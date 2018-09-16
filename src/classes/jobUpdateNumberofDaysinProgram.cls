global class jobUpdateNumberofDaysinProgram {

    global utilityIds clsUtilIds = new utilityIds();

    global void UpdateDayCountFields(Integer intLimit, Date dteStart, Date dteEnd) {
        
        // this method can be run 3 ways. 
        // 1. You can update intLimit number of clients that have a blank value for Number of Days in Progrma
        // or Days in Detention before Intake.
        // 2. You can update the values for clients that had an orientation, detained date, or admin action in the date range
        // or who are currently active/ in detention. This is used for the nightly run
        
        list<String> lstStrings = new list<String>();
        list<String> lstDetainedStrings = new list<String>();
        list<Contact> lstClientsForLoop = new list<Contact>();
        Map<Id, Contact> mapClients= new Map<Id, Contact>();
        
        // if this method is run for a specified date range (nightly update)
        if(dteStart != null && dteEnd != null) {
            
            //find all records modified in the date range, and active clients and clients w/ open detainments
            list<Event> lstAllOrientations = [select whoId, activitydate, LastModifiedDate 
                                              from Event 
                                              where recordtypeid = :clsUtilids.orientationAppointment
                                              and Verification_Date__c >= :dteStart and Verification_Date__c <= :dteEnd
                                              and (Verification_Status__c = 'Attended' or Verification_Status__c = 'Late'
                                              or Verification_Status__c = 'Tardy')
                                              Order By CreatedDate desc Limit 200];
                                              
            list<Detained_Dates__c> lstAllDetainedDates = [select id, Contact_Detained_Dates_Lookup__c, Detained_Date__c, Date_Released__c, LastModifiedDate 
                                              from Detained_Dates__c
                                              where LastModifiedDate >= :dteStart and LastModifiedDate <= :dteEnd
                                              Order By CreatedDate desc Limit 200];     
                                              
            list<Detained_Dates__c> lstOpenDetainedDates = [select id, Contact_Detained_Dates_Lookup__c, Detained_Date__c, Date_Released__c, LastModifiedDate 
                                              from Detained_Dates__c
                                              where Date_Released__c = null];                                         
            
            list<Administrative_Actions__c> lstAllExits = [select Client__c, Action_Date__c, LastModifiedDate  
                                              from Administrative_Actions__c
                                              where (recordtypeid = :clsUtilids.aaExitNotificationLocked or approved__c = 'Yes' )
                                              and LastModifiedDate >= :dteStart and LastModifiedDate <= :dteEnd
                                              Order By CreatedDate desc Limit 200]; 
                                              
            list<Administrative_Actions__c> lstAllReinstatements = [select Client__c, Action_Date__c, LastModifiedDate 
                                              from Administrative_Actions__c
                                              where (recordtypeid = :clsUtilids.aaReinstatementLocked or approved__c = 'Yes' )
                                              and LastModifiedDate >= :dteStart and LastModifiedDate <=:dteEnd
                                              Order By CreatedDate desc Limit 200];
                                              
            list<contact> lstActiveClients = [select Id, Client_Status__c, Intake_Date__c from Contact 
                                             where RecordTypeId = :clsUtilIds.conClient 
                                             and Client_Status__c = 'Active'];                                                                              
            
            set<Id> setAffectedClientIds = new set<Id>();
            
            //generate lists of clients for scoped loop
            for(Event e: lstAllOrientations) {
                
                setAffectedClientIds.add(e.whoId);      
            }
            
            for(Detained_Dates__c d: lstAllDetainedDates) {
                
                setAffectedClientIds.add(d.Contact_Detained_Dates_Lookup__c);
            }
    
            for(Administrative_Actions__c a: lstAllExits) {
                
                setAffectedClientIds.add(a.Client__c);      
            }
            
            for(Administrative_Actions__c a: lstAllReinstatements) {
                            
                setAffectedClientIds.add(a.Client__c);      
            }
            
            for(Contact c: lstActiveClients) {
                
                setAffectedClientIds.add(c.Id); 
            }
                
            for(Detained_Dates__c d: lstOpenDetainedDates ) {
    
                setAffectedClientIds.add(d.Contact_Detained_Dates_Lookup__c);
            }
            
            //exit method if there are no clients that need to be updated
            if(setAffectedClientIds.size() == 0) {
                
                system.debug('No clients found, exiting method.');
                system.debug('\n List of clients: ' + setAffectedClientIds);
                return;
            }       
            
            //get contact lists and maps from id sets for loop
            lstClientsForLoop = [select id, Number_of_Days_in_Program__c, Current_Intake_Date__c,
                                 Days_in_Detention_Before_Intake__c, Intake_Date__c, Re_intake_Date__c
                                 from Contact where Id in :setAffectedClientIds];   
                                                        
            // turn list into a map                 
            for(Contact client: lstClientsForLoop) {
            
                mapClients.put(client.Id, client);
            }       
            
        }           
        
        // if this method is looking for contacts with blank values
        else {              
        //get client lists
            lstClientsForLoop = [select id, Number_of_Days_in_Program__c, Current_Intake_Date__c,
                                 Days_in_Detention_Before_Intake__c, Intake_Date__c, Re_intake_Date__c
                                 from Contact where RecordTypeId = :clsUtilIds.conClient
                                 and (Number_of_Days_in_Program__c = null 
                                 or Days_in_Detention_Before_Intake__c = null)
                                 limit :intLimit];      
                                              
            // turn list into a map                 
            for(Contact client: lstClientsForLoop) {
            
                mapClients.put(client.Id, client);
            }                                                                     
        
        }
        
        //get client actions to convert to strings
        list<Event> lstOrientations = [select whoId, activitydate, LastModifiedDate 
                                          from Event 
                                          where recordtypeid = :clsUtilids.orientationAppointment
                                          and whoId in :lstClientsForLoop
                                          and (Verification_Status__c = 'Attended' or Verification_Status__c = 'Late'
                                          or Verification_Status__c = 'Tardy')];
                                          
        list<Detained_Dates__c> lstDetainedDates = [select id, Contact_Detained_Dates_Lookup__c, Detained_Date__c, Date_Released__c, LastModifiedDate 
                                          from Detained_Dates__c
                                          where Contact_Detained_Dates_Lookup__c in :lstClientsForLoop
                                          ];        
        
        list<Administrative_Actions__c> lstExits = [select Client__c, Action_Date__c, LastModifiedDate  
                                          from Administrative_Actions__c
                                          where (recordtypeid = :clsUtilids.aaExitNotificationLocked or approved__c = 'Yes')
                                          and Client__c in :lstClientsForLoop
                                          ];    
                                          
        list<Administrative_Actions__c> lstReinstatements = [select Client__c, Action_Date__c, LastModifiedDate 
                                          from Administrative_Actions__c
                                          where (recordtypeid = :clsUtilids.aaReinstatementLocked or approved__c = 'Yes')
                                          and Client__c in :lstClientsForLoop
                                          ];                                                                                
                                                                    
        
        //generate lists of strings for calculation loop
        for(Event e: lstOrientations) {
            
            if(mapClients.get(e.whoId).Re_Intake_Date__c == null 
            || mapClients.get(e.whoId).Re_Intake_Date__c <= e.ActivityDate) {
                lstStrings.add(e.whoId + ';' + e.activitydate + ';' + 'A');     
            }   
        }
        
        for(Detained_Dates__c d: lstDetainedDates) {
            
            if(mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c == null 
            || mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c <= d.Detained_Date__c) {                
            
                lstStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Detained_Date__c + ';' + 'D');
            }
            
            lstDetainedStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Detained_Date__c + ';' + 'D');
            
            if(d.Date_Released__c != null && d.Date_Released__c> date.newInstance(1950,1,1)) {

                if(mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c == null 
                || mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c <= d.Date_Released__c) {    
                    
                    lstStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Date_Released__c + ';' + 'U');
                }   
                
                lstDetainedStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Date_Released__c + ';' + 'U');              
            }
        }
    
        for(Administrative_Actions__c a: lstExits) {
            
            if(mapClients.get(a.Client__c).Re_Intake_Date__c == null 
            || mapClients.get(a.Client__c).Re_Intake_Date__c <= a.Action_Date__c) {                   
            
                lstStrings.add(a.Client__c + ';' + a.Action_Date__c + ';' + 'E'); 
            }
        }
        
        for(Administrative_Actions__c a: lstReinstatements) {
            
            if(mapClients.get(a.Client__c).Re_Intake_Date__c == null 
            || mapClients.get(a.Client__c).Re_Intake_Date__c <= a.Action_Date__c) {         
            
                lstStrings.add(a.Client__c + ';' + a.Action_Date__c + ';' + 'A');   
            }
        }
        
        //exit method if there are no clients that need to be updated
        if(lstClientsForLoop.size() == 0) {
            
            system.debug('No clients found, exiting method.');
            system.debug('\n List of clients: ' + lstClientsForLoop);
            return;
        }                   

        //sort strings so that all clients are grouped, and dates are in ascending chronological order
        //this ensures that the day counts and "break" statements work correctly
        lstStrings.sort();
        lstDetainedStrings.sort();
                                                    

        // initialize this so the first run through doesn't throw an error on the first if statement
        string strClient = null;
        string strDate = null;
        string strAction = null;
        string strnewClient = null;
        string strnewDate = null;
        string strnewAction = null;     
        Integer intDays = 0;
        Date dteLastStatusChange = date.NewInstance(1950,1,1);
        string strCurrentClientStatus = 'Inactive';
        Integer intDetained = 0;
        Boolean bolInactive = true; 
                        
        for(String s: lstStrings) {
            
            system.debug('Starting contact history record: ' + s);
            
            strnewClient = s.left(18);
            strnewDate = s.mid(19,19);
            strnewAction = s.mid(39,1);
            
            system.debug('strnewClient = ' + strnewClient + '\n strnewDate = ' + strnewDate + '\n strnewAction = ' + strnewAction);
            
            if(strnewClient != strclient) {
                
                system.debug('Finishing client: ' + strClient);
                // update IntDays for active clients up till the current day
                if(strCurrentClientStatus == 'Active') {
                    
                    IntDays = IntDays + 1 + dteLastStatusChange.daysBetween(system.today());
                }
                //set value for contact 
                if(strClient != null) {             
                    mapClients.get(strClient).Number_of_Days_in_Program__c = intDays;
                }
                
                //reset values for new client
                intDays = 0;
                //last date the status change, either through an exit, a re-intake, an orientation, or intDetained going from 0->1 or V.v.
                dteLastStatusChange = date.NewInstance(1950,1,1);
                strCurrentClientStatus = 'Inactive';
                //number of detainments currently active (can overlap)
                intDetained = 0;
                bolInactive = true;                     
                
            }
            
            //set values to current string
            strClient = strnewClient;
            strDate = strnewDate;
            strAction = strnewAction;               
                
            //A = Re-instatement or Orientation (intake or re-intake)
            
            if(strAction == 'A') {
            
                bolInactive = false;    
            }
            
            //E = Exit (via admin action)
            
            else if(strAction == 'E') {
            
                bolInactive = true; 
            }
            
            //D = Detained
            
            else if(strAction == 'D') {
            
                intDetained = intDetained + 1;                      
            }
            
            //U = Undetained (has one fewer detainment active)
            
            else if(strAction == 'U') {
            
                intDetained = intDetained - 1;
            }                   
            
            if(intDetained == 0 && !bolInactive && strCurrentClientStatus != 'Active') {
                dteLastStatusChange = date.valueof(strDate);
                strCurrentClientStatus = 'Active';
                system.debug('Block: change to active. \n New Date is: ' + dteLastStatusChange
                 + '\n New Client Status is: ' + strCurrentClientStatus
                 + '\n Current Day Count: ' + intDays);
            }
            
            else if((intDetained > 0 || bolInactive) && strCurrentClientStatus == 'Active') {
                
                IntDays = IntDays + 1 + dteLastStatusChange.daysBetween(date.valueof(strDate));
                dteLastStatusChange = date.valueof(strDate);
                strCurrentClientStatus = 'Inactive';
                system.debug('Block: change to inactive. Set Day Counter. \n New Date is: ' + dteLastStatusChange
                 + '\n New Client Status is: ' + strCurrentClientStatus
                 + '\n Current Day Count: ' + intDays);                     
            }           
        
        }// end of days in program loop
        
        // set value for final contact after loop
        if(strCurrentClientStatus == 'Active') {        
            IntDays = IntDays + 1 + dteLastStatusChange.daysBetween(system.today());
        }
            
        if(strClient != null) {             
            mapClients.get(strClient).Number_of_Days_in_Program__c = intDays;
        }       

        //////////////////
        // Detained loop
        //////////////////
        
        //reset variables from "days in program" calc before beginning detained loop
        strClient = null;
        strDate = null;
        strAction = null;
        
        // initialize this so the first run through doesn't throw an error on the first if statement        
        Integer intDaysDetained = 0;
        Date dteLastDetainedChange = date.NewInstance(1950,1,1);
        intDetained = 0;
        Boolean bolStopCalc = false;        
            
            for(String s: lstDetainedStrings) {
                
                //don't process this loop if the selected clients don't have any detainments
                if(lstDetainedStrings.size() == 0) {
                    
                    system.debug('No detained dates, skipping detained loop.');
                    break;
                }
                
                system.debug('Starting contact history record: ' + s);
                
                strnewClient = s.left(18);
                strnewDate = s.mid(19,19);
                strnewAction = s.mid(39,1);
                
                system.debug('strnewClient = ' + strnewClient + '\n strnewDate = ' + 
                strnewDate + '\n strnewAction = ' + strnewAction);
                
                // if we've moved on to a new client, then the current one is done and the value needs to be set
                if(strnewClient != strClient) {
                    
                    system.debug('Finishing client: ' + strClient);                 
                    //update IntDaysDetained for currently detained clients up till current day
                    
                    if(mapClients.containsKey(strClient)) {                     
                        if(intDetained > 0) { 
                            
                            if(mapClients.get(strClient).Current_Intake_Date__c == null) {
                                
                                IntDaysDetained = IntDaysDetained + 1 
                                + dteLastDetainedChange.daysBetween(date.Today());
                            }
                            
                            else if (dteLastDetainedChange < mapClients.get(strClient).Current_Intake_Date__c) {
                                
                                IntDaysDetained = IntDaysDetained + 1 
                                + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c);                                  
                            }
                                                                    
                        }
                        
                        mapClients.get(strClient).Days_In_Detention_Before_Intake__c = IntDaysDetained;                 
                    }
                    
                    else {
                        
                        system.debug ('Client not in loop: ' + strClient);
                    }
                    
                    //reset variables for new client
                    intDaysDetained = 0;
                    //last date intDetained went from 0->1 or V.v.
                    dteLastDetainedChange = date.NewInstance(1950,1,1);
                    intDetained = 0;
                    bolStopCalc = false;
                }               
                
                strClient = strnewClient;
                strDate = strnewDate;
                strAction = strnewAction;   
                
                if(!bolStopCalc) {              
                    
                    //D = Detained
                
                    if(strAction == 'D') {
                    
                        intDetained = intDetained + 1;
                        
                            //if the client is newly in detention
                        if(intDetained == 1) {
                            
                            dteLastDetainedChange = date.ValueOf(strDate);
                        }
                        
                        else if(intDetained > 1 && 
                        ( mapClients.get(strClient).Current_Intake_date__c != null
                        && date.ValueOf(strDate) >= mapClients.get(strClient).Current_Intake_Date__c)) {
                            
                                intDaysDetained = intDaysDetained + 1
                                + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c);                          
                        }                                               
                    }
                    
                    //U = Undetained (has one fewer detainment active)
                    
                    else if(strAction == 'U') {
                    
                        intDetained = intDetained - 1;
                                
                        if(mapClients.get(strClient).Current_Intake_date__c != null
                        && date.ValueOf(strDate) >= mapClients.get(strClient).Current_Intake_Date__c) {
                                
                            intDaysDetained = intDaysDetained + 1
                                              + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c);
                            dteLastDetainedChange = date.ValueOf(strDate);
                        }
                            
                        else if(intDetained == 0) { 
                                
                            intDaysDetained = intDaysDetained + 1 + dteLastDetainedChange.daysBetween(date.ValueOf(strDate));
                            dteLastDetainedChange = date.ValueOf(strDate);
                        }
                    }
                
                    //if we've passed the client's intake date, stop the calculation for this client
                    if(date.ValueOf(strDate) >= mapClients.get(strClient).Current_Intake_Date__c) {
                    
                        bolStopCalc = true;
                    }
            }                       
        }// end of contact history loop
        
        // update values for final client after loop is finished        
        if(mapClients.containsKey(strClient)) {         
                    
            if(intDetained > 0) { 
                
                if(mapClients.get(strClient).Current_Intake_Date__c == null) {
                    
                    IntDaysDetained = IntDaysDetained + 1 
                    + dteLastDetainedChange.daysBetween(date.Today());
                }
                
                else if (dteLastDetainedChange < mapClients.get(strClient).Current_Intake_Date__c) {
                    
                    IntDaysDetained = IntDaysDetained + 1 
                    + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c);                                  
                }
                                                        
            }               
                                    
            mapClients.get(strClient).Days_In_Detention_before_Intake__c = IntDaysDetained;         
        }
            
        // if a value was not set for either field, set it to zero. This way we know it was processsed
        for(Contact c: lstClientsForLoop) {
            
            if(c.Number_of_Days_in_Program__c == null || c.Number_of_Days_in_Program__c < 0) {
                
                c.Number_of_Days_in_Program__c = 0;
            }
            
            if(c.Days_in_Detention_before_Intake__c == null || c.Days_in_Detention_before_Intake__c < 0) {
                
                c.Days_in_Detention_before_Intake__c = 0;
            }           
        }
        
        // attempt to update contact records and send error email if necessary
        Database.SaveResult[] lstResults = Database.Update(lstClientsForLoop, false);
        string strErrorListforEmail = 'The following contacts did not update during the Set All method of the jobUpdateNumberofDaysinProgram class. \n \n';
        integer i = 0;
        Boolean bolSendEmail = false;
            
        //email handling
        for(Database.SaveResult res: lstResults) {
            
            if(!res.isSuccess()) {  
                for(Database.Error err: res.getErrors()) {
                    strErrorListforEmail = strErrorListforEmail + 'Contact: ' + lstClientsForLoop[i].Id + '\nError: ' + err.getMessage() + '\n \n';
                }
                
                bolSendEmail = true;
            }   
            
            i++;
        }
        
        if(bolSendEmail) {
            
             Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
             mail.setTargetObjectId('00560000004K7uo'); // Peter Robinson
             mail.setSubject('Apex error in jobUpdateNumberofDaysinProgram()');
             mail.setPlainTextBody(strErrorListforEmail);
             mail.saveAsActivity = false;
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }       
        
    }       


    // test manual method (scheduled method tested in scheduler)
    static testmethod void test() {
        
        utilityIds clsUtilIds = new utilityIds();       
        
        list<Contact> lstContacts = [select id, Number_of_Days_in_Program__c from Contact 
        where RecordTypeId=:clsUtilIds.conClient limit 5];
        
        for(Contact c: lstContacts) {
            
            c.Number_of_Days_in_Program__c = null;
        }
        
        update lstContacts;     
                            
        Test.startTest();

        jobUpdateNumberofDaysinProgram j = new jobUpdateNumberofDaysinProgram();
        j.UpdateDayCountFields(5, null, null);
        j.UpdateDayCountFields(null, System.Today().addDays(-3), System.Today().addDays(-1));

        Test.stopTest();
    }


}// end of class