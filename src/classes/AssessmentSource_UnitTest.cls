@isTest (SeeAllData=true)
private class AssessmentSource_UnitTest {
  static Id cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
  static Account accClient = new Account();
  static Contact con = new Contact(); 
 static CRAFFT__c CRAFFT{get;set;}  
 // static Case_Information__c newCaseInfo =  new Case_Information__c();
  static BJMHS__c BJMHS = new BJMHS__c();
  static CaseCoordinator__c CC = new  CaseCoordinator__c();
  static AssessmentContainer__c cnt = new AssessmentContainer__c();
  static CCM_Orientation__c CCM = new CCM_Orientation__c();
  static CEP_Intake__c CEPINT = new CEP_Intake__c();
  static CourtRepAssm__c CR = new CourtRepAssm__c();
  static MHSF__c MHSF = new MHSF__c();
  static LifeEventsAssm__c LEC = new LifeEventsAssm__c(); 
  static CEP_ICD__c ICD = new CEP_ICD__c();
  static UCLA_PTSD_DSM_V__c DSM = new UCLA_PTSD_DSM_V__c();
  static Health_Screen__c HS = new 	Health_Screen__c();
  static HW__c HW = new HW__c();
  static PCLC__c PCL = new PCLC__c(); 
  static WRNA__c WR = new WRNA__c();
  static SRP_IntakeAssessments__c SRP = new SRP_IntakeAssessments__c();
  static CEP_BPS__c BPS = new CEP_BPS__c();
  static SubstanceAbuseAssessment__c SAA = new SubstanceAbuseAssessment__c();
  static LSCMI__c LSCMI = new LSCMI__c();
  static LSIR__c LSIR = new LSIR__c();
  static PHQ_9__c PHQ_9 = new PHQ_9__c();
  static TCUassessment__c TCU = new TCUassessment__c();
  static PHQ_9T__c PHQ_9T = new PHQ_9T__c(); 
  static  EducationAssm__c ed = new  EducationAssm__c();
  static Psychosocial_MH__c psycho = new Psychosocial_MH__c();
  static Map<String,String> mapNameCode = new Map<String,String>();
//  static AssessmentController ac = new  AssessmentController();
  static ID contId,accId,assmId,assmId1,assmId2,assmId3,assmId4,assmId5,assmId6,assmId7,assmId8,assmId9,assmId10,assmId11,assmId12;
  static ID assmId13,assmId14,assmId15,assmId16,assmId17,assmId18,assmId19,assmId20,assmId21,assmId22,assmId23,assmId24,assmId25;
  static void createTestData() {
    utilityIds utilIds = new utilityIds();
    
    accClient = new Account(Name='Assessment Tester', RecordTypeId = utilIds.accClient);
    insert accClient;

    accId = accClient.Id;    
    con = new Contact(firstName = 'assmFirst',lastName = 'assmLast',Drug_test_frequency__c = 'Bi-Weekly',Referral_Date__c = system.today().addDays(-5),
    Eligible__c = 'Yes',Interview_Acceptance_Date__c = system.today().addDays(-3),Interview_Outcome__c = 'CEP Accepts',RecordTypeId = utilIds.conClient,
    accountId = accClient.id,Case_Coordinator__c = utilIds.defaultTaskAssignedTo,Court_Rep__c = UserInfo.getUserId());
    insert con;
    contId = con.Id;
 
   for (AssessmentList__c c : [select assessmentName__c,name from AssessmentList__c]){
   	mapNameCode.put(c.assessmentName__c,c.name);
   }



  //**** BJMHS      
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
   //  cnt.assessmentCode__c = 'A-030';
     cnt.assessmentCode__c = mapNameCode.get('BJMHS');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
      assmId = cnt.id;  
  
      BJMHS = new BJMHS__c(AssessmentContainerId__c = assmId,Q1_Mind_Control__c = 'Yes',Q2_Mind_Reading__c = 'Yes',Q3_weight_Gain__c = 'Yes',
      Q6_Feel_Sinful__c = 'Yes',Survey_Notes__c = 'Yes');
      insert BJMHS;
  //****      
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     cnt.assessmentCode__c = mapNameCode.get('Case Coordinator');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId1 = cnt.id;
     
     CC = new  CaseCoordinator__c();
     CC.AssessmentContainerId__c = assmId1;
     CC.Current_Employment__c = 'empl';
     insert CC;  
         
  //****  CCM Orientation    
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-020';
     cnt.assessmentCode__c = mapNameCode.get('CCM Orientation');

     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId2 = cnt.id;
     
      CCM = new CCM_Orientation__c();
      CCM.AssessmentContainerId__c = assmId2;
      CCM.Family_Background__c = 'backgroud';
      insert CCM;
  
  //****      
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-026';
     cnt.assessmentCode__c = mapNameCode.get('CCM Orientation');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId3 = cnt.id;
     
     CR = new CourtRepAssm__c();
     CR.AssessmentContainerId__c = assmId3;
     CR.Education_Section_1__c = 'education';
      insert CR;
  
  //****    Life Events Checklist (LEC)   
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-005';
      cnt.assessmentCode__c = mapNameCode.get('Life Events Checklist (LEC)');
 
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId4 = cnt.id;
     
     LEC = new LifeEventsAssm__c();
     LEC.AssessmentContainerId__c = assmId4;
     insert LEC;
     
  //****	MHSF
    cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-018';
     cnt.assessmentCode__c = mapNameCode.get('MHSF');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId5 = cnt.id;
     
     MHSF = new MHSF__c();
     MHSF.AssessmentContainerId__c = assmId5;
     insert MHSF;

//**  CEP ICD
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-027';
     cnt.assessmentCode__c = mapNameCode.get('CEP ICD');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId6 = cnt.id;
       
  
     ICD = new CEP_ICD__c();
     ICD.AssessmentContainerID__c = assmId6;
     ICD.Last_School_Attended__c = accId;
     insert ICD;   

  //**UCLA PTSD DSM V
  
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-022';
     cnt.assessmentCode__c = mapNameCode.get('UCLA PTSD DSM V');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId7 = cnt.id;
     
     DSM = new UCLA_PTSD_DSM_V__c();
     DSM.AssessmentContainerId__c = assmId7;
     insert DSM;
     
   //** Health Screen
      cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-027';
      cnt.assessmentCode__c = mapNameCode.get('Health Screen');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId8 = cnt.id;
  
     HS = new 	Health_Screen__c();  
     HS.AssessmentContainerId__c = assmId8;
     insert HS;
     
   //**  WRNA
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-006';
     cnt.assessmentCode__c = mapNameCode.get('WRNA');
 
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId9 = cnt.id;
   
     WR = new WRNA__c(AssessmentContainerId__c = assmId9,WRNA_RF_Adult_Abuse__c = 1,WRNA_RF_Anger_hostility__c = 0,WRNA_RF_Child_abuse__c = 1,
     WRNA_RF_Depression_anxiety__c = 2,WRNA_RF_Family_Conflict__c = 3,WRNA_RF_History_of_mental_illness__c = 0,
     WRNA_RF_Parental_Stress__c = 2,WRNA_RF_Physical_Abuse__c = 1,WRNA_RF_Psychosis__c = 1,WRNA_RF_PTSD__c = 1,WRNA_RF_Relationship_Dysfunction__c = 2,
     WRNA_RF_Sexual_Abuse__c = 2,WRNA_Risk_Factor_Employment_Financial__c = 1,
     WRNA_STR_Educational_Strengths__c = 1,WRNA_STR_Family_Support__c = 1,WRNA_STR_Parental_Involvement__c = 0,WRNA_STR_Relationship_Support__c = 0,
     WRNA_STR_Self_efficacy__c = 0);
     insert WR;
     
//** SRP Intake
    cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-025';
     cnt.assessmentCode__c = mapNameCode.get('SRP Intake');
  
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId10 = cnt.id;

     SRP = new SRP_IntakeAssessments__c();  
     SRP.AssessmentContainerId__c = assmId10;
      insert SRP;
           
//*CEP BPS

    cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-015';
     cnt.assessmentCode__c = mapNameCode.get('CEP BPS');

     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId11 = cnt.id;

    BPS = new CEP_BPS__c();
    BPS.AssessmentContainerId__c = assmId11;
    insert BPS; 
    
   //* Substance Abuse
      cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-010';
        cnt.assessmentCode__c = mapNameCode.get('Substance Abuse');
   
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId12 = cnt.id;
     
     SAA = new SubstanceAbuseAssessment__c();
     SAA.AssessmentContainerId__c = assmId12; 
     insert SAA;
     
//*   LS/CMI
    cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-021';
     cnt.assessmentCode__c = mapNameCode.get('LS/CMI');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId13 = cnt.id;
     
     LSCMI = new LSCMI__c();
     LSCMI.AssessmentContainerId__c = assmId13;
     insert LSCMI;  

//*  LSI R  
     
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-002';
     cnt.assessmentCode__c = mapNameCode.get('LSI R');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId14 = cnt.id; 
     
     LSIR = new LSIR__c();
     LSIR.AssessmentContainerId__c = assmId14;    
     insert LSIR;
     
// 
  //* 	CRAFFT
      cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-007';
     cnt.assessmentCode__c = mapNameCode.get('CRAFFT');

     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId15 = cnt.id;
     
     CRAFFT = new CRAFFT__c();
     CRAFFT.AssessmentContainerId__c = assmId15; 
     insert CRAFFT;
     
//*  //* PCL  
          cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-008';
    cnt.assessmentCode__c = mapNameCode.get('PCL-C');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId17 = cnt.id; 
     
     PCL = new PCLC__c(); 
     PCL.AssessmentContainerId__c = assmId17;
     insert PCL;
     
    //* TCU
          cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-009';
     cnt.assessmentCode__c = mapNameCode.get('TCU II');
     
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId18 = cnt.id; 
    
     TCU = new TCUassessment__c(); 
     TCU.AssessmentContainerId__c = assmId18;
     insert TCU;
     
     // Health and Wellbeing
           cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-013';
     cnt.assessmentCode__c = mapNameCode.get('Health and Wellbeing');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId19= cnt.id; 
     HW = new HW__c();
     HW.AssessmentContainerId__c = assmId19;
     insert HW; 
     
     // CEP Intake
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-031';
     cnt.assessmentCode__c = mapNameCode.get('CEP Intake');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId20= cnt.id;    
     CEPINT = new CEP_Intake__c();    
     CEPINT.AssessmentContainerId__c = assmId20;
     insert CEPINT; 

//* PHQ 9T
   
     cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-024';
     cnt.assessmentCode__c = mapNameCode.get('PHQ-9 Teen');

     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;   
     assmId21 = cnt.id; 
     PHQ_9T = new PHQ_9T__c();
     PHQ_9T.AssessmentContainerId__c = assmId21;
     insert PHQ_9T;
 
 // PHQ 9
    cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     cnt.assessmentCode__c = mapNameCode.get('PHQ-9');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;  
     assmId24 = cnt.id; 

     PHQ_9 = new PHQ_9__c(AssessmentContainerId__c = assmId24);
     insert PHQ_9;
 
 // Education
      cnt = new AssessmentContainer__c();
     cnt.AccountId__c = accId;
     //cnt.assessmentCode__c = 'A-024';
     cnt.assessmentCode__c = mapNameCode.get('Education');
     cnt.Assessment_Date__c = date.today();
     cnt.Client__c = contId;    
     insert cnt;  
     assmId22 = cnt.id; 

     ed = new EducationAssm__c();         
     ed.AssessmentContainerId__c = assmId22;
     insert ed;
// PSYCHO
     cnt = new AssessmentContainer__c(AccountId__c = accId,assessmentCode__c = mapNameCode.get('Education'),Assessment_Date__c = date.today(),Client__c = contId);    
     insert cnt;  
     assmId23 = cnt.id; 
     psycho = new Psychosocial_MH__c(AssessmentContainerId__c = assmId23);
     insert psycho;

  }
  
