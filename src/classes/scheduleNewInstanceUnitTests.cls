@isTest(SeeAllData=True)
private class scheduleNewInstanceUnitTests {

    ///////////////////////////////////////////
    // This test method covers scheduleNewInstance
    // Created 20110706 AAB / DCS
    ///////////////////////////////////////////
    
    static utilityIds utilIds = new utilityIds();
    static Course__c crsTest;
    static Class__c clTest;
    static Schedule__c scTest;
    static Contact conTest;
    static Enrollment__c enrTest;
    static Session__c seTest;
    static Event evt1;
    static Event evt2;
    
    static void establishCoreData(Integer intClassType) {
        
        system.debug('\n\n*** utilIds.cepIcdStaff: ' + utilIds.cepIcdStaff);
        
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
        crsTest.Category__c = 'Category';
        crsTest.Area__c = 'Area';
        crsTest.Serves_All_Programs__c = true;        
        insert crsTest;
        
        // Create Class
        clTest = new Class__c();
        clTest.Course__c = crsTest.Id;
        if(intClassType == 0) { clTest.RecordTypeId = utilIds.classSingle; }
        if(intClassType == 1) { clTest.RecordTypeId = utilIds.classFixed; }
        if(intClassType == 2) { clTest.RecordTypeId = utilIds.classOngoing; }
    
        insert clTest;
        
    }

    static testMethod void testController() {
        
        establishCoreData(0);
        
        test.startTest();
        
        ApexPages.CurrentPage().getParameters().put('id',clTest.Id);
        scheduleNewInstance clsSchedule = new scheduleNewInstance();
        
        test.stopTest();
        
    }
    
    static testMethod void testScheduleSingle() {
        
        establishCoreData(0);
        
        ApexPages.CurrentPage().getParameters().put('id',clTest.Id);
        scheduleNewInstance clsSchedule = new scheduleNewInstance();
        
        test.startTest();
        
        // Set UI variables - error handling
        clsSchedule.createNewSchedule();
        
        // Test End Time before Start Time
        clsSchedule.schNew = new Schedule__c();
        clsSchedule.schNew.UI_Start_Date__c = System.Today();
        clsSchedule.strTimeStart = '10:00';
        clsSchedule.strStartAMPM = 'PM';
        clsSchedule.strTimeEnd = '11:00';
        clsSchedule.strEndAMPM = 'AM';
        clsSchedule.schNew.Class__c = clsSchedule.idClass;
        clsSchedule.schNew.RecordTypeId = utilIds.scheduleSingle;
        
        clsSchedule.createNewSchedule();
        
        // Test Success
        clsSchedule.strStartAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        test.stopTest();
        
    }

