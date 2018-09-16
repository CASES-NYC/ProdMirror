@isTest
private class EducationMethodsUnitTests {

    static testMethod void testEducationUpdate() {
        
        utilityIds utilIds = new utilityIds();
        
        // Stage Data
        
        Account accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert accClient;
        
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
        
        Education__c eduCase2 = new Education__c();
        eduCase2.Client__c = newContactForInsert.Id;
        eduCase2.Diploma_Type__c = 'GED Program';
        eduCase2.Institution_Type__c = 'GED Program';
        eduCase2.Start_Date__c = date.newInstance(2000, 1, 1);
        insert eduCase2;
        
        Education__c eduCase1 = new Education__c();
        eduCase1.Client__c = newContactForInsert.Id;
        eduCase1.Diploma_Type__c = 'High School Diploma';
        eduCase1.Institution_Type__c = 'High School';
        eduCase1.Reason_for_Leaving__c = 'Graduated';
        eduCase1.Start_Date__c = date.newInstance(2000, 1, 1);
        eduCase1.End_Date__c = date.newInstance(2004, 1, 1);
        insert eduCase1;
        
        Education__c eduCase3 = new Education__c();
        eduCase3.Client__c = newContactForInsert.Id;
        eduCase3.Diploma_Type__c = 'GED Diploma';
        eduCase3.Institution_Type__c = 'GED Program';
        eduCase3.Reason_for_Leaving__c = 'Graduated';
        eduCase3.Start_Date__c = date.newInstance(2000, 1, 1);
        eduCase3.End_Date__c = date.newInstance(2004, 1, 1);
        insert eduCase3;
        
        test.stopTest();
        
    }
}