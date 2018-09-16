@isTest(SeeAllData=true)
private class toDoPortal_Client_unitTests {
    static utilityIds utilIds = new utilityIds();
    static Portal_Filter__c searchCriteriaFilter = new Portal_Filter__c();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    static Event thisEvent = new Event();
 
    static void createTestData() {
               
        accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert accClient;
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2013TN456011';
        newCaseInfo.Borough__c = 'Bronx';
        insert newCaseInfo;        
        
        con = new Contact();
        con.firstName = 'Unit';
        con.lastName = 'Tester';
        con.Drug_test_frequency__c = 'Bi-Weekly';
        con.Referral_Date__c = system.today().addDays(-5);
        con.Eligible__c = 'Yes';
        con.Interview_Acceptance_Date__c = system.today().addDays(-3);
        con.Interview_Outcome__c = 'CEP Accepts';
        con.Intake_Approved_By__c = userInfo.getUserId();
        con.Intake_Date__c = System.Today();
        con.Intake_Case__c = newCaseInfo.id;
        con.RecordTypeId = utilIds.conClient;
        con.accountId = accClient.id;       
        
        insert con;
        

        thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
                thisEvent.Skip_Triggers__c = true;
      insert thisEvent;               
            
        Event thisEventDummy1 = new Event();
        thisEventDummy1.RecordTypeId = utilIds.educationExternal;
        thisEventDummy1.Subject = 'College Participation';
        thisEventDummy1.whoId = con.Id;
        thisEventDummy1.DurationInMinutes = 60;
        thisEventDummy1.ActivityDateTime = System.now();
        thisEventDummy1.Verification_Status__c  =  'Not Verified';
        thisEventDummy1.Verification_Due_Date__c  = System.Today().addDays(4);
        thisEventDummy1.ActivityDate = Date.today();
  
        insert thisEventDummy1;

        searchCriteriaFilter = new Portal_Filter__c();
        searchCriteriaFilter.Activity_Status__c = 'Outstanding';
        searchCriteriaFilter.Client__c =  con.Id;
        insert searchCriteriaFilter;
    }
     
    static testMethod void test1(){
        createTestData();
        Test.startTest();
        todoPortal_Client portalClientTest = new todoPortal_Client();
        portalClientTest.setFilter(searchCriteriaFilter);
        portalClientTest.settoDoObject(searchCriteriaFilter);
    
        portalClientTest.getEventCount();
        portalClientTest.getFilter();
        portalClientTest.getTaskCount();
        portalClientTest.gettoDoItems();

        String[] toDoSelections = new List<String>();
        for (RecordType rt : [Select Id from RecordType]) {
            toDoSelections.add(rt.Id);
        }
        portalClientTest.settoDoSelection(toDoSelections);          

        portalClientTest.gettoDoSelection();
        
        portalClientTest.getToDoTasksTab();
        portalClientTest.getUnverifiedEvents();
        
        searchCriteriaFilter.Activity_Status__c = 'Completed';
        
        portalClientTest.getToDoTasksTab();
        portalClientTest.getUnverifiedEvents();
        
        
        portalClientTest.doNothing();
        portalClientTest.doNothing2();

        
        Test.stopTest();        
    }
     static testMethod void test2(){
        createTestData();
        Test.startTest();
        todoPortal_Client portalClientTest = new todoPortal_Client();
        List<SelectOption> v1 = portalClientTest.getPLValues();
        List<SelectOption> v2 = portalClientTest.getPLValuesFuture();
        portalClientTest.eventid = thisEvent.id;
        portalClientTest.fieldValue = 'Attended';
        portalClientTest.saveRecord();
        
        Test.stopTest();        
    }
 
}