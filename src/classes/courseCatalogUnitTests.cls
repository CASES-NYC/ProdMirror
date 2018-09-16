@isTest
private class courseCatalogUnitTests {
    
    ///////////////////////////////////////////
    // This test class covers the Course Catalog functionality
    // Created by AAB / DCS 20110413
    ///////////////////////////////////////////
    
    static testMethod void testController() {
        
        Course__c crsTest = new Course__c();
        crsTest.name = 'test';
        crsTest.Serves_All_Programs__c = true;        
        insert crsTest;
        
        ApexPages.StandardController ctr = new ApexPages.Standardcontroller(crsTest);
        
        courseCatalog clsCourseCatalog = new courseCatalog(ctr);
        
    }
    
    static testMethod void testPOSTVariables() {
        
        test.startTest();
        
        ApexPages.CurrentPage().getParameters().put('result','referralsuccess');
        courseCatalog clsCourseCatalog = new courseCatalog();
        
        test.stopTest();
        
    }

    static testMethod void testGeneralCourseCatalog() {
        
        test.startTest();
        
        courseCatalog clsCourseCatalog = new courseCatalog();
        
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        clsCourseCatalog.doNothing();
        clsCourseCatalog.clearSearch();
        //clsCourseCatalog.createEnrollment();
        clsCourseCatalog.createNewCourse();
        
        // Search - Clear Criteria
        clsCourseCatalog.intClassType = 0;
        clsCourseCatalog.createNewClass();
        
        clsCourseCatalog.intClassType = 1;
        clsCourseCatalog.createNewClass();

        clsCourseCatalog.intClassType = 2;
        clsCourseCatalog.createNewClass();
        
        // Search - Specify Criteria
        
        clsCourseCatalog.coSearch.Category__c = 'Education';
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        clsCourseCatalog.coSearch.Area__c = 'Area';
        clsCourseCatalog.tskDummy.ActivityDate = null;
        clsCourseCatalog.tskDummy.Closing_Date__c = null;
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        clsCourseCatalog.tskDummy.ActivityDate = System.Today();
        clsCourseCatalog.tskDummy.Closing_Date__c = null;
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        clsCourseCatalog.tskDummy.ActivityDate = null;
        clsCourseCatalog.coSearch.Area__c = null;
        clsCourseCatalog.coSearch.Category__c = null;
        clsCourseCatalog.tskDummy.Closing_Date__c = System.Today();
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        clsCourseCatalog.tskDummy.ActivityDate = System.Today();
        clsCourseCatalog.coSearch.Area__c = null;
        clsCourseCatalog.coSearch.Category__c = null;
        clsCourseCatalog.tskDummy.Closing_Date__c = null;
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        test.stopTest();
        
    }
    
    static testMethod void testGeneralCourseCatalogRun2() {
        
        courseCatalog clsCourseCatalog = new courseCatalog();
        
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        clsCourseCatalog.clearSearch();
        
        // Search - Clear Criteria
        clsCourseCatalog.intClassType = 0;
        
        // Search - Specify Criteria
        
        test.startTest();
        
        clsCourseCatalog.coSearch.Category__c = 'Education';
        clsCourseCatalog.coSearch.Area__c = 'Area';
        clsCourseCatalog.tskDummy.ActivityDate = System.Today();
        clsCourseCatalog.tskDummy.Closing_Date__c = System.Today();
        clsCourseCatalog.clsForDisplay = clsCourseCatalog.getClasses();
        
        test.stopTest();
        
    }
    
    static testMethod void gradingAndVerification() {
        
        Course__c crsTest = new Course__c();
        crsTest.name = 'Test Course';
    	crsTest.Serves_All_Programs__c = true;        
        insert crsTest;
        
        Class__c clsTest = new Class__c();
        clsTest.Course__c = crsTest.Id;
        insert clsTest;
        
        test.startTest();
        
        courseCatalog clsCourseCatalog = new courseCatalog();
        clsCourseCatalog.strEnrollmentClassId = clsTest.Id;
        //clsCourseCatalog.gradingAndVerification();
        
        test.stopTest();
        
    }
}