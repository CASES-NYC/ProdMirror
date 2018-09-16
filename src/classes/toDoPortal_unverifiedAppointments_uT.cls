@isTest(seeAllData=true)
private class toDoPortal_unverifiedAppointments_uT {
 
    static testMethod void displayEvent(){
            
            utilityIds UTILITY = new utilityIds();
            
            //Test was failing due to too many queries. Don't need to create clients, there are plenty in production
            
            User adminUser = [Select Id, Unit__c from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
            
            Contact testingCEP = [select Id from Contact where Client_Status__c = 'Active' limit 1];
            
            /// Add a dummy event
            
            Event thisEventDummy1 = new Event();
            thisEventDummy1.RecordTypeId = UTILITY.educationExternal;
            thisEventDummy1.Subject = 'College Participation';
            thisEventDummy1.whoId = testingCEP.Id;
            thisEventDummy1.DurationInMinutes = 60;
            thisEventDummy1.ActivityDateTime = System.now();
            thisEventDummy1.ActivityDate = Date.today();
            thisEventDummy1.Verification_Status__c  =  'Not Verified';
            thisEventDummy1.Verification_Due_Date__c  = System.Today().addDays(4);
            insert thisEventDummy1;
            
            
            
            Test.startTest();
            
            toDoPortal_unverifiedAppointments unverifiedAppointmentsTest = new toDoPortal_unverifiedAppointments();
            unverifiedAppointmentsTest.DISPLAYED_UNVERIFIED_EVENTS = new List<toDoPortal_unverifiedAppointments.DisplayedEvent>();
            unverifiedAppointmentsTest.DISPLAYED_UNVERIFIED_EVENTS.add(new toDoPortal_unverifiedAppointments.DisplayedEvent(thisEventDummy1,adminUser,UTILITY));
            unverifiedAppointmentsTest.getCaseloadOptions();
            unverifiedAppointmentsTest.SaveFilter();
            unverifiedAppointmentsTest.UpdateEvents();
            
             Test.stopTest();
             
    }      
    
    static testMethod void searchForEvents(){     
    
            utilityIds UTILITY = new utilityIds();
                
            User ccUser = [Select Id, Unit__c from User Where isActive = true 
                and ProfileID = :UTILITY.caseCoordinatorStaff  Limit 1];
                
            toDoPortal_unverifiedAppointments unverifiedAppointmentsTest = new toDoPortal_unverifiedAppointments();                

            // Going to test all the controls on the page now         
               
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Due_date_from__c = System.Today().addDays(-1);
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Due_date_to__c = System.Today().addDays(1);
        
            // Caseload 
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Filter_By__c = 'Caseload'; 
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Caseload__c = ccUser.Id;
            unverifiedAppointmentsTest.getUnverifiedEvents();
            
            Test.startTest();  
            
            // Unit
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Filter_By__c = 'Unit'; 
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Unit__c = 'Education'; 
            unverifiedAppointmentsTest.getUnverifiedEvents();
            
            // Staff
            
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Filter_By__c =  'Staff';          
            unverifiedAppointmentsTest.APPOINTMENT_FILTER.Unverified_Appointments_Staff__c = ccUser.Id;
            unverifiedAppointmentsTest.getUnverifiedEvents();
            
            Test.stopTest();
    }
}