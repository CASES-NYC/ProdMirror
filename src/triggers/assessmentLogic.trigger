trigger assessmentLogic on Assessment__c (before insert, before update, after insert, after update, after delete) {

    
    if(utilityIds.bolAlumniSurveysAlreadyUpdated != true) {
        
        assessmentTaskRelatedMethods assessMethods = new assessmentTaskRelatedMethods(); 
        
        if(trigger.IsInsert || trigger.IsUpdate) {
            assessMethods.insertedAssessments = trigger.New;
        } else {
            assessMethods.insertedAssessments = trigger.Old;
        }
        
        assessMethods.getWhoIds();
        
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
            assessMethods.refreshFromContact();
        }
         
        if(Trigger.isAfter) {
            
            assessMethods.setMostRecentAlumniSurvey();  
            assessMethods.updateMHFlags();      
            
            if(Trigger.isInsert || Trigger.isUpdate) {
                
                assessMethods.getAllRelatedTasks();              
                assessMethods.closeTasks();
                        
                //added 9/28/13 by MB to populate the LSCMI lookup on the Program Plan (for CCM)
                assessMethods.setLSCMIandWRNALookups();             
                assessMethods.updateAllRelatedTasks();          
            }
        }
    }
}