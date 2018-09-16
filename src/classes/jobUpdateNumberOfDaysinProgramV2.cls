global class jobUpdateNumberOfDaysinProgramV2 {

  global utilityIds clsUtilIds = new utilityIds();

  //Added by DCS/EBG on 20160512
  // create webservice so code can be called from a Javascript button on a contact record
  webservice static void wsCalculateDaysInProgram(Id clientId) {
    jobUpdateNumberOfDaysinProgramV2 job = new jobUpdateNumberOfDaysinProgramV2();
    job.UpdateDayCountFields(null, null, null, clientId);
  }


    global void UpdateDayCountFields(Integer intLimit, Date dteStart, Date dteEnd, Id clientId) {
        
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
            list<Event> lstAllOrientations = [SELECT whoId, activitydate, LastModifiedDate 
                                              FROM Event 
                                              WHERE recordtypeid = :clsUtilids.orientationAppointment
                                              AND Verification_Date__c >= :dteStart AND Verification_Date__c <= :dteEnd
                                              AND (Verification_Status__c = 'Attended' OR Verification_Status__c = 'Late'
                                              OR Verification_Status__c = 'Tardy')
                                              ORDER BY CreatedDate DESC LIMIT 200];
                                              
            list<Detained_Dates__c> lstAllDetainedDates = [SELECT id, Contact_Detained_Dates_Lookup__c, Detained_Date__c, Date_Released__c, LastModifiedDate 
                                              FROM Detained_Dates__c
                                              WHERE LastModifiedDate >= :dteStart AND LastModifiedDate <= :dteEnd
                                              ORDER BY CreatedDate DESC LIMIT 200];     
                                              
            list<Detained_Dates__c> lstOpenDetainedDates = [SELECT id, Contact_Detained_Dates_Lookup__c, Detained_Date__c, Date_Released__c, LastModifiedDate 
                                              FROM Detained_Dates__c
                                              WHERE Date_Released__c = null];                                         
            
            list<Administrative_Actions__c> lstAllExits = [SELECT Client__c, Action_Date__c, LastModifiedDate  
                                              FROM Administrative_Actions__c
                                              WHERE (recordtypeid = :clsUtilids.aaExitNotificationLocked OR 
                                                    (approved__c = 'Yes' AND recordtypeid = :clsUtilids.aaExitNotification))
                                              AND LastModifiedDate >= :dteStart AND LastModifiedDate <= :dteEnd
                                              ORDER BY CreatedDate DESC LIMIT 200]; 
                                              
            list<Administrative_Actions__c> lstAllReinstatements = [SELECT Client__c, Action_Date__c, LastModifiedDate 
                                              FROM Administrative_Actions__c
                                              WHERE (recordtypeid = :clsUtilids.aaReinstatementLocked OR
                                                    (approved__c = 'Yes' AND recordtypeid = :clsUtilids.aaReinstatement))
                                              AND LastModifiedDate >= :dteStart AND LastModifiedDate <=:dteEnd
                                              ORDER BY CreatedDate DESC LIMIT 200];
                                              
            list<contact> lstActiveClients = [SELECT Id, Client_Status__c, Intake_Date__c FROM Contact 
                                             WHERE RecordTypeId = :clsUtilIds.conClient 
                                             AND Client_Status__c = 'Active'
                                             FOR UPDATE];                                                                              
            
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
            lstClientsForLoop = [SELECT id, Number_of_Days_in_Program__c, Current_Intake_Date__c,
                                 Days_in_Detention_Before_Intake__c, Intake_Date__c, Re_intake_Date__c
                                 FROM Contact 
                                 WHERE Id in :setAffectedClientIds
                                 FOR UPDATE];   
                                                        
            // turn list into a map                 
            for(Contact client: lstClientsForLoop) {
                mapClients.put(client.Id, client);
            }       
            
        }           

        //added by DCS/EBG on 20160502
        else if (clientId != null) {
            //get contact lists and maps from id 
            lstClientsForLoop = [SELECT id, Number_of_Days_in_Program__c, Current_Intake_Date__c,
                                 Days_in_Detention_Before_Intake__c, Intake_Date__c, Re_intake_Date__c
                                 FROM Contact 
                                 WHERE Id = :clientId
                                 FOR UPDATE];   

            // turn list into a map                 
            for(Contact client: lstClientsForLoop) {
                mapClients.put(client.Id, client);
            }       
        }
        // if this method is looking for contacts with blank values
        else {              
        //get client lists
            lstClientsForLoop = [SELECT id, Number_of_Days_in_Program__c, Current_Intake_Date__c,
                                 Days_in_Detention_Before_Intake__c, Intake_Date__c, Re_intake_Date__c
                                 FROM Contact 
                                 WHERE RecordTypeId = :clsUtilIds.conClient
                                 AND (Number_of_Days_in_Program__c = null 
                                 OR Days_in_Detention_Before_Intake__c = null)
                                 LIMIT :intLimit];      
                                              
            // turn list into a map                 
            for(Contact client: lstClientsForLoop) {
            
                mapClients.put(client.Id, client);
            }                                                                     
        
        }
        
        //get client actions to convert to strings
        list<Event> lstOrientations = [SELECT whoId, activitydate, LastModifiedDate 
                                          FROM Event 
                                          WHERE recordtypeid = :clsUtilids.orientationAppointment
                                          AND whoId in :lstClientsForLoop
                                          AND (Verification_Status__c = 'Attended' OR Verification_Status__c = 'Late'
                                          OR Verification_Status__c = 'Tardy')];
                                                  
        list<Detained_Dates__c> lstDetainedDates = [SELECT id, Contact_Detained_Dates_Lookup__c, Detained_Date__c, Date_Released__c, LastModifiedDate 
                                          FROM Detained_Dates__c
                                          WHERE Contact_Detained_Dates_Lookup__c in :lstClientsForLoop
                                          ];        
        
        list<Administrative_Actions__c> lstExits = [SELECT Client__c, Action_Date__c, LastModifiedDate  
                                          FROM Administrative_Actions__c
                                          WHERE (recordtypeid = :clsUtilids.aaExitNotificationLocked OR 
                                                    (approved__c = 'Yes' AND recordtypeid = :clsUtilids.aaExitNotification))
                                          AND Client__c in :lstClientsForLoop
                                          ];    
                                          
        list<Administrative_Actions__c> lstReinstatements = [SELECT Client__c, Action_Date__c, LastModifiedDate 
                                          FROM Administrative_Actions__c
                                          WHERE (recordtypeid = :clsUtilids.aaReinstatementLocked OR
                                                    (approved__c = 'Yes' AND recordtypeid = :clsUtilids.aaReinstatement))
                                          AND Client__c in :lstClientsForLoop
                                          ];                                                                                
                                                                    
        
        //generate lists of strings for calculation loop
        for(Event e: lstOrientations) {
            
            if(mapClients.get(e.whoId).Re_Intake_Date__c == null 
            || mapClients.get(e.whoId).Re_Intake_Date__c <= e.ActivityDate) {
                lstStrings.add(e.whoId + ';' + e.activitydate + ';' + 'A');     
            }   
        }
        
        boolean bolDetentionLineAdded = false;
        for(Detained_Dates__c d: lstDetainedDates) {
            
            if(mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c == null 
            || mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c <= d.Detained_Date__c) {                
            
                lstStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Detained_Date__c + ';' + 'D');
                bolDetentionLineAdded = true;
            }
            
            lstDetainedStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Detained_Date__c + ';' + 'D');
            
            if(d.Date_Released__c != null && d.Date_Released__c> date.newInstance(1950,1,1)) {

                if(mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c == null 
                || mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c <= d.Date_Released__c) {    
                    
                    lstStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Date_Released__c + ';' + 'U');
                    //Added by DCS/EBG on 20160512 
                    // handles scenario where detention happens before reintake and release happens on the reintake date
                    // do this to prevent having a "U" record without a corresponding "D" record
                    if (!bolDetentionLineAdded && mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c != null) {
                      lstStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + mapClients.get(d.Contact_Detained_Dates_Lookup__c).Re_Intake_Date__c + ';' + 'D');
                    }
                }   
                
                lstDetainedStrings.add(d.Contact_Detained_Dates_Lookup__c + ';' + d.Date_Released__c + ';' + 'U');              
            }
            bolDetentionLineAdded = false;
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

        system.debug('lstStrings:\n' + lstStrings);

        for(String s: lstStrings) {
            
            system.debug('Starting contact history record: ' + s);
            
            strnewClient = s.left(18);
            strnewDate = s.mid(19,19);
            strnewAction = s.mid(39,1);
            
            system.debug('\nstrclient: ' + strClient
                        + '\nstrnewClient: ' + strnewClient 
                        + '\nstrnewDate: ' + strnewDate 
                        + '\nstrnewAction: ' + strnewAction 
                        + '\ndteLastStatusChange: ' + dteLastStatusChange
                        + '\nstrCurrentClientStatus: ' + strCurrentClientStatus
                        + '\nbolInactive: ' + bolInactive
                        + '\nintDetained: ' + intDetained
                        + '\nintDays: ' + intDays);
            
            if(strnewClient != strclient) {
                
                system.debug('Finishing client: ' + strClient);
                // update IntDays for active clients up till the current day
                if(strCurrentClientStatus == 'Active') {
                    
                    IntDays = IntDays + 1 + dteLastStatusChange.daysBetween(system.today());
                    system.debug('Client is Active.  IntDays: ' + intDays);
                }
                //set value for contact 
                if(strClient != null) {   
                    system.debug('Setting client days in program: ' + intDays);          
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
                system.debug('Detained.  intDetained: ' + intDetained);
            }
            
            //U = Undetained (has one fewer detainment active)
            
            else if(strAction == 'U') {
                intDetained = intDetained - 1;
                system.debug('Undetained.  intDetained: ' + intDetained);
            }                   
            
            if(intDetained == 0 && !bolInactive && strCurrentClientStatus != 'Active') {
                dteLastStatusChange = date.valueof(strDate);
                strCurrentClientStatus = 'Active';
                system.debug('Block: change to active. '
                 + '\n New Date is: ' + dteLastStatusChange
                 + '\n New Client Status is: ' + strCurrentClientStatus
                 + '\n Current Day Count: ' + intDays);
            }
            
            else if((intDetained > 0 || bolInactive) && strCurrentClientStatus == 'Active') {
                
                IntDays = IntDays + 1 + dteLastStatusChange.daysBetween(date.valueof(strDate));
                system.debug('Old Date: ' + dteLastStatusChange
                            + '\n strDate: ' + strDate
                            + '\n days between: ' + dteLastStatusChange.daysBetween(date.valueof(strDate)));
                dteLastStatusChange = date.valueof(strDate);
                strCurrentClientStatus = 'Inactive';
                system.debug('Block: change to inactive. Set Day Counter. '
                 + '\n New Date is: ' + dteLastStatusChange
                 + '\n New Client Status is: ' + strCurrentClientStatus
                 + '\n Current Day Count: ' + intDays
                 + '\n intDetained: ' + intDetained);                     
            }

            system.debug('End of line.\nstrclient: ' + strClient
                        + '\nstrnewClient: ' + strnewClient 
                        + '\nstrnewDate: ' + strnewDate 
                        + '\nstrnewAction: ' + strnewAction 
                        + '\ndteLastStatusChange: ' + dteLastStatusChange
                        + '\nstrCurrentClientStatus: ' + strCurrentClientStatus
                        + '\nbolInactive: ' + bolInactive
                        + '\nintDetained: ' + intDetained
                        + '\nintDays: ' + intDays);
        
        }// end of days in program loop
        
        // set value for final contact after loop
        if(strCurrentClientStatus == 'Active') {
            system.debug('Before final assignment.'
                        + '\n IntDays: ' + intDays
                        + '\ndteLastStatusChange: ' + dteLastStatusChange
                        + '\ndteLastStatusChange.daysBetween(system.today()): ' + dteLastStatusChange.daysBetween(system.today()))        ;
            IntDays = IntDays + 1 + dteLastStatusChange.daysBetween(system.today());

            system.debug('After final days assignment.'
                        + '\nIntDays: ' + intDays
                        + '\nstrClient: ' + strClient);
            //ebg removed +1: IntDays = IntDays + dteLastStatusChange.daysBetween(system.today());
        }
            
        if(strClient != null) {
            system.debug('Final contact in loop.  Setting days in program: ' + intDays);             
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
            system.debug('Start looping through detained dates');
            for(String s: lstDetainedStrings) {
                
                //don't process this loop if the selected clients don't have any detainments
                if(lstDetainedStrings.size() == 0) {
                    
                    system.debug('No detained dates, skipping detained loop.');
                    break;
                }
                
                system.debug('Starting contact history record for detained dates: ' + s);
                
                strnewClient = s.left(18);
                strnewDate = s.mid(19,19);
                strnewAction = s.mid(39,1);
                
                system.debug('strnewClient = ' + strnewClient 
                            + '\n strnewDate = ' + strnewDate 
                            + '\n strnewAction = ' + strnewAction
                            + '\nstrClient = ' + strClient);
                
                // if we've moved on to a new client, then the current one is done and the value needs to be set
                if(strnewClient != strClient) {
                    
                    system.debug('Finishing client: ' + strClient);                 
                    //update IntDaysDetained for currently detained clients up till current day
                    
                    if(mapClients.containsKey(strClient)) {                     
                        if(intDetained > 0) { 
                            
                            if(mapClients.get(strClient).Current_Intake_Date__c == null) {
                                system.debug('No Intake Date.  IntDaysDetained before adjustment: ' + IntDaysDetained);
                                IntDaysDetained = IntDaysDetained + 1 
                                + dteLastDetainedChange.daysBetween(date.Today());
                                system.debug('IntDaysDetained after adjustment: ' + IntDaysDetained);
                            }
                            
                            else if (dteLastDetainedChange < mapClients.get(strClient).Current_Intake_Date__c) {
                                system.debug('Intake Date.  IntDaysDetained before adjustment: ' + IntDaysDetained);
                                IntDaysDetained = IntDaysDetained + 1 
                                + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c);                                  
                                system.debug('IntDaysDetained after adjustment: ' + IntDaysDetained);
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
                        system.debug('Detained ' + strDate + '\nintDetained: ' + intDetained);
                    
                        intDetained = intDetained + 1;
                        
                            //if the client is newly in detention
                        if(intDetained == 1) {
                            
                            dteLastDetainedChange = date.ValueOf(strDate);
                        }
                        
                        else if(intDetained > 1 && 
                        ( mapClients.get(strClient).Current_Intake_date__c != null
                        && date.ValueOf(strDate) >= mapClients.get(strClient).Current_Intake_Date__c)) {
                                system.debug('Calculate days detained for Detained date.  Before: ' + intDaysDetained);
                                intDaysDetained = intDaysDetained + 1
                                + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c);                          
                                system.debug('After: ' + intDaysDetained);
                        }                                               
                    }
                    
                    //U = Undetained (has one fewer detainment active)
                    
                    else if(strAction == 'U') {
                        system.debug('Undetained.  intDetained: ' + intDetained);
                        intDetained = intDetained - 1;
                                
                        if(mapClients.get(strClient).Current_Intake_date__c != null
                        && date.ValueOf(strDate) >= mapClients.get(strClient).Current_Intake_Date__c) {
                                
                            system.debug('Before calculating detained dates.  intDaysDetained: ' + intDaysDetained
                                        + '\ndaysBetween ' + dteLastDetainedChange + ' and ' + mapClients.get(strClient).Current_Intake_Date__c + ': ' + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c));
                            intDaysDetained = intDaysDetained + 1
                                              + dteLastDetainedChange.daysBetween(mapClients.get(strClient).Current_Intake_Date__c);
                            system.debug('After calculating detained dates. intDaysDetained: ' + intDaysDetained);
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
        system.debug('After looping through detained dates. intDaysDetained: ' + intDaysDetained);
        
        // update values for final client after loop is finished        
        if(mapClients.containsKey(strClient)) {         
            system.debug('Process last client: ' + strClient);
            system.debug('intDetained: ' + intDetained
                        + '\ndteLastDetainedChange: ' + dteLastDetainedChange
                        + '\ndteLastDetainedChange.daysBetween(date.Today()): ' + dteLastDetainedChange.daysBetween(date.Today()));
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
        string strErrorListforEmail = 'The following contacts did not update during the Set All method of the jobUpdateNumberofDaysinProgramV2 class. \n \n';
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
             mail.setTargetObjectId('00560000001jFOg'); // Matt Britton
             mail.setSubject('Apex error in jobUpdateNumberofDaysinProgramV2()');
             mail.setPlainTextBody(strErrorListforEmail);
             mail.saveAsActivity = false;
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }       
        
    }       


    // test manual method (scheduled method tested in scheduler)
    static testmethod void test() {
        
        utilityIds clsUtilIds = new utilityIds();       
        
        list<Contact> lstContacts = [SELECT id, Number_of_Days_in_Program__c FROM Contact 
        WHERE RecordTypeId=:clsUtilIds.conClient LIMIT 5];
        
        for(Contact c: lstContacts) {
            
            c.Number_of_Days_in_Program__c = null;
        }
        
        update lstContacts;     
                            
        Test.startTest();

        jobUpdateNumberofDaysinProgramV2 j = new jobUpdateNumberofDaysinProgramV2();
        j.UpdateDayCountFields(null, System.Today().addDays(-3), System.Today().addDays(-1), null);
        j.UpdateDayCountFields(null, null, null, lstContacts[0].Id);
        jobUpdateNumberofDaysinProgramV2.wsCalculateDaysInProgram(lstContacts[0].Id);

        Test.stopTest();
    }


}// end of class