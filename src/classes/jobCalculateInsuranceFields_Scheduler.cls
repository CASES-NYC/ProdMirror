global class jobCalculateInsuranceFields_Scheduler implements Schedulable{

    global static string scheduleJob(string runTime) {
        
        jobCalculateInsuranceFields_Scheduler j = new jobCalculateInsuranceFields_Scheduler();
        return system.schedule('Calculate Insurance Fields', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobCalculateInsuranceFields job = new jobCalculateInsuranceFields();
        job.main(date.Today().addDays(-2), date.Today().addDays(1));
    }   
}