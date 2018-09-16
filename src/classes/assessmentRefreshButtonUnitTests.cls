@isTest
private class assessmentRefreshButtonUnitTests {

     static testMethod void refreshAssessmentUnitTests() {
        
        ///////////////////////////////////////////////////////
        //
        // Stage Data 
        //
        ///////////////////////////////////////////////////////
        
        utilityIds util = new utilityIds();
        
        User teamLeader = [Select Id from User Where isActive = true Limit 1];
        
        Account accClient = new Account();
        accClient.Name = 'Unit Tester';
        accClient.RecordTypeID = util.accClient;
        insert accClient;
        
        Contact newContactForInsert = new Contact();
        newContactForInsert.lastName = 'Test';
        newContactForInsert.Client_Status__c = 'Active';
        newContactForInsert.Drug_test_frequency__c = 'Bi-Weekly';
        newContactForInsert.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        newContactForInsert.Team_Leader__c = teamLeader.Id;
        newContactForInsert.AccountID = accClient.id;
        newContactForInsert.RecordTypeId = util.conQJC;
        insert newContactForInsert;
        

        //////////////////////////////////////////////////////////////
        //
        // Save off all the assessments
        //
        ////////////////////////////////////////////////////////////////////
        
        Assessment__c alumniSurvey = new Assessment__c();
        alumniSurvey.Contact__c = newContactForInsert.id;
        alumniSurvey.Assessment_Completed_on__c = System.today();
        alumniSurvey.RecordTypeId = util.alumniSurveyRecordType;
        insert alumniSurvey;
        

        ///// TEST   
        pageReference pageRef = Page.assessmentPageRefresh;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', alumniSurvey.Id);
        assessmentRefreshButton thecontroller = new assessmentRefreshButton();
        thecontroller.refreshPage();
     }

}