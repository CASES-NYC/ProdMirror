@isTest
private class AddressInformationMethodsUnitTests {

    
    static testMethod void testAddressInsert() {
        
        utilityIds util = new utilityIds();
        
        // Create some sample dates for insert commands
        Date birthDate1 = Date.newInstance(1976,11,20);
        Date referDate1 = Date.newInstance(2006,11,20);
        Address_Information__c adinfo1;
        
        //Create client account
        Account accClient = new Account(Name = 'Unit Tester', RecordTypeId = util.accClient);
        insert accClient;

        //Create a Test Client
        Contact testContact = new Contact(FirstName = 'Unit', LastName = 'Tester', AccountId = accClient.Id, 
        Birthdate = birthDate1, RecordTypeID = util.conClient );  
        insert testContact;
        
        //Get a Zip Code
       Zip_Code_Mapping__c zipIn = new Zip_Code_Mapping__c(City__c='Elmsford', State__c = 'New York', Name = '10502');
       insert zipIn;
      
        Zip_Code_Mapping__c zip = [select id, Name from Zip_Code_Mapping__c limit 1 ];

        //Attempt to insert TWO Primary Addresses, only one should go through
        Address_Information__c adinfo2;
        try {
            adinfo1 = new Address_Information__c(Client__c = testContact.Id, Address_Type__c = 'Primary', 
            Street__c = 'TEST', Contact_Person__c = 'TEST', Move_In_Date__c = referDate1, Home_Phone__c = '12345', 
            Zip_Code__c = zip.id);
            insert adinfo1;
            adinfo2 = new Address_Information__c(Client__c = testContact.Id,  Address_Type__c = 'Primary', 
            Street__c = 'TEST', Contact_Person__c = 'TEST', Move_In_Date__c = referDate1, Zip_Code__c = zip.id);
            insert adinfo2;
        } catch(Exception e) {
            // We don't really need to do anything with the exception since we are doing a dup test
            System.debug('Address Info Exception = ' + e);
        }
        
        Integer i = 0;

        //Now let's check to see how many Primary addresses exist for our test client
        
        System.debug('Test Contact ID = ' + testContact.id);

        for (Address_Information__c a : [SELECT Id FROM Address_Information__c 
               WHERE (Address_Type__c = 'Primary')
               AND Client__c = :testContact.Id]) {
            i++;
        }

        //Ensure that the query returned the expected number of
        //contacts.

        System.assertEquals(1, i);
        
        //Make sure the Home Phone was populated
        testContact = [Select Id, HomePhone from Contact where Id = :testContact.Id];
        System.assertEquals('12345', testContact.HomePhone);
        
        //Delete address should delete home phone in Contact 
        delete adinfo1;
        testContact = [Select Id, HomePhone from Contact where Id = :testContact.Id];
        System.assertEquals(null, testContact.HomePhone);
        
    }       
    
}