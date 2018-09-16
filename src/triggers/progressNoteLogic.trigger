trigger progressNoteLogic on Progress_Note__c (before insert, before update, after insert) {

    progressNoteMethods clsPNotes = new progressNoteMethods();
    clsPNotes.lstNotes = Trigger.New;
    clsPNotes.bolInsert = Trigger.isInsert;
    
    if(trigger.isUpdate) {
        
        clsPNotes.lstOldNotes = Trigger.Old;
    }
    
    if(trigger.isBefore) {
    
        clsPNotes.setHashtags();
    
        if(trigger.isInsert) {
            
            clsPNotes.setIncidentReportField();
            clsPNotes.blockManualGroupNoteCreation();
        }
    
    }
    
    if(trigger.isAfter && trigger.isInsert) {
        
        clsPNotes.closeTasks();
    
    }
}