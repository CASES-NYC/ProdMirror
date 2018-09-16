@isTest (SeeAllData=true)
private class ChoicesComplTrackingUnitTest {
    static Id curFewId_Internal = Utility_ID__c.getValues('Case Coordination').RecordType_Id__c;
    static Id afterShcoolExternalId = Utility_ID__c.getValues('Case Coordination External').RecordType_Id__c;
    static Case_Information__c caseTest = new Case_Information__c();
    static Contact contactTest = new Contact();
    static Detained_Dates__c detDates = new Detained_Dates__c();
    static UtilityIDs uid = new  UtilityIDs();
    static Id contId; 
    static date selDate;
    Static string choiceClient = uid.conBXChoices;
    static void createTestData() {
        contactTest = new Contact();
        contactTest.recordtypeid = choiceClient;
        contactTest = new Contact();
        contactTest.lastName = 'Lasttest';
        contactTest.firstName = 'firsttest';
        contactTest.current_intake_date__c = date.today() - 1;
   //     contactTest.Current_Exit_date__c = date.today() + 1;
        insert contactTest;     
        contId = contactTest.id;
        detDates = new Detained_Dates__c();
        detDates.Detained_date__c = date.today();
        detDates.date_Released__c = date.today() + 5;   
        detDates.Contact_Detained_Dates_Lookup__c = contactTest.id; 
        insert detDates;    
        
        List<Event> lstEvents = new List<Event>();
        Event evt = new Event();
        evt.recordtypeid = curFewId_Internal;
        evt.verification_status__c = 'Not Verified';
        evt.ActivityDateTime = datetime.now();
        evt.ActivityDate = date.today();
        evt.DurationInMinutes = 60;
        evt.WhoId = contactTest.id;
        evt.subject = 'Curfew';
        lstEvents.add(evt);     
        
        selDate = evt.ActivityDate;
        
        evt = new Event();
        evt.recordtypeid = curFewId_Internal;
        evt.verification_status__c = 'Not Verified';
        evt.ActivityDateTime = datetime.now();
        evt.ActivityDate = date.today();
        evt.DurationInMinutes = 60;
        evt.WhoId = contactTest.id;
        evt.subject = 'Program Reporting';
        lstEvents.add(evt);     
        insert lstEvents;
         }
     
        static testMethod void testClassInit() {
        ChoicesComplTrackingController tc = new ChoicesComplTrackingController();
        test.startTest();  
        tc.cmNames = 's';
        tc.proxyObject.activitydate = date.today();
        tc.lst2track = tc.getContacts();
        test.stopTest();}
  
        static testMethod void testMisc(){
          ChoicesComplTrackingController tc = new ChoicesComplTrackingController();
           test.starttest();
           tc.proxyObject.activitydate = date.today();
           tc.selectedDate = date.today();
           tc.lst2track = tc.getContacts();
           string dow = tc.getDayOfWeek();
           string dow1 = tc.getDateDow();
           tc.getStatusItems();
           tc.getCmItems();
           tc.doNothing();
        test.stopTest();}

       static testMethod void testMisc1(){
       	createTestData();
          ChoicesComplTrackingController tc = new ChoicesComplTrackingController();
           test.starttest();
           tc.contid = contid;
           tc.selectedDate = selDate;
           tc.createApp();
           test.stopTest();}
 }