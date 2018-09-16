@isTest (SeeAllData=true)
private class jobCreateProgramStages_UnitTest {

    static testmethod void test() {
        Test.startTest();

        System.schedule('Test Create Program Stages', '0 45 1 * * ?', new jobCreateProgramStages_Scheduler());

        Test.stopTest();
    }
}