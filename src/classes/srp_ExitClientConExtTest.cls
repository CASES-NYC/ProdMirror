@isTest(seeAllData=true)
private class srp_ExitClientConExtTest 
{

    Private Static testmethod void srp_ExitClientConExtTest()
    {    
        Date referDate1 = Date.newInstance(2006,11,20);

        Account account = new Account();
        account.Name = 'Fname Lname';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        insert account;

        Case_Information__c caseInfo = new Case_Information__c();
        caseInfo.Name = '2000QN234567';
        caseInfo.RecordTypeId = Schema.SObjectType.Case_Information__c.getRecordTypeInfosByName().get('Criminal Court').getRecordTypeId();
        caseInfo.Client_Account__c = account.id;
        insert caseInfo;
                
        Contact contact = new Contact();
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SRP Client').getRecordTypeId();
        contact.FirstName = 'Test Fname';
        contact.LastName = 'Test Lname';
        contact.Screening_Outcome_srp__c = 'Eligible';
        contact.Arraignment_Outcome__c = 'Released into Supervised Release';        
        contact.AccountId = account.id;
        contact.Intake_Case__c = caseInfo.Id;
        insert contact;
       
        Case_Relationship__c caseRel = new Case_Relationship__c();
        caseRel.Docket__c = CaseInfo.Id;
        caseRel.Case_Type__c = 'Intake';
        caseRel.Contact__c = contact.id;
        insert caseRel;

        Program_Cycle__c progCycle = new Program_Cycle__c();
        progCycle.Client__c = contact.id;
        progCycle.Cycle_Type__c = 'Intake';
        progCycle.Start_Date__c = Date.parse('09/15/2016');
        progCycle.End_Date__c = Date.parse('10/15/2016');
        progCycle.RecordTypeId = Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('SRP Program Cycle').getRecordTypeId();
        insert progCycle;

        contact.Most_Recent_Program_Cycle__c = progCycle.Id;
        contact.Intake_Case__c = caseInfo.Id;
        update contact;
        
        Tier__c tier = new Tier__c();
        tier.Start_Date__c = Date.Today();
        tier.Most_Recent_Tier__c = True;
        tier.Program_Cycle__c = progCycle.Id;
        insert tier;            
        
        PageReference pageRef = Page.SRP_Exit_Client;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', contact.Id);
        srp_ExitClientConExt controller = new srp_ExitClientConExt();
        controller.saveThis();         
    
    }
    
}