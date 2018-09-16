global class jobUpdateTodayField_Scheduler  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobUpdateTodayField_Scheduler j = new jobUpdateTodayField_Scheduler();
        return system.schedule('Update Today Fields', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobUpdateTodayFields job = new jobUpdateTodayFields();
        job.setToday();
    }

}