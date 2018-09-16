global class jobUpdateNumberofDaysinProgram_SchedV2  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobUpdateNumberofDaysinProgram_SchedV2 j = new jobUpdateNumberofDaysinProgram_SchedV2();
        return system.schedule('Update Day Count Fields', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobUpdateNumberofDaysinProgramV2 job = new jobUpdateNumberofDaysinProgramV2();
        job.UpdateDayCountFields(null, date.Today().addDays(-1), date.Today().addDays(1), null);
    }
    
    ////////////// 
    /// UNIT TEST
    ////////////////
    static testmethod void test() {
        Test.startTest();

        System.schedule('Test Update Days in Program', '0 30 1 * * ?', new jobUpdateNumberofDaysinProgram_SchedV2());
        jobUpdateNumberofDaysinProgram_SchedV2.scheduleJob('0 30 1 * * ?');

        Test.stopTest();
    }     

}