      static testMethod void testNew(){
       	createTestData();
        test.startTest();
       	AssessmentSource asm = new  AssessmentSource();
        asm.saveBJMHS(BJMHS, assmId);
        asm.saveCC(CC,assmId1);
        asm.saveCCM(CCM,assmId2);
        asm.saveCR(CR,assmId3);
        asm.saveLEC(LEC,assmId4);
        asm.saveMHSF(MHSF,assmId5);
        asm.saveICD(ICD, assmId6);
        asm.saveDSM(DSM, assmId7);
        asm.saveHS(HS, assmId8);
        asm.saveWRNA(WR, assmId9);
        asm.saveSRP(SRP,assmId10);
        asm.saveBPS(BPS, assmId11);        
        asm.saveSAA(SAA,assmId12);
        asm.saveLSCMI(LSCMI,assmId13);
        asm.saveLSIR(LSIR,assmId14);
	        asm.saveCRAFFT(CRAFFT, assmId15);
        asm.savePCL(PCL,assmId17);
        asm.saveTCU(TCU,assmId18);
        asm.saveHW(HW,assmId19);
        asm.saveCEPIntake(CEPINT,assmId20);
        asm.savePHQ9teen(PHQ_9T,assmId21);
        asm.saveEd(Ed,assmId22);
        asm.savePsycho(psycho,assmId23);
        asm.savePHQ9(PHQ_9, assmId24);
 
         
        BJMHS = asm.createBJMHSsource(assmId);
        CC  = asm.createCCsource(assmId1);
        CCM = asm.createCCMsource(assmId2);
        CR = asm.createCRsource(assmId3);
        LEC = asm.createLECsource(assmId4);
        MHSF = asm.createMHSFsource(assmId5); 
        ICD = asm.createICDsource(assmId6);
        DSM = asm.createDSMsource(assmId7);
        HS = asm.createHSsource(assmId8);
        WR = asm.createWRNAsource(assmId9);
        SRP = asm.createSRPsource(assmId10);
        BPS = asm.createBPSsource(assmId11);
        SAA = asm.createSAAsource(assmId12);
        LSCMI = asm.createLSCMIsource(assmId13);
        LSIR = asm.createLSIRsource(assmId14);
         PHQ_9T = asm.createPHQ9teensource(assmId21);
        ed = asm.createEdsource(assmId22);
        psycho = asm.createPsychosource(assmId23);
        PHQ_9 = asm.createPHQ9source(assmId24);

        CRAFFT = asm.createCRAFFTsource(assmId15) ;
        PCL = asm.createPCLsource(assmId17) ;
        TCU = asm.createTCUsource(assmId18) ;
        HW = asm.createHWsource(assmId19) ;
        CEPINT =  asm.createCEPIntakeSource(assmId20);
        asm.validateLEC(LEC);
        asm.totalScorePHQ(assmId24);
        
  //      asm.totalScorePHQ(assmId15);
        asm.totalScorePHQ_teen(assmId21);
       	test.stopTest();
       }
}