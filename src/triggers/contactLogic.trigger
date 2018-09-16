trigger contactLogic on Contact (before update, before insert, after insert, after update) {

    contactMethods contactMethods = new contactMethods();
    contactMethods.newContacts = trigger.New;  
    contactMethods.bolInsert = trigger.isInsert;
    
    if(trigger.isUpdate) {
        contactMethods.setContactIds = trigger.newMap.keySet();         
        contactMethods.oldContacts = trigger.Old;
        contactMethods.getMap();
    }
    
    if(Trigger.isBefore) {
    
        // 10/5/12 MB: set the Client Status field based on Program Exit Type for CJC and JS clients
        contactMethods.setNonCEPClientStatus(); 
        contactMethods.setClientStatusfromCycle();
        contactMethods.setCEPClientStatus();
        contactMethods.setPCIdAdmin();
        
        if(Trigger.isInsert) {
            
            contactMethods.setDefaultLeader();
        } 
            
    } else if(Trigger.isAfter) {
        
        if(Trigger.isInsert) {
               
            contactMethods.createNonCEPProgramPlan();
        } 
        
        if(Trigger.isUpdate) {
            
            contactMethods.checkForProjectedExitDateChange();
            // 3/15/13 MB: added for prod.a.BT-1116
            // contactMethods.createInitialAlumniSurveyTask();
        }  
        
        contactMethods.createCaseRelationships();    
    } 
}