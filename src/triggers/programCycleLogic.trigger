trigger programCycleLogic on Program_Cycle__c (after delete, after insert, after update) {
    
    programCycleMethods pcMethods = new programCycleMethods();
    
    if(trigger.isInsert) {
        pcMethods.lstNewPCs = trigger.new;
    } else {
        pcMethods.lstNewPCs = trigger.Old;
    }
    
    //shared data for all methods
    pcMethods.getContacts();
    
        
    /*if(trigger.isDelete) {
        
        pcMethods.deleteChildTiers(Trigger.oldMap.keySet());
    }*/
            
    pcMethods.setMostRecentFlag();
}