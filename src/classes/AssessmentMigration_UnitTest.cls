@isTest (SeeAllData=true)
private class AssessmentMigration_UnitTest {
  static testData th = new testData();
 //   static utilityIds utilIds = new utilityIds(); 
 //   static Account accCEP = new Account();
//    static Account accClient = new Account(); 
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
 /*
    static testMethod void test_CC(){
       createTestData();   
       recId = mapRecType.get('Case Coordinator Assessment - Read Only');
       //rec = new RecordType();
       assessm = new Assessment__c();
       assessm.Contact__c = con.id;
       assessm.Assessment_Completed_on__c = System.today();
       assessm.RecordTypeId = recId;
       insert assessm;  
       recIdfromAssessment_1 = assessm.id;  
 
      cont = new AssessmentContainer__c();
      cont.assessmentName__c = 'Case Coordinator';
      string assessmentCode = mapNameCode.get('Case Coordinator');
      cont.assessmentcode__c = assessmentCode;
      cont.client__c = con.id;
      cont.recIdFromassessment__c = recIdfromAssessment_1; 
      insert cont;
    
     AssessmentMigration migr = new AssessmentMigration(); 
     test.startTest();
     migr.aValue = 'Case Coordinator'; 
     migr.doMigration();
     test.stopTest();
    }  
   
   static testMethod void test_CR(){
     createTestData();      
    recId = mapRecType.get('Court Rep Assessment');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;
    recIdfromAssessment_1 = assessm.id;   
   
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'Court Rep';
   assessmentCode = mapNameCode.get('Court Rep');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;
 
    AssessmentMigration migr = new AssessmentMigration();
    test.startTest();
     migr.aValue = 'Court Rep';
     migr.doMigration();
   
     test.stopTest();
    }   

    static testMethod void test_BJMHS(){
        createTestData();      
    recId = mapRecType.get('BJMHS');
    assessm1 = new Assessment__c();
    assessm1.Contact__c = con.id; 
    assessm1.Assessment_Completed_on__c = System.today();
    assessm1.RecordTypeId = recId;
    insert assessm1; 
    recIdfromAssessment_2 = assessm1.id;  
    
    cont = new AssessmentContainer__c();
    cont.assessmentName__c = 'BJMHS';
    assessmentCode = mapNameCode.get('BJMHS');
    cont.assessmentcode__c = assessmentCode;
    cont.client__c = con.id;
    cont.recIdFromassessment__c = recIdfromAssessment_2; 
    insert cont;
   
    AssessmentMigration migr = new AssessmentMigration();
    test.startTest();
     migr.aValue = 'BJMHS';
     migr.doMigration();   
     test.stopTest();}
*/
   static testMethod void test_CRAFFT(){
        createTestData();      
   
     recId = mapRecType.get('CRAFFT');
     assessm = new Assessment__c();
     assessm.Contact__c = con.id; 
     assessm.Assessment_Completed_on__c = System.today();
     assessm.RecordTypeId = recId;
     insert assessm;  
     recIdfromAssessment_1 = assessm.id;

    assessmentCode = mapNameCode.get('CRAFFT');
    AssessmentContainer__c cont = new AssessmentContainer__c(
    accountId__c = accountId,assessmentName__c = 'CRAFFT',
    assessmentcode__c = assessmentCode,client__c = clientId,
     recIdFromassessment__c = recIdfromAssessment_1);  
     insert cont;
   
    AssessmentMigration migr = new AssessmentMigration();
    test.startTest();
     migr.aValue = 'CRAFFT';
     migr.doMigration();   

     test.stopTest();
    }


    static testMethod void test_CCM(){
        createTestData();      
    recId = mapRecType.get('CCM Orientation');
   assessm = new Assessment__c(); 
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm; 
   recIdfromAssessment_1 = assessm.id;   
  
    cont = new AssessmentContainer__c();
      cont.assessmentName__c = 'CCM Orientation';
     assessmentCode = mapNameCode.get('CCM Orientation');
      cont.assessmentcode__c = assessmentCode;
      cont.client__c = con.id;
      cont.recIdFromassessment__c = recIdfromAssessment_1; 
      insert cont; 
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     
     migr.aValue =  'CCM Orientation';
     migr.doMigration();
 ///
     test.stopTest();
    }
   
        static testMethod void test_UCLA(){
        createTestData(); 
   recId = mapRecType.get('UCLA PTSD DSM V');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm; 
   recIdfromAssessment_1 = assessm.id;   
  
    cont = new AssessmentContainer__c();
      cont.assessmentName__c = 'UCLA PTSD DSM V';
     assessmentCode = mapNameCode.get('UCLA PTSD DSM V');
      cont.assessmentcode__c = assessmentCode;
      cont.client__c = con.id;
      cont.recIdFromassessment__c = recIdfromAssessment_1; 
      insert cont;     
         AssessmentMigration migr = new AssessmentMigration();
       test.startTest();
  
    migr.aValue =  'UCLA PTSD DSM V';
      migr.doMigration();


     test.stopTest();
    }   
  

