@isTest (SeeAllData=true)
private class assessDispatchUnitTest 
{
    static id conSRP = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SRP Client').getRecordTypeId();
    static id acctClient = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    static id assessUCPT = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('UCLA PTSD DSM V').getRecordTypeId();     

    static testMethod void assessDispatchUnitTest() 
    {
        Account account = new Account(Name = 'Fname Lname', RecordTypeId = acctClient);
        insert account;
 
        Contact contact = new Contact();
        contact.RecordTypeId = conSRP;
        contact.FirstName = 'Test Fname';
        contact.LastName = 'Test Lname';
        contact.Screening_Outcome_srp__c = 'Eligible';
        contact.Arraignment_Outcome__c = 'Released into Supervised Release';
        contact.AccountId = account.Id;      
        insert contact;


        Assessment__c ptsd = new Assessment__c(RecordTypeId = assessUCPT, Contact__c = contact.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(ptsd);
        string contactID = contact.Id;        
        
        PageReference pageRef = Page.dispatchAssessNew;        
        pageRef.getParameters().put('RecordType',assessUCPT);
        pageRef.getParameters().put('CF00N60000001rJHg_lkid',contact.Id);
        Test.setCurrentPage(pageRef);  
        dispatchAssessNewCon newcon = new dispatchAssessNewCon(sc);       
        newcon.redirect();
        
        PageReference pageRef1 = Page.CEP_ICD_Assessment_New;
        pageRef1.getParameters().put('RecordType', assessUCPT);
        pageRef1.getParameters().put('CF00N60000001rJHg_lkid',contactId);              
        Test.setCurrentPage(pageRef1);
        ApexPages.StandardController sdn = new ApexPages.StandardController(ptsd);
        assessPreloadCon newAsmt = new assessPreloadCon(sdn);
        insert ptsd;

        String ptsdId = ptsd.Id;
        PageReference pageRef2 = Page.dispatchAssessView;
        pageRef2.getParameters().put('Id', ptsdId);
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController sdv = new ApexPages.StandardController(ptsd);
        dispatchAssessViewCon viewcon = new dispatchAssessViewCon(sdv);
        viewcon.redirect();
        
        PageReference pageRef3 = Page.dispatchAssessEdit;
        pageRef3.getParameters().put('Id', ptsdId);
        Test.setCurrentPage(pageRef3);
        ApexPages.StandardController sde = new ApexPages.StandardController(ptsd);
        dispatchAssessEditCon editcon = new dispatchAssessEditCon(sde);
        editcon.redirect(); 

        newAsmt.saveAssessment();
        newAsmt.LockRecord();
    }                  
}