global class jobProgramReportingMaxDate_Scheduler  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobProgramReportingMaxDate_Scheduler j = new jobProgramReportingMaxDate_Scheduler();
        return system.schedule('Calculate Max/Min Appointments', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobProgramReportingMaxDate job = new jobProgramReportingMaxDate();
        job.calculate();
    } 

}