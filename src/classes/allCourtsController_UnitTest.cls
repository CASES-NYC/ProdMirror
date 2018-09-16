@isTest(SeeAllData=true)
private class allCourtsController_UnitTest {
  static utilityIds utilIDs = new utilityIds();
    static UtilityTimeMethods ut = new UtilityTimeMethods();
    static string t_timeBeg;
    static boolean bolStartTimeRequired;
    static Case_Relationship__c Rel = new Case_Relationship__c();    
    static Program_Plan__c newProgramPlan = new Program_Plan__c();
    static User userCaseCoordinator;
    static Id eventId = null;
    static Account acc1 = new Account();
    static Account acc2 = new Account();
    static Contact con1 = new Contact();
    static Contact con2 = new Contact();    
    static Contact con3 = new Contact();    
    static List<Event> listEvents = new List<Event>();
    static Case_Information__c Case1 =  new Case_Information__c();
    static Case_Information__c Case2 =  new Case_Information__c();
    static User u = new User();
    static Event evt1 = new Event();    
    static Event evt2 = new Event();    
    static string cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
    static string srpClient = Utility_ID__c.getValues('SRP Client').RecordType_Id__c;
    static string cirtClient = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c;
    static  string sfid,sfid2,clientId2,event1,event2,repid,cname,pcid1,pcid2,repid1,actionid1,actionid2,
    caseid1,caseid2;
    //static List<Contact> lstcontacts = new List<Contact>();
    static Map<id,Contact> mapcontact = new Map<id,Contact>();
    static date ctdate,ctdate2; 
    static String[] selProgramIds = new String[]{'CEP','CIRT','SRP'};
    static Id caseCriminalRecTypeId = 
      Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
    static Id caseSupremeRecTypeId = 
      Utility_ID__c.getValues('Case - Supreme Court').RecordType_Id__c;  
   
    static void createTestData() {
        u = [SELECT Id FROM User WHERE IsActive =: true AND Court_Team__c  !=: '' limit 1];
        u.Court_Team__c = 'Team 1';
        update u;
            date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        datetime dtime = DateTime.parse(s);
 
        acc1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        acc1.NYSID_Number__c = '12548725T';
        insert acc1;

        acc2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        acc2.NYSID_Number__c = '12548725S';
        insert acc2;
 
 
        Case1 = new Case_Information__c();
        case1.Client_Account__c = acc1.Id;
        case1.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case1.Name = '2014BG456055';
        case1.Indictment__c = '1235647894';
        case1.Borough__c = 'Bronx';
        case1.Arrest_Date__c = date.today().addDays(-35);
        insert case1; 
        caseid1 = case1.id;  

        Case2 = new Case_Information__c();
        case2.Client_Account__c = acc1.Id;
        case2.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case2.Name = '2000BJ456011';
        case2.Indictment__c = '3000000000';
        case2.Borough__c = 'Brooklyn';
        case2.Arrest_Date__c = date.today().addDays(-2);
        insert case2; 
        caseid2 = case2.id;  
 
 
 
        con1 = new Contact();
        con1.Court_Rep__c = UserInfo.getUserId();
        con1.RecordTypeId = cepClient;
        con1.Screening_Stage__c = 'Screening Complete';
        con1.firstName = 'first';
        con1.Client_Status__c = 'Active';
        con1.lastName = 'last';   
        con1.Referral_Date__c = date.today().addDays(-30);
        con1.Current_Intake_Date__c = date.today().addDays(-30);
        con1.accountId = acc1.id;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Case__c = caseid1;
        insert con1;
        pcid1 = con1.P_C_ID__c;
    //    lstcontacts.add(con1);
       
        
        update con1;
        
        con2 = new Contact();
        con2.Court_Rep__c = UserInfo.getUserId();
        con2.AccountId = acc2.id;
        con2.RecordTypeId = srpClient;
        con2.Screening_Stage__c = 'Pending Attorney Info';
        con2.firstName = 'first1';
        con2.Client_Status__c = 'Active';
        con2.lastName = 'last1';   
        con2.Referral_Date__c = date.today().addDays(-25);
        con2.Current_Intake_Date__c = date.today().addDays(-25);
        con2.Reporting_Borough__c = 'Queens';   
        con2.Intake_Case__c = caseid2;
   //     con1.Intake_Date__c = ddate - 30;    
        insert con2;
        pcid2 = con2.P_C_ID__c;
 //     lstcontacts.add(con2);


       Rel = new Case_Relationship__c();
        Rel.Contact__c = con1.id;
        Rel.Docket__c = caseid1;
        insert Rel; 
        system.assert(rel != null);
 
        update rel;
  
        id  courtRecType = utilIds.courtDate;

        evt1 = new Event();
        evt1.Subject = 'Court Date';
        evt1.ActivityDateTime = System.Now().addHours(+24);
        evt1.ActivityDate = date.today().addDays(+1);
        evt1.DurationInMinutes = 30;
        evt1.Part__c = '010';
        evt1.WhoId = con1.id;
        evt1.WhatId = caseid1;
        evt1.P_C_ID__c = pcid1;
        evt1.Subject = 'Court Date';
        evt1.RecordTypeId = courtRecType;
        insert evt1;

        evt2 = new Event();
         evt2.Subject = 'Court Date';
        evt2.ActivityDateTime = System.Now().addHours(+48);
        evt2.ActivityDate = date.today().addDays(+48);
        evt2.DurationInMinutes = 30;
        evt2.WhoId = con1.id;
        evt2.WhatId = caseid1;
        evt2.P_C_ID__c = pcid1;
        evt2.Subject = 'Court Date';
        evt2.RecordTypeId = courtRecType;
        evt2.Part__c = '020';
        insert evt2;

       } 
    
      static testMethod void test1(){
        createTestData();
        allCourtsController cls = new allCourtsController();
        test.startTest();
        cls.programs = selProgramIds;
        List<SelectOption> so = cls.StageItems;
        List<SelectOption> s1 = cls.getProgramItems();
      cls.cpValue = 'All';
       cls.ccValue = 'All';
        cls.crValue = 'All';

        List<SelectOption> allboro = cls.BoroItems;
        List<SelectOption> s = cls.getSearchItems();
        List<SelectOption> sp = cls.getSearchItems();
        cls.RequeryInfo();
        con2.Screening_Stage__c = 'Pending Interviev';
        update con2;
        cls.RequeryInfo();
        boolean filt = cls.checkFilter('All');
    
        cls.findbtnURL('CEP', con1.Intake_Case__c,con1.id,con1.AccountId,'Attorney',evt1.id);
        cls.findbtnURL('CEP', con1.Intake_Case__c,con1.id,con1.AccountId,'Basic',evt1.id);
        cls.findbtnURL('CEP', con1.Intake_Case__c,con1.id,con1.AccountId,'Interview',evt1.id);
         cls.findbtnURL('CEP', con1.Intake_Case__c,con1.id,con1.AccountId,'Pending',evt1.id);
        cls.findbtnURL('CEP', con1.Intake_Case__c,con1.id,con1.AccountId,'Orientation',evt1.id);
  
        cls.findbtnURL('CRT', con1.Intake_Case__c,con1.id,con1.AccountId,'Attorney',evt1.id);
      cls.findbtnURL('CRT', con1.Intake_Case__c,con1.id,con1.AccountId,'Mandate',evt1.id);
        cls.findbtnURL('CRT', con1.Intake_Case__c,con1.id,con1.AccountId,'Interview',evt1.id);
    
        cls.findbtnURL('SRP', con1.Intake_Case__c,con1.id,con1.AccountId,'Attorney',evt1.id);
        cls.findbtnURL('SRP', con1.Intake_Case__c,con1.id,con1.AccountId,'Interview',evt1.id);
 
          cls.RequeryInfo();
      
        cls.searchValue = '2014BG456055';
        cls.selectClient();

        cls.boroValue = 'Brooklyn'; 
        cls.RequeryInfo();
       con1.Screening_Stage__c = 'Pending Mandate';
        update con1;
 
        con2.Screening_Stage__c = 'Pending Basic Client Data';
        update con2;
        cls.RequeryInfo();
        con2.Screening_Stage__c = 'Pending Attorney Info';
        update con2;
       cls.RequeryInfo();        
/*
       con2.Screening_Stage__c = 'Attorney';
        update con2;
       cls.RequeryInfo();

        cls.saveLogin(); 
        String[] prog = cls.getPrograms();
//        string[] p = cls.Programs;  
  
        cls.programs = prog;
        cls.RequeryInfo();   
        string s2 = cls.getChooserender();
        PageReference pageRef = Page.allCourtsPage;
        pageRef.getParameters().put('selectedClient',con1.id); 
        cls.selectedClient = con1.id;
        cls.showPopup();
        cls.deliverAsPDF();
        cls.closePopup();
        cls.proxyObject.Closing_Date__c = date.today();
        cls.proxyObject.Catalog_End_Date__c = date.today().addDays(-1);
         cls.RequeryInfo(); 
        
        cls.sfAdmin = false;
        cls.proxyObject.Catalog_End_Date__c = date.today().addDays(+45);
        cls.RequeryInfo();   
  */
        test.stopTest();
      }
       static testMethod void test2(){
        createTestData();
        allCourtsController cls = new allCourtsController();
        test.startTest();
        con2.Screening_Stage__c = 'Attorney';
        update con2;
       cls.RequeryInfo();

        cls.saveLogin(); 
        String[] prog = cls.getPrograms();
  
        cls.programs = prog;
        cls.RequeryInfo();   
        string s2 = cls.getChooserender();
        PageReference pageRef = Page.allCourtsPage;
        pageRef.getParameters().put('selectedClient',con1.id); 
        cls.selectedClient = con1.id;
        cls.showPopup();
        cls.deliverAsPDF();
        cls.closePopup();
        cls.proxyObject.Closing_Date__c = date.today();
        cls.proxyObject.Catalog_End_Date__c = date.today().addDays(-1);
         cls.RequeryInfo(); 
        
        cls.sfAdmin = false;
        cls.proxyObject.Catalog_End_Date__c = date.today().addDays(+45);
        cls.RequeryInfo();   
  
        test.stopTest();
    }
}