    static testMethod void test_PHQ_teen(){
        createTestData();      
   recId = mapRecType.get('PHQ-9 Teen');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;  
   recIdfromAssessment_1 = assessm.id;
  
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'PHQ-9 Teen';
   assessmentCode = mapNameCode.get('PHQ-9 Teen');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;
      
    AssessmentMigration migr = new AssessmentMigration(); 
    test.startTest();

     migr.aValue = 'PHQ-9 Teen'; 
     migr.doMigration();

       test.stopTest();
    }

   static testMethod void test_PHQ(){
        createTestData();      

   recId = mapRecType.get('PHQ-9');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;
   recIdfromAssessment_1 = assessm.id;    
 
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'PHQ-9';
   assessmentCode = mapNameCode.get('PHQ-9');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont; 
    AssessmentMigration migr = new AssessmentMigration(); 
     test.startTest();
  
     migr.aValue = 'PHQ-9'; 
     migr.doMigration();
       test.stopTest();
    }

    static testMethod void test_PCL(){
       createTestData();    
       
   recId = mapRecType.get('PCL-C');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;   
    recIdfromAssessment_1 = assessm.id;   
       
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'PCL-C';
   assessmentCode = mapNameCode.get('PCL-C');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;
            
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     migr.aValue =  'PCL-C';
     migr.doMigration();
       test.stopTest();
    }
/*
   static testMethod void test9_LEC(){
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
           
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     migr.aValue =  'Life Events Checklist (LEC)';
     migr.doMigration();
     test.stopTest();
   }
 //
 
      static testMethod void test9_sr(){
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
   AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
    migr.aValue =  'SRP Intake';
   migr.doMigration();
  test.stopTest();
      } 
  */
   ///  WRNA
     static testMethod void test_wrna(){
       createTestData();
   recId = mapRecType.get('WRNA');
   assessm1 = new Assessment__c();
   assessm1.Contact__c = con.id;
   assessm1.Assessment_Completed_on__c = System.today();
   assessm1.RecordTypeId = recId;
   insert assessm1;
   recIdfromAssessment_2 = assessm1.id;    
 
   cont1 = new AssessmentContainer__c();
   cont1.assessmentName__c = 'WRNA';
   assessmentCode = mapNameCode.get('WRNA');
   cont1.assessmentcode__c = assessmentCode;
   cont1.client__c = con.id;
   cont1.recIdFromassessment__c = recIdfromAssessment_2; 
   insert cont1;     

   AssessmentMigration migr = new AssessmentMigration();
   test.startTest();
   migr.aValue =  'WRNA';
   migr.doMigration();
   
   
    test.stopTest();     
       
   }                 
    
  static testMethod void test_SA(){
    createTestData();      

   recId = mapRecType.get('Substance Abuse Assessment');
   //rec = new RecordType();
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;  
    recIdfromAssessment_1 = assessm.id;  
   
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'Substance Abuse';
   assessmentCode = mapNameCode.get('Substance Abuse');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;

    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
    migr.aValue =  'Substance Abuse';
     migr.doMigration();

    test.stopTest();
     }    
    
 static testMethod void test_TCU(){
    createTestData();      

   recId = mapRecType.get('TCU');
   //rec = new RecordType();
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;  
    recIdfromAssessment_1 = assessm.id;  
   
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'TCU II';
   assessmentCode = mapNameCode.get('TCU II');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;
   
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
    migr.aValue =  'TCU II';
     migr.doMigration();

    test.stopTest();}
     
     
 static testMethod void test_LSCMI(){
    createTestData();      

   recId = mapRecType.get('LS/CMI');
   //rec = new RecordType();
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;  
    recIdfromAssessment_1 = assessm.id;  
   
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'LS/CMI';
   assessmentCode = mapNameCode.get('LS/CMI');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;

    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
    migr.aValue =  'LS/CMI';
     migr.doMigration();

    test.stopTest();
     }         
 static testMethod void test_LSIR(){
    createTestData();      

   recId = mapRecType.get('LSI-R:SV');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;  
    recIdfromAssessment_1 = assessm.id;  
   
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'LSI R';
   assessmentCode = mapNameCode.get('LSI R');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;
    
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
    migr.aValue =  'LSI R';
     migr.doMigration();

    test.stopTest();
     }              

   static testMethod void test_BPS(){
     createTestData(); 
 
    recId = mapRecType.get('CEP BPS Assessment');
    //rec = new RecordType();
    assessm1 = new Assessment__c();
    assessm1.Contact__c = con.id;
    assessm1.Assessment_Completed_on__c = System.today();
    assessm1.Referrals_Made_YN__c = true;
    assessm1.Referrals_Made__c = 'ffff';
    assessm1.RecordTypeId = recId; 
    insert assessm1; 
    recIdfromAssessment_1 = assessm1.id;  
   
   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'CEP BPS';
   assessmentCode = mapNameCode.get('CEP BPS');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();

    migr.aValue = 'CEP BPS';
     migr.doMigration(); 
     test.stopTest(); 
   }
 
