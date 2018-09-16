global class jobEmailMHSAReferrals_Scheduler  implements Schedulable{
    
    global static string scheduleJob(string runTime) {
        
        jobEmailMHSAReferrals_Scheduler j = new jobEmailMHSAReferrals_Scheduler();
        return system.schedule('MH/SA Appointments missing Referrals for Jessica', runTime ,j);
    }
    
    
    global void execute(SchedulableContext ctx) {
       
        jobEmailMHSAReferrals job = new jobEmailMHSAReferrals();
        job.findAppointments(system.today());
    }   

}