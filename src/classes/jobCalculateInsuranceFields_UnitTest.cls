@isTest (SeeAllData=true)
private class jobCalculateInsuranceFields_UnitTest {

    static testmethod void test() {
        Test.startTest();

        System.schedule('Test Insurance Fields', '0 45 2 * * ?', 
            new jobCalculateInsuranceFields_Scheduler());

        Test.stopTest();
    }
    
}