    static testMethod void testScheduleFixed() {
        
        establishCoreData(1);
        
        ApexPages.CurrentPage().getParameters().put('id',clTest.Id);
        scheduleNewInstance clsSchedule = new scheduleNewInstance();
        
        test.startTest();
        
        // Set UI variables - error handling
        clsSchedule.createNewSchedule();
        
        clsSchedule.schNew = new Schedule__c();
        clsSchedule.schNew.UI_Start_Date__c = System.Today();
        clsSchedule.schNew.UI_End_Date__c = System.Today().addDays(30);
        clsSchedule.strTimeStart = '10:00';
        clsSchedule.strStartAMPM = 'AM';
        clsSchedule.strTimeEnd = '11:00';
        clsSchedule.strEndAMPM = 'AM';
        clsSchedule.schNew.Monday__c = false;
        clsSchedule.schNew.Tuesday__c = false;
        clsSchedule.schNew.Wednesday__c = false;
        clsSchedule.schNew.Thursday__c = false;
        clsSchedule.schNew.Friday__c = false;
        clsSchedule.schNew.Saturday__c = false;
        clsSchedule.schNew.Sunday__c = false;
        clsSchedule.schNew.Class__c = clsSchedule.idClass;
        clsSchedule.schNew.RecordTypeId = utilIds.scheduleFixed;
        clsSchedule.createNewSchedule();
        
        // Test Day Checks
        clsSchedule.schNew.Monday__c = true;
        clsSchedule.schNew.Tuesday__c = true;
        clsSchedule.schNew.Wednesday__c = true;
        clsSchedule.schNew.Thursday__c = true;
        clsSchedule.schNew.Friday__c = true;
        clsSchedule.schNew.Saturday__c = true;
        clsSchedule.schNew.Sunday__c = true;
        clsSchedule.createNewSchedule();
        
        // Test Time Checks
        clsSchedule.strTimeStartMonday = '11:00';
        clsSchedule.strTimeEndMonday = '10:00';
        clsSchedule.strStartMondayAMPM = 'AM';
        clsSchedule.strEndMondayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartMonday = '10:00';
        clsSchedule.strTimeEndMonday = '11:00';
        clsSchedule.strStartMondayAMPM = 'AM';
        clsSchedule.strEndMondayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartTuesday = '11:00';
        clsSchedule.strTimeEndTuesday = '10:00';
        clsSchedule.strStartTuesdayAMPM = 'AM';
        clsSchedule.strEndTuesdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartTuesday = '10:00';
        clsSchedule.strTimeEndTuesday = '11:00';
        clsSchedule.strStartTuesdayAMPM = 'AM';
        clsSchedule.strEndTuesdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartWednesday = '11:00';
        clsSchedule.strTimeEndWednesday = '10:00';
        clsSchedule.strStartWednesdayAMPM = 'AM';
        clsSchedule.strEndWednesdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartWednesday = '10:00';
        clsSchedule.strTimeEndWednesday = '11:00';
        clsSchedule.strStartWednesdayAMPM = 'AM';
        clsSchedule.strEndWednesdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartThursday = '11:00';
        clsSchedule.strTimeEndThursday = '10:00';
        clsSchedule.strStartThursdayAMPM = 'AM';
        clsSchedule.strEndThursdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartThursday = '10:00';
        clsSchedule.strTimeEndThursday = '11:00';
        clsSchedule.strStartThursdayAMPM = 'AM';
        clsSchedule.strEndThursdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartFriday = '11:00';
        clsSchedule.strTimeEndFriday = '10:00';
        clsSchedule.strStartFridayAMPM = 'AM';
        clsSchedule.strEndFridayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartFriday = '10:00';
        clsSchedule.strTimeEndFriday = '11:00';
        clsSchedule.strStartFridayAMPM = 'AM';
        clsSchedule.strEndFridayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartSaturday = '11:00';
        clsSchedule.strTimeEndSaturday = '10:00';
        clsSchedule.strStartSaturdayAMPM = 'AM';
        clsSchedule.strEndSaturdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartSaturday = '10:00';
        clsSchedule.strTimeEndSaturday = '11:00';
        clsSchedule.strStartSaturdayAMPM = 'AM';
        clsSchedule.strEndSaturdayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartSunday = '11:00';
        clsSchedule.strTimeEndSunday = '10:00';
        clsSchedule.strStartSundayAMPM = 'AM';
        clsSchedule.strEndSundayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        clsSchedule.strTimeStartSunday = '10:00';
        clsSchedule.strTimeEndSunday = '11:00';
        clsSchedule.strStartSundayAMPM = 'AM';
        clsSchedule.strEndSundayAMPM = 'AM';
        clsSchedule.createNewSchedule();
        
        test.stopTest();
        
    }
    
    static testMethod void testMiscActions() {
        
        establishCoreData(0);
        
        ApexPages.CurrentPage().getParameters().put('id',clTest.Id);
        scheduleNewInstance clsSchedule = new scheduleNewInstance();
        
        test.startTest();
        
        clsSchedule.cancelSchedule();
        
        test.stopTest();
        
    }
}