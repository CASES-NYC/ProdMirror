public class assessmentSource 
{
  
  public assessmentSource()
    { 
    }
     
    BJMHS__c BJMHSreturn = new BJMHS__c(); 
     CaseCoordinator__c CCreturn = new  CaseCoordinator__c ();
     CCM_Orientation__c CCMreturn = new CCM_Orientation__c();
     CEP_BPS__c BPSreturn = new CEP_BPS__c();
     CEP_ICD__c ICDreturn = new CEP_ICD__c();
    CEP_Intake__c CEPINTreturn = new CEP_Intake__c();     
     CourtRepAssm__c  CRreturn = new CourtRepAssm__c(); 
  CRAFFT__c CRAFFTreturn  = new CRAFFT__c(); 

    EducationAssm__c Edreturn = new EducationAssm__c();
    Employment_Education_Survey__c EmpEdreturn = new Employment_Education_Survey__c();
 
    HW__c HWreturn = new HW__c ();      

     LifeEventsAssm__c LECreturn = new LifeEventsAssm__c();   
     LSCMI__c LSCMIreturn = new LSCMI__c();
     LSCMI_Y__c LSCMI_Yreturn = new LSCMI_Y__c(); 
     LSIR__c LSIRreturn = new LSIR__c();

     MHSF__c MHSFreturn = new MHSF__c();
     
     PHQ_9__c PHQ_9return = new PHQ_9__c(); 
     PHQ_9T__c PHQ_9Treturn = new PHQ_9T__c();

     SRP_IntakeAssessments__c SRPreturn = new SRP_IntakeAssessments__c();
     SubstanceAbuseAssessment__c SAAreturn = new SubstanceAbuseAssessment__c();  

     Health_Screen__c HSreturn = new  Health_Screen__c();

     PCLC__c PCLreturn = new PCLC__c();
     Psychosocial_MH__c PSYCHOreturn = new Psychosocial_MH__c();
     UCLAptsd_RI__c RIreturn = new UCLAptsd_RI__c();

     TCUassessment__c TCUreturn  = new TCUassessment__c(); 

  //TCU_V__c TCUVreturn = new TCU_V__c();
     TCU_Screen_V__c TCUVreturn = new TCU_Screen_V__c();
     
     UCLA_PTSD_DSM_V__c DSMreturn = new UCLA_PTSD_DSM_V__c();
    WRNA__c WRNAreturn = new WRNA__c();
     ///    BJMHS open record
     public BJMHS__c createBJMHSsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = BJMHS__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  BJMHS__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;  
       BJMHSreturn = Database.Query(strQuery);
       return BJMHSreturn;
    }
    
    
      public EducationAssm__c createEdsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = EducationAssm__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  EducationAssm__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;
       //strQuery += sWhere; 
       Edreturn = Database.Query(strQuery);
       return EDreturn;}
    
