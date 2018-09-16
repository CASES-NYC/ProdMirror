@isTest(SeeAllData=true)
private class toDoPortal_tasks_unitTests {

	static utilityIds utilIds = new utilityIds();

    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
 
    static testMethod void toDoPortal_tasks_unitTests() {   
        
        User adminUser = [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
            
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
        update con;
        

        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        insert thisEvent;          
        
                    
        Test.startTest();
        
        
        toDoPortal_tasks portalTasksTesting = new toDoPortal_tasks();
        
        portalTasksTesting.getCaseload();
        portalTasksTesting.getcaseloadDivInitialClass();
        portalTasksTesting.getQUery();
        portalTasksTesting.getselectedCaseLoad();
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Staff';
        portalTasksTesting.getstaffDivInitialClass();
        portalTasksTesting.getthisPortalFilter();
        portalTasksTesting.gettoDoItems();
        portalTasksTesting.gettoDoSelection();
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Unit';
        portalTasksTesting.getunitDivInitialClass();
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Unit';
        portalTasksTesting.saveThisTaskFilter();
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Caseload';
        portalTasksTesting.saveThisTaskFilter();
        portalTasksTesting.getcaseloadDivInitialClass();
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Staff';
        portalTasksTesting.saveThisTaskFilter();
        
        portalTasksTesting.settoDoObject(portalTasksTesting.toDoObject);
        
        
        portalTasksTesting.setSelectedCaseLoad('test');
        portalTasksTesting.determineColor(System.Today().addDays(-10));
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Caseload';
        portalTasksTesting.caseLoadSelection = adminUser.Id;
        portalTasksTesting.getToDoTasksTab();
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Unit';
        portalTasksTesting.getToDoTasksTab();
        
        portalTasksTesting.toDoObject.Filter_By__c = 'Staff';
        portalTasksTesting.toDoObject.OwnerId =  adminUser.Id;
        portalTasksTesting.getToDoTasksTab();
        
        
        portalTasksTesting.toDoItems.add(utilIds.employmentSurveyTask);
        portalTasksTesting.settoDoSelection(portalTasksTesting.toDoItems);
        portalTasksTesting.getToDoTasksTab();
        
        //now test when a filter exists for the current user
        Portal_Filter__c pf = new Portal_Filter__c();
        pf.OwnerId = UserInfo.getUserId();
        pf.Name = 'test it';
        pf.Filter_By__c = 'Caseload';
        pf.Tasks_To_Do_Selection__c = 'how about this';
        insert pf;
        
        portalTasksTesting = new toDoPortal_tasks();
            
    
        Test.stopTest();
    }
}