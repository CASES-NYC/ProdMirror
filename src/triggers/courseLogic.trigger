trigger courseLogic on Course__c (after insert, after update) {
    
    public courseMethods clsCourseMethods = new courseMethods();
    clsCourseMethods.lstCourses = trigger.New;
    
    if(trigger.isUpdate && trigger.isAfter) {
        
        clsCourseMethods.updateClassAttributes();
        
    } else if (trigger.isInsert && trigger.isAfter) {
        
        clsCourseMethods.createDummyClass();
    }

}