@isTest(SeeAllData=true)
private class SignPrintUnitTest {
  static Id accClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
   static utilityIds utilIDs = new utilityIds();
static Id eventRecordType =   Utility_ID__c.getValues('Case Coordination').RecordType_Id__c;

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
    static List<Event> listEvents = new List<Event>();
    static  string cepid1,cepid2,event1,event2;  
      static void createEventsTestData() {
        date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        datetime dtime = DateTime.parse(s);
 
        accCep1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        insert accCep1;

        accCep2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        insert accCep2;

        con1 = new Contact();
        con1.firstName = 'first1';
        con1.lastName = 'last1';
        con1.Current_Intake_Date__c = System.Today()- 5;
        con1.RecordTypeId = accClient;
        con1.accountId = accCep1.id;   
        con1.Reporting_Borough__c = 'Brooklyn'; 
        con1.Client_Status__c = 'Active';          
        insert con1;
        cepid1 = con1.id;

       accCep2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        insert accCep2;
        con2 = new Contact();
        con2.firstName = 'first3';
        con2.lastName = 'last13';
        con2.Current_Intake_Date__c = System.Today()- 5;
        con2.RecordTypeId = accClient;
        con2.accountId = accCep2.id;   
        con2.Reporting_Borough__c = 'Harlem';   
        con2.Client_Status__c = 'Active';          
        insert con2;
        cepid2 = con2.id;    
 
        List<Event> lstEvents = new List<Event>();
        Event evt = new Event();
        evt.Subject = 'Program Reporting';
        evt.ActivityDateTime = System.Now().addHours(-72);
        evt.ActivityDate = date.today().addDays(-3);
        evt.DurationInMinutes = 30;
        evt.verification_status__c = 'Not Verified';
        evt.WhoId = cepid1;
        evt.RecordTypeId = eventRecordType;
        insert evt;

        Event evt1 = new Event();
        evt1.Subject = 'Program Reporting';
        evt1.ActivityDateTime = System.Now().addHours(-48);
        evt1.ActivityDate = date.today().addDays(-2);
        evt1.DurationInMinutes = 10;
        evt1.verification_status__c = 'Attended';
        evt1.Verification_Date__c = date.today();
        evt1.Time_In__c = '10:00 AM';
        evt1.Time_Out__c = '10:30 AM';
        evt1.WhoId = cepid1;
        insert evt1;


        Event evt2 = new Event();
        evt2.Subject = 'Program Reporting';
        evt2.ActivityDateTime = System.Now().addHours(-72);
        evt2.ActivityDate = date.today().addDays(-3);
        evt2.DurationInMinutes = 30;
        evt2.verification_status__c = 'Attended';
        evt2.Verification_Date__c = date.today();
        evt2.Time_In__c = '10:00 AM';
        evt2.Time_Out__c = '10:30 AM';
        evt2.WhoId = cepid2;
        insert evt2;


        Event evt4 = new Event();
        evt4.Subject = 'Program Reporting';
        evt4.ActivityDateTime = System.Now().addHours(-24);
        evt4.ActivityDate = date.today().addDays(-1);
        evt4.DurationInMinutes = 10;
        evt4.verification_status__c = 'Attended';
        evt4.Verification_Date__c = date.today();
        evt4.WhoId = cepid2;
        evt4.RecordTypeId = eventRecordType;
       // lstEvents.add(evt);
        insert evt4;
 
   
        
        Event evt3 = new Event();
        evt3.Subject = 'Program Reporting';
       evt3.ActivityDateTime = System.Now().addHours(-2);
        evt3.ActivityDate = date.today();
        evt3.DurationInMinutes = 10;
        evt3.verification_status__c = 'Attended';
        evt3.Verification_Date__c = date.today();
        evt3.WhoId = cepid2;
        evt3.RecordTypeId = eventRecordType;
       // lstEvents.add(evt);
        insert evt3;

  
  
      } 
  
        static testMethod void testfindEvents() {      
	    createEventsTestData();
	    date dFrom = date.today().addDays(-5);
	    date dTo = date.today();
        string sFrom = dFrom.format() ;
        string sTo = dTo.format() ;
        PageReference pageRef = Page.signInPrint;
        pageRef.getParameters().put('passedFrom',sFrom);
        pageRef.getParameters().put('passedTo',sTo);           
        pageRef.getParameters().put('passBoro','Brooklyn');
        Test.setCurrentPageReference(pageRef);
        SignInPrintController sign = new SignInPrintController();
        test.startTest();
        date dt = sign.getTodayDate();
        sign.proxyobject.activitydate = date.today();
    //    sign.lstEventsShow = sign.findClientEvents();
        sign.getDayOfWeek();
      //  sign.dFrom = dFrom;
      //  sign.dTo = dTo;
        sign.proxyobject.Open_Date__c = date.today().addDays(-5);
        sign.proxyobject.Closing_Date__c  = date.today();

        sign.ReportData();
        
        test.stopTest();
      }   
}