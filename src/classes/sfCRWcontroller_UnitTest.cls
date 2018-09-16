@isTest (seeAllData=true)
private class sfCRWcontroller_UnitTest {
  static Id accClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
   static utilityIds utilIDs = new utilityIds();
    static UtilityTimeMethods ut = new UtilityTimeMethods();
    static string t_timeBeg;
    static boolean bolStartTimeRequired;
    static Program_Plan__c newProgramPlan = new Program_Plan__c();
    static User userCaseCoordinator;
    static Id eventId = null;
    static Account accCep1 = new Account();
    static Account accCep2 = new Account();
    static Contact con1 = new Contact();
    static Contact con2 = new Contact();    
    static Contact con3 = new Contact();    
    static List<Event> listEvents = new List<Event>();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    static Case_Information__c newCaseInfo1 =  new Case_Information__c();
    static SF_CRW__c crwMain = new SF_CRW__c(); 
    static SF_CRW__c crwMain1 = new SF_CRW__c(); 
    static SF_CRW_notes__c crwNotes = new SF_CRW_notes__c();
    static Administrative_Actions__c aa =  new Administrative_Actions__c();    
   static Administrative_Actions__c aa1 =  new Administrative_Actions__c();    

   static Event evt1 = new Event();    
   static Event evt2 = new Event();    

    static  string sfid,sfid2,cepid2,event1,event2,repid,cname,pcid,repid1,actionid1,actionid2;
    static date ctdate; 

