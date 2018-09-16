@isTest(seealldata=true)
private class SRP_Reinstatement_UT 
{
    static SRP_ReinstatementConExt srConExt;

    Private Static testmethod void SRP_Reinstatement_UT()
    {    
        Account account = new Account();
        account.Name = 'Fname Lname';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        insert account;
        
        Contact contact = new Contact();
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SRP Client').getRecordTypeId();
        contact.FirstName = 'Test Fname';
        contact.LastName = 'Test Lname';
        contact.Screening_Outcome_srp__c = 'Eligible';
        contact.Arraignment_Outcome__c = 'Released into Supervised Release';        
        contact.accountid = account.id;
        insert contact;
        
        Program_Cycle__c progCycle = new Program_Cycle__c();
        progCycle.Client__c = contact.id;
        progCycle.Cycle_Type__c = 'Intake';
        progCycle.Start_Date__c = Date.parse('09/15/2016');
        progCycle.End_Date__c = Date.parse('10/15/2016');
        progCycle.RecordTypeId = Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('SRP Program Cycle').getRecordTypeId();
        insert progCycle;

        contact.Most_Recent_Program_Cycle__c = progCycle.Id;
        update contact;

        Program_Cycle__c newProgCycle = new Program_Cycle__c();
        
        ApexPages.StandardController stdcon = new ApexPages.StandardController(contact);
        srConExt = new SRP_ReinstatementConExt(stdcon); 
        Test.startTest();
        PageReference pageRef = Page.SRP_Reinstatement;
        Test.setCurrentPage(pageRef);
        srConExt.cancelThis();
        srConExt.saveThis();
        contact.RecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get('DTC Client').getRecordTypeId();
        update contact;
        progCycle.End_Date__c = Date.parse('11/01/2018');
        update progCycle;
        srConExt.saveThis();
        contact.RecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get('CEO Client').getRecordTypeId();
        update contact;
        progCycle.End_Date__c = Date.parse('11/01/2018');
        update progCycle;
        srConExt.saveThis();
        contact.RecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get('CCM Client').getRecordTypeId();
        update contact;
        progCycle.End_Date__c = Date.parse('11/01/2018');
        update progCycle;
        srConExt.saveThis();
        Test.stopTest();
    }	
}