 /////////
 
 
    static testMethod void test_other(){
         createTestData();
    recId = mapRecType.get('Health Screen');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;  
    recIdfromAssessment_1 = assessm.id;  
    

   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'Health Screen';
   assessmentCode = mapNameCode.get('Health Screen');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;  
   AssessmentMigration migr = new AssessmentMigration();
     test.startTest();   

   migr.aValue =  'Health Screen';
   migr.doMigration();   
 
   Id CEP_ICD_Assessment = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP ICD Assessment').getRecordTypeId();   
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId =  CEP_ICD_Assessment;
   insert assessm;     
   recIdfromAssessment_1 = assessm.id;  

   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'CEP ICD';
   assessmentCode = mapNameCode.get('CEP ICD');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;  
   
   migr.aValue =  'CEP ICD';
   migr.doMigration(); 

 //////////////////////////////
 
   recId = mapRecType.get('CEP Intake Assessment');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId =  recId;
   insert assessm;     
   recIdfromAssessment_1 = assessm.id;  

   cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'CEP Intake';
   assessmentCode = mapNameCode.get('CEP Intake');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;  
 //   insert assm2;     
   migr.aValue =  'CEP Intake';
   migr.doMigration(); 

////////
/*
       recId = mapRecType.get('MHSF');
   assessm = new Assessment__c();
   assessm.Contact__c = con.id;
   assessm.Assessment_Completed_on__c = System.today();
   assessm.RecordTypeId = recId;
   insert assessm;
   recIdfromAssessment_1 = assessm.id; 
   
    cont = new AssessmentContainer__c();
   cont.assessmentName__c = 'MHSF';
   assessmentCode = mapNameCode.get('MHSF');
   cont.assessmentcode__c = assessmentCode;
   cont.client__c = con.id;
   cont.recIdFromassessment__c = recIdfromAssessment_1; 
   insert cont;  
   
   migr.aValue =  'MHSF';
   migr.doMigration(); 
  */ 
 
     test.stopTest();
     }
/*
   static testMethod void test16_HW(){
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
  
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     migr.aValue = 'Health and Wellbeing';
     migr.doMigration();
      test.stopTest();
     }

  static testMethod void testLegacy_Education(){
       createTestData();
    test.startTest();
 
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
  
   string cid = assessmLeg.Contact__c;

    contLeg = new AssessmentContainer__c();
    contLeg.assessmentName__c = 'Education';
    assessmentCode = mapNameCode.get('Education');
    contLeg.assessmentcode__c = assessmentCode;
    contLeg.client__c = cid;
    contLeg.recIdFromassessment__c = recIdfromAssessment_1; 
    insert cont;
         
    AssessmentMigration migr = new AssessmentMigration();
     migr.aValue = 'Education';
      test.stopTest();
     }     

  static testMethod void testLegacy_Psych(){
       createTestData();
 
    recId = mapRecTypeLegacy.get('Psychosocial Assesment (Mental Health Assessment)');
   //rec = new RecordType();
   assessmLeg = new Assessment_Legacy__c();
   assessmLeg.Contact__c = con.id;
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
    Psychosocial_MH__c assm = new Psychosocial_MH__c(AssessmentcontainerId__c = cont.id) ;
    insert assm; 
             
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     migr.aValue = 'Psychosocial MH';
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
         
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     migr.aValue = 'UCLA PTSD RI';
      test.stopTest();
     }     
*/

static testMethod void testSurvey(){
  	createTestData();
    recId = mapRecType.get('Employment/Education Survey');
    assessm1 = new Assessment__c();
    assessm1.Contact__c = con.id; 
    assessm1.Assessment_Completed_on__c = System.today();
    assessm1.RecordTypeId = recId;
    insert assessm1; 
    recIdfromAssessment_1 = assessm1.id;   
  
    integer i = 1;
    List<Assessment__c> lstAssm = new List<Assessment__c>([select id from Assessment__c where id =: recIdfromAssessment_1]);
    integer k =  lstAssm.size(); 
    system.assertEquals(i,k); 

    cont = new AssessmentContainer__c();
    cont.assessmentName__c = 'Employment/Education Survey';
    assessmentCode = mapNameCode.get('Employment/Education Survey');
    cont.assessmentcode__c = assessmentCode;
    cont.client__c = con.id;
    cont.recIdFromassessment__c = recIdfromAssessment_1; 
    insert cont;
    
    List<AssessmentContainer__c> lstcont = new List<AssessmentContainer__c>([select id from AssessmentContainer__c where 
    recIdFromassessment__c =: recIdfromAssessment_1]);
    integer m =  lstcont.size(); 
    system.assertEquals(i,m); 
    
         
    AssessmentMigration migr = new AssessmentMigration();
     test.startTest();
     migr.aValue = 'Employment/Education Survey';
     migr.doMigration();
      test.stopTest();
     }
       
}