trigger programPlanLogic on Program_Plan__c (before insert, before update, after delete, after insert, after undelete) {

    programPlanMethods ppMethods = new programPlanMethods();
    
    if(trigger.isBefore) {
    
        ppMethods.setDOHMHDiagnosisFields(Trigger.New);
    } else if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUnDelete) {
            
            ppMethods.setMostRecentProgramPlan(trigger.New);
        }
        
        else if(trigger.isDelete) {
            
            ppMethods.setMostRecentProgramPlan(trigger.Old);
        }
    }

}