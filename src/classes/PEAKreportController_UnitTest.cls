@isTest(SeeAllData=true)
private class PEAKreportController_UnitTest {
	   static utilityIds utilIDs = new utilityIds();
	static Id accClient = Utility_ID__c.getValues('Client').RecordType_Id__c;
  static string bkClient = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BK PEAK Client').getRecordTypeId();
  static string bxClient = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BX PEAK Client').getRecordTypeId();
 
 // static Id bkClient = Utility_ID__c.getValues('BK PEAK Clien').RecordType_Id__c;
 // static Id bxClient = Utility_ID__c.getValues('BX PEAK Clientt').RecordType_Id__c;
    static Address_Information__c adinfo1 = new Address_Information__c();
    static Id eventId = null;
    static Account accPEAK1 = new Account();
    static Account accPEAK2 = new Account();
    static Contact con1 = new Contact();
    static Contact con2 = new Contact();    
    static List<Event> listEvents = new List<Event>();
    static  string PEAKid1,PEAKid2,event1,event2,dateFrom,dateTo;  

   static void createEventsTestData() {
        date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        datetime dtime = DateTime.parse(s);
 
        accPEAK1 = new Account(Name='test1', DOB__c = date.today().addDays(-4000),RecordTypeId = accClient);
        insert accPEAK1;
        con1 = new Contact();
        con1.firstName = 'first1';
        con1.lastName = 'last1';
        con1.Current_Intake_Date__c = System.Today()- 5;
        con1.RecordTypeId = bkClient;
        con1.accountId = accPEAK1.id;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        insert con1;
        PEAKid1 = con1.id;

        accPEAK2 = new Account(Name='test2', RecordTypeId = accClient);
        insert accPEAK2;
        con2 = new Contact();
        con2.firstName = 'first2';
        con2.lastName = 'last2';
        con2.Current_Intake_Date__c = System.Today()- 10;
        con2.RecordTypeId = BKclient;
        con2.accountId = accPEAK1.id;   
        con2.Reporting_Borough__c = 'Harlem';   
        con2.intake_date__c = System.Today()- 10;
        insert con2;
        PEAKid2 = con2.id;    
        
    //    s = ddate.format() + ' 10:00 AM';
        List<Event> lstEvents = new List<Event>();
        Event evt = new Event();
        evt.Subject = 'Program Reporting';
        ddate =  date.today();
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 30;
        evt.verification_status__c = 'Not Verified';
        evt.WhoId = PEAKid1;
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
        evt.WhoId = PEAKid2;
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
        evt.WhoId = PEAKid2;
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
        evt.WhoId = PEAKid2;
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
        evt.WhoId = PEAKid1;
        lstEvents.add(evt);
        
        evt = new Event();
        evt.Subject = 'Math';
        ddate =  date.today();
  //      s = ddate.format() + ' 02:00 PM';
     //   dtime = DateTime.parse(s);
        dtime= System.Now();     
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = PEAKid2;
        lstEvents.add(evt);

        evt = new Event();
        evt.Subject = 'Participation';
        ddate =  date.today() - 1;
  //      s = ddate.format() + ' 02:00 PM';
     //   dtime = DateTime.parse(s);
        dtime= System.Now();     
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.verification_status__c = 'Attended';        
        evt.WhoId = PEAKid2;
        lstEvents.add(evt);


        evt = new Event();
        evt.Subject = 'Art';
        ddate =  date.today();
 //       s = ddate.format() + ' 03:00 PM';
//        dtime = DateTime.parse(s);
        dtime= System.Now();     
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 10;
        evt.WhoId = PEAKid1;
        lstEvents.add(evt); 
        insert lstEvents;
        
        adinfo1 = new Address_Information__c(Client__c = PEAKid2, Address_Type__c = 'Primary', 
            Street__c = 'TEST', Contact_Person__c = 'TEST', Move_In_Date__c = date.today(), 
        Home_Phone__c = '12345', city__c = 'Brooklyn',Apt_No__c = '6B');
            insert adinfo1;
        
          dateFrom = date.today().format();
        dateTo = (date.today() + 20).format();  
      } 
    static testMethod void testSelectClients()
      {         
        createEventsTestData();
        PEAKreportController peak = new PEAKreportController();
        test.startTest();
        peak.proxyobject.activitydate = date.today() - 10;
        peak.proxyobject.Verification_Date__c = date.today();
        peak.proxyobject.catalog_end_date__c = date.today();
        peak.monthValue = '09';
        peak.yearValue = '2017';
        peak.changeDates();
        List<SelectOption> months = peak.monthItems;
        List<SelectOption> year = peak.yearItems;
       List<SelectOption> boro = peak.boroItems;
        peak.selectClients();	
        peak.selectedclient = PEAKid2;   
        peak.showClientInfo();
        peak.saveLogin();
        peak.saveInfo();
        test.stopTest();
   
      }
}