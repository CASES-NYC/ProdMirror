trigger scheduleLogic on Schedule__c (before insert, before update, before delete, after insert, after update) {

    public scheduleMethods clsSchedule = new scheduleMethods();

    
    if(trigger.isBefore) {
        
        // Ongoing Schedule Auto-Extend Check
        if(trigger.isUpdate) { clsSchedule.autoExtendOngoingSchedule(trigger.new); }
        
        // History Tracking
        if(trigger.isInsert) { clsSchedule.createSchedule(trigger.new); }
        if(trigger.isInsert) { clsSchedule.trackOriginalDates(trigger.new); }
        
        // Schedule Updating
        if(trigger.isUpdate) { clsSchedule.modifySchedule(trigger.new); }
        
        // Schedule Deleting
        if(trigger.isDelete) { clsSchedule.deleteSchedule(trigger.old); }
        
    }


    // Main Schedule Processing
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        
        clsSchedule.createScheduleSessions(trigger.new);
        
    }

}