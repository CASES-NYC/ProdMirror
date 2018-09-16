@isTest
private class courseGradingUnitTests {

    /////////////////////////////////////////
    // Test Class for courseGrading
    // Created 20110705 AAB / DCS
    /////////////////////////////////////////
    
    static utilityIds utilIDs = new utilityIds();
    static Course__c crsTest;
    static Class__c clTest;
    static Schedule__c scTest;
    static Contact conTest;
    static Enrollment__c enrTest;
    static Session__c seTest;
    static Event evt1;
    static Event evt2;
    static Progress_Note__c prgNote;
    static Program_Plan__c prgPlan;
    static List<Id> lstContactIds = new List<Id>();
    
    static void establishCoreData() {
        
        // User u = [SELECT Id FROM User WHERE IsActive = true AND ProfileId = :utilIDs.cepIcdStaff];
        User u = new User();
        u.FirstName = 'Unit';
        u.LastName = 'Tester';
        u.ProfileId = utilIDs.cepIcdStaff;
        u.Username = 'unittester@cases.org';
        u.Email = 'unittester@cases.org';
        u.Alias = 'UTCASES';
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        Account acc = new Account(Name = 'Test', RecordTypeId = utilIds.accClient);
        insert acc;
        
        // Create Client
        conTest = new Contact();
        conTest.FirstName = 'Howdy';
        conTest.LastName = 'Doody';
        conTest.Client_Status__c = 'Active';
        conTest.AccountId = acc.id;
        conTest.RecordTypeId = utilIDs.conClient;
        insert conTest;
        
        // Create Course
        crsTest = new Course__c();
        crsTest.name = 'Test Course';
        crsTest.Category__c = 'Category';
        crsTest.Area__c = 'Area';
        crsTest.Serves_All_Programs__c = true;        
        insert crsTest;
        
        // Update Course
        crsTest.Name = 'Test Course Update';
        update crsTest;
        
        // Create Class
        clTest = new Class__c();
        clTest.Course__c = crsTest.Id;
    
        insert clTest;
        
        // Create Schedule
        scTest = new Schedule__c();
        scTest.Class__c = clTest.Id;
        scTest.Start_Date__c = System.Today();
        scTest.End_Date__c = System.Today();
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
        evt1.Catalog_End_Date__c = scTest.Start_Date__c.date();        
        evt1.ActivityDateTime = scTest.Start_Date__c;
        evt1.StartDateTime = scTest.Start_Date__c;
        evt1.EndDateTime = scTest.End_Date__c;
        evt1.Subject = 'HSE Class';
        evt1.Verification_Status__c = 'Attended';
        insert evt1;
        
        //create Program Plan
        prgPlan = new Program_Plan__c();
        prgPlan.Client_Name__c = conTest.Id;
        insert prgPlan;
        //Create Progress Note
        prgNote = new Progress_Note__c();
        // Progress Note A
        prgNote.Program_Plan__c = prgPlan.Id;
        prgNote.RecordTypeId = '012600000005MlhAAE';
        prgNote.Progress_Note__c = 'This is a test Progress Note';
        insert prgNote;        
        
        List<Course__c> lstCourses = new List<Course__c>();
        lstCourses.add(crsTest);
        
        lstContactIds.add(conTest.id);
        
        update lstCourses;
        
        /*courseMethods clsMethods = new courseMethods();
        clsMethods.updateClassAttributes(lstCourses);*/
        
    }
    
    static testMethod void testConstructors() {
        
        test.startTest();
        
        courseGrading clsGrading = new courseGrading();
        
        //clsGrading.getStudentList();      
        
        test.stopTest();
        
    }
    
    static testMethod void testActions() {
        
        establishCoreData();
        
        test.startTest();
        
        courseGrading clsGrading = new courseGrading();
        PageReference testPage = Page.courseGrading;
        test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('c',crsTest.Id);
        ApexPages.currentPage().getParameters().put('a',crsTest.Area__c);
        ApexPages.currentPage().getParameters().put('t',crsTest.Category__c);
        ApexPages.currentPage().getParameters().put('s',evt1.ActivityDate.format());
        ApexPages.currentPage().getParameters().put('e',evt1.Catalog_End_Date__c.format());
        clsGrading.initPage();
        
        // Test doNothind
        clsGrading.doNothing();
        
        // Test Class Search
        clsGrading.coSearch.Area__c = 'Area';
        clsGrading.coSearch.Category__c = 'Category';
        clsGrading.tskDummy.ActivityDate = date.today();
        clsGrading.tskDummy.Catalog_End_Date__c = date.today();

        
        //clsGrading.returnClasses();
        clsGrading.returnClassList();
        
        // Test Session Dropdown
        clsGrading.strSelectedClassId = clTest.Id;
        clsGrading.returnSessionList();
        
        // Test Session Return
        clsGrading.strSelectedSession = seTest.Id;
        clsGrading.returnSessionInfo();
        clsGrading.returnAttendees();
        
        //clsGrading.loadAttendeeDetails(lstContactIds);
        
        // Test Maps and GETers
        Map<Id, Date> mapcalculateClassWeek = clsGrading.calculateClassWeek();
        
        delete enrTest;
        
        
        test.stopTest();        
        
    }

}