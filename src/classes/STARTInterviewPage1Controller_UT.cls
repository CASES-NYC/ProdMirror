@isTest(SeeAllData=true)
private class STARTInterviewPage1Controller_UT {

    static utilityIds utilIds = new utilityIds();

    static testMethod void testSearchCriteria() {
        
        Account newAccountForInsert = new Account();
        newAccountForInsert.name = 'Dusty Bottoms';
        newAccountForInsert.RecordTypeId = utilIds.accClient;
        newAccountForInsert.NYSID_Number__c = '09414437J';
        newAccountForInsert.DOB__c = Date.newInstance(1970,1,1);
        insert newAccountForInsert;
        
        Case_Information__c newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = newAccountforInsert.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoCriminalCourt;
        newCaseInfo.Name = '2011BV144590';
        newCaseInfo.Borough__c = 'Bronx';
        insert newCaseInfo;
        
        Case_Information__c newCaseInfo2 = new Case_Information__c();
        newCaseInfo2.Client_Account__c = newAccountforInsert.Id;
        newCaseInfo2.RecordTypeId = utilIds.caseInfoCriminalCourt;
        newCaseInfo2.Name = '2012SK414337';
        newCaseInfo2.Borough__c = 'Bronx';
        insert newCaseInfo2;        
        
        Contact newContactForInsert = new Contact();
        newContactForInsert.FirstName = 'Dusty';
        newContactForInsert.lastName = 'Bottoms';
        newContactForInsert.Client_Status__c = 'Incomplete Screening';
        newContactForInsert.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert.Team_Leader__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert.AccountId = newAccountForInsert.id;
        newContactForInsert.Intake_Case__c = newCaseInfo.id;
        newContactForInsert.Referral_Date__c = date.newInstance(2011,2,1);
        newContactForInsert.RecordTypeId = utilIds.conDTC; 
        insert newContactForInsert;
        
        Contact newContactForInsert2 = new Contact();
        newContactForInsert2.FirstName = 'Dusty';
        newContactForInsert2.lastName = 'Bottoms';
        newContactForInsert2.Client_Status__c = 'Incomplete Screening';
        newContactForInsert2.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert2.Team_Leader__c = utilIds.defaultTaskAssignedTo;
        newContactForInsert2.AccountId = newAccountForInsert.id;
        newContactForInsert2.Intake_Case__c = newCaseInfo2.id;
        newContactForInsert2.Referral_Date__c = date.newInstance(2011,2,1);
        newContactForInsert2.RecordTypeId = utilIds.conCCM; 
        insert newContactForInsert2;
        
        /*************
        * START TEST
        *************/
        test.startTest();
        
        STARTInterviewPage1Controller clsFlow = new STARTInterviewPage1Controller();
        Test.setCurrentPage(Page.STARTInterviewPage1);
        
        
        // Test NULL sides of GETers
        String strContactId = clsFlow.strContactId;
        String strDocketId = clsFlow.strDocketId;
        String strProgram = clsFlow.getstrProgram();
        String strProgramCycleId = clsFlow.getstrProgramCycleId();
        String strAddressId = clsFlow.getstraddressId();
        String strBJMHSTestId = clsFlow.getstrBJMHSTestId();
        String strG_AccountId = clsFlow.getstrG_AccountId();
        System.Assert(strContactId == null && strDocketId == null && strProgram == null && strProgramCycleId == null && strAddressId == null && strBJMHSTestId == null && strG_AccountId == null, 'NULL GETers are failing');
        
        
        // Test Flow Exit Page References
        clsFlow.strContactId = newContactForInsert.Id; 
        clsFlow.strDocketId = newCaseInfo.Id;
        
        PageReference prRefFlow1End = clsFlow.strFlow1EndPage;
        System.Assert(prRefFlow1End != null, 'Flow1End PR Fail');
        PageReference prRefFlow2End = clsFlow.getstrFlow2EndPage();
        System.Assert(prRefFlow1End != null, 'Flow2End PR Fail');
        
        // Test Intermediary button advances
        PageReference prRefMoveToCharges = clsFlow.moveToCharges();
        System.Assert(prRefMoveToCharges != null, 'MoveToCharges PR Fail');
        
        PageReference prRefMoveToFlow2 = clsFlow.moveToFlow2();
        System.Assert(prRefMoveToCharges != null, 'MoveToFlow2 PR Fail');
        
        // TEST NULL side of Step Progress
        String strStepProgress = clsFlow.getstrStepProgress();
        System.Assert(strStepProgress != null, 'NULL Step Progress FAIL');
        
        ////////////////////
        // NOTE!  Salesforce limitation, we cannot "start" the interview - it's not supported yet.
        ////////////////////
        
        test.stopTest();
        /*************
        * STOP TEST
        *************/
    }
}