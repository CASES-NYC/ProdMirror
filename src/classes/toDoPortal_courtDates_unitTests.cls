@isTest(SeeAllData=true)
private class toDoPortal_courtDates_unitTests {

	static utilityIds utilIds = new utilityIds();

    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    static User adminUser = new User();

    static testMethod void toDoPortal_courtDates_unitTests() {
    	
    	adminUser = [select id from User where isActive = true and ProfileId = :utilIds.systemAdmin limit 1];
        
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
            
            Event courtDateReminderOne = new Event();
            courtDateReminderOne.WhatId = newCaseInfo.Id;
            courtDateReminderOne.whoId =  con.Id;
            courtDateReminderOne.recordTypeID = utilIds.courtDate;
            courtDateReminderOne.DurationInMinutes = 60;
            courtDateReminderOne.ActivityDateTime = System.Now();
            courtDateReminderOne.ActivityDate = Date.today();
            courtDateReminderOne.Outcome__c = 'Pending';
            insert courtDateReminderOne;
            
            
            Test.startTest();
            
            toDoPortal_courtDates courtDateUnitTests = new toDoPortal_courtDates();
            
            courtDateUnitTests.getCasesTab();
            courtDateUnitTests.getthisPortalFilter();
            courtDateUnitTests.getThisQuery();
            courtDateUnitTests.saveThisTaskFilter();
            courtDateUnitTests.doNothing();
            
            courtDateUnitTests.setThisPortalFilter(courtDateUnitTests.thisPortalFilter);
            
            //////////////////////////////////////////////////////
            //
            // Start Testing different UI options
            //
            //////////////////////////////////////////////////////
            
            courtDateUnitTests.thisPortalFilter.Court_Date_From__c = System.Today().addDays(-3);
            courtDateUnitTests.thisPortalFilter.Court_Date_To__c = System.Today().addDays(100);
            courtDateUnitTests.thisPortalFilter.Active_Clients_Only__c = true;
        
            // Case Coordinator
            courtDateUnitTests.thisPortalFilter.Case_Coordinator__c  = adminUser.Id;
            courtDateUnitTests.getCasesTab();
            
            // Staff
            
            courtDateUnitTests.thisPortalFilter.Court_Staff__c  = adminUser.Id;
            courtDateUnitTests.getCasesTab();
            
            
            Test.stopTest();
            
    }
}