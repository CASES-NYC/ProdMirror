public class multiTabDisableController {
    private ApexPages.StandardController sc;
    public Referral__c referral;
    public Boolean isEdit {get; set;}
    public Boolean isNew {get; set;}
    public String screeningStage {get; set;}
    public boolean input { get; set; }
    public String selecttab1 { get; set; }
    public String currentTab {get; set;}
    public boolean output { get; set; }
    public Map<String, String> pageParameters = new Map<String, String>();
    public String referralId {get; set;}
    public String retURL {get; set;}
    public String detectedMode {get;set;}
    public String saveNew {get;set;}
    private String selectedTab;
    public Boolean sryAgeRange {get; set;}  //in Supervised Release Youth's age range

    public MAP<id, Penal_Code__c> mapPenalCodes {
      get {
        if (mapPenalCodes == null)
          mapPenalCodes = new MAP<id, Penal_Code__c>([SELECT Id, Name, Numeric_Charge_Value__c,
                                        Class__c, Degree__c, Description__c, Drug_Related__c, Level__c, 
                                        SRP_Exclusion__c, Top_Charge_Calculation__c, Violent__c
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
    public multiTabDisableController(ApexPages.StandardController sc) 
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
        //selecttab1 ='name1';
        currentTab = '1';
        output=false;
        input=true;
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



    
    public void nextTab() { currentTab = String.valueOf(Integer.valueOf(currentTab)+1); }
    public void prevTab() { currentTab = String.valueOf(Integer.valueOf(currentTab)-1); }
}