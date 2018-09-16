@isTest
private class employmentMethodsUnitTests {

    static testMethod void testEmploymentUpdateContactRecord() {
    
        utilityIds utilIds = new utilityIds();
        
        // Stage Data
        Account accEmployer = new Account(Name='Employer', RecordTypeId = utilIds.accExternalEntities);        
        
        Account accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert new sObject[]{accClient, accEmployer};
        
        Contact newContactForInsert = new Contact();
        newContactForInsert.lastName = 'Test';
        newContactForInsert.Client_Status__c = 'Active';
        newContactForInsert.Drug_test_frequency__c = 'Bi-Weekly';
        newContactForInsert.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        newContactForInsert.Client_Status__c = 'Active';
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
        
        Employment__c empCase1 = new Employment__c();
        empCase1.Employer__c = accEmployer.Id;
        empCase1.Client__c = newContactForInsert.Id;
        empCase1.Employment_Type__c = 'Unemployed';
        empCase1.Start_Date__c = date.newInstance(2000, 1, 1);
        //empCase1.End_Date__c = date.newInstance(2010, 12, 31);
        empCase1.Job_Title__c = 'Chief Yak Herder';
        insert empCase1;
        
        Employment__c empCase2 = new Employment__c();
        empCase2.Employer__c = accEmployer.Id;
        empCase2.Client__c = newContactForInsert.Id;
        empCase2.Employment_Type__c = 'Unemployed';
        empCase2.Start_Date__c = date.newInstance(2000, 1, 1);
        empCase2.End_Date__c = date.newInstance(2010, 12, 31);
        empCase2.Reason_for_Leaving__c = 'Other';
        empCase2.Reason_for_Leaving_Other__c = 'Yak shortages';
        empCase2.Job_Title__c = 'Chief Yak Herder';
        insert empCase2;
        
        test.stopTest();
        
    }
}