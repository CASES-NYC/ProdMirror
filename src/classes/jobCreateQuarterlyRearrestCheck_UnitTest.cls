@isTest (SeeAllData=true)
private class jobCreateQuarterlyRearrestCheck_UnitTest {

    ////////////// 
    /// UNIT TEST
    ////////////////
    static testmethod void test() {
        Test.startTest();

        //System.schedule('Test Create Quarterly Rearrest Checks', '0 45 10 L 3,6,9,12 ?', new jobCreateQuarterlyRearrest_Scheduler());

        Test.stopTest();
    }
}