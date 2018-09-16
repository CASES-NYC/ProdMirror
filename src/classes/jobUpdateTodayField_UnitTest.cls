@isTest (SeeAllData=true)
private class jobUpdateTodayField_UnitTest {
    static testmethod void test() {
        Test.startTest();

        System.schedule('Test Update Today Fields'+System.now(), '0 30 1 * * ?', new jobUpdateTodayField_Scheduler());

        Test.stopTest();
    }
    
}