trigger classLogic on Class__c (before insert, before update, before delete) {

    ///////////////////////////////////////////
    // This method manages Classes
    // Author:  AAB / DCS
    // Created:  20110418
    ///////////////////////////////////////////
    public classMethods clsClassMethods = new classMethods();
    
    // Class Creation
    if(trigger.isInsert && trigger.isBefore) {
        clsClassMethods.classReporting(trigger.new);
        clsClassMethods.createClass(trigger.new);
    }
    
    // Class Edit
    if(trigger.isUpdate && trigger.isBefore) {
        clsClassMethods.editClass(trigger.new);
        clsClassMethods.classReporting(trigger.new);
    }

    // Class Deletion
    if(trigger.isDelete && trigger.isBefore) {
        clsClassMethods.deleteClass(trigger.old);
    }

}