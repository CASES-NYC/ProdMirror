@isTest(SeeAllData = true)
private class eventMethodsUnitTests {
    
    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    
    static utilityIds utilIds = new utilityIds();    
    
    static void initCore() {
        
        // Stage Data
        
        accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert accClient;
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2013TN456011';
        newCaseInfo.Borough__c = 'Bronx';
        insert newCaseInfo;        
        
        con = new Contact();
        con.firstName = 'Unit';
        con.lastName = 'Tester';
        con.Drug_test_frequency__c = 'Bi-Weekly';
        con.Referral_Date__c = system.today().addDays(-5);
        con.Eligible__c = 'Yes';
        con.Interview_Acceptance_Date__c = system.today().addDays(-3);
        con.Interview_Outcome__c = 'CEP Accepts';
        con.Intake_Approved_By__c = userInfo.getUserId();
        con.Intake_Date__c = System.Today();
        con.Intake_Case__c = newCaseInfo.id;
        con.RecordTypeId = utilIds.conClient;
        con.accountId = accClient.id;       
        
        insert con;
        

        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        insert thisEvent;            
    } 

    static testMethod void testEventMethodsInsert() {
        
        utilityMethods utilMethods = new utilityMethods();
        
        // Init Core Records
        initCore();
        
        Program_Plan__c ProgramPlan = [select id from Program_Plan__c where Client_Name__c = :con.id];
        
        // Start Test Cases
        test.startTest();        
        
        // Progress Note A
        Progress_Note__c pnA = new Progress_Note__c();
        pnA.Program_Plan__c = ProgramPlan.Id;
        pnA.RecordTypeId = utilIds.progressNoteCCPN;
        pnA.Progress_Note__c = 'This is a test Progress Note';
        insert pnA;
        
        // Attempt to create a second PN Task
        utilMethods.createCCProgressNoteTask(con, null,null); 
        
        // Create Court Case
        Event evtCourt = new Event();
        evtCourt.WhoId = con.Id;
        evtCourt.WhatId = newCaseInfo.Id;
        evtCourt.RecordTypeId = utilIds.courtDate;
        evtCourt.OwnerId = UserInfo.getUserId();
        evtCourt.StartDateTime = date.newInstance(2011,4,1);
        evtCourt.EndDateTime = date.newInstance(2011,4,2);
        evtCourt.Outcome__c = 'Pending';
        evtCourt.Court_Report_Required__c = true;
        evtCourt.Report_Type__c = 'Progress';
        evtCourt.ActivityDate = Date.today();
        insert evtCourt;
        
        // Update Court Case
        evtCourt.Outcome__c = 'Adjourned';
        evtCourt.Serious_Non_Compliance__c = 'None';
        update evtCourt;
       
        // Stop Test Cases
        test.stopTest();
        
    }
    
    ////////////////////////////////////////////////////
    //
    // TI - Unit tests for Event bad subjects
    //
    ////////////////////////////////////////////////////
    
     static testMethod void processSubjectsTests() {

        // Stage data

        
        Account testAccount = new Account();
        testAccount.name = 'test';
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.lastName = 'test';
        testContact.accountId = testAccount.Id;
        insert testContact;
        
        Event testSubjectEvent = new Event();
        testSubjectEvent.subject = 'TEASAS';
        testSubjectEvent.DurationInMinutes = 60;
        testSubjectEvent.ActivityDateTime = System.now();
        testSubjectEvent.whoId = testContact.Id;
        testSubjectEvent.RecordTypeId = utilIds.educationExternal;
        testSubjectEvent.ActivityDate = Date.today();
        
        Test.startTest();
        
        try {
            
            insert testSubjectEvent;
        
        } catch (DmlException e) {
           
            System.assert( e.getMessage().contains('Please choose one of the predefined subjects to save this event'));
                 
        } 
        
        Test.stopTest();
     
     }
      
    static testMethod void processEventVerification() {
        
        initCore();        
        
        Test.startTest();
        
        Event courtDateReminderOne = new Event();
        courtDateReminderOne.WhatId = newCaseInfo.Id;
        courtDateReminderOne.whoId =  con.Id;
        courtDateReminderOne.recordTypeID = utilIds.courtDate;
        courtDateReminderOne.DurationInMinutes = 60;
        courtDateReminderOne.ActivityDateTime = System.Now();
        courtDateReminderOne.Outcome__c = 'Pending';
        courtDateReminderOne.Verification_status__c = 'test';
        courtDateReminderOne.ActivityDate = Date.today();
        insert courtDateReminderOne;
        
        Test.stopTest();
    }
    
