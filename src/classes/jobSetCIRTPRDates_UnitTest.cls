@isTest (SeeAllData=true)
private class jobSetCIRTPRDates_UnitTest{
    static testmethod void test() {
        Test.startTest();

        System.schedule('Test CIRT Program Relationship Dates', '0 30 2 * * ?', 
            new jobSetCIRTPRDates_Scheduler());

        Test.stopTest();
    }
}