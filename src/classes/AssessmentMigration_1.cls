public with sharing class AssessmentMigration_1 {
 public boolean inProcess{get;set;} 
 public string aValue{get;set;}
  public List<SelectOption> Items{get;set;}
 //Map<string,string> mapAssCodePage = new Map<string,string>();    
//  Map<string,string> mapAssCodeName = new Map<string,string>(); 
  public AssessmentMigration_1(){
     generatePickListFromLookUp();
  }
 
public integer numbers{get;set;} 
    
  ////////////////////   PART 1  8 
  public void doMigration(){
    inProcess = true;
 
  //else if (aValue == 'UCLA PTSD DSM V') // 
   //   doUCLA_PTSD_DSM_V();    

  if (aValue == 'Health and Wellbeing')
       doHW();  
   else if (aValue == 'Life Events Checklist (LEC)') //
      doLifeEventsAssm();
  else if (aValue == 'SRP Intake') // 20
      doSRP_intake();
  else if (aValue == 'Education')                    //             Legacy Education   
      doEducation(); 
  else if (aValue == 'Psychosocial MH')  //     Legacy PSYCHO
      doPsycho();
  else if (aValue == 'UCLA PTSD RI')                //     Legacy UCLA PTSD RI
      doUCLA();
      inProcess = false;
  }
  
//  else if (aValue == 'Employment/Education Survey') //SURVEY
//      doSurvey();
//  else if (aValue == 'Y-LS/CMI')
//      doY_LS_CMI();


  void generatePickListFromLookUp(){
    List<SelectOption> option = new List<SelectOption>();
    option.add(new SelectOption('','')); 
    option.add(new SelectOption('Health and Wellbeing','Health and Wellbeing'));
    option.add(new SelectOption('Life Events Checklist (LEC)','Life Events Checklist (LEC)'));
    option.add(new SelectOption('SRP Intake','SRP Intake'));
    option.add(new SelectOption('Education','Education'));
    option.add(new SelectOption('Psychosocial MH','Psychosocial MH'));
    option.add(new SelectOption('UCLA PTSD RI','UCLA PTSD RI'));
       Items = option;}

//    option.add(new SelectOption('Employment/Education Survey','Employment/Education Survey'));
//    option.add(new SelectOption('Y-LS/CMI','Y-LS/CMI'));
 
      //               SRP INTAKE          

               void doSRP_intake(){
       integer k = 0;      
   Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'SRP Intake' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
      setAssmId.add(ac.recIdFromassessment__c);} 
    Set<string> setInserted = new Set<string>();
     for (SRP_IntakeAssessments__c cc : [select AssessmentContainerId__c from SRP_IntakeAssessments__c]){
     	setInserted.add(cc.AssessmentContainerId__c);}
     AssessmentContainer__c assmCont = new AssessmentContainer__c(); 
     List<AssessmentContainer__c> assmContList = new List<AssessmentContainer__c>(); 
     SRP_IntakeAssessments__c oneMigrate = new SRP_IntakeAssessments__c(); 
     List<SRP_IntakeAssessments__c> lstMigrate = new List<SRP_IntakeAssessments__c>();
     List<SR_Intake_Needs_Assessment__c> lstAssm = new List<SR_Intake_Needs_Assessment__c>([                
       Select  id,Therapist__c,Therapist_Phone__c,
        Therapist_Agency__c,Therapist_Address__c,Taking_Meds_for_MH__c,Support_needed_for_medical_issues__c, 
        Street__c,State__c,Smoke_cigarettes__c,  
        Secondary_Contact_Relationship__c,Secondary_Contact_Phone__c,Secondary_Contact_Name__c,
        Secondary_Contact_Address__c,Satisfied_with_therapist__c,Satisfied_with_psych__c,
        SA_satisfied_with_support__c,SA_overdose__c,SA_looking_for_support__c,  
        SA_in_treatment__c,SA_caused_legal_problems__c,SA_Treatment_Details__c,
       SA_Substances_Used__c,SA_Overdose_Details__c,Reliable_Access_Food__c,
       Reliable_Access_Clothing__c,Relation_to_client__c,Relation_to_Client_Other__c,  
       Psychiatrist__c,Psychiatrist_Phone__c,Psychiatrist_Agency__c,Psychiatrist_Address__c,
       Psychiatric_Diagnosis_Information__c,Psy_Diagnosis_Other__c,
       Primary_caregiver__c,Primary_Contact_Relationship__c, 
       Primary_Contact_Phone__c,Primary_Contact_Name__c, 
       Primary_Contact_Address__c,Primary_Care_Physician__c,Physician_Phone__c,
       Physician_Address__c,PCP_Clinic__c,Other_medical_issues__c,Other_legal_issues__c,
       OBGYN_Phone__c,OBGYN_Clinic__c,OBGYN_Address__c,Need_medical_referrals__c,
       Need_Medical_Referrals_Txt__c,Most_Important_Needs__c,Most_Helpful_Needs__c,
        Mental_Health_Meds__c,Medications_Dosage__c,Medical_Issues__c, 
       Medicaid_Sequence_Number__c,MH_Hospitalization_Details__c,MH_Ever_Hospitalized__c,
       Level_of_Social_Support__c,Last_Physical_Exam__c,Last_Pap_Smear__c,
       Insurance_Number__c,Income_Wages__c,Income_Veteran_Benefits__c,Income_SSI__c, 
       Income_SSD__c,Income_Pension__c,Income_PA_CASH__c,Income_Other__c,Income_None__c,
       Income_Family__c,Immediate_Needs__c,Hurt_self_when__c,Hurt_others_when__c,
        Hurt_others__c,Hurt_others_What_going_on__c,Hurt_Self_happening_now__c,
        Hurt_Self__c,Hurt_Self_What_you_do__c,Hurt_Self_What_going_on__c, 
        Hurt_Others_happening_now__c,Hurt_Others_What_you_do__c,How_safe_do_you_feel__c,  
        Hospitalized_Details__c,Home_Phone__c,Highest_Level_of_Education__c,
        Health_home_care_coordinator__c,Health_Insurance__c,Have_case_worker__c, 
        Have_OBGYN__c,Hangout_Place__c,Half_Fare_Metrocard__c,Food_stamps__c,
        Food_Stamps_YN__c,Food_Stamps_Amount__c,Employment_Goals__c,  
        Email__c,Educational_Goals__c,Ed_currently_enrolled__c,Ed_continue_studies__c, 
        Cutting_down__c,Currently_seeing_therapist__c,Currently_seeing_psych__c,
        Current_School_Enrollment__c,Current_Medical_Care_Provider_YN__c,  
        Contact_Person__c, Cigarettes_How_Many__c,Case_Worker__c,Case_Worker_Phone__c,  
        Case_Worker_Agency__c,Case_Worker_Address__c,Caregiver_Referrals__c 
         From SR_Intake_Needs_Assessment__c where id in:setAssmId]); 
      ID parentId;
      for (SR_Intake_Needs_Assessment__c s : lstAssm){
        parentId = s.id; 
            if (setInserted.contains(parentid) == false){
      oneMigrate = new SRP_IntakeAssessments__c(AssessmentContainerId__c = mapParentIds.get(parentId),
         Therapist__c = s.Therapist__c,  
         Therapist_Phone__c = s.Therapist_Phone__c,  
         Therapist_Agency__c = s.Therapist_Agency__c,
         Therapist_Address__c = s.Therapist_Address__c,
         Taking_Meds_for_MH__c = s.Taking_Meds_for_MH__c,
         Support_needed_for_medical_issues__c = s.Support_needed_for_medical_issues__c,
         Smoke_cigarettes__c = s.Smoke_cigarettes__c,
         Secondary_Contact_Relationship__c = s.Secondary_Contact_Relationship__c,
         Secondary_Contact_Phone__c = s.Secondary_Contact_Phone__c,
         Secondary_Contact_Name__c = s.Secondary_Contact_Name__c,
         Secondary_Contact_Address__c = s.Secondary_Contact_Address__c,
         Satisfied_with_therapist__c = s.Satisfied_with_therapist__c,
         Satisfied_with_psych__c = s.Satisfied_with_psych__c,
         SA_satisfied_with_support__c = s.SA_satisfied_with_support__c,
         SA_overdose__c = s.SA_overdose__c,
         SA_looking_for_support__c = s.SA_looking_for_support__c,
         SA_in_treatment__c = s.SA_in_treatment__c,
         SA_caused_legal_problems__c = s.SA_caused_legal_problems__c, 
         SA_Treatment_Details__c = s.SA_Treatment_Details__c,
        SA_Substances_Used__c = s.SA_Substances_Used__c,
        SA_Overdose_Details__c = s.SA_Overdose_Details__c,
        Reliable_Access_Food__c = s.Reliable_Access_Food__c,
        Reliable_Access_Clothing__c = s.Reliable_Access_Clothing__c, 
         Relation_to_client__c = s.Relation_to_client__c,
         Relation_to_Client_Other__c = s.Relation_to_Client_Other__c,
        Psychiatrist__c = s.Psychiatrist__c,
        Psychiatrist_Phone__c = s.Psychiatrist_Phone__c,
        Psychiatrist_Agency__c = s.Psychiatrist_Agency__c,
        Psychiatrist_Address__c = s.Psychiatrist_Address__c,
        Psychiatric_Diagnosis_Information__c = s.Psychiatric_Diagnosis_Information__c,
        Psy_Diagnosis_Other__c = s.Psy_Diagnosis_Other__c,
        Primary_caregiver__c = s.Primary_caregiver__c,
        Primary_Contact_Relationship__c = s.Primary_Contact_Relationship__c,
        Primary_Contact_Phone__c = s.Primary_Contact_Phone__c,
        Primary_Contact_Name__c = s.Primary_Contact_Name__c,
        Primary_Contact_Address__c = s.Primary_Contact_Address__c,
        Primary_Care_Physician__c = s.Primary_Care_Physician__c,
        Physician_Phone__c = s.Physician_Phone__c,
        Physician_Address__c = s.Physician_Address__c, 
        PCP_Clinic__c = s.PCP_Clinic__c,
        Other_medical_issues__c = s.Other_medical_issues__c,
        Other_legal_issues__c = s.Other_legal_issues__c,  
        OBGYN_Phone__c = s.OBGYN_Phone__c,
        OBGYN_Clinic__c = s.OBGYN_Clinic__c,
        OBGYN_Address__c = s.OBGYN_Address__c,
        Need_medical_referrals__c = s.Need_medical_referrals__c,
        Need_Medical_Referrals_Txt__c = s.Need_Medical_Referrals_Txt__c, 
        Most_Important_Needs__c = s.Most_Important_Needs__c, 
         Most_Helpful_Needs__c = s.Most_Helpful_Needs__c,
         Mental_Health_Meds__c = s.Mental_Health_Meds__c,
        Medications_Dosage__c = s.Medications_Dosage__c,
        Medical_Issues__c = s.Medical_Issues__c,
        Medicaid_Sequence_Number__c = s.Medicaid_Sequence_Number__c,
        MH_Hospitalization_Details__c = s.MH_Hospitalization_Details__c,
        MH_Ever_Hospitalized__c = s.MH_Ever_Hospitalized__c,
        Level_of_Social_Support__c = s.Level_of_Social_Support__c,
        Last_Physical_Exam__c = s.Last_Physical_Exam__c,
        Last_Pap_Smear__c = s.Last_Pap_Smear__c,
        Insurance_Number__c = s.Insurance_Number__c,
        Income_Wages__c = s.Income_Wages__c,
        Income_Veteran_Benefits__c = s.Income_Veteran_Benefits__c,
        Income_SSI__c = s.Income_SSI__c,
        Income_SSD__c = s.Income_SSD__c,
        Income_Pension__c = s.Income_Pension__c,
        Income_PA_CASH__c = s.Income_PA_CASH__c,
        Income_Other__c = s.Income_Other__c,
        Income_None__c = s.Income_None__c,
        Income_Family__c = s.Income_Family__c,
        Immediate_Needs__c = s.Immediate_Needs__c, 
         Hurt_self_when__c = s.Hurt_self_when__c,
         Hurt_others_when__c = s.Hurt_others_when__c,
         Hurt_others__c = s.Hurt_others__c,
         Hurt_others_What_going_on__c = s.Hurt_others_What_going_on__c,
         Hurt_Self_happening_now__c = s.Hurt_Self_happening_now__c,
         Hurt_Self__c = s.Hurt_Self__c,
         Hurt_Self_What_you_do__c = s.Hurt_Self_What_you_do__c,
         Hurt_Self_What_going_on__c = s.Hurt_Self_What_going_on__c,
         Hurt_Others_happening_now__c = s.Hurt_Others_happening_now__c,
         Hurt_Others_What_you_do__c = s.Hurt_Others_What_you_do__c,
         How_safe_do_you_feel__c = s.How_safe_do_you_feel__c,
         Hospitalized_Details__c = s.Hospitalized_Details__c,
         Highest_Level_of_Education__c = s.Highest_Level_of_Education__c,
         Health_home_care_coordinator__c = s.Health_home_care_coordinator__c,
         Health_Insurance__c = s.Health_Insurance__c,
         Have_case_worker__c = s.Have_case_worker__c,
         Have_OBGYN__c = s.Have_OBGYN__c,
         Hangout_Place__c = s.Hangout_Place__c,
         Half_Fare_Metrocard__c = s.Half_Fare_Metrocard__c,
         Food_stamps__c = s.Food_stamps__c,
         Food_Stamps_YN__c = s.Food_Stamps_YN__c,  
         Food_Stamps_Amount__c = s.Food_Stamps_Amount__c,
         Employment_Goals__c = s.Employment_Goals__c,
         Email__c = s.Email__c,
         Educational_Goals__c = s.Educational_Goals__c,
         Ed_currently_enrolled__c = s.Ed_currently_enrolled__c,
         Ed_continue_studies__c = s.Ed_continue_studies__c,
         Cutting_down__c = s.Cutting_down__c,
         Currently_seeing_therapist__c = s.Currently_seeing_therapist__c,
         Currently_seeing_psych__c = s.Currently_seeing_psych__c,
         Current_School_Enrollment__c = s.Current_School_Enrollment__c,
         Current_Medical_Care_Provider_YN__c = s.Current_Medical_Care_Provider_YN__c,  
         Contact_Person__c = s.Contact_Person__c,
         Cigarettes_How_Many__c = s.Cigarettes_How_Many__c,
         Case_Worker__c = s.Case_Worker__c,
         Case_Worker_Phone__c = s.Case_Worker_Phone__c,
         Case_Worker_Agency__c = s.Case_Worker_Agency__c,
         Case_Worker_Address__c = s.Case_Worker_Address__c,
         Caregiver_Referrals__c = s.Caregiver_Referrals__c);
              lstMigrate.add(oneMigrate);
        k++;}}numbers = k;
         if ( lstMigrate.size() != 0){
        upsert lstMigrate;
             AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'SRP Intake' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
 
        //   Life Events Checklist // 13
 
       void doLifeEventsAssm(){
         // source: Life_Events_Checklist__c 
         // target: LifeEventsAssm__c
     integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();  
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Life Events Checklist (LEC)' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
       setAssmId.add(ac.recIdFromassessment__c); } 
     Set<string> setInserted = new Set<string>();
     for (LifeEventsAssm__c cc : [select AssessmentContainerId__c from LifeEventsAssm__c]){
     	setInserted.add(cc.AssessmentContainerId__c);}
        LifeEventsAssm__c oneMigrate = new  LifeEventsAssm__c();
        List<LifeEventsAssm__c> lstMigrate = new List<LifeEventsAssm__c>();
    
        List<Life_Events_Checklist__c> lstAssm = new List<Life_Events_Checklist__c>([
        select  Participant__c,LEC_Q17__c,LEC_Q16__c, LEC_Q15__c,
         LEC_Q14__c, LEC_Q13__c, LEC_Q12__c,LEC_Q11__c,LEC_Q10__c,
         LEC_Q09__c, LEC_Q08__c, LEC_Q07__c, LEC_Q06__c, LEC_Q05__c, LEC_Q04__c, 
         LEC_Q03__c, LEC_Q02__c, LEC_Q01__c, Id From Life_Events_Checklist__c where id in: setAssmId]);
    
      ID parentId;
        for (Life_Events_Checklist__c s : lstAssm){
          parentId = s.id;
          if (setInserted.contains(parentId) == false){
        oneMigrate = new  LifeEventsAssm__c(AssessmentContainerId__c = mapParentIds.get(parentId),     
          LEC_Q01__c = s.LEC_Q01__c,LEC_Q02__c = s.LEC_Q02__c,LEC_Q03__c = s.LEC_Q03__c,LEC_Q04__c = s.LEC_Q04__c,    
          LEC_Q05__c = s.LEC_Q05__c,LEC_Q06__c = s.LEC_Q06__c,LEC_Q07__c = s.LEC_Q07__c,    
          LEC_Q08__c = s.LEC_Q08__c,LEC_Q09__c = s.LEC_Q09__c,LEC_Q10__c = s.LEC_Q10__c,LEC_Q11__c = s.LEC_Q11__c,    
          LEC_Q12__c = s.LEC_Q12__c,LEC_Q13__c = s.LEC_Q13__c,LEC_Q14__c = s.LEC_Q14__c,    
          LEC_Q15__c = s.LEC_Q15__c,LEC_Q16__c = s.LEC_Q16__c,LEC_Q17__c = s.LEC_Q17__c);  
          lstMigrate.add(oneMigrate);
          k++;}}      numbers = k;
        if (lstMigrate.size() != 0){
             upsert lstMigrate; 
       AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'Life Events Checklist (LEC)' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}

    void doHW(){
      integer k = 0;
   Map<ID,string>  mapParentIds = new Map<ID,string>();  
    Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Health and Wellbeing' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (HW__c cc : [select AssessmentContainerId__c from HW__c]){
     	setInserted.add(cc.AssessmentContainerId__c);}
      MAP<string,string> mapResult = new MAP<string,string>();
      HW__c  oneMigrate = new   HW__c ();
      List <HW__c> lstMigrate = new List<HW__c>();
      ///    Employment__c,Education__c, - not in legacy  !!!1
      List<Health_and_Wellbeing_Assessment__c> lstAssm = new List<Health_and_Wellbeing_Assessment__c>([
      Select Participant__c,SystemModstamp,Summary_Strengths__c,Summary_Presenting__c,Self_Harm__c,
        Presenting_Challenges__c,Physical_Health__c,Personal_Strengths__c,Peers_Support__c,
        Past_Ideations__c,Mental_Status__c,Mental_Health__c,MH_Hospitalized__c,MH1_Type_of_Program__c,
        MH1_Name_of_Program__c,MH1_Length_of_Time__c,MH1_Contact__c,Legal_History__c,
        LastModifiedDate,LastModifiedById,IsComplete__c,Id,Harming_Others__c,
        Goals_Substance_Use__c,Goals_Satisfaction__c,Goals_Peers__c,Goals_Mental_Health__c,
        Goals_Family__c,Goals_Education__c,Family_Structure__c,Family_Members__c,
        Environment__c,Ending_Life__c,Drugs_Used__c,
        Drugs4_Tried_to_Stop__c,Drugs4_Last_Time_Used__c,Drugs4_Get_Out_Of__c,Drugs4_First_Time_Used__c,
        Drugs4_Drug_Name__c,Drugs4_Alone_or_Peers__c,Drugs3_Tried_to_Stop__c,Drugs3_Last_Time_Used__c,
        Drugs3_Get_Out_Of__c,Drugs3_First_Time_Used__c,Drugs3_Drug_Name__c,Drugs3_Alone_or_Peers__c,
        Drugs2_Type_of_Treatment__c,Drugs2_Tried_to_Stop__c,Drugs2_Name_of_Program__c,
        Drugs2_Last_Time_Used__c,Drugs2_Get_Out_Of__c,Drugs2_First_Time_Used__c,
        Drugs2_Drug_Name__c,Drugs2_Dates__c,Drugs2_Date_Started__c,Drugs2_Contact_Info__c,
        Drugs2_Alone_or_Peers__c,Drugs1_Type_of_Treatment__c,Drugs1_Tried_to_Stop__c,
        Drugs1_Name_of_Program__c,Drugs1_Last_Time_Used__c,Drugs1_Get_Out_Of__c,
        Drugs1_First_Time_Used__c,Drugs1_Drug_Name__c,Drugs1_Dates__c,
        Drugs1_Date_Started__c,Drugs1_Contact_Info__c,Drugs1_Alone_or_Peers__c,
        Describe_Anger__c,Cultural_Considerations__c,
        Aggressive_Behavior__c,Abuse__c
        From Health_and_Wellbeing_Assessment__c  where id in: setAssmId]);      
    ID parentId;
     for (Health_and_Wellbeing_Assessment__c  s : lstAssm){ 
       parentId = s.id;
           if (setInserted.contains(parentId) == false){
       oneMigrate = new  HW__c(AssessmentContainerId__c = mapParentIds.get(parentId),Summary_Strengths__c = s.Summary_Strengths__c,
       Summary_Presenting__c = s.Summary_Presenting__c,Self_Harm__c = s.Self_Harm__c,Presenting_Challenges__c = s.Presenting_Challenges__c,
        Physical_Health__c = s.Physical_Health__c,Personal_Strengths__c = s.Personal_Strengths__c,
        Peers_Support__c = s.Peers_Support__c,Past_Ideations__c = s.Past_Ideations__c,Mental_Status__c = s.Mental_Status__c,
        Mental_Health__c = s.Mental_Health__c,MH_Hospitalized__c = s.MH_Hospitalized__c,
        MH1_Type_of_Program__c = s.MH1_Type_of_Program__c,MH1_Name_of_Program__c = s.MH1_Name_of_Program__c,
        MH1_Length_of_Time__c = s.MH1_Length_of_Time__c,MH1_Contact__c = s.MH1_Contact__c,
        Legal_History__c = s.Legal_History__c,Harming_Others__c = s.Harming_Others__c,Goals_Substance_Use__c = s.Goals_Substance_Use__c,
        Goals_Satisfaction__c = s.Goals_Satisfaction__c,Goals_Peers__c = s.Goals_Peers__c,
        Goals_Mental_Health__c = s.Goals_Mental_Health__c,Goals_Family__c = s.Goals_Family__c,Goals_Education__c = s.Goals_Education__c,
        Family_Structure__c = s.Family_Structure__c,Family_Members__c = s.Family_Members__c,Environment__c = s.Environment__c,
        Ending_Life__c = s.Ending_Life__c,
        Drugs_Used__c = s.Drugs_Used__c,Drugs4_Tried_to_Stop__c = s.Drugs4_Tried_to_Stop__c,Drugs4_Last_Time_Used__c = s.Drugs4_Last_Time_Used__c,
        Drugs4_Get_Out_Of__c = s.Drugs4_Get_Out_Of__c,Drugs4_First_Time_Used__c = s.Drugs4_First_Time_Used__c,
        Drugs4_Drug_Name__c = s.Drugs4_Drug_Name__c,Drugs4_Alone_or_Peers__c = s.Drugs4_Alone_or_Peers__c,
        Drugs3_Tried_to_Stop__c = s.Drugs3_Tried_to_Stop__c,Drugs3_Last_Time_Used__c = s.Drugs3_Last_Time_Used__c,
        Drugs3_Get_Out_Of__c = s.Drugs3_Get_Out_Of__c,Drugs3_First_Time_Used__c = s.Drugs3_First_Time_Used__c,
        Drugs3_Drug_Name__c = s.Drugs3_Drug_Name__c,Drugs3_Alone_or_Peers__c = s.Drugs3_Alone_or_Peers__c,
        Drugs2_Type_of_Treatment__c = s.Drugs2_Type_of_Treatment__c,Drugs2_Tried_to_Stop__c = s.Drugs2_Tried_to_Stop__c,
        Drugs2_Name_of_Program__c = s.Drugs2_Name_of_Program__c,Drugs2_Last_Time_Used__c = s.Drugs2_Last_Time_Used__c,
        Drugs2_Get_Out_Of__c = s.Drugs2_Get_Out_Of__c,Drugs2_First_Time_Used__c = s.Drugs2_First_Time_Used__c,
        Drugs2_Drug_Name__c = s.Drugs2_Drug_Name__c,Drugs2_Dates__c = s.Drugs2_Dates__c,Drugs2_Date_Started__c = s.Drugs2_Date_Started__c,
        Drugs2_Contact_Info__c = s.Drugs2_Contact_Info__c,Drugs2_Alone_or_Peers__c = s.Drugs2_Alone_or_Peers__c,
        Drugs1_Type_of_Treatment__c = s.Drugs1_Type_of_Treatment__c,Drugs1_Tried_to_Stop__c = s.Drugs1_Tried_to_Stop__c,
        Drugs1_Name_of_Program__c = s.Drugs1_Name_of_Program__c,Drugs1_Last_Time_Used__c = s.Drugs1_Last_Time_Used__c,
        Drugs1_Get_Out_Of__c = s.Drugs1_Get_Out_Of__c,Drugs1_First_Time_Used__c = s.Drugs1_First_Time_Used__c,
        Drugs1_Drug_Name__c = s.Drugs1_Drug_Name__c,Drugs1_Dates__c = s.Drugs1_Dates__c,Drugs1_Date_Started__c = s.Drugs1_Date_Started__c,
        Drugs1_Contact_Info__c = s.Drugs1_Contact_Info__c,Drugs1_Alone_or_Peers__c = s.Drugs1_Alone_or_Peers__c,
        Describe_Anger__c = s.Describe_Anger__c,Cultural_Considerations__c = s.Cultural_Considerations__c,
        Aggressive_Behavior__c = s.Aggressive_Behavior__c,Abuse__c = s.Abuse__c);       
   lstMigrate.add(oneMigrate);
   k++;     }} numbers = k;
      if (lstMigrate.size() != 0){
        upsert lstMigrate; 
         AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =: 'Health and Wellbeing' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}
 
     
         //  -------------------------------  Education
  
    void doEducation(){ 
     integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Education' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);} 
     Set<string> setInserted = new Set<string>();
     for (EducationAssm__c cc : [select AssessmentContainerId__c from EducationAssm__c]){
     	setInserted.add(cc.AssessmentContainerId__c);}
      MAP<string,string> mapResult = new MAP<string,string>(); 
      EducationAssm__c  oneMigrate = new   EducationAssm__c ();
      List <EducationAssm__c> lstMigrate = new List<EducationAssm__c>();
      List<Assessment_Legacy__c> lstAssm = new List<Assessment_Legacy__c>([
      Select id,Education_Section_1__c,Education_Section_2__c,School_GED_Enrollment_at_Intake__c,
      Update_School_GED_Enrollment_at_Intake__c,Diploma_Status_at_Intake__c,Update_Diploma_Status_at_Intake__c,
      Current_School_Enrollment__c,School_Start_Date__c,Last_School_Attended__c,School_End_Date__c,
      School_Institution_Hours_from_and_to__c,Reason_for_Leaving_School__c,How_many_credits_have_you_earned__c,
      Update_No_of_High_School_Credits__c,What_grade_are_you_currently_in__c,Update_Current_Grade__c,
      Update_Last_Grade_Completed__c,Diploma_Type__c,Present_past_school_suspension__c,Diploma_Date__c,
      Received_a_Superintendent_s_suspension__c,Best_time_to_reach_parents_at_home__c,In_Special_Education__c,
      Did_you_pass_any_Regent_s_exams_in_HS__c,Who_is_the_guidance_counselor__c,No_schools_attended_in_the_last_5_yrs__c,
      OSIS_No__c,Family_Peers_Section_1__c,Employment_Section_1__c,Substance_Abuse_Section_1__c,
      Required_Documents__c,Update_Required_Documents__c,Optional_Documents_Needed__c,
      Update_Optional_Documents_Needed__c,Optional_Documents_Collected__c,Update_Optional_Documents_Collected__c
        From Assessment_Legacy__c  where id in: setAssmId]); 
            ID parentId;
        for (Assessment_Legacy__c s : lstAssm){ 
          parentId = s.id; 
        if (setInserted.contains(parentId) == false){    
         oneMigrate = new  EducationAssm__c(AssessmentContainerId__c = mapParentIds.get(parentId),
         Education_Section_1__c = s.Education_Section_1__c,
         Education_Section_2__c = s.Education_Section_2__c,
         School_GED_Enrollment_at_Intake__c = s.School_GED_Enrollment_at_Intake__c,
         Update_School_GED_Enrollment_at_Intake__c = s.Update_School_GED_Enrollment_at_Intake__c,
         Diploma_Status_at_Intake__c = s.Diploma_Status_at_Intake__c,
         Update_Diploma_Status_at_Intake__c = s.Update_Diploma_Status_at_Intake__c,
         Current_School_Enrollment__c = s.Current_School_Enrollment__c,
         School_Start_Date__c = s.School_Start_Date__c,
         Last_School_Attended__c = s.Last_School_Attended__c, 
         School_End_Date__c = s.School_End_Date__c,
         School_Institution_Hours_from_and_to__c = s.School_Institution_Hours_from_and_to__c,
         Reason_for_Leaving_School__c = s.Reason_for_Leaving_School__c,
         How_many_credits_have_you_earned__c = s.How_many_credits_have_you_earned__c,
         Update_No_of_High_School_Credits__c = s.Update_No_of_High_School_Credits__c,
         What_grade_are_you_currently_in__c = s.What_grade_are_you_currently_in__c,
         Update_Current_Grade__c = s.Update_Current_Grade__c, 
         Update_Last_Grade_Completed__c = s.Update_Last_Grade_Completed__c,
         Diploma_Type__c = s.Diploma_Type__c,
         Present_past_school_suspension__c = s.Present_past_school_suspension__c,
         Diploma_Date__c = s.Diploma_Date__c,
         Received_a_Superintendent_s_suspension__c = s.Received_a_Superintendent_s_suspension__c,
         Best_time_to_reach_parents_at_home__c = s.Best_time_to_reach_parents_at_home__c,
         In_Special_Education__c = s.In_Special_Education__c,
         Did_you_pass_any_Regent_s_exams_in_HS__c = s.Did_you_pass_any_Regent_s_exams_in_HS__c,
         Who_is_the_guidance_counselor__c = s.Who_is_the_guidance_counselor__c,
         No_schools_attended_in_the_last_5_yrs__c = s.No_schools_attended_in_the_last_5_yrs__c,
         OSIS_No__c = s.OSIS_No__c,
         Family_Peers_Section_1__c = s.Family_Peers_Section_1__c,
         Employment_Section_1__c = s.Employment_Section_1__c,
         Substance_Abuse_Section_1__c = s.Substance_Abuse_Section_1__c,
         Required_Documents__c = s.Required_Documents__c,
         Update_Required_Documents__c = s.Update_Required_Documents__c,
         Update_Optional_Documents_Needed__c = s.Update_Optional_Documents_Needed__c,
         Update_Optional_Documents_Collected__c = s.Update_Optional_Documents_Collected__c);
         lstMigrate.add(oneMigrate);
         k++;}} numbers = k;
         if (lstMigrate.size() != 0){
        	 upsert lstMigrate;
           AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
           assessmentName__c =:'Education' limit 1];
          al.recordsMigrated__c = k;
          al.date__c = date.today();
        upsert al;}}     
  
 //////////////////////////////////////////////////////////////////////////////////////////////////   Psycho 
    void doPsycho(){
    	   integer k = 0;  
     Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'Psychosocial MH' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id);
        setAssmId.add(ac.recIdFromassessment__c);}  
     Set<string> setInserted = new Set<string>();  
     for (Psychosocial_MH__c cc : [select AssessmentContainerId__c from Psychosocial_MH__c]){
     	setInserted.add(cc.AssessmentContainerId__c);}
       Psychosocial_MH__c  oneMigrate = new  Psychosocial_MH__c();    
       List <Psychosocial_MH__c> lstMigrate = new List<Psychosocial_MH__c>(); 
       List<Assessment_Legacy__c> lstAssm = new List<Assessment_Legacy__c>([
       Select id,Update_Insurance_Provider__c,Update_Insurance_Number__c,Update_Drugs_Used__c,Update_Drugs_Used_Other__c,
       Summary_Recommendations_Section_1__c,Substance_Abuse_Section_1__c,Referrals_Made_YN__c,Physical_Health_Section_1__c,
       Other_Phys_Health_Problem__c,Neighborhood__c,Mental_Health_Section_1__c,Mental_Health_Issues_at_Interview__c,
       Mental_Health_History__c,MAYSI_2__c,Insurance_Number__c,Indication_of_Phys_Health_Problem__c,Employment_Section_1__c,
       Education_Section_2__c,Education_Section_1__c,Drugs_Used__c,Drugs_Used_Other__c,Drug_Test_Frequency__c,
       DO_YOU_HAVE_INSURANCE__c,Community_based_Care_Recommended__c,Case_Coordinator_Comments__c,
       Assessment_Result__c,Family_Peers_Section_1__c From Assessment_Legacy__c  where id in: setAssmId]); 
            ID parentId; 
       for (Assessment_Legacy__c s : lstAssm){ 
            parentId = s.id; 
        if (setInserted.contains(parentId) == false){    
           oneMigrate = new  Psychosocial_MH__c(AssessmentContainerId__c = mapParentIds.get(parentId),
           Update_Insurance_Provider__c = s.Update_Insurance_Provider__c,Update_Insurance_Number__c = s.Update_Insurance_Number__c,
           Update_Drugs_Used__c = s.Update_Drugs_Used__c,
           Summary_Recommendations_Section_1__c = s.Summary_Recommendations_Section_1__c,
           Substance_Abuse_Section_1__c = s.Substance_Abuse_Section_1__c, Referrals_Made_YN__c = s.Referrals_Made_YN__c,
           Physical_Health_Section_1__c = s.Physical_Health_Section_1__c,Other_Phys_Health_Problem__c = s.Other_Phys_Health_Problem__c,
           Neighborhood__c = s.Neighborhood__c,Mental_Health_Section_1__c = s.Mental_Health_Section_1__c,
           Mental_Health_Issues_at_Interview__c = s.Mental_Health_Issues_at_Interview__c,
           Mental_Health_History__c = s.Mental_Health_History__c, MAYSI_2__c = s.MAYSI_2__c,Insurance_Number__c = s.Insurance_Number__c,
           Indication_of_Phys_Health_Problem__c = s.Indication_of_Phys_Health_Problem__c,
           Employment_Section_1__c = s.Employment_Section_1__c,Education_Section_2__c = s.Education_Section_2__c,
           Education_Section_1__c = s.Education_Section_1__c,Drugs_Used__c = s.Drugs_Used__c,
           Drugs_Used_Other__c = s.Drugs_Used_Other__c,Drug_Test_Frequency__c = s.Drug_Test_Frequency__c,
           DO_YOU_HAVE_INSURANCE__c = s.DO_YOU_HAVE_INSURANCE__c,
           Community_based_Care_Recommended__c = s.Community_based_Care_Recommended__c,
            Case_Coordinator_Comments__c = s.Case_Coordinator_Comments__c,
           Update_Drugs_Used_Other__c  = s.Update_Drugs_Used_Other__c,Family_Peers_Section_1__c = s.Family_Peers_Section_1__c);       
          lstMigrate.add(oneMigrate);
          k++;}} numbers = k;
         if (lstMigrate.size() != 0){
         	 upsert lstMigrate;
           AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =:'Psychosocial MH' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}  
  	    

