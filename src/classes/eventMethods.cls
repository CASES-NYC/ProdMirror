public class eventMethods 
{
    
    public utilityMethods util = new utilityMethods();
    //public utilityIds utilId = new utilityIds();
    public List<Event> newEvents = new List<Event>();
    public Map<Id, Event> mapOldEvents = new Map<Id, Event>();
    public boolean bolInsert = null;
    public Set<Id> getWhoIds = new Set<Id>();
    public Set<Id> getWhatIds = new Set<Id>();
    public Map<Id, Contact> mapClients = new map<Id, Contact>();
    public Map<Id,User> mapAllUsers = new  Map<Id,User>();    
    public Set<Id> allOwnerIDs = new Set<Id>();
    public set<Task> setTasksForInsert = new set<Task>();
    public set<Task> setTasksToUpdate = new set<Task>();
    public set<Id> setContactIdsToUpdate = new set<Id>();
    public set<Contact> setContactsToUpdate = new set<Contact>();
    public Id APTAppointment = Utility_ID__c.getValues('APT Appointment').RecordType_Id__c; 
    public Id APTProgressNote = Utility_ID__c.getValues ('Progress Note (APT)').RecordType_ID__c;
    public Id ccm_client = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CCM Client').getRecordTypeId();
    public Id ceo_client = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CEO Client').getRecordTypeId();    
    public Id one_client = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('ONE Client').getRecordTypeId();    
    public Id dtc_client = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('DTC Client').getRecordTypeId();  

   // always reset Skip Restrictions back to false at the end of the before trigger
   // 3/26/13 MB renamed from skipRestrictions, which is confusing    
    public void resetSkipRestrictions() {
        
        for(Event thisEvent:newEvents) { 
        
            thisEvent.SkipRestrictions__c = false;
        }       
    }
    
    
    public List<Event> getNewEvents(List<Event> newItmems)
    {
        return newEvents;
    }

    // Set the P/C ID field
    // Set time in and out, added 11/11/13 MB for prod.a.BT-1286, combined with the P/C ID loop
    public void setBeforeFields() 
    {    
        Integer intHour = 0;
        Integer intHourstoAdd = 0;
        Integer intMinute = 0;
              
        for(Event thisEvent:newEvents) 
        { 
            system.debug(thisEvent.activityDate);
            system.debug(thisEvent.Verification_Status__c);
            system.debug(thisEvent.Time_In__c);
            system.debug(thisEvent.Time_Out__c);
            system.debug(bolInsert);
            
            if (!mapClients.isEmpty())
                thisEvent.P_C_Id__c = mapClients.get(thisEvent.whoId).P_C_Id__c; 
            thisEvent.tDate__c = thisEvent.ActivityDateTime;           
            
            if(thisEvent.Verification_Status__c != 'Attended' 
            && thisEvent.Verification_Status__c != 'Late'
            && thisEvent.Verification_Status__c != 'Tardy') 
            {
                if((test.isRunningTest()) && thisEvent.Verification_Status__c == 'Not Verified') 
                {
                    //allow marking time in only (w/o status change) from Sign In Page only
                } else {            
                    thisEvent.Time_In__c = '';
                    thisEvent.Time_Out__c = '';
                }
            } else {
                
                if((thisEvent.Time_In__c == '' || thisEvent.Time_In__c == null) 
                && (thisEvent.Time_Out__c == '' || thisEvent.Time_Out__c == null)) 
                {
                    
                    thisEvent.Time_In__c = thisEvent.ActivityDateTime.format('hh:mm a');
                    thisEvent.Time_Out__c = thisEvent.ActivityDateTime.addMinutes(thisEvent.durationInMinutes).format('hh:mm a');               
                } 
                
                //12/4/13 as per SPA's request, users cannot add Time In and leave Time In blank
                // Therefore, Time Out would only ever be calculated from the activitydatetime
                // (if both fields are blank). Validation rule will be tripped if Time Out is not set here
            }
        }
    }        

    
    // 11/11/13 MB modified this method so that it generates a map of contacts which is used in
    // many of the methods. Also added this to the before logic in trigger        
    public void getWhoIds() {
        
        for(Event thisEvent:newEvents) {
            
            if(thisEvent.whoId != null) {
            
                getWhoIds.add(thisEvent.whoId); 
                getWhatIds.add(thisEvent.whatId);   
            }
        }
        
        mapClients = new map<Id, Contact>(
            [select id, P_C_Id__c, Client_Status__c, RecordtypeId, Current_Exit_Date__c, 
            Case_Coordinator__c, Team_leader__c, Intake_Case__c, Mandatory_Class_Count_RPT__c, 
            Compliance_Date_Formula__c, PRP_Status__c, Next_Court_Date__c,
            (select id from Program_Plans__r where Most_Recent_Program_Plan__c = true),
            (select id, ActivityDate, Verification_Status__c, RecordTypeId, whatId
                from Events where 
                //Choices compliance
                (subject in ('Curfew', 'Program Reporting') 
                and Verification_Status__c in ('Attended', 'Excused', 'Unexcused')
                and ActivityDate <= :system.today()
                and ActivityDate >= :system.today().addDays(-20))
                //court dates
                or (RecordTypeId = :Utility_ID__c.getValues('Court Date').RecordType_Id__c
                and Outcome__c != 'Entered in Error')
                order by ActivityDate desc) 
            from Contact where id in :getWhoIDs]);
    }
    
        
    public void processSubjects() {

        // Subject validation     
        Set<String> accceptableSubjects = new Set<String>();
        
        for(Event thisEvent:newEvents) {
            
            // 20110527 - ebg:  According to Apex documentation, recurring tasks are not handled in bulk.  As a result,
            // we need to reset our utility class with each event we process so we can get the list
            // of acceptable subjects for the given record type

            
            this.util = new utilityMethods();  
            if(this.util.acceptableEventSubjects.containsKey(thisEvent.recordTypeId)) {
                
                System.debug('\n\nHERE123 for recordTypeId ' + thisEvent.recordTypeId);
                
                accceptableSubjects.clear(); 
                accceptableSubjects = this.util.acceptableEventSubjects.get(thisEvent.recordTypeId);
                
                System.debug('HERE123: ' + accceptableSubjects);
                System.debug('HERE123: Event Subject: ' + thisEvent.Subject + '  IsRecurring: ' + thisEvent.IsRecurrence + '  Date: ' + thisEvent.ActivityDate + '\n\n');
                if(!accceptableSubjects.contains(thisEvent.Subject)) {
                    
                    ///////////////////////////////////////////////////////
                    // The subject the entered is not on the list so we 
                    // need to throw an error to stop the save
                    ///////////////////////////////////////////////////////
                    System.debug('HERE123: Subject not in list: ' + accceptableSubjects);
                    System.debug('HERE123: Event Subject: ' + thisEvent.Subject + '  IsRecurring: ' + thisEvent.IsRecurrence + '\n\n');
                    
                    thisEvent.Subject.addError('Please choose one of the predefined subjects to save this event.');
                    
                }
            }
        }
    }

    ///////////////////////////////////////////////////////
    // Set Verification Due Date (moved from processEventVerification by MB  4/10/13)
    ///////////////////////////////////////////////////////
    
    public void setVerificationDueDate() 
    {  
        for(Event thisEvent: newEvents) 
        {
            if( thisEvent.RecordTypeId == Utility_ID__c.getValues('Orientation Appointment').RecordType_Id__c ||
                thisEvent.RecordTypeId == Utility_ID__c.getValues('Court Date').RecordType_Id__c) 
            {
                system.debug('***Setting verification due date: ' + thisEvent);
                
                //20110718 ebg: Because recurring events are not handled in bulk like single events, we need to look at the RecurrenceStartDateTime field
                //rather than the Activity Date field
                if (thisEvent.RecurrenceStartDateTime != null) 
                {
                    thisEvent.ActivityDate = thisEvent.RecurrenceStartDateTime.Date();  
                }   
                
                Date verificationDueDate = thisEvent.ActivityDate.addDays(1);
                verificationDueDate = util.getNextWorkingDayFromDate(verificationDueDate);
                thisEvent.Verification_Due_Date__c = verificationDueDate;
            
            } else {
                
                system.debug('***Before check for recurrence: ' + thisEvent);
                //20110718 ebg: Because recurring events are not handled in bulk like single events, 
                //we need to look at the RecurrenceStartDateTime field rather than the Activity Date field
                if (thisEvent.RecurrenceStartDateTime != null) {
                    thisEvent.ActivityDate = thisEvent.RecurrenceStartDateTime.Date();  
                }
                
                Date verificationDueDate = thisEvent.ActivityDate.addDays(7);               
                verificationDueDate = verificationDueDate.toStartOfWeek();              
                verificationDueDate = verificationDueDate.addDays(2);
                
                //chose not to go to next working day.  If holiday falls on a Tuesday, users will handle accordingly
                thisEvent.Verification_Due_Date__c = verificationDueDate;
                
                System.Debug('\n\n ********* Event Due Date is ' + thisEvent.ActivityDate);
                System.Debug('\n\n ********* Setting Event Verification Due Date to ' + verificationDueDate);
            }
        }
    }               
    
        
    public void processEventVerification() 
    {
        
        // 1/4/13 MB: added so we can set the closing date of career ex referral tasks to the activity date of the interview
        Map<Id, Date> mapCarExInterviewDates = new Map<Id, Date>();
        
        // Fill Bulk Lists
        List<Id> lstSessionIds = new List<Id>();
/*        
        for(Event e : newEvents) 
        {    
            lstSessionIds.add(e.WhatId);

            if(e.recordtypeid == Utility_ID__c.getValues('Career Exploration').RecordType_Id__c 
            && (!mapCarExInterviewDates.containsKey(e.whoId) || mapCarExInterviewDates.get(e.whoId)< e.activitydate)) 
                {mapCarExInterviewDates.put(e.whoId, e.activitydate);}
        }
*/      
        // Create List of Tasks to check
        List<Task> lstTasksToCheck = [SELECT WhoId, Status, Closed_By__c, ActivityDate, RecordTypeId, 
            IsClosed, Program_Cycle__c 
            FROM Task WHERE WhoId IN :getWhoIds AND IsClosed = false 
            AND RecordTypeId in ( :Utility_ID__c.getValues('Mandatory Classes Task').RecordType_Id__c)];
        // :Utility_ID__c.getValues('Career Exploration Referral Task').RecordType_Id__c,
        // Mandatory Classes - create list of sessions in scope            

        Map<Id, Session__c> mapMandSessions = new Map<Id, Session__c>([SELECT Id FROM Session__c 
            WHERE Course_Category__c = 'Mandatory Class' and Id in :lstSessionIDs]);
        
        for(Event thisEvent:newEvents) {
        
            //8/20/13 MB: prevent verifying events for inactive START clients 
            //(we want to force users to enroll in voluntary and otherwise utilize the Search Portal)
            
            if(!thisEvent.SkipRestrictions__c && UserInfo.getProfileId() != Utility_ID__c.getValues('System Administrator').RecordType_Id__c) 
            {
                
                if( mapClients.get(thisEvent.whoId).Client_Status__c != 'Active'
                
                && (mapClients.get(thisEvent.whoId).Client_Status__c == 'Never Enrolled' ||
                
                (thisEvent.ActivityDate > mapClients.get(thisEvent.whoId).Compliance_Date_Formula__c
                && mapClients.get(thisEvent.whoId).PRP_Status__c == 'Unsuccessful Exit')
                
                || (thisEvent.ActivityDate > mapClients.get(thisEvent.whoId).Current_Exit_Date__c
                && mapClients.get(thisEvent.whoId).PRP_Status__c == 'Successful Exit'))
                
                && (thisEvent.Type__c != 'Collateral' && thisEvent.Type__c != 'Call'
                // added 6/3/14 by MB for DB Helpdesk: 1613
                && thisEvent.RecordTypeId != Utility_ID__c.getValues('Course Catalog Class').RecordType_Id__c)  
                              
                && (thisEvent.Verification_Status__c == 'Late' 
                || thisEvent.Verification_Status__c == 'Attended')
                
                && (bolInsert ||
                (mapOldEvents.get(thisEvent.Id).Verification_Status__c != 'Attended' 
                && mapOldEvents.get(thisEvent.Id).Verification_Status__c != 'Late')) 
                
                && (mapClients.get(thisEvent.whoID).RecordTypeId == Utility_ID__c.getValues('DTC Client').RecordType_Id__c 
                || mapClients.get(thisEvent.whoID).RecordTypeId == Utility_ID__c.getValues('CCM Client').RecordType_Id__c)) {
                    
                    thisEvent.addError('You cannot verify appointments for a client who is not active. Either intake them '
                    + 'on a mandate or enroll them in voluntary services via the Search Portal.');
                }
            }
        
            ////////////////////////////////////////////////
            // Preventing court date appointment
            // from being final displostion/adjourned if court
            // date is in the future
            ////////////////////////////////////////////////
            
            if(thisEvent.RecordTypeId == Utility_ID__c.getValues('Court Date').RecordType_Id__c) {
                if((thisEvent.Outcome__c == 'Final Disposition' || thisEvent.Outcome__c == 'Adjourned') & thisEvent.ActivityDate > System.Today()) { 
                    thisEvent.addError('The outcome cannot be Final Disposition or Adjourned id the court date is in the future.');
                }
            }
            
            ////////////////////////////////////////////////
            // Preventing profiles from
            // making or verifying orientation
            // appointments
            ////////////////////////////////////////////////

            ////////////////////////////////////////////////////
            // Event verification date time set
            // a week is Mon-Sun
            // 
            // Need to set verification due date to the 
            // tuesday of the week following
            // when the event is due
            ////////////////////////////////////////////////////
        

/*            
            // Career Ex Appointment / Task
            System.Debug('eventMethods.processEventVerification INFO:  Checking for Career Exploration Appointment');
            if(thisEvent.RecordTypeId == Utility_ID__c.getValues('Career Exploration').RecordType_Id__c) 
            {
                
                System.Debug('eventMethods.processEventVerification INFO:  FOUND Career Exploration Appointment');
                
                // Close the associated Career Ex Task when the Appointment is Verified
                for(Task t : lstTasksToCheck) 
                {
                    
                    System.Debug('eventMethods.processEventVerification INFO:  Checking for Career Exploration Referral Task - ' + t.Id + ' - ' + thisEvent.RecordTypeId + ' == ' + Utility_ID__c.getValues('Career Exploration Referral Task').RecordType_Id__c);
                    
                    if(thisEvent.WhoId == t.WhoId 
                    && t.RecordTypeId == Utility_ID__c.getValues('Career Exploration Referral Task').RecordType_Id__c) {
                        
                        if((thisEvent.Verification_Status__c == 'Attended' 
                        || thisEvent.Verification_Status__c == 'Late')) {
                        
                            if(System.Today() <= t.ActivityDate) {
                                t.Status = 'DONE ON TIME';
                                t.Status__c = 'DONE ON TIME';
                            } else {
                                t.Status = 'DONE LATE';
                                t.Status__c = 'DONE LATE';

                            }
                        
                            t.closing_date__c = mapCarExInterviewDates.get(t.whoId);
                            t.closed_by_system__c = true;
                            t.SkipRestrictions__c = true;
                            setTasksToUpdate.add(t);
                        }
                    
                        
                        // 10/21/13 MB: adding code to assign program cycle from task to interview.
                        // This is currently done via the URL in the To Do Portal link for the task,
                        // but that requires the page layout to leave the cycle field editable,
                        // and allows interview to be created w/o a referral. 
                        // This code assigns a cycle from the relevant task, and if none exists, throws
                        // an error asking the user to create a referral first
                            
                        thisEvent.Program_Cycle__c = t.Program_Cycle__c;                   
                    }
                }
                
                if(thisEvent.Program_Cycle__c == null) {
                    
                    thisEvent.addError('You cannot create a Career Ex Interview without first '
                    +'making a referral for the client via the course catalog.');
                }
                
            }
*/          
            // Mandatory Classes
            if(thisEvent.RecordTypeId == Utility_ID__c.getValues('Course Catalog Class').RecordType_Id__c && 
                mapMandSessions.containsKey(thisEvent.whatID) &&
                
                (thisEvent.Verification_Status__c == 'Attended' 
                || thisEvent.Verification_Status__c == 'Late' 
                || thisEvent.Verification_Status__c == 'Tardy') &&
                
                (bolInsert ||
                (mapOldEvents.get(thisEvent.Id).Verification_Status__c != 'Attended' 
                && mapOldEvents.get(thisEvent.Id).Verification_Status__c != 'Late' 
                && mapOldEvents.get(thisEvent.Id).Verification_Status__c != 'Tardy'))) {
                    

                // 6/17/13 MB: Added the containsKey check to avoid null reference errors when
                // a course catalog class event is being created with an "attended" verification status.
                // This can now occur because the course catalog allows the single-step creation
                // and verification of single sesssion classes.                 


                // Close the associated Mandatory Classes Task when the Appointment is Verified
                for(Task t : lstTasksToCheck) {
                    
                    if(thisEvent.WhoId == t.WhoId && t.RecordTypeId == Utility_ID__c.getValues('Mandatory Classes Task').RecordType_Id__c) {
                        
                        mapClients.get(t.whoID).Mandatory_Class_Count_RPT__c += 1;  
                        setContactIdsToUpdate.add(t.whoID);                       
                                
                        // Check to see if we're at the count to close this task
                        if(mapClients.get(thisEvent.whoID).Mandatory_Class_Count_RPT__c == 4) {
                            
                            t.Closing_Date__c = thisEvent.StartDateTime.Date();
                            
                            if(t.Closing_Date__c <= t.ActivityDate) {
                                t.Status = 'DONE ON TIME';
                                t.Status__c = 'DONE ON TIME';
                            } else {
                                t.Status = 'DONE LATE';
                                t.Status__c = 'DONE LATE';  
                            }
                            
                            t.SkipRestrictions__c = true;
                            setTasksToUpdate.add(t);                                        
                        }
                    }
                }
            }
        
            // Handle Verification Date, Verified By, and Status
            if(thisEvent.Verification_status__c != 'Not Verified' 
            
            // 11/29/12 MB: added check for update=yes and changed verification status, to prevent changes to verified_by
            // when LastClassRpt__c is updated on course grading page open (BT-cls.a.307)
                && (bolInsert ||
                mapOldEvents.get(thisEvent.Id).Verification_Status__c != thisEvent.Verification_status__c)) {
                
                thisEvent.Verification_Date__c = System.Today();
                thisEvent.Verified_By__c = UserInfo.getName();
                
                
                /// Status Logic
                if(thisEvent.Verification_status__c == 'Cancelled') {
                
                    thisEvent.Status__c = 'CANCELLED';  
            
                } else {
                    //BT-284 - ebg - changed comparison dates
                    //if(System.Today() >= thisEvent.EndDateTime) 
                    if(thisEvent.Verification_Date__c > thisEvent.Verification_Due_Date__c) {
                        
                        thisEvent.Status__c = 'DONE LATE';  
                        
                    }   else {
                        
                        thisEvent.Status__c = 'DONE ON TIME';   
                    }   
                    
                }
            } 
        }

    }
    
    
    public void editNoteTask() {
    
        list<Event> lstChangedCourtDates = new list<Event>();
        list<Id> lstChangedCourtDateIds = new list<Id>();
        list<Task> lstChangedNoteTasks = new list<Task>();
        
        list<Event> lstCourtNewReport = new list<Event>();
        list<Id> lstCourtNewReportIds = new list<Id>();
        list<Task> lstNewNoteTasks = new list<Task>();
        
        list<Event> lstCourtNoReport = new list<Event>();
        list<Id> lstCourtNoReportIds = new list<Id>();          
        
        for(Event e: newEvents)  
        {
        
            if(e.RecordTypeId == Utility_ID__c.getValues('Court Date').RecordType_Id__c) { 
                            
                if(e.Court_Report_Required__c == true && e.Report_Type__c != 'Oral'
                && (mapOldEvents.get(e.id).Court_Report_Required__c != true 
                || mapOldEvents.get(e.id).Report_Type__c == 'Oral')) {
                    
                    lstCourtNewReport.add(e);
                    lstCourtNewReportIds.add(e.id);
                }
                
                else if(e.ActivityDate != mapOldEvents.get(e.id).ActivityDate 
                && e.Court_Report_Required__c == true && e.Report_Type__c != 'Oral') {
                    
                    lstChangedCourtDates.add(e);
                    lstChangedCourtDateIds.add(e.id);
                    // will add code to create new note tasks eventually
                }               
                
                else if(e.Court_Report_Required__c == false || e.Report_Type__c == 'Oral'
                && (mapOldEvents.get(e.id).Court_Report_Required__c == true 
                && mapOldEvents.get(e.id).Report_Type__c != 'Oral')) {
                    
                    lstCourtNoReport.add(e);
                    lstCourtNoReportIds.add(e.id);
                }
                            
            }
        }
        
        lstChangedNoteTasks = [select id, activitydate, open_date__c,
                        recordtypeid, task_source__c, status, SkipRestrictions__c
                        from Task 
                        where (task_source__c in :lstChangedCourtDateIds or task_source__c in :lstCourtNoReportIds)
                        and status = 'Not Started'
                        and (recordtypeid = :Utility_ID__c.getValues('CC CRS Note Task').RecordType_Id__c or recordtypeid = :Utility_ID__c.getValues('PS CRS Note Task').RecordType_Id__c)];
                                    
                        
        for(task t: lstChangedNoteTasks){
            
            for(event e: lstChangedCourtDates) {
                
                if(e.id == t.Task_source__c ) {
                    
                    if(t.RecordTypeId == Utility_ID__c.getValues('CC CRS Note Task').RecordType_Id__c ) {  
                          
                        t.ActivityDate = e.ActivityDate.addDays(-6);
                        t.Open_Date__c = e.ActivityDate.addDays(-8);
                    }
                    else {
                        
                        t.ActivityDate = e.ActivityDate.addDays(-8);
                        t.Open_Date__c = system.today();
                    }   
                                        
                    t.SkipRestrictions__c = true;
                    continue;
                }
            }
            
            for(event e: lstCourtNoReport) {
                
                if(e.id == t.Task_source__c ) {
                    
                    t.Status = 'Rejected';
                    t.Reject_Reason__c = 'Court date ' + e.id + ' was updated. It no longer requires a progress report';
                    t.Closing_Date__c = system.today();
                    t.Closed_By_System__c = true;
                    t.SkipRestrictions__c = true;
                }               
            }
        }   
        
        setTasksToUpdate.addAll(lstChangedNoteTasks);                           
    }        
    
  
    public void checkForIntakes() {
    
        Set<Id> contactsThatHaveAdministrativeActions = new Set<Id>();
        
        // Get list of administrative actions 
        // associated with this client
        
        List<Administrative_Actions__c> effectedContacts = [Select Client__c, RecordTypeId 
            From Administrative_Actions__c Where Client__c in :getWhoIds 
            and recordTypeId in (:Utility_ID__c.getValues('Re-Intake').RecordType_Id__c, :Utility_ID__c.getValues('Re-Intake - Locked').RecordType_Id__c)];
        
        for(Administrative_Actions__c thisAA: effectedContacts) {
            
            // If they are in this list then it means they have
            // a prior reintake adminstrative action
            
            contactsThatHaveAdministrativeActions.add(thisAA.Client__c);
        
        }
        
        
        List<Id> contactIdsToIntake = new List<Id>();
        List<Id> contactIdsToReIntake = new List<Id>();
        
        // Loop through all the events to see if orientation appointment
          
        for(Event thisEvent:newEvents) {
            
            if(thisEvent.whoId != null && thisEvent.recordTypeId == Utility_ID__c.getValues('Orientation Appointment').RecordType_Id__c) {

                // Page 17 #2 Appointment Requirements
                
                // 11/19/12 MB Replaced this rule to allow case coordinators to close extra orientation appointments              
                if(mapClients.get(thisEvent.whoId).Client_status__c == 'Active') {
                    
                    if(bolInsert) {
                        
                        if(thisEvent.Verification_Status__c == 'Unexcused' || thisEvent.Verification_Status__c == 'Excused' || thisEvent.Verification_Status__c == 'Cancelled') {
                            
                        }
                            
                        else {  
                            
                            thisEvent.addError('You cannot save an orientation appointment with this status if the client is already Active.');                         
                        }                       
                    }
                    
                    else if (thisEvent.SkipRestrictions__c && 
                    mapOldEvents.get(thisEvent.id).Verification_Status__c == thisEvent.Verification_Status__c) {
                        
                    }
                    
                    else if ((mapOldEvents.get(thisEvent.id).Verification_Status__c == 'Not Verified' 
                    || mapOldEvents.get(thisEvent.id).Verification_Status__c == 'Excused' 
                    || mapOldEvents.get(thisEvent.id).Verification_Status__c == 'Unexcused' 
                    || mapOldEvents.get(thisEvent.id).Verification_Status__c == 'Cancelled')
                    
                    && (thisEvent.Verification_Status__c == 'Cancelled' 
                    || thisEvent.Verification_Status__c == 'Excused' 
                    || thisEvent.Verification_Status__c == 'Unexcused')) {
                        
                    }
                    
                    else {
                        
                        thisEvent.addError('You cannot save an orientation appointment with this status if the client is already Active.');
                        
                    }
                    
                }           
        
                /////////////////////////////////////
                // EOF
                /////////////////////////////////////
            
                if((bolInsert && (thisEvent.Verification_Status__c == 'Attended' 
                    || thisEvent.Verification_Status__c == 'Late'))
                    
                    || ((thisEvent.Verification_Status__c == 'Attended'
                    || thisEvent.Verification_Status__c == 'Late')
                    && (mapOldEvents.get(thisEvent.id).Verification_Status__c != 'Attended' 
                    && mapOldEvents.get(thisEvent.id).Verification_Status__c != 'Late'))) 
                {
                    
                    //if(mapClients.get(thisEvent.whoId).Team_Leader__c != null) 
                    //{
                            
                        if(mapClients.get(thisEvent.whoId).Client_status__c == 'Intaked - Not Yet Active' ) 
                        {
                                                           
                            if(contactsThatHaveAdministrativeActions.contains(thisEvent.whoId)) {
                                
                                ////////////////////////
                                //reintake
                                ////////////////////
                                
                                System.Debug('eventMethods.checkForIntakes INFO:  REINTAKE');
                                contactIdsToReIntake.add(thisEvent.whoId);
                            
                            } else {
                                
                                //////////////////////////
                                // Intake
                                ////////////////////////
                                
                                System.Debug('eventMethods.checkForIntakes INFO:  INTAKE');
                                contactIdsToIntake.add(thisEvent.whoId);
                            }
                            
                        } else {
                            
                            
                            thisEvent.addError('You cannot intake this client. Their status must be Intaked - Not Yet Active');
                        }
                    //}
                    // else {
                    //    thisEvent.addError('Client must have Team Leader');
                    //}
                
                }
            }
        }
    
        // Create the intakes
        
        List<Program_Plan__c> lstPPstoCreate = new list<Program_Plan__c>();
        Program_Plan__c newPP = new Program_Plan__c();
        
        if(contactIdsToIntake.size() > 0) {
            utilityMethods.createIntakeForCEP(contactIdsToIntake, System.Today(), false);
            
            for(Id contactId: contactIdsToIntake) {
                
                if(mapClients.get(contactId).Program_Plans__r.size() == 0) {
                
                    newPP = new Program_Plan__c();
                    newPP.Client_Name__c = contactId;
                    lstPPsToCreate.add(newPP);
                }               
            }
        
        }
        if(contactIdsToReIntake.size() > 0) {
            utilityMethods.createIntakeForCEP(contactIdsToReIntake, System.Today(), true);
            
            for(Id contactId: contactIdsToReIntake) {
                
                newPP = new Program_Plan__c();
                newPP.Client_Name__c = contactId;
                lstPPsToCreate.add(newPP);
            }                 
        }
        
        insert lstPPsToCreate;        
        
    }   
    
    
    /////////////////////////////////
    // Verification Status change
    /////////////////////////////////
    public void checkVerificationStatusChange() {
        // Loop through new events and apply change logic
        for(Event e : this.newEvents) {
   
            // Check Verification Status - this always has a value
            if (e.Verification_Status__c != mapOldEvents.get(e.Id).Verification_Status__c) {
                //BT-283 - ebg - use current date/time rather than last modified date
                //String strHistory = 'Changed from ' + mapOldEvents.get(e.Id).Verification_Status__c + ' to ' + e.Verification_Status__c  + ' on ' + e.LastModifiedDate.format() + ' by ' + UserInfo.getName() + '\n' + util.nullToBlank(e.Verification_Status_History__c).trim();
                String strHistory = 'Changed from ' + mapOldEvents.get(e.Id).Verification_Status__c + ' to ' + e.Verification_Status__c  + ' on ' + datetime.now().format() + ' by ' + UserInfo.getName() + '\n' + util.nullToBlank(e.Verification_Status_History__c).trim();
                
                Integer intHistoryNoteLength = strHistory.length();
                if (intHistoryNoteLength >= 255) { intHistoryNoteLength = 254; }
                intHistoryNoteLength = intHistoryNoteLength - 1; // Account for zero-based vs. one-based
                
                // Update Status History field
                e.Verification_Status_History__c = strHistory.substring(0, intHistoryNoteLength);               
            }
            
            // Check for StartDateTime (not always populated on BeforeInsert)
            if(mapOldEvents.get(e.Id).StartDateTime != null) {
                if (e.StartDateTime.date() != mapOldEvents.get(e.Id).StartDateTime.date()) {
                    //BT-283 - ebg - use current date/time rather than last modified date
                    //String strHistory = 'Changed from ' + mapOldEvents.get(e.Id).StartDateTime.format() + ' to ' + e.StartDateTime.format()  + ' on ' + e.LastModifiedDate.format() + ' by ' + UserInfo.getName() + '\n' + util.nullToBlank(e.Activity_Date_History__c).trim();
                    String strHistory = 'Changed from ' + mapOldEvents.get(e.Id).StartDateTime.format() + ' to ' + e.StartDateTime.format()  + ' on ' + datetime.now().format() + ' by ' + UserInfo.getName() + '\n' + util.nullToBlank(e.Activity_Date_History__c).trim();
                    
                    Integer intHistoryNoteLength = strHistory.length();
                    if (intHistoryNoteLength >= 255) { intHistoryNoteLength = 254; }
                    intHistoryNoteLength = intHistoryNoteLength - 1; // Account for zero-based vs. one-based
                
                    // Update Date History field
                    //e.Verification_Status_History__c = strHistory.substring(0, intHistoryNoteLength);
                    e.Activity_Date_History__c = strHistory.substring(0, intHistoryNoteLength);
                }
            }
                
        }
    }
    
    //added 6/10/13 by MB
    public void setMandatorySessionsCounter() {
        
        list<Id> lstContactIds = new list<Id>();
        list<Program_Cycle__c> lstCycles = new list<Program_Cycle__c>();
        list<Event> lstAllEvents = new list<Event>();
        integer intSessions = 0;
        integer intUnverifiedSessions = 0;
        Event evtLatest = null;
        
        //query contacts and related events
        lstCycles = [select id, Cycle_Type__c, Mandatory_Sessions_Completed__c, Mandatory_Sessions_Required__c,
        Next_Class_Date__c, TRP_Class_Status__c, Start_Date__c, End_Date__c, Client__c, Compliance_Date__c, Closing_Date__c,
        Last_Mandated_Session_Admin__c, Client__r.RecordTypeId, Client__r.Client_Status__c
        from Program_Cycle__c where Client__c in :getWhoIds and Locked_admin__c = false];
        
        lstAllEvents = [select id, whoId, Verification_Status__c, ActivityDate, Class_Category__c,
        ActivityDateTime, Subject, Apply_to_Mandate_Override__c 
        from Event where whoId in :getWhoIDs
        and ((Class_Category__c = 'TRP One Day Session' and Verification_Status__c != 'Withdrawn')
        or subject = 'Program Reporting'
        or (((RecordTypeId = :Utility_ID__c.getValues('Case Coordination (CCM)').RecordType_Id__c and Type__c = 'Face to Face' ) 
        or RecordTypeId = :Utility_ID__c.getValues('Course Catalog Class').RecordType_Id__c)
            and ((DurationInMinutes >= 45
                and Location__c != 'Jail' and Apply_to_Mandate_Override__c != 'No') 
            or Apply_to_Mandate_Override__c = 'Yes'))) 
        order by ActivityDate asc];
        
        for(Program_Cycle__c pc: lstCycles) {
            
            //reset counter
            intSessions = 0;
            intUnverifiedSessions = 0;
            evtLatest = null;
            
            //loop through all attended events
            for(Event e: lstAllEvents) {
                
                //make sure the client matches, and that the event occurs during the current program cycle
                if(pc.Client__c == e.whoId && e.ActivityDate >= pc.Start_Date__c
                && (pc.Compliance_Date__c == null || e.ActivityDate <= pc.Compliance_Date__c)) {
                
                    //for DTC and CCM clients, just increment the counter for all attended program reporting sessions
                    if(pc.Client__r.RecordTypeId == dtc_client || pc.Client__r.RecordTypeId == ccm_client 
                        || pc.Client__r.RecordTypeId == one_client || pc.Client__r.RecordTypeId == ceo_client)
                    {
                        
                        if(e.verification_status__c == 'Attended' 
                        || e.Verification_Status__c == 'Late')  {
        
                            if(intSessions < pc.Mandatory_Sessions_Required__c
                            //added 10/31/13 by MB so that only one session per day is counted, as per prod.a.BT-1268
                            && (evtLatest == null || e.ActivityDate > evtLatest.activityDate || e.Apply_to_Mandate_Override__c == 'Yes')) {
                                intSessions++;
                                evtLatest = e;
                                    if(intSessions == pc.Mandatory_Sessions_Required__c) {
                                        break;
                                    }
                            }
                        } else if(e.verification_status__c == 'Unverified') {
                            intUnverifiedSessions++;
                        }                   
                        
                    // for TRP, get the first class
                    } else if(pc.Client__r.RecordTypeId == Utility_ID__c.getValues('TRP Client').RecordType_Id__c 
                    && e.Class_Category__c == 'TRP One Day Session') {
                            
                        evtLatest = e;
                        break;              
                    }
                }           
            }
            
            //save new session count to program cycle for DTC and CCM
            if(pc.Client__r.RecordTypeId == dtc_client || pc.Client__r.RecordTypeId == ccm_client
                        || pc.Client__r.RecordTypeId == one_client || pc.Client__r.RecordTypeId == ceo_client)            
            {
                
                pc.Mandatory_Sessions_Completed__c = intSessions;
                if(evtLatest != null) {
                    pc.Last_Mandated_Session_Admin__c = evtLatest.activityDate;
                }
                
                //CCM is exited manually, so increment session counter but don't close cycle
                //9/24/13 MB: slight change to this, we want to populate the end date with the evtLatest
                //date after the exit type is manually selected. New field Last_Mandated_Session_Admin__c set above.
                if((pc.Client__r.RecordTypeId == dtc_client 
                        || pc.Client__r.RecordTypeId == one_client || pc.Client__r.RecordTypeId == ceo_client)                
                    && (pc.Client__r.Client_Status__c == 'Active' || pc.Client__r.Client_Status__c == 'Exited')) {
                
                    //successful exit               
                    if(pc.Mandatory_Sessions_Completed__c >= pc.Mandatory_Sessions_Required__c) {
                        
                        pc.End_Date__c = evtLatest.activityDate;
                        pc.Exit_Type__c = 'Successful Exit';
                        
                    } else if(system.today() < pc.Compliance_Date__c) { 
                    
                        //if the client did not complete all sessions yet, and hasn't hit their compliance date,
                        //make sure they are active. This is useful when unverifying/deleting data entry errors that caused
                        //the client to be prematurely exited

                        pc.End_Date__c = null;
                        pc.Exit_Type__c = null;                     
                        
                    } else if(intUnverifiedSessions == 0) {
                        
                        
                        //unsuccessful exit, did not hit mandate,
                        //it's on or after compliance date, and no remaining unverified appts
                        // Note this logic can be triggered by the nightly process that fires updates on all DTC/CCM events                     
                        pc.End_Date__c = pc.Closing_Date__c;
                        pc.Exit_Type__c = 'Unsuccessful Exit';                  
                    }
                }   
            } else if (evtLatest == null) { //TRP
                
                pc.Next_Class_Date__c = null;
                pc.TRP_Class_Status__c = 'Needs to be Scheduled';
                
            } else if (evtLatest.Verification_Status__c == 'Attended' 
            || evtLatest.Verification_Status__c == 'Late') {
                
                pc.Next_Class_Date__c = null;
                pc.TRP_Class_Status__c = 'Successful';
                pc.End_Date__c = evtLatest.activityDate;
                pc.Exit_Type__c = 'Successful Exit';
                
            } else if (evtLatest.Verification_Status__c != 'Not Verified') {
                
                pc.Next_Class_Date__c = null;
                pc.TRP_Class_Status__c = 'Unsuccessful';
                pc.End_Date__c = evtLatest.activityDate;
                pc.Exit_Type__c = 'Unsuccessful Exit';
            
            } else {//if event is not verified  
                
                pc.Next_Class_Date__c = evtLatest.ActivityDate;
                pc.TRP_Class_Status__c = 'Scheduled';
            }
            
        }
        
        //dml
        if(lstCycles.size() > 0) {
            update lstCycles;
        }
    }
    
    
    //new method for Choices 9/10/13 MB
    public void setChoicesComplianceCounter() {
        

        // track date to make sure that two unverified appts on the same day don't count twice
        // integer tracks sessions so far
        Date dteLastChecked = system.today().addDays(1);
        Boolean bolCurrentDayCompliant = false;
        Integer intConsecutiveDays = 0;
        
        //for each contact, run through and find the number of consecutive absent appts
        // note that this does not count days, just appts, so if past appts are missing or unverified
        // this total will not be correct. I am doing this because clients may have different schedules
        // for curfew, and there may be days off that are not tracked in the Holidays object    
        for(Contact c: mapClients.values()) {
            
            if(c.RecordtypeId == Utility_ID__c.getValues('Bronx Choices Client').RecordType_Id__c 
                || c.RecordtypeId == Utility_ID__c.getValues('Manhattan Choices Client').RecordType_Id__c) 
            {
                //reset variables   
                dteLastChecked = system.today().addDays(1);
                bolCurrentDayCompliant = false;
                intConsecutiveDays = 0;         
            
                for(Event e: c.Events) 
                {
                    //events sub-query includes court dates since these are used in the setNextCourtDate method
                    if(e.RecordTypeId != Utility_ID__c.getValues('Court Date').RecordType_Id__c) 
                    {
                        //we're on a new day
                        if(e.ActivityDate < dteLastChecked) 
                        {    
                            //if the client was compliant for all of the last day's sessions
                            if(bolCurrentDayCompliant == true) 
                            {    
                                //exit loop, set value and move to next contact
                                break;
                            } else { //if client was non-compliant that day
                                if(dteLastChecked <= system.today()) 
                                {
                                    //increment counter, unless this is the first time thru the loop
                                    intConsecutiveDays ++;
                                }
                                                    
                                
                                //set values for new day
                                dteLastChecked = e.ActivityDate;
                                if(e.Verification_Status__c != 'Attended') 
                                {
                                    bolCurrentDayCompliant = false;
                                } else {
                                    bolCurrentDayCompliant = true;
                                }
                            }
                        } else { //if date is the same              
                            
                            if(bolCurrentDayCompliant == false) {
                                //do nothing, move onto next event in loop
                            } else {
                                if(e.Verification_Status__c != 'Attended') 
                                {
                                    bolCurrentDayCompliant = false;
                                }
                            }               
                        }
                    }
                }
            
                //if the list of events ended with a non-compliant day, it will not have been counted yet   
                if(bolCurrentDayCompliant == false) {
                    
                    intConsecutiveDays ++;
                }   
                
                //set value on contact  
                c.Consecutive_Days_Non_Compliant__c = intConsecutiveDays;    
                setContactIdsToUpdate.add(c.id);  
            }
        }
    }
    
    ////////////////////////
    //
    // Insert Progress Note
    //
    ///////////////////////
    
    public Progress_Note__c insertProgressNote(event evt, id pp, Progress_Note__c note) 
    {
        Progress_Note__c pn = new Progress_Note__c();
            
        if(note == null) 
        {
            pn.Program_Plan__c = pp;  
            pn.Activity_Id_Admin__c = evt.Id;
                
            if(evt.RecordTypeId == Utility_Id__c.getValues('Court Date').RecordType_Id__c) 
            {
                pn.RecordTypeId = Utility_ID__c.getValues('Court Rep Note').RecordType_Id__c; 
            } else 
            if(evt.RecordTypeId == Utility_Id__c.getValues('Employment - Internal').RecordType_Id__c) 
            {
                pn.RecordTypeId = Utility_ID__c.getValues('CC Progress Note').RecordType_Id__c; 
            } else 
            if(evt.RecordTypeId == Utility_Id__c.getValues('Immediate Notification').RecordType_Id__c) 
            {
                pn.RecordTypeId = Utility_ID__c.getValues('Court Rep Note').RecordType_Id__c; 
            } else                 
            if(evt.RecordTypeId == Utility_ID__c.getValues('APT Appointment').RecordType_Id__c) 
            {
                pn.RecordTypeID = Utility_ID__c.getValues ('Progress Note (APT)').RecordType_ID__c;
            } else 
            if(evt.RecordTypeId == Utility_ID__c.getValues('Supervision').RecordType_Id__c) 
            {
                pn.RecordTypeID = Utility_ID__c.getValues ('Case Note').RecordType_ID__c;
            } else 
            if(evt.RecordTypeId == Utility_ID__c.getValues('Intake/Needs Assessment').RecordType_Id__c) 
            {
                pn.RecordTypeID = Utility_ID__c.getValues ('Case Note').RecordType_ID__c;
            } else 
            if(evt.RecordTypeId == Utility_Id__c.getValues('Case Coordination (CCM)').RecordType_id__c) 
            {
                pn.RecordTypeId = Utility_ID__c.getValues('Progress Note (CCM)').RecordType_Id__c;
            } else 
            if(evt.RecordTypeID == Utility_Id__c.getValues('Case Coordination (CIRT)').RecordType_id__c
                || evt.RecordTypeID ==  Utility_Id__c.getValues('Nurse\'s Appointment').RecordType_id__c
                || evt.RecordTypeID == Utility_Id__c.getValues('CIRT External').RecordType_id__c)
            {
                pn.RecordTypeId = Utility_ID__c.getValues('Progress Note (CIRT)').RecordType_Id__c;
            } else 
            if (evt.RecordTypeID == Utility_Id__c.getValues('Psychiatrist\'s Appointment').RecordType_id__c 
            || evt.RecordTypeId == Utility_Id__c.getValues('Collateral Contact').RecordType_id__c) 
            {
                if(mapClients.get(evt.whoId).RecordTypeId == Utility_ID__c.getValues('CIRT Client').RecordType_Id__c) 
                {
                pn.RecordTypeId = Utility_ID__c.getValues('Progress Note (CIRT)').RecordType_Id__c;
                } else {
                    pn.RecordTypeId = Utility_ID__c.getValues('Progress Note (CCM)').RecordType_Id__c;
                }
            } else 
            if(evt.RecordTypeID == Utility_ID__c.getValues('Case Coordination').RecordType_Id__c) 
            {
                pn.RecordTypeId = Utility_ID__c.getValues('CC Progress Note').RecordType_Id__c;
            }
        } else 
            {
                pn = note;
            }                    
            
        if(evt.Subject == 'Court Date') 
        {
            pn.Area__c = 'Judicial and Civic Accountability';
        } else {
            pn.Area__c = evt.Subject;               
        }           

        pn.Progress_Note__c = evt.Description;
        pn.Activity_Date__c = evt.ActivityDate;
        if(note == null) 
        {
            pn.Date__c = system.today();
        }
        return pn;
    }
    
    ////////////////////////
    //Edit Progress Note
    //
    ///////////////////////
    public void editProgressNote(set<ID> setNewEventIds) 
    {
        map<Id, Progress_Note__c> mapEventstoNotes = new map<Id, Progress_Note__c>();
        
        list<Progress_Note__c> lstPNstoInsert = new list<Progress_Note__c>();       
        list<Progress_Note__c> lstPNstoUpdate = new list<Progress_Note__c>();
        list<Progress_Note__c> lstPNstoDelete = new list<Progress_Note__c>();
        
        
        system.debug('Activity_Id_Admin__c: ' + setNewEventIds);
        system.debug('Client_Name__c: ' + getWhoIds);
       
        //create map                                         
        for(Progress_Note__c pn : [select id, Area__c, Date__c, Activity_Date__c,
                        Progress_Note__c, Activity_Id_Admin__c 
                        FROM Progress_Note__c WHERE Activity_Id_Admin__c IN :setNewEventIds
                        AND Program_Plan__r.Client_Name__c IN :getWhoIds]) 
        {  
            mapEventsToNotes.put(pn.Activity_Id_Admin__c, pn);
        }                                    
                                                 
        for(Event e: newEvents) 
        {
            if(!mapClients.isEmpty())
            {  if(mapClients.get(e.whoId).Program_Plans__r.size() > 0) 
               {
                //check non-court dates first
                if(e.RecordTypeId != Utility_Id__c.getValues('Court Date').RecordType_Id__c)          
                {
                    //insert note
                    if(e.description != null) 
                    {
                        //if note added already 
                        if(mapEventstoNotes.containsKey(e.id)) 
                        {
                            if((e.ActivityDate != mapOldEvents.get(e.id).ActivityDate 
                            || e.Description != mapOldEvents.get(e.id).Description)) 
                            {
                                lstPNstoUpdate.add(insertProgressNote(e, mapClients.get(e.whoId).Program_Plans__r[0].Id, mapEventstoNotes.get(e.id)));              
                            }
                        //if new note needed (insert or note added on update)           
                        } else {
                            lstPNstoInsert.add(insertProgressNote(e, mapClients.get(e.whoId).Program_Plans__r[0].Id, null));
                        }       
                       //delete note                
                    }  else if(mapEventstoNotes.containsKey(e.id) 
                        && mapOldEvents.get(e.id).description != null) 
                        {    
                            lstPNstoDelete.add(mapEventstoNotes.get(e.id));
                    }       
                //Create Progress Note? field is only for court dates   
                } else if(e.RecordTypeId == Utility_Id__c.getValues('Court Date').RecordType_Id__c) 
                { 
                    //insert note
                    if(e.description != null && e.Create_Progress_Note__c == true) 
                    {
                        //if note added already 
                        if(mapEventstoNotes.containsKey(e.id)) 
                        {
                            if((e.ActivityDate != mapOldEvents.get(e.id).ActivityDate 
                            || e.Description != mapOldEvents.get(e.id).Description)) 
                            {
                                
                                lstPNstoUpdate.add(insertProgressNote(e, mapClients.get(e.whoId).Program_Plans__r[0].Id, mapEventstoNotes.get(e.id)));              
                            }
                        //if new note needed (insert or note added on update)           
                        } else {
                            lstPNstoInsert.add(insertProgressNote(e, mapClients.get(e.whoId).Program_Plans__r[0].Id, null));
                        }       
                       //delete note                
                    }  else if(mapEventstoNotes.containsKey(e.id) 
                            && (e.description == null || e.Create_Progress_Note__c == false)) 
                    {        
                            lstPNstoDelete.add(mapEventstoNotes.get(e.id));
                    }                   
                }   
              }
            }
        }
        
        //dml
        if(lstPNstoInsert.size() > 0) 
        {
            insert lstPNstoInsert;
        }
        if(lstPNstoUpdate.size() > 0) 
        {
            update lstPNstoUpdate;
        }
        if(lstPNstoDelete.size() > 0) 
        { 
            delete lstPNstoDelete; 
        }
    }
        
    public void createProgramRelationship() {
        
        list<Program_Relationships__c> lstNewPRs = new list<Program_Relationships__c>();
        Program_Relationships__c pr = new Program_Relationships__c();
        
        for(Event e: newEvents) {
            
            //only create PR if event is Insert, or if checkbox was not previously checked
            // no support for editing existing relationship, unlike the progress note logic that START also uses

            system.debug('****Event e: ' +  e);
            system.debug('****RecordType: ' +  mapClients.get(e.whoId).RecordTypeId);
            system.debug('****BOLINSERT: ' +  bolInsert);
            //system.debug('****mapOldEvents: ' +   mapOldEvents.get(e.id).whatId);


            if(e.whatId != null && mapClients.get(e.whoId).RecordTypeId == Utility_ID__c.getValues('CCM Client').RecordType_Id__c
                && (e.RecordTypeID == Utility_ID__c.getValues('Case Coordination (CCM)').RecordType_Id__c 
                    || e.RecordTypeID == Utility_Id__c.getValues('Psychiatrist\'s Appointment').RecordType_id__c)
                && (bolInsert || mapOldEvents.get(e.id).whatId == null)) 
            {                      
                //validation   
                if(e.Verification_Status__c != 'Attended' && e.Verification_Status__c != 'Late') 
                {    
                    e.Verification_Status__c.addError('The client must have attended the appointment '
                    + 'before you can create a Program Relationship. Please verify the appointment first.');
                } else 
                    if(e.Service_Type__c == null) 
                    {
                        e.Service_Type__c.addError('To create a Program Relationship, you need to '
                        +'choose a Service Type from the picklist.');
                    } else 
                        if(e.Referral_Type__c == null) 
                        {
                            e.Referral_Type__c.addError('To create a Program Relationship, you need to '
                            +'choose a Referral Type from the picklist.');                  
                        } else 
                            if(e.Client_Escorted_to_Provider__c == null) 
                            {
                                e.Client_Escorted_to_Provider__c.addError('To create a Program Relationship, you need to '
                                +'indicate if the client was escorted to the provider.');                   
                            } else {
                                //clear variable
                                pr = new Program_Relationships__c();
                                pr.Warrant__c = e.whoId;
                                pr.Appointment_Date__c = e.ActivityDate;
                                pr.Appointment_Time__c = e.activityDateTime.format().right(8).trim();
                                pr.Follow_Up_Required__c = e.Need_Follow_up__c;
                                pr.Program_Start_Date__c = e.Program_Start_Date__c;
                                pr.Program__c = e.whatId;
                                pr.Referral_Date__c = e.ActivityDate;
                                pr.Client_Escorted__c = e.Client_Escorted_to_Provider__c;
                                pr.Referral_Type__c = e.Referral_Type__c;
                                pr.Service_Type__c = e.Service_Type__c; 
                                pr.Treatment_Type__c = e.Treatment_Type__c;
                                pr.RecordtypeID = Utility_ID__c.getValues('Referral Program Relationship').RecordType_Id__c;
                    
                                lstNewPRs.add(pr);
                            }
            }
        }
        
        insert lstNewPRs;
    }
    
    public void checkForDuplicates() {
        
        list<dateTime> lstDTs = new list<dateTime>();
        list<String> lstSubjects = new list<String>();
        
        for(Event e: newEvents) {
            
            lstDTs.add(e.ActivityDateTime);
            lstSubjects.add(e.Subject);
        }
        
        //pulls events for matching dates and times, and court dates set to Final Disposition 
        //(if court date is in the list of subjects, if not then this validation does not need to be run)
        list<Event> lstDupes = [select id, Subject, whoId, whatId, activityDate, 
            activityDateTime, CreatedDate, Outcome__c
            from Event where whoId in :getWhoIds and Subject in :lstSubjects 
            and (activityDateTime in :lstDTs or Outcome__c = 'Final Disposition')
            and isRecurrence = false and isDeleted = false];
            
            system.debug(lstDupes);
            
        for(Event dupe: lstDupes) {
            
            for(Event newE: newEvents) {
                                
                if(dupe.Subject == newE.Subject && dupe.whoId == newE.whoId && dupe.Id != newE.id 
                    && newE.IsRecurrence == false) {
                        
                    if(dupe.Subject != null && dupe.Subject.contains('Court Date')) {
                        
                        if(dupe.whatId != newE.whatId) {
                        
                        //allow court dates for different cases on the same date
                        } else if(dupe.ActivityDate == newE.activityDate){
                            
                            newE.ActivityDate.addError('This court date already exists for this case. Copy this URL '
                            + 'to view the appointment:\r\r' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + dupe.Id);                            
                            //court dates for the same case on the same day are not allowed
                        } else if(dupe.Outcome__c == 'Final Disposition' && dupe.Outcome__c == newE.Outcome__c) {
                            
                            newE.Outcome__c.addError('A court date with an Outcome of \'Final Disposition\' already exists for this case. '
                            + 'Copy this URL to view the appointment:\r\r' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + dupe.Id);
                        }
                    } else if (dupe.ActivityDateTime == newE.activityDateTime){
                        
                        //non court date events can be on the same date, but not the same time
                        newE.ActivityDate.addError('An appointment with the same subject already exists for this time. Copy this URL '
                        + 'to view the appointment:\r\r' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + dupe.Id);
                    }
                }
            }                       
        }   
    }
    
    public void validateClassAttendance() {
        
        for(Event e: newEvents) {
            
            if( e.RecordTypeId == Utility_ID__c.getValues('Course Catalog Class').RecordType_Id__c ) {
            
                if (URL.getCurrentRequestUrl().toExternalForm().toLowerCase().contains('visual.force.com')
                    || UserInfo.getProfileId() == Utility_ID__c.getValues('System Administrator').RecordType_Id__c 
                    || UserInfo.getProfileId() == Utility_ID__c.getValues('Strategic Planning').RecordType_Id__c
                    || UserInfo.getProfileId() == Utility_ID__c.getValues('START Admin').RecordType_Id__c
                    || e.SkipRestrictions__c == true) {
                    //skip validation   
                } else if(bolInsert
                    
                    || (mapOldEvents.get(e.id).Verification_Status__c == 'Not Verified' 
                    && e.Verification_Status__c != 'Not Verified')
                    
                    || ((e.ActivityDate.month() < system.today().month() || e.ActivityDate.year() < system.today().year())
                    && (((e.Verification_Status__c == 'Attended' || e.Verification_Status__c == 'Late')
                    && (mapOldEvents.get(e.id).Verification_Status__c == 'Excused' || mapOldEvents.get(e.id).Verification_Status__c == 'Unexcused'))
                    
                    || ((e.Verification_Status__c == 'Unexcused' || e.Verification_Status__c == 'Excused')
                    &&(mapOldEvents.get(e.id).Verification_Status__c == 'Attended' || mapOldEvents.get(e.id).Verification_Status__c == 'Late'))))){
                        
                    e.addError('Verification of Course Catalog class sessions must be done via the Course Catalog. '
                        + '\n\nMandatory Orientation Activity sessions must be done via Schedule Orientation Activities.'
                        + '\n\nYou cannot change a class from not attended to attended '
                        + '\n\nafter the end of month (this affects billing). ' 
                        + '\n\nPlease submit a ticket.');    
                } else if(mapOldEvents.get(e.id).Verification_Status__c == 'Withdrawn' && e.Verification_Status__c != 'Withdrawn') {
                    
                    e.Verification_Status__c.addError('You cannot un-wthdraw a client from a class.' 
                    + '\nPlease post a task to the Database Helpdesk group in Google for IS assistance.');
                }
            }        
        }
    }
    
    public void setNextCourtDate() {
        
        for(Contact c: mapClients.values()) {
            
            Date dteNextCourt = date.newInstance(1950,1,1);
            
            for(Event e: c.Events) {
                
                //events are in descending date order due to the sorting needed for the Choices method
                //so break after the first valid appt is hit
                if(e.RecordTypeId == Utility_ID__c.getValues('Court Date').RecordType_Id__c && e.whatId == c.Intake_Case__c) {
                    
                    dteNextCourt = e.ActivityDate;
                    break;
                }
            }
            
            if(dteNextCourt != c.Next_Court_Date__c) 
            {
                if(dteNextCourt == date.newInstance(1950,1,1)) 
                {
                    if(c.Next_Court_Date__c != null) 
                    {
                        c.Next_Court_Date__c = null;
                        setContactIdsToUpdate.add(c.id);
                    }
                } else 
                    {
                        c.Next_Court_Date__c = dteNextCourt;
                        setContactIdsToUpdate.add(c.id);
                    }
            }
        }
    }
    
    public void validateCourtDates() 
    {
        Task newCCCRSTask = new Task();            
            
        for(Event e: newEvents)
        {
            if(e.Subject != null && e.Subject.contains('Court Date')) 
            {
                if(!string.valueOf(e.whatId).contains('a0G')) 
                {
                    e.whatId.addError('Court Dates must be attached to a Case Information record.');
                } else 
                    if(e.Court_Report_Required__c == true)
                    { 
                        if(e.whatId != mapClients.get(e.whoId).Intake_Case__c) 
                        {
                            // 3/9/15 MB only apply this validation to CEP
                            // this was precipitated by Choices clients switching or merging intake cases
                            if(mapClients.get(e.whoId).RecordTypeId == Utility_ID__c.getValues('CEP Client').RecordType_Id__c) 
                            {            
                                e.Court_Report_Required__c.addError('Court Reports may only be requested on Intake Cases');
                            }
                        } else 
                            if(bolInsert)
                            {
                                newCCCRSTask = util.createCCCourtReportNoteTask(mapClients.get(e.whoId), e);
                    
                                if(newCCCRSTask != null) 
                                {
                                    setTasksForInsert.Add(newCCCRSTask);
                                }
                            }
                    }
            }
        }           
    }
    
    public void massDML() {
        
        if(setTasksToUpdate.size() > 0) {
             
            update new list<Task>(setTasksToUpdate);
        }
        
        if(setTasksForInsert.size() > 0 ) {
            
            insert new list<Task>(setTasksForInsert);
        }       
        
        if(setContactIdsToUpdate.size() > 0) {
            
            for(Id i: setContactIdsToUpdate) {
                
                setContactsToUpdate.add(mapClients.get(i));
            }
            
            update new list<Contact>(setContactsToUpdate);
        }
    }
}