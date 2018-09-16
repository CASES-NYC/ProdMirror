global class jobCreateQuarterlyRearrest_Scheduler implements Schedulable{

    global static string scheduleJob(string runTime) {
        
        jobCreateQuarterlyRearrest_Scheduler j = new jobCreateQuarterlyRearrest_Scheduler();
        return system.schedule('Create Quarterly Rearrest Checks', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobCreateQuarterlyRearrestChecks job = new jobCreateQuarterlyRearrestChecks();
        job.createRearrestChecks(null);
    }

}