@isTest (SeeAllData=true)
private with sharing class DSM_4_UnitTest {
    //  static Id cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
    static reportQuery rq = new reportQuery();
   static utilityIds utilIds = new utilityIds();
    static Case_Information__c newCaseInfo = new Case_Information__c();
//    static Event eventTest = new Event();
     static Contact newContactForInsert = new Contact();
     static Contact newJudge = new Contact();
    static Client_Diagnosis__c  newDiagnosisForInsert = new Client_Diagnosis__c();
    static Client_Diagnosis__c  newDiagnosisForInsert1 = new Client_Diagnosis__c();
//    static Case_Charges__c chgTest = new Case_Charges__c();
    static Program_Plan__c PPforInsert = new Program_Plan__c();
    static Program_Plan__c PPforInsert1 = new Program_Plan__c();
    static DSM4_code__c dsmcodes = new  DSM4_code__c();
 
 //   static Penal_Code__c ppcode = new Penal_Code__c();
    static Account newAccountForInsert = new Account();
 //   static Address_Information__c addressTest = new Address_Information__c(); 
    static Id caseRecTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
    static Id EventRecTypeId = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
    static Id conCRT = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c; 
    static Id judge  =  Utility_ID__c.getValues('Judge').RecordType_Id__c; 
 //   static Id accCIRT = Utility_ID__c.getValues('CIRT Account').RecordType_Id__c;
      static void createTestData()
  {   
      
        newJudge = new Contact();
        newJudge.FirstName = 'judgeFirst';
        newJudge.lastName = 'JudgeLast';
        newJudge.RecordTypeId = utilIds.conJudge; 
        insert newJudge;

        newAccountForInsert = new Account();
        newAccountForInsert.name = 'Dusty Bottoms';
        newAccountForInsert.RecordTypeId = utilIds.accClient;
        newAccountForInsert.NYSID_Number__c = '90978021U';
        newAccountForInsert.DOB__c = Date.newInstance(1970,1,1);
        insert newAccountForInsert;
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = newAccountforInsert.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoCriminalCourt;
        newCaseInfo.Name = '2011BV144590';
        newCaseInfo.Borough__c = 'Bronx';
        newCaseInfo.judge__c = newjudge.id; 
        insert newCaseInfo;
  
        newContactForInsert = new Contact();
        newContactForInsert.FirstName = 'Dusty';
        newContactForInsert.lastName = 'Bottoms';
        newContactForInsert.Client_Status__c = 'Screened';
        newContactForInsert.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert.Team_Leader__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert.AccountId = newAccountForInsert.id;
        newContactForInsert.Intake_Case__c = newCaseInfo.id;
        newContactForInsert.Referral_Date__c = date.today();
        newContactForInsert.RecordTypeId = utilIds.conDTC;
        insert newContactForInsert;

       PPforInsert = new Program_Plan__c();
       PPforInsert.client_name__c = newContactForInsert.id; 
       insert PPforInsert;
       
       PPforInsert1 = new Program_Plan__c();
       PPforInsert1.client_name__c = newContactForInsert.id; 
       insert PPforInsert1;


       dsmcodes = new  DSM4_code__c();
       dsmcodes.description__c = 'descr1';
       dsmcodes.name = '(111) descr1';
       insert dsmcodes;
 
       
       newDiagnosisForInsert = new Client_Diagnosis__c();
       newDiagnosisForInsert.contact__c = newContactForInsert.id;
       newDiagnosisForInsert.Account__c = newContactForInsert.AccountId;
       newDiagnosisForInsert.Program_Plan__c = PPforInsert.id;
       newDiagnosisForInsert.Type__c = 'Jail';
       newDiagnosisForInsert.description__c = dsmcodes.name;
       insert newDiagnosisForInsert;
       
       newDiagnosisForInsert = new Client_Diagnosis__c();
       newDiagnosisForInsert.contact__c = newContactForInsert.id;
       newDiagnosisForInsert.Account__c = newContactForInsert.AccountId;
       newDiagnosisForInsert.Program_Plan__c = PPforInsert.id;
       newDiagnosisForInsert.Type__c = 'Current';
       newDiagnosisForInsert.description__c = dsmcodes.name;
       insert newDiagnosisForInsert;
  
  
       dsmcodes = new  DSM4_code__c();
       dsmcodes.description__c = 'descr2';
       dsmcodes.name = '(222) descr1';
       insert dsmcodes;
  
       newDiagnosisForInsert = new Client_Diagnosis__c();
       newDiagnosisForInsert.contact__c = newContactForInsert.id;
       newDiagnosisForInsert.Account__c = newContactForInsert.AccountId;
       newDiagnosisForInsert.Program_Plan__c = PPforInsert.id;
       newDiagnosisForInsert.Type__c = 'Current';
       newDiagnosisForInsert.description__c = dsmcodes.name;
       insert newDiagnosisForInsert;
       
       newDiagnosisForInsert1 = new Client_Diagnosis__c();
       newDiagnosisForInsert1.contact__c = newContactForInsert.id;
       newDiagnosisForInsert1.Account__c = newContactForInsert.AccountId;
       newDiagnosisForInsert.Program_Plan__c = PPforInsert.id;
       newDiagnosisForInsert1.Type__c = 'Jail';
       newDiagnosisForInsert1.description__c = dsmcodes.name;
       insert newDiagnosisForInsert1;
    }
       static testMethod void testDSM4()
      {
           createTestData();
           test.startTest();
           DSM_4_Controller dsm = new DSM_4_Controller(); 
           dsm.progPlanPassed = PPforInsert.id;
           dsm.buildDiagnosisInfo();
           test.stopTest();
     }
        static testMethod void testSave()
      {
           createTestData();
           test.startTest();
           DSM_4_Controller dsm = new DSM_4_Controller(); 
           dsm.progPlanPassed = PPforInsert.id;
           dsm.pl1 = '(222) descr1';
           dsm.pl2 = '(333) descr2)';
           dsm.pl3 = '(333) descr3)';
           dsm.pl4 = '(333) descr3)';
           dsm.pl5 = '(333) descr4)';
           dsm.diagType = 'Jail';
           dsm.clientPassed = rq.progInfo(dsm.progPlanPassed);
           dsm.SaveSelectedDiag();

           dsm.diagType = 'Current';
           dsm.progPlanPassed = PPforInsert1.id;
           dsm.clientPassed = rq.progInfo(dsm.progPlanPassed);
           dsm.SaveSelectedDiag();
           test.stopTest();
     }

        static testMethod void testCODES()
      {
           createTestData();
           test.startTest();
           DSM_4_Controller dsm = new DSM_4_Controller(); 
           dsm.progPlanPassed = PPforInsert.id;
           dsm.id2delete = newDiagnosisForInsert.id;
           dsm.deleteDiag();
           List<SelectOption> lst1 = dsm.CodesItems1;
           List<SelectOption> lst2 = dsm.CodesItems2;
           List<SelectOption> lst3 = dsm.CodesItems3;
           List<SelectOption> lst4 = dsm.CodesItems4;
           List<SelectOption> lst5 = dsm.CodesItems5;
           
           dsm.closePopUp();
           dsm.showPopup();
           test.stopTest();
    
}}