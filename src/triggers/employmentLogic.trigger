trigger employmentLogic on Employment__c (after insert, after update, after delete) {

    employmentMethods empLogic = new employmentMethods();
    
    if (trigger.isInsert || trigger.isUpdate) {
        empLogic.newEmployments = Trigger.new;
        empLogic.updateContactEmploymentSection();
    }

    //20120913 ebg - added check for deletion
    if (trigger.isDelete) {
        empLogic.newEmployments = Trigger.old;
        empLogic.updateContactEmploymentSection();
    }

}