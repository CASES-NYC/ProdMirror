@isTest (SeeAllData=true)
private class assessmentMigation_1_UnitTest {
	static testData th = new testData();
    static Contact con = new Contact();
    static Assessment__c assessm = new Assessment__c();
    static Assessment__c assessm1 = new Assessment__c();
    static string cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c; 
    static Assessment_Legacy__c assessmLeg = new Assessment_Legacy__c();

    static List<Assessment__c> lstAssm = new List<Assessment__c>();
    static List<AssessmentContainer__c> lstCont = new List<AssessmentContainer__c>();
    static List<AssessmentContainer__c> lstCont1 = new List<AssessmentContainer__c>();

    
    static Case_Information__c newCaseInfo =  new Case_Information__c();
//    static RecordType //rec = new RecordType();
//    static RecordType rec1 = new RecordType();
    static string recId,recid1,assessmentCode,clientId,accountId;
    static  Map<string,string> mapRecType = new Map<string,string>();
    static  Map<string,string> mapRecTypeLegacy = new Map<string,string>();
    static Map<string,string> mapAssCodePage = new Map<string,string>();
    static Map<string,string> mapNameCode  = new Map<string,string>();
    static ID recIdfromAssessment_1,recIdfromAssessment_2;
    static AssessmentContainer__c cont = new AssessmentContainer__c();
    static AssessmentContainer__c contLeg = new AssessmentContainer__c();
    static AssessmentContainer__c cont1 = new AssessmentContainer__c();
    
    private static void createTestData() {
        Con = new Contact();
        Con = th.client; 
       clientId = con.id;
         mapRecType = new Map<string,string>();
        for (RecordType r : [Select id,developername,name from RecordType where SobjectType =: 'Assessment__c']){
          mapRecType.put(r.name.trim(),r.id);
        }
        mapRecTypeLegacy =  new Map<string,string>();
        for (RecordType r : [Select id,developername,name from RecordType where SobjectType =: 'Assessment_Legacy__c']){
          mapRecTypeLegacy.put(r.name.trim(),r.id);
        }
        
       for (assessmentList__c lu :[Select assessmentName__c,name,pageName__c,programs__c
         From assessmentList__c where isActive__c =: true order by assessmentName__c]){
        mapNameCode.put(lu.assessmentName__c.trim(),lu.name);}
    } 
 
   static testMethod void test_LEC(){
       createTestData(); 
 
    recId = mapRecType.get('Life Events Checklist (LEC)');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;   
   recIdfromAssessment_1 = assessm.id;      
       
   Life_Events_Checklist__c le = new Life_Events_Checklist__c();
   le.participant__c = con.id;
   le.AssessmentId__c = recIdfromAssessment_1;
   insert le;
   recIdfromAssessment_2 = le.id;
  
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'Life Events Checklist (LEC)';
   assessmentCode = mapNameCode.get('Life Events Checklist (LEC)');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_2; 
   insert cont; 
           
     AssessmentMigration_1 migr = new AssessmentMigration_1();
     test.startTest();
     migr.aValue =  'Life Events Checklist (LEC)';
     migr.doMigration();
     test.stopTest();
   }
 //
 
      static testMethod void test_sr(){
       createTestData();      
 
      recId = mapRecType.get('SR Intake Needs Assessment');
      assessm = new Assessment__c();
      assessm.Contact__c = con.id;
      assessm.Assessment_Completed_on__c = System.today();
      assessm.RecordTypeId = recId;
      insert assessm;   
      recIdfromAssessment_1 = assessm.id;      
 
    recIdfromAssessment_1 = assessm.id; 
     SR_Intake_Needs_Assessment__c srp = new SR_Intake_Needs_Assessment__c();
       srp.participant__c = con.id;
       srp.AssessmentId__c = recIdfromAssessment_1;
      insert srp;
      recIdfromAssessment_2 = srp.id;
  
     cont = new AssessmentContainer__c();
     cont.assessmentName__c = 'SRP Intake';
     assessmentCode = mapNameCode.get('SRP Intake');
     cont.assessmentcode__c = assessmentCode;
     cont.client__c = con.id;
     cont.recIdFromassessment__c = recIdfromAssessment_2; 
     insert cont;
     AssessmentMigration_1 migr = new AssessmentMigration_1();
     test.startTest();
    migr.aValue =  'SRP Intake';
   migr.doMigration();
  test.stopTest();
      } 
 
   static testMethod void test_HW(){
    	   createTestData();
 
    recId = mapRecType.get('Health and Wellbeing Assessment');
   //rec = new RecordType();
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;   
   recIdfromAssessment_1 = assessm.id;      
       
       Health_and_Wellbeing_Assessment__c le = new Health_and_Wellbeing_Assessment__c();
       le.participant__c = con.id;
       le.AssessmentId__c = recIdfromAssessment_1;
       insert le;
       recIdfromAssessment_2 = le.id;
  
     cont = new AssessmentContainer__c();
     cont.assessmentName__c = 'Health and Wellbeing';
     assessmentCode = mapNameCode.get('Health and Wellbeing');
     cont.assessmentcode__c = assessmentCode;
     cont.client__c = con.id;
     cont.recIdFromassessment__c = recIdfromAssessment_2; 
     insert cont;
  
    AssessmentMigration_1 migr = new AssessmentMigration_1();
     test.startTest();
     migr.aValue = 'Health and Wellbeing';
     migr.doMigration();
      test.stopTest();
     }
 
 
  
