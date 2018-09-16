public class administrativeActionMethods {
    
    public utilityMethods utilMethods = new utilityMethods();
    public utilityIds utilIDs = new utilityIds();
    public Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
    public List<Administrative_Actions__c> newAdministrativeActions = new List<Administrative_Actions__c>();
    public List<Administrative_Actions__c> oldAdministrativeActions = new List<Administrative_Actions__c>();
    public Boolean isInsert = false;
    public List<Id> contactIds = new List<Id>();
    public Map<Id, Contact> mapClients = new Map<Id,Contact>();
    public Set<Task> setTaskstoUpdate = new set<Task>();   
    public Set<Event> setEventstoUpdate = new set<Event>();
    public Set<Event> setEventstoDelete = new set<Event>();           
    public Set<Enrollment__c> setEnrollmentstoUpdate = new Set<Enrollment__c>(); 
    public Set<Id> setInternalAppointments = new Set<Id>();        
    public Set<Id> setExternalAppointments = new Set<Id>();
    public void clientToStatus() {
   
        for(Administrative_Actions__c aa :newAdministrativeActions ) {
            
            contactIds.add(aa.Client__c); 
        }   
        
        // Define Internal Appointments that will be deleted
        setInternalAppointments = new Set<Id>();
        setInternalAppointments.add(utilIDs.educationInternal);
        setInternalAppointments.add(utilIDs.employmentInternal);
        setInternalAppointments.add(utilIDs.mentalHealthInternal);
        setInternalAppointments.add(utilIDs.substanceAbuseInternal);
        setInternalAppointments.add(utilIDs.orientationAppointment);
        setInternalAppointments.add(utilIDs.caseCoordination);
        
        // Define External Appointments
        setExternalAppointments = new Set<Id>();
        setExternalAppointments.add(utilIDs.courseCatalogClass);
        setExternalAppointments.add(utilIDs.educationExternal);
        setExternalAppointments.add(utilIDs.employmentExternal);
        setExternalAppointments.add(utilIDs.substanceAbuseExternal);
        setExternalAppointments.add(utilIDs.mentalHealthExternal);
        setExternalAppointments.add(utilIDs.careerExplorationAppointment);
        setExternalAppointments.add(utilIDs.caseCoordinationExternal);        
        
        mapClients = new Map<Id, Contact> ( [Select Client_Status__c, Current_Projected_Exit_Date__c, Exit_Date_1__c,
                                                Number_of_Days_in_Program__c, Intake_Date__c, Team_Leader__c, Intake_Case__c,
                                                Case_Coordinator__c, First_Date_Back_in_the_Program__c,
                                                (select id, whoId, whatId, Open_Date__c, activityDate, Closed_By_System__c, 
                                                    Subject, isClosed,Closing_Date__c, ownerID, recordTypeId, Status, 
                                                    Re_arrest_Check_Completed_On__c
                                                    from Tasks),
                                                (SELECT Id, ActivityDate, WhoId, WhatId, RecordTypeId, Outcome__c, 
                                                    SkipRestrictions__c, Subject FROM Events 
                                                    WHERE IsRecurrence = false 
                                                    AND Verification_Status__c = 'Not Verified' 
                                                    AND (RecordTypeId IN :setInternalAppointments 
                                                    OR RecordTypeId IN :setExternalAppointments 
                                                    OR RecordTypeId = :utilIDs.courtDate)),
                                                (SELECT Id, Client__c, Class__c, Client_Class_Status_Field__c, 
                                                    Withdrawn_Date__c, Withdrawn_Reason__c, Class_Record_Type__c,
                                                    Single_Session_Class__c
                                                    FROM relContactEnrollments__r
                                                    WHERE Client_Class_Status_Field__c = 'Active')
                                                from Contact Where Id in :contactIds]);
    }
    ///////////////////////////////////////////////
    // Only certain Admin Actions can be made to certain Client Statuses
    // Added 20110519 AAB per QC (BT-045)
    ///////////////////////////////////////////////
    public void clientStatusValidation() {
        
        for(Administrative_Actions__c aa : newAdministrativeActions) {
            
            // All record types          
            // 2/13/13 MB: Moved from ClassAdminActionValidation
            if (mapClients.get(aa.Client__c).Intake_Date__c == null){
                aa.addError('This client was never made an Intake, no Administrative Actions can be added.');
            }
            
            ///////////////////////////
            // Record Type Validations
            ///////////////////////////
            
            // Extension
            if(aa.RecordTypeId == utilIDs.aaExtension) {
                if(mapClients.get(aa.Client__c).Client_Status__c != 'Active' 
                && mapClients.get(aa.Client__c).Client_Status__c  != 'On Program Hold') {
                    aa.addError('Client cannot be extended unless the Client Status is Active or On Program Hold.');
                }
            }
            
            // Exit Notification
        
            if(aa.RecordTypeId == utilIDs.aaExitNotification) 
            {
                if(mapClients.get(aa.Client__c).Client_Status__c  != 'Active' 
                && mapClients.get(aa.Client__c).Client_Status__c  != 'On Program Hold' 
                && mapClients.get(aa.Client__c).Client_Status__c  != 'Intaked - Not Yet Active' ) 
                {
                    aa.addError('Client cannot be exited unless the Client Status is Active, On Program Hold, or Intaked - Not Yet Active.');
                }
                // Added by MB 8/24/12 for Phase2Dev BT-039.
            }

            
            // Reinstake / Reinstatement
            if(aa.RecordTypeId == utilIDs.aaReintake || aa.RecordTypeId == utilIDs.aaReinstatement) 
            {
                if(mapClients.get(aa.Client__c).Client_Status__c != 'Exited') 
                {
                    aa.addError('Client cannot be Reintaked or Reinstated unless the Client Status is Exited.');
                }
            }
        }
    }
    

    // Only certain people can authorize the administrative actions

    
    public void validateApproval() {
        
        Integer i = 0;
        
        for(Administrative_Actions__c aa :newAdministrativeActions ) 
        {
            
            ///////////////////////////////////////////
            // Re-instatement Approval
            ///////////////////////////////////////////
            
             if(aa.RecordTypeId == utilIDs.aaReinstatement
             && aa.Approved__c == 'Yes' && oldAdministrativeActions[i].Approved__c != 'Yes')
             {
                    
                if( UserInfo.getProfileId() == utilIDs.cepDeputyDirector ||
                    UserInfo.getProfileId() == utilIDs.adminSupportSupervisor ||
                    UserInfo.getProfileId() == utilIDs.cepDirector ||
                    UserInfo.getProfileId() == utilIDs.systemAdmin )
                {   
                    aa.RecordTypeId = utilIDs.aaReinstatementLocked;
                    aa.Approved_By__c = UserInfo.getUserId();                  
                                
                } else {
                    aa.addError('You cannot approve this Reinstatement');
                }                             
             }
            
            
            ///////////////////////////////////////////
            // Reintake Approval
            ///////////////////////////////////////////
            
             if(aa.RecordTypeId == utilIDs.aaReintake
             && aa.Approved__c == 'Yes' && oldAdministrativeActions[i].Approved__c != 'Yes')
             {             
                    
                if( UserInfo.getProfileId() == utilIDs.cepDeputyDirector ||
                UserInfo.getProfileId() == utilIDs.cepDirector ||                    
                UserInfo.getProfileId() == utilIDs.adminSupportSupervisor ||
                UserInfo.getProfileId() == utilIDs.systemAdmin )
                {   
                    
                    aa.RecordTypeId = utilIDs.aaReintakeLocked;
                    aa.Approved_By__c = UserInfo.getUserId();
                            
                } else {
                    aa.addError('You cannot approve this Reintake');
                }       
            }
            
            ///////////////////////////////////////////
            // Exit Notification approval
            ///////////////////////////////////////////
 
            if(aa.RecordTypeId == utilIDs.aaExitNotification
             && aa.Approved__c == 'Yes' && oldAdministrativeActions[i].Approved__c != 'Yes') {
                
                if( UserInfo.getProfileId() == utilIDs.cepDirector || 
                UserInfo.getProfileId() == utilIDs.cepDeputyDirector ||
                UserInfo.getProfileId() == utilIDs.adminSupportSupervisor ||
                UserInfo.getProfileId() == utilIDs.systemAdmin ||
                UserInfo.getProfileID() == utilIDs.ProgramStaff ||
                UserInfo.getProfileID() == utilIDs.CourtStaff )
                { 
                    
                    aa.RecordTypeId = utilIDs.aaExitNotificationLocked;
                    aa.Approved_By__c = UserInfo.getUserId();                         
                } 
                
                else { 
                    
                    aa.addError('You cannot approve this Exit Notification'); 
                }
            }
                          
            ///////////////////////////////////////////
            // Extension approval
            ///////////////////////////////////////////
                                
            if(aa.RecordTypeId == utilIDs.aaExtension
             && aa.Approved__c == 'Yes' && oldAdministrativeActions[i].Approved__c != 'Yes'){
                                   
                if( UserInfo.getProfileId() == utilIDs.cepDirector || 
                UserInfo.getProfileId() == utilIDs.cepDeputyDirector ||
                UserInfo.getProfileId() == utilIDs.adminSupportSupervisor ||
                UserInfo.getProfileID() == utilIDs.ProgramStaff ||
                UserInfo.getProfileID() == utilIDs.CourtStaff ||
                UserInfo.getProfileId() == utilIDs.systemAdmin ) {   
                
                    aa.RecordTypeId = utilIDs.aaExtensionLocked;
                    aa.Approved_By__c = UserInfo.getUserId();  
                                                              
                } else {
                    
                    aa.addError('You cannot approve this Exit Notification');
                }
            }
                
              
            i++;
        }
    }
    
    // Quick method to set the status of the reintaked
    // clients back to "Intaked-Not Yet Active"
    
    public void processReintake() {
        
        integer i = 0;
        list<Id> lstContactIdsForReintake = new list<Id>();
        
        for(Administrative_Actions__c aa :newAdministrativeActions ) {
            
            if(aa.recordTypeId == utilIDs.aaReintakeLocked ) {
                 
                if(aa.Approved__c == 'Yes'
                && oldAdministrativeActions[i].Approved__c != 'Yes') {
                                       
                    lstContactIdsForReintake.add(aa.Client__c);         
                }              
            }
            i++;
        }
          
        ////////////////////////////////////////////////////
        // Get contacts
        ///////////////////////////////////////////////////

        if(lstcontactIdsforReintake.size() > 0) 
        {        
            
            ///////////////////////////////
            // Lock Program Plans
            /////////////////////////////// 
                
            utilMethods.lockProgramPlanAll(lstContactIdsforReintake);               
        }
    }
       
    ///////////////////////////////////////////////////////////
    // Method to reinstate clients
    ////////////////////////////////////////////////////////////
    
    public void processReinstatement() {
        
        Integer i = 0;
        Task newExitNotificationTask = new Task(); 
        Task newNextdrugTestTask = new Task();        
        Task tskCCCRS = new Task();
        Task tskCCPN = new Task();
        
        for(Administrative_Actions__c aa :newAdministrativeActions ) 
        {
            
            if(aa.recordTypeId == utilIDs.aaReinstatementLocked) 
            {
                      
                if(aa.Approved__c == 'Yes'
                && oldAdministrativeActions[i].Approved__c != 'Yes') 
                {               
  
                    Set<Id> taskRecTypesToQuery = new Set<Id>();
                    
                    // Limit the tasks by rec type      
                    taskRecTypesToQuery.add(utilIDs.mandatoryClassesTask);
                    taskRecTypesToQuery.add(utilIDs.caseCoordinatorAssessmentTask);
                    taskRecTypesToQuery.add(utilIDs.employmentSurveyTask);
                    taskRecTypesToQuery.add(utilIDs.substanceAbuseAssessmenTask);
                    taskRecTypesToQuery.add(utilIDs.MAYSIAssessmentTask);
                    taskRecTypesToQuery.add(utilIds.PHQ9Task);
                    taskRecTypesToQuery.add(utilIds.UCLATask);
                    taskRecTypesToQuery.add(utilIds.LSCMITask);            
                    taskRecTypesToQuery.add(utilIDs.STARTestReadingTask);
                    taskRecTypesToQuery.add(utilIDs.STARTestMathTask);
                    taskRecTypesToQuery.add(utilIDs.initialProgramPlanTask);
                    taskRecTypesToQuery.add(utilIDs.exitDrugTestTask);
                    taskRecTypesToQuery.add(utilIDs.CBOPlacementTask );
            
            
            // Get all the tasks you may need
            // to update as a result of the reinstatement
            
           
                    for(Task t:mapClients.get(aa.Client__c).Tasks) 
                    {
                    
                    
                        if((t.Status == 'Incomplete' || t.Status == 'Cancelled')
                        && taskRecTypesToQuery.contains(t.RecordTypeId)) 
                        {
                    
                            t.SkipRestrictions__c = true;
                            
                            // Update tasks
                                          
                            if(t.recordTypeId == utilIDs.exitDrugTestTask) 
                            {
                                
                                t.status = 'Not Started';
                                t.Open_Date__c = aa.New_Projected_Exit_Date__c.addDays(-14);
                                t.ActivityDate =  aa.New_Projected_Exit_Date__c;
                                t.Closing_Date__c = null;
                                t.Closed_By__c = null;
                                t.Closed_by_System__c = false;
                            }
                                       
                            else if(t.recordTypeId == utilIDs.CBOPlacementTask)
                            {
                                
                                t.status = 'Not Started';
                                t.Open_Date__c = aa.New_Projected_Exit_Date__c.addDays(-30);
                                t.ActivityDate =  aa.New_Projected_Exit_Date__c;
                                t.Closing_Date__c = null;
                                t.Closed_By__c = null;
                                t.Closed_by_System__c = false;
                            }
                            
                            else {
                                
                                t.status = 'Not Started';
                                t.ActivityDate =  aa.First_Date_Back_in_the_Program__c;
                                t.Closing_Date__c = null;
                                t.Closed_By__c = null;
                                t.Closed_by_System__c = false;
                            }
                            
                            setTaskstoUpdate.add(t);
                        }
                    }
    
            // Create some new tasks
            
                    /// new exit notification task
                    system.debug('\n\n***Creating Exit Notification***');
        
                    newExitNotificationTask = new Task();
                    newExitNotificationTask.whoId = aa.Client__c;
                    newExitNotificationTask.RecordTypeId = utilIDs.exitNotificationTask;
                    newExitNotificationTask.ownerId = mapClients.get(aa.Client__c).case_coordinator__c;
                    newExitNotificationTask.Automatically_Generated__c = true;
                    newExitNotificationTask.Subject = 'Exit Notification';
                    newExitNotificationTask.Open_Date__c = aa.New_Projected_Exit_Date__c;
        
                    //20110616 ebg - activity date is one working day after projected exit date (not just one day)
                    //newExitNotificationTask.ActivityDate = clientToProjectedExitDate.get(thisContact).addDays(1);
                    newExitNotificationTask.ActivityDate = utilMethods.getNextWorkingDayFromDate(aa.New_Projected_Exit_Date__c);                   
                    newExitNotificationTask.SkipRestrictions__c = true;
                    setTaskstoUpdate.add(newExitNotificationTask);     
                
                    /// Next drug test
            
                    newNextdrugTestTask = new Task();
                    newNextdrugTestTask.whoId = aa.Client__c;
                    newNextdrugTestTask.RecordTypeId = utilIDs.nextDrugTestTask;
                    newNextdrugTestTask.OwnerId = csApexDefaults.substance_Abuse_Supervisor__c;
                    newNextdrugTestTask.Automatically_Generated__c = true;
                    newNextdrugTestTask.Subject = 'Next Drug Test';
                    newNextdrugTestTask.Open_Date__c = mapClients.get(aa.Client__c).First_Date_Back_in_the_Program__c;
                    newNextdrugTestTask.ActivityDate = mapClients.get(aa.Client__c).First_Date_Back_in_the_Program__c.addDays(13);    
                    newNextdrugTestTask.SkipRestrictions__c = true;
                    setTaskstoUpdate.add(newNextdrugTestTask);
                
                    
                    // Test for / add CCCRS (BT-106)
                    tskCCCRS = utilMethods.createCCCourtReportNoteTask(mapClients.get(aa.Client__c), null);
                    if(tskCCCRS != null) {
                        setTaskstoUpdate.add(tskCCCRS);
                    }
                    
                    // Test for / add CCPN (BT-106)
                    tskCCPN = utilMethods.createCCProgressNoteTask(mapClients.get(aa.Client__c), null, mapClients.get(aa.Client__c).First_Date_Back_in_the_Program__c.addDays(14));
                    if(tskCCPN != null) {
                        setTaskstoUpdate.add(tskCCPN);
                    }
                
                }
      
            }
            i++; 
        }                 
               
    }
    
    
    /////////////////////////////////////////
    // 20110128 AAB - Changes-ContactObject-RelatedLists 6.b.2nd arrow
    /////////////////////////////////////////
    public void updateCBOClosingDate() 
    {
        

        
        // Get list of open CBO Placement Tasks for this Client
    
        integer i=0;
    
        for(Administrative_Actions__c aa :newAdministrativeActions ) {
            
            String strStatus = null;
            Date dteClosingDate = null;
            
            System.Debug('\n\n*** AA RecordTypeId = ' + aa.RecordTypeId);
            
            if (aa.RecordTypeId == utilIDs.aaExitNotification 
            || aa.RecordTypeId == utilIDs.aaExitNotificationLocked) {
                
                System.Debug('\n\n*** Found an Exit Notification, processing');
                if((isInsert && aa.Task_Status__c != null) ||
                (!isInsert && aa.Task_Status__c != oldAdministrativeActions[i].Task_Status__c)) 
                {
                    strStatus = aa.Task_Status__c;
                    aa.CBO_Closing_Date__c = date.today();

                }
                
                System.Debug('\n\n*** Task Status = ' + aa.Task_Status__c);

                for(Task t : mapClients.get(aa.Client__c).Tasks) {
                
                    if(strStatus != null && t.RecordTypeId == utilIDs.CBOPlacementTask && !t.IsClosed) {
                    
                        if(aa.Task_Status__c != 'Not Started') { 
                            t.Closing_Date__c = date.today(); 
                        }
                        
                        system.debug('\n\n***Inside updateCBOClosingDate.  Setting task status to ' + strStatus);
                        t.Status = strStatus;
                        t.SkipRestrictions__c = true;
                        setTaskstoUpdate.add(t);
                    }
                }
            }
            i++;
        }
        
    }
    
    /////////////////////////////////////////
    // END - Changes-ContactObject-RelatedLists 6.b.2nd arrow
    /////////////////////////////////////////
    
    // 2/1/13 MB: this was previously done in ClassClientStatus but it is being moved to the Before section
    // of the AdminActionsLogic trigger so as to avoid triggering another update of admin action
    public void setAAFieldValues() {
        
        for(administrative_actions__c aa: newAdministrativeActions) {
        
            if(aa.recordtypeId == utilIDs.aaExtension ) {
                //Previous Projected Exit Date
                aa.Previous_Projected_Exit_Date__c = 
                mapClients.get(aa.Client__c).Current_Projected_Exit_Date__c;
            }
        }   
    }

    
    public void processExtension() 
    {
        
        Integer i = 0;
        
        for(Administrative_Actions__c aa :newAdministrativeActions ) 
        {
            
            if(aa.recordTypeId == utilIDs.aaExtension ||
                aa.recordTypeId == utilIDs.aaExtensionLocked) 
                {
                          
                if(aa.Approved__c == 'Yes'
                && oldAdministrativeActions[i].Approved__c != 'Yes') 
                {  
                       
        
                    for(Task t: mapClients.get(aa.Client__c).Tasks) 
                    {
                    
                        if(t.recordTypeId == utilIDs.exitDrugTestTask
                           || t.recordTypeId == utilIDs.exitNotificationTask
                           || t.recordTypeId == utilIDs.CBOPlacementTask) 
                           {
                        
                            t.SkipRestrictions__c = true;
                        
    
                            // Exit notification task 
                            if(t.RecordTypeId == utilIDs.exitNotificationTask) 
                            {
                                
                                t.Open_Date__c = aa.New_Projected_Exit_Date__c;

                                t.ActivityDate = utilMethods.getNextWorkingDayFromDate(aa.New_Projected_Exit_Date__c);                            
                            }
                            
                            // CBO Placement task
                            if(t.RecordTypeId == utilIDs.CBOPlacementTask) 
                            {
                                
                                t.ActivityDate = aa.New_Projected_Exit_Date__c;                           
                            }
                            
                            // Exit Drug Test
                            system.debug('\n\n***Checking Exit Drug Test Task: \n' + t);
                            if(t.RecordTypeId == utilIDs.exitDrugTestTask) {
                                
                                if(t.IsClosed) {
                                    
                                    // Closed Tasks
                                    
                                    if(t.Status == 'Done on Time' || t.Status == 'Done Late'  || t.Status == 'Incomplete' ) {
                                        
                                    
                                        // Administive Actions: 17
                                        //    Exit drug test closing date is before new projected exit date - 14 days 
                                        
                                        if(t.Closing_Date__c < aa.New_Projected_Exit_Date__c.addDays(-14)) {
                                            
                                            t.Status = 'Not Started';
                                            t.Open_Date__c = aa.New_Projected_Exit_Date__c.addDays(-14);
                                            t.ActivityDate = aa.New_Projected_Exit_Date__c;
                                            t.Closing_Date__c = null;
                                            t.Drug_Test_Results__c = null;
                                                                                
                                        }
        
                                        ///////////////////////////////////////////////////
                                        //
                                        // Administive Actions: 16
                                        //    Exit drug test closing date falls between new projected exit date and new projected exit date - 14 days 
                                        //////////////////////////////////////////////////////
        
                                        //NP Exit Date: 9/15/2011
                                        //2 Weeks Prior: 9/1/2011
                                        //Drug Test Closing Date: 9/21/2011
                                        if(aa.New_Projected_Exit_Date__c >= t.Closing_Date__c
                                        && t.Closing_Date__c >= aa.New_Projected_Exit_Date__c.addDays(-14)) {
                                            
                                            t.Open_Date__c = aa.New_Projected_Exit_Date__c.addDays(-14);
                                            t.ActivityDate = aa.New_Projected_Exit_Date__c;
                                            t.Status = 'Done on Time';
        
                                        }
                                        
                                        //    Exit drug test closing date falls after new projected exit date 
                                        if( t.Closing_Date__c > aa.New_Projected_Exit_Date__c) {
                                            
                                            t.Open_Date__c = aa.New_Projected_Exit_Date__c.addDays(-14);
                                            t.ActivityDate = aa.New_Projected_Exit_Date__c;
                                            t.Status = 'Not Started';
                                            t.Closing_Date__c = null;
                                            t.Drug_Test_Results__c = null;
        
                                        }                                
                                        
                                    }
                                    
                                } else {
                                    
                                    // Open Tasks
                                    
                                    t.Open_Date__c = aa.New_Projected_Exit_Date__c.addDays(-14);
                                    t.ActivityDate = aa.New_Projected_Exit_Date__c;
                                  
                                }
                            }
                            
                            setTaskstoUpdate.add(t);
                        
                        }
                    }             
                
            //if(allTasksThatNeedToBeExtended.size() > 0 ) {update allTasksThatNeedToBeExtended;}
                
                    // Course Registration / Enrollment            
                        
                    courseEnrollment clsEnroll = new courseEnrollment();
                    
                    // Loop through Contacts
                    for(Enrollment__c enr : mapClients.get(aa.Client__c).relContactEnrollments__r) {
                        ///////////////////////////////////////////////////////////
                        //Update to Verify that the class is not for a single session class
                        //10/31/2016 DCS MS
                        ///////////////////////////////////////////////////////////
                        if(!enr.Single_Session_Class__c){
                            clsEnroll.strClassId = enr.Class__c;
                            clsEnroll.clCurrent = null;
                            clsEnroll.lstEnrollees.clear();
                            
                            courseEnrollment.clientsForDisplay nClientForDisplay = new courseEnrollment.clientsForDisplay();
                            nClientForDisplay.con = mapClients.get(enr.Client__c);
                            nClientForDisplay.chk = true;
                            nClientForDisplay.bolEnrolled = true;
                            //added 9/27/12 by MB, because bolUseExistingEnrollment is now a variable on ClientsForDisplay. This change was made to bulkify courseEnrollment
                            nClientForDisplay.bolUseExistingEnrollment =  true;
                            //added 10/2/12 by MB, to tell courseEnrollment to not enroll a client in past sessions if this in an Extension
                            nClientforDisplay.isAAExtension = true;
                            nClientforDisplay.OrigExitDate = aa.Previous_Projected_Exit_Date__c;                   
                            clsEnroll.lstEnrollees.add(nClientForDisplay);
                            
                            clsEnroll.enrollClients();
                        }   
                        //update lstContacts;
                    }      
                    
                }
            }
            i++;
        }                        
    }
    
    
    
    ///////////////////////////////////////////////////////////
    // Approved Exit notifications
    ////////////////////////////////////////////////////////////
    
    public void processExitNotification() {
        
        // This check is here to block nPower @future method from invoking this a second time during AA Exit Creation
        if(System.isFuture() == false) { 
              
            Integer i = 0;
            Date dteEarliestExitDate = System.Today();
            //List<Id> contactIdsforExit = new List<Id>();
            //List<Task> rearrestChecksForInsert = new List<Task>();
            
            Boolean bolExit = false;
            //Boolean bol3Mo = false;
            Task newRearesstCheck = new Task();

            
            for(Administrative_Actions__c aa :newAdministrativeActions ) {
            
                bolExit = false;
                for(task t : mapClients.get(aa.Client__c).Tasks) {
                
                    if(t.Subject == 'Rearrest Check - Successful Exit'
                    && (!t.IsClosed 
                    || (t.Re_arrest_Check_Completed_On__c<> null 
                    && t.Re_arrest_Check_Completed_On__c> = system.today().addDays(-5)))) {
                     
                        bolExit = true; 
                    }

                }                
                
    
                if(aa.recordTypeId == utilIDs.aaExitNotification ||
                    aa.recordTypeId == utilIDs.aaExitNotificationLocked) {
    
                ////////////////////////////////////////////////
                // Create a rearrests check when exit notification
                // Admin Action pg 5.3
                ////////////////////////////////////////////////
                
                    if(bolExit == false && ((aa.Exit_Type__c == '(S) Successful Exit/ Graduation' && isInsert) ||
                        (!isInsert && aa.Exit_Type__c == '(S) Successful Exit/ Graduation'  
                        && oldAdministrativeActions[i].Exit_Type__c != '(S) Successful Exit/ Graduation' ))) {
                            
                        newRearesstCheck = new Task();
                        newRearesstCheck.whoId = aa.client__c;
                        newRearesstCheck.recordTypeId = utilIDs.rearrestCheckTask;
                        
                    
                        // Need to test activity date to make sure it does not fall on the weekend
                        
                        // Edited 20110518 AAB Per QC - BT-018
                        //Date currentDTNotificationDate = aa.Exit_Date__c.addDays(1);
                        Date currentDTNotificationDate = System.Today().addDays(1);
                        
                        DateTime cenDTNAsDateTime =  datetime.newInstance(currentDTNotificationDate.Year(), currentDTNotificationDate.Month(),currentDTNotificationDate.Day());
                        String dtDateDay= cenDTNAsDateTime.format('E');
                        
                        if(dtDateDay == 'Sat') {
                            
                            currentDTNotificationDate = currentDTNotificationDate.addDays(2);
                        }
                        
                        
                        if(dtDateDay == 'sun') {
                            
                            currentDTNotificationDate = currentDTNotificationDate.addDays(1);
                        }
                        
                        newRearesstCheck.Open_Date__c = System.today();
                  
                        newRearesstCheck.ActivityDate = currentDTNotificationDate;
                        newRearesstCheck.Subject = 'Rearrest Check - Successful Exit';
                        newRearesstCheck.OwnerId = csApexDefaults.admin_Support_Supervisor__c;
                        // Added 20110601 EBG to assist with enforcing rules of allowable subjects
                        newRearesstCheck.Automatically_Generated__c = true;
                        
                        System.Debug('administrativeActionMethods.testExitNotificationApproval INFO:  Adding Rearrest Check Task ' + newRearesstCheck);
                        
                        setTaskstoUpdate.add(newRearesstCheck);
                       
                    }
        
                        
            
            //////////////////////
            // Contact Loop
            // Pull all open tasks of certain record types and close / cancel them
            //////////////////////


                /// Now I need to loop through all the 
                /// Tasks and set them to closed and status based
                /// on date of exit
    
                //System.debug('allTasksThatNeedToBeClosed size: ' + allTasksThatNeedToBeClosed.size());

                    Set<Id> taskRecTypesToQuery = new Set<Id>();
                    
                    // Limit the tasks by rec type      
                    taskRecTypesToQuery.add(utilIDs.educationAssessmentTask);
                    taskRecTypesToQuery.add(utilIDs.mentalHealthAssessmentTask);
                    taskRecTypesToQuery.add(utilIDs.employmentAssessmentTask);
                    taskRecTypesToQuery.add(utilIDs.exitNotificationTask);
                    taskRecTypesToQuery.add(utilIDs.ccProgressNoteTask);
                    taskRecTypesToQuery.add(utilIds.psProgressNoteTask );
                    taskRecTypesToQuery.add(utilIds.initialProgramPlanTask );
                    taskRecTypesToQuery.add(utilIds.mandatoryClassesTask );            
                    taskRecTypesToQuery.add(utilIDs.caseCoordinatorAssessmentTask);
                    taskRecTypesToQuery.add(utilIDs.careerExplorationReferralTask);
                    taskRecTypesToQuery.add(utilIDs.employmentSurveyTask);
                    taskRecTypesToQuery.add(utilIDs.substanceAbuseAssessmenTask);
                    taskRecTypesToQuery.add(utilIDs.initialDrugTestTask);
                    taskRecTypesToQuery.add(utilIDs.MAYSIAssessmentTask);
                    taskRecTypesToQuery.add(utilIDs.PHQ9Task);
                    taskRecTypesToQuery.add(utilIDs.UCLATask);
                    taskRecTypesToQuery.add(utilIDs.LSCMITask);
                    taskRecTypesToQuery.add(utilIDs.STARTestMathTask);
                    taskRecTypesToQuery.add(utilIDs.STARTestReadingTask);
                    taskRecTypesToQuery.add(utilIDs.ccCRSNoteTask);
                    taskRecTypesToQuery.add(utilIDs.CBOPlacementTask ); 
                    taskRecTypesToQuery.add(utilIDs.psCRSNoteTask );       
                    taskRecTypesToQuery.add(utilIDs.nextDrugTestTask );       
                    taskRecTypesToQuery.add(utilIDs.schoolVisitTask);                                                                                                               
                
                    for(Task t:mapClients.get(aa.Client__c).Tasks) {
                    
                        if((taskRecTypesToQuery.contains(t.RecordTypeId) && !t.isClosed)
                        || t.recordTypeId == utilIDs.exitDrugTestTask) {
                
                    // ACTION SET 1: We do this to all tasks no matter what the status is

                        
                            if( t.RecordTypeId == utilIDs.mandatoryClassesTask || 
                                t.RecordTypeId == utilIDs.caseCoordinatorAssessmentTask ||
                                t.RecordTypeId == utilIDs.employmentSurveyTask ||
                                t.RecordTypeId == utilIDs.substanceAbuseAssessmenTask ||
                                t.RecordTypeId == utilIDs.initialDrugTestTask ||
                                t.RecordTypeId == utilIDs.initialProgramPlanTask  ) {
                               
        
                                
                                if(aa.Action_Date__c > t.activityDate ) {
                                    
                                    /// This means that it is incomplete
                                    t.Status = 'Incomplete';
                                    if(t.Closing_Date__c == null) { 
                                        t.Closing_Date__c = aa.Action_Date__c; 
                                    }
                                                                
                                } else {
                                    
                                    /// This means that it is complete  
                                    t.Status = 'Cancelled';
                                    if(t.Closing_Date__c == null) { 
                                        t.Closing_Date__c = aa.Action_Date__c; 
                                    }
                                    
                                }
                            }   /// EOF First set of Tasks
                        
                            ///////////////////////////////////////////////////
                            //// Second SET OF TASKS
                            ////////////////////////////////////////////////////
                            
                            if( t.RecordTypeId == utilIDs.MAYSIAssessmentTask ||
                                t.RecordTypeId == utilIds.PHQ9Task ||
                                t.RecordTypeId == utilIds.UCLATask ||
                                t.RecordTypeId == utilIds.LSCMITask ||                        
                                t.RecordTypeId == utilIDs.STARTestReadingTask ||
                                t.RecordTypeId == utilIDs.nextDrugTestTask ||
                                t.RecordTypeId == utilIDs.STARTestMathTask ||
                                t.RecordTypeId == utilIDs.schoolVisitTask) {
                                    
                                
                                if(aa.Action_Date__c > t.activityDate ) {
                                    
                                    /// This means that it is incomplete
                                    t.Status = 'Incomplete';
                                    
                                } else {
                                    
                                    /// This means that it is complete  
                                    t.Status = 'Cancelled';
                                }
                                
                                t.Closing_Date__c = aa.Action_Date__c;
                                    
                            } /// EOF second set of Tasks
                            
                            ///////////////////////////////////////////////////
                            //// THIRD SET OF TASKS
                            ////////////////////////////////////////////////////
                            
                            if( t.RecordTypeId == utilIDs.educationAssessmentTask || 
                                t.RecordTypeId == utilIDs.mentalHealthAssessmentTask ||
                                t.RecordTypeId == utilIDs.employmentAssessmentTask ) {
                                    
                                t.Status = 'Incomplete';
                                t.Closing_Date__c = aa.Action_Date__c;
                                    
                            } /// EOF third set of Tasks
                            
                            ///////////////////////////////////////////////////
                            //// Fourth SET OF TASKS
                            ////////////////////////////////////////////////////
                            
                            if( t.RecordTypeId == utilIDs.ccProgressNoteTask ||
                                t.RecordTypeId == utilIDs.psProgressNoteTask ) {
                                   
                                // Logic for BT-097
                                if(aa.Action_Date__c >= t.activityDate ) {
                                    System.Debug('administrativeActionMethods.testExitNotificationApproval INFO:  Setting CRS / CCPN to Incomplete');
                                    t.Status = 'Incomplete';   
                                    t.Closing_Date__c = aa.Action_Date__c;                     
                                } else {
                                    System.Debug('administrativeActionMethods.testExitNotificationApproval INFO:  Setting CRS / CCPN to Cancelled');
                                    t.Status = 'Cancelled';
                                    t.Closing_Date__c = aa.Action_Date__c;
                                }
                                
                                    
                            } /// EOF fourth set of Tasks
                            
                            
                            ///////////////////////////////////////////////////
                            //// Fifth SET OF TASKS
                            ////////////////////////////////////////////////////
                            
                            if( t.RecordTypeId == utilIDs.exitNotificationTask ) {
                                    
                                if(aa.Action_Date__c < t.activityDate ) {
                                    
                                    /// This means that it is incomplete
                                    t.Status = 'Done on Time';
                                    
                                } else {
                                    
                                    /// This means that it is complete  
                                    t.Status = 'Done Late';
                                }
                                
                                // Updated BT-086 AAB 20110606
                                t.Closing_Date__c = System.Today();
                                
                                //code from setExitNotificationTaskDates
                                if(OldAdministrativeActions == null 
                                    || aa.Action_Date__c != OldAdministrativeActions[i].Action_Date__c) {  
                                        
                                    t.OwnerID = mapClients.get(t.whoId).Case_Coordinator__c; 
                                    t.Open_Date__c = aa.Action_Date__c;
                                    t.ActivityDate = utilMethods.getNextWorkingDayFromDate(aa.Action_Date__c);
                                }                                
                                    
                            } /// EOF Fifth set of Tasks
                            
                                    
                            ///////////////////////////////////////////////////////////
                            // All are closed by system
                            // 1/4/13 MB: Not true, record types that aren't dealt with in one of the 5 blocks
                            // were being mistakenly set to closed_by_system= true. Added recordtype filter below
                            ///////////////////////////////////////////////////////////
                            
                            if(t.recordtypeId != utilIDs.careerExplorationReferralTask
                            && t.recordtypeId != utilIDs.ccCRSNoteTask 
                            && t.recordtypeId != utilIDs.CBOPlacementTask 
                            && t.recordtypeId != utilIDs.psCRSNoteTask ) {
                            
                                t.Closed_By_System__c = true;
                            }
                            
                            
                            // ACTION SET 2: IF the status is "unsuccessful" and "transfer"
                       
                            if(aa.Exit_Type__c == '(U) Unsuccessful Exit/ Discharge' || aa.Exit_Type__c == '(T) Transfer') {
                                
                                if( (t.RecordTypeId == utilIDs.exitDrugTestTask &&  !t.isClosed) ||
                                    t.RecordTypeId == utilIDs.CBOPlacementTask
                                     ) {
                                        
                                    t.Status = 'Cancelled';
                                    t.Closing_Date__c = aa.Action_Date__c;
                                    t.Closed_by_system__c = true;
                                        
                                } 
                                
                                if( t.RecordTypeId == utilIDs.careerExplorationReferralTask 
                                && t.ActivityDate < aa.Action_Date__c) {
                                        
                                    t.Status = 'Rejected';
                                    t.Reject_Reason__c = 'Participant Exit';
                                    t.Closing_Date__c = aa.Action_Date__c;
                                    t.Closed_by_system__c = true;
                                        
                                } 
                            }
    
                            
    
                            // ACTION SET 3: IF the status is "(S) Successful Exit/ Graduation "
    
                        
                            /////////////////////////
                            // Edited 20110527 AAB EBG per Quinn/Patrick for BT-069/BT-070
                            /////////////////////////
                        
                            if(aa.Exit_Type__c == '(S) Successful Exit/ Graduation') {
                                if(t.RecordTypeId == utilIDs.exitDrugTestTask) {
                                
                                    // Recalculate open and due dates for the task
                                    Date dteNewOpenDate = aa.Action_Date__c.addDays(-14);
                                    Date dteNewDueDate = aa.Action_Date__c.addDays(1);
                                    String strNewStatus = t.Status;
                                    Date dteNewClosingDate = t.Closing_Date__c;
                                    
                                    // Recalculate task status based on Closing Date
                                    if(dteNewClosingDate < dteNewOpenDate) {
                                        strNewStatus = 'Not Started';
                                        dteNewClosingDate = null;
                                    } else if(dteNewClosingDate >= dteNewOpenDate && dteNewClosingDate <= dteNewDueDate) {
                                        strNewStatus = 'Done on Time';
                                    } else if(dteNewClosingDate > dteNewDueDate && dteNewClosingDate <= dteNewDueDate.addDays(14)) {
                                        strNewStatus = 'Done Late';
                                    } else if(dteNewClosingDate > dteNewDueDate.addDays(14)) {
                                        strNewStatus = 'Incomplete';
                                    }
                                    
                                    // Assign new values to Task Fields
                                    t.Open_Date__c = dteNewOpenDate;
                                    t.ActivityDate = dteNewDueDate;
                                    t.Status = strNewStatus;
                                    t.Closing_Date__c = dteNewClosingDate;
                                    if(dteNewClosingDate != null) {
                                        t.Closed_by_System__c = true;
                                    }                           
                                }
                            }
                            
                            t.SkipRestrictions__c = true;
                            setTaskstoUpdate.add(t);
                        } 
                    }/// EOF of Looping through tasks
                
                
                ///////////////////////////////
                // Set SkipRestrictions Flag on all tasks to TRUE so that system can 
                // properly update them, then commit changes
                ///////////////////////////////
                
                
                //////////////////////////////////////////////
                // BT-278 Updating of Events START (AAB)
                //////////////////////////////////////////////
                

                                
                    // Pull List of Events to update / delete
                    
                                                    
                    if(mapClients.get(aa.Client__c).Exit_Date_1__c != null 
                    && mapClients.get(aa.Client__c).Exit_Date_1__c < aa.Action_Date__c) {
                    
                        dteEarliestExitDate = mapClients.get(aa.Client__c).Exit_Date_1__c;
                    } else {
                        
                        dteEarliestExitDate = aa.Action_Date__c;
                    }                             
                    
                    List<Id> lstEventWhatIds = new List<Id>();
                    for(Event e : mapClients.get(aa.Client__c).Events) { 
                        lstEventWhatIds.add(e.WhatId); 
                    } 
                    
                    Map<Id,Session__c> mapSessionTypes = new Map<Id, Session__c>([SELECT Id, Course_RecordType__c 
                                FROM Session__c WHERE Id IN :lstEventWhatIds]);
                 
                    for(Event e : mapClients.get(aa.Client__c).Events) {
                        
                        if(e.ActivityDate > dteEarliestExitDate) {
                        
                            // 2/12/13 MB: Moved this from inside the unsuccessful/ transfer block. Non-intake court dates
                            // should be closed regardless of the exit type
                            if(e.RecordTypeId == utilIDs.courtDate && e.ActivityDate > aa.Action_Date__c
                            && e.whatId != mapClients.get(aa.Client__c).Intake_Case__c) {
                                    
                                e.Outcome__c = 'No Longer Tracking';
                                e.SkipRestrictions__c = true;
                                setEventstoUpdate.add(e);   
                            }               
                        
                            if(aa.Exit_Type__c == '(S) Successful Exit/ Graduation') {
        
                                // BUSINESS LOGIC:  If exit is approved and type = (S)                      
                                System.Debug('administrativeActionMethods.testExitNotificationApproval INFO:  Processing eventId = ' + e.Id + ' - Successful logic branch');                        
                                
                                // Delete all internal appointments (from list above)
                                if(setInternalAppointments.contains(e.RecordTypeId)) { 
                                    setEventstoDelete.add(e); 
                                }
                                
                                // Delete all Ongoing Course Reg events
                                if(e.whatId != null && mapSessionTypes.containsKey(e.whatId)
                                && mapSessionTypes.get(e.whatId).Course_Recordtype__c == utilIDs.classOngoing) {
                                    setEventstoDelete.add(e);
                                }
                            }
                            
                            if(aa.Exit_Type__c == '(U) Unsuccessful Exit/ Discharge' || aa.Exit_Type__c == '(T) Transfer') {
                                
                                // BUSINESS LOGIC:  If exit is approved and type = (U) or (T)
                                System.Debug('administrativeActionMethods.testExitNotificationApproval INFO:'
                                + ' Processing eventId = ' + e.Id + ' - Unsuccessful or Transfer logic branch'); 
                                if(e.ActivityDate > aa.Action_Date__c) {
                                                                       
                                    if(e.RecordTypeId != utilIDs.courtDate) {
                                        // Just delete.
                                        setEventstoDelete.add(e);
                                    }
                                    
                                }
                            }
                        
                        }
                    }
                    
                    
                    //////////////////////////////////////////////
                    // BT-278 Updating of Events END (AAB)
                    //////////////////////////////////////////////
                    
                    ///////////////////////////////
                    // Update Client Status as well as Exit Date 1 / Exit Date 2
                    ///////////////////////////////
                    

                    
                    ////////////////////////////////////////
                    // Withdraw Client from any Classes
                    ////////////////////////////////////////
                    
                    
                    // Get all Enrollment and Class Ids
                    for(Enrollment__c enr : mapClients.get(aa.Client__c).relContactEnrollments__r) { 
                        
                        if(aa.Exit_Type__c == '(U) Unsuccessful Exit/ Discharge' 
                        || aa.Exit_Type__c == '(T) Transfer'
                        ||(aa.Exit_Type__c == '(S) Successful Exit/ Graduation'
                        && enr.Class_Record_Type__c == utilIDs.classOngoing)) {
                        
                            enr.Client_Class_Status_Field__c = 'Withdrawn';
                            enr.Withdrawn_Date__c = aa.Action_Date__c;
                            enr.Withdrawn_Reason__c = 'Participant Exit';
                            setEnrollmentstoUpdate.add(enr);
                        }
                    }
                    

                }
                i++;               
            }          
        }
    
    }

    
    public void massDML() 
    {
    
        update new list<Event>(setEventstoUpdate);
        delete new list<Event>(setEventstoDelete);
        update mapClients.values();
        upsert new list<Task>(setTaskstoUpdate);
        update new list<Enrollment__c>(setEnrollmentstoUpdate);
    }
 
}