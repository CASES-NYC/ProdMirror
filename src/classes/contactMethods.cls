public with sharing class contactMethods {

    public utilityMethods util = new utilityMethods();
    //public utilityIds utilIDs = new utilityIds();
    public Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
    
    // 3/15/13 MB: added to replace variables passed through methods
    public id     aaExitNotificationLocked    =    Schema.SObjectType.Administrative_Actions__c.getRecordTypeInfosByName().get('Exit Notification - Locked').getRecordTypeId();
    public id     aaReinstatementLocked    =    Schema.SObjectType.Administrative_Actions__c.getRecordTypeInfosByName().get('Re-Instatement - locked').getRecordTypeId();
    public id     aaReintakeLocked    =    Schema.SObjectType.Administrative_Actions__c.getRecordTypeInfosByName().get('Re-Intake - Locked').getRecordTypeId();
    public id     conCCISTART    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CCI START Client').getRecordTypeId();
    public id     conCCM    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CCM Client').getRecordTypeId();
    public id     conCEP    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CEP Client').getRecordTypeId();
    public id     conCJC    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Civic Justice Corps Client').getRecordTypeId();
    public id     conCRT    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CIRT Client').getRecordTypeId();
    public id     conDTC    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('DTC Client').getRecordTypeId();
    public id     conJS    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Justice Scholars Client').getRecordTypeId();
    public id     conBXChoices    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Bronx Choices Client').getRecordTypeId();
    public id     conMNChoices    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Manhattan Choices Client').getRecordTypeId();
    public id     conONE    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('ONE Client').getRecordTypeId();
    public id     conQJC    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Queens Justice Corps Client').getRecordTypeId();
    public id     conTRP    =    Schema.SObjectType.Contact.getRecordTypeInfosByName().get('TRP Client').getRecordTypeId();
    public id     objectiveCIRT    =    Schema.SObjectType.Goal__c.getRecordTypeInfosByName().get('CIRT').getRecordTypeId();
    public id     progCycleCCISTART    =    Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('CCI START Cycle').getRecordTypeId();
    public id     progCycleCCM    =    Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('CCM Program Cycle').getRecordTypeId();
    public id     progCycleCRT    =    Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('CIRT Program Cycle').getRecordTypeId();
    public id     progCycleDTC    =    Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('DTC Program Cycle').getRecordTypeId();
    public id     progCycleONE    =    Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('ONE Program Cycle').getRecordTypeId();
    public id     progCycleTRP    =    Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('TRP Program Cycle').getRecordTypeId();
    public id     progPlanCEP    =    Schema.SObjectType.Program_Plan__c.getRecordTypeInfosByName().get('CEP Program Plan').getRecordTypeId();    
    public id     progPlanCIRT    =    Schema.SObjectType.Program_Plan__c.getRecordTypeInfosByName().get('CIRT Program Plan').getRecordTypeId();
    public id     progPlanSTART    =    Schema.SObjectType.Program_Plan__c.getRecordTypeInfosByName().get('START Program Plan').getRecordTypeId();
    public id     progPlanYouth    =    Schema.SObjectType.Program_Plan__c.getRecordTypeInfosByName().get('Youth Program Plan').getRecordTypeId();
    //public id     taskAlumniSurvey    =    Schema.SObjectType.Task.getRecordTypeInfosByName().get('Alumni Survey').getRecordTypeId();
    public id     taskCboPlacement    =    Schema.SObjectType.Task.getRecordTypeInfosByName().get('CBO Placement').getRecordTypeId();
    public id     taskExitDrugTest    =    Schema.SObjectType.Task.getRecordTypeInfosByName().get('Exit Drug Test').getRecordTypeId();
    public id     taskExitNotification    =    Schema.SObjectType.Task.getRecordTypeInfosByName().get('Exit Notification').getRecordTypeId();

    public List<Contact> newContacts = new List<Contact>();   
    public List<Contact> oldContacts = new List<Contact>();
    public List<RecordType> recTypes = new List<RecordType>();
    public set<Id> setClientRecordTypes = new set<Id>();
    
    public set<Id> setContactIds = new set<Id>();

    public map<Id, Contact> mapClients = new map<Id, Contact>();
    public boolean bolInsert = null;
    
    public void getMap() {
        
        mapClients = new map<Id, Contact>([select id, Client_Status__c, 
            CEP_Num__c, CEP_ID_Imported__c, Exit_Date_1__c, Current_Projected_Exit_Date__c,
            Current_Exit_Date__c, Current_Exit_Type__c, Re_Intake_Date__c, Reinstatement_Date__c,
            Team_Leader__c, Case_Coordinator__c, Exit_Reason__c, Intake_Court_Formula__c, Intake_Case__c,       
            Final_Outcome__c, Referral_Date__c, Mandate_Units__c,
            Intake_Case__r.Defense_Attorney_Law_Guardian__c, Intake_Case__r.Judge__c,
            
            (select id from Contact_Detained_Dates__r where Date_Released__c = null),
            
            (select id, Verification_Status__c, activityDate from Events
            where Subject = 'Orientation Appointment' and Verification_Status__c in ('Attended', 'Late', 'Tardy')
            order by activityDate asc),
            
            (select id, RecordTypeId, Action_Date__c, New_Projected_Exit_Date__c, Exit_Type__c, Exit_Reason__c
            from Administrative_Actions__r
            where RecordType.Name Like '%Locked%' or RecordType.Name Like '%Extension%'
            order by Action_date__c asc),
            
            (select id, Start_Date__c, End_Date__c, Cycle_Type__c, Exit_Type__c, Exit_Reason__c, Exit_Reason_Other__c,
            RecordTypeId, Track__c
            from Program_Cycles__r order by Start_Date__c asc),
            
            (Select SkipRestrictions__c, ActivityDate, Open_Date__c, RecordTypeId, WhoId, IsClosed
            From Tasks
            Where WhoId in :setContactIds 
            // 2/5/13 MB: Only open tasks should be updated
            AND IsClosed = false
            AND (RecordTypeId = :taskExitDrugTest OR 
            RecordTypeId = :taskCboPlacement OR 
            RecordTypeId = :taskExitNotification ))
            
            from Contact where id in :setContactIds]);      
    }
    
    public void createCaseRelationships() 
    {
        integer i = 0;
        set<Id> setContactIdsforCRs = new set<Id>();
        Set<Id> setClientRecordTypes = new Set<Id>();
        for (RecordType recType: recTypes)
        {
            if(recType.SObjectType == 'Contact' && recType.Name == '%Client%')
                setClientRecordTypes.add(recType.Id);
        }//setClientRecordTypes = [SELECT RecordTypeId FROM Contact WHERE RecordType.Name LIKE '%Client'];        
        if(bolInsert) {
        
            for(Contact cNew: newContacts) {
                //if(cNew.RecordTypeId IN :lstClientRecordTypes)            
                if(setClientRecordTypes.contains(cNew.RecordTypeId)
                && (cNew.Client_Status__c == 'Active' || cNew.Client_Status__c == 'Exited'
                || cNew.Client_Status__c == 'On Program Hold')) {
                
                    setContactIdsforCRs.add(cNew.id);
                }
            }
        } else {
        
            for(Contact cNew: newContacts) 
            {
                if(cNew.Intake_Date__c != OldContacts[i].Intake_Date__c
                    || cNew.Exit_Date_1__c != OldContacts[i].Exit_Date_1__c
                    || cNew.Current_Exit_Date__c != OldContacts[i].Current_Exit_Date__c
                    || cNew.Current_Intake_Date__c != OldContacts[i].Current_Intake_Date__c
                    || cNew.Intake_Case__c != OldContacts[i].Intake_Case__c)
                {
                    setContactIdsforCRs.add(cNew.id);
                }  
                         
                i++;
            }      
        }
        
        if(setContactIdsforCRs.size() > 0) 
        {
            list<Id> lstContactIdsforCRs = new list<Id>();
            lstContactIdsforCRs.addAll(setContactIdsforCRs );
            CaseRelationshipFutureMethods.main(lstContactIdsforCRs, null);
        }
    }    
    
    //set the P/C Id as a text field so that it can be searched in the sidebar
    public void setPCIdAdmin() 
    {
        for(Contact cNew: newContacts) 
        {    
            cNew.P_C_ID_Search_admin__c = cNew.P_C_Id__c;
        }
    }
    
    public void checkForProjectedExitDateChange() 
    {
        list<Task> lstTaskstoUpdate = new list<Task>();
        Integer i = 0;
        Date currentDTNotificationDate = system.today();
        DateTime cenDTNAsDateTime =  system.now();
        String dtDateDay= ''; 
        Date currentExitNotificationDate = system.today();
        DateTime cendAsDateTime =  system.now();
        String exitDateDay= '';             
        
        for(Contact thisContact:newContacts) 
        {
            if(thisContact.Current_Projected_Exit_Date__c != null && 
                thisContact.Current_Projected_Exit_Date__c != oldContacts[i].Current_Projected_Exit_Date__c) 
            {
                for(Task thisTask: mapClients.get(thisContact.id).Tasks) 
                {               
                    if(thisTask.RecordTypeId == taskExitDrugTest) 
                    {
                        currentDTNotificationDate = thisContact.Current_Projected_Exit_Date__c;
                        cenDTNAsDateTime =  datetime.newInstance(currentDTNotificationDate.Year(), currentDTNotificationDate.Month(),currentDTNotificationDate.Day());
                        dtDateDay= cenDTNAsDateTime.format('E');
                        if(dtDateDay == 'sat' || dtDateDay == 'Sat') 
                        {
                            currentDTNotificationDate = currentDTNotificationDate.addDays(2);
                        }
                        
                        if(dtDateDay == 'sun' || dtDateDay == 'Sun') 
                        {
                            currentDTNotificationDate = currentDTNotificationDate.addDays(1);
                        }
                    
                    
                        thisTask.Open_Date__c = thisContact.Current_Projected_Exit_Date__c.addDays(-14);
                        thisTask.ActivityDate = currentDTNotificationDate;
                        thisTask.SkipRestrictions__c = true;
                            
                    } else if(thisTask.RecordTypeId == taskCboPlacement) {
                        
                        thisTask.Open_Date__c = thisContact.Current_Projected_Exit_Date__c.addDays(-30);
                        thisTask.ActivityDate = thisContact.Current_Projected_Exit_Date__c;
                        thisTask.SkipRestrictions__c = true;
                            
                    } else if(thisTask.RecordTypeId == taskExitNotification) {
                         
                        currentExitNotificationDate = thisContact.Current_Projected_Exit_Date__c.addDays(1);
                        cendAsDateTime =  datetime.newInstance(currentExitNotificationDate.Year(), currentExitNotificationDate.Month(),currentExitNotificationDate.Day());
                        exitDateDay= cendAsDateTime.format('E');
                         
                        if(exitDateDay.contains('Sat') || exitDateDay.contains('sat')) {
                          
                            currentExitNotificationDate = currentExitNotificationDate.addDays(2);
                        }
                                                    
                        if(exitDateDay.contains('Sun') || exitDateDay.contains('sun')) {
                            currentExitNotificationDate = currentExitNotificationDate.addDays(1);
                        }
                        
                        thisTask.Open_Date__c = thisContact.Current_Projected_Exit_Date__c;
                        thisTask.ActivityDate = currentExitNotificationDate;
                        thisTask.SkipRestrictions__c = true;          
                    }// task IF                            
                }// Task For
                lstTaskstoUpdate.addAll(mapClients.get(thisContact.Id).Tasks);
            }// Contact If
            i++;
        }// Contact for 
        
        if(lstTaskstoUpdate.size() > 0) {
            
            update lstTaskstoUpdate;
        }               
    }// method
    

    public void setClientStatusfromCycle() {
    SYSTEM.DEBUG('************* ENTERING SETCLIENTSTATUSFROM CYCLE *******************');
        
        for(Contact c: newContacts) 
        {
            if(c.RecordTypeId == conDTC || c.RecordTypeId == conCCM || c.RecordTypeId == conTRP
                || c.RecordTypeId == conCRT || c.RecordTypeId == conMNChoices || c.RecordTypeId == conCCISTART
                || c.RecordTypeId == conONE || c.RecordTypeId == conBXChoices) 
            {
SYSTEM.DEBUG('bolInsert: ' + bolInsert);
                if(bolInsert) 
                {
                    //values may be entered in test methods at insert
SYSTEM.DEBUG('CLIENT_STATUS__c: ' + c.CLient_Status__c);
                    if(c.Intake_Case__c == null) 
                    {
                        c.Client_Status__c = 'Missing Intake Case';
                    } else if(c.Client_Status__c == null) 
                        {
                        c.Client_Status__c = 'Incomplete Screening';
                        }
                } else {
                    if(mapClients.get(c.id).Program_Cycles__r.size() > 0) 
                    {
                        //original intake fields
                        c.Intake_Date__c = mapClients.get(c.id).Program_Cycles__r[0].Start_Date__c;
                        c.Original_Exit_Type__c = mapClients.get(c.id).Program_Cycles__r[0].Exit_Type__c;
                        c.Exit_Date_1__c = mapClients.get(c.id).Program_Cycles__r[0].End_Date__c;
                        
                        if(mapClients.get(c.id).Program_Cycles__r[0].RecordTypeId == progCycleDTC) 
                        {
                            c.Mandate_Type__c = 'DTC';
                        } else if(mapClients.get(c.id).Program_Cycles__r[0].RecordTypeId == progCycleCCM) {
                            c.Mandate_Type__c = 'CCM';
                        } else if(mapClients.get(c.id).Program_Cycles__r[0].RecordTypeId == progCycleCCISTART) {
                            c.Mandate_Type__c = 'CCI START';
                        } else if(mapClients.get(c.id).Program_Cycles__r[0].RecordTypeId == progCycleONE) {
                            c.Mandate_Type__c = 'ONE';
                        } else if(mapClients.get(c.id).Program_Cycles__r[0].RecordTypeId == progCycleTRP) {
                            c.Mandate_Type__c = 'TRP';
                        } else if(mapClients.get(c.id).Program_Cycles__r[0].RecordTypeId == progCycleCRT) 
                            {   
                                c.Mandate_Type__c = mapClients.get(c.id).Program_Cycles__r[0].Track__c;
                            }
                    }   
                
                    //current intake fields
                    for(Program_Cycle__c pc: mapClients.get(c.id).Program_Cycles__r) 
                    {
                        c.Current_Intake_Date__c = pc.Start_Date__c;
                        c.Current_Exit_Date__c = pc.End_Date__c;
                        c.Current_Exit_Type__c = pc.Exit_Type__c;
                        if(pc.Exit_Reason__c == 'Other') 
                        {
                            c.Exit_Reason__c = 'Other: ' + pc.Exit_Reason_Other__c;
                        } else {
                            c.Exit_Reason__c = pc.Exit_Reason__c;
                            }
                        
                        if(pc.Cycle_Type__c != 'Voluntary') 
                        {
                            c.PRP_Status__c = pc.Exit_Type__c;
                        }   
                    }
                    
                    if(c.Intake_Case__c == null) 
                    {
                        if(c.Client_Status__c != 'Never Enrolled') 
                        {
                            c.Client_Status__c = 'Missing Intake Case';
                        }
                    } else if(c.Screening_Stage__c == null || !c.Screening_Stage__c.contains('Complete')
                                || c.Current_Intake_Date__c == null) 
                            {
                                if(c.Client_Status__c != 'Never Enrolled') 
                                {
                                    c.Client_Status__c = 'Incomplete Screening';
                                }
                            } else if(c.Current_Intake_Date__c != null) 
                                {
                                    if(c.Current_Exit_Date__c == null) 
                                    {
                                        if(mapClients.get(c.id).Contact_Detained_Dates__r.size() > 0) 
                                        {
                                            c.Client_Status__c = 'On Program Hold';                       
                                        } else 
                                            {                      
                                                c.Client_Status__c = 'Active';
                                            }
                                    } else
                                        {
                                            c.Client_Status__c = 'Exited';
                                        }
                                }
                    }
            }
        SYSTEM.DEBUG('CLIENT STATUS: ' + c.Client_Status__c);
        }       
    }


    //10/15/2012 MB: Set Client Status based on Program Exit Type for CJC/JS clients
    // 2/22/13 MB: Added QJC clients
    // 3/12/13 MB: Do not set if status is Never Enrolled, which may use PRP Status and Exit Reason fields    
    public void setNonCEPClientStatus () {
        
        for(Contact thisContact:newContacts) {
            
            if(thisContact.RecordTypeID == conCJC || thisContact.RecordTypeID == conJS
            || thisContact.RecordTypeID == conQJC) {
                
                if(thisContact.Client_Status__c == 'Never Enrolled') {  
                    //do nothing
                }
                
                else if(thisContact.PRP_Status__c == 'Successful Exit' 
                || thisContact.PRP_Status__c == 'Unsuccessful Exit' 
                || thisContact.PRP_Status__c == 'Other Exit' ) {
                
                    thisContact.Client_Status__c = 'Exited';    
                }
                
                else if(thisContact.PRP_Status__c == null) {
                    
                    thisContact.Client_Status__c = 'Active';
                }
            }
        }       
    }
    
    
    public void createNonCEPProgramPlan() 
    {
        List<Program_Plan__c> lstPPsForInsert = new List<Program_Plan__c>();
        List<Goal__c> lstObjectivesForInsert = new List<Goal__c>();
        
        for(Contact c:newContacts) 
        { // For each Contact
            if(c.recordTypeId == conCEP) 
            { 
                //CEP Program Plans created at Intake                        
                //DO NOTHING
            } else if(c.RecordTypeId == conCRT) 
            {
                //CIRT
                lstPPsForInsert.add(new Program_Plan__c(RecordTypeId = progPlanCIRT,
                                                        Client_Name__c = c.id));
            } else if(c.RecordTypeId == conCCM || c.RecordTypeId == conDTC
                || c.RecordTypeId == conTRP || c.RecordTypeId == conCCISTART) 

            {
                //START
                lstPPsForInsert.add(new Program_Plan__c(RecordTypeId = progPlanSTART,
                                                        Client_Name__c = c.id));            
            } else if(c.RecordTypeId == Utility_Id__c.getValues('SRP Client').RecordType_Id__c) 
            { 
                //SRP
                lstPPsForInsert.add(new Program_Plan__c(RecordTypeId = Utility_Id__c.getValues('SRP Program Plan').RecordType_Id__c,
                                                        Client_Name__c = c.id));                 
            } else if(c.RecordTypeId == Utility_Id__c.getValues('Bronx Choices Client').RecordType_Id__c || c.RecordTypeId == Utility_Id__c.getValues('Manhattan Choices Client').RecordType_Id__c) 
            { 
                //Choices
                lstPPsForInsert.add(new Program_Plan__c(RecordTypeId = Utility_Id__c.getValues('Choices Program Plan').RecordType_Id__c,
                                                        Client_Name__c = c.id));                 
            } else
            {          
                lstPPsForInsert.add(new Program_Plan__c(RecordTypeId = progPlanYouth,
                                                        Client_Name__c = c.id));
            }
        }       
           
        insert lstPPsForInsert;
        
        for(Program_Plan__c pp: lstPPsForInsert) 
        {
            //auto-create SS/CL objective
            if(pp.RecordTypeId == progPlanCIRT) 
            {
                lstObjectivesForInsert.add(new Goal__c(RecordTypeId = objectiveCIRT,
                                                        Program_Plan__c = pp.Id,
                                                        Area__c = 'Community Living',
                                                        Start_Date__c = system.today()));
            }
        }
        
        insert lstObjectivesForInsert;
    }  
    
    
    //////////////////////////////////////////////////////////////
    //
    // 20120913 ebg - BT-036
    // when inserting a record, default the team leader to the
    // current user's manager; if no manager assigned to current
    // user, assign to the current user
    //
    //////////////////////////////////////////////////////////////
    public void setDefaultLeader() {
        User currUser = [Select Id, ManagerId, Username, FirstName, LastName
                        From User 
                        where Id = :userinfo.getUserId() LIMIT 1];
                                
        ID defaultTeamLeader = currUser.Id;
        if (currUser.ManagerId != null) {
            defaultTeamLeader = currUser.ManagerId;
        }
    
        for (Contact c : newContacts) {
            if(c.RecordTypeId != conCEP) {
                c.Team_Leader__c = defaultTeamLeader;
            } 
        }
    }
    
/*
    // 3/15/13 MB: This method added for prod.a.BT-1116
    public void createInitialAlumniSurveyTask() 
    {
        
        list<Task> lstExistingTasksForUpdate = new list<Task>();
        list<Task> lstNewTasks = new list<Task>();
        integer i = 0;
        
        //find existing tasks
        list<Contact> lstContacts = [select id, Current_Exit_Date__c, Highest_Career_Ex_Stage__c,
                            (select id, whoId, activitydate, open_date__c from Tasks
                            where IsClosed = false AND Subject = 'Alumni Survey') 
                            from Contact
                            where Id in :setContactIds];        

        
        //dummy new task
        Task thisTask = new Task();
        
        //find the contacts that need an alumni task created or modified (uncommon)
        for(Contact c: lstContacts) {
            
            if(c.Current_Exit_Date__c != null && c.Highest_Career_Ex_Stage__c == 80) {
                
                //check that some change has occured, either because an exit notification was approved,
                // or the exit date was changed manually (non-CEP), or Career Ex Support Class was graduated
                
                if(c.Current_Exit_Date__c != oldContacts[i].Current_Exit_Date__c
                || oldContacts[i].Highest_Career_Ex_Stage__c != 80) {
                
                    //find contacts that need a new task    
                    if(c.Tasks.size() == 0) {
                        
                        thisTask = new Task();
                        thisTask.WhoId = c.id;
                        thisTask.recordTypeId = taskAlumniSurvey;
                        thisTask.ActivityDate = System.Today().addDays(7); 
                        thisTask.Open_Date__c = System.Today();   
                        thisTask.Automatically_Generated__c = true;
                        thisTask.Subject = 'Alumni Survey';
                        thisTask.ownerId = csApexDefaults.employment_supervisor__c;            
                        thisTask.SkipRestrictions__c = true;
                    
                        lstNewTasks.add(thisTask);  
                    } else {                
                    
                        if(c.Current_Exit_Date__c != oldContacts[i].Current_Exit_Date__c) { //uncommon
                            
                            // modify existing tasks    
                            for(Task t: c.Tasks) {
                                    
                                // set the dates
                                // 10/5/14 MB only running this on Exit Date change
                                // because it is causing task dates to be modified
                                // when program stages are dropped and regenerated during the nightly script
                                // (Highest Career Ex Stage rollup is set to zero then back to 80)
                                    
                                t.ActivityDate = System.Today().addDays(7);
                                t.Open_Date__c = System.Today();
                                t.SkipRestrictions__c = true;
                                lstExistingTasksForUpdate.add(t);
                            }                           
                        }           
                    }
                }
            }
        
            i++;                
        }

        
        //bulk DML
        update lstExistingTasksForUpdate;
        insert lstNewTasks;
        
    }  
*/
  
    
    public void setCEPClientStatus() {
        System_Values__c sv = new System_Values__c();        
        
        for(Contact c: newContacts) {
            
            if(c.RecordTypeId == conCEP) {           
            
                //run a subset of the full contact status logic on insert to check screening stages fields
                if(bolInsert) {
                    
                    if(c.Intake_Case__c == null) {
                            
                        c.Client_Status__c = 'Missing Intake Case';             
                    } else if(c.Final_Outcome_Date__c == null) {
                        
                        c.Client_Status__c = 'Screened';
                    } else if (c.Intake_Date__c == null) {
                                
                        c.Client_Status__c = 'Never Enrolled';
                    } else {
                                
                        c.Current_Intake_Date__c = c.Intake_Date__c;
                        c.Client_Status__c = 'Intaked - Not Yet Active';
                    }
                } else {
                
                    //Orientation Dates
                    if(mapClients.get(c.id).Events.size() == 0) {
                        
                        c.Orientation_Date_1__c = null;
                        c.Orientation_Date_2__c = null;
                        c.Current_Orientation_Date__c = null;               
                    } else if(mapClients.get(c.id).Events.size() == 1) {
                        
                        c.Orientation_Date_1__c = mapClients.get(c.id).Events[0].activityDate;
                        c.Orientation_Date_2__c = null;
                        c.Current_Orientation_Date__c = mapClients.get(c.id).Events[0].activityDate;                   
                    } else {
                        c.Orientation_Date_1__c = mapClients.get(c.id).Events[0].activityDate;
                        c.Orientation_Date_2__c = mapClients.get(c.id).Events[1].activityDate;
                        c.Current_Orientation_Date__c = mapClients.get(c.id).Events[mapClients.get(c.id).Events.size()-1].activityDate;                     
                    }
                    
                    //Projected Exit Date
                    c.Current_Projected_Exit_Date__c = null;
                    
                    if(c.Current_Orientation_Date__c != null) {
                        
                        system.debug('Hello: ' + mapClients.get(c.id).Intake_Court_Formula__c);
                        system.debug('Hello: ' + c.Current_Orientation_Date__c);
                        
                        integer mandatelength = integer.valueof(c.Mandate_Units__c); 

                       c.Current_Projected_Exit_Date__c = c.Current_Orientation_Date__c.addDays(mandatelength);
                        }
                        system.debug('Hello: ' + c.Current_Projected_Exit_Date__c);
                  
                    system.debug('Hello: ' + c.Current_Projected_Exit_Date__c);
                    
                    for(Administrative_Actions__c aa: mapClients.get(c.id).Administrative_Actions__r) {
                        
                        if( aa.New_Projected_Exit_Date__c != null
                        && (c.Current_Projected_Exit_Date__c == null 
                        || aa.New_Projected_Exit_Date__c > c.Current_Projected_Exit_Date__c)) {
                            
                            c.Current_Projected_Exit_Date__c = aa.New_Projected_Exit_Date__c;
                        }
                    }           
                    
                    //Intake Dates
                    // original intake date is now set manually on the contact
                    
                    c.Current_Intake_Date__c = null;
                    
                    if(c.Re_intake_Date__c != null && c.Re_intake_date__c > c.Intake_Date__c) {
                        
                        c.Current_Intake_Date__c = c.Re_intake_Date__c;
                    } else {
                        c.Current_Intake_Date__c = c.Intake_Date__c;
                    }
                    
                    //Exit Dates
                    
                    //to get exit date 1, loop through until we hit an exit
                    // if we hit another, it's exit date 2
                    c.Exit_Date_1__c = null;
                    c.Exit_Date_2__c = null;
                    c.Current_Exit_Date__c = null;
                    
                    //latest exit notification. leave null if there is a reintake/reinstatement afterwards
                    Administrative_Actions__c aaLatest = null;
                    
                    for(Administrative_Actions__c aa: mapClients.get(c.id).Administrative_Actions__r) {
                        
                        if(aa.RecordTypeID == aaExitNotificationLocked) {
                            
                            if(c.Exit_Date_1__c != null) {
                                c.Exit_Date_2__c = aa.Action_Date__c;
                            } else {
                                c.Exit_Date_1__c = aa.Action_Date__c;
                            }
                            
                            aaLatest = aa;   
                        } else if(aa.RecordTypeID == aaReinstatementLocked
                        || aa.RecordTypeID == aaReintakeLocked) {
                        //null out aaLatest if there was a reintake or reinstatement
                            
                            aaLatest = null;
                        }
                    }
                    
                    
                    //current exit date
                    if(aaLatest != null) {
                        
                        c.Current_Exit_Date__c = aaLatest.Action_Date__c;
                        c.Exit_Reason__c = aaLatest.Exit_Reason__c;
                        c.Current_Exit_Type__c = string.valueOf(aaLatest.Exit_Type__c).mid(1,1);
                        if(c.Current_Exit_Date__c != null) {
                        
                            c.Current_Projected_Exit_Date__c = c.Current_Exit_Date__c;
                        }
                    } else {
                        c.Current_Exit_Date__c = null;
                        c.Exit_Reason__c = null;
                        c.Current_Exit_Type__c = null;          
                    }
            

                    //CEP Number        
                    if (c.CEP_Num__c == null && c.Final_Outcome__c == 'Intake'){ 
                                        
                        //Get the CEP Number record from System Values (keeping this inside the client/case loops
                        //to skip this SoQL if un-needed
                        sv = [Select SysFieldValue__c, SysFieldName__c, Id 
                        From System_Values__c where SysFieldName__c = 'CEP Counter'];
                    
                        if(c.CEP_ID_Imported__c != Null) {
                            
                            c.CEP_Num__c = c.CEP_ID_Imported__c.intValue();
                        } else {
                                    
                            //Increment the counter
                            sv.SysFieldValue__c += 1;
                            c.CEP_Num__c = sv.SysFieldValue__c;
                            update sv;
                        }   
                    }

                   
                    //Client Status
                    if(c.Intake_Case__c == null) {
                            
                        c.Client_Status__c = 'Missing Intake Case';             
                    } else if(c.Final_Outcome_Date__c == null) {
                        
                        c.Client_Status__c = 'Screened';
                    } else if(c.Intake_Date__c == null) {
                            
                        c.Client_Status__c = 'Never Enrolled';
                    } 
                    
                    if(c.Current_Exit_Date__c != null) {
                        
                        c.Client_Status__c = 'Exited';
                        
                    } else if (c.Current_Intake_Date__c != null 
                    && (c.Current_Orientation_Date__c == null 
                    || c.Current_Orientation_Date__c < c.Current_Intake_Date__c)) {
                        
                        c.Client_Status__c = 'Intaked - Not Yet Active';
                        
                    } else if(c.Current_Orientation_Date__c != null) {
                        
                        if(mapClients.get(c.id).Contact_Detained_Dates__r.size() > 0) {
                            
                            c.Client_Status__c = 'On Program Hold';
                        } else {
                            c.Client_Status__c = 'Active';
                        }
                    }
                } 
            }
        }    
    }
}