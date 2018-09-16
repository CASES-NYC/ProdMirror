trigger detainedDatesMethodsLogic on Detained_Dates__c (before insert, before update, after insert, after update, after delete) {

    detainedDatesMethods ddLogic = new detainedDatesMethods();
    
    if(trigger.isInsert || trigger.isUpdate) {
        
        ddLogic.newDetainedDates = Trigger.new;
        ddLogic.oldDetainedDates = Trigger.old;
    } else if (trigger.isDelete) {
        
        ddLogic.newDetainedDates = Trigger.old;
    }

    if (trigger.isBefore) {
        
        if(trigger.isInsert) {
            ddLogic.checkForOpenEndedRecordsInsert();
        }
    
        if (trigger.isUpdate) {
            ddLogic.checkForOpenEndedRecordsUpdate();
        }
    }
    
    if (trigger.isAfter) {
            
        // Check to place client on hold if detained
        //ddLogic.checkForClientDetained();     
        ddLogic.updateContacts();       
    }
}