//  Employment/Education Survey
    public Employment_Education_Survey__c createSurveySource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = Employment_Education_Survey__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  Employment_Education_Survey__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;
       //strQuery += sWhere; 
       EmpEdreturn = Database.Query(strQuery);
       return EmpEdreturn;}
 
   /// open HBW page  Health and Wellbeing
    public HW__c createHWsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = HW__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  HW__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;
       //strQuery += sWhere; 
       HWreturn = Database.Query(strQuery);
       return HWreturn;}
 
 
   /// open CEP Intake
    public CEP_Intake__c createCEPIntakeSource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = CEP_Intake__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  CEP_Intake__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;
       //strQuery += sWhere; 
       CEPINTreturn = Database.Query(strQuery);
       return CEPINTreturn;}

    

    /// open SRP Intake
    public SRP_IntakeAssessments__c createSRPsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = SRP_IntakeAssessments__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  SRP_IntakeAssessments__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;  
       //strQuery += sWhere; 
       SRPreturn = Database.Query(strQuery);
       return SRPreturn;
    }


    /// open LSCMI 
    public LSCMI__c createLSCMIsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = LSCMI__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  LSCMI__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;  
       //strQuery += sWhere; 
       LSCMIreturn = Database.Query(strQuery);
       return LSCMIreturn;}

   /// open LSCMI Youth
    public LSCMI_Y__c createLSCMI_Ysource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = LSCMI_Y__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  LSCMI_Y__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;  
       //strQuery += sWhere; 
       LSCMI_Yreturn = Database.Query(strQuery);
       return LSCMI_Yreturn;}       
       
  
    /// open LSIR 
    public LSIR__c createLSIRsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = LSIR__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  LSIR__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;  
       //strQuery += sWhere; 
       LSIRreturn = Database.Query(strQuery);
       return LSIRreturn;
    }
  
    /// open PSYCHOsocial
    public Psychosocial_MH__c createPSYCHOsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = Psychosocial_MH__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  Psychosocial_MH__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;  
       //strQuery += sWhere; 
       PSYCHOreturn = Database.Query(strQuery);
       return PSYCHOreturn;
    }
  
  
    ///    TCU open record
    public TCUassessment__c createTCUsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = TCUassessment__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  TCUassessment__c ' + 
       'where AssessmentContainerId__c =: recid limit 1' ;  
     //  strQuery += sWhere; 
       TCUreturn = Database.Query(strQuery);
       return TCUreturn;
    }
   
    ///    CCM ORIENTAtion open record
    public CCM_Orientation__c createCCMsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = CCM_Orientation__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  CCM_Orientation__c '+
      ' where AssessmentContainerId__c =: recid limit 1' ;  
     //  strQuery += sWhere; 
       CCMreturn = Database.Query(strQuery);
       return CCMreturn;
    }   

    /// Substance Abuse open record
  public SubstanceAbuseAssessment__c createSAAsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = SubstanceAbuseAssessment__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
        }
       string strQuery = 'Select ' + fieldsAPIname + ' from  SubstanceAbuseAssessment__c '+
        'where AssessmentContainerId__c =: recid limit 1' ;  
     //  strQuery += sWhere; 
       SAAreturn = Database.Query(strQuery); 
       return SAAreturn;
    }


     ///  Case coordinator open record
  public  CaseCoordinator__c  createCCsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r =  CaseCoordinator__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet()){ 
       Schema.SObjectField field = M.get(fieldName);
       if (fieldsAPIname == '') 
           fieldsAPIname = fieldsAPIname + field;
       else   
           fieldsAPIname = fieldsAPIname + ',' + field;}
       string strQuery = 'Select ' + fieldsAPIname + ' from   CaseCoordinator__c  '+
       'where AssessmentContainerId__c =: recid limit 1' ;  
    //   strQuery += sWhere; 
       CCreturn = Database.Query(strQuery); 
       return CCreturn;
    }


  ///  court Rep open record
    public  CourtRepAssm__c  createCRsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r =  CourtRepAssm__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
        }
       string strQuery = 'Select ' + fieldsAPIname + ' from   CourtRepAssm__c  '+
       'where AssessmentContainerId__c =: recid limit 1' ;  
     //  strQuery += sWhere; 
       CRreturn = Database.Query(strQuery); 
       return CRreturn;
    }


    ///    PHQ9 open record
     public PHQ_9__c createPHQ9source(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = PHQ_9__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  PHQ_9__c '+
       'where AssessmentContainerId__c =: recid limit 1' ;  
     //  strQuery += sWhere; 
       PHQ_9return = Database.Query(strQuery);
       return PHQ_9return;
    }

  ///    PHQ9T open record
   public PHQ_9T__c createPHQ9teensource(string recid)
   {
       string fieldsAPIname = '';
    //  string objName = 'PHQ_9T__c';
       Schema.DescribeSObjectResult r = PHQ_9T__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  PHQ_9T__c '+
       'where AssessmentContainerId__c =: recid limit 1' ;  
     //  strQuery += sWhere; 
       PHQ_9Treturn = Database.Query(strQuery);
       return PHQ_9Treturn;
   }


  ///    LEC open record
     public LifeEventsAssm__c createLECsource(string recid)
     {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = LifeEventsAssm__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  LifeEventsAssm__c '+
       'where AssessmentContainerId__c =: recid limit 1' ;  
      // strQuery += sWhere; 
       LECreturn = Database.Query(strQuery);
       return LECreturn;
     }

  ///    MHSF open record
     public MHSF__c createMHSFsource(string recid)
     {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = MHSF__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  MHSF__c '+
       'where AssessmentContainerId__c =: recid limit 1' ;  
     //  strQuery += sWhere; 
       MHSFreturn = Database.Query(strQuery);
       return MHSFreturn;
     }

  ///    Health Screen open record
     public Health_Screen__c createHSsource(string recid)
     {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = Health_Screen__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  Health_Screen__c ' +
        'where AssessmentContainerId__c =: recid limit 1' ;  
       //strQuery += sWhere; 
       HSreturn = Database.Query(strQuery);
       return HSreturn;
     }

  ///    PCL_C open record
     public PCLC__c createPCLsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = PCLC__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
   string strQuery = 'Select ' + fieldsAPIname + ' from  PCLC__c ' +
      'where AssessmentContainerId__c =: recid limit 1' ;  
   PCLreturn = Database.Query(strQuery);
   return PCLreturn;
   }

  ///    TCU_SCREEN V open record
  public TCU_Screen_V__c createTCUVsource(string recid)
    {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = TCU_Screen_V__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
         Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  TCU_Screen_V__c ' +
          'where AssessmentContainerId__c =: recid limit 1' ;  
       TCUVreturn = Database.Query(strQuery);
       return TCUVreturn;
  }

  ///    CEP BPS open record
     public CEP_BPS__c createBPSsource(string recid)
     {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = CEP_BPS__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  CEP_BPS__c ' +
        'where AssessmentContainerId__c =: recid limit 1' ;  
       BPSreturn = Database.Query(strQuery);
    return BPSreturn;
  }

