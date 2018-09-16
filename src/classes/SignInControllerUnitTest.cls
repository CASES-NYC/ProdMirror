@isTest (seeAllData=true)
private class SignInControllerUnitTest { 
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
    static List<Event> listEvents = new List<Event>();
    static  string cepid1,cepid2,event1,event2;  
      static void createEventsTestData() {
        date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        datetime dtime = DateTime.parse(s);
 
        accCep1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        insert accCep1;
        con1 = new Contact();
        con1.firstName = 'first1';
        con1.lastName = 'last1';
        con1.Current_Intake_Date__c = System.Today()- 5;
        con1.RecordTypeId = accClient;
        con1.accountId = accCep1.id;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        insert con1;
        cepid1 = con1.id;

       accCep2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        insert accCep2;
        con2 = new Contact();
        con2.firstName = 'first1';
        con2.lastName = 'last1';
        con2.Current_Intake_Date__c = System.Today()- 5;
        con2.RecordTypeId = accClient;
        con2.accountId = accCep1.id;   
        con2.Reporting_Borough__c = 'Harlem';   
        insert con2;
        cepid2 = con2.id;    
        
    //    s = ddate.format() + ' 10:00 AM';
        List<Event> lstEvents = new List<Event>();
        Event evt = new Event();
        evt.Subject = 'Program Reporting';
        ddate =  date.today();
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 30;
        evt.verification_status__c = 'Not Verified';
        evt.WhoId = cepid1;
        insert(evt);
        event1 = evt.Id;
        
        lstEvents = new List<Event>();
        evt = new Event();
        evt.Subject = 'Program Reporting';
        ddate =  date.today();
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 30;
        evt.verification_status__c = 'Not Verified';
        evt.WhoId = cepid2;
        lstEvents.add(evt);

        ddate =  date.today().addDays(-1);
   //     s = ddate.format() + ' 08:00 AM';
   //     dtime = DateTime.parse(s);
        dtime= System.Now().addHours(-1);
        evt = new Event();
        evt.Subject = 'Program Reporting';
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 15;
        evt.verification_status__c = 'Attended';
        evt.WhoId = cepid2;
        lstEvents.add(evt);
 
        ddate =  date.today().addDays(-2);
     //  s = ddate.format() + ' 12:00 PM';
    //    dtime = DateTime.parse(s);
        dtime= System.Now().addHours(-2);    
        evt = new Event();
        evt.Subject = 'Program Reporting';
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.verification_status__c = 'Attended';
        evt.WhoId = cepid2;
        lstEvents.add(evt);
 
        evt = new Event();
        evt.Subject = 'Drug Test';
        ddate =  date.today();
  //      s = ddate.format() + ' 01:00 PM';
       // dtime = DateTime.parse(s);
        dtime= System.Now();       
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = cepid1;
        lstEvents.add(evt);
        
        evt = new Event();
        evt.Subject = 'Anything Else';
        ddate =  date.today();
  //      s = ddate.format() + ' 02:00 PM';
     //   dtime = DateTime.parse(s);
        dtime= System.Now();     
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = cepid2;
        lstEvents.add(evt);

        evt = new Event();
        evt.Subject = 'Basketball';
        ddate =  date.today();
 //       s = ddate.format() + ' 03:00 PM';
//        dtime = DateTime.parse(s);
        dtime= System.Now();     
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = cepid1;
        lstEvents.add(evt);
        insert lstEvents;

        Task ts = new Task();
        ts.ActivityDate = date.today();
  //      ts.ActivityDateTime = dtime;
        ts.Status = 'Not Started';
        ts.subject = 'Next Drug Test';
        ts.WhoId = cepid1;     
        insert ts;      
   //     listEvents = lstEvents;
  
      } 
  
        static testMethod void testfindEvents()
      {         
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();
        sign.proxyobject.activitydate = date.today();
        sign.lstEventsShow = sign.findClientEvents();
         sign.getDayOfWeek();
        test.stopTest();
      }
       
      static testMethod void testBuildTimeList()
      {
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();
        date ddate =  date.today();
        string s = ddate.format() + ' 01:00 PM';
        datetime dtime = DateTime.parse(s);           
  
        sign.proxyobject.activitydate = ddate;
        t_timeBeg = '11:55 AM';
        sign.BuildTimeList(t_timeBeg, ddate, 'Time In');
        t_timeBeg = '09:00 AM';
        bolStartTimeRequired = true;
        sign.BuildTimeList(t_timeBeg, ddate, 'Time In');
        t_timeBeg = '05:00 PM';
          test.stopTest();
     }

     static testMethod void test2(){
        createEventsTestData();
        SignInController sign = new SignInController();
        sign.contactselected = cepid1;
        sign.selectedBoro = 'Harlem';
        test.startTest();
        sign.findClientEvents(); 
        sign.proxyobject.activitydate = date.today() - 1;
        sign.AddEvent();
        test.stopTest(); 
     }
     
   static testMethod void test2_1(){
        createEventsTestData();
        SignInController sign = new SignInController();
        sign.contactselected = cepid1;
        sign.selectedBoro = 'Harlem';
        test.startTest();
           sign.eventId = event1;
        sign.fieldName = 'Time In';
        sign.fieldValue = '12:00 AM';
        sign.saveRecord();
        test.stopTest(); 
     }     
   static testMethod void testSave2(){
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();   
        sign.eventId = event1;             
        sign.fieldName = 'Time Out';
        sign.fieldValue = '12:30 AM';
        sign.saveRecord();
        test.stopTest(); 
       }
    static testMethod void testSave3(){
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();
        sign.eventId = event1;
        sign.fieldName = 'Attendance';
        sign.fieldValue = 'Attended';
        date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        sign.fieldDateTime = DateTime.parse(s);
        sign.fieldDuration = 60;
        sign.saveRecord();
         test.stopTest(); 
     }      

   static testMethod void testSave3_1(){
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();
        sign.eventId = event1;
        sign.fieldName = 'Attendance';
        sign.fieldValue = 'Excused';        
         date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        sign.fieldDateTime = DateTime.parse(s);
        sign.fieldDuration = 60;
        sign.saveRecord();
         test.stopTest(); 
     }      

     
   static testMethod void testSave4(){
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();
        sign.eventId = event1;
        sign.fieldName = 'Attendance';
        date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        sign.fieldDateTime = DateTime.parse(s);
        sign.fieldDuration = 60;
         sign.fieldValue = 'Late';        
        sign.saveRecord();
       test.stopTest(); 
     }           
       static testMethod void testAttItems(){
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();
 //     List<SelectOption> testOpt = new get(sign.attendanceItems);
       integer i =  sign.attendanceItems.Size();
        test.stopTest();         
       }     
       /*
       static testMethod void testBoroItems(){
        createEventsTestData();
        SignInController sign = new SignInController();
        test.startTest();
        List<SelectOption> sB = sign.getBoro();
        test.stopTest();         
       }     
*/
}