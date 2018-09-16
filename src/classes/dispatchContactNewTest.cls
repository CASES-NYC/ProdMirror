@isTest
public class dispatchContactNewTest 
{

    public static testMethod void dispatchContactNewTest() 
    {
        Id testRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BK PEAK Client').getRecordTypeId();
        Contact con = new Contact(RecordTypeId = testRecType);     
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        PageReference pageRef = Page.dispatchContactNew;
        Test.setCurrentPage(pageRef);
        dispatchContactNewCon disp = new dispatchContactNewCon(sc);
        String nextPage = disp.redirect().getUrl();
    }
}