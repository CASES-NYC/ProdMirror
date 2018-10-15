public class xxxTabController {

    private ApexPages.StandardController sc;
    public Referral__c referral;
    public Boolean isEdit {get; set;}
    public Boolean isNew {get; set;}
    public String screeningStage {get; set;}
    public boolean input { get; set; }
    public String selecttab1 { get; set; }
    public boolean output { get; set; }
    public Map<String, String> pageParameters = new Map<String, String>();
    public String referralId {get; set;}
    public String retURL {get; set;}
    public String detectedMode {get;set;}
    public String saveNew {get;set;}
    private String selectedTab;
    public Boolean sryAgeRange {get; set;}  //in Supervised Release Youth's age range

    public MAP <id, Penal_Code__c> mapPenalCodes
    {
      get {
        if (mapPenalCodes == null)
          mapPenalCodes = new MAP<id, Penal_Code__c>(
                          [SELECT Id, Name, Class__c, Degree__c, Description__c, Level__c, 
                               SRP_Exclusion__c, Top_Charge_Calculation__c
                          FROM Penal_Code__c]);
        return mapPenalCodes;
      } set;
    }
    public String pcValue {get; set;}
    public String pcName {get;set;}
    public string pcClass {get;set;}
    public String pcSrpExclusion {get;set;}
    public String pcLevel {get;set;}
    public String pcDegree {get;set;}
    public String getPcNumChgVal() 
    {
      return null;
    }
    public xxxTabController(ApexPages.StandardController sc) 
    {
        if (!Test.isRunningTest())         
        sc.addFields(new List<String> {'ContactId__c','DocketId__c', 'Attorney_Consent_Date__c','RA_Total_Score_Calc__c', 'Ineligible__c'});
        referral = (Referral__c)sc.getRecord();
        pageParameters = ApexPages.currentPage().getParameters();
        referralId = PageParameters.get('id');
        retURL = PageParameters.get('retURL');
        saveNew = PageParameters.get('save_new');
        if (referralId == null)
            { DetectedMode = 'New';  } 
        else if (referralId != null &  retURL!= null)
            { DetectedMode = 'Edit'; } 
        else if (referralId != null & retURL == null)
            { DetectedMode = 'View'; }
        //selectedTab = 'tabOne';
        output=false;
        input=true;
        selectedTab = 'tab1';
    }

    public PageReference saveBasicInfo() 
    {
       /*  
        system.debug('Screening Stage: ' + referral.Screening_Stage__c);
        if(referral.Screening_Stage__c == '')
        {
            String nysid = referral.NYSID__c;
            nysid.toUpperCase();
            referral.NYSID__c = nysid;
            referral.Screening_Stage__c = 'Eligibility Testing';
            Upsert referral;
        }
        if basic info
                create record
                validate nysid
                check age
                change screening stage to eligibility testing
                rerender show basic view /eligibility edit

            if eligibility testing

            
            if Additional Information
            if Completed Evaluation 
    */        
        if(DetectedMode == 'New')
        {
            String nysid = referral.NYSID__c;
            referral.NYSID__c = nysid.toUpperCase();
            referral.Screening_Stage__c = 'Eligibility Testing';        
            if(referral.Screening_Date__c == NULL){referral.Screening_Date__c = referral.Referral_Date__c;}
            if(referral.Court_Representative__c == NULL){referral.Court_Representative__c = UserInfo.getUserId();}
            referral.Screening_Stage__c = 'Eligibility Testing';
            Upsert referral;
        }
        selecttab1 ='name2';
        return null;
        //PageReference referralPage = new PageReference('/'+referral.id);
        //return referralPage;
    }

    public List<Penal_Code__c> penalCodeList {
      get {
        if (penalCodeList == null) {
          penalCodeList= [select Id, Name, Description__c, Top_Charge_Calculation__c, Numeric_Charge_Value__c, SRP_Exclusion__c
            FROM Penal_Code__c Order By Name];
        }
        return penalCodeList;        
      } set;
    }
    
    public List<SelectOption> penalCodes
    {
      get{
        List<SelectOption> penalCodes = new List<SelectOption>();
        penalCodes.add(new SelectOption('',''));
        for (Penal_Code__c p : [select Id, name, description__c from Penal_Code__c order by name])
        {
            penalCodes.add(new SelectOption(p.id,p.name.trim()));
        }
        return penalCodes;
        }
      set{penalCodes = this.penalCodes;}
    }    

//////////////////////  TAB MANAGEMENT  ////////////////////////////////

  public boolean getistab1disabled() {
    return selectedTab <> 'tab1';
  }

  public boolean getistab2disabled() {
    return selectedTab <> 'tab2';
  }

  public boolean getistab3disabled() {
    return selectedTab <> 'tab3';
  }

  public boolean getistab4disabled() {
    return selectedTab <> 'tab4';
  }

  public boolean getistab5disabled() {
    return selectedTab <> 'tab5';
  }  

  public void enabletab1() {
    selectedtab = 'tab1';
  }

  public void enabletab2() {
    selectedtab = 'tab2';
  }

  public void enabletab3() {
    selectedtab = 'tab3';
  }

  public void enabletab4() {
    selectedtab = 'tab4';
  }

  public void enabletab5() {
    selectedtab = 'tab5';
  }
  public string getselectedtab() {
     return selectedtab;
  }
}