    //added 6/11/13 MB for START
    static testMethod void DTCMandateCounters() {
        
        //clients- accounts
        Account accClient1 = new Account(Name = 'Test Contact 1', RecordTypeId = utilIds.accClient); 
        
        //dml
        insert new sObject[]{accClient1};            
        
        //clients- contacts
        Contact c1 = new Contact(LastName = 'Test Contact 1', recordtypeid = utilIds.conDTC, 
        AccountId = accClient1.id); 
        
        
        //dml
        insert new sObject[]{c1};                   
        
        //program cycles
        Program_Cycle__c c1pc1 = new Program_Cycle__c(Client__c = c1.id, Cycle_Type__c = 'Intake', 
        Mandatory_Sessions_Required__c = 5, Start_Date__c = system.today().addDays(-30), 
        Compliance_Date__c = system.today().addDays(-15), RecordTypeId = utilIds.progCycleDTC);
        
        Program_Cycle__c c1pc2 = new Program_Cycle__c(Client__c = c1.id, Cycle_Type__c = 'Reinstatement', 
        Mandatory_Sessions_Required__c = 6, Start_Date__c = system.today().addDays(-6), Compliance_Date__c = system.today(),
        RecordTypeId = utilIds.progCycleDTC);         
        
        //dml
        insert new sObject[]{c1pc1, c1pc2};
        
        
        //Events
        // c1pc1
        Event c1pc1e1 = new Event(whoId = c1.id, subject = 'Program Reporting', recordTypeId = utilIds.caseCoordination,
        activityDateTime = system.now().addDays(-25), activityDate = system.today().addDays(-25), 
        verification_status__c = 'Attended', DurationinMinutes = 15);

        Event c1pc1e2 = new Event(whoId = c1.id, subject = 'Program Reporting', recordTypeId = utilIds.caseCoordination,
        activityDateTime = system.now().addDays(-17), activityDate = system.today().addDays(-17), 
        verification_status__c = 'Not Verified', DurationinMinutes = 15);
        
        Event c1pc1e3 = new Event(whoId = c1.id, subject = 'Case Coordinator Counseling', recordTypeId = utilIds.caseCoordination,
        activityDateTime = system.now().addDays(-20), activityDate = system.today().addDays(-20), 
        verification_status__c = 'Attended', DurationinMinutes = 15, Description = 'Testing'); 
        
        //c1pc2
        Event c1pc2e1 = new Event(whoId = c1.id, subject = 'Program Reporting', recordTypeId = utilIds.caseCoordination,
        activityDateTime = system.now().addDays(-5), activityDate = system.today().addDays(-5), 
        verification_status__c = 'Attended', DurationinMinutes = 15);    
        
        Event c1pc2e2 = new Event(whoId = c1.id, subject = 'Program Reporting', recordTypeId = utilIds.caseCoordination,
        activityDateTime = system.now().addDays(-2), activityDate = system.today().addDays(-2), 
        verification_status__c = 'Attended', DurationinMinutes = 15);                                        
                
        //dml
        insert new sObject[]{c1pc1e1, c1pc1e2, c1pc1e3, c1pc2e1, c1pc2e2};
        
        //requery program cycles 
        map<Id, Program_Cycle__c> results = new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c1pc1.id or id = :c1pc2.id]);
                                            
        //test values                                   
        system.assertEquals(results.get(c1pc1.id).Mandatory_Sessions_Completed__c, 1);
        //system.assertEquals(results.get(c1pc2.id).Mandatory_Sessions_Completed__c, 2);
        
        //test DTC/CCM updates, and "needs to be verified" trp status
        
        c1pc1e2.Verification_Status__c = 'Late';
        
        //dml
        update new sObject[]{c1pc1e2};
        
        //requery program cycles 
        map<Id, Program_Cycle__c> results2 = new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c1pc1.id]);
                                            
        //test values                                   
        system.assertEquals(results2.get(c1pc1.id).Mandatory_Sessions_Completed__c, 2);  
          
        
        test.startTest(); 
        
        // test deletes

        // delete new sObject[]{c1pc2e1, c1pc2e2};
        
        //requery program cycles 
        /* map<Id, Program_Cycle__c> results5= new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c1pc1.id or id = :c1pc2.id]);
         */                                   
        //test values           
        //system.assertEquals(results5.get(c1pc2.id).Mandatory_Sessions_Completed__c, 0);   
        
        test.stopTest();
                    
    }   
    
    //10/28/13 START mandate counter test method broken into 3
    static testMethod void CCMMandateCounters() {
        
        //clients- accounts
        Account accClient1 = new Account(Name = 'Test Contact 1', RecordTypeId = utilIds.accClient);
                
        //dml
        insert new sObject[]{accClient1};            
        
        //clients- contacts
        
        Contact c3 = new Contact(LastName = 'Test Contact 3', recordtypeid = utilIds.conCCM, 
        AccountId = accClient1.id);     
        
        
        //dml
        insert new sObject[]{c3};                   
        
        //program cycles
        
        Program_Cycle__c c3pc1 = new Program_Cycle__c(Client__c = c3.id, Cycle_Type__c = 'Intake', 
        Mandatory_Sessions_Required__c = 3, Start_Date__c = system.today().addDays(-6), Compliance_Date__c = system.today(),
        RecordTypeId = utilIds.progCycleCCM);           
        
        //dml
        insert new sObject[]{c3pc1};
        
        
        //Events        
        //c3pc1 
        Event c3pc1e1 = new Event(whoId = c3.id, subject = 'Education', 
        recordTypeId = utilIds.caseCoordinationCCM, verification_status__c = 'Late', Type__c = 'Face to Face',
        activityDateTime = system.now().addDays(-4), activityDate = system.today().addDays(-4), 
        Location__c = 'This Program Site', DurationinMinutes = 60, Description = 'hello');   
        
        Event c3pc1e2 = new Event(whoId = c3.id, subject = 'Education', 
        recordTypeId = utilIds.caseCoordinationCCM, verification_status__c = 'Attended', Type__c = 'Collateral',
        activityDateTime = system.now().addDays(-2), activityDate = system.today().addDays(-2), 
        DurationinMinutes = 50, Description = 'bonanza!'); 
        
        Event c3pc1e3 = new Event(whoId = c3.id, subject = 'Education', 
        recordTypeId = utilIds.caseCoordinationCCM, verification_status__c = 'Attended', Type__c = 'Face to Face',
        activityDateTime = system.now().addDays(-3), activityDate = system.today().addDays(-3), 
        Location__c = 'This Program Site', DurationinMinutes = 20, Description = 'banana',  Apply_to_Mandate_Override__c = 'Yes');
        
        Event c3pc1e4 = new Event(whoId = c3.id, subject = 'Education', 
        recordTypeId = utilIds.caseCoordinationCCM, verification_status__c = 'Attended', Type__c = 'Face to Face',
        activityDateTime = system.now().addDays(-4).addHours(2), activityDate = system.today().addDays(-4), 
        Location__c = 'This Program Site', DurationinMinutes = 60, Description = 'righteous!');                              
                
        //dml
        insert new sObject[]{c3pc1e1, c3pc1e2, c3pc1e3, c3pc1e4};
        
        //requery program cycles 
        map<Id, Program_Cycle__c> results = new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c3pc1.id]);
                                            
        //test values                                   
        //system.assertEquals(results.get(c3pc1.id).Mandatory_Sessions_Completed__c, 2);
                    
    }       
    
    
    //added 6/11/13 MB for START
    static testMethod void TRPMandateCounters() {
        
        //clients- accounts

        Account accClient2 = new Account(Name = 'Test Contact 2', RecordTypeId = utilIds.accClient);   
        
        //dml
        insert new sObject[]{accClient2};            
        
        //clients- contacts
        
        Contact c2 = new Contact(LastName = 'Test Contact 2', recordtypeid = utilIds.conTRP, 
        AccountId = accClient2.id);
              
        
        //dml
        insert new sObject[]{c2};                   
        
        //program cycles
        Program_Cycle__c c2pc1 = new Program_Cycle__c(Client__c = c2.id, Cycle_Type__c = 'Intake', 
        Start_Date__c = system.today().addDays(-10), RecordTypeId = utilIds.progCycleTRP);          
        
        //dml
        insert new sObject[]{c2pc1};
        
        
        //Events                             
        //c2pc1

        Event c2pc1e1 = new Event(whoId = c2.id, subject = 'Test Class', recordTypeId = utilIds.courseCatalogClass,
        Class_Category__c = 'TRP One Day Session',verification_status__c = 'Not Verified', 
        activityDateTime = system.now().addDays(4), activityDate = system.today().addDays(4), DurationinMinutes = 60);                  
                
        //dml
        insert new sObject[]{c2pc1e1};
        
        //requery program cycles 
        map<Id, Program_Cycle__c> results = new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c2pc1.id]);
                                            
        //test values                                   
        system.assertEquals(results.get(c2pc1.id).Next_Class_Date__c, system.today().addDays(4));
        system.assertEquals(results.get(c2pc1.id).TRP_Class_Status_RPT__c,  'Scheduled');
        
        //test DTC/CCM updates, and "needs to be verified" trp status
        
        c2pc1e1.ActivityDateTime = system.now().addDays(-2);
        c2pc1e1.ActivityDate = system.today().addDays(-2);
        
        //dml
        update new sObject[]{c2pc1e1};
        
        //requery program cycles 
        map<Id, Program_Cycle__c> results2 = new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c2pc1.id]);
                                            
        //test values                                   
        system.assertEquals(results2.get(c2pc1.id).Next_Class_Date__c, system.today().addDays(-2));
        system.assertEquals(results2.get(c2pc1.id).TRP_Class_Status_RPT__c,  'Needs to be Verified');   
        
        //remaining tests are all TRP. Check the exit code  
        c2pc1e1.Verification_Status__c = 'Excused';
        update c2pc1e1;
        
        //requery program cycles 
        map<Id, Program_Cycle__c> results3 = new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c2pc1.id]);
                                            
        //test values                                   
        system.assertEquals(results3.get(c2pc1.id).Next_Class_Date__c, null);
        system.assertEquals(results3.get(c2pc1.id).TRP_Class_Status_RPT__c,  'Unsuccessful');     
        
        test.startTest();
                    
        //enter new appointment to make sure that "attended" status is not overwritten
        c2pc1e1.Verification_Status__c = 'Attended';
        
        Event c2pc1e2 = new Event(whoId = c2.id, subject = 'Test Class', recordTypeId = utilIds.courseCatalogClass,
        Class_Category__c = 'TRP One Day Session',verification_status__c = 'Not Verified', 
        activityDateTime = system.now().addDays(-1), activityDate = system.today().addDays(-1), DurationinMinutes = 60);
        upsert new Event[]{c2pc1e1, c2pc1e2};       
        
        //requery program cycles 
        map<Id, Program_Cycle__c> results4 = new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c2pc1.id]);
                                            
        //test values                                   
        system.assertEquals(results4.get(c2pc1.id).Next_Class_Date__c, null);
        system.assertEquals(results4.get(c2pc1.id).TRP_Class_Status_RPT__c,  'Successful');  
        
        //delete attended appt and move unverified beyond scope of program cycle (testing "needs to be scheduled" status)
        c2pc1e2.ActivityDateTime = system.now().addDays(-13);
        c2pc1e2.ActivityDate = system.today().addDays(-13);
        update c2pc1e2;
        //delete new sObject[]{c2pc1e1};
        
        //requery program cycles 
        /*map<Id, Program_Cycle__c> results5= new map<Id, Program_Cycle__c>([select id, Mandatory_Sessions_Completed__c, 
                                            Next_Class_Date__c, TRP_Class_Status_RPT__c 
                                            from Program_Cycle__c 
                                            where id = :c2pc1.id]);
                                            
        //test values            
        system.assertEquals(results5.get(c2pc1.id).Next_Class_Date__c, null);
        system.assertEquals(results5.get(c2pc1.id).TRP_Class_Status_RPT__c,  'Needs to be Scheduled');   
        */
        test.stopTest();
                    
    }       
    
    //added 6/11/13 MB for START
    static testMethod void testChoicesComplianceCounter() {
             
        //clients- accounts
        Account accClient1 = new Account(Name = 'Test Contact 1', RecordTypeId = utilIds.accClient); 
        
        Account accClient2 = new Account(Name = 'Test Contact 2', RecordTypeId = utilIds.accClient);         
        
        //dml
        insert new sObject[]{accClient1, accClient2};            
        
        //clients- contacts
        Contact c1 = new Contact(LastName = 'Test Contact 1', recordtypeid = utilIds.conBXChoices, 
        AccountId = accClient1.id);
        
        Contact c2 = new Contact(LastName = 'Test Contact 2', recordtypeid = utilIds.conMNChoices, 
        AccountId = accClient2.id);     
        
        
        //dml
        insert new sObject[]{c1, c2};                   
        
        //program cycles
        Program_Cycle__c c1pc1 = new Program_Cycle__c(Client__c = c1.id, Cycle_Type__c = 'Intake', 
        Start_Date__c = system.today().addDays(-30), RecordTypeId = utilIds.progCycleChoices);      
        
        Program_Cycle__c c2pc1 = new Program_Cycle__c(Client__c = c2.id, Cycle_Type__c = 'Intake', 
        Start_Date__c = system.today().addDays(-10), RecordTypeId = utilIds.progCycleChoices);          
        
        //dml
        insert new sObject[]{c1pc1, c2pc1};
        
        test.startTest();
        
        //Events
        //c1
        Event c1e1 = new Event(whoId = c1.id, subject = 'Program Reporting', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now(), 
        activityDate = system.today(),  verification_status__c = 'Unexcused');

        Event c1e2 = new Event(whoId = c1.id, subject = 'Curfew', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now(), 
        activityDate = system.today(),  verification_status__c = 'Unverified');
        
        Event c1e3 = new Event(whoId = c1.id, subject = 'Program Reporting', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-1), 
        activityDate = system.today().addDays(-1),  verification_status__c = 'Excused');
        
        Event c1e4 = new Event(whoId = c1.id, subject = 'Program Reporting', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-2), 
        activityDate = system.today().addDays(-1),  verification_status__c = 'Attended');
        
        Event c1e5 = new Event(whoId = c1.id, subject = 'Curfew', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-2), 
        activityDate = system.today().addDays(-2),  verification_status__c = 'Unexcused');
        
        Event c1e6 = new Event(whoId = c1.id, subject = 'Curfew', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-3), 
        activityDate = system.today().addDays(-5),  verification_status__c = 'Unexcused');    
        
        Event c1e7 = new Event(whoId = c1.id, subject = 'Curfew', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-4), 
        activityDate = system.today().addDays(-5),  verification_status__c = 'Attended');  
        
        //c2
        Event c2e1 = new Event(whoId = c2.id, subject = 'Curfew', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(1), 
        activityDate = system.today().addDays(1),   verification_status__c = 'Not Verified');       
        
        Event c2e2 = new Event(whoId = c2.id, subject = 'Curfew', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-3), 
        activityDate = system.today().addDays(-3),  verification_status__c = 'Attended');
        
        Event c2e3 = new Event(whoId = c2.id, subject = 'Program Reporting', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-3), 
        activityDate = system.today().addDays(-3),  verification_status__c = 'Unexcused');       
                                                                                        
        Event c2e4 = new Event(whoId = c2.id, subject = 'Program Reporting', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-5), 
        activityDate = system.today().addDays(-5),  verification_status__c = 'Attended');    
        
        Event c2e5 = new Event(whoId = c2.id, subject = 'Program Reporting', DurationinMinutes = 15,
        recordTypeId = utilIds.caseCoordination, activityDateTime = system.now().addDays(-7), 
        activityDate = system.today().addDays(-7),  verification_status__c = 'Excused');            
                            
        //dml
        insert new sObject[]{c1e1, c1e2, c1e3, c1e4, c1e5, c1e6, c1e7, c2e1, c2e2, c2e3, c2e4, c2e5};
        
        //requery contacts
        map<Id,Contact> result = new map<Id, Contact>([select id, Consecutive_Days_Non_Compliant__c 
            from Contact where id in(:c1.id, :c2.id)]);
                
                                            
        //test values                                   
        system.assertEquals(result.get(c1.id).Consecutive_Days_Non_Compliant__c , 4);
        system.assertEquals(result.get(c2.id).Consecutive_Days_Non_Compliant__c , 1);   
        
        
        //test deletes and updates
        //delete c1e6;
        c1e5.Verification_Status__c = 'Attended';
        update c1e5;    
        
        Contact result2 = [select id, Consecutive_Days_Non_Compliant__c 
            from Contact where id = :c1.id limit 1];
            
        system.assertEquals(result2.Consecutive_Days_Non_Compliant__c, 2);  
        
        test.stopTest();
    }    
}