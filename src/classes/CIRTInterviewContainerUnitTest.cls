@isTest (SeeAllData=true)
private class CIRTInterviewContainerUnitTest {

    static Contact contactTest = new Contact(); 
	static utilityIds utilIDs = new utilityIds(); 
    
   static void createTestData() {
   	
   		Account a = new Account();
   		a.Name = 'Test';
   		a.RecordTypeId = utilIds.accClient;
   		insert a;
   	
        contactTest = new Contact();
        contactTest.lastName = 'Lasttest';
        contactTest.firstName = 'firsttest';
        contactTest.recordtypeid = utilIds.conCRT; 
        contactTest.Client_Status__c = '';
        contactTest.Resource_Coordinator_s_Comments__c = 'comments';
        contactTest.Attorney_Consent__c = 'Yes';
        contactTest.AccountId = a.id;
        insert contactTest;
   }

   static testMethod void test1()
      {
        createTestData();
        CIRTInterviewContainerController ai = new CIRTInterviewContainerController();  
        test.startTest();
        ai.c = [SELECT id, FirstName, LastName, Name, P_C_ID__c
                FROM Contact WHERE Id = :contactTest.id limit 1];
                
        String s = ai.getstrURL();      
        test.stopTest();

      }


}