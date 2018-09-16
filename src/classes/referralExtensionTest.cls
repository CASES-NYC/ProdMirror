@isTest (seeAllData=true)
private class referralExtensionTest 
{
    static referralExtension refEx;
    static Referral__c referral;
    static Penal_Code__c penalCode;
    static PageReference pageRef;
    static Account accnt;
    static Contact contct;
    static Criminal_and_Legal_History__c legalHist;
    static Case_Information__c caseInfo;
    static Date dob1 = Date.newInstance(1976,11,20);

    private static void init()
    {
        penalCode = new Penal_Code__c();
        penalCode.Name = '100.00';
        penalCode.Degree__c = '5';
        penalCode.Level__c = 'V';
        insert penalCode;
        
        referral = new Referral__c();
        referral.FirstName__c = 'Fname';
        referral.LastName__c = 'Lname';
        referral.DOB__c = dob1;
        referral.NYSID__c = '12345678Z';
        referral.Attorney_Consent__c = 'Yes';
        Referral.Client_Consent_to_Screening__c = 'Yes';
        referral.Docket__c = '2012NY123456';
        referral.Arrest_Date__c = Date.newInstance(2016, 06, 10);
        referral.Arrest_Number__c = 'h143576543';
        referral.Charge_A1__c = penalCode.Id;
        referral.Docket2__c = '2013NY123456';       
        referral.Charge_B1__c = penalCode.Id;
        referral.Docket3__c = '2014NY123456';
        referral.Charge_C1__c = penalCode.Id;
        referral.Docket4__c = '2015NY123456';
        referral.Charge_D1__c = penalCode.Id;       
        insert referral;
        pageRef = Page.srp_referralV2_edit;

        ApexPages.StandardController stdcon = new ApexPages.StandardController(referral);
        refEx = new referralExtension(stdCon);
    }

    static testMethod void testRefExt()
    {
        init();
        Test.startTest();
        pageRef = refEx.reloadPage();
        refEx.ClientConsented();
        Test.stopTest();
    } 


}