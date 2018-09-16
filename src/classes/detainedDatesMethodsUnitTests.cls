@isTest
private class detainedDatesMethodsUnitTests {


    static testMethod void testDetainedDateInsert() {
    
        utilityIds utilIds = new utilityIds();
        
        // Stage Data
        
        Account accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert accClient;
        
        Contact newContactForInsert = new Contact();
        newContactForInsert.lastName = 'Test';
        newContactForInsert.Client_Status__c = 'Active';
        newContactForInsert.Drug_test_frequency__c = 'Bi-Weekly';
        newContactForInsert.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        newContactForInsert.Intake_Date__c = System.Today();
        newContactForInsert.Current_Intake_Date__c = System.Today();
        newContactForInsert.Current_Orientation_Date__c = date.newInstance(2011,1,1);
        newContactForInsert.Current_Exit_Date__c = date.newInstance(2011,7,1);
        newContactForInsert.Team_Leader__c = UserInfo.getUserId();
        newContactForInsert.RecordTypeId = utilIds.conClient;
        newContactForInsert.accountId = accClient.id;
        insert newContactForInsert;
        
        // Execute Test Cases
        
        test.startTest();
        
        // Create Record with Release Date
        Detained_Dates__c releasedDetained = new Detained_Dates__c();
        releasedDetained.Contact_Detained_Dates_Lookup__c = newContactForInsert.Id;
        releasedDetained.Detained_Date__c = date.newInstance(2011,2,1);
        releasedDetained.Detention_Type__c = 'Rehab Participation';
        releasedDetained.Date_Released__c = date.newInstance(2011,4,1);
        insert releasedDetained;
        
        // Create Record with no Release Date
        Detained_Dates__c currentlyDetained = new Detained_Dates__c();
        currentlyDetained.Contact_Detained_Dates_Lookup__c = newContactForInsert.Id;
        currentlyDetained.Detained_Date__c = date.newInstance(2011,2,1);
        currentlyDetained.Detention_Type__c = 'Rehab Participation';
        try {insert currentlyDetained;} catch(Dmlexception e) { /* Keep Going */ }
        
        // Create Record with no Release Date
        Detained_Dates__c currentlyDetainedFail = new Detained_Dates__c();
        currentlyDetainedFail.Contact_Detained_Dates_Lookup__c = newContactForInsert.Id;
        currentlyDetainedFail.Detained_Date__c = date.newInstance(2011,2,1);
        currentlyDetainedFail.Detention_Type__c = 'Rehab Participation';
        try {insert currentlyDetainedFail;} catch(Dmlexception e) { /* Keep Going */ }
        
        // Update Open Record to Closed
        releasedDetained.Date_Released__c = date.newInstance(2011,4,1);
        try {update releasedDetained;} catch(Dmlexception e) { /* Keep Going */ }
        
        // Update Closed Record to Open
        releasedDetained.Date_Released__c = null;
        try {update releasedDetained;} catch(Dmlexception e) { /* Keep Going */ }
        
        test.stopTest();
        

    }
}