trigger educationLogic on Education__c (after insert, after update, before delete, after delete) {

    //20120726 ebg: BT-010 - added "after delete" to the trigger declaration
    educationMethods educationInfoLogic = new educationMethods();
    educationInfoLogic.newEducations = Trigger.new;
    UtilityMethods utilMethods = new utilityMethods();
    list<Id> lstEdIds = new list<Id>();
    list<Semester__c> lstSemesterstoDelete = new list<Semester__c>();
    
    
    if (trigger.isInsert || trigger.isUpdate) {
        system.debug('\n\n***Inserting/Updating Education record: ' + Trigger.new);
        educationInfoLogic.updateContactEduEmpSection();
        utilMethods.lstUpdatedEdu = Trigger.new;
        utilMethods.updateDiplomaFieldsOnContact();
        
    }
    
    if (trigger.isDelete) {
        
        // delete related semesters before deleting education to avoid error (because relationship on child is required)
        // deleting semester will trigger deletion of classes as well
            
        if(trigger.isBefore) {
        
            for(Education__c e: Trigger.Old) {
                
                lstEdIds.add(e.id);
            }
            
            lstSemesterstoDelete = [select id from Semester__c where Education__c in :lstEdIds];
            
            if(lstSemesterstoDelete.size()>0) {
                delete lstSemesterstoDelete;
            }
        }           
        
        if(trigger.isAfter) {
            
            system.debug('\n\n***Deleting Education record: ' + Trigger.old);
            educationInfoLogic.newEducations = Trigger.old;
            educationInfoLogic.updateContactEduEmpSection();
            utilMethods.lstUpdatedEdu = Trigger.old;
            utilMethods.updateDiplomaFieldsOnContact();
        }       
    }
}