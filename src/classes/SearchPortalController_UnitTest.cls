@isTest(SeeAllData=true)
private class SearchPortalController_UnitTest {

    static utilityIds utilIds = new utilityIds();
    static Account newAccountForInsertNoCase = new Account();
    static Account newAccountForInsert = new Account();
    static Case_Information__c newCaseInfo = new Case_Information__c();
    static Case_Information__c newCaseInfo2 = new Case_Information__c();
    static Contact newContactForInsert = new Contact();
    static Contact newContactForInsertNoCase = new Contact();
    static Contact newContactForInsert2 = new Contact();
    static Course__c crsTest = new Course__c();
    static Class__c clTest = new Class__c();
    static Schedule__c scTest = new Schedule__c();
    static Session__c seTest = new Session__c();
    static void createTestData()
  {     
        newAccountForInsert = new Account();
        newAccountForInsert.name = 'Dusty Bottoms';
        newAccountForInsert.RecordTypeId = utilIds.accClient;
        newAccountForInsert.NYSID_Number__c = '90978021U';
        newAccountForInsert.DOB__c = Date.newInstance(1970,1,1);
        insert newAccountForInsert;
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = newAccountforInsert.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoCriminalCourt;
        newCaseInfo.Name = '2011BV144590';
        newCaseInfo.Borough__c = 'Bronx';
        insert newCaseInfo;
        
        newCaseInfo2 = new Case_Information__c();
        newCaseInfo2.Client_Account__c = newAccountforInsert.Id;
        newCaseInfo2.RecordTypeId = utilIds.caseInfoCriminalCourt;
        newCaseInfo2.Name = '2012SK414337';
        newCaseInfo2.Borough__c = 'Bronx';
        insert newCaseInfo2;        
        
        newContactForInsert = new Contact();
        newContactForInsert.FirstName = 'Dusty';
        newContactForInsert.lastName = 'Bottoms';
        newContactForInsert.Client_Status__c = 'Incomplete Screening';
        newContactForInsert.PRP_Status__c = 'Successful Exit';
        newContactForInsert.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert.Team_Leader__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert.AccountId = newAccountForInsert.id;
        newContactForInsert.Intake_Case__c = newCaseInfo.id;
        newContactForInsert.Referral_Date__c = date.newInstance(2011,2,1);
        newContactForInsert.RecordTypeId = utilIds.conDTC; 
        insert newContactForInsert;
        
        newContactForInsert2 = new Contact();
        newContactForInsert2.FirstName = 'Dusty1';
        newContactForInsert2.lastName = 'Bottoms1';
        newContactForInsert2.Client_Status__c = 'Incomplete Screening';
        newContactForInsert.PRP_Status__c = 'Unsuccessful Exit';
        newContactForInsert2.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert2.Team_Leader__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert2.AccountId = newAccountForInsert.id;
        newContactForInsert2.Intake_Case__c = newCaseInfo2.id;
        newContactForInsert2.Referral_Date__c = date.newInstance(2011,2,1);
        newContactForInsert2.RecordTypeId = utilIds.conCCM; 
        insert newContactForInsert2;
  
        crsTest = new Course__c();
        crsTest.name = 'TRP One Day Session';
        crsTest.Category__c = 'TRP One Day Session';
        crsTest.Area__c = 'Substance Abuse';
        crsTest.Programs_served__c = 'TRP';        
        insert crsTest;
        
        // Create Class
        clTest = new Class__c();
        clTest.Course__c = crsTest.Id;
      clTest.RecordTypeId = utilIds.classSingle;
        insert clTest;
        
        // Create Schedule
        scTest = new Schedule__c();
        scTest.Class__c = clTest.Id;
        scTest.Start_Date__c = System.Now().addHours(24);
        scTest.End_Date__c = System.Now().addHours(26);
        scTest.RecordTypeId = utilIDs.scheduleSingle;
        insert scTest;
        
        // Create Session
        seTest = new Session__c();
        seTest.Assigned_To__c = UserInfo.getUserId();
        seTest.Schedule__c = scTest.Id;
        seTest.Session_Start__c = scTest.Start_Date__c;
        seTest.Session_End__c = scTest.End_Date__c;
        insert seTest;
  

        newAccountForInsertNoCase = new Account();
        newAccountForInsertNoCase.name = 'Bill Adams';
        newAccountForInsertNoCase.RecordTypeId = utilIds.accClient;
        newAccountForInsertNoCase.NYSID_Number__c = '11111111K';
        newAccountForInsertNoCase.DOB__c = Date.newInstance(1970,1,1);
        insert newAccountForInsertNoCase;
  
  
        newContactForInsertNoCase = new Contact();
        newContactForInsertNoCase.FirstName = 'Bill';
        newContactForInsertNoCase.lastName = 'Adams';
        newContactForInsertNoCase.AccountId = newAccountForInsertNoCase.id;
        newContactForInsertNoCase.RecordTypeId = utilIds.conPRP; 
        newContactForInsertNoCase.Referral_Date__c = date.newInstance(2011,2,1);
        newContactForInsertNoCase.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
        newContactForInsertNoCase.Team_Leader__c = utilIds.defaultTaskAssignedTo;
        newContactForInsertNoCase.Warrant_id__c = '123564';
        insert newContactForInsertNoCase;
 
  }
   
       static testMethod void test_1() {
        createTestData();
        /*************
        * START TEST
        *************/
        test.startTest();
        
        SearchPortalController_New clsSPC = new SearchPortalController_New();
        clsSPC.strUserType = 'START';
        // GET-SET Tests
        List<SelectOption> lstTestTRPClasses = clsSPC.getlstTRPClasses();
        //System.Assert(lstTestTRPClasses.size() > 0, 'There are no future TRP classes available, this test cannot continue!');
        
        // Misc Class Tests
        clsSPC.doNothing();
        
        // Null Criteria Search
        clsSPC.doCriteriaSearch();
        System.Assert(clsSPC.strStatusMessage != null, 'The NULL Criteria search did not return a proper status message, this test cannot continue!');
        
        // Fill Invalid Criteria to create new client
        clsSPC.clsSearch.strDocket = '2000XX123456';
        clsSPC.clsSearch.strNYSID = '65485273X';
        clsSPC.clsSearch.strFirstName = 'xxxxxxxxxx';
        clsSPC.clsSearch.strLastName = 'yyyyyyyyyy';
        clsSPC.clsSearch.tskSearch.ActivityDate = System.Today().addYears(-18);
        clsSPC.doCriteriaSearch();
        // Test Search - for new client creation
        clsSPC.doCriteriaSearch();
        System.Assert(clsSPC.bolSearchExecuted && !clsSPC.bolQueryExactMatch, 'The -Create New Client- functionality will not continue because the search found an Exact Match, this test cannot continue!');       
        
        // Success test
        PageReference prTestNewClient = clsSPC.createBasicDataForStart();
        System.Assert(prTestNewClient != null, 'The -Create New Client- functionality did not create a new Account properly, this test cannot continue!');
        
        // Failure test, blank out fn/ln
        clsSPC.clsSearch.strFirstName = '';
        clsSPC.clsSearch.strLastName = '';
        prTestNewClient = clsSPC.createBasicDataForStart();
        System.Assert(prTestNewClient == null, 'The -Create New Client- functionality FAIL TEST created an account, this test cannot continue!');
        
        // Fill Valid Criteria
        clsSPC.clsSearch.clearSearchCriteria();
        clsSPC.clsSearch.strDocket = newCaseInfo.Name;
        clsSPC.clsSearch.strLastName = 'Bottoms';
        clsSPC.clsSearch.strFirstname = 'Dusty';
        
        // Full Criteria Search
        
        clsSPC.doCriteriaSearch();
  
        PageReference prTestTRP;
        // TRP - FAIL
        
       prTestTRP = clsSPC.createTRPContact();
   //     System.Assert(prTestTRP == null, 'The - Enroll TRP- functionality FAIL TEST enrolled the client properly, this test cannot continue!');
        
        // TRP - SUCCESS
 //       if (lstTestTRPClasses.Size() <> 0){
        clsSPC.clsSearch.strTRPClass = lstTestTRPClasses[0].getValue();
        clsSPC.clsSearch.strDocket = '2000XX123456';
        prTestTRP = clsSPC.createTRPContact();
    //    System.Assert(prTestTRP != null, 'The - Enroll TRP- functionality did not enroll the client properly, this test cannot continue!');
    //    }
        
        
        test.stopTest();
        /*************
        * STOP TEST
        *************/
    }
      
       static testMethod void test_3() {
        createTestData();
        test.startTest();
        PageReference ref = new PageReference('/apex/SearchPortalPage'); 
        Test.setCurrentPage(ref); 
        test.stopTest();
     }
        static testMethod void test_4() {
        createTestData();
        test.startTest();
  
        SearchPortalController_New clsSPC = new SearchPortalController_New();
        clsSPC.getUserTypes();
       
        PageReference pr;
       
        clsSPC.strUserType = 'CEP';
        pr = clsSPC.createBasicDataForCEP();
        test.stopTest();
 
    }
   
          static testMethod void test_noCaseCEP() {
        createTestData();
        /*************
        * START TEST
        *************/
        test.startTest();
        SearchPortalController_New clsSPC = new SearchPortalController_New();
        clsSPC.strUserType = 'CEP';
        // GET-SET Tests
  
        // Misc Class Tests
        clsSPC.doNothing();

        clsSPC.clsSearch.strDocket = '';
        clsSPC.clsSearch.strNYSID = '11111111K';
        clsSPC.clsSearch.strFirstName = '';
        clsSPC.clsSearch.strLastName = '';
        clsSPC.doCriteriaSearch();
        test.stopTest();
        /*************
        * STOP TEST
        *************/
    }
}