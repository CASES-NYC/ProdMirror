global class jobAutoExtendSchedule_Scheduler implements Schedulable{

    global void execute(SchedulableContext ctx) {
       
        jobAutoExtendSchedule job = new jobAutoExtendSchedule();
        ID batchId = Database.executeBatch(job, 1);

    }


    /// UNIT TESTS
    static testmethod void test() {
        Test.startTest();

        String jobId_00 = System.schedule('Extend Schedule - 10 Past the Hour',    '0 10 * * * ?', new jobAutoExtendSchedule_Scheduler());

        Test.stopTest();
    } 

}