@isTest (seeAllData=true)
private class cirtNonDocExtensionTest 
{
    static cirtNonDocExtension cnd;
    static CIRT_Download__c cirtDownload;
    static PageReference pageRef;
    static Account accnt;
    static Contact contct;
    static Case_Information__c caseInfo;
    static Date dob1 = Date.newInstance(1976,11,20);

    private static void init()
    {
        cirtDownload = new CIRT_Download__c();
        cirtDownload.FirstName__c = 'Fname';
        cirtDownload.LastName__c = 'Lname';
        cirtDownload.DOB__c = dob1;
        cirtDownload.NYSID__c = '12345678Z';
        cirtDownload.Client_Consent__c = 'Yes';
        cirtDownload.Docket__c = '2012NY123456';
     

      
        insert cirtDownload;
        pageRef = Page.CIRTnonDOC;

        ApexPages.StandardController stdcon = new ApexPages.StandardController(cirtDownload);
        cnd = new cirtNonDocExtension(stdCon);
    }

    static testMethod void testRefExt()
    {
        init();
        Test.startTest();
        cnd.ClientConsented();
        Test.stopTest();
    } 


}