//////////////////////////////////////////////////////////////////////////////////////////////////   Psycho 
    void doUCLA(){
    	   integer k = 0;
     Map<ID,string>  mapParentIds = new Map<ID,string>();   
     Set<string> setAssmId =  new Set<string>();     
     for (AssessmentContainer__c ac : [select id,recIdFromassessment__c from AssessmentContainer__c
     where assessmentName__c =: 'UCLA PTSD RI' ]){
       mapParentIds.put(ac.recIdFromassessment__c,ac.id); 
        setAssmId.add(ac.recIdFromassessment__c);}  
     Set<string> setInserted = new Set<string>();
     for (UCLAptsd_RI__c cc : [select AssessmentContainerId__c from UCLAptsd_RI__c]){
     	setInserted.add(cc.AssessmentContainerId__c);}
      UCLAptsd_RI__c  oneMigrate = new  UCLAptsd_RI__c();     
       List <UCLAptsd_RI__c> lstMigrate = new List<UCLAptsd_RI__c>();
        List<Assessment_Legacy__c> lstAssm = new List<Assessment_Legacy__c>([
        Select id,UCLA_S1Q10_Violent_injury_of_loved_one__c,UCLA_S1Q1_In_a_disaster__c,UCLA_S1Q11_Painful_medical_treatment__c,
     UCLA_S1Q12_Forced_to_have_sex__c,UCLA_S1Q13_Anything_else__c,UCLA_S1Q2_In_a_bad_accident__c,UCLA_S1Q3_In_a_place_at_war__c,
     UCLA_S1Q4_Hit_hard_at_home__c,UCLA_S1Q5_Seeing_family_member_hit__c,UCLA_S1Q6_Beaten_shot_at_threatened__c,
     UCLA_S1Q7_Seeing_someone_beaten_etc__c,UCLA_S1Q8_Seeing_dead_body__c,UCLA_S1Q9_Having_adult_touch_you__c,
     UCLA_S2Q14_Scared_you_would_die__c,UCLA_S2Q15_Scared_of_being_hurt__c,UCLA_S2Q16_Hurt_badly__c,
     UCLA_S2Q17_Scared_someone_else_hurt__c,UCLA_S2Q19_Scared_someone_would_die__c,UCLA_S2Q20_Did_someone_die__c,
     UCLA_S2Q21_Were_you_very_scared__c,UCLA_S2Q22_Felt_you_couldn_t_stop_it__c,UCLA_S2Q23_Disgusting_or_gross__c, 
     UCLA_S3Q10_I_have_trouble_feeling_happy__c,UCLA_S3Q11_Trouble_feeling_sadness_anger__c,UCLA_S3Q12_I_feel_jumpy__c,
     UCLA_S3Q13_I_have_trouble_sleeping__c,UCLA_S3Q14_I_think_it_s_partly_my_fault__c,UCLA_S3Q15_Cant_remember_important_parts__c, 
     UCLA_S3Q16_I_have_trouble_concentrating__c,UCLA_S3Q17_I_avoid_things_that_remind_me__c,UCLA_S3Q18_I_have_physical_reactions__c,
     UCLA_S3Q19_I_think_I_won_t_live_long__c,UCLA_S3Q1_I_watch_out_for_danger__c,UCLA_S3Q20_I_have_arguments_or_fights__c,
     UCLA_S3Q21_I_feel_worried_about_future__c,UCLA_S3Q22_Afraid_it_will_happen_again__c,UCLA_S3Q2_I_get_upset_when_reminded__c,
     UCLA_S3Q3_Memories_come_to_mind__c,UCLA_S3Q4_I_feel_angry__c,UCLA_S3Q6_I_feel_I_relive_experience__c,
     UCLA_S3Q7_I_feel_like_staying_by_myself__c,UCLA_S3Q8_I_feel_alone__c,Hospitalized_resd_prgm_for_MH_reasons__c,
     Description_of_traumatic_event__c,Ever_recvd_counseling_other_MH_services__c,Full_PTSD_Diagnosis_Likely__c,
     UCLA_Most_Impacted_By__c,Partial_PTSD_Diagnosis_Likely__c,Prescribe_take_med_to_treat_MH_problem__c,
     UCLA_How_Long_Ago__c,UCLA_S2Q18_Someone_else_hurt_badly__c,UCLA_S3Q9_I_try_not_to_talk_or_think__c,
     UCLA_S3Q5_I_have_bad_dreams__c From Assessment_Legacy__c  where id in: setAssmId]); 
            ID parentId;
        for (Assessment_Legacy__c s : lstAssm){ 
          parentId = s.id; 
        if (setInserted.contains(parentId) == false){  
        	oneMigrate = new  UCLAptsd_RI__c(AssessmentContainerId__c = mapParentIds.get(parentId),
        	UCLA_S1Q10_Violent_injury_of_loved_one__c = s.UCLA_S1Q10_Violent_injury_of_loved_one__c,
        	UCLA_S1Q1_In_a_disaster__c = s.UCLA_S1Q1_In_a_disaster__c,
            UCLA_S1Q11_Painful_medical_treatment__c = s.UCLA_S1Q11_Painful_medical_treatment__c,
     UCLA_S1Q12_Forced_to_have_sex__c = s.UCLA_S1Q12_Forced_to_have_sex__c, 
     UCLA_S1Q13_Anything_else__c = s.UCLA_S1Q13_Anything_else__c,
     UCLA_S1Q2_In_a_bad_accident__c = s.UCLA_S1Q2_In_a_bad_accident__c,
     UCLA_S1Q3_In_a_place_at_war__c = s.UCLA_S1Q3_In_a_place_at_war__c,
     UCLA_S1Q4_Hit_hard_at_home__c = s.UCLA_S1Q4_Hit_hard_at_home__c, 
     UCLA_S1Q5_Seeing_family_member_hit__c = s.UCLA_S1Q5_Seeing_family_member_hit__c,
     UCLA_S1Q6_Beaten_shot_at_threatened__c = s.UCLA_S1Q6_Beaten_shot_at_threatened__c,
     UCLA_S1Q7_Seeing_someone_beaten_etc__c = s.UCLA_S1Q7_Seeing_someone_beaten_etc__c,
     UCLA_S1Q8_Seeing_dead_body__c = s.UCLA_S1Q8_Seeing_dead_body__c,
     UCLA_S1Q9_Having_adult_touch_you__c = s.UCLA_S1Q9_Having_adult_touch_you__c,
     UCLA_S2Q14_Scared_you_would_die__c = s.UCLA_S2Q14_Scared_you_would_die__c, 
     UCLA_S2Q15_Scared_of_being_hurt__c = s.UCLA_S2Q15_Scared_of_being_hurt__c,
     UCLA_S2Q16_Hurt_badly__c = s.UCLA_S2Q16_Hurt_badly__c,
     UCLA_S2Q17_Scared_someone_else_hurt__c = s.UCLA_S2Q17_Scared_someone_else_hurt__c,
     UCLA_S2Q19_Scared_someone_would_die__c = s.UCLA_S2Q19_Scared_someone_would_die__c,
     UCLA_S2Q20_Did_someone_die__c = s.UCLA_S2Q20_Did_someone_die__c,
     UCLA_S2Q21_Were_you_very_scared__c = s.UCLA_S2Q21_Were_you_very_scared__c,
     UCLA_S2Q22_Felt_you_couldn_t_stop_it__c = s.UCLA_S2Q22_Felt_you_couldn_t_stop_it__c,
     UCLA_S2Q23_Disgusting_or_gross__c = s.UCLA_S2Q23_Disgusting_or_gross__c, 
     UCLA_S3Q10_I_have_trouble_feeling_happy__c = s.UCLA_S3Q10_I_have_trouble_feeling_happy__c,
     UCLA_S3Q11_Trouble_feeling_sadness_anger__c = s.UCLA_S3Q11_Trouble_feeling_sadness_anger__c,
     UCLA_S3Q12_I_feel_jumpy__c = s.UCLA_S3Q12_I_feel_jumpy__c,
     UCLA_S3Q13_I_have_trouble_sleeping__c = s.UCLA_S3Q13_I_have_trouble_sleeping__c,
     UCLA_S3Q14_I_think_it_s_partly_my_fault__c = s.UCLA_S3Q14_I_think_it_s_partly_my_fault__c, 
     UCLA_S3Q15_Cant_remember_important_parts__c = s.UCLA_S3Q15_Cant_remember_important_parts__c, 
     UCLA_S3Q16_I_have_trouble_concentrating__c = s.UCLA_S3Q16_I_have_trouble_concentrating__c,
     UCLA_S3Q17_I_avoid_things_that_remind_me__c = s.UCLA_S3Q17_I_avoid_things_that_remind_me__c,
     UCLA_S3Q18_I_have_physical_reactions__c = s.UCLA_S3Q18_I_have_physical_reactions__c,
     UCLA_S3Q19_I_think_I_won_t_live_long__c = s.UCLA_S3Q19_I_think_I_won_t_live_long__c,
     UCLA_S3Q1_I_watch_out_for_danger__c = s.UCLA_S3Q1_I_watch_out_for_danger__c,
     UCLA_S3Q20_I_have_arguments_or_fights__c = s.UCLA_S3Q20_I_have_arguments_or_fights__c,
     UCLA_S3Q21_I_feel_worried_about_future__c = s.UCLA_S3Q21_I_feel_worried_about_future__c,
     UCLA_S3Q22_Afraid_it_will_happen_again__c = s.UCLA_S3Q22_Afraid_it_will_happen_again__c,
     UCLA_S3Q2_I_get_upset_when_reminded__c = s.UCLA_S3Q2_I_get_upset_when_reminded__c,
     UCLA_S3Q3_Memories_come_to_mind__c = s.UCLA_S3Q3_Memories_come_to_mind__c,
     UCLA_S3Q4_I_feel_angry__c = s.UCLA_S3Q4_I_feel_angry__c,
     UCLA_S3Q6_I_feel_I_relive_experience__c = s.UCLA_S3Q6_I_feel_I_relive_experience__c,
     UCLA_S3Q7_I_feel_like_staying_by_myself__c = s.UCLA_S3Q7_I_feel_like_staying_by_myself__c,
     UCLA_S3Q8_I_feel_alone__c = s.UCLA_S3Q8_I_feel_alone__c,
     Hospitalized_resd_prgm_for_MH_reasons__c = s.Hospitalized_resd_prgm_for_MH_reasons__c,
     Description_of_traumatic_event__c = s.Description_of_traumatic_event__c,
     Ever_recvd_counseling_other_MH_services__c = s.Ever_recvd_counseling_other_MH_services__c,
     Full_PTSD_Diagnosis_Likely__c = s.Full_PTSD_Diagnosis_Likely__c,
     UCLA_Most_Impacted_By__c = s.UCLA_Most_Impacted_By__c,
     Partial_PTSD_Diagnosis_Likely__c = s.Partial_PTSD_Diagnosis_Likely__c,
     Prescribe_take_med_to_treat_MH_problem__c = s.Prescribe_take_med_to_treat_MH_problem__c,
    UCLA_How_Long_Ago__c = s.UCLA_How_Long_Ago__c,UCLA_S3Q9_I_try_not_to_talk_or_think__c = s.UCLA_S3Q9_I_try_not_to_talk_or_think__c,
    UCLA_S2Q18_Someone_else_hurt_badly__c = s.UCLA_S2Q18_Someone_else_hurt_badly__c,
    UCLA_S3Q5_I_have_bad_dreams__c = s.UCLA_S3Q5_I_have_bad_dreams__c);
          lstMigrate.add(oneMigrate);
         k++;}} numbers = k;
         if (lstMigrate.size() != 0){
         	 upsert lstMigrate;
           AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =:'UCLA PTSD RI' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}}  
/*
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

 

//    Y_LS_CMI    20  do not need ONLY one rec
  
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
		  Legacy_Database_Id__c = s.Legacy_Database_Id__c);	
        lstMigrate.add(oneMigrate);
         k++;}} numbers = k;
         if (lstMigrate.size() != 0){
         	 upsert lstMigrate;
           AssessmentList__c al = [select id,  recordsMigrated__c from AssessmentList__c where
         assessmentName__c =:'Y-LS/CMI' limit 1];
        al.recordsMigrated__c = k;al.date__c = date.today();
        upsert al;}} 
        */
}