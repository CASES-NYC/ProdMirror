global class jobCloseSTARTCycles_Scheduler  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobCloseSTARTCycles_Scheduler j = new jobCloseSTARTCycles_Scheduler();
        return system.schedule('Close DTC/CCM Cycles', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobCloseSTARTCycles job = new jobCloseSTARTCycles();
  //      job.CloseSTARTCycles();
    }
    
    ////////////// 
    /// UNIT TEST
    ////////////////
    static testmethod void test() {
        Test.startTest();

        System.schedule('Test Close START Cycles', '0 45 1 * * ?', new jobCloseSTARTCycles_Scheduler());

        Test.stopTest();
    }     

}