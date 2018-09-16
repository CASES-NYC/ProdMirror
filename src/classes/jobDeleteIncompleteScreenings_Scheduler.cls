global class jobDeleteIncompleteScreenings_Scheduler  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobDeleteIncompleteScreenings_Scheduler j = new jobDeleteIncompleteScreenings_Scheduler();
        return system.schedule('Delete Incomplete Screenings', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobDeleteIncompleteScreenings job = new jobDeleteIncompleteScreenings();
        job.DeleteIncompleteScreenings(1);
    }
    
    ////////////// 
    /// UNIT TEST
    ////////////////
    static testmethod void test() {
        Test.startTest();

        //System.schedule('Test Delete Incomplete Screenings', '0 45 2 * * ?', new jobDeleteIncompleteScreenings_Scheduler());

        Test.stopTest();
    }     

}