///    CEP BPS open record
     public UCLA_PTSD_DSM_V__c createDSMsource(string recid)
     {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = UCLA_PTSD_DSM_V__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  UCLA_PTSD_DSM_V__c ' +
        'where AssessmentContainerId__c =: recid limit 1' ;  
       DSMreturn = Database.Query(strQuery);
    return DSMreturn;
  }

//    WRNA open record
     public WRNA__c createWRNAsource(string recid)
     {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = WRNA__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  WRNA__c ' +
        'where AssessmentContainerId__c =: recid limit 1' ;  
       WRNAreturn = Database.Query(strQuery);
    return WRNAreturn;
  }

//    UCLA_PTSD_RI open record
     public UCLAptsd_RI__c createRIsource(string recid)
     {
       string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = UCLAptsd_RI__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { 
      Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
             fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  UCLAptsd_RI__c ' +
        'where AssessmentContainerId__c =: recid limit 1' ;  
        RIreturn = Database.Query(strQuery);
    return RIreturn;
  }

//    CEP ICD open record  
   public CEP_ICD__c createICDsource(string recid)
     {  string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = CEP_ICD__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
           fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  CEP_ICD__c ' +
        'where AssessmentContainerId__c =: recid limit 1' ;  
        ICDreturn = Database.Query(strQuery);
    return ICDreturn;
  }  
  
//    CRAFFT open record  
   public CRAFFT__c createCRAFFTsource(string recid)
     {  string fieldsAPIname = '';
       Schema.DescribeSObjectResult r = CRAFFT__c.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();   
       for(String fieldName : M.keySet())
        { Schema.SObjectField field = M.get(fieldName);
         if (fieldsAPIname == '') 
           fieldsAPIname = fieldsAPIname + field;
         else   
             fieldsAPIname = fieldsAPIname + ',' + field;
       }
       string strQuery = 'Select ' + fieldsAPIname + ' from  CRAFFT__c ' +
        'where AssessmentContainerId__c =: recid limit 1' ;  
        CRAFFTreturn = Database.Query(strQuery);
    return CRAFFTreturn;
  }  


  // SAVE BJMHS
  public void saveBJMHS(BJMHS__c bj,string containerId)
    {
      System.Debug('\n\n XXX containerId: ' + containerId);
      try{
            BJMHS__c b = [select id, result__c from BJMHS__c 
                          where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        bj.AssessmentContainerId__c = containerId;}  
       upsert bj;
        string contId = bj.AssessmentContainerId__c;
        string cResult = '';
        AssessmentContainer__c c = new AssessmentContainer__c(id=contId);   
        BJMHS__c b = [select id, Referral_Recommended_by_Assessment__c,  Referral_Recommended_by_Screener__c 
                from BJMHS__c where AssessmentContainerId__c =: contId limit 1];
            if (b.Referral_Recommended_by_Screener__c == 'Yes' || b.Referral_Recommended_by_Assessment__c == 'Yes')
                cResult = 'Referral recommended';   
            c.assmresult__c  = cResult;
            update c;                    
    }

  // SAVE Education
  public void saveED(EducationAssm__c bj,string containerId)
    {
      System.Debug('\n\n XXX containerId: ' + containerId);
      try{
            EducationAssm__c b = [select id from EducationAssm__c 
                          where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        bj.AssessmentContainerId__c = containerId;}  
       upsert bj;
   }

  // SAVE Empl/ Education survey
  public void saveSurvey(Employment_Education_Survey__c bj,string containerId)
    {
      System.Debug('\n\n XXX containerId: ' + containerId);
      try{
            Employment_Education_Survey__c b = [select id from Employment_Education_Survey__c 
                          where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        bj.AssessmentContainerId__c = containerId;}  
       upsert bj;
   } 


  // SAVE LSCMI
  public void saveLSCMI(LSCMI__c ls,string containerId)
    {
      System.Debug('\n\n XXX in source containerId: ' + containerId);
     try{
         LSCMI__c a = [select id from LSCMI__c 
                       where AssessmentContainerId__c =: containerId];}  
     catch (Exception e){
       ls.AssessmentContainerId__c = containerId;}  
      upsert ls;
  }
  
    // SAVE LSCMI Youth
  public void saveLSCMI_Y(LSCMI_Y__c ls,string containerId)
    {
      System.Debug('\n\n XXX in source containerId: ' + containerId);
     try{
         LSCMI_Y__c a = [select id from LSCMI_Y__c 
                       where AssessmentContainerId__c =: containerId];}  
     catch (Exception e){
       ls.AssessmentContainerId__c = containerId;}  
      upsert ls;
  }
  
 
 // SAVE LSIR
  public void saveLSIR(LSIR__c ls,string containerId)
  {
     try{LSIR__c a = [select id from LSIR__c 
                      where AssessmentContainerId__c =: containerId];}  
     catch (Exception e){
       ls.AssessmentContainerId__c = containerId;}  
      upsert ls;}
 
// SAVE TCU SCTEEN V     
  public void saveTCU(TCU_Screen_V__c tcu,string containerId){
    System.Debug('\n\n XXX containerId: ' + containerId);
   try{TCU_Screen_V__c a = [select id from TCU_Screen_V__c 
                             where AssessmentContainerId__c =: containerId];}  
   catch (Exception e){
       tcu.AssessmentContainerId__c = containerId;}  
      upsert tcu;
  }  

// SAVE TCU V Drug Screen     
  public void saveTCUV(TCU_Screen_V__c tcuv,string containerId)
    {
      System.Debug('\n\n XXX containerId: ' + containerId);
       try{TCU_Screen_V__c a = [select id from TCU_Screen_V__c 
                          where AssessmentContainerId__c =: containerId];}  
       catch (Exception e){
         tcuv.AssessmentContainerId__c = containerId;
        }  
      upsert tcuv;
        string contId = tcuv.AssessmentContainerId__c;
        AssessmentContainer__c c = new AssessmentContainer__c(id=contId);    
        TCU_Screen_V__c t = [select Result__c,TCU_Total_Score__c from TCU_Screen_V__c where 
          AssessmentContainerId__c =: contId limit 1];
             c.assmresult__c  = 'Total score: ' + string.valueOf(t.TCU_Total_Score__c) + ' - ' + t.result__c;
             update c;            
    }  
  
    // SAVE Substance Abuse       
    public void saveSAA(SubstanceAbuseAssessment__c s,string containerId)
    {
    try{SubstanceAbuseAssessment__c a = [select id from SubstanceAbuseAssessment__c 
                                             where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
         s.AssessmentContainerId__c = containerId;
        }  
      upsert s;
  }  

   public void saveCC(CaseCoordinator__c s,string containerId)
   { try{CaseCoordinator__c cc = [select id from CaseCoordinator__c 
      where AssessmentContainerId__c =: containerId];}  
     catch (Exception e){
     s.AssessmentContainerId__c = containerId;}  
     upsert s;}  
   
   public void saveCCM(CCM_Orientation__c s,string containerId)
   {try{CCM_Orientation__c a = [select id from CCM_Orientation__c 
                          where AssessmentContainerId__c =: containerId];}   
   catch (Exception e){s.AssessmentContainerId__c = containerId;}  
      upsert s;}    
   
     public void saveCR(CourtRepAssm__c s,string containerId)
     {try{
      CourtRepAssm__c a = [select id from CourtRepAssm__c 
          where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
       s.AssessmentContainerId__c = containerId;}  
      upsert s;}      
 
    public void saveSRP(SRP_IntakeAssessments__c i,string containerId)
    {
       try{
         SRP_IntakeAssessments__c s = [select id from SRP_IntakeAssessments__c 
                          where AssessmentContainerId__c =: containerId];
        }  
      catch (Exception e){ 
         i.AssessmentContainerId__c = containerId;}   
      upsert i;
    }      
 
 // SAVE TCU      
  public void saveTCU(TCUassessment__c tcu,string containerId){
    System.Debug('\n\n XXX containerId: ' + containerId);
   try{TCUassessment__c a = [select id from TCUassessment__c 
                             where AssessmentContainerId__c =: containerId];}  
   catch (Exception e){
       tcu.AssessmentContainerId__c = containerId;}  
      upsert tcu;
  }  
 
 
   // SAVE PHQ9 
  public void savePHQ9(PHQ_9__c bj,string containerId)
    {
      System.Debug('\n\n XXX containerId: ' + containerId);
       try{
           PHQ_9__c b = [select id from PHQ_9__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
      bj.AssessmentContainerId__c = containerId;}  
       upsert bj;
         totalScorePHQ(containerId);
       
       
     }
   // SAVE PHQ9 teen
    public void savePHQ9teen(PHQ_9T__c bj,string containerId)
    {
      System.Debug('\n\n XXX containerId: ' + containerId);
       try{PHQ_9T__c b = [select id from PHQ_9T__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
      bj.AssessmentContainerId__c = containerId;}  
       upsert bj;
       totalScorePHQ_teen(containerId);
     }
  // SAVE LEC 
    public void saveLEC(LifeEventsAssm__c le,string containerId)
    {
      System.Debug('\n\n XXX saveLEC containerId: ' + containerId);
       try{LifeEventsAssm__c b = [select id from LifeEventsAssm__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
      le.AssessmentContainerId__c = containerId;}  
       upsert le;
     }
 
  // SAVE MHSF
  public void saveMHSF(MHSF__c mh,string containerId)
    {
      System.Debug('\n\n XXX saveLEC containerId: ' + containerId);
       try{MHSF__c b = [select id from MHSF__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        mh.AssessmentContainerId__c = containerId;}   
       upsert mh;
      string contId = mh.AssessmentContainerId__c;
      string cResult = '';
        AssessmentContainer__c c = new AssessmentContainer__c(id=contId);   
       MHSF__c b = [select id, MHSF_Total_Score__c
             from MHSF__c where AssessmentContainerId__c =: contId limit 1];
         cResult = 'Total Score: ' + b.MHSF_Total_Score__c;   
        c.assmresult__c  = cResult;
        update c;   
     }

  // SAVE Health Screen
    public void saveHS(Health_Screen__c mh,string containerId)
    {
      System.Debug('\n\n XXX saveLEC containerId: ' + containerId);
       try{Health_Screen__c b = [select id from Health_Screen__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        mh.AssessmentContainerId__c = containerId;}   
       upsert mh;
     }
 
  // SAVE PCL Screen
    public void savePCL(PCLC__c pl,string containerId)
    {
       try{PCLC__c b = [select id from PCLC__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        pl.AssessmentContainerId__c = containerId;}   
       upsert pl;
     }
      
  // SAVE CEP BPS
  public void saveBPS(CEP_BPS__c c,string containerId)
    {
       try{CEP_BPS__c b = [select id from CEP_BPS__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;
    }    
    
      // SAVE DSM
  public void saveDSM(UCLA_PTSD_DSM_V__c c,string containerId)
    {
       try{UCLA_PTSD_DSM_V__c b = [select id from UCLA_PTSD_DSM_V__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;
    }    
    
        // SAVE WRNA
  public void saveWRNA(WRNA__c c,string containerId)
    {
       try{WRNA__c b = [select id from WRNA__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;}   

        // SAVE UCLA_PTSD_RI
  public void saveRI(UCLAptsd_RI__c c,string containerId){
        try{UCLAptsd_RI__c b = [select id from UCLAptsd_RI__c where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;} 
  
     // SAVE CEP ICD
  public void saveICD(CEP_ICD__c  c,string containerId){
        try{CEP_ICD__c  b = [select id from CEP_ICD__c  where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;}  
 
     // SAVE CRAFFT
  public void saveCRAFFT(CRAFFT__c  c,string containerId){
  try{CRAFFT__c  b = [select id from CRAFFT__c  where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;}  
 
    // SAVE Psychsocial
  public void savePSYCHO(Psychosocial_MH__c  c,string containerId){
  try{Psychosocial_MH__c  b = [select id from Psychosocial_MH__c  where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;}  


       // SAVE CEP Intake
  public void saveCEPIntake(CEP_Intake__c  c,string containerId){
        try{CEP_Intake__c  b = [select id from CEP_Intake__c  where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;} 
  
    // SAVE HW Health and Wellbeing
  public void saveHW(HW__c  c,string containerId){
  try{HW__c  b = [select id from HW__c  where AssessmentContainerId__c =: containerId];}  
      catch (Exception e){
        c.AssessmentContainerId__c = containerId;}   
       upsert c;}  
  
  
   public string validateLEC(LifeEventsAssm__c LECinput){
    string retValue = '';
    if (LECinput.LEC_Q01__c == null)retValue = 'Natural disaster...'; 
    else
      if (LECinput.LEC_Q02__c == null){
        if (retValue == '')retValue = 'Fire or explosion...';
          else retValue = retValue + '* Fire or explosion';}
    if (LECinput.LEC_Q03__c == null){
          if (retValue == '') retValue = 'Transportation accident...';
            else retValue = retValue + '* Transportation accident';  }
    if (LECinput.LEC_Q04__c == null){
            if (retValue == '') retValue = 'Serious accident...';
            else retValue = retValue + '* Serious accident'; 
          }
    if (LECinput.LEC_Q05__c == null){
            if (retValue == '') retValue = 'Exposure to toxic substance...';
            else retValue = retValue + '* Exposure to toxic substance'; }
    if (LECinput.LEC_Q06__c == null){
            if (retValue == '') retValue = 'Physical assault...';
            else  retValue = retValue + '* Physical assault';  }
   if (LECinput.LEC_Q07__c == null){
            if (retValue == '')  retValue = 'Assault with a weapon...';
            else retValue = retValue + '* Assault with a weapon'; }
    if (LECinput.LEC_Q08__c == null){
            if (retValue == '') retValue = 'Sexual assault...';
            else retValue = retValue + '* Sexual assault'; }
        
    if (LECinput.LEC_Q09__c == null){
            if (retValue == '') retValue = 'Other unwanted experience...';
            else retValue = retValue + '*Other unwanted experience'; }
     
    if (LECinput.LEC_Q10__c == null){
            if (retValue == '') retValue = 'Combat or exposure ..';
            else  retValue = retValue + '*Combat or exposure';}
     
    if (LECinput.LEC_Q11__c == null){
            if (retValue == '') retValue = 'Captivity ..';
            else  retValue = retValue + '*Captivity';}
  
    if (LECinput.LEC_Q12__c == null){
            if (retValue == '') retValue = 'Life-threatening illness..';
            else retValue = retValue + '*Life-threatening illness';}
 
    if (LECinput.LEC_Q13__c == null){
            if (retValue == '') retValue = 'Severe human suffering..';
            else retValue = retValue + 'Severe human suffering'; } 
              if (LECinput.LEC_Q14__c == null){
    if (retValue == '') retValue = 'Sudden, violent ..';
            else retValue = retValue + 'Sudden, violent ';} 
      
    if (LECinput.LEC_Q15__c == null){
            if (retValue == '')  retValue = 'Sudden unexpected death ..';
            else retValue = retValue + 'Sudden unexpected death ';}  
     
    if (LECinput.LEC_Q16__c == null){
      if (retValue == '') retValue = 'Serious injury..';
      else retValue = retValue + 'Serious injury'; }
        if (LECinput.LEC_Q17__c == null){
          if (retValue == '') retValue = 'Any other very stressful..';
          else retValue = retValue + 'Any other very stressful'; }  
   return retValue;} 
   
   public void totalScorePHQ( string contId){
 //    return;
     integer sumScore = 0;
   
     PHQ_9__c b = [select id,Score_Summary__c,Little_interest_doing_things__c,Feeling_depressed__c,
     Sleep_trouble__c,Tired_or_lack_energy__c,Poor_appetite_or_overeating__c,Feel_bad_about_yourself__c,Trouble_concentrating__c,
     Moving_or_speaking_slow_or_fast__c,Thoughts_of_self_harm__c 
      from PHQ_9__c where AssessmentContainerId__c =: contId];
   
     if(b.Little_interest_doing_things__c <> null) 
       sumScore += integer.valueOf(b.Little_interest_doing_things__c);  
     if(b.Feeling_depressed__c <> null) 
       sumScore += integer.valueOf(b.Feeling_depressed__c);  
     if(b.Moving_or_speaking_slow_or_fast__c <> null) 
        sumScore += integer.valueOf(b.Moving_or_speaking_slow_or_fast__c);  
     if(b.Thoughts_of_self_harm__c  <> null) 
        sumScore += integer.valueOf(b.Thoughts_of_self_harm__c );  
     if(b.Sleep_trouble__c <> null)
       sumScore += integer.valueOf(b.Sleep_trouble__c);  
     if(b.Tired_or_lack_energy__c <> null) 
        sumScore += integer.valueOf(b.Tired_or_lack_energy__c);  
     if(b.Poor_appetite_or_overeating__c<> null) 
        sumScore += integer.valueOf(b.Poor_appetite_or_overeating__c);  
     if(b.Feel_bad_about_yourself__c <> null)
        sumScore += integer.valueOf(b.Feel_bad_about_yourself__c);
     if(b.Trouble_concentrating__c <> null)
       sumScore += integer.valueOf(b.Trouble_concentrating__c);
 
     b.Score_Summary__c = sumScore;  
     update b;
   }  
   
   public void totalScorePHQ_teen( string contId){
     integer sumScore = 0;
   
     PHQ_9T__c b = [select id,Score_Summary__c,PHQ_Little_interest_doing_things__c,PHQ_Feeling_depressed__c,
     PHQ_Sleep_trouble__c,PHQ_Tired_or_lack_energy__c,PHQ_Poor_appetite_or_overeating__c,PHQ_Feel_bad_about_yourself__c,
     PHQ_Trouble_concentrating__c,PHQ_Moving_or_speaking_slow_or_fast__c,PHQ_Thoughts_of_self_harm__c 
      from PHQ_9T__c where AssessmentContainerId__c =: contId];
   
     if(b.PHQ_Little_interest_doing_things__c <> null) 
       sumScore += integer.valueOf(b.PHQ_Little_interest_doing_things__c);  
     if(b.PHQ_Feeling_depressed__c <> null) 
       sumScore += integer.valueOf(b.PHQ_Feeling_depressed__c);  
     if(b.PHQ_Moving_or_speaking_slow_or_fast__c <> null) 
        sumScore += integer.valueOf(b.PHQ_Moving_or_speaking_slow_or_fast__c);  
     if(b.PHQ_Thoughts_of_self_harm__c  <> null) 
        sumScore += integer.valueOf(b.PHQ_Thoughts_of_self_harm__c );  
     if(b.PHQ_Sleep_trouble__c <> null)
       sumScore += integer.valueOf(b.PHQ_Sleep_trouble__c);  
     if(b.PHQ_Tired_or_lack_energy__c <> null) 
        sumScore += integer.valueOf(b.PHQ_Tired_or_lack_energy__c);  
     if(b.PHQ_Poor_appetite_or_overeating__c<> null) 
        sumScore += integer.valueOf(b.PHQ_Poor_appetite_or_overeating__c);  
     if(b.PHQ_Feel_bad_about_yourself__c <> null)
        sumScore += integer.valueOf(b.PHQ_Feel_bad_about_yourself__c);
     if(b.PHQ_Trouble_concentrating__c <> null)
       sumScore += integer.valueOf(b.PHQ_Trouble_concentrating__c);
 
     b.Score_Summary__c = sumScore;  
     update b;
   }
         
 }