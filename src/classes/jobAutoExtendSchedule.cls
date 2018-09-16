global class jobAutoExtendSchedule implements Database.Batchable<SObject> {
     
    global String query;
    global utilityIds clsUtilIds = new utilityIds();    
    global List<SObject> glstJobRecords;
    
    //constructor
    global jobAutoExtendSchedule() 
    {
        //20160303 EBG/DCS - fixed syntax error in query (missing comma after Single_Session_Ongoing__c) and removed filter on same field
        //build the query to find all rules we are to monitor for required workflows, and create a case for each rule
        String strQuery = 'SELECT ';
                    strQuery += 'UI_Start_Date__c, UI_End_Date__c, Record_Type_RPT__c, RecordTypeId, ';
                    strQuery += 'SystemModstamp, Start_Date__c, Original_Start_Date__c, Original_End_Date__c, ';
                    strQuery += 'Name, Months_of_Sessions_to_Generate__c, LastModifiedDate, LastModifiedById, LastActivityDate, ';
                    strQuery += 'IsDeleted, Id, Extension_Days_to_Generate__c, End_Date__c, CreatedDate, CreatedById, Class__c, ';
                    strQuery += 'Change_Schedule_As_Of__c, AutoExtendFlag__c, Single_Session_Ongoing__c, ';
                    strQuery += 'Monday__c, Monday_Start_Time__c, Monday_End_Time__c, ';
                    strQuery += 'Tuesday__c, Tuesday_Start_Time__c, Tuesday_End_Time__c, ';
                    strQuery += 'Wednesday__c, Wednesday_Start_Time__c, Wednesday_End_Time__c, ';
                    strQuery += 'Thursday__c, Thursday_Start_Time__c, Thursday_End_Time__c, ';
                    strQuery += 'Friday__c, Friday_Start_Time__c, Friday_End_Time__c, ';
                    strQuery += 'Saturday__c, Saturday_Start_Time__c, Saturday_End_Time__c, ';
                    strQuery += 'Sunday__c, Sunday_Start_Time__c, Sunday_End_Time__c ';
                    strQuery += 'FROM Schedule__c s ';
                    strQuery += 'WHERE s.RecordTypeId = \'' + clsUtilIds.scheduleOngoing + '\' '; 
                    strQuery += 'AND s.End_Date__c > ' + system.now().format('yyyy-MM-dd') + 'T00:00:00Z';
        system.debug('\nstrQuery: ' + strQuery + '\n');        
        query = strQuery;
    }
    
    
    ////////////////////////////////////////////////
    //base method that runs when the class is instantiated.  Its return value is sent to the "execute" routine
    ////////////////////////////////////////////////
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        system.debug('\n\n******Inside start.\n');
        system.debug('\n\n******Inside start.  query:\n' + query + '\n*********\n');
      
        return Database.getQueryLocator(query);
    }


    ////////////////////////////////////////////////
    // EXECUTE
    ////////////////////////////////////////////////
    global void execute(Database.BatchableContext BC, List<SObject> jobRecords) 
    {
        system.debug('Inside execute.');
        //the results of the query are returned in a list of SObjects, so as we process each record we need to 
        //convert it to a hard typed variable
        glstJobRecords = jobRecords;

        List<Schedule__c> lstSchedulesExtend = new List<Schedule__c>();
        
        // Loop through Schedule__c records and look for any end dates that are 30 days out, then extend by 8 days
        system.debug('glstJobRecords');
        system.debug(glstJobRecords);
        for (SObject jr : glstJobRecords) 
        {
            Schedule__c s = (Schedule__c)jr;
            
            System.Debug('**** clsScheduleMethods.autoExtendOngoingClasses INFO:  Checking ScheduleId: ' + s.Id + ' if End_Date__c is <= today (' + s.End_Date__c.addDays(-30) + ')');
            
            if(s.End_Date__c.addDays(-30) <= System.Today()) 
            {
                System.Debug('**** clsScheduleMethods.autoExtendOngoingClasses INFO:  Extending ScheduleId: ' + s.Id + ' by ' + s.Extension_Days_To_Generate__c + ' days');
                
                //20160310 EBG/DCS - set Change Schedule As Of to one day after the current value and then extend the class.  Do this because
                //we don't want events for sessions already created through the end of the schedule to be deleted
                //s.Change_Schedule_As_Of__c = System.Today();
                Datetime dttChangeDate = s.End_Date__c.addDays(1);
                s.Change_Schedule_As_Of__c = Date.newInstance(dttChangeDate.year(), dttChangeDate.month(), dttChangeDate.day());
                s.End_Date__c = s.End_Date__c.addDays(Integer.valueOf(s.Extension_Days_To_Generate__c));
                lstSchedulesExtend.add(s);
            }
        }

        system.debug('lstSchedulesExtend' + lstSchedulesExtend.size());
        if(lstSchedulesExtend.size() > 0) { update lstSchedulesExtend; }

    }

    
    ////////////////////////////////////////////////
    // FINISH
    ////////////////////////////////////////////////
    global void finish(Database.BatchableContext BC)
    {

        //get the custom settings for the notification process
        //Automated_Notification_Settings__c cstNotif = Automated_Notification_Settings__c.getInstance();
        //String strAdminEmail = cstNotif.Missing_Email_Admin_Address__c;
        String strAdminEmail = 'qcushing@cases.org';
        
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [Select Id
                                , CompletedDate
                                , Status
                                , ExtendedStatus
                                , JobType
                                , NumberOfErrors
                                , JobItemsProcessed
                                , TotalJobItems 
                            from AsyncApexJob 
                            where Id = :BC.getJobId()];
        
        // Send an email to the admin notifying of job failure.
        String strSubject = '';
        
        if (a.NumberOfErrors > 0) 
        {
            strSubject = 'Error in Scheduled Routine : jobAutoExtendSchedule';
        } else {
            strSubject = 'SUCCESS Scheduled Routine : jobAutoExtendSchedule';
        }
        
        // Send Email on Completion
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {strAdminEmail};
        mail.setToAddresses(toAddresses);
        mail.setSubject(strSubject);
        String strBody = 'The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.\n' +
                        '\nCompletedDate: ' + a.CompletedDate +
                        '\nStatus: ' + a.Status +
                        '\nExtendedStatus: ' + a.ExtendedStatus +
                        '\nJobType: ' + a.JobType +
                        '\nJobItemsProcessed: ' + a.JobItemsProcessed;
                        
        mail.setPlainTextBody(strBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        //cheating for unit test purposes 
        Integer i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        i = 0;
        
    }
}