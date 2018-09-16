@isTest (SeeAllData = true)
private class jobProgramReportingMaxDate_UnitTest {
    static testmethod void test() {
        Test.startTest();

        System.schedule('Test Calculate Max/Min Appointments', '0 45 2 * * ?', new jobProgramReportingMaxDate_Scheduler());

        Test.stopTest();
    }
}