    static void createEventsTestData() {
        date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        datetime dtime = DateTime.parse(s);
 
        accCep1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        accCEp1.NYSID_Number__c = '11112222A';
        insert accCep1;

        accCep2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        accCEp2.NYSID_Number__c = '12548725W';
        insert accCep2;
 
 
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accCep1.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2014BG456011';
        newCaseInfo1.Indictment__c = '1235647894';
        newCaseInfo.Borough__c = 'Bronx';
        insert newCaseInfo;   

        newCaseInfo1 = new Case_Information__c();
        newCaseInfo1.Client_Account__c = accCep1.Id;
        newCaseInfo1.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo1.Name = '2015MM456011';
        newCaseInfo1.Indictment__c = '1235647894';
        newCaseInfo1.Borough__c = 'Bronx';
                                         
        insert newCaseInfo1;  

        con1 = new Contact();
        con1.firstName = 'first';
        con1.lastName = 'last';   
        con1.Referral_Date__c = system.today()- 180; 
        con1.Current_Intake_Date__c = ddate - 180;
        con1.RecordTypeId = utilIds.conClient;
        con1.accountId = accCep1.id;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Case__c = newCaseInfo.id;
        con1.Intake_Approved_By__c = userInfo.getUserId();  
        con1.Interview_Outcome__c = 'CEP Accepts';
        con1.Intake_Date__c = ddate - 180;    
           
        insert con1;
        sfid = con1.id;
        pcid = con1.P_C_ID__c;
        cname = con1.FirstName + ' ' + con1.LastName;
        
        con2 = new Contact();
        con2.firstName = 'first2';
        con2.lastName = 'last2';   
        con2.Referral_Date__c = system.today()- 80; 
        con2.Current_Intake_Date__c = ddate - 80;
        con2.RecordTypeId = utilIds.conClient;
        con2.accountId = accCep2.id;   
        con2.Reporting_Borough__c = 'Brooklyn';   
        con2.Intake_Case__c = newCaseInfo1.id;
        con2.Intake_Approved_By__c = userInfo.getUserId();  
        con2.Interview_Outcome__c = 'CEP Accepts';
        con2.Intake_Date__c = ddate - 80;   
        con2.Current_Exit_Date__c = System.Today();
        sfid2 = con2.id; 
   
   
        Administrative_Actions__c aaExit = new Administrative_Actions__c();
        aaExit.Client__c = con1.id;
        aaExit.RecordTypeId = utilIds.aaExitNotificationLocked;
        aaExit.Action_Date__c = System.Today();
        aaExit.Exit_Type__c = '(S) Successful Exit/ Graduation';
        aaExit.Exit_Reason__c = 'Successfully completed program, without modification';
        
        insert aaExit;
        actionid2 = aaExit.id;
     
       accCep2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        insert accCep2;
        con2 = new Contact();
        con2.firstName = 'first2';
        con2.lastName = 'last2';   
        con2.Referral_Date__c = system.today()- 80; 
        con2.Current_Intake_Date__c = ddate - 80;
        con2.RecordTypeId = utilIds.conClient;
        con2.accountId = accCep2.id;   
        con2.Reporting_Borough__c = 'Brooklyn';   
        con2.Intake_Case__c = newCaseInfo1.id;
        con2.Intake_Approved_By__c = userInfo.getUserId();  
        con2.Interview_Outcome__c = 'CEP Accepts';
        con2.Intake_Date__c = ddate - 80;
        con2.Current_Exit_Date__c = System.Today() - 1;
        insert con2;
   //     sfid1 = con2.id;
   
        aaExit = new Administrative_Actions__c();
        aaExit.Client__c = con2.id;
        aaExit.RecordTypeId = utilIds.aaExitNotification;
        aaExit.Action_Date__c = System.Today() - 1;
        aaExit.Exit_Type__c = '(U) Unsuccessful Exit/ Discharge';
        aaExit.Exit_Reason__c = 'Never reported for orientation';
        insert aaExit;     
        actionid2 = aaExit.id;
             
        s = ddate.format() + ' 10:00 AM';
        dtime = DateTime.parse(s);        
  //      List<Event> lstEvents = new List<Event>();
        Event evt = new Event();
        evt.Subject = 'Court Report';
        ddate =  date.today() - 5;
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 30;
        evt.WhoId = sfid;
        evt.Report_Type__c = 'Progress';
        insert(evt);
        event1 = evt.Id;
  
        ctdate = evt.ActivityDate;
        

        crwMain.contact__c = sfid;
        crwMain.actionid__c = event1;
        crwMain.Document__c = 'Report';
        crwMain.ReportType__c = 'Progress';
        crwMain.CourtDate__c = evt.ActivityDate;
        crwMain.repStage__c = 'to Do';
        crwMain.ClientName__c = cname;
        insert crwMain;
        repid = crwMain.id;
        
   
        crwNotes = new SF_CRW_notes__c();
        crwNotes.luReports__c = repid;
        crwnotes.Question__c = 'question 1';
        crwNotes.Respond__c = 'rep 1';
        insert crwNotes;
    /*    
        ddate = date.today() +3;
        s = ddate.format() + ' 08:00 AM';
        dtime = DateTime.parse(s);
        evt1 = new Event();
        evt1.Subject = 'Court Report';
        evt1.Report_Type__c = 'Progress';        
        evt1.ActivityDateTime = dtime;
        evt1.ActivityDate = ddate;
        evt1.DurationInMinutes = 30;
        evt1.WhoId = sfid;
        insert evt1;
*/
  
    //    crwMain1.contact__c = con2.id;
    //    crwMain1.actionid__c = actionid2;
    //    crwMain1.Document__c = 'Letter';
    ///    crwMain1.ReportType__c = 'Discharge';
    //    crwMain1.CourtDate__c = evt.activitydate;
    //    crwMain1.repStage__c = 'Drafting';
    //    crwMain1.ClientName__c = cname;
    //    insert crwMain1;
     //   repid1 = crwMain1.id;
        
 
/*   
        ddate =  date.today().addDays(-1);
        s = ddate.format() + ' 08:00 AM';
        dtime = DateTime.parse(s);
        evt1 = new Event();
        evt1.Subject = 'Court Report';
        evt1.ActivityDateTime = dtime;
        evt1.ActivityDate = ddate;
        evt1.Report_Type__c = 'Progress';
        evt1.DurationInMinutes = 15;
        evt1.verification_status__c = 'Attended';
        evt1.WhoId = con1.id;
    //    lstEvents.add(evt);
        insert evt1;
   //**************
  
        ddate =  date.today().addDays(-3);
        s = ddate.format() + ' 12:00 PM';
        dtime = DateTime.parse(s);
        evt2 = new Event();
        evt2.Subject = 'Court Report';
        evt2.ActivityDateTime = dtime;
        evt2.Report_Type__c = 'Progress';
        evt2.ActivityDate = ddate;
        evt2.DurationInMinutes = 10;
        evt2.WhoId = con2.id;
        insert evt2;
        
      //  lstEvents.add(evt);

        evt = new Event();
        evt.Subject = 'Court Report';
        ddate =  date.today();
        s = ddate.format() + ' 01:00 PM';
        dtime = DateTime.parse(s);
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = sfid;
  //      lstEvents.add(evt);
             insert evt;
             
        evt = new Event();
        evt.Subject = 'Court Report';
        ddate =  date.today() + 4;
        s = ddate.format() + ' 02:00 PM';
        dtime = DateTime.parse(s);
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = con2.id;
         insert evt;
 
  //      lstEvents.add(evt);

        evt = new Event();
        evt.Subject = 'Court Report';
        ddate =  date.today() - 2;
        s = ddate.format() + ' 03:00 PM';
        dtime = DateTime.parse(s);
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = sfid;
        insert evt;
    //    lstEvents.add(evt);
   // insert lstEvents;
     */    
      } 
 
