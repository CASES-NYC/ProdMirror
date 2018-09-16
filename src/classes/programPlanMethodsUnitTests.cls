@isTest(SeeAllData=true)
private class programPlanMethodsUnitTests {

    static utilityIds utilIds = new utilityIds();

    static testMethod void programPlanMethodsUnitTests() {
        
        //Stage Data
        
        Contact testContact = new Contact();
        testContact.lastName = 'Test';
        testContact.Team_Leader__c = UserInfo.getUserId();
        insert testContact;
        
        Program_Plan__c newPP = new Program_Plan__c();
        newPP.Client_Name__c = testContact.Id;
        insert newPP;
        
        // Create On-time Task to Close
        Task tskPP = new Task();
        tskPP.WhoId = testContact.Id;
        tskPP.RecordTypeId = utilIds.initialProgramPlanTask;
        tskPP.Subject = 'Initial Program Plan';
        tskPP.Open_Date__c = System.Today();
        tskPP.ActivityDate = System.Today();
        tskPP.Verification_Due_Date__c = System.Today().addDays(29);
        tskPP.Automatically_Generated__c = true;  
        tskPP.ownerId = testContact.Team_Leader__c;
        tskPP.SkipRestrictions__c = true;
        insert tskPP;
   
        ///// TEST   
        pageReference pageRef = Page.programPlanRecordLock;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', newPP.Id);
        programPlanMethods thecontroller = new programPlanMethods();
        thecontroller.lockRecord();

        ///// TEST   
        pageReference pageRef2 = Page.programPlanRecordLock;
        Test.setCurrentPage(pageRef2);
        programPlanMethods thecontroller2 = new programPlanMethods();
        thecontroller2.lockRecord();
        
        // Create Late Task to Close
        Task tskPPLate = new Task();
        tskPPLate.WhoId = testContact.Id;
        tskPPLate.RecordTypeId = utilIds.initialProgramPlanTask;
        tskPPLate.Subject = 'Initial Program Plan';
        tskPPLate.Open_Date__c = System.Today().addDays(-14);
        tskPPLate.ActivityDate = System.Today().addDays(-14);
        tskPPLate.Verification_Due_Date__c = System.Today().addDays(-10);
        tskPPLate.Automatically_Generated__c = true;  
        tskPPLate.ownerId = testContact.Team_Leader__c;
        tskPPLate.SkipRestrictions__c = true;
        insert tskPPLate;
        
        ///// TEST   
        pageReference pageRef3 = Page.programPlanRecordLock;
        Test.setCurrentPage(pageRef3);
        ApexPages.currentPage().getParameters().put('id', newPP.Id);
        programPlanMethods thecontroller3 = new programPlanMethods();
        thecontroller3.lockRecord();

        ///// TEST   
        pageReference pageRef4 = Page.programPlanRecordLock;
        Test.setCurrentPage(pageRef4);
        programPlanMethods thecontroller4 = new programPlanMethods();
        thecontroller4.lockRecord();
    }        
}