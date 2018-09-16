@isTest (SeeAllData=true)
private class AssessmentSectionController_UnitTest{
  static testData th = new testData();
  static Contact testClient = new Contact();
   static AssessmentContainer__c cnt = new AssessmentContainer__c();
  static Map<string,string> mapAssCodePage = new Map<string,string>();
    static Map<string,string> mapNameCode  = new Map<string,string>();
    static AssessmentContainer__c cont = new AssessmentContainer__c();
    static BJMHS__c BJMHS = new BJMHS__c();
     static CRAFFT__c CRAFFT{get;set;}  
    static ID clientId,assmId,assmId1;
    private static void createTestData() {
        testClient = new Contact();
       testClient = th.client; 
       clientId = testClient.id;
       //**** BJMHS      
     cnt = new AssessmentContainer__c();
     cnt.assessmentCode__c = mapNameCode.get('BJMHS');
     cnt.assessmentName__c = 'BJMHS';
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = clientId;    
     insert cnt;   
      assmId = cnt.id;  
  
      BJMHS = new BJMHS__c(AssessmentContainerId__c = assmId,Q1_Mind_Control__c = 'Yes',Q2_Mind_Reading__c = 'Yes',Q3_weight_Gain__c = 'Yes',
      Q6_Feel_Sinful__c = 'Yes',Survey_Notes__c = 'Yes');
      insert BJMHS;
  
    //* 	CRAFFT
      cnt = new AssessmentContainer__c();
     cnt.assessmentCode__c = mapNameCode.get('CRAFFT');
     cnt.assessmentName__c = 'CRAFFT';
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = clientId;    
     insert cnt;   
     assmId1 = cnt.id;
     CRAFFT = new CRAFFT__c();
     CRAFFT.AssessmentContainerId__c = assmId1; 
     insert CRAFFT;
    }  
     static testMethod void testSection(){
     	createTestData();
 	      PageReference pageRef = Page.AssessmentSectionPage;
       Test.setCurrentPageReference(pageRef);
      ApexPages.StandardController sc = new ApexPages.standardController(testClient);
        test.startTest(); 
      AssessmentSectionController ext = new  AssessmentSectionController(sc);
      ext.contactId = clientId;
      ext.client = testClient;
       test.stopTest();    
     }
}