@isTest (SeeAllData=true)
private class jobCreateSessionsforDTCGroups_UnitTest{
    static testmethod void test() {
        Test.startTest();

        System.schedule('Test Create DTC Sessions', '0 50 1 * * ?', new jobCreateSessionsforDTCGroups_Scheduler());

        Test.stopTest();
    }
}