  //  Education
       static testMethod void testLegacy_Education(){
  	   createTestData();
 
    recId = mapRecTypeLegacy.get('Education Assessment'); 
   //rec = new RecordType();
   assessmLeg = new Assessment_Legacy__c(); 
   assessmLeg.Contact__c = clientId;
   assessmLeg.Assessment_Completed_on__c = System.today();
   assessmLeg.RecordTypeId = recId;  
//   assessmLeg.Employment_Information_Confirmed__c = 'No';
 //  assessmLeg.Client_Contact_Method__c
   insert assessmLeg;   
   recIdfromAssessment_1 = assessmLeg.id;      
    
   List<Assessment_Legacy__c> chk = new List<Assessment_Legacy__c>([select id from Assessment_Legacy__c where id =: recIdfromAssessment_1]);
   
   integer i = chk.Size();
   System.assertEquals(i,1);
    
   string cid = assessmLeg.Contact__c;

    cont = new AssessmentContainer__c();
    cont.assessmentName__c = 'Education';
    assessmentCode = mapNameCode.get('Education');
    cont.assessmentcode__c = assessmentCode;
    cont.client__c = clientId;
    cont.recIdFromassessment__c = recIdfromAssessment_1; 
    insert cont;

    Id contId = cont.id;
   List<AssessmentContainer__c> chk1 = new List<AssessmentContainer__c>([select id,client__c from AssessmentContainer__c where id =: contId]);
   
    i = chk1.Size();

   System.assertEquals(i,1);
   
   System.Debug('\n\n XXX chk1[0],clientid__c :'  + chk1[0].client__c);
       AssessmentMigration_1 migr = new AssessmentMigration_1();
      test.startTest();     
      migr.aValue = 'Education';
         migr.doMigration();
      test.stopTest();
     }     

 

  static testMethod void testLegacy_Psych(){
  	   createTestData();
 
    recId = mapRecTypeLegacy.get('Psychosocial Assesment (Mental Health Assessment)');
   //rec = new RecordType();
   assessmLeg = new Assessment_Legacy__c();
   assessmLeg.Contact__c = clientId;
   assessmLeg.Assessment_Completed_on__c = System.today();
   assessmLeg.RecordTypeId = recId;
   insert assessmLeg;   
   recIdfromAssessment_1 = assessmLeg.id;      
  
    cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'Psychosocial MH';
    assessmentCode = mapNameCode.get('Psychosocial MH');
    cont.assessmentcode__c = assessmentCode;
    cont.client__c = con.id;
    cont.recIdFromassessment__c = recIdfromAssessment_1; 
    insert cont;
 //   Psychosocial_MH__c assm = new Psychosocial_MH__c(AssessmentcontainerId__c = cont.id) ;
             
    AssessmentMigration_1 migr = new AssessmentMigration_1();
     test.startTest();
     migr.aValue = 'Psychosocial MH';
     migr.doMigration();
      test.stopTest();
     }     

  static testMethod void testLegacy_UCLA(){
  	   createTestData();
 
    recId = mapRecTypeLegacy.get('UCLA PTSD RI');
   //rec = new RecordType();
   assessmLeg = new Assessment_Legacy__c();
   assessmLeg.Contact__c = con.id;
   assessmLeg.Assessment_Completed_on__c = System.today();
   assessmLeg.RecordTypeId = recId;
   insert assessmLeg;   
   recIdfromAssessment_1 = assessmLeg.id;      
  
    cont = new AssessmentContainer__c();
    cont.assessmentName__c = 'UCLA PTSD RI)';
    assessmentCode = mapNameCode.get('UCLA PTSD RI)');
    cont.assessmentcode__c = assessmentCode;
    cont.client__c = con.id;
    cont.recIdFromassessment__c = recIdfromAssessment_1; 
    insert cont;
         
    AssessmentMigration_1 migr = new AssessmentMigration_1();
     test.startTest();
     migr.aValue = 'UCLA PTSD RI';
     migr.doMigration();
      test.stopTest();
     }     
/*
 static testMethod void testSurvey(){
  	   createTestData();
    recId = mapRecType.get('Employment/Education Survey');
    assessm1 = new Assessment__c();
    assessm1.Contact__c = con.id; 
    assessm1.Assessment_Completed_on__c = System.today();
    assessm1.RecordTypeId = recId;
    insert assessm1; 
    recIdfromAssessment_1 = assessm1.id;   
  
    cont = new AssessmentContainer__c();
    cont.assessmentName__c = 'Employment/Education Survey';
    assessmentCode = mapNameCode.get('Employment/Education Survey');
    cont.assessmentcode__c = assessmentCode;
    cont.client__c = con.id;
    cont.recIdFromassessment__c = recIdfromAssessment_1; 
    insert cont;
         
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     migr.aValue = 'Employment/Education Survey';
     migr.doMigration();
      test.stopTest();
     }   
*/

}