@isTest(SeeAllData=true)
private class SearchOnMobile_UnitTest {
 static utilityIds utilIDs = new utilityIds();
    static UtilityTimeMethods ut = new UtilityTimeMethods();
    static string t_timeBeg;
    static boolean bolStartTimeRequired;
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
    static date ctdate,ctdate2; 
    
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
        case1.Name = '2014BG456011';
        case1.Indictment__c = '1235647894';
        case1.Borough__c = 'Bronx';
        insert case1; 
        caseid1 = case1.id;  

        Case2 = new Case_Information__c();
        case2.Client_Account__c = acc2.Id;
        case2.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case2.Name = '2014BJ456011';
        case2.Indictment__c = '3000000000';
        case2.Borough__c = 'Brooklyn';
        insert case2; 
        caseid2 = case2.id;  
        con1 = new Contact();
        con1.Court_Rep__c = UserInfo.getUserId();
        con1.RecordTypeId = cepClient;
        con1.Screening_Stage__c = 'Pending Attorney Info';
        con1.firstName = 'first';
        con1.Client_Status__c = 'Active';
        con1.lastName = 'last';   
        con1.Referral_Date__c = date.today().addDays(-30);
        con1.Current_Intake_Date__c = date.today().addDays(-30);
        con1.accountId = acc1.id;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Case__c = caseid1;
  //      con1.NYSID__c = '55555555Y';
   //     con1.Intake_Date__c = ddate - 30;    
        insert con1;
        pcid1 = con1.P_C_ID__c;
        
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


         Case_Relationship__c Rel = new Case_Relationship__c();
         Rel.Case_Type__c  = 'In-Program';
         Rel.Contact__c = con1.id;
         Rel.Docket__c = caseid1;
 //        Rel.Unique_Id__c = case2.id + ';' + sfid;
         insert Rel; 
         system.assert(rel != null);     


       } 
    
      static testMethod void testSearchCriteria(){
        createTestData();
        SearchOnMobileController sc = new SearchOnMobileController();
        test.startTest();
         List<SelectOption> so = sc.SearchItems;
         
         sc.searchValue = 'Docket';
         sc.docketValue = case1.Name;
         sc.selectClient();

         sc.searchValue = 'NYSID';
         sc.nysidValue = acc1.NYSID_Number__c;
         sc.selectClient();

         sc.searchValue = 'NAME';
         sc.fnameValue = con1.firstName;
         sc.lnameValue = con1.LastName;
         sc.selectClient();

         sc.searchValue = '';
         sc.selectClient();

   //     clsController.RequeryInfo();
        test.stopTest();
      }
}