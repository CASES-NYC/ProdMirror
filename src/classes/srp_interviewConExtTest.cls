@isTest(seeAllData=true)
private class srp_interviewConExtTest {
    
    //static utilityIds utilIds = new utilityIds();

    Private Static testmethod void srp_interviewConExtTest()
    {    

        Date referDate1 = Date.newInstance(2006,11,20);

        Account account = new Account();
        account.Name = 'Fname Lname';
        account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        //account.RecordTypeId = utilIds.accClient;
        insert account;
        
        Contact contact = new Contact();
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SRP Client').getRecordTypeId();
        //contact.RecordTypeID = utilIds.conSRP;
        contact.FirstName = 'Test Fname';
        contact.LastName = 'Test Lname';
        contact.Screening_Outcome_srp__c = 'Eligible';
        contact.Arraignment_Outcome__c = 'Released into Supervised Release';        
        contact.accountid = account.id;
        insert contact;

        //Get a Zip Code
        Zip_Code_Mapping__c zipIn = new Zip_Code_Mapping__c(City__c='Elmsford', State__c = 'New York', Name = '10502');
        insert zipIn;
      
        Zip_Code_Mapping__c zip = [select id, Name from Zip_Code_Mapping__c limit 1 ];
        
        Address_Information__c addressInfo = new Address_Information__c();
        addressInfo.Client__c = contact.id;
        addressInfo.Address_Type__c = 'Primary';
        addressInfo.Street__c = 'TEST';
        addressInfo.Move_In_Date__c = referDate1;
        addressInfo.Contact_Person__c = 'TEST';
        addressInfo.Home_Phone__c = '12345';
        addressInfo.Zip_Code__c = zip.id;
        insert addressInfo;

        
        ApexPages.StandardController sc = new ApexPages.StandardController(contact);
        srp_interviewConExt controller = new srp_interviewConExt(sc);
        Test.startTest();
        PageReference pageRef = Page.SRP_Interview_Edit;
        Test.setCurrentPage(pageRef);      
        /*controller.Contactid=contact.id;
        //controller.Caseid=caseInfo.id;
        controller.thisContact = contact;
        //controller.thisCase = caseInfo;
        controller.newProgCycle = newProgCycle;
        controller.progCycleSRP='012210000004JAp';
        */
        controller.saveThis();
        Test.stopTest();
        
    }
    
}