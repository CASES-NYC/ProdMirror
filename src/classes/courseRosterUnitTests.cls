@isTest
private class courseRosterUnitTests {

    static utilityIds utilIds = new utilityIds();
    static Course__c crsTest;
    static Class__c clTest;
    static Schedule__c scTest;
    static Contact conTest;
    static Enrollment__c enrTest;
    static Session__c seTest;
    static Event evt1;
    static Event evt2;
    
    static void establishCoreData() {
        
        User u = [SELECT Id FROM User WHERE IsActive = true AND ProfileId = :utilIds.cepIcdStaff LIMIT 1];
        
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
        scTest.RecordTypeId = utilIds.scheduleSingle;
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
        evt1.RecordTypeId = utilIds.courseCatalogClass;
        evt1.OwnerId = u.Id;
        evt1.WhoId = conTest.Id;
        evt1.WhatId = seTest.Id;
        evt1.ActivityDate = scTest.Start_Date__c.date();
        evt1.ActivityDateTime = scTest.Start_Date__c;
        evt1.StartDateTime = scTest.Start_Date__c;
        evt1.EndDateTime = scTest.End_Date__c;
        evt1.Subject = 'HSE Class';
        insert evt1;
        
    }


    static testMethod void testRoster() {
        
        test.startTest();
        
        establishCoreData();
        
        ApexPages.CurrentPage().getParameters().put('c',clTest.Id);
        ApexPages.CurrentPage().getParameters().put('s',seTest.Id);
        
        courseRoster clsRoster = new courseRoster();
        
        clsRoster.getRoster();
        
        test.stopTest();
    }

    

}