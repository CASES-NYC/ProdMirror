@isTest
private class courseEnrollmentUnitTests {
    
    static utilityIds utilIDs = new utilityIds();
    static Course__c crsTest;
    static Class__c clTest;
    static Schedule__c scTest;
    static Contact conTest;
    static Enrollment__c enrTest;
    static Session__c seTest;
    static Event evt1;
    static Event evt2;
    
    static void establishCoreData() {
        
        User u = [SELECT Id FROM User WHERE IsActive = true AND ProfileId = :utilIDs.cepIcdStaff LIMIT 1];
        
        // Create Client
        conTest = new Contact();
        conTest.FirstName = 'Howdy';
        conTest.LastName = 'Doody';
        conTest.Client_Status__c = 'Active';
        insert conTest;
        
        // Create Course
        crsTest = new Course__c();
        crsTest.name = 'Test Course';
        crsTest.Serves_All_Programs__c = true;        
        insert crsTest;
        
        // Create Class
        clTest = new Class__c();
        clTest.Course__c = crsTest.Id;
        insert clTest;
        
        // Create Schedule
        scTest = new Schedule__c();
        scTest.Class__c = clTest.Id;
        scTest.Start_Date__c = System.Today().addDays(7);
        scTest.End_Date__c = System.Today().addDays(7);
        scTest.RecordTypeId = Schema.SObjectType.Schedule__c.getRecordTypeInfosByName().get('Single Schedule').getRecordTypeId();
        insert scTest;
        
    }
    
    static testMethod void testController() {
        
        test.startTest();
        
        establishCoreData();
        
        Class__c clCurrent = [SELECT Id FROM Class__c LIMIT 1];
        
        ApexPages.CurrentPage().getParameters().put('c',clCurrent.Id);
        courseEnrollment clsEnrollment = new courseEnrollment();
        
                
        
        test.stopTest();
        
    }
    
/*  static testMethod void testFixedController() {
        
        test.startTest();
        
        establishCoreData();
        
        Class__c clCurrent = [SELECT Id FROM Class__c WHERE RecordTypeId = :Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Fixed').getRecordTypeId() LIMIT 1];
        
        ApexPages.CurrentPage().getParameters().put('c',clCurrent.Id);
        courseEnrollment clsEnrollment = new courseEnrollment();
        
        test.stopTest();
        
    }
    
    static testMethod void testCEXController() {
        
        test.startTest();
        
        establishCoreData();
        
        Class__c clCurrent = [SELECT Id FROM Class__c WHERE CategoryRPT__c = 'Career Exploration Training' LIMIT 1];
        
        ApexPages.CurrentPage().getParameters().put('c',clCurrent.Id);
        courseEnrollment clsEnrollment = new courseEnrollment();
        
        test.stopTest();
        
    }
*/  
    static testMethod void testPageActions() {
        
        establishCoreData();
        
        test.startTest();
        
        Class__c clCurrent = [SELECT Id FROM Class__c WHERE RecordTypeId = :Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Fixed').getRecordTypeId() LIMIT 1];
        
        ApexPages.CurrentPage().getParameters().put('c',clTest.Id);
        courseEnrollment clsEnrollment = new courseEnrollment();
        clsEnrollment.strClassId = clTest.Id;
        
        clsEnrollment.init();
        
        // Test Getters
        List<courseEnrollment.clientsForDisplay> lstEnrollees = new List<courseEnrollment.clientsForDisplay>();
        
        clsEnrollment.intEnrollees = 0;
        lstEnrollees = clsEnrollment.getClients();
        
        clsEnrollment.intEnrollees = 1;
        lstEnrollees = clsEnrollment.getClients();
        
        clsEnrollment.intEnrollees = 2;
        lstEnrollees = clsEnrollment.getClients();
        
        clsEnrollment.intEnrollees = 3;
        lstEnrollees = clsEnrollment.getClients();
        
        clsEnrollment.intEnrollees = 4;
        lstEnrollees = clsEnrollment.getClients();
        
        clsEnrollment.intEnrollees = 5;
        lstEnrollees = clsEnrollment.getClients();
        
        List<selectOption> lstSearchOptions = new List<selectOption>();
        lstSearchOptions = clsEnrollment.getSearchOptions();
        
        List<selectOption> lstSessionStart = new List<selectOption>();
        lstSearchOptions = clsEnrollment.getSessionStart();
        
        List<selectOption> lstSessionEnd = new List<selectOption>();
        lstSearchOptions = clsEnrollment.getSessionEnd();
        
        // Here we go
        clsEnrollment.doNothing();
        clsEnrollment.printRoster();
        clsEnrollment.viewConflicts();
        clsEnrollment.createCeXPInterview();
        clsEnrollment.cancelAndReturn();
        

        
        // Enrollment
        clsEnrollment.lstEnrollees.clear();
        
        courseEnrollment.clientsForDisplay nClientForDisplay = new courseEnrollment.clientsForDisplay();
        nClientForDisplay.con = conTest;
        nClientForDisplay.chk = true;
        nClientForDisplay.bolEnrolled = false;
        
        clsEnrollment.lstEnrollees.add(nClientForDisplay);
        
        clsEnrollment.clCurrent = null;
        clsEnrollment.enrollClients();
        
        // Enroll again with conflicts
        
        evt1 = new Event();
        evt1.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Course Catalog Class').getRecordTypeId();  
        evt1.OwnerId = UserInfo.getUserId();
        evt1.WhoId = conTest.Id;
        evt1.ActivityDate = scTest.Start_Date__c.date();
        evt1.ActivityDateTime = scTest.Start_Date__c;
        evt1.StartDateTime = scTest.Start_Date__c;
        evt1.EndDateTime = scTest.End_Date__c;
        evt1.Subject = 'HSE Class';
        insert evt1;
        
        
        clsEnrollment.enrollClients();
        
        test.stopTest();
        
    }
}