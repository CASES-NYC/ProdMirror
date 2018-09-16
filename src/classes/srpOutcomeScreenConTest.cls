@isTest (seeAllData=True)
private class srpOutcomeScreenConTest 
{
    //static utilityIds utilIds = new utilityIds();

    Private Static testmethod void srpOutcomeScreenConTest()
    {    

        Account account = new Account();
        account.Name = 'Fname Lname';
        //account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        account.RecordTypeId = Utility_ID__c.getValues('Client').RecordType_Id__c;
        insert account;
        
        Contact contact = new Contact();
        //contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SRP Client').getRecordTypeId();
        contact.RecordTypeID = Utility_ID__c.getValues('SRP Client').RecordType_Id__c;
        contact.FirstName = 'Test Fname';
        contact.LastName = 'Test Lname';
        contact.Screening_Outcome_srp__c = 'Eligible';
        contact.Arraignment_Outcome__c = 'Released into Supervised Release';        
        contact.accountid = account.id;
        insert contact;
        
        Case_Information__c caseInfo = new Case_Information__c();
        caseInfo.Name = '2000QN234567';
        //caseInfo.RecordTypeId = Schema.SObjectType.Case_Information__c.getRecordTypeInfosByName().get('Criminal Court').getRecordTypeId();
        caseInfo.RecordTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
        caseInfo.Client_Account__c = account.id;
        insert caseInfo;
        
        Program_Cycle__c newProgCycle = new Program_Cycle__c();
        Event nextCourtDate = new Event();
        nextCourtDate.whoId = contact.id;
        nextCourtDate.Subject = 'Court Date';
        nextCourtDate.RecordTypeId = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
        nextCourtDate.WhatId = caseInfo.id;  
        nextCourtDate.DurationInMinutes = 60; 
        nextCourtDate.ActivityDate = system.today().addDays(-1);       
        nextCourtDate.ActivityDateTime = 
            DateTime.newInstance(nextCourtDate.ActivityDate, Time.newInstance(12,0,0,0));
            
        insert nextCourtDate;  
        
    
        srpOutcomeScreenCon controller = new srpOutcomeScreenCon();
        Test.startTest();
        PageReference pageRef = Page.srpOutcomeScreen;
        Test.setCurrentPage(pageRef);      
        controller.Contactid=contact.id;
        controller.Caseid=caseInfo.id;
        controller.thisContact = contact;
        controller.thisCase = caseInfo;
        controller.newProgCycle = newProgCycle;
        controller.progCycleSRP= Utility_ID__c.getValues('SRP Program Cycle').RecordType_Id__c;
        controller.doNothing();
        controller.goPortal();
        controller.nextCourtDate = nextCourtDate;
        controller.saveOutcome();
        Test.stopTest();
        
    }
    
}