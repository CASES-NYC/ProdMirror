public without sharing class cirtNonDocExtension 
{

    private ApexPages.StandardController sc;
    public CIRT_Download__c cd;
    public MAP<id, Penal_Code__c> mapPenalCodes 
    {
      get {
        if (mapPenalCodes == null)
          mapPenalCodes = new MAP<id, Penal_Code__c>([SELECT Id, Name, Numeric_Charge_Value__c,
                                        Class__c, Degree__c, Description__c, Drug_Related__c, Level__c, 
                                        Top_Charge_Calculation__c, Violent__c
                                        FROM Penal_Code__c]);
        return mapPenalCodes;
      } set;
    }
    public String pcValue {get; set;}
    Public ModuleHelper mh = new ModuleHelper();
    
    public cirtNonDocExtension(ApexPages.StandardController sc) 
    {
        if (!Test.isRunningTest())     
            sc.addFields(new List<String> {'ContactId__c','DocketId__c'});
        cd = (CIRT_Download__c)sc.getRecord();
        

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

    public boolean fieldsarePopulated()
    {
       if(!ErrorHandler.isValueValid(cd.Docket__c))
       {
           mh.CheckText('','value. Enter the Docket Number for intake case.'); 
           return false;
       }
  
       return true;
   } 


    public PageReference ClientConsented()
    {     

       if (cd.NYSID__c <> '' )
       {
          if (validateNYSIDformat(cd.NYSID__c) == false){
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'NYSID format is incorrect.'));
            return null;
          }}
       else
          {
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'NYSID can not be empty.'));
             return null;            
          }
          
      String acctId;
      List<Account> checkAccount = [SELECT Id FROM Account WHERE NYSID_Number__c =: cd.NYSID__c];

      if (checkAccount.size() != 0)
        acctId = checkAccount[0].Id;
      else
      {
          Account account = new Account();   
          account.nysid_number__c = cd.NYSID__c; 
          account.name = cd.firstname__c.trim() + ' ' + cd.lastname__c.trim();
          account.recordtypeId =  Utility_Id__c.getValues('Client').RecordType_Id__c;
          account.DOB__c = cd.DOB__c;
          account.Gender__c = cd.Gender__c;
          insert account;
          acctId = account.Id;
          cd.AccountID__c = acctId;          
      }
          
      Contact contact = new Contact();
      contact.AccountId = acctId;
      contact.firstname = cd.firstname__c; 
      contact.lastname = cd.lastname__c;
      contact.BOOK_CASE__c = cd.BOOKCASENUMBER__c;
      contact.referral_source__c = cd.Referral_Source__c;
      contact.Referral_Date__c = cd.Referral_Date__c;
      contact.DOC_Risk_Score__c = cd.DOC_Score__c;
      contact.recordtypeid = Utility_Id__c.getValues('CIRT Client').RecordType_Id__c;
      Contact.Attorney_Consent__c = 'Yes';
      Contact.Attorney_Decision_Date__c = cd.Referral_Date__c;
      contact.MOCJ_Risk_Score__c = cd.MOCJ_RA_Score__c;
      contact.Screening_Stage__c = 'Pending Interview';
      contact.Interview_Stage__c = 'Consent';          
      contact.Client_Status__c = 'Consented - Not Yet Screened';
      insert contact;
      cd.ContactId__c = Contact.Id;

      List<Case_Information__c> ci = [SELECT name, id, client_account__c 
          FROM Case_Information__c WHERE client_account__c = :acctId];
      if (ci.size() > 0)
      {
        contact.Intake_Case__c = ci[0].Id;
        update contact;
      }
      else
      {
////////     DOCKET A (1)  AND CASE CHARGES   //////////////////////////////////////////////                    

          if(cd.Charge_No__c != '')
          {
              Case_Information__c caseInfo1 = new Case_Information__c();
              caseInfo1.Client_Account__c = acctId;
              //caseInfo1.Arrest_Date__c = cd.Arrest_Date__c;
              //caseInfo1.Arrest_Number__c = cd.Arrest_Number__c;
              caseInfo1.Criminal_Court_Arraignment_Date__c = cd.Arraignment_Date__c;
              caseInfo1.Name = cd.Docket__c;
              if(caseInfo1.Name == 'Docket NA') 
                 caseInfo1.No_Docket__c = true;
              //caseInfo1.Borough__c = cd.Court_Borough__c;
              //caseInfo1.Defense_Attorney_Law_Guardian__c = cd.Attorney__c;
              caseInfo1.RecordTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
              insert caseInfo1;
              cd.docketid__c = caseInfo1.Id;
              contact.Intake_Case__c = caseInfo1.Id;
          
              Case_Charges__c caseChrg1 = new Case_Charges__c();
              caseChrg1.Charge__c = cd.Charge_No__c;
              caseChrg1.Docket_No__c = cd.docketid__c;
              caseChrg1.type__c = 'Criminal Court Arraignment Charges';  
              insert caseChrg1;

              if(cd.Charge_No1__c != '')
              {          
                Case_Charges__c caseChrg2 = new Case_Charges__c();
                caseChrg2.Charge__c = cd.Charge_No1__c;
                caseChrg2.Docket_No__c = cd.docketid__c;
                caseChrg2.type__c = 'Criminal Court Arraignment Charges';  
                insert caseChrg2;
              }

              if(cd.Charge_No2__c != '')
              {
                Case_Charges__c caseChrg3 = new Case_Charges__c();
                caseChrg3.Charge__c = cd.Charge_No2__c;
                caseChrg3.Docket_No__c = cd.docketid__c;
                caseChrg3.type__c = 'Criminal Court Arraignment Charges'; 
                insert caseChrg3;                          
              } 

              if(cd.Charge_No3__c != '')
              {
                Case_Charges__c caseChrg4 = new Case_Charges__c();
                caseChrg4.Charge__c = cd.Charge_No3__c;
                caseChrg4.Docket_No__c = cd.docketid__c;
                caseChrg4.type__c = 'Criminal Court Arraignment Charges'; 
                insert caseChrg4;                          
              }

              if(cd.Charge_No4__c != '')
              {
                Case_Charges__c caseChrg5 = new Case_Charges__c();
                caseChrg5.Charge__c = cd.Charge_No4__c;
                caseChrg5.Docket_No__c = cd.docketid__c;
                caseChrg5.type__c = 'Criminal Court Arraignment Charges';                 
                insert caseChrg5;                          
              }
          }
      }

      Program_Plan__c progPlan = new Program_Plan__c();
      progPlan.Client_Name__c = contact.id;
      progPlan.RecordTypeId = Utility_ID__c.getValues('CIRT Program Plan').RecordType_Id__c;
      insert progPlan;
        
      Address_Information__c addressInfo = new Address_Information__c();
      addressInfo.Client__c = contact.Id;
      addressInfo.Address_Type__c = 'Primary';
      insert addressInfo;
        
      upsert cd;
      upsert contact;
      Pagereference pageRef = new PageReference('/a0U/e');
      pageRef.setRedirect(true);
      pageRef.getParameters().put('RecordType','012600000005N1H');
      pageRef.getParameters().put('CF00N60000001rJHg_lkid',Contact.Id);
      pageRef.getParameters().put('CF00N60000001rJHg',Contact.FirstName+' '+Contact.LastName);
      return pageRef;
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
}