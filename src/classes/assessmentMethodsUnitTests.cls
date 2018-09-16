@isTest(SeeAllData=true)
private class assessmentMethodsUnitTests {
  
    static utilityIds utilIds = new utilityIds();
    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    
    private static void init() {
        
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
        

        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        insert thisEvent;   
    }  

   static testMethod void assessmentMethodsUnitTests() {
        
    init();
    
    test.startTest();
    
        // Save off all the assessments       
        Assessment__c caseCoordinatorAssessment = new Assessment__c();
        caseCoordinatorAssessment.Contact__c = con.id;
        caseCoordinatorAssessment.Assessment_Completed_on__c = System.today();
        caseCoordinatorAssessment.RecordTypeId = utilIds.ccAssessmentRecordType;
        
        Assessment__c educationAssessment = new Assessment__c();
        educationAssessment.Contact__c = con.id;
        educationAssessment.Assessment_Completed_on__c = System.today();
        educationAssessment.RecordTypeId = utilIds.eduAssessmentRecordType;
        insert new Assessment__c[] {caseCoordinatorAssessment, educationAssessment};        
        
        ///// TEST   
        pageReference pageRef1 = Page.assessmentRecordLock;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('id', caseCoordinatorAssessment.Id);
        assessmentMethods thecontroller1 = new assessmentMethods();
        thecontroller1.lockRecord();
        
        // 3/26/13 MB: This has to be set after each assessment or else the triggers won't run
        // and we won't get code coverage for all the recordtype-specific logic in processAssessmentSave
        UtilityIds.bolAlumniSurveysAlreadyUpdated = false;
              
         ///// TEST   
        pageReference pageRef2 = Page.assessmentRecordLock;
        Test.setCurrentPage(pageRef2);
        ApexPages.currentPage().getParameters().put('id', educationAssessment.Id);
        assessmentMethods thecontrolle2 = new assessmentMethods();
        thecontrolle2.lockRecord();
        
    test.stopTest();         
   }
   
   static testMethod void assessmentMethodsUnitTests2() {
        
    init();
        
    test.startTest();        
        
        Assessment__c psychAssessment = new Assessment__c();
        psychAssessment.Contact__c = con.id;
        psychAssessment.Assessment_Completed_on__c = System.today();
        psychAssessment.RecordTypeId = utilIds.psyAssessmentRecordType;
        
        Assessment__c homeVisitAssessment = new Assessment__c();
        homeVisitAssessment.Contact__c = con.id;
        homeVisitAssessment.Assessment_Completed_on__c = System.today();
        homeVisitAssessment.RecordTypeId = utilIds.homeVisitRecordType;
        
        Assessment__c substanceAbuseAssessment = new Assessment__c();
        substanceAbuseAssessment.Contact__c = con.id;
        substanceAbuseAssessment.Assessment_Completed_on__c = System.today();
        substanceAbuseAssessment.RecordTypeId = utilIds.subAbuseAssessmentRecordType;
        //new fields added 12/9/13 MB must be filled in when assessment is completed
        substanceAbuseAssessment.CRAFFT_A1_Drink_any_alcohol__c = 'No';
        substanceAbuseAssessment.CRAFFT_A2_Smoke_any_marijuana_or_hashish__c = 'No';
        substanceAbuseAssessment.CRAFFT_A3_Use_anything_else_to_get_high__c = 'No';        
        insert new Assessment__c[] {psychAssessment, homeVisitAssessment, substanceAbuseAssessment};               
        
         ///// TEST   
        pageReference pageRef5 = Page.assessmentRecordLock;
        Test.setCurrentPage(pageRef5);
        ApexPages.currentPage().getParameters().put('id', psychAssessment.Id);
        assessmentMethods thecontroller5 = new assessmentMethods();
        thecontroller5.lockRecord();
        
        UtilityIds.bolAlumniSurveysAlreadyUpdated = false;
        

         ///// TEST   
        pageReference pageRef6 = Page.assessmentRecordLock;
        Test.setCurrentPage(pageRef6);
        ApexPages.currentPage().getParameters().put('id', substanceAbuseAssessment.Id);
        assessmentMethods thecontroller6 = new assessmentMethods();
        thecontroller6.lockRecord();
        
        UtilityIds.bolAlumniSurveysAlreadyUpdated = false;
        
         ///// TEST   
        pageReference pageRef7 = Page.assessmentRecordLock;
        Test.setCurrentPage(pageRef7);
        ApexPages.currentPage().getParameters().put('id', homeVisitAssessment.Id);
        assessmentMethods thecontroller7 = new assessmentMethods();
        thecontroller7.lockRecord();
        
        homeVisitAssessment = [select id, recordtypeId from Assessment__c where id = :homeVisitAssessment.id];
        system.assertEquals(homeVisitAssessment.recordtypeId, utilIds.homeVisitLockedRecordType);
        
    test.stopTest();        
        
   }
/*   
   static testMethod void alumniSurveyUnitTests() {
    
    init();    

    test.startTest();

        //test alumni survey tasks
        
        Program_Stage__c ps = new Program_Stage__c();
        ps.Client_Name__c = con.Id;
        ps.Program_Cycle__c = 3;
        ps.Program_Name__c = ' ';        
        ps.Stage_Date__c = system.today();
        ps.Stage_Id__c = '80.Completed Internship';
        ps.Stage_Number__c = 80;

        Insert ps;
        
        Administrative_Actions__c aaExit = new Administrative_Actions__c();
        aaExit.Client__c = con.id;
        aaExit.RecordTypeId = utilIds.aaExitNotification;
        aaExit.Action_Date__c = System.Today();
        aaExit.Exit_Type__c = '(S) Successful Exit/ Graduation';
        aaExit.Exit_Reason__c = 'Successfully completed program, without modification';
        
        insert aaExit;
        
        aaExit.Approved__c = 'Yes';
        aaExit.Approved_By__c = UserInfo.getUserId();
        
        update aaExit;

        con = [select id, highest_career_ex_stage__c, current_exit_date__c
        from contact where id = :con.id];
        
        system.debug(con);

        Task openTask = [select id, ActivityDate from Task where whoId = :con.id
                           and Subject = 'Alumni Survey' and IsClosed = false];  

        system.debug('past openTask');

        Assessment__c alumniSurvey = new Assessment__c();
        alumniSurvey.Contact__c = con.id;
        //alumniSurvey.Assessment_Completed_on__c = System.today();
        alumniSurvey.Client_Contact_Method__c = 'Career Ex Graduation Survey';
        alumniSurvey.Survey_Date__c = system.today();
        alumniSurvey.Survey_Completed_by__c = userInfo.getUserId();
        alumniSurvey.Education_Information_Confirmed__c = 'Yes';
        alumniSurvey.Employment_Information_Confirmed__c = 'Yes';
        //alumniSurvey.Locked__c = true;
        alumniSurvey.RecordTypeId = utilIds.alumniSurveyRecordType;      
        insert alumniSurvey;    
        
        // must set this value back to false or else the assessment triggers won't run on lockRecord
        UtilityIds.bolAlumniSurveysAlreadyUpdated = false;          

         ///// TEST   
        pageReference pageRef = Page.assessmentRecordLock;
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', alumniSurvey.Id);
        assessmentMethods thecontroller = new assessmentMethods();
        thecontroller.lockRecord();
        
        system.debug(con.Current_Exit_Date__c + '\n'
        + con.Highest_Career_Ex_Stage__c + '\n' 
        + alumniSurvey.RecordTypeId + '\n' + ps.Id);
        
        Task closedTask = [select id, Closing_Date__c from Task where whoId = :con.id
                           and Subject = 'Alumni Survey' and IsClosed = true];   

        openTask = [select id, ActivityDate from Task where whoId = :con.id
                           and Subject = 'Alumni Survey' and IsClosed = false];  

        system.assertEquals(closedTask.Closing_Date__c, system.today());
        system.assertEquals(openTask.ActivityDate, system.today().addDays(90));                
         
    test.stopTest();                            
                                                               
   }
*/
}