@isTest
private class courseConflictUnitTests {
    
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
        
        User u = new User();
        u.FirstName = 'Unit';
        u.LastName = 'Tester';
        u.ProfileId = utilIDs.cepIcdStaff;
        //u.ProfileId = '00e60000000vR5g';
        u.Username = 'unittester@cases.org';
        u.Email = 'unittester@cases.org';
        u.Alias = 'UTCASES';
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
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
        scTest.RecordTypeId = utilIDs.scheduleSingle;
        insert scTest;
        
        // Create Session
        seTest = new Session__c();
        seTest.Assigned_To__c = u.Id;
        seTest.Schedule__c = scTest.Id;
        seTest.Session_Start__c = scTest.Start_Date__c;
        seTest.Session_End__c = scTest.End_Date__c;
        insert seTest;
        
        // Create Enrollment
        enrTest = new Enrollment__c();
        enrTest.Class__c = clTest.Id;
        enrTest.Client__c = conTest.Id;
        enrTest.Most_Recent_Enrollment__c = true;
        insert enrTest;
        
        // Create Event
        evt1 = new Event();
        evt1.RecordTypeId = utilIDs.courseCatalogClass;
        evt1.OwnerId = u.Id;
        evt1.WhoId = conTest.Id;
        evt1.ActivityDate = scTest.Start_Date__c.date();
        evt1.ActivityDateTime = scTest.Start_Date__c;
        evt1.StartDateTime = scTest.Start_Date__c;
        evt1.EndDateTime = scTest.End_Date__c;
        evt1.Subject = 'HSE Class';
        insert evt1;
        
    }

    static testMethod void testController() {
        
        test.startTest();
        
        establishCoreData();
        
        Class__c clCurrent = [SELECT Id FROM Class__c LIMIT 1];
        
        ApexPages.CurrentPage().getParameters().put('c',clCurrent.Id);
        courseConflict clsConflict = new courseConflict();
        
        clsConflict.clCurrent = clTest;
        
        clsConflict.getConflicts();
        
        // Create Conflict!
        Enrollment_Conflict__c enrCon = new Enrollment_Conflict__c();
        enrCon.Conflict_Session__c = seTest.Id;
        enrCon.Enrollment__c = enrTest.Id;
        enrCon.Conflicting_Appointment__c = evt1.Id;
        insert enrCon;
        
        clsConflict.getConflicts();
        
        
        test.stopTest();
        
    }
}