@isTest (SeeAllData=true)
private class DTC_ProgramReportUnitTest{
    static Contact contactTest = new Contact();
    static UtilityIDs uid = new  UtilityIDs();
    static Id contId; 
    static string DCT_client = uid.conDTC;
    static ID CaseCoordination = uid.caseCoordination;
    static void createTestData() {
        contactTest = new Contact();
        contactTest.recordtypeid = DCT_client;
        contactTest = new Contact();
        contactTest.lastName = 'Lasttest';
        contactTest.firstName = 'firsttest';
        contactTest.current_intake_date__c = date.today() - 1;
        insert contactTest;     
        
        List<Event> lstEvents = new List<Event>();
        Event evt = new Event();
        evt.recordtypeid = CaseCoordination;
        evt.verification_status__c = 'Not Verified';
        evt.ActivityDateTime = datetime.now();
        evt.ActivityDate = date.today();
        evt.DurationInMinutes = 60;
        evt.WhoId = contactTest.id;
        evt.subject = 'Curfew';
        lstEvents.add(evt);     
        
        evt = new Event();
        evt.recordtypeid = CaseCoordination;
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
        DTC_ProgramRepController dtc = new DTC_ProgramRepController();
        test.startTest();  
        dtc.cmNames = 's';
        dtc.proxyObject.activitydate = date.today();
        dtc.buildContacts();
//        dtc.grpStatus = true;
  //      dtc.createGroupAtt();
        test.stopTest();}
  
        static testMethod void testMisc(){
          DTC_ProgramRepController dtc = new DTC_ProgramRepController();
           test.starttest();
           dtc.proxyObject.activitydate = date.today();
           dtc.selectedDate = date.today();
           dtc.buildContacts();
           string dow = dtc.getDayOfWeek();
           string dow1 = dtc.getDateDow();
           dtc.getStatusItems();
           dtc.getCmItems();
           dtc.getGroupsItems();
           dtc.doNothing();
        test.stopTest();}
}