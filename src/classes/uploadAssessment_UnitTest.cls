@isTest(SeeAllData=true)
private class uploadAssessment_UnitTest {
    static utilityIds utilIDs = new utilityIds();	
	static UtilityFileMethods uf = new UtilityFileMethods();
    static Account accCep1 = new Account();	
//	static Assessment__c assTest = new Assessment__c();
	static AssessmentContainer__c assTest = new AssessmentContainer__c();
	static Contact contactTest = new Contact();
    static Case_Information__c newCaseInfo1 =  new Case_Information__c();
    static string ccmclient = Utility_ID__c.getValues('CCM Client').RecordType_Id__c;    
    static string ccmid;
	static Blob csvFileBody;
 //   static Blob csvFileBody;
 
   static void createAssessmentTestData() {
   	    
   	    accCep1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        insert accCep1;
 	    
        newCaseInfo1 = new Case_Information__c();
        newCaseInfo1.Client_Account__c = accCep1.Id;
        newCaseInfo1.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo1.Name = '2015TN456011';
        newCaseInfo1.Borough__c = 'Bronx';
        insert newCaseInfo1;   
 
 	    contactTest = new Contact();
        contactTest.lastName = 'Lasttest'; 
        contactTest.firstName = 'firsttest';
        contactTest.Client_Status__c = 'Active';
        contactTest.recordtypeid = ccmclient; 
        contactTest.Current_Intake_Date__c = System.Today()- 30;
        contactTest.accountId = accCep1.id;   
        contactTest.Intake_Case__c = newCaseInfo1.id;   
        insert contactTest;
        ccmid = contactTest.id;
        
        assTest = new AssessmentContainer__c();
   	    assTest.client__c = contactTest.id;
        assTest.Assessment_Completed_on__c = date.today();
        insert assTest;}
         
   static testMethod void testLSCMI()
   {  createAssessmentTestData();
   	   uploadAssessmentController csv = new uploadAssessmentController();
  	   uf.idForTestCCM = ccmid;
  	   csv.csvFileBody = uf.generateCSV_forLSMI();
   	   csv.csvFile = 'LSCMI';
  	   test.startTest();  
   	   csv.readcsvLSCMI();
 	   csv.csvFile = 'LSCMI ABH';
   	   csv.readcsvLSCMI();
   	   test.stopTest();}
    
  static testMethod void test_LSIR()
   {   createAssessmentTestData();
   	   uploadAssessmentController csv = new uploadAssessmentController();
  	   uf.idForTestCCM = ccmid;   	   
   	   csv.csvFileBody = uf.generateCSV_forLSIR();
   	   csv.csvFile = 'LSIR';
  	   test.startTest();  
   //
   //    readcsvLSCMI();
   	//   csv.readcsvLSIR();
   	   csv.readcsvFile('LSIR');
   	   test.stopTest();}

    static testMethod void testfix()
     { 
   	   uploadAssessmentController csv = new uploadAssessmentController();
   	   test.startTest();  
   	   csv.fixString('ttt,yyyy,mmmmmmmmm') ;
   	   csv.fixString('ttt,nnnn,"yyyy,oooooo,kkk"') ;
   	   test.stopTest();}
/*   
    static testMethod void test3()
     { 
   	   uploadAssessmentController csv = new uploadAssessmentController();
   	   test.startTest();  
   	   csv.fixString('ttt,nnnn,"yyyy,oooooo,kkk"') ;
   	   test.stopTest();}
  
  static testMethod void test_TABE(){
  	   createAssessmentTestData();
  	   uploadAssessmentController_new csv = new uploadAssessmentController_new();
   	   uf.idForTestCCM = ccmid;
   	   csv.csvFileBody = uf.generateCSV_forTABE(); 
   	   csv.csvFile = 'TABE';
  	   test.startTest();  
       csv.readcsvTABE();
   	   test.stopTest();} 
  */  	   
}