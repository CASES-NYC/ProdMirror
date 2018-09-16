public without sharing class testData {
 utilityIds utilIds = new utilityIds(); 
 string cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c; 

 public Account accClient {
    get{
    	Account accClient = new Account(
    Name='Unit Tester', RecordTypeId = utilIds.accClient);
   insert accClient;      
   return accClient;
   }
 }

 public  Contact Client {
    get{
    	Account acc = accClient;
    	Contact Client = new Contact(
        firstName = 'Unit', lastName = 'Tester',Court_Rep__c = UserInfo.getUserId(),        
        Drug_test_frequency__c = 'Bi-Weekly',Referral_Date__c = system.today().addDays(-5),
        Eligible__c = 'Yes',Interview_Acceptance_Date__c = system.today().addDays(-3),
        Interview_Outcome__c = 'CEP Accepts',
        Intake_Approved_By__c = userInfo.getUserId(),Intake_Date__c = System.Today(),
        RecordTypeId = cepClient,
        accountId = acc.id); 
   insert Client;      
   return Client;
   }
 }
  
}