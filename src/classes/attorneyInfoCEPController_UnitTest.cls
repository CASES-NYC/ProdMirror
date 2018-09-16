@isTest (SeeAllData=true)
private class attorneyInfoCEPController_UnitTest {
  
    static utilityIds utilIds = new utilityIds();
    static Account accountTest = new Account();
    static Account accountAtt = new Account();
   static Account accountJudge = new Account();
    static Case_Information__c caseTest = new Case_Information__c();
    static Contact contactTest = new Contact();
    static Contact contactJudge = new Contact();
    static Contact ContactDefAtt = new Contact();
    static contact Affiliation = new Contact();
    static void createTestData()
  {     
        accountTest = new Account();
        accountTest.name = 'Pavel Bure';
        accountTest.RecordTypeId = utilIds.accClient;
        accountTest.NYSID_Number__c = '90978021U';
        accountTest.DOB__c = Date.newInstance(1970,1,1);
        insert accountTest;

        accountAtt = new Account();
        accountAtt.name = 'Bill Oh';
        accountAtt.RecordTypeId = utilIds.accExternalEntities;
        insert accountAtt;        
        
        accountJudge = new Account();
        accountJudge.name = 'Bill Oh';
        accountJudge.RecordTypeId = utilIds.accExternalEntities;
        insert accountJudge;        



       contactJudge = new Contact();
       contactJudge.RecordTypeId = utilIds.conJudge  ;
       contactJudge.FirstName = 'Bill';
       contactJudge.lastName = 'Oh';
       contactJudge.RecordTypeId = utilIds.conAttorney;
       contactJudge.AccountId = accountJudge.id;
       insert contactJudge;
        
       ContactDefAtt = new Contact();
       ContactDefAtt.FirstName = 'Bill';
       ContactDefAtt.lastName = 'Oh';
       ContactDefAtt.RecordTypeId = utilIds.conAttorney;
       ContactDefAtt.AccountId = accountAtt.id;
       insert ContactDefAtt;
        
        caseTest = new Case_Information__c();
        caseTest.Client_Account__c = accountTest.Id;
        caseTest.RecordTypeId = utilIds.caseInfoCriminalCourt;
        caseTest.Name = '2011BV144590';
        caseTest.Borough__c = 'Bronx';
        caseTest.Defense_Attorney_Law_Guardian__c = ContactDefAtt.id;
        caseTest.Affiliation__c = ContactDefAtt.id;
        caseTest.Prosecutor__c = ContactDefAtt.id; 
        caseTest.Judge__c = ContactJudge.id; 
        caseTest.Probation_Officer__c = ContactDefAtt.id; 
        caseTest.Prosecutor__c = ContactDefAtt.id; 
        caseTest.PSI_Officer__c = ContactDefAtt.id;
        caseTest.Probation_Officer__c = ContactDefAtt.id;
        caseTest.PSI_Officer__c = ContactDefAtt.id;
        insert caseTest;


       ContactTest = new Contact();
       ContactTest.FirstName = 'Pavel';
       ContactTest.lastName = 'Bure';
       ContactTest.Client_Status__c = 'Incomplete Screening';
       ContactTest.PRP_Status__c = 'Successful Exit';
       ContactTest.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
       ContactTest.Team_Leader__c = utilIds.defaultTaskAssignedTo;
       ContactTest.AccountId = accountTest.id;
       ContactTest.Intake_Case__c = caseTest.id;
       ContactTest.Referral_Date__c = date.newInstance(2011,2,1);
       ContactTest.RecordTypeId = utilIds.conDTC; 
       insert ContactTest;
  
  }
     static testMethod void test_1()
      {
        createTestData();
 
           test.startTest();
          attorneyInfoCEPController att = new attorneyInfoCEPController(); 
          att.strCase = caseTest.id;
          att.thisContact = ContactTest; 
          att.thisCase = CaseTest;
          att.thisContact.id = ContactTest.id;
          att.thisCase.id = CaseTest.Id;
          PageReference pr = att.goAttorneyConsent(); 
          pr = att.goPortal();
          test.stopTest();
      }
      static testMethod void test_2() {
        createTestData();
        test.startTest();
        PageReference ref = new PageReference('/apex/allcourtsPage');
        Test.setCurrentPage(ref); 
        test.stopTest();
     }
     
     static testMethod void test_3() {
        createTestData();
         PageReference pageRef = Page.attorneyInfo_CEP;
        pageRef.getParameters().put('case',CaseTest.id);
        pageRef.getParameters().put('contact',ContactTest.id);
        Test.setCurrentPageReference(pageRef);
        attorneyInfoCEPController att = new attorneyInfoCEPController(); 
        test.startTest();
        // att.goPortal();
         att.doNothing();
         att.updateAttorneyInfo();
         test.stopTest();
           }
}