global class jobSetCIRTPRDates_Scheduler implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobSetCIRTPRDates_Scheduler j = new jobSetCIRTPRDates_Scheduler();
        return system.schedule('Update CIRT Program Relationship Dates', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobSetCIRTProgramRelationshipDates job = new jobSetCIRTProgramRelationshipDates();
        job.setAppointmentDates(date.Today().addDays(-2), date.Today().addDays(1));
    }  

}