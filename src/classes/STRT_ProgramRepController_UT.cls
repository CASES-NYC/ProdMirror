@isTest
(seeAllData=true)
public class STRT_ProgramRepController_UT
{
    static Id acct_client = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    static Id dtc_client = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('DTC Client').getRecordTypeId();
    static Id dtc_progCycle = Schema.SObjectType.Program_Cycle__c.getRecordTypeInfosByName().get('DTC Program Cycle').getRecordTypeId();
    static Id caseCoordination = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Case Coordination').getRecordTypeId();

    static testMethod void STRT_ProgramRepController_UT()
    {
        Account clientAccount = new Account(
                Name = 'DTC Test',
                NYSID_Number__c = '43215678A',
                RecordTypeId = acct_client);
        insert clientAccount;
        
        Contact conDTC = new Contact(
                AccountId = clientAccount.Id,
                FirstName = 'DTC',
                LastName = 'TEST',
                RecordTypeId = dtc_client,
                Client_Status__c = 'Active');
        insert conDTC;
        
        Program_Cycle__c progCycle = new Program_Cycle__c(
                Client__c = conDTC.Id,
                RecordTypeId = dtc_progCycle,
                Start_Date__c = Date.Today() - 5,
                Mandatory_Sessions_Required__c = 5);
        insert progCycle;
                
        PageReference pageRef = Page.STRTProgramReporting;
        Test.setCurrentPage(pageRef);
        STRT_ProgramRepController controller = new STRT_ProgramRepController();
        controller.selectedDate = Date.Today()-1;
        controller.proxyObject.ActivityDate = Date.Today()-1;
        controller.getDateDOW();
        controller.getStatusItems();
        controller.selectProgs = 'DTC';
        controller.buildContacts();
        controller.doNothing();
        controller.appstatus = 'Attended';
        controller.contId = conDTC.Id;
        controller.createApp();
//        controller.setMandatorySessionsCounter();
        controller.getGroupsItems();
        controller.createGroupAtt();
    }
}