@isTest(seeAllData=true)
private class srNeedsAssessExtUnitTest 
{
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo = new Case_Information__c();
    static Assessment__c BJMHS = new Assessment__c();
    static Assessment__c PHQ9 = new Assessment__c();
    static Assessment__c PHQ9T = new Assessment__c();
    static Assessment__c TCU = new Assessment__c();
    static Id accSRP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    static Id conSRP = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SRP Client').getRecordTypeId();
    static Id caseInfoCC = Schema.SObjectType.Case_Information__c.getRecordTypeInfosByName().get('Criminal Court').getRecordTypeId();
    static Id assBJMHSRecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('BJMHS').getRecordTypeId();
    static Id assPHQ9RecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('PHQ-9').getRecordTypeId();
    static Id assPHQ9RORecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('PHQ-9 - Read Only').getRecordTypeId();
    static Id assPHQ9TRecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('PHQ-9 Teen').getRecordTypeId();
    static Id assTCURecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('TCU').getRecordTypeId();
    static Id assCRAFFTRecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CRAFFT').getRecordTypeId();
    static Id assSRPNeedsIntake = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('SR Intake Needs Assessment').getRecordTypeId();  
    
    private static void init() 
    {
        
        accClient = new Account();
        accClient.Name='Unit Tester'; 
        accClient.RecordTypeId = accSRP;
        accClient.DOB__c =  Date.newInstance(1970,1,1);
        insert accClient;
       
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient.Id;
        newCaseInfo.RecordTypeId = caseInfoCC;
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
        con.RecordTypeId = conSRP;
        con.accountId = accClient.id;    
        
        insert con;

        BJMHS = new Assessment__c();
        BJMHS.Contact__c = con.Id;
        BJMHS.RecordTypeId = assBJMHSRecTypeId;
        insert BJMHS;

        TCU = new Assessment__c();
        TCU.COntact__c = con.Id;
        TCU.RecordTypeId = assTCURecTypeId;
        insert TCU;
        
    }

    testmethod private static void intakeTest1()
    {
        init();
        PageReference pageRef = Page.SRP_Needs_Assessment_Master;
        Test.StartTest();
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('contactid', con.Id);
        Assessment__c assSRNA = new Assessment__c();
        Apexpages.StandardController sc1 = new ApexPages.StandardController(assSRNA);        
        srpNeedsMasterExt snMastExt = new srpNeedsMasterExt(sc1);
        snMastExt.Initialize();
        System.assertEquals(assSRNA.Contact__c, con.Id);
        pageRef = new PageReference('/apex/sr_needs_assessment_edit');
        SR_Intake_Needs_Assessment__c srNeeds = [SELECT Id, Participant__r.Name, Participant__r.Current_Age__c, AssessmentId__c, Participant__c 
                FROM SR_Intake_Needs_Assessment__c WHERE Id = :assSRNA.SR_Intake_Needs__c LIMIT 1];
        Apexpages.StandardController sc = new Apexpages.standardController(srNeeds);
        srNeedsAssessExt srExt = new srNeedsAssessExt(sc);    
        Test.setCurrentPage(pageRef);
        String urlVal = Apexpages.currentPage().getURL();
        srExt.initialize();
        srExt.getTypes();
        srExt.getSupportLevel();
        srExt.getEducationLevel();
        srExt.getBJMHS_Completed();
        srExt.getCRAFFT_Completed();
        srExt.getPHQ9_Completed();
        srExt.getPHQ9T_Completed();
        srExt.getTCU_Completed();
        srExt.getIsAdult();
        srExt.cancel();
        srExt.save();

        Test.StopTest();
        
    }
    
}