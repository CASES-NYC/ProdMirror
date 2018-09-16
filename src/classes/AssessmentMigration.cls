public with sharing class AssessmentMigration {
 public boolean inProcess{get;set;}
 public string aValue{get;set;}
  public List<SelectOption> Items{get;set;}
 //Map<string,string> mapAssCodePage = new Map<string,string>();    
//  Map<string,string> mapAssCodeName = new Map<string,string>(); 
  public AssessmentMigration(){
     generatePickListFromLookUp();
  }
 
public integer numbers{get;set;} 
   
  ////////////////////   PART 1  8 
  public void doMigration(){
    inProcess = true;
  if (aValue == 'Case Coordinator')  //  1
       doCaseCoordination();  
  else if (aValue == 'CRAFFT') //  2
       doCRAFFT();
  else if (aValue == 'PHQ-9 Teen') //  3
     doPHQ9teen();
  else if (aValue == 'CCM Orientation') // 4 
      doCCMorientation();
  else if (aValue == 'PHQ-9') //  5
      doPHQ9();    
  else if (aValue == 'Court Rep') // 6
           doCourtRep();   
  else if (aValue == 'PCL-C') // 7
      doPCLC();
  else if (aValue == 'Substance Abuse')   // 8
          doSubsAbuse();
  else if (aValue == 'TCU II') // 9
     doTCU(); 
  else if (aValue == 'LS/CMI') // 10
      doLSCMI();  
  else if (aValue == 'LSI R') // 11
     doLSIR();   
  else if (aValue == 'CEP BPS') // 12  
      doBPS();
  else if (aValue == 'CEP ICD') // 13  
      doICD();             
  else if (aValue == 'Health Screen') // 14
      doHEALTH();
  else if (aValue == 'MHSF') // 16
     doMHSF();
  else if (aValue == 'BJMHS') //  17
               doBJMHS();
  else if (aValue == 'WRNA') // 18
      doWRNA();
  else if (aValue == 'CEP Intake') //19
    doCEPintake(); 
  else if (aValue == 'UCLA PTSD DSM V') // 17
     doUCLA_PTSD_DSM_V();   
 else if (aValue == 'Employment/Education Survey') //SURVEY
      doSurvey();      
 else if (aValue == 'Y-LS/CMI')
      doY_LS_CMI();      
   inProcess = false;
 }

  
  void generatePickListFromLookUp(){
    List<SelectOption> option = new List<SelectOption>();
    option.add(new SelectOption('','')); 
    option.add(new SelectOption('BJMHS','BJMHS'));
    option.add(new SelectOption('Case Coordinator','Case Coordinator'));
    option.add(new SelectOption('CCM Orientation','CCM Orientation'));
    option.add(new SelectOption('CEP BPS','CEP BPS'));
    option.add(new SelectOption('CEP ICD','CEP ICD'));
    option.add(new SelectOption('CEP Intake','CEP Intake'));
    option.add(new SelectOption('Court Rep','Court Rep'));
    option.add(new SelectOption('Health Screen','Health Screen'));
    option.add(new SelectOption('CRAFFT','CRAFFT'));
    option.add(new SelectOption('LS/CMI','LS/CMI'));
    option.add(new SelectOption('LSI R','LSI R'));
    option.add(new SelectOption('MHSF','MHSF'));
    option.add(new SelectOption('PHQ-9 Teen','PHQ-9 Teen'));
    option.add(new SelectOption('PHQ-9','PHQ-9'));
    option.add(new SelectOption('PCL-C','PCL-C'));
    option.add(new SelectOption('Substance Abuse','Substance Abuse'));
    option.add(new SelectOption('TCU II','TCU II'));
   option.add(new SelectOption('UCLA PTSD DSM V','UCLA PTSD DSM V'));
    option.add(new SelectOption('WRNA','WRNA')); 
   option.add(new SelectOption('Employment/Education Survey','Employment/Education Survey'));
   option.add(new SelectOption('Y-LS/CMI','Y-LS/CMI'));    
       Items = option;}

 //      CASE COORDINATION   
      void doCaseCoordination(){ 
    CaseCoordinator__c oneMigrate = new CaseCoordinator__c();
    List<CaseCoordinator__c> lstMigrate = new List<CaseCoordinator__c>();
    Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Case Coordinator' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (CaseCoordinator__c cc : [select AssessmentContainerId__c from CaseCoordinator__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
      ID parentId;
      integer k = 0;
       List<Assessment__c> lstAssm = new List<Assessment__c>([
     Select  Id,Work_Hours_from_and_to__c,  What_is_the_last_grade_you_completed__c,What_grade_are_you_currently_in__c,
     Update_School_GED_Enrollment_at_Intake__c,Update_Other_Phys_Health_Problem__c,  Update_No_of_High_School_Credits__c,
       Update_Last_Grade_Completed__c,  Update_Insurance_Provider__c,  Update_Insurance_Number__c,Update_Indication_of_Phys_Health_Problem__c,
      Update_Has_Insurance__c,  Update_Employed_at_Intake__c,Update_Diploma_Status_at_Intake__c, Update_Current_Grade__c,
       Substance_Abuse_at_Interview__c,  Substance_Abuse_Section_1__c,  Start_Date__c,School_Start_Date__c,  School_Institution_Hours_from_and_to__c,
      School_GED_Enrollment_at_Intake__c,  School_End_Date__c,  Relation_To_Client__c,Reason_for_Leaving_School__c,
      Reason_for_Leaving_School_Other__c,Prescribe_take_med_to_treat_MH_problem__c,  Physical_Health_Section_1__c,Parent_Guardian__c,
      Other_Phys_Health_Problem__c,Mental_Health_Section_1__c,  Mental_Health_Issues_at_Interview__c,Last_School_Attended__c, Job_Title__c,   
      Insurance_Provider__c,  Insurance_Number__c,  Indication_of_Phys_Health_Problem__c,Incarcerated_Family_Members__c,
      How_many_credits_have_you_earned__c,How_many_children__c,  Hourly_Pay__c,  Hospitalized_resd_prgm_for_MH_reasons__c,  
      Gang_Involvement__c,Family_Peers_Section_1__c,  Expecting_a_Child__c,Ever_recvd_counseling_other_MH_services__c,Employment_Section_1__c, 
      Employer__c,Employed_at_Intake__c,Education_Section_1__c,Education_Plan__c,Drugs_Used__c,Drugs_Used_Other__c,Do_you_have_Insurance__c,
      Diploma_Type__c,Diploma_Status_at_Intake__c,Diploma_Date__c,Current_School_Enrollment__c,Current_Employment__c
      From Assessment__c c where id  in: setAssmId]);
     for (Assessment__c s : lstAssm){
        parentId = s.id;
        if (setInserted.contains(parentId) == false){
        oneMigrate = new CaseCoordinator__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        Work_Hours_from_and_to__c = s.Work_Hours_from_and_to__c,What_is_the_last_grade_you_completed__c = s.What_is_the_last_grade_you_completed__c,  
        What_grade_are_you_currently_in__c = s.What_grade_are_you_currently_in__c,
        Update_School_GED_Enrollment_at_Intake__c = s.Update_School_GED_Enrollment_at_Intake__c,  
        Update_Other_Phys_Health_Problem__c = s.Update_Other_Phys_Health_Problem__c,Update_No_of_High_School_Credits__c = s.Update_No_of_High_School_Credits__c, 
        Update_Last_Grade_Completed__c = s.Update_Last_Grade_Completed__c,Update_Insurance_Provider__c = s.Update_Insurance_Provider__c,   
        Update_Insurance_Number__c = s.Update_Insurance_Number__c,Update_Indication_of_Phys_Health_Problem__c = s.Update_Indication_of_Phys_Health_Problem__c,
        Update_Has_Insurance__c = s.Update_Has_Insurance__c,Update_Employed_at_Intake__c = s.Update_Employed_at_Intake__c, 
        Update_Diploma_Status_at_Intake__c = s.Update_Diploma_Status_at_Intake__c,Update_Current_Grade__c = s.Update_Current_Grade__c, 
        Substance_Abuse_at_Interview__c = s.Substance_Abuse_at_Interview__c,Substance_Abuse_Section_1__c = s.Substance_Abuse_Section_1__c,   
        Start_Date__c = s.Start_Date__c,School_Start_Date__c = s.School_Start_Date__c,   
        School_Institution_Hours_from_and_to__c = s.School_Institution_Hours_from_and_to__c,School_GED_Enrollment_at_Intake__c = s.School_GED_Enrollment_at_Intake__c,   
        School_End_Date__c = s.School_End_Date__c,Relation_To_Client__c = s.Relation_To_Client__c,Reason_for_Leaving_School__c = s.Reason_for_Leaving_School__c,  
         Reason_for_Leaving_School_Other__c = s.Reason_for_Leaving_School_Other__c,Prescribe_take_med_to_treat_MH_problem__c = s.Prescribe_take_med_to_treat_MH_problem__c,   
         Physical_Health_Section_1__c = s.Physical_Health_Section_1__c,Parent_Guardian__c = s.Parent_Guardian__c,   
         Other_Phys_Health_Problem__c = s.Other_Phys_Health_Problem__c,Mental_Health_Section_1__c = s.Mental_Health_Section_1__c,   
         Mental_Health_Issues_at_Interview__c = s.Mental_Health_Issues_at_Interview__c,   
         Last_School_Attended__c = s.Last_School_Attended__c,Job_Title__c = s.Job_Title__c,Insurance_Provider__c = s.Insurance_Provider__c,   
         Insurance_Number__c = s.Insurance_Number__c,Indication_of_Phys_Health_Problem__c = s.Indication_of_Phys_Health_Problem__c,  
         Incarcerated_Family_Members__c = s.Incarcerated_Family_Members__c,How_many_credits_have_you_earned__c = s.How_many_credits_have_you_earned__c,  
         How_many_children__c = s.How_many_children__c,Hourly_Pay__c = s.Hourly_Pay__c,Hospitalized_resd_prgm_for_MH_reasons__c = s.Hospitalized_resd_prgm_for_MH_reasons__c,   
         Gang_Involvement__c = s.Gang_Involvement__c,Family_Peers_Section_1__c = s.Family_Peers_Section_1__c,   
         Expecting_a_Child__c = s.Expecting_a_Child__c,Ever_recvd_counseling_other_MH_services__c = s.Ever_recvd_counseling_other_MH_services__c,   
         Employment_Section_1__c = s.Employment_Section_1__c,Employer__c = s.Employer__c,Employed_at_Intake__c = s.Employed_at_Intake__c,   
         Education_Section_1__c = s.Education_Section_1__c,Education_Plan__c = s.Education_Plan__c,Drugs_Used__c = s.Drugs_Used__c,   
         Drugs_Used_Other__c = s.Drugs_Used_Other__c,Do_you_have_Insurance__c = s.Do_you_have_Insurance__c,   
         Diploma_Type__c = s.Diploma_Type__c,Diploma_Status_at_Intake__c = s.Diploma_Status_at_Intake__c,   
         Diploma_Date__c = s.Diploma_Date__c,Current_School_Enrollment__c = s.Current_School_Enrollment__c,Current_Employment__c = s.Current_Employment__c);   
             lstMigrate.add(oneMigrate);
             k++;}}      numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate;
       AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'Case Coordinator' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;inProcess = false;}}
   
   //  -------------------------------  SUBSTANCE ABUSE  1   TESTED
    void doSubsAbuse(){
     integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Substance Abuse' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (SubstanceAbuseAssessment__c cc : [select AssessmentContainerId__c from SubstanceAbuseAssessment__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
     SubstanceAbuseAssessment__c oneMigrate = new SubstanceAbuseAssessment__c();
     list<SubstanceAbuseAssessment__c> lstMigrate = new List<SubstanceAbuseAssessment__c>();
     List<Assessment__c> lstAssm = new List<Assessment__c>();
     lstAssm = [select Do_you_have_Insurance__c,Insurance_Provider__c, 
     Insurance_Number__c,Update_Insurance_Number__c,Substance_Abuse_at_Interview__c,
     Current_Substance_Abuse_Problems__c,Drugs_Used__c,Drugs_Used_Other__c,Tried_to_stop_using_on_your_own__c,
     Have_had_treatment__c,Drug_Test_Frequency__c,Physical_Health_Section_1__c,Substance_Abuse_Section_1__c,
     Update_Indication_of_Phys_Health_Problem__c,Other_Phys_Health_Problem__c,Update_Other_Phys_Health_Problem__c,
     contact__c,recordtypeid,id
      from Assessment__c where id in: setAssmId];
      id parentId;
        for (Assessment__c s : lstAssm){
        parentId = s.id;
        if (setInserted.contains(parentId) == false){
        oneMigrate = new SubstanceAbuseAssessment__c(
         AssessmentContainerId__c = mapParentIds.get(parentId),Do_you_have_Insurance__c = s.Do_you_have_Insurance__c,
         Insurance_Provider__c = s.Insurance_Provider__c,Insurance_Number__c = s.Insurance_Number__c,
         Update_Insurance_Number__c = s.Update_Insurance_Number__c,Substance_Abuse_at_Interview__c = s.Substance_Abuse_at_Interview__c,
         Current_Substance_Abuse_Problems__c = s.Current_Substance_Abuse_Problems__c,
         Drugs_Used__c = s.Drugs_Used__c,Tried_to_stop_using_on_your_own__c = s.Tried_to_stop_using_on_your_own__c,
         Have_had_treatment__c = s.Have_had_treatment__c,Drug_Test_Frequency__c = s.Drug_Test_Frequency__c,
         Physical_Health_Section_1__c = s.Physical_Health_Section_1__c,Update_Indication_of_Phys_Health_Problem__c = s.Update_Indication_of_Phys_Health_Problem__c,
         Other_Phys_Health_Problem__c = s.Other_Phys_Health_Problem__c,Update_Other_Phys_Health_Problem__c = s.Update_Other_Phys_Health_Problem__c,
         Substance_Abuse_Section_1__c = s.Substance_Abuse_Section_1__c);
        lstMigrate.add(oneMigrate);
        k++;}}      numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate;
        AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'Substance Abuse' limit 1];
         al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
  
     //-------------------------------  PHQ9 TEEN   TESTED
    void doPHQ9teen(){
   integer sumScore = 0;   
     Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'PHQ-9 Teen' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
      setAssmId.add(ac.recIdFromassessment__c);} 
   Set<string> setInserted = new Set<string>();
     for (PHQ_9T__c cc : [select AssessmentContainerId__c from PHQ_9T__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
      integer k = 0;
      string cResult = '';
     PHQ_9T__c oneMigrate = new PHQ_9T__c();
     list<PHQ_9T__c> lstMigrate = new List<PHQ_9T__c>();
     List<Assessment__c> lstAssm = new List<Assessment__c>([
     select PHQ_Feeling_depressed__c,PHQ_Moving_or_speaking_slow_or_fast__c,
     PHQ_Little_interest_doing_things__c,PHQ_Thoughts_of_self_harm__c,PHQ_Sleep_trouble__c,PHQ9T_Sad_most_days_of_the_past_year__c,
     PHQ_Poor_appetite_or_overeating__c,PHQ_Hard_to_function_based_on_above__c,PHQ_Tired_or_lack_energy__c,PHQ9T_Suicidal_thought_in_last_month__c,
    PHQ_Feel_bad_about_yourself__c, PHQ9T_Ever_tried_to_kill_yourself__c,contact__c,recordtypeid,id,Survey_Notes__c,
     PHQ_Trouble_concentrating__c from Assessment__c 
     where id in: setAssmId]);
     ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
       if (setInserted.contains(parentid) == false){
           sumScore = 0;
          if(s.PHQ_Little_interest_doing_things__c <> null) 
       sumScore += integer.valueOf(s.PHQ_Little_interest_doing_things__c);  
     if(s.PHQ_Feeling_depressed__c <> null) 
       sumScore += integer.valueOf(s.PHQ_Feeling_depressed__c);  
     if(s.PHQ_Moving_or_speaking_slow_or_fast__c <> null) 
        sumScore += integer.valueOf(s.PHQ_Moving_or_speaking_slow_or_fast__c);  
     if(s.PHQ_Thoughts_of_self_harm__c  <> null) 
        sumScore += integer.valueOf(s.PHQ_Thoughts_of_self_harm__c );  
     if(s.PHQ_Sleep_trouble__c <> null)
       sumScore += integer.valueOf(s.PHQ_Sleep_trouble__c);  
     if(s.PHQ_Tired_or_lack_energy__c <> null) 
        sumScore += integer.valueOf(s.PHQ_Tired_or_lack_energy__c);  
     if(s.PHQ_Poor_appetite_or_overeating__c<> null) 
        sumScore += integer.valueOf(s.PHQ_Poor_appetite_or_overeating__c);  
     if(s.PHQ_Feel_bad_about_yourself__c <> null)
        sumScore += integer.valueOf(s.PHQ_Feel_bad_about_yourself__c);
     if(s.PHQ_Trouble_concentrating__c <> null)
       sumScore += integer.valueOf(s.PHQ_Trouble_concentrating__c);
        oneMigrate = new PHQ_9T__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        PHQ_Feeling_depressed__c = s.PHQ_Feeling_depressed__c,
        PHQ_Moving_or_speaking_slow_or_fast__c = s.PHQ_Moving_or_speaking_slow_or_fast__c,
        PHQ_Little_interest_doing_things__c = s.PHQ_Little_interest_doing_things__c,
        PHQ_Thoughts_of_self_harm__c = s.PHQ_Thoughts_of_self_harm__c,
        PHQ_Sleep_trouble__c = s.PHQ_Sleep_trouble__c,
        PHQ9T_Sad_most_days_of_the_past_year__c = s.PHQ9T_Sad_most_days_of_the_past_year__c,
        PHQ_Poor_appetite_or_overeating__c = s.PHQ_Poor_appetite_or_overeating__c,
        PHQ_Hard_to_function_based_on_above__c = s.PHQ_Hard_to_function_based_on_above__c,
        PHQ_Tired_or_lack_energy__c = s.PHQ_Tired_or_lack_energy__c,
        PHQ9T_Suicidal_thought_in_last_month__c = s.PHQ9T_Suicidal_thought_in_last_month__c,
        PHQ_Feel_bad_about_yourself__c = s.PHQ_Feel_bad_about_yourself__c,
             PHQ9T_Ever_tried_to_kill_yourself__c = s.PHQ9T_Ever_tried_to_kill_yourself__c,
          PHQ_Trouble_concentrating__c = s.PHQ_Trouble_concentrating__c,   
          Survey_Notes__c = s.Survey_Notes__c,
          Score_Summary__c = sumScore);
  k++;
        lstMigrate.add(oneMigrate);}}
        numbers = k;
         if ( lstMigrate.size() != 0){
        upsert lstMigrate;
            AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'PHQ-9 Teen' limit 1];
         al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}} 

   //-------------------------------  PHQ9     
       void doPHQ9(){ 
      integer k = 0;   
    Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'PHQ-9' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
      setAssmId.add(ac.recIdFromassessment__c);} 
   Set<string> setInserted = new Set<string>();
     for (PHQ_9__c cc : [select AssessmentContainerId__c from PHQ_9__c]){
       setInserted.add(cc.AssessmentContainerId__c);}

     PHQ_9__c oneMigrate = new PHQ_9__c();
     list<PHQ_9__c> lstMigrate = new List<PHQ_9__c>();
     List<Assessment__c> lstAssm = new List<Assessment__c>([
     select contact__c,PHQ_Feel_bad_about_yourself__c,PHQ_Feeling_depressed__c,
     PHQ_Hard_to_function_based_on_above__c,PHQ_Little_interest_doing_things__c,
     PHQ_Moving_or_speaking_slow_or_fast__c,PHQ_Poor_appetite_or_overeating__c,
     PHQ_Sleep_trouble__c,PHQ_Thoughts_of_self_harm__c,PHQ_Tired_or_lack_energy__c,
     PHQ_Trouble_concentrating__c,Survey_Notes__c,PHQ_9_Result__c,PHQ_9_Flag__c from Assessment__c 
     where id in: setAssmId]);
     integer sumScore;
     ID parentId;
        for (Assessment__c s : lstAssm){ 
          parentId = s.id;
          if (setInserted.contains(parentid) == false){
          sumScore = 0;
  if(s.PHQ_Little_interest_doing_things__c <> null) 
       sumScore += integer.valueOf(s.PHQ_Little_interest_doing_things__c);  
     if(s.PHQ_Feeling_depressed__c <> null) 
       sumScore += integer.valueOf(s.PHQ_Feeling_depressed__c);  
     if(s.PHQ_Moving_or_speaking_slow_or_fast__c <> null)  
        sumScore += integer.valueOf(s.PHQ_Moving_or_speaking_slow_or_fast__c);  
     if(s.PHQ_Thoughts_of_self_harm__c  <> null) 
        sumScore += integer.valueOf(s.PHQ_Thoughts_of_self_harm__c );  
     if(s.PHQ_Sleep_trouble__c <> null)
       sumScore += integer.valueOf(s.PHQ_Sleep_trouble__c);  
     if(s.PHQ_Tired_or_lack_energy__c <> null) 
        sumScore += integer.valueOf(s.PHQ_Tired_or_lack_energy__c);  
     if(s.PHQ_Poor_appetite_or_overeating__c<> null) 
        sumScore += integer.valueOf(s.PHQ_Poor_appetite_or_overeating__c);  
     if(s.PHQ_Feel_bad_about_yourself__c <> null)
        sumScore += integer.valueOf(s.PHQ_Feel_bad_about_yourself__c);
     if(s.PHQ_Trouble_concentrating__c <> null)
       sumScore += integer.valueOf(s.PHQ_Trouble_concentrating__c);
      oneMigrate = new PHQ_9__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        Feel_bad_about_yourself__c = s.PHQ_Feel_bad_about_yourself__c,
        Feeling_depressed__c = s.PHQ_Feeling_depressed__c,
        Hard_to_function_based_on_above__c = s.PHQ_Hard_to_function_based_on_above__c,
        Little_interest_doing_things__c = s.PHQ_Little_interest_doing_things__c,
        Moving_or_speaking_slow_or_fast__c = s.PHQ_Moving_or_speaking_slow_or_fast__c,
        Poor_appetite_or_overeating__c = s.PHQ_Poor_appetite_or_overeating__c,
        Sleep_trouble__c = s.PHQ_Sleep_trouble__c,
        Tired_or_lack_energy__c = s.PHQ_Tired_or_lack_energy__c,
        Thoughts_of_self_harm__c = s.PHQ_Thoughts_of_self_harm__c,
        Trouble_concentrating__c = s.PHQ_Trouble_concentrating__c,
            Survey_Notes__c = s.Survey_Notes__c,Score_Summary__c = sumScore);
        lstMigrate.add(oneMigrate);
        k++;}}
        numbers = k;
        if ( lstMigrate.size() != 0){
        upsert lstMigrate;
            AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'PHQ-9' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}   
     
         //   CCM ORIENTATION 7   
    void doCCMorientation(){
      integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'CCM Orientation' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
      setAssmId.add(ac.recIdFromassessment__c);} 
    Set<string> setInserted = new Set<string>();
     for (CCM_Orientation__c cc : [select AssessmentContainerId__c from CCM_Orientation__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
     CCM_Orientation__c oneMigrate = new CCM_Orientation__c();
     List<CCM_Orientation__c> lstMigrate = new List<CCM_Orientation__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select contact__c,Partner_hurt_pets_destroyed_objects__c,Partner_forced_you_to_do_something__c,Other_Neurodevelopmental_Disorders__c,
       Other_Mental_Health_Issues__c,Neurodevelopmental_Disorders__c,Mental_Health_Issues__c, Leisure_Recreation_Notes__c,
       Id,Highest_Level_of_Education_Completed__c,Have_any_of_your_friends_been_arrested__c,Have_3_of_your_friends_been_arrested__c,
       Has_your_partner_taken_hurt_your_kids__c,Has_your_partner_ever_pushed_hit_you__c,Has_your_intimate_partner_ever_hurt_you__c,
       Feel_afraid_at_home__c,Family_Background__c,Drugs_Used__c,Drugs_Used_Other__c,Does_your_partner_endanger_your_health__c,
       Absence_of_organized_activities__c,Suspended_or_expelled_at_least_once__c From Assessment__c c where id in: setAssmId]);    
      ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
          if (setInserted.contains(parentId) == false){
        oneMigrate = new CCM_Orientation__c(
          AssessmentContainerId__c = mapParentIds.get(parentId),
           Partner_hurt_pets_destroyed_objects__c = s.Partner_hurt_pets_destroyed_objects__c, 
           Partner_forced_you_to_do_something__c = s.Partner_forced_you_to_do_something__c,
           Other_Neurodevelopmental_Disorders__c = s.Other_Neurodevelopmental_Disorders__c,
           Other_Mental_Health_Issues__c = s.Other_Mental_Health_Issues__c,
           Neurodevelopmental_Disorders__c = s.Neurodevelopmental_Disorders__c,
           Mental_Health_Issues__c = s.Mental_Health_Issues__c, 
           Leisure_Recreation_Notes__c = s.Leisure_Recreation_Notes__c,
           Highest_Level_of_Education_Completed__c = s.Highest_Level_of_Education_Completed__c,
           Have_any_of_your_friends_been_arrested__c = s.Have_any_of_your_friends_been_arrested__c,
           Have_3_of_your_friends_been_arrested__c = s.Have_3_of_your_friends_been_arrested__c,
           Has_your_partner_taken_hurt_your_kids__c = s.Has_your_partner_taken_hurt_your_kids__c,
           Has_your_partner_ever_pushed_hit_you__c = s.Has_your_partner_ever_pushed_hit_you__c,
           Has_your_intimate_partner_ever_hurt_you__c = s.Has_your_intimate_partner_ever_hurt_you__c,
           Feel_afraid_at_home__c = s.Feel_afraid_at_home__c,
           Family_Background__c = s.Family_Background__c,
           Drugs_Used__c = s.Drugs_Used__c,
           Drugs_Used_Other__c = s.Drugs_Used_Other__c,
           Does_your_partner_endanger_your_health__c = s.Does_your_partner_endanger_your_health__c,
          Absence_of_organized_activities__c = s.Absence_of_organized_activities__c,
          Suspended_or_expelled_at_least_once__c = s.Suspended_or_expelled_at_least_once__c);
          lstMigrate.add(oneMigrate);
          k++;}}
        numbers = k;
        if ( lstMigrate.size() != 0){
        upsert lstMigrate;
                  AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'CCM Orientation' limit 1];
         al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}inProcess = false;} 
     
 //             COURT REP      
      void doCourtRep(){
      integer k = 0;      
   Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Court Rep' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
      setAssmId.add(ac.recIdFromassessment__c);} 
    Set<string> setInserted = new Set<string>();
     for (CourtRepAssm__c cc : [select AssessmentContainerId__c from CourtRepAssm__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
     CourtRepAssm__c oneMigrate = new CourtRepAssm__c();
     List<CourtRepAssm__c> lstMigrate = new List<CourtRepAssm__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select  contact__c,Update_School_GED_Enrollment_at_Intake__c,id,Update_Mental_Health_Issues_at_Interview__c,
       Update_Employed_at_Intake__c,Update_Diploma_Status_at_Intake__c,Substance_Abuse_Section_1__c,Social__c,Residence__c,
       Miscellaneous1__c,Legal__c,Health__c,  Family_Peers_Section_1__c,  Employment_Section_1__c,  
       Education_Section_1__c,  Current_Substance_Abuse_Problems__c,Court_Rep__c from Assessment__c where id in: setAssmId]);
      ID parentId;
      string Miscellaneous;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
          if (setInserted.contains(parentid) == false){
  //          Miscellaneous = substitute(s.Miscellaneous1__c,'\\n','<br/>');
        oneMigrate = new CourtRepAssm__c(AssessmentContainerId__c = mapParentIds.get(parentId),       
        Update_School_GED_Enrollment_at_Intake__c = s.Update_School_GED_Enrollment_at_Intake__c,
          Update_Mental_Health_Issues_at_Interview__c = s.Update_Mental_Health_Issues_at_Interview__c, 
          Update_Employed_at_Intake__c = s.Update_Employed_at_Intake__c, 
          Update_Diploma_Status_at_Intake__c = s.Update_Diploma_Status_at_Intake__c,
          Substance_Abuse_Section_1__c = s.Substance_Abuse_Section_1__c, 
          Social__c = s.Social__c, 
          Residence__c = s.Residence__c, 
          Miscellaneous1__c = s.Miscellaneous1__c ,
          Legal__c = s.Legal__c, 
          Health__c = s.Health__c, 
         Family_Peers_Section_1__c = s.Family_Peers_Section_1__c, 
         Employment_Section_1__c = s.Employment_Section_1__c, 
          Education_Section_1__c = s.Education_Section_1__c, 
          Current_Substance_Abuse_Problems__c = s.Current_Substance_Abuse_Problems__c,  
          Court_Rep__c = s.Court_Rep__c);
          lstMigrate.add(oneMigrate);
        }}            numbers = k;
        if ( lstMigrate.size() != 0){
        upsert lstMigrate;
                     AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'Court Rep' limit 1];
         al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
    

      //               TCU   
               void doTCU(){
  Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'TCU II' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (TCUassessment__c cc : [select AssessmentContainerId__c from TCUassessment__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
      TCUassessment__c oneMigrate = new  TCUassessment__c();
     List< TCUassessment__c> lstMigrate = new List< TCUassessment__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select contact__c,id, TCU_Q9_Get_sick_when_quitting__c,TCU_Q8_Took_drugs_to_avoid_withdrawal__c,
          TCU_Q7_Increase_drug_amount__c,TCU_Q6c_physical_or_medical_problems__c,TCU_Q6b_Problems_w_family_friends_work__c,
          TCU_Q6a_Emotional_and_psych_problems__c,TCU_Q5_Spend_less_time_at_work__c,TCU_Q4b_Caused_an_accident__c, 
          TCU_Q4a_Kept_you_from_doing_work_school__c,TCU_Q3_Spend_a_lot_of_time__c,TCU_Q2_Try_to_cut_down__c,
          TCU_Q1_Longer_more_drugs_than_intended__c,TCU_Q13_How_serious_are_your_problems__c,TCU_Q12_How_often_did_you_inject__c,  
          TCU_Q11n_Other_drugs_frequency__c,TCU_Q11n_Other_drugs__c,TCU_Q11m_Barbiturates__c,TCU_Q11l_Amphetamines__c,
          TCU_Q11k_Methamphetamine__c,     TCU_Q11j_Other_opiates__c,TCU_Q11i_Methadone__c,TCU_Q11h_Heroin__c,
          TCU_Q11g_Cocaine__c,TCU_Q11f_Speedball__c,TCU_Q11e_Crack__c,TCU_Q11d_Inhalants__c,
          TCU_Q11c_Hallucinogens__c,TCU_Q11b_Marijuana__c,TCU_Q11a_Alcohol__c,
          TCU_Q10_Most_problematic_drug__c,TCU_Total_Score__c,Legacy_Database_Id__c
          from Assessment__c where id in: setAssmId]);
    /// mapResult = new MAP<string,string>();
      ID parentId;
      integer k = 0;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
          string tscore;
         try{tscore = string.valueOf(s.TCU_Total_Score__c);}
         catch (exception e){tscore = '';} 

         if (setInserted.contains(parentId) == false){
           oneMigrate = new  TCUassessment__c(AssessmentContainerId__c = mapParentIds.get(parentId),
          TCU_Q9_Get_sick_when_quitting__c = s.TCU_Q9_Get_sick_when_quitting__c,
          TCU_Q8_Took_drugs_to_avoid_withdrawal__c = s.TCU_Q8_Took_drugs_to_avoid_withdrawal__c,  
          TCU_Q7_Increase_drug_amount__c = s.TCU_Q7_Increase_drug_amount__c,  
          TCU_Q6c_physical_or_medical_problems__c = s.TCU_Q6c_physical_or_medical_problems__c,
          TCU_Q6b_Problems_w_family_friends_work__c = s.TCU_Q6b_Problems_w_family_friends_work__c,  
          TCU_Q6a_Emotional_and_psych_problems__c = s.TCU_Q6a_Emotional_and_psych_problems__c,  
          TCU_Q5_Spend_less_time_at_work__c = s.TCU_Q5_Spend_less_time_at_work__c,  
          TCU_Q4b_Caused_an_accident__c = s.TCU_Q4b_Caused_an_accident__c,  
          TCU_Q4a_Kept_you_from_doing_work_school__c = s.TCU_Q4a_Kept_you_from_doing_work_school__c,  
          TCU_Q3_Spend_a_lot_of_time__c = s.TCU_Q3_Spend_a_lot_of_time__c,TCU_Q2_Try_to_cut_down__c = s.TCU_Q2_Try_to_cut_down__c,  
          TCU_Q1_Longer_more_drugs_than_intended__c = s.TCU_Q1_Longer_more_drugs_than_intended__c,  
          TCU_Q13_How_serious_are_your_problems__c = s.TCU_Q13_How_serious_are_your_problems__c,  
          TCU_Q12_How_often_did_you_inject__c = s.TCU_Q12_How_often_did_you_inject__c,   
          TCU_Q11n_Other_drugs_frequency__c = s.TCU_Q11n_Other_drugs_frequency__c,
          TCU_Q11n_Other_drugs__c = s.TCU_Q11n_Other_drugs__c,
          TCU_Q11m_Barbiturates__c = s.TCU_Q11m_Barbiturates__c,
          TCU_Q11l_Amphetamines__c = s.TCU_Q11l_Amphetamines__c,
          TCU_Q11k_Methamphetamine__c = s.TCU_Q11k_Methamphetamine__c,
          TCU_Q11j_Other_opiates__c = s.TCU_Q11j_Other_opiates__c,
          TCU_Q11i_Methadone__c = s.TCU_Q11i_Methadone__c,
          TCU_Q11h_Heroin__c = s.TCU_Q11h_Heroin__c,
          TCU_Q11g_Cocaine__c = s.TCU_Q11g_Cocaine__c,
          TCU_Q11f_Speedball__c = s.TCU_Q11f_Speedball__c,
          TCU_Q11e_Crack__c = s.TCU_Q11e_Crack__c,
          TCU_Q11d_Inhalants__c = s.TCU_Q11d_Inhalants__c,
          TCU_Q11c_Hallucinogens__c = s.TCU_Q11c_Hallucinogens__c,
          TCU_Q11b_Marijuana__c = s.TCU_Q11b_Marijuana__c,
          TCU_Q11a_Alcohol__c = s.TCU_Q11a_Alcohol__c,
          TCU_Q10_Most_problematic_drug__c = s.TCU_Q10_Most_problematic_drug__c);
          lstMigrate.add(oneMigrate);
          k++;
        }}         numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate; 
                     AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'TCU II' limit 1];
         al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
        MAP<string,string> mapResult = new MAP<string,string>();

      //               LSCMI  16   
                
       void doLSCMI(){
         integer k = 0;
      Map<ID,string>  mapParentIds = new Map<ID,string>();
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'LS/CMI' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (LSCMI__c cc : [select AssessmentContainerId__c from LSCMI__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
        MAP<string,string> mapResult = new MAP<string,string>();
        LSCMI__c oneMigrate = new  LSCMI__c();
        List< LSCMI__c> lstMigrate = new List< LSCMI__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select contact__c,id,Weight__c,Survey_Notes__c,Survey_Date__c,Overall_Risk_Category__c,  
          LSCMI_Subscale_8_Risk_Level__c,LSCMI_Subscale_8_Anti_social_Pattern__c,  
          LSCMI_Subscale_7_Risk_Level__c,LSCMI_Subscale_7_Pro_criminal_Attitude__c, 
          LSCMI_Subscale_6_Risk_Level__c,LSCMI_Subscale_6_Alcohol_Drug_Problem__c, 
          LSCMI_Subscale_5_Risk_Level__c,LSCMI_Subscale_5_Companions__c, 
          LSCMI_Subscale_4_Risk_Level__c,LSCMI_Subscale_4_Leisure_Recreation__c,
          LSCMI_Subscale_3_Risk_Level__c,LSCMI_Subscale_3_Family_Marital__c,
          LSCMI_Subscale_2_Risk_Level__c,LSCMI_Subscale_2_Education_Employment__c,
          LSCMI_Subscale_1_Criminal_History__c,LSCMI_Strengths__c,LSCMI_Result__c,Legacy_Database_Id__c
          from Assessment__c where id in: setAssmId]);
      numbers = lstAssm.size();
      ID parentId;
      string tscore;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
        if (setInserted.contains(parentId) == false){
        oneMigrate = new  LSCMI__c(AssessmentContainerId__c = mapParentIds.get(parentId),
         Weight__c = s.Weight__c,Survey_Notes__c = s.Survey_Notes__c,  
           Survey_Date__c = s.Survey_Date__c,Overall_Risk_Category__c = s.Overall_Risk_Category__c,  
           LSCMI_Subscale_8_Risk_Level__c = s.LSCMI_Subscale_8_Risk_Level__c,
           LSCMI_Subscale_8_Anti_social_Pattern__c = s.LSCMI_Subscale_8_Anti_social_Pattern__c,  
           LSCMI_Subscale_7_Risk_Level__c = s.LSCMI_Subscale_7_Risk_Level__c,  
           LSCMI_Subscale_7_Pro_criminal_Attitude__c = s.LSCMI_Subscale_7_Pro_criminal_Attitude__c,  
           LSCMI_Subscale_6_Risk_Level__c = s.LSCMI_Subscale_6_Risk_Level__c,  
           LSCMI_Subscale_6_Alcohol_Drug_Problem__c = s.LSCMI_Subscale_6_Alcohol_Drug_Problem__c,  
           LSCMI_Subscale_5_Risk_Level__c = s.LSCMI_Subscale_5_Risk_Level__c,  
           LSCMI_Subscale_5_Companions__c = s.LSCMI_Subscale_5_Companions__c,  
           LSCMI_Subscale_4_Risk_Level__c = s.LSCMI_Subscale_4_Risk_Level__c,   
           LSCMI_Subscale_4_Leisure_Recreation__c = s.LSCMI_Subscale_4_Leisure_Recreation__c,
           LSCMI_Subscale_3_Risk_Level__c = s.LSCMI_Subscale_3_Risk_Level__c,
           LSCMI_Subscale_3_Family_Marital__c = s.LSCMI_Subscale_3_Family_Marital__c,
           LSCMI_Subscale_2_Risk_Level__c = s.LSCMI_Subscale_2_Risk_Level__c,
           LSCMI_Subscale_2_Education_Employment__c = s.LSCMI_Subscale_2_Education_Employment__c,
           LSCMI_Subscale_1_Criminal_History__c = s.LSCMI_Subscale_1_Criminal_History__c,
           LSCMI_Strengths__c = s.LSCMI_Strengths__c,LSCMI_Result__c = s.LSCMI_Result__c,
          legacy_database_id__c = s.Legacy_Database_Id__c);
    ///      try {tscore = string.valueOf(s.LSCMI_Result__c);}
    //      catch (exception e) {tscore = '';}
    //      mapResult.put(parentId,string.valueOf(s.LSCMI_Result__c));
                lstMigrate.add(oneMigrate);
         k++;}}
              numbers = k;
        if (lstMigrate.size() != 0){
           upsert lstMigrate;  
        
             
//        for (integer i = 0; i < assmContList.Size(); i++){
 //         assmContList[i].Result__c = mapResult.get(assmContList[i].id);
 //       }
  //       update assmContList;
            AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'LS/CMI' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
    
         //               LSIR  15 
                
       void doLSIR(){
       Map<ID,string>  mapParentIds = new Map<ID,string>();  
 Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'LSI R' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (LSIR__c cc : [select AssessmentContainerId__c from LSIR__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
             integer k = 0;
        MAP<string,string> mapResult = new MAP<string,string>(); 
        LSIR__c oneMigrate = new  LSIR__c(); 
        List<LSIR__c> lstMigrate = new  List<LSIR__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select contact__c,id,Survey_Notes__c,Survey_Date__c,LSI_R_SV_Score__c,LSIRSV_Original_Assessment__c,Assessment_Date__c,
       Assessment_Completed_by__c,Assessment_Completed_on__c,legacy_database_id__c
          from Assessment__c where id in: setAssmId]);
      ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
        if (setInserted.contains(parentId) == false){
        oneMigrate = new  LSIR__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        Survey_Notes__c = s.Survey_Notes__c,Survey_Date__c = s.Survey_Date__c,LSI_R_SV_Score__c = s.LSI_R_SV_Score__c,
        LSIRSV_Original_Assessment__c = s.LSIRSV_Original_Assessment__c,Legacy_Database_Id__c = s.legacy_database_id__c);
          lstMigrate.add(oneMigrate);
          k++;}} numbers = k;
        if (lstMigrate.size() != 0){ 
           upsert lstMigrate;  
           AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
            assessmentName__c =: 'LSI R' limit 1];
           al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}   
   
        //               HEALTH Screen  9
     void doHEALTH(){
        integer k = 0;
       Map<ID,string>  mapParentIds = new Map<ID,string>();  
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Health Screen' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (Health_Screen__c cc : [select AssessmentContainerId__c from Health_Screen__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
        MAP<string,string> mapResult = new MAP<string,string>();
        Health_Screen__c oneMigrate = new  Health_Screen__c();
        List< Health_Screen__c> lstMigrate = new List< Health_Screen__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select  id,contact__c,of_general_health_hospital_admissions__c,
        of_cigarettes_per_day__c,What_did_you_receive_in_jail__c,Weight__c,Want_help_getting__c,
        Time_to_first_cigarette__c,Temperature__c,Smoking_status__c,Smoking_information__c,
        Number_of_doctor_visits_in_the_last_year__c,Notes_Psych__c,Notes_LPN__c,
        List_any_prescribed_painkillers__c,If_client_is_in_pain_rate_intensity__c,
        Height__c,Current_Medical_Problems__c,Client_prescribed_pain_medications__c,
        Client_in_pain__c,Blood_Pressure__c,Pulse__c,Number_of_general_health_ER_visits__c,Respiratory_rate__c
        from Assessment__c where  id in: setAssmId]);
       ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
            if (setInserted.contains(parentId) == false){
        oneMigrate = new  Health_Screen__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        of_general_health_hospital_admissions__c = s.of_general_health_hospital_admissions__c,
        of_cigarettes_per_day__c = s.of_cigarettes_per_day__c,
        What_did_you_receive_in_jail__c = s.What_did_you_receive_in_jail__c,
        Weight__c = s.Weight__c,Want_help_getting__c = s.Want_help_getting__c,
        Time_to_first_cigarette__c = s.Time_to_first_cigarette__c,
        Pulse__c = s.Pulse__c,Number_of_general_health_ER_visits__c =  s.Number_of_general_health_ER_visits__c,
        Respiratory_rate__c = s.Respiratory_rate__c,Temperature__c = s.Temperature__c,
        Smoking_status__c = s.Smoking_status__c,Smoking_information__c = s.Smoking_information__c,
        Number_of_doctor_visits_in_the_last_year__c = s.Number_of_doctor_visits_in_the_last_year__c,
        Notes_Psych__c = s.Notes_Psych__c,Notes_LPN__c = s.Notes_LPN__c,
        List_any_prescribed_painkillers__c = s.List_any_prescribed_painkillers__c,
        If_client_is_in_pain_rate_intensity__c = s.If_client_is_in_pain_rate_intensity__c,
        Height__c = s.Height__c,Current_Medical_Problems__c = s.Current_Medical_Problems__c,
        Client_prescribed_pain_medications__c = s.Client_prescribed_pain_medications__c,
        Client_in_pain__c = s.Client_in_pain__c,Blood_Pressure__c = s.Blood_Pressure__c);
        lstMigrate.add(oneMigrate); k++;
        }}      numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate; 
         AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'Health Screen' limit 1];
         al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}     
              
 
        //               PCLC  10  
       void doPCLC(){ 
         integer k = 0;
       Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'PCL-C' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
      setAssmId.add(ac.recIdFromassessment__c);} 
      Set<string> setInserted = new Set<string>();
     for (PCLC__c cc : [select AssessmentContainerId__c from PCLC__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
        MAP<string,string> mapResult = new MAP<string,string>();
         AssessmentContainer__c assmCont = new AssessmentContainer__c(); 
        List<AssessmentContainer__c> assmContList = new List<AssessmentContainer__c>(); 
        PCLC__c oneMigrate = new  PCLC__c();
        List< PCLC__c> lstMigrate = new List<PCLC__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select contact__c,id,PCLC_Trouble_remembering__c,
       PCLC_Trouble_falling_or_staying_asleep__c,PCLC_Loss_of_interest__c,PCLC_Having_physical_reactions__c,
       PCLC_Having_difficulty_concentrating__c,PCLC_Future_cut_short__c,PCLC_Feeling_jumpy_or_easily_startled__c,
       PCLC_Feeling_irritable__c,PCLC_Feeling_emotionally_numb__c,PCLC_Feeling_distant_or_cut_off__c,
       PCLC_Disturbing_memories_thoughts__c,PCLC_Disturbing_dreams__c,PCLC_Being_super_alert_or_watchful__c,
       PCLC_Avoid_thinking_about_the_past__c,PCLC_Avoid_activities_or_situations__c,PCLC_Reliving_a_stressful_experience__c,
       PCLC_Upset_when_reminded_of_the_past__c from Assessment__c where id =: setAssmId]);
      ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
       if (setInserted.contains(parentid) == false){
        oneMigrate = new  PCLC__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        PCLC_Upset_when_reminded_of_the_past__c = s.PCLC_Upset_when_reminded_of_the_past__c,
        PCLC_Trouble_remembering__c = s.PCLC_Trouble_remembering__c,
        PCLC_Trouble_falling_or_staying_asleep__c = s.PCLC_Trouble_falling_or_staying_asleep__c,
        PCLC_Loss_of_interest__c = s.PCLC_Loss_of_interest__c,
        PCLC_Having_physical_reactions__c = s.PCLC_Having_physical_reactions__c,
        PCLC_Having_difficulty_concentrating__c = s.PCLC_Having_difficulty_concentrating__c,
        PCLC_Future_cut_short__c = s.PCLC_Future_cut_short__c,
        PCLC_Feeling_jumpy_or_easily_startled__c = s.PCLC_Feeling_jumpy_or_easily_startled__c,
        PCLC_Feeling_irritable__c = s.PCLC_Feeling_irritable__c,
        PCLC_Reliving_a_stressful_experience__c = s.PCLC_Reliving_a_stressful_experience__c,
        PCLC_Feeling_emotionally_numb__c = s.PCLC_Feeling_emotionally_numb__c,
        PCLC_Feeling_distant_or_cut_off__c = s.PCLC_Feeling_distant_or_cut_off__c,
        PCLC_Disturbing_memories_thoughts__c = s.PCLC_Disturbing_memories_thoughts__c,
        PCLC_Disturbing_dreams__c = s.PCLC_Disturbing_dreams__c,
        PCLC_Being_super_alert_or_watchful__c = s.PCLC_Being_super_alert_or_watchful__c,
        PCLC_Avoid_thinking_about_the_past__c = s.PCLC_Avoid_thinking_about_the_past__c,
          PCLC_Avoid_activities_or_situations__c = s.PCLC_Avoid_activities_or_situations__c);
          lstMigrate.add(oneMigrate);
          k++;}}      numbers = k;
        if ( lstMigrate.size() != 0){
        upsert lstMigrate; 
              AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'PCL-C' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
         upsert al;}}
    
             //               CEP BPS  11  TESTED
       void doBPS(){
         integer k = 0;
        Map<ID,string>  mapParentIds = new Map<ID,string>();  
 Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'CEP BPS' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (CEP_BPS__c cc : [select AssessmentContainerId__c from CEP_BPS__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
        MAP<string,string> mapResult = new MAP<string,string>();
        CEP_BPS__c oneMigrate = new  CEP_BPS__c();
        List<CEP_BPS__c> lstMigrate = new List<CEP_BPS__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select Workforce_Strengths__c, Treatments__c, Traumatic_Events__c, Spiritual_Identity__c,
       Six_Month_Goals__c, Service_Recommendations__c, Referrals_Not_Made__c, Referrals_Made__c, Referrals_Made_YN__c, 
       Personal_Strengths__c, Obstacles_to_Progress__c, Need_for_MHS__c, Meet_with_Counselor__c, 
       Living_Situation_Picklist__c, Living_Situation_Detail__c, Health_Issues__c, Genogram__c, 
       Diagnostic_Impressions__c, Current_Treatments_Provider_5__c, Current_Treatments_Provider_4__c, Current_Treatments_Provider_3__c,
       Current_Treatments_Provider_2__c, Current_Treatments_Provider_1__c,Current_Treatments_Issues_5__c, Current_Treatments_Issues_4__c, 
       Current_Treatments_Issues_3__c, Current_Treatments_Issues_2__c,Current_Treatments_Issues_1__c,  Current_Treatments_5__c, 
       Current_Treatments_4__c,  Current_Treatments_3__c,Current_Treatments_2__c,  Current_Treatments_1__c, 
       Current_External_Schedule_5__c,  Current_External_Schedule_4__c, Current_External_Schedule_3__c,  Current_External_Schedule_2__c, 
       Current_External_Schedule_1__c,  Current_External_Provider_5__c,Current_External_Provider_4__c,  Current_External_Provider_3__c, 
       Current_External_Provider_2__c,  Current_External_Provider_1__c,Current_External_End_5__c,  Current_External_End_4__c,
       Current_External_End_3__c,  Current_External_End_2__c,Current_External_End_1__c,  Cultural_Identity__c,
       Coping_with_Stress__c,Additional_Comments__c,Academic_Strengths__c 
       from Assessment__c where id in: setAssmId]); 
       ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
        if (setInserted.contains(parentId) == false){
        oneMigrate = new  CEP_BPS__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        Workforce_Strengths__c = s.Workforce_Strengths__c,
        Treatments__c = s.Treatments__c,
        Traumatic_Events__c = s.Traumatic_Events__c,
        Spiritual_Identity__c = s.Spiritual_Identity__c,
        Six_Month_Goals__c = s.Six_Month_Goals__c,
        Service_Recommendations__c = s.Service_Recommendations__c,
        Referrals_Not_Made__c = s.Referrals_Not_Made__c,
        Referrals_Made__c = s.Referrals_Made__c,
        Referrals_Made_YN__c = s.Referrals_Made_YN__c,
        Personal_Strengths__c = s.Personal_Strengths__c,
        Obstacles_to_Progress__c = s.Obstacles_to_Progress__c,
        Need_for_MHS__c = s.Need_for_MHS__c,
        Meet_with_Counselor__c = s.Meet_with_Counselor__c,
        Living_Situation_Picklist__c = s.Living_Situation_Picklist__c,
        Living_Situation_Detail__c = s.Living_Situation_Detail__c,
        Health_Issues__c = s.Health_Issues__c,
        Genogram__c = s.Genogram__c,
      Diagnostic_Impressions__c = s.Diagnostic_Impressions__c,
      Current_Treatments_Provider_5__c = s.Current_Treatments_Provider_5__c,
      Current_Treatments_Provider_4__c = s.Current_Treatments_Provider_4__c,
      Current_Treatments_Provider_3__c = s.Current_Treatments_Provider_3__c,
      Current_Treatments_Provider_2__c = s.Current_Treatments_Provider_2__c,
      Current_Treatments_Provider_1__c = s.Current_Treatments_Provider_1__c,
      Current_Treatments_Issues_5__c = s.Current_Treatments_Issues_5__c,
   Current_Treatments_Issues_4__c = s.Current_Treatments_Issues_4__c,
   Current_Treatments_Issues_3__c = s.Current_Treatments_Issues_3__c,
   Current_Treatments_Issues_2__c = s.Current_Treatments_Issues_2__c,
   Current_Treatments_Issues_1__c = s.Current_Treatments_Issues_1__c,
      Current_External_Schedule_5__c = s.Current_External_Schedule_5__c,
     Current_External_Schedule_4__c = s.Current_External_Schedule_4__c,
     Current_External_Schedule_3__c = s.Current_External_Schedule_3__c,
     Current_External_Schedule_2__c = s.Current_External_Schedule_2__c,
     Current_External_Schedule_1__c = s.Current_External_Schedule_1__c,
      Current_External_Provider_5__c = s.Current_External_Provider_5__c,
      Current_External_Provider_4__c = s.Current_External_Provider_4__c,
      Current_External_Provider_3__c = s.Current_External_Provider_3__c,
      Current_External_Provider_2__c = s.Current_External_Provider_2__c,
      Current_External_Provider_1__c = s.Current_External_Provider_1__c,
      Current_External_End_5__c = s.Current_External_End_5__c,
    Current_External_End_4__c = s.Current_External_End_4__c,
    Current_External_End_3__c = s.Current_External_End_3__c,
    Current_External_End_2__c = s.Current_External_End_2__c,
    Current_External_End_1__c = s.Current_External_End_1__c,
      Cultural_Identity__c = s.Cultural_Identity__c,
      Coping_with_Stress__c = s.Coping_with_Stress__c,
      Additional_Comments__c = s.Additional_Comments__c,
      Academic_Strengths__c = s.Academic_Strengths__c);
    lstMigrate.add(oneMigrate);
    k++; }}      numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate; 
        AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'CEP BPS' limit 1];
       al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}} 

     ///   CEP_ICD    12
   void doICD(){
       integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();  
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'CEP ICD' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
        
     System.Debug('\n\n XXX setAssmId: ' + setAssmId);   
     Set<string> setInserted = new Set<string>();
     for (CEP_ICD__c cc : [select AssessmentContainerId__c from CEP_ICD__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
          MAP<string,string> mapResult = new MAP<string,string>();
        CEP_ICD__c oneMigrate = new  CEP_ICD__c();
    List<CEP_ICD__c> lstMigrate = new List<CEP_ICD__c>();
    List<Assessment__c> lstAssm = new List<Assessment__c>([         
    Select id,TASC__c,Sections_Passed_TASC__c,Sections_Passed_Regents__c,Sections_Passed_GED__c,
    Regents__c,Other_Education_Attended__c,Mo_Yr_Taken_TASC__c,Mo_Yr_Taken_Regents__c,
    Mo_Yr_Taken_GED__c,Mo_Yr_Last_Attended_School__c,Mo_Yr_Last_Attended_Other__c,Last_School_Attended__c,
    Last_Grade_Completed__c,ICD_Services__c,
    GED__c,Employment_Section_1__c,Education_Plan__c,Education_Client_Narrative__c,Credits_Attained__c
    From Assessment__c where id in: setAssmId]);           
        ID parentId;
        integer lastgrade;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
          try{
             lastgrade = integer.valueOf(s.Last_Grade_Completed__c);}
           catch (Exception e){
              lastgrade = 0;
          }
      if (setInserted.contains(parentId) == false){
          oneMigrate = new  CEP_ICD__c(AssessmentContainerId__c = mapParentIds.get(parentId),
          TASC__c = s.TASC__c,Sections_Passed_TASC__c = s.Sections_Passed_TASC__c, 
          Sections_Passed_Regents__c = s.Sections_Passed_Regents__c,Sections_Passed_GED__c = s.Sections_Passed_GED__c, 
          Regents__c = s.Regents__c,Other_Education_Attended__c = s.Other_Education_Attended__c, 
          Mo_Yr_Taken_TASC__c = s.Mo_Yr_Taken_TASC__c,Mo_Yr_Taken_Regents__c = s.Mo_Yr_Taken_Regents__c, 
          Mo_Yr_Taken_GED__c = s.Mo_Yr_Taken_GED__c,Mo_Yr_Last_Attended_School__c = s.Mo_Yr_Last_Attended_School__c,
          Mo_Yr_Last_Attended_Other__c = s.Mo_Yr_Last_Attended_Other__c,Last_School_Attended__c = s.Last_School_Attended__c,
          ICD_Services__c = s.ICD_Services__c,GED__c = s.GED__c,Employment_Section_1__c = s.Employment_Section_1__c, 
          Education_Plan__c = s.Education_Plan__c,Education_Client_Narrative__c = s.Education_Client_Narrative__c, 
          Credits_Attained__c = s.Credits_Attained__c,Last_Grade_Completed__c = lastgrade);
            lstMigrate.add(oneMigrate);  
          k++; }}numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate; 
        AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'CEP ICD' limit 1];
      al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
      
//             try{
 //               oneMigrate.Last_Grade_Completed__c = integer.valueOf(s.Last_Grade_Completed__c);}
  //           catch (Exception e){
   //            oneMigrate.Last_Grade_Completed__c = 0;
   //          }

        //   Life Events Checklist // 13

 
  ///   CRAFFT   
     void doCRAFFT(){
     Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'CRAFFT' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
      setAssmId.add(ac.recIdFromassessment__c);} 

     Set<string> setInserted = new Set<string>();
     for (CRAFFT__c cc : [select AssessmentContainerId__c from CRAFFT__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
      ID parentId;
      integer k = 0;
      MAP<string,string> mapResult = new MAP<string,string>();
      AssessmentContainer__c assmCont = new AssessmentContainer__c(); 
        List<AssessmentContainer__c> assmContList = new List<AssessmentContainer__c>(); 
        CRAFFT__c oneMigrate = new  CRAFFT__c();
        List<CRAFFT__c> lstMigrate = new List<CRAFFT__c>();
        List<Assessment__c> lstAssm = new List<Assessment__c>([
       Select contact__c,id,Assessment_Date__c,Assessment_Completed_by__c,Assessment_Completed_on__c,
       CRAFFT_B6_In_TROUBLE_while_using_drugs__c,CRAFFT_B5_FAMILY_FRIENDS_say_to_cut_down__c,
       CRAFFT_B4_Ever_FORGET_what_you_did__c,CRAFFT_B3_Use_drugs_or_alcohol_ALONE__c, 
       CRAFFT_B2_Use_drugs_or_alcohol_to_RELAX__c,CRAFFT_B1_In_CAR_driven_by_someone_high__c,
       CRAFFT_A3_Use_anything_else_to_get_high__c,CRAFFT_A2_Smoke_any_marijuana_or_hashish__c,
       CRAFFT_A1_Drink_any_alcohol__c From Assessment__c where id in: setAssmId]); 
       for (Assessment__c s : lstAssm){
         parentId = s.id;
         if (setInserted.contains(parentid) == false){
        oneMigrate = new  CRAFFT__c(AssessmentContainerId__c = mapParentIds.get(parentId),
       CRAFFT_B6_In_TROUBLE_while_using_drugs__c = s.CRAFFT_B6_In_TROUBLE_while_using_drugs__c,
       CRAFFT_B5_FAMILY_FRIENDS_say_to_cut_down__c = s.CRAFFT_B5_FAMILY_FRIENDS_say_to_cut_down__c,
      CRAFFT_B4_Ever_FORGET_what_you_did__c = s.CRAFFT_B4_Ever_FORGET_what_you_did__c,
      CRAFFT_B3_Use_drugs_or_alcohol_ALONE__c = s.CRAFFT_B3_Use_drugs_or_alcohol_ALONE__c ,
      CRAFFT_B2_Use_drugs_or_alcohol_to_RELAX__c = s.CRAFFT_B2_Use_drugs_or_alcohol_to_RELAX__c,
      CRAFFT_B1_In_CAR_driven_by_someone_high__c = s.CRAFFT_B1_In_CAR_driven_by_someone_high__c,
      CRAFFT_A3_Use_anything_else_to_get_high__c = s.CRAFFT_A3_Use_anything_else_to_get_high__c,
      CRAFFT_A2_Smoke_any_marijuana_or_hashish__c = s.CRAFFT_A2_Smoke_any_marijuana_or_hashish__c,
      CRAFFT_A1_Drink_any_alcohol__c = s.CRAFFT_A1_Drink_any_alcohol__c);
       lstMigrate.add(oneMigrate);
        k++;}}      numbers = k;
        if ( lstMigrate.size() != 0){
        upsert lstMigrate;  
       AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'CRAFFT' limit 1];
       al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}     

/////////////////////  BJMHS 
       void doBJMHS(){
       integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();  
 Set<string> setAssmId =  new Set<string>();    
     List<AssessmentContainer__c>  lstcontainer =   [select id,recIdFromassessment__c,assmresult__c from AssessmentContainer__c
     where assessmentName__c =: 'BJMHS' ]; 
     for (AssessmentContainer__c ac : lstcontainer){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (BJMHS__c cc : [select AssessmentContainerId__c from BJMHS__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
        MAP<string,string> mapResult = new MAP<string,string>();
        BJMHS__c oneMigrate = new  BJMHS__c();
        List<BJMHS__c> lstMigrate = new List<BJMHS__c>();
        List<Assessment__c> lstAssm = new List<Assessment__c>();
        lstAssm = [Select BJMHS_Q1_Mind_Control__c,BJMHS_Q2_Mind_Reading__c,BJMHS_Q3_weight_Gain__c,
       BJMHS_Q4_More_Active__c,BJMHS_Q5_Talking_Slowly__c,BJMHS_Q6_Feel_Sinful__c,BJMHS_Referral_Recommended_by_Assessment__c,
       BJMHS_Q7_Taking_Medication__c,BJMHS_Q8_Hospital__c,BJMHS_Referral_Recommended_by_Screener__c,
       Survey_Notes__c From Assessment__c where id in: setAssmId]; 
      ID parentId;
  //    string cResult;
        for (Assessment__c s : lstAssm){ 
          parentId = s.id;
          if (setInserted.contains(parentId) == false){
        oneMigrate = new  BJMHS__c(AssessmentContainerId__c = mapParentIds.get(parentId), 
        Q1_Mind_Control__c = s.BJMHS_Q1_Mind_Control__c,Q2_Mind_Reading__c = s.BJMHS_Q2_Mind_Reading__c,
       Q3_weight_Gain__c = s.BJMHS_Q3_weight_Gain__c,Q4_More_Active__c = s.BJMHS_Q4_More_Active__c ,
       Q5_Talking_Slowly__c = s.BJMHS_Q5_Talking_Slowly__c, Q6_Feel_Sinful__c = s.BJMHS_Q6_Feel_Sinful__c,
       Q7_Taking_Medication__c = s.BJMHS_Q7_Taking_Medication__c,Q8_Hospital__c = s.BJMHS_Q8_Hospital__c,
       Referral_Recommended_by_Screener__c = s.BJMHS_Referral_Recommended_by_Screener__c,
       Survey_Notes__c =  s.Survey_Notes__c);
  //     if (s.BJMHS_Referral_Recommended_by_Screener__c == 'Yes' || s.BJMHS_Referral_Recommended_by_Assessment__c == 'Yes')
   //        mapResult.put(oneMigrate.AssessmentContainerId__c,'Assessment Recomended');
       lstMigrate.add(oneMigrate);
        k++;}}numbers = k;
        upsert lstMigrate;  
        AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'BJMHS' limit 1];
   al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;
    //    string Result;
    //    List<AssessmentContainer__c> lstUpdate = new List<AssessmentContainer__c>();
     //   AssessmentContainer__c oneUpdate = new AssessmentContainer__c();
     //   for (integer i = 0; i < lstcontainer.Size(); i++){
     //       oneUpdate = new AssessmentContainer__c();
     //      Result = mapResult.get(lstcontainer[i].id);
     //       if (Result <> null){
     //           oneUpdate = new AssessmentContainer__c(assmResult__c = Result,id = lstcontainer[i].id);
     //           lstUpdate.add(oneUpdate);
     //       }}
     //   update lstUpdate;
        } 
    
  ///   MHSF        
    void doMHSF(){
      integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();  
 Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'MHSF' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (MHSF__c cc : [select AssessmentContainerId__c from MHSF__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
     // Source: Assessment    target: MHSF__c   
     MAP<string,string> mapResult = new MAP<string,string>();
         AssessmentContainer__c assmCont = new AssessmentContainer__c(); 
        List<AssessmentContainer__c> assmContList = new List<AssessmentContainer__c>(); 
        MHSF__c oneMigrate = new  MHSF__c();
        List<MHSF__c> lstMigrate = new List<MHSF__c>();
        List<Assessment__c> lstAssm = new List<Assessment__c>([
        Select id,Assessment_Date__c,Assessment_Completed_by__c,Assessment_Completed_on__c,
        MHSF_Q17_Special_Learning_Problem__c, MHSF_Q16_Gambling_impulse__c,
        MHSF_Q15_Persistent_repetitive_impulse__c,MHSF_Q14_Attacks_of_anxiety__c,
        MHSF_Q13_Full_of_energy__c, MHSF_Q12_Worried_about_gaining_weight__c,
        MHSF_Q11_Emotional_problems_with_sex__c, MHSF_Q10_People_are_against_you__c,
        MHSF_Q9_Given_in_to_an_aggressive_urge__c,MHSF_Q8_Experienced_any_strong_fears__c,
        MHSF_Q7_Have_you_ever_had_nightmares__c,MHSF_Q6b_Ever_attempt_to_kill_yourself__c,
        MHSF_Q6a_Been_depressed__c,MHSF_Q5_Heard_voices__c,
        MHSF_Q4_Been_hospitalized_for_psych__c,MHSF_Q3_Ever_been_advised_to_take_meds__c,
        MHSF_Q2_Felt_you_needed_help__c,MHSF_Q1_Talked_to_psychiatrist__c
        From Assessment__c where id in: setAssmId]);  
        numbers = lstAssm.size();
      ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
            if (setInserted.contains(parentId) == false){
        oneMigrate = new  MHSF__c(AssessmentContainerId__c = mapParentIds.get(parentId),
          MHSF_Q17_Special_Learning_Problem__c = s.MHSF_Q17_Special_Learning_Problem__c,
          MHSF_Q16_Gambling_impulse__c = s.MHSF_Q16_Gambling_impulse__c,
          MHSF_Q15_Persistent_repetitive_impulse__c = s.MHSF_Q15_Persistent_repetitive_impulse__c,
          MHSF_Q14_Attacks_of_anxiety__c = s.MHSF_Q14_Attacks_of_anxiety__c,
          MHSF_Q13_Full_of_energy__c = s.MHSF_Q13_Full_of_energy__c,
          MHSF_Q12_Worried_about_gaining_weight__c = s.MHSF_Q12_Worried_about_gaining_weight__c,
          MHSF_Q11_Emotional_problems_with_sex__c = s.MHSF_Q11_Emotional_problems_with_sex__c,
          MHSF_Q10_People_are_against_you__c = s.MHSF_Q10_People_are_against_you__c,
          MHSF_Q09_Given_in_to_an_aggressive_urge__c = s.MHSF_Q9_Given_in_to_an_aggressive_urge__c,
          MHSF_Q08_Experienced_any_strong_fears__c = s.MHSF_Q8_Experienced_any_strong_fears__c,
          MHSF_Q07_Have_you_ever_had_nightmares__c = s.MHSF_Q7_Have_you_ever_had_nightmares__c,
          MHSF_Q06b_Ever_attempt_to_kill_yourself__c = s.MHSF_Q6b_Ever_attempt_to_kill_yourself__c,
          MHSF_Q06a_Been_depressed__c = s.MHSF_Q6a_Been_depressed__c,
          MHSF_Q05_Heard_voices__c = s.MHSF_Q5_Heard_voices__c,
          MHSF_Q04_Been_hospitalized_for_psych__c = s.MHSF_Q4_Been_hospitalized_for_psych__c,
          MHSF_Q03_Ever_been_advised_to_take_meds__c = s.MHSF_Q3_Ever_been_advised_to_take_meds__c,
          MHSF_Q02_Felt_you_needed_help__c = s.MHSF_Q2_Felt_you_needed_help__c,
          MHSF_Q01_Talked_to_psychiatrist__c = s.MHSF_Q1_Talked_to_psychiatrist__c);          
         lstMigrate.add(oneMigrate);
         k++;}}      numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate;
   AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'MHSF' limit 1];
      al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;         }}   

   //            UCLA_PTSD_DSM_V    17
    void doUCLA_PTSD_DSM_V(){
       integer k = 0;
     MAP<string,string> mapResult = new MAP<string,string>();
    Map<ID,string>  mapParentIds = new Map<ID,string>();  
 Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'UCLA PTSD DSM V' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (UCLA_PTSD_DSM_V__c cc : [select AssessmentContainerId__c from  UCLA_PTSD_DSM_V__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
       UCLA_PTSD_DSM_V__c  oneMigrate = new  UCLA_PTSD_DSM_V__c ();
        List<UCLA_PTSD_DSM_V__c > lstMigrate = new List<UCLA_PTSD_DSM_V__c >();
        List<Assessment__c> lstAssm = new List<Assessment__c>([
        Select UC_Trauma_History_Profile_Summary__c,UC_SelfRpt_Q15_Anything_else__c,
         UC_SelfRpt_Q14_Died__c,UC_SelfRpt_Q13_Forced_sex__c,UC_SelfRpt_Q12_medical_treatment__c,
         UC_SelfRpt_Q11_loved_one__c,UC_SelfRpt_Q10_touch__c,UC_SelfRpt_Q09_dead_body__c,
         UC_SelfRpt_Q08_someone_beaten__c,UC_SelfRpt_Q07_school__c,
         UC_SelfRpt_Q06_family_member__c,UC_SelfRpt_Q05_Hit_hard__c,UC_SelfRpt_Q04_war__c,
         UC_SelfRpt_Q03_accident__c,UC_SelfRpt_Q02_disaster__c,UC_SelfRpt_Q01_History__c,
         UC_SelfRpt_Most_Impacted_By__c,UC_SelfRpt_Clinician_Description__c,
         UC_SelfRpt_Age_Impacted__c,UC_Reaction_Q31__c,UC_Reaction_Q30__c,
         UC_Reaction_Q29__c,UC_Reaction_Q28__c,UC_Reaction_Q27__c,
         UC_Reaction_Q26__c,UC_Reaction_Q25__c,UC_Reaction_Q24__c,UC_Reaction_Q23__c,
         UC_Reaction_Q22__c,UC_Reaction_Q21__c,UC_Reaction_Q20__c,UC_Reaction_Q19__c,
         UC_Reaction_Q18__c,UC_Reaction_Q17__c,UC_Reaction_Q16__c,UC_Reaction_Q15__c,
         UC_Reaction_Q14__c,UC_Reaction_Q13__c,UC_Reaction_Q12__c,UC_Reaction_Q11__c,
         UC_Reaction_Q10__c,UC_Reaction_Q09__c,UC_Reaction_Q08__c,UC_Reaction_Q07__c,
         UC_Reaction_Q06__c,UC_Reaction_Q05__c,UC_Reaction_Q04__c,UC_Reaction_Q03__c,
         UC_Reaction_Q02__c,UC_Reaction_Q01__c,
         UC_PTSD_RI__c,UC_Clinical_School_Q2__c,UC_Clinical_School_Q1__c,UC_Clinical_School_Describe__c,UC_Clinical_Peer_Q1__c,
         UC_Clinical_Home_Q3__c,UC_Clinical_Home_Q1__c,UC_Clinical_Home_Describe__c,UC_Clinical_Distress_Q1__c,UC_Clinical_Developmental_Q1__c,
         UC_Clinical_Developmental_Other__c,UC_Clinical_Home_Q2__c,
         UC_CD2_OTHER_Describe__c
         From Assessment__c where id in: setAssmId]);
      ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
          if (setInserted.contains(parentId) == false){
        oneMigrate = new  UCLA_PTSD_DSM_V__c(AssessmentContainerId__c = mapParentIds.get(parentId),
          UC_Trauma_History_Profile_Summary__c = s.UC_Trauma_History_Profile_Summary__c,
          UC_SelfRpt_Q15_Anything_else__c = s.UC_SelfRpt_Q15_Anything_else__c,
          UC_SelfRpt_Q14_Died__c = s.UC_SelfRpt_Q14_Died__c,UC_SelfRpt_Q13_Forced_sex__c = s.UC_SelfRpt_Q13_Forced_sex__c,
          UC_SelfRpt_Q12_medical_treatment__c = s.UC_SelfRpt_Q12_medical_treatment__c,
          UC_SelfRpt_Q11_loved_one__c = s.UC_SelfRpt_Q11_loved_one__c,UC_SelfRpt_Q10_touch__c = s.UC_SelfRpt_Q10_touch__c,
          UC_SelfRpt_Q09_dead_body__c = s.UC_SelfRpt_Q09_dead_body__c,UC_SelfRpt_Q08_someone_beaten__c = s.UC_SelfRpt_Q08_someone_beaten__c,
          UC_SelfRpt_Q07_school__c = s.UC_SelfRpt_Q07_school__c,UC_SelfRpt_Q06_family_member__c = s.UC_SelfRpt_Q06_family_member__c,
          UC_SelfRpt_Q05_Hit_hard__c = s.UC_SelfRpt_Q05_Hit_hard__c,UC_SelfRpt_Q04_war__c = s.UC_SelfRpt_Q04_war__c,
          UC_SelfRpt_Q03_accident__c = s.UC_SelfRpt_Q03_accident__c,UC_SelfRpt_Q02_disaster__c = s.UC_SelfRpt_Q02_disaster__c,
          UC_SelfRpt_Q01_History__c = s.UC_SelfRpt_Q01_History__c,UC_SelfRpt_Most_Impacted_By__c = s.UC_SelfRpt_Most_Impacted_By__c,
          UC_SelfRpt_Clinician_Description__c = s.UC_SelfRpt_Clinician_Description__c,UC_SelfRpt_Age_Impacted__c = s.UC_SelfRpt_Age_Impacted__c,
          UC_Reaction_Q31__c = s.UC_Reaction_Q31__c,UC_Reaction_Q30__c = s.UC_Reaction_Q30__c,UC_Reaction_Q29__c = s.UC_Reaction_Q29__c,
          UC_Reaction_Q28__c = s.UC_Reaction_Q28__c,UC_Reaction_Q27__c = s.UC_Reaction_Q27__c,UC_Reaction_Q26__c = s.UC_Reaction_Q26__c,
          UC_Reaction_Q25__c = s.UC_Reaction_Q25__c,UC_Reaction_Q24__c = s.UC_Reaction_Q24__c,UC_Reaction_Q23__c = s.UC_Reaction_Q23__c,
          UC_Reaction_Q22__c = s.UC_Reaction_Q22__c,UC_Reaction_Q21__c = s.UC_Reaction_Q21__c,UC_Reaction_Q20__c = s.UC_Reaction_Q20__c,
          UC_Reaction_Q19__c = s.UC_Reaction_Q19__c,UC_Reaction_Q18__c = s.UC_Reaction_Q18__c,UC_Reaction_Q17__c = s.UC_Reaction_Q17__c,
          UC_Reaction_Q16__c = s.UC_Reaction_Q16__c,UC_Reaction_Q15__c = s.UC_Reaction_Q15__c,UC_Reaction_Q14__c = s.UC_Reaction_Q14__c,
          UC_Reaction_Q13__c = s.UC_Reaction_Q13__c,UC_Reaction_Q12__c = s.UC_Reaction_Q12__c,UC_Reaction_Q11__c = s.UC_Reaction_Q11__c,
          UC_Reaction_Q10__c = s.UC_Reaction_Q10__c,UC_Reaction_Q09__c = s.UC_Reaction_Q09__c,UC_Reaction_Q08__c = s.UC_Reaction_Q08__c,
          UC_Reaction_Q07__c = s.UC_Reaction_Q07__c,UC_Reaction_Q06__c = s.UC_Reaction_Q06__c,UC_Reaction_Q05__c = s.UC_Reaction_Q05__c,
          UC_Reaction_Q04__c = s.UC_Reaction_Q04__c,UC_Reaction_Q03__c = s.UC_Reaction_Q03__c,UC_Reaction_Q02__c = s.UC_Reaction_Q02__c,
          UC_Reaction_Q01__c = s.UC_Reaction_Q01__c,UC_PTSD_RI__c = s.UC_PTSD_RI__c,UC_Clinical_School_Q2__c = s.UC_Clinical_School_Q2__c,
          UC_Clinical_School_Q1__c = s.UC_Clinical_School_Q1__c,UC_Clinical_School_Describe__c = s.UC_Clinical_School_Describe__c,
          UC_Clinical_Peer_Q1__c = s.UC_Clinical_Peer_Q1__c,UC_Clinical_Home_Q3__c = s.UC_Clinical_Home_Q3__c,
          UC_Clinical_Home_Q1__c = s.UC_Clinical_Home_Q1__c,UC_Clinical_Home_Describe__c = s.UC_Clinical_Home_Describe__c,
          UC_Clinical_Distress_Q1__c = s.UC_Clinical_Distress_Q1__c,UC_Clinical_Developmental_Q1__c = s.UC_Clinical_Developmental_Q1__c,
          UC_Clinical_Developmental_Other__c = s.UC_Clinical_Developmental_Other__c,UC_Clinical_Home_Q2__c = s.UC_Clinical_Home_Q2__c,
          UC_CD2_OTHER_Describe__c = s.UC_CD2_OTHER_Describe__c);         
       lstMigrate.add(oneMigrate);
       k++;}}numbers = k;
        if (lstMigrate.size() != 0){
        upsert lstMigrate;
 AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'UCLA PTSD DSM V' limit 1];
        al.recordsMigrated__c = k;
        upsert al;} inProcess = false;}     

      //   WRNA 19     TESTED
    void doWRNA(){
      integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();  
 Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'WRNA' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (WRNA__c cc : [select AssessmentContainerId__c from WRNA__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
         MAP<string,string> mapResult = new MAP<string,string>();
        WRNA__c  oneMigrate = new   WRNA__c ();
        List <WRNA__c> lstMigrate = new List< WRNA__c >();
        List<Assessment__c> lstAssm = new List<Assessment__c>([
        Select contact__c,id,WRNA_STR_Self_efficacy__c,WRNA_STR_Relationship_Support__c,
         WRNA_STR_Parental_Involvement__c,WRNA_STR_Family_Support__c,
         WRNA_STR_Educational_Strengths__c,WRNA_Risk_Factor_Housing_Safety__c,
         WRNA_Risk_Factor_Employment_Financial__c,WRNA_RF_Sexual_Abuse__c,
         WRNA_RF_Relationship_Dysfunction__c,WRNA_RF_Psychosis__c,
         WRNA_RF_Physical_Abuse__c,WRNA_RF_Parental_Stress__c,WRNA_RF_PTSD__c,
         WRNA_RF_History_of_mental_illness__c,WRNA_RF_Family_Conflict__c,
         WRNA_RF_Depression_anxiety__c,WRNA_RF_Child_abuse__c,WRNA_RF_Anger_hostility__c,
         WRNA_RF_Adult_Abuse__c from Assessment__c where id in: setAssmId]);  
      ID parentId;
        for (Assessment__c s : lstAssm){
          parentId = s.id;
         if (setInserted.contains(parentId) == false){
          oneMigrate = new  WRNA__c(AssessmentContainerId__c = mapParentIds.get(parentId),
          WRNA_STR_Self_efficacy__c = s.WRNA_STR_Self_efficacy__c,
          WRNA_STR_Relationship_Support__c = s.WRNA_STR_Relationship_Support__c,
          WRNA_STR_Parental_Involvement__c = s.WRNA_STR_Parental_Involvement__c,
          WRNA_STR_Family_Support__c = s.WRNA_STR_Family_Support__c,WRNA_STR_Educational_Strengths__c = s.WRNA_STR_Educational_Strengths__c,
          WRNA_Risk_Factor_Housing_Safety__c = s.WRNA_Risk_Factor_Housing_Safety__c,
          WRNA_Risk_Factor_Employment_Financial__c = s.WRNA_Risk_Factor_Employment_Financial__c,
          WRNA_RF_Sexual_Abuse__c = s.WRNA_RF_Sexual_Abuse__c,WRNA_RF_Relationship_Dysfunction__c = s.WRNA_RF_Relationship_Dysfunction__c,
          WRNA_RF_Psychosis__c = s.WRNA_RF_Psychosis__c,WRNA_RF_Physical_Abuse__c = s.WRNA_RF_Physical_Abuse__c,
          WRNA_RF_Parental_Stress__c = s.WRNA_RF_Parental_Stress__c,WRNA_RF_PTSD__c = s.WRNA_RF_PTSD__c,
          WRNA_RF_History_of_mental_illness__c = s.WRNA_RF_History_of_mental_illness__c,
          WRNA_RF_Family_Conflict__c = s.WRNA_RF_Family_Conflict__c,WRNA_RF_Depression_anxiety__c = s.WRNA_RF_Depression_anxiety__c,
          WRNA_RF_Child_abuse__c = s.WRNA_RF_Child_abuse__c,WRNA_RF_Anger_hostility__c = s.WRNA_RF_Anger_hostility__c,
          WRNA_RF_Adult_Abuse__c = s.WRNA_RF_Adult_Abuse__c);
       lstMigrate.add(oneMigrate);
       k++;}} numbers = k;
        upsert lstMigrate;
        if (lstMigrate.size() != 0){
        AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'WRNA' limit 1];
       al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}    
 
    void doCEPintake(){
      integer k = 0;
      Map<ID,string>  mapParentIds = new Map<ID,string>();  
 Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'CEP Intake' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (CEP_Intake__c cc : [select AssessmentContainerId__c from CEP_Intake__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
      MAP<string,string> mapResult = new MAP<string,string>();
      CEP_Intake__c  oneMigrate = new   CEP_Intake__c ();
      List <CEP_Intake__c> lstMigrate = new List<CEP_Intake__c>();
      List<Assessment__c> lstAssm = new List<Assessment__c>([
      Select contact__c,id, Leisure_Recreation_Notes__c,Legal__c,LastModifiedDate,LastModifiedById,Health__c,
      Family_Background__c,Employment_Section_1__c,Education_Section_1__c
      From Assessment__c where id in: setAssmId]); 
      ID parentId;
        for (Assessment__c s : lstAssm){ 
          parentId = s.id;
        if (setInserted.contains(parentId) == false){
          oneMigrate = new  CEP_Intake__c(AssessmentContainerId__c = mapParentIds.get(parentId),
         Leisure_Recreation_Notes__c = s.Leisure_Recreation_Notes__c,
         Legal__c = s.Legal__c,Health__c = s.Health__c,Family_Background__c = s.Family_Background__c,
         Employment_Section_1__c = s.Employment_Section_1__c,Education_Section_1__c = s.Education_Section_1__c);
         lstMigrate.add(oneMigrate);
         k++;}} numbers = k;
              upsert lstMigrate;
         if (lstMigrate.size() != 0){
       AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'CEP Intake' limit 1];
  al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}   
         
 //                                 code for results
/* 
 //                       BJMHS

     Map<string,string>  mapResult = new Map<string,string>(); 
   for (BJMHS__c r : [select AssessmentContainerId__c,Referral_Recommended_by_Screener__c,
     Referral_Recommended_by_Assessment__c from BJMHS__c]){
     if (r.Referral_Recommended_by_Screener__c == 'Yes' || r.Referral_Recommended_by_Assessment__c   == 'Yes')
      mapResult.put(r.AssessmentContainerId__c,'Referral recommended');
   }  

   string result;
   List<AssessmentContainer__c> lstUpdate = new List<AssessmentContainer__c>();
   AssessmentContainer__c oneUpdate = new AssessmentContainer__c();
   for (AssessmentContainer__c c : [select id, assmResult__c from AssessmentContainer__c where assessmentName__c =: 'BJMHS']){
     oneUpdate = new AssessmentContainer__c();
     Result = mapResult.get(c.id); 
     if (Result <> null){
         oneUpdate = new AssessmentContainer__c(assmResult__c = Result,id = c.id);
        lstUpdate.add(oneUpdate);
     }} 
      update lstUpdate; 
  system.debug('\n\n XXX lstUpdate: ' + lstUpdate.size()); 
 
 /* 
 //                       LSCMI
 
      Map<string,string>  mapUpload = new Map<string,string>();
     Map<string,string>  mapResult = new Map<string,string>(); 
   for (LSCMI__c r : [select AssessmentContainerId__c,Overall_Risk_Category__c,Legacy_Database_Id__c from LSCMI__c]){
        mapResult.put(r.AssessmentContainerId__c,'Risk Category: ' + r.Overall_Risk_Category__c);
        if (r.Legacy_Database_Id__c <> null)
            mapUpload.put(r.AssessmentContainerId__c,'1');
   }  

   string result,fileId;
   boolean upload;
   List<AssessmentContainer__c> lstUpdate = new List<AssessmentContainer__c>();
   AssessmentContainer__c oneUpdate = new AssessmentContainer__c();
   for (AssessmentContainer__c c : [select id, assmResult__c from AssessmentContainer__c where assessmentName__c =: 'LS/CMI']){
     oneUpdate = new AssessmentContainer__c();
     fileId = mapUpload.get(c.id); 
     if (fileId <> null )
        upload = true;
     else
        upload = false;
           
     Result = mapResult.get(c.id); 
     if (Result <> null){
         oneUpdate = new AssessmentContainer__c(assmResult__c = Result,id = c.id,uploaded__c = upload);
        lstUpdate.add(oneUpdate);
     }} 
      update lstUpdate; 
  system.debug('\n\n XXX lstUpdate: ' + lstUpdate.size()); 
 
 
 
 
  //                       CRAFFT 

     Map<string,string>  mapResult = new Map<string,string>(); 
   for (CRAFFT__c r : [select AssessmentContainerId__c,Assessment_Recommended__c from CRAFFT__c]){
     if (r.Assessment_Recommended__c == true)
      mapResult.put(r.AssessmentContainerId__c,'Referral Recomended');
   }  

   string result;
   List<AssessmentContainer__c> lstUpdate = new List<AssessmentContainer__c>();
   AssessmentContainer__c oneUpdate = new AssessmentContainer__c();
   for (AssessmentContainer__c c : [select id, assmResult__c from AssessmentContainer__c where assessmentName__c =: 'CRAFFT']){
     oneUpdate = new AssessmentContainer__c();
     Result = mapResult.get(c.id); 
     if (Result <> null){
         oneUpdate = new AssessmentContainer__c(assmResult__c = Result,id = c.id);
        lstUpdate.add(oneUpdate);
     }} 
      update lstUpdate; 
  system.debug('\n\n XXX lstUpdate: ' + lstUpdate.size()); 
 
 
 'LS/CMI'
 
 
 
 
 //     TCU 
 
     Map<string,string>  mapResult = new Map<string,string>(); 
     string sResult;
   for (TCUassessment__c t : [select AssessmentContainerId__c,Result__c,TCU_Total_Score__c
     from TCUassessment__c]){
     if (t.TCU_Total_Score__c <> null)
         mapResult.put(t.AssessmentContainerId__c,'Total score: ' + string.valueOf(t.TCU_Total_Score__c));
   }  

   string result;
   List<AssessmentContainer__c> lstUpdate = new List<AssessmentContainer__c>();
   AssessmentContainer__c oneUpdate = new AssessmentContainer__c();
   for (AssessmentContainer__c c : [select id, assmResult__c from AssessmentContainer__c where assessmentName__c =: 'TCU II']){
     oneUpdate = new AssessmentContainer__c();
     Result = mapResult.get(c.id); 
     if (Result <> null){
         oneUpdate = new AssessmentContainer__c(assmResult__c = Result,id = c.id);
        lstUpdate.add(oneUpdate);
     }} 
      update lstUpdate;
        system.debug('\n\n XXX lstUpdate: ' + lstUpdate.size()); 
 
  
  //  PHQ 9 TEEN
 
        Map<string,string>  mapResult = new Map<string,string>(); 
        string cresult;
    for (PHQ_9T__c p : [select AssessmentContainerId__c,id, Result__c,PHQ_9_Flag__c
                from PHQ_9T__c ]){
            if (p.PHQ_9_Flag__c == true)
               cResult  = 'Flag and ' + p.Result__c;
            else
               cResult  = p.Result__c;
        mapResult.put(p.AssessmentContainerId__c,cResult);            
                }
  List<AssessmentContainer__c> lstUpdate = new List<AssessmentContainer__c>();
   AssessmentContainer__c oneUpdate = new AssessmentContainer__c();
   for (AssessmentContainer__c c : [select id, assmResult__c from AssessmentContainer__c where assessmentName__c =: 'PHQ-9 Teen']){
     oneUpdate = new AssessmentContainer__c();
     cResult = mapResult.get(c.id); 
     if (cResult <> null){
         oneUpdate = new AssessmentContainer__c(assmResult__c = cResult,id = c.id);
        lstUpdate.add(oneUpdate);
     }} 
      update lstUpdate; 
        system.debug('\n\n XXX lstUpdate: ' + lstUpdate.size());                
 
  //  PHQ 9
   
        Map<string,string>  mapResult = new Map<string,string>(); 
        string cresult;
    for (PHQ_9__c p : [select AssessmentContainerId__c,id, Result__c,PHQ_9_Flag__c
                from PHQ_9__c ]){
            if (p.PHQ_9_Flag__c == true)
               cResult  = 'Flag and ' + p.Result__c;
            else
               cResult  = p.Result__c;
        mapResult.put(p.AssessmentContainerId__c,cResult);            
              }
   string Result;    
  List<AssessmentContainer__c> lstUpdate = new List<AssessmentContainer__c>();
   AssessmentContainer__c oneUpdate = new AssessmentContainer__c();
   for (AssessmentContainer__c c : [select id, assmResult__c from AssessmentContainer__c where assessmentName__c =: 'PHQ-9']){
     oneUpdate = new AssessmentContainer__c();
     Result = mapResult.get(c.id); 
     if (Result <> null){
         oneUpdate = new AssessmentContainer__c(assmResult__c = Result,id = c.id);
        lstUpdate.add(oneUpdate);
     }} 
      update lstUpdate;                 
   system.debug('\n\n XXX lstUpdate: ' + lstUpdate.size());
  
 
 
 */
 //   SURVEY

    void doSurvey(){
    Employment_Education_Survey__c oneMigrate = new Employment_Education_Survey__c();
    List<Employment_Education_Survey__c> lstMigrate = new List<Employment_Education_Survey__c>(); 
    Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Employment/Education Survey' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
        
     System.Debug('\n\n XXX setAssmId: ' + setAssmId);   
     Set<string> setInserted = new Set<string>();
     for (Employment_Education_Survey__c cc : [select AssessmentContainerId__c from Employment_Education_Survey__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
      ID parentId;
      integer k = 0;
      List<Assessment__c> lstAssm = new List<Assessment__c>([ Select  Id,Survey_Date__c,Client_s_True_Name__c,Home_Phone__c,
        Client_Contact_Method__c,Most_Recent_Alumni_Survey__c,Education_Information_Confirmed__c,School_Start_Date__c,
        Current_School_Enrollment__c,School_End_Date__c,Last_School_Attended__c,Reason_for_Leaving_School_Other__c,
    Reason_for_Leaving_School__c,Diploma_Type__c,Diploma_Date__c,Employment_Information_Confirmed__c,Current_Employment__c,
    Hourly_Pay__c,Employer__c,Job_Title__c,Survey_Notes__c,Follow_up_Needed__c,Follow_up_Date__c
      From Assessment__c c where id  in: setAssmId]);
    for (Assessment__c s : lstAssm){
        parentId = s.id;
        if (setInserted.contains(parentId) == false){
        oneMigrate = new Employment_Education_Survey__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        Survey_Date__c = s.Survey_Date__c,Client_s_True_Name__c = s.Client_s_True_Name__c,Home_Phone__c = s.Home_Phone__c,
        Client_Contact_Method__c = s.Client_Contact_Method__c,Most_Recent_Alumni_Survey__c = s.Most_Recent_Alumni_Survey__c,
        Education_Information_Confirmed__c = s.Education_Information_Confirmed__c,School_Start_Date__c = s.School_Start_Date__c,
        Current_School_Enrollment__c = s.Current_School_Enrollment__c,School_End_Date__c = s.School_End_Date__c,
    Last_School_Attended__c = s.Last_School_Attended__c,Reason_for_Leaving_School_Other__c = s.Reason_for_Leaving_School_Other__c,
    Reason_for_Leaving_School__c = s.Reason_for_Leaving_School__c,Diploma_Type__c = s.Diploma_Type__c,
    Diploma_Date__c = s.Diploma_Date__c,Employment_Information_Confirmed__c = s.Employment_Information_Confirmed__c,
    Current_Employment__c = s.Current_Employment__c,Hourly_Pay__c = s.Hourly_Pay__c,
    Employer__c = s.Employer__c,Job_Title__c = s.Job_Title__c,
    Survey_Notes__c = s.Survey_Notes__c,Follow_up_Needed__c = s.Follow_up_Needed__c,
    Follow_up_Date__c = s.Follow_up_Date__c);  
        lstMigrate.add(oneMigrate);
         k++;}} numbers = k;
         if (lstMigrate.size() != 0){
            upsert lstMigrate;
           AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =:'Employment/Education Survey' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
        //    Y_LS_CMI   
  //////////////////////////////////////////////////////////////////////////
    void doY_LS_CMI(){
      LSCMI_Y__c oneMigrate = new LSCMI_Y__c();
    List<LSCMI_Y__c> lstMigrate = new List<LSCMI_Y__c>(); 
    Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Y-LS/CMI' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (LSCMI_Y__c cc : [select AssessmentContainerId__c from LSCMI_Y__c]){
       setInserted.add(cc.AssessmentContainerId__c);}
      ID parentId;
      integer k = 0;
      List<Assessment__c> lstAssm = new List<Assessment__c>([Select  Id,Overall_Risk_Category__c,LSCMI_Strengths__c,LSCMI_Result__c,
         Survey_Notes__c,LSCMI_Subscale_1_Criminal_History__c,LSCMI_Subscale_5_Companions__c,LSCMI_Subscale_2_Education_Employment__c,
          LSCMI_Subscale_6_Alcohol_Drug_Problem__c,LSCMI_Subscale_3_Family_Marital__c,LSCMI_Subscale_7_Pro_criminal_Attitude__c,
          LSCMI_Subscale_4_Leisure_Recreation__c,LSCMI_Subscale_8_Anti_social_Pattern__c,Legacy_Database_Id__c
              From Assessment__c c where id  in: setAssmId]);
  
     for (Assessment__c s : lstAssm){
        parentId = s.id;
        if (setInserted.contains(parentId) == false){ 
        oneMigrate = new LSCMI_Y__c(AssessmentContainerId__c = mapParentIds.get(parentId),
          Overall_Risk_Category__c = s.Overall_Risk_Category__c,LSCMI_Strengths__c = s.LSCMI_Strengths__c,
          LSCMI_Result__c = s.LSCMI_Result__c,Survey_Notes__c = s.Survey_Notes__c,
          LSCMI_Subscale_1_Criminal_History__c = s.LSCMI_Subscale_1_Criminal_History__c,
          LSCMI_Subscale_5_Companions__c = s.LSCMI_Subscale_5_Companions__c,
          LSCMI_Subscale_2_Education_Employment__c = s.LSCMI_Subscale_2_Education_Employment__c,
      LSCMI_Subscale_6_Alcohol_Drug_Problem__c = s.LSCMI_Subscale_6_Alcohol_Drug_Problem__c,
      LSCMI_Subscale_3_Family_Marital__c = s.LSCMI_Subscale_3_Family_Marital__c,
      LSCMI_Subscale_7_Pro_criminal_Attitude__c = s.LSCMI_Subscale_7_Pro_criminal_Attitude__c,
      LSCMI_Subscale_4_Leisure_Recreation__c = s.LSCMI_Subscale_4_Leisure_Recreation__c,
      LSCMI_Subscale_8_Anti_social_Pattern__c = s.LSCMI_Subscale_8_Anti_social_Pattern__c,
      legacy_database_id__c = s.Legacy_Database_Id__c);  
        lstMigrate.add(oneMigrate);
         k++;}} numbers = k;
         if (lstMigrate.size() != 0){
            upsert lstMigrate;
           AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =:'Y-LS/CMI' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}} 
}