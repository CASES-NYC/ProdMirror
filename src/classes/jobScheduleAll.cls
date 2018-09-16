public class jobScheduleAll {

    public void scheduleAll() {
        
        jobAutoExtendSchedule_Scheduler job = new jobAutoExtendSchedule_Scheduler();  
        system.schedule('Course Registration Ongoing Auto-Extender','0 15 23 1-31 1-12 ? *', job); 
        
        jobCloseSTARTCycles_Scheduler job2 = new jobCloseSTARTCycles_Scheduler();  
        system.schedule('Close START Cycles','0 30 23  1-31 1-12 ? *',job2);
        
        jobCreateQuarterlyRearrest_Scheduler job3 = new jobCreateQuarterlyRearrest_Scheduler();  
        system.schedule('Quarterly Rearrest Tasks','0 25 23 L 3,6,9,12 ? *',job3);
        
        jobCreateSessionsforDTCGroups_Scheduler job4 = new jobCreateSessionsforDTCGroups_Scheduler();  
        system.schedule('Create DTC Groups','0 30 3  1-31 1-12 ? *',job4);
        
        jobUpdateNumberofDaysinCycle_Scheduler job5 = new jobUpdateNumberofDaysinCycle_Scheduler();   
        system.schedule('Update Days in Cycle','0 15 1 1-31 1-12 ? *',job5);
        
        jobUpdateNumberofDaysinProgram_Scheduler job6 = new jobUpdateNumberofDaysinProgram_Scheduler();   
        system.schedule('Update Days in Program','0 45 0 1-31 1-12 ? *',job6);
        
        jobUpdateTodayField_Scheduler job7 = new jobUpdateTodayField_Scheduler();   
        system.schedule('Set Today field','0 10 0 1-31 1-12 ? *',job7);     
        
        jobProgramReportingMaxDate_Scheduler job8 = new jobProgramReportingMaxDate_Scheduler();   
        system.schedule('Calculate Max/Min Appointments','0 10 22 1-31 1-12 ? *',job8); 
        
        jobEmailMHSAReferrals_Scheduler job9 = new jobEmailMHSAReferrals_Scheduler();   
        system.schedule('MH/SA Appts missing Referrals for Jessica','0 45 22 1-31 1-12 ? *',job9);  
        
        jobCreateProgramStages_Scheduler job10 = new jobCreateProgramStages_Scheduler();   
        system.schedule('Create Program Stages','0 45 23 1-31 1-12 ? *',job10);     
        
        jobSetCIRTPRDates_Scheduler job11 = new jobSetCIRTPRDates_Scheduler();   
        system.schedule('Update CIRT Program Relationship Dates','0 30 02 1-31 1-12 ? *',job11);    
        
        jobCalculateInsuranceFields_Scheduler job12 = new jobCalculateInsuranceFields_Scheduler();   
        system.schedule('Calculate Insurance Fields','0 45 02 1-31 1-12 ? *',job12);                                       
    }

}