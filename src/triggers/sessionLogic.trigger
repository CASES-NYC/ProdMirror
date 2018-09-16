trigger sessionLogic on Session__c (after insert, after update, before delete) {
    
    public sessionMethods clsSession= new sessionMethods();
    
    if(trigger.isAfter) {
        
        if(trigger.isInsert) {
            
            // Create Events for clients currently enrolled in a Class - new Session creation
            clsSession.additionalSessionEnrollments(trigger.new);
        }
        
        if(trigger.isUpdate) {
            
            // Update Events for clients currently enrolled in a Class
            //20110819 ebg - in the grading and verification functionality, sometimes the session is updated and we
            //              don't want to modify any of the enrollment events.  Need to revisit this portion.
            //              * When the session.Cancelled_c = true we want to update all enrollment event.Verification_Status__c = 'Cancelled'
            //              * When the session.Group_Note__c is updated we want to create a group process note or update existing group progress note for the client/session combination
            //              -- these two pieces of functionality currently reside in courseGrading.cls 
            
            //20111021 ebg/dcs - if the start or end date changed, delete events from the session and then recreate them
            List<Session__c> lstSession = new List<Session__c>();
            Integer i = 0;
            for (Session__c s : trigger.new) {
                if (s.Session_Start__c != trigger.old[i].Session_Start__c || s.Session_End__c != trigger.old[i].Session_End__c) {
                    lstSession.add(s);
                }
                i++;
            }
            if (lstSession.size() > 0) {
                clsSession.deleteSessionEvents(lstSession);
                clsSession.additionalSessionEnrollments(lstSession);
            }
            
        }
        
    }
    
    // Delete Related Events
    if(trigger.isBefore && trigger.isDelete) {
        
        clsSession.deleteSessionEvents(trigger.old);
        
    }

}