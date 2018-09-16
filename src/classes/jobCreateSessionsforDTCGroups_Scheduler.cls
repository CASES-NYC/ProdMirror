global class jobCreateSessionsforDTCGroups_Scheduler  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobCreateSessionsforDTCGroups_Scheduler j = new jobCreateSessionsforDTCGroups_Scheduler();
        return system.schedule('Create DTC Sessions', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobCreateSessionsforDTCGroups job = new jobCreateSessionsforDTCGroups();
        job.createSessions(100);
    }   

}