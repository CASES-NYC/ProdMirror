@isTest(SeeAllData=true)
private class toDoPortal_cboPlacement_unitTests {

    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    static Account accClient2 = new Account();
    static Contact con2 = new Contact();
    static Case_Information__c newCaseInfo2 =  new Case_Information__c();    
 
    static testMethod void  cboTests() {
        
  
        utilityIds utilIds = new utilityIds();
            
        User adminUser = [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
        
        accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        accClient2 = new Account(Name='Unit Tester2', RecordTypeId = utilIds.accClient);
        insert new sObject[]{accClient, accClient2};
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2013TN456011';
        newCaseInfo.Borough__c = 'Bronx';
        
        newCaseInfo2 = new Case_Information__c();
        newCaseInfo2.Client_Account__c = accClient2.Id;
        newCaseInfo2.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo2.Name = '2013TN456012';
        newCaseInfo2.Borough__c = 'Bronx';       
        insert new sObject[]{newCaseInfo, newCaseInfo2};        
        
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
        
        con2 = new Contact();
        con2.firstName = 'Unit';
        con2.lastName = 'Tester2';
        con2.Drug_test_frequency__c = 'Bi-Weekly';
        con2.Referral_Date__c = system.today().addDays(-5);    
        con2.Eligible__c = 'Yes';
        con2.Interview_Acceptance_Date__c = system.today().addDays(-3);
        con2.Interview_Outcome__c = 'CEP Accepts';
        con2.Intake_Approved_By__c = userInfo.getUserId();
        con2.Intake_Date__c = System.Today();
        con2.Intake_Case__c = newCaseInfo2.id;
        con2.RecordTypeId = utilIds.conClient;
        con2.accountId = accClient2.id;        
        insert new sObject[]{con, con2};
        update new sObject[]{con, con2};        
        
        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        
        Event thisEvent2 = new Event();
        thisEvent2.RecordTypeId = utilIds.orientationAppointment;
        thisEvent2.whoId = con2.Id;
        thisEvent2.DurationInMinutes = 60;
        thisEvent2.ActivityDate = System.Today();
        thisEvent2.ActivityDateTime = System.now();
        thisEvent2.Verification_Status__c = 'Attended';        
        insert new sObject[]{thisEvent, thisEvent2};
            
        Event courtDate1 = new Event();
        courtDate1.WhatId = newCaseInfo.Id;
        courtDate1.whoId =  con.Id;
        courtDate1.recordTypeID = utilIds.courtDate;
        courtDate1.DurationInMinutes = 60;
        courtDate1.ActivityDateTime = System.Now();
        courtDate1.ActivityDate = System.Today();
        courtDate1.Outcome__c = 'Pending';        
        
        Event courtDate2 = new Event();
        courtDate2.WhatId = newCaseInfo2.Id;
        courtDate2.whoId =  con2.Id;
        courtDate2.recordTypeID = utilIds.courtDate;
        courtDate2.DurationInMinutes = 60;
        courtDate2.ActivityDateTime = System.Now();
        courtDate2.ActivityDate = System.Today();
        courtDate2.Appearance_Required__c = true;
        courtDate2.Outcome__c = 'Pending';
        insert new sObject[]{courtdate1, courtdate2};
        
        
        Test.startTest();
        
        toDoPortal_cboPlacement cboUnitTesting = new toDoPortal_cboPlacement();
        
        cboUnitTesting.getCaseload();
        cboUnitTesting.getClientEvents();
        cboUnitTesting.getExitNotifictionDetails();
        cboUnitTesting.getexitAdminErrors();
        cboUnitTesting.getselectedContact();
        
        
        cboUnitTesting.setselectedContact(con.Id);
        cboUnitTesting.doNothing();
        
        
        cboUnitTesting.setselectedContact(con2.Id);
        cboUnitTesting.doNothing();
        // delete testAA2;
        cboUnitTesting.doNothing();
        
        Test.stopTest();
        
        
    }
}