   static testMethod void test1(){
        createEventsTestData();
        sfCRWcontroller crw = new sfCRWcontroller();
        test.startTest();
        crw.clientPassed = sfid;
        string client = crw.clientPassed;
        test.stopTest(); 
     }     

   static testMethod void insertNewrecords(){
        createEventsTestData();
        sfCRWcontroller crw = new sfCRWcontroller();
        test.startTest();
        PageReference pg = crw.insertCRW();
        crw.reportpassed = repid;
        crw.clientPassed = sfid;        
        crw.createReportNarrative();
        test.stopTest(); 
     }     
/*
  static testMethod void showClient(){
        createEventsTestData();
        sfCRWcontroller crw = new sfCRWcontroller();
        test.startTest();
        crw.clientPassed = sfid;
        crw.ShowClientMainInfo();
        crw.RequeryInfo();
        test.stopTest(); 
     }  
      
      static testMethod void createNarrative(){
        createEventsTestData();
        sfCRWcontroller crw = new sfCRWcontroller();
        test.startTest();
        crw.clientPassed = sfid;
        crw.reportpassed = repid;
        crw.createReportNarrative();
        crw.clientPassed = sfid2;
        crw.createReportNarrative();
        test.stoptest();
       }
  */     
      static testMethod void testSearh1(){
 
        sfCRWcontroller crw = new sfCRWcontroller();
        test.startTest();
        crw.searchOption = 'CEP ID'; 
        crw.clientSearch = 'CEP_' + pcid; 
        crw.searchclient();
        test.stoptest();
       }
      static testMethod void searchItems(){
       createEventsTestData();          
         sfCRWcontroller crw = new sfCRWcontroller();
         test.startTest();
         List<SelectOption> lstItems = crw.getSearchItems();
         List<SelectOption> lstUsers = crw.getCRWUsers();
         List<SelectOption> lstBoro = crw.getBoro();
         crw.userpassed = userInfo.getLastName();
         crw.reportid = repid;
         crw.saveAssign();
         crw.doNothing();
        test.stoptest(); }    
        
      static testMethod void testShowClientMainInfo(){
       createEventsTestData();          
         sfCRWcontroller crw = new sfCRWcontroller();
         test.startTest();
         crw.userpassed = userInfo.getLastName();
         crw.clientPassed = sfid;
         crw.ShowClientMainInfo();
         crw.checkDateInput();
         test.stoptest(); }  
         
 }