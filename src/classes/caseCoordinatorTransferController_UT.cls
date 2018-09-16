@isTest(SeeAllData=True)
private class caseCoordinatorTransferController_UT {

    static caseCoordinatorTransferController ext;
    static utilityIds utilIds = new utilityIds();
    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    static Event evt;
    static Task tsk;
    static PageReference pRef;
    
    private static void init(integer caseCoordinatorFlag, integer createTEFlag) {
        
        User userTeamLeader = new User(alias='testtl',email='testuser56@dcs.com',firstname='Test',
            lastname='User',profileid=utilIds.caseCoordinatorStaff,localesidkey='en_US',username='testuser56@dcs.com',
            timezonesidkey='America/Chicago',languagelocalekey='en_US',emailencodingkey='UTF-8');
            
        User userCaseCoordinator = new User(alias='testtl',email='testuser198@dcs.com',firstname='Test',
            lastname='User',profileid=utilIds.caseCoordinatorStaff,localesidkey='en_US',username='testuser198@dcs.com',
            timezonesidkey='America/Chicago',languagelocalekey='en_US',emailencodingkey='UTF-8');
        
        insert userTeamLeader;
        insert userCaseCoordinator;
        
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
        if (caseCoordinatorFlag == 0) {
            // Null conditional - test for NULL Case_Coordinator__c
        }else if (caseCoordinatorFlag == 1) {
            con.Case_Coordinator__c = userCaseCoordinator.Id;
        }        
        
        insert con;
        

        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        insert thisEvent;   

        
        if (createTEFlag == 1) {
        
            // [ Create Event ]
            evt = new Event();
            //evt.RecordTypeId = '';
            evt.Subject = 'Court Date';
            evt.WhoId = con.Id;
            evt.WhatId = newCaseInfo.Id;
            evt.ActivityDate = Date.newInstance(2020,10,11);
            evt.ActivityDateTime = Date.newInstance(2020,10,12);
            evt.DurationInMinutes = 60;
            if (caseCoordinatorFlag == 0) {
                evt.OwnerId = userTeamLeader.Id;
            }
            if (caseCoordinatorFlag == 1) {
                evt.OwnerId = userCaseCoordinator.Id;
            }
            
            insert evt;
            
            // [ Create Open Task ]
            tsk = new Task();
            tsk.Subject = 'Exit Drug Test';
            tsk.WhoId = con.Id;
            tsk.Priority = 'Normal';
            tsk.RecordTypeId = utilIds.exitDrugTestTask;
            //this line added by MB 9/17/12 because this task can no longer be manually generated 
            tsk.Automatically_Generated__c = true;            
            if (caseCoordinatorFlag == 0) {
                tsk.OwnerId = userTeamLeader.Id;
            }
            if (caseCoordinatorFlag == 1) {
                tsk.OwnerId = userCaseCoordinator.Id;
            }
            insert tsk;
            
            // [ Create Closed Task ]
            tsk = new Task();
            tsk.Subject = 'Exit Drug Test';
            tsk.WhoId = con.Id;
            tsk.Priority = 'Normal';
            tsk.Status = 'Completed';
            tsk.RecordTypeId = utilIds.exitDrugTestTask;
            //this line added by MB 9/17/12 because this task can no longer be manually generated 
            tsk.Automatically_Generated__c = true;              
            if (caseCoordinatorFlag == 0) {
                tsk.OwnerId = userTeamLeader.Id;
            }
            if (caseCoordinatorFlag == 1) {
                tsk.OwnerId = userCaseCoordinator.Id;
            }
            insert tsk;
        
        }
        
        ApexPages.CurrentPage().getParameters().put('id',con.id);
        ApexPages.CurrentPage().getParameters().put('name',con.Name);
    
        ApexPages.StandardController controller = new ApexPages.StandardController(con);
        ext = new caseCoordinatorTransferController(controller);
        
        if (caseCoordinatorFlag == 1) {
            ext.newCoordinator = userTeamLeader.Id;
        }
        if (caseCoordinatorFlag == 0) {
            ext.newCoordinator = userCaseCoordinator.Id;
        }
    }
    
    
    static testMethod void testCancel() {
        
        init(0,0);
        
        Test.startTest();
        
        ext.cancelAction();
        
        Test.stopTest();
    }
    
    static testMethod void testMiscVars() {
        
        init(0,0);
        
        Test.startTest();        
        
        // [ Test Disaster Catches ]
        ext.existingCoordinator = '';
        ext.transferRecords();
        
        ext.getCaseCoordStaff();
        ext.getTransferMethods();
        
        // [ Test Blank Case Coordinator ]
        ext.newCoordinator = '';
        ext.transferRecords();
        
        // [ Test Blank Transfer Method ]
        ext.newCoordinator = 'dummy value';
        ext.newTransferMethod = '';
        ext.transferRecords();
        
        ext.init();
        
        Test.stopTest();
    
    }
    
    static testMethod void testTransferIntakeFull() {
        
        init(1,1);
        
        Test.startTest();
               
        ext.newTransferMethod = 'default';
        ext.transferRecords();
        
        Test.stopTest();
    
    }
    
    static testMethod void testTransferIntakePartial() {
        
        init(1,1);
        
        Test.startTest();
        
        ext.newTransferMethod = 'custom';
        ext.transferRecords();
        
        Test.stopTest();
    
    }
    
    static testMethod void testTransferReAssign() {
        
        init(0,1);
        
        Test.startTest();        
        
        ext.transferRecords();
        
        Test.stopTest();
    
    }
    

}