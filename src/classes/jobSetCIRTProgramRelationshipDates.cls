global class jobSetCIRTProgramRelationshipDates {

    global utilityIDs utilIDs = new utilityIDs();
    
    global void setAppointmentDates(date dteStart, date dteEnd) {
        
        list<Id> lstPRIds = new list<Id>();
        list<Program_Relationships__c > lstPRstoProcess = new list<Program_Relationships__c >();
        
        list<Event> lstUpdatedEvents = [select id, whatId from Event
                                        where RecordTypeId = :utilIDs.apptCIRTExternal
                                        and LastModifiedDate >= :dteStart and LastModifiedDate <= :dteEnd];
                                        
        list<Event> lstDeletedEvents = [select id, whatId, RecordTypeId from Event 
                                        where RecordTypeId = :utilIDs.apptCIRTExternal
                                        and isDeleted = true ALL ROWS];                         
                                        
        for(Event e: lstUpdatedEvents) {
            
            lstPRIds.add(e.whatId);
        }   
        
        for(Event e: lstDeletedEvents) {
            
            lstPRIds.add(e.whatId);
        }                                   
        
        lstPRstoProcess = [select id, X1st_appointment_date__c, X2nd_appointment_date__c, X6th_appointment_date__c,
                            (select id, ActivityDate from Events 
                            where Verification_Status__c in ('Attended','Late')
                            and IsDeleted = false
                            order by ActivityDateTime asc)
                            from Program_Relationships__c where id in :lstPRIds];
                            
        for(Program_Relationships__c pr: lstPRstoProcess){
            
            //clear values
            pr.X1st_appointment_date__c = null;
            pr.X2nd_appointment_date__c = null;
            pr.X6th_appointment_date__c = null;
            
            if(pr.Events.size() > 0) {
                
                pr.X1st_appointment_date__c = pr.Events[0].ActivityDate;
            }
            
            if(pr.Events.size() > 1) {
                
                pr.X2nd_appointment_date__c = pr.Events[1].ActivityDate;
            }
            
            if(pr.Events.size() > 5) {
                
                pr.X6th_appointment_date__c = pr.Events[5].ActivityDate;
            }                       
        }   
        
        update lstPRstoProcess;             
    }

}