public with sharing class referralExtension 
{

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

    public referralExtension(ApexPages.StandardController sc) 
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
        selecttab1 ='name1';
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

    public PageReference save() 
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
        PageReference referralPage = new PageReference('/'+referral.id);
        return referralPage;
    }

    public Referral__c getReferral() 
    {
        if(referral == null) referral = new Referral__c();
        return referral;
    }

    public PageReference cancel() 
    {
                if(referralId != NULL && referralId !='' && detectedMode != 'View')
                {
                        PageReference referralPage1 = new PageReference('/'+ referral.Id);
                        return referralPage1;
                }
                else
                {
                        PageReference referralPage2 = new PageReference('/a1G/o');
                        return referralPage2;
                }
    }

    // This method performs the final save for all four objects, and
    // then navigates the user to the detail page for the new
    // opportunity.

   
    public pagereference reloadPage()
    {
    
        return new PageReference('/'+referral.id+'/e');
    }

    public pagereference fieldValidation()
    {
      Boolean OK2Continue = true;
        /*
      upsert referral;
      if(referral.Ineligible__c != NULL && referral.Ineligible__c != '' && referral.Ineligible__c != 'Eligible')
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Client not eligible.'));
        OK2Continue = false;      
      }
        
      if(referral.MOCJ_Risk_Category__c == 'INCOMPLETE')
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Risk assessment not completed.'));
        OK2Continue = false;       
      } 
            
      if (referral.Client_Consent_to_Screening__c  != 'Yes' )
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Client not consented.'));
        OK2Continue = false;       
      }    
      
      if (referral.Attorney_Consent__c  != 'Yes' )
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Attorney not consented.'));
        OK2Continue = false;       
      }    
      
      if((referral.Docket__c == NULL || referral.Docket__c == '') && (referral.Indictment__c == NULL || referral.Indictment__c == '') )
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Docket/Indictment #.'));
        OK2Continue = false;       
      }      
      
      if(referral.Arrest_Date__c == NULL)
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter arrest date.'));
        OK2Continue = false;     
      }    
      
      if(referral.Arrest_Number__c == NULL ||referral.Arrest_Number__c == '')
      {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter arrest number.'));
        OK2Continue = false;       
      }   
     
      if(OK2Continue)
      {
          ClientConsented();
      }
        */
        return null;  //////////delete this line    
    }
    
    public PageReference ClientConsented()
    {     
        /*
      String acctId;
      List<Account> checkAccount = [SELECT Id FROM Account WHERE NYSID_Number__c =: referral.NYSID__c];

      if (checkAccount.size() != 0)
        acctId = checkAccount[0].Id;
      else
      {
          Account account = new Account();   
          account.nysid_number__c = referral.NYSID__c; 
          account.name = referral.firstname__c.trim() + ' ' + referral.lastname__c.trim();
          account.recordtypeId =  Utility_Id__c.getValues('Client').RecordType_Id__c;
          account.DOB__c = referral.DOB__c;
          insert account;
          acctId = account.Id;
          referral.AccountID__c = acctId;          
      }
          
          Contact contact = new Contact();
          contact.AccountId = acctId;
          contact.firstname = referral.firstname__c; 
          contact.lastname = referral.lastname__c;
          contact.BOOK_CASE__c = referral.BOOKCASENUMBER__c;
          contact.referral_source__c = referral.ReferredBy__c;
          contact.Referral_Date__c = referral.Referral_Date__c;
          contact.CJA_Score__c = referral.cja_score__c;
          contact.Court_Rep__c = referral.Court_Representative__c;
          contact.X730_Evaluation__c = referral.X730_Evaluation_pl__c;
          contact.recordtypeid = Utility_Id__c.getValues('SRP Client').RecordType_Id__c;
          Contact.Attorney_Consent__c = 'Yes';
          Contact.Attorney_Decision_Date__c = referral.Referral_Date__c;
          contact.Supervision_Level__c = referral.Supervision_Level_Recommendation__c;
          contact.MOCJ_Risk_Score__c = referral.RA_Total_Score_Calc__c;
          contact.Screening_Stage__c = 'Pending Interview';
          contact.Interview_Stage__c = 'Consent';          
          contact.Client_Status__c = 'Consented - Not Yet Screened';
          insert contact;
          referral.ContactId__c = Contact.Id;
          contact.SR_Referral__c = referral.Id;

////////     DOCKET A (1)  AND CASE CHARGES   //////////////////////////////////////////////                    

          if(referral.Charge_A1__c != '')
          {
          Case_Information__c caseInfo1 = new Case_Information__c();
          caseInfo1.Client_Account__c = acctId;
          caseInfo1.Arrest_Date__c = referral.Arrest_Date__c;
          caseInfo1.Arrest_Number__c = referral.Arrest_Number__c;
          caseInfo1.Criminal_Court_Arraignment_Date__c = referral.Arraignment_Date__c;
          if (referral.Indictment__c != NULL && referral.Docket__c == NULL)
              referral.Docket__c = 'Docket NA';
          caseInfo1.Name = referral.Docket__c;
          if(caseInfo1.Name == 'Docket NA') 
               caseInfo1.No_Docket__c = true;
          caseInfo1.Indictment__c = referral.Indictment__c;
          caseInfo1.Borough__c = referral.Court_Borough__c;
          caseInfo1.Defense_Attorney_Law_Guardian__c = referral.Attorney_lu__c;
          caseInfo1.RecordTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
          insert caseInfo1;
          referral.docketid__c = caseInfo1.Id;
          contact.Intake_Case__c = caseInfo1.Id;
          
          Case_Charges__c caseChrg1 = new Case_Charges__c();
          caseChrg1.Charge__c = referral.Charge_A1__c;
          caseChrg1.Docket_No__c = referral.docketid__c;
          caseChrg1.type__c = 'Criminal Court Arraignment Charges';  
          insert caseChrg1;

          if(referral.Charge_A2__c != '')
          {          
            Case_Charges__c caseChrg2 = new Case_Charges__c();
            caseChrg2.Charge__c = referral.Charge_A2__c;
            caseChrg2.Docket_No__c = referral.docketid__c;
            caseChrg2.type__c = 'Criminal Court Arraignment Charges';  
            insert caseChrg2;
          }

          if(referral.Charge_A3__c != '')
          {
            Case_Charges__c caseChrg3 = new Case_Charges__c();
            caseChrg3.Charge__c = referral.Charge_A3__c;
            caseChrg3.Docket_No__c = referral.docketid__c;
            caseChrg3.type__c = 'Criminal Court Arraignment Charges'; 
            insert caseChrg3;                          
          } 

          if(referral.Charge_A4__c != '')
          {
            Case_Charges__c caseChrg4 = new Case_Charges__c();
            caseChrg4.Charge__c = referral.Charge_A4__c;
            caseChrg4.Docket_No__c = referral.docketid__c;
            caseChrg4.type__c = 'Criminal Court Arraignment Charges'; 
            insert caseChrg4;                          
          }

          if(referral.Charge_A5__c != '')
          {
            Case_Charges__c caseChrg5 = new Case_Charges__c();
            caseChrg5.Charge__c = referral.Charge_A5__c;
            caseChrg5.Docket_No__c = referral.docketid__c;
            caseChrg5.type__c = 'Criminal Court Arraignment Charges';                 
            insert caseChrg5;                          
          }

////////     DOCKET B (2)  AND CASE CHARGES   //////////////////////////////////////////////

          if(referral.Charge_B1__c != '' && referral.Charge_B1__c != NULL)
          {
            Case_Information__c caseInfo2 = new Case_Information__c();
            caseInfo2.Client_Account__c = acctId;
            caseInfo2.Arrest_Date__c = referral.Arrest_Date2__c;
            caseInfo2.Arrest_Number__c = referral.Arrest_Number2__c;
            caseInfo2.Criminal_Court_Arraignment_Date__c = referral.Arraignment_Date__c;
            caseInfo2.Name = referral.Docket2__c;
            if(caseInfo2.Name == 'Docket NA') 
               caseInfo2.No_Docket__c = true;
            caseInfo2.Borough__c = referral.Court_Borough__c;
            caseInfo2.RecordTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
            insert caseInfo2;
            referral.docketid2__c = caseInfo2.Id;
          
          
            Case_Charges__c caseChrgB1 = new Case_Charges__c();
            caseChrgB1.Charge__c = referral.Charge_B1__c;
            caseChrgB1.Docket_No__c = referral.docketid2__c;
            caseChrgB1.type__c = 'Criminal Court Arraignment Charges';  
            insert caseChrgB1;

            if(referral.Charge_B2__c != '')
            {          
              Case_Charges__c caseChrgB2 = new Case_Charges__c();
              caseChrgB2.Charge__c = referral.Charge_B2__c;
              caseChrgB2.Docket_No__c = referral.docketid2__c;
              caseChrgB2.type__c = 'Criminal Court Arraignment Charges';  
              insert caseChrgB2;
            }

            if(referral.Charge_B3__c != '')
            {
              Case_Charges__c caseChrgB3 = new Case_Charges__c();
              caseChrgB3.Charge__c = referral.Charge_B3__c;
              caseChrgB3.Docket_No__c = referral.docketid2__c;
              caseChrgB3.type__c = 'Criminal Court Arraignment Charges'; 
              insert caseChrgB3;                          
            } 

            if(referral.Charge_B4__c != '')
            {
              Case_Charges__c caseChrgB4 = new Case_Charges__c();
              caseChrgB4.Charge__c = referral.Charge_B4__c;
              caseChrgB4.Docket_No__c = referral.docketid2__c;
              caseChrgB4.type__c = 'Criminal Court Arraignment Charges'; 
              insert caseChrgB4;                          
            }

            if(referral.Charge_B5__c != '')
            {
              Case_Charges__c caseChrgB5 = new Case_Charges__c();
              caseChrgB5.Charge__c = referral.Charge_B5__c;
              caseChrgB5.Docket_No__c = referral.docketid2__c;
              caseChrgB5.type__c = 'Criminal Court Arraignment Charges';                 
              insert caseChrgB5;                          
            }
        }

        Criminal_and_Legal_History__c legalHistory = new Criminal_and_Legal_History__c();
        legalHistory.Account__c = acctId;
        legalHistory.Prior_Felony_Arrests__c = referral.Prior_Arrests_Felony__c;
        legalHistory.Prior_Felony_Convictions__c = referral.Prior_Convictions_Felony__c;
        legalHistory.Prior_Misdemeanor_Arrests__c = referral.Prior_Arrests_Misdemeanor__c;
        legalHistory.Prior_Misdemeanor_Convictions__c = referral.Prior_Convictions_Misdemeanor__c;
        legalHistory.Convictions_in_the_Past_12_Months__c= referral.Convictions_in_past_12_months__c;
        legalHistory.Prior_Violent_Conviction__c=referral.Prior_Conviction_Violence__c;
        legalHistory.Prior_Violent_Conviction_Charge__c=referral.Prior_Conv_Violence_Pl_Code__c;
        legalHistory.Prior_Violent_Conviction_Date__c=referral.Date_Prior_Conviction_Violence__c;
        insert legalHistory;
        
        Address_Information__c addressInfo = new Address_Information__c();
        addressInfo.Client__c = contact.Id;
        addressInfo.Address_Type__c = 'Primary';
        insert addressInfo;
          
        upsert referral;
        upsert contact;

      return (new PageReference('/apex/CourtPortal_SRP'));    
        */
        return null;  //////////delete this line
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

/*
    public boolean validateDocketformat(string s)
    {
      if (s.length() != 12)    
           return false;    
      string s1 = s.left(4);
      string s2 = s.mid(4,2);
      string s3 = s.right(6);
      boolean b1 = false;
      boolean b2 = false;
      boolean b3 = false;
      if ( s1.isNumeric() == false)
        return false;
      if ( s2.isAlpha() == false)
        return false;
      if ( s3.isNumeric() == false)
        return false;
      return true;
    }

    public boolean validateNYSIDformat(string s)
    {
      if (s.length() != 9)    
        return false;
      string s1 = s.left(8);
      string s2 = s.right(1);
      boolean b1 = false;
      boolean b2 = false;
      if ( s1.isNumeric() == false)
        return false;
      if ( s2.isAlpha() == false)
        return false;
      return true;
      }

    public boolean validateBookCase(string s)
    {
      if (s.length() != 10)    
           return false;
      return true;
    }
*/

}