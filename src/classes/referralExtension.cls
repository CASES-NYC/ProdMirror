public with sharing class referralExtension 
{

    private ApexPages.StandardController sc;
    public Referral__c referral;
    public Boolean isEdit {get; set;}
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
    //Lets instantiate the Module helper here
    //Public ModuleHelper mh = new ModuleHelper();

    public referralExtension(ApexPages.StandardController sc) 
    {
        if (!Test.isRunningTest())         
        sc.addFields(new List<String> {'ContactId__c','DocketId__c', 'Attorney_Consent_Date__c','RA_Total_Score_Calc__c', 'Ineligible__c'});
        referral = (Referral__c)sc.getRecord();

    }


        public String pcName {get;set;}
        public String getPcNumChgVal() 
        {
          return null;
        }
        public string pcClass {get;set;}
        public String pcSrpExclusion {get;set;}
        public String pcLevel {get;set;}
        public String pcDegree {get;set;}


   public Referral__c getReferral() {
      if(referral == null) referral = new Referral__c();
      return referral;
   }


   // The next three methods control navigation through
   // the wizard. Each returns a PageReference for one of the three pages
   // in the wizard. Note that the redirect attribute does not need to
   // be set on the PageReference because the URL does not need to change
   // when users move from page to page.
   public PageReference step1() {
      return Page.opptyStep1;
   }

   public PageReference step2() {
      return Page.opptyStep2;
   }

   public PageReference step3() {
      return Page.opptyStep3;
   }

   public PageReference step4() {
      return Page.opptyStep4;
   }

   // This method cancels the wizard, and returns the user to the 
   // Opportunities tab
    public PageReference cancel() {
            PageReference referralPage = new ApexPages.StandardController(referral).view();
            referralPage.setRedirect(true);
            return referralPage; 
    }

   // This method performs the final save for all four objects, and
   // then navigates the user to the detail page for the new
   // opportunity.
   public PageReference save() 
   {
            PageReference referralPage = new ApexPages.StandardController(referral).view();
    return referralPage;
   }
   
    public pagereference reloadPage()
    {
        String nysid = referral.NYSID__c;
        nysid.toUpperCase();
        referral.NYSID__c = nysid;
        Upsert referral;
      Boolean OK2Continue = true;        
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
        return new PageReference('/'+referral.id+'/e');
    }

    public void fieldValidation()
    {
      Boolean OK2Continue = true;
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
   } 

    public PageReference ClientConsented()
    {     

      
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

////////     DOCKET C (3)  AND CASE CHARGES   //////////////////////////////////////////////

          if(referral.Charge_C1__c != '' && referral.Charge_C1__c != NULL)
          {
            Case_Information__c caseInfo3 = new Case_Information__c();
            caseInfo3.Client_Account__c = acctId;
            caseInfo3.Arrest_Date__c = referral.Arrest_Date3__c;
            caseInfo3.Arrest_Number__c = referral.Arrest_Number3__c;
            caseInfo3.Criminal_Court_Arraignment_Date__c = referral.Arraignment_Date__c;
            caseInfo3.Name = referral.Docket3__c;
            if(caseInfo3.Name == 'Docket NA') 
               caseInfo3.No_Docket__c = true;
            caseInfo3.Borough__c = referral.Court_Borough__c;
            caseInfo3.RecordTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
            insert caseInfo3;
            referral.docketid3__c = caseInfo3.Id;

            Case_Charges__c caseChrgC1 = new Case_Charges__c();
            caseChrgC1.Charge__c = referral.Charge_C1__c;
            caseChrgC1.Docket_No__c = referral.docketid3__c;
            caseChrgC1.type__c = 'Criminal Court Arraignment Charges';  
            insert caseChrgC1;

            if(referral.Charge_C2__c != '')
            {          
              Case_Charges__c caseChrgC2 = new Case_Charges__c();
              caseChrgC2.Charge__c = referral.Charge_C2__c;
              caseChrgC2.Docket_No__c = referral.docketid3__c;
              caseChrgC2.type__c = 'Criminal Court Arraignment Charges';  
              insert caseChrgC2;
            }

            if(referral.Charge_C3__c != '')
            {
              Case_Charges__c caseChrgC3 = new Case_Charges__c();
              caseChrgC3.Charge__c = referral.Charge_C3__c;
              caseChrgC3.Docket_No__c = referral.docketid3__c;
              caseChrgC3.type__c = 'Criminal Court Arraignment Charges'; 
              insert caseChrgC3;                          
            } 

            if(referral.Charge_C4__c != '')
            {
              Case_Charges__c caseChrgC4 = new Case_Charges__c();
              caseChrgC4.Charge__c = referral.Charge_C4__c;
              caseChrgC4.Docket_No__c = referral.docketid3__c;
              caseChrgC4.type__c = 'Criminal Court Arraignment Charges'; 
              insert caseChrgC4;                          
            }

            if(referral.Charge_C5__c != '')
            {
              Case_Charges__c caseChrgC5 = new Case_Charges__c();
              caseChrgC5.Charge__c = referral.Charge_C5__c;
              caseChrgC5.Docket_No__c = referral.docketid3__c;
              caseChrgC5.type__c = 'Criminal Court Arraignment Charges';                 
              insert caseChrgC5;                          
            }
          }

////////     DOCKET D (4)  AND CASE CHARGES   //////////////////////////////////////////////


          if(referral.Charge_D1__c != ''&& referral.Charge_D1__c != NULL)
          {
            Case_Information__c caseInfo4 = new Case_Information__c();
            caseInfo4.Client_Account__c = acctId;
            caseInfo4.Arrest_Date__c = referral.Arrest_Date4__c;
            caseInfo4.Arrest_Number__c = referral.Arrest_Number4__c;
            caseInfo4.Criminal_Court_Arraignment_Date__c = referral.Arraignment_Date__c;
            caseInfo4.Name = referral.Docket4__c;
            if(caseInfo4.Name == 'Docket NA') 
               caseInfo4.No_Docket__c = true;
            caseInfo4.Borough__c = referral.Court_Borough__c;
            caseInfo4.RecordTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
            insert caseInfo4;
            referral.docketid4__c = caseInfo4.Id;

            Case_Charges__c caseChrgD1 = new Case_Charges__c();
            caseChrgD1.Charge__c = referral.Charge_D1__c;
            caseChrgD1.Docket_No__c = referral.docketid4__c;
            caseChrgD1.type__c = 'Criminal Court Arraignment Charges';  
            insert caseChrgD1;

            if(referral.Charge_D4__c != '')
            {          
              Case_Charges__c caseChrgD2 = new Case_Charges__c();
              caseChrgD2.Charge__c = referral.Charge_D4__c;
              caseChrgD2.Docket_No__c = referral.docketid4__c;
              caseChrgD2.type__c = 'Criminal Court Arraignment Charges';  
              insert caseChrgD2;
            }

            if(referral.Charge_D3__c != '')
            {
              Case_Charges__c caseChrgD3 = new Case_Charges__c();
              caseChrgD3.Charge__c = referral.Charge_D3__c;
              caseChrgD3.Docket_No__c = referral.docketid4__c;
              caseChrgD3.type__c = 'Criminal Court Arraignment Charges'; 
              insert caseChrgD3;                          
            } 

            if(referral.Charge_D4__c != '')
            {
              Case_Charges__c caseChrgD4 = new Case_Charges__c();
              caseChrgD4.Charge__c = referral.Charge_D4__c;
              caseChrgD4.Docket_No__c = referral.docketid4__c;
              caseChrgD4.type__c = 'Criminal Court Arraignment Charges'; 
              insert caseChrgD4;                          
            }

            if(referral.Charge_D5__c != '')
            {
              Case_Charges__c caseChrgD5 = new Case_Charges__c();
              caseChrgD5.Charge__c = referral.Charge_D5__c;
              caseChrgD5.Docket_No__c = referral.docketid4__c;
              caseChrgD5.type__c = 'Criminal Court Arraignment Charges';                 
              insert caseChrgD5;                          
            }
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