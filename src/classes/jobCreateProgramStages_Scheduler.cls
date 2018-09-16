global class jobCreateProgramStages_Scheduler  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobCreateProgramStages_Scheduler j = new jobCreateProgramStages_Scheduler();
        return system.schedule('Create Program Stages', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobCreateProgramStages job = new jobCreateProgramStages();
        job.main(system.today().addDays(-1), system.today().addDays(2));
    }    

}