trigger testLogic on Test__c (after insert , before insert, before update, after update, after delete) {

    testMethods testM = new testMethods();
    UtilityMethods utilMethods = new utilityMethods();
    
    if(trigger.isInsert || trigger.isUpdate) {
        testM.insertedTests = trigger.New;
        utilMethods.lstUpdatedTest = trigger.New;
    } else {
        utilMethods.lstUpdatedTest = trigger.Old;
        testM.insertedTests = trigger.Old;      
    }
            
    testM.getWhoIds(); 
    
    if(Trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        
        testM.processTestSummary();
    }
    
    if(trigger.isAfter) {
        
        if(trigger.IsInsert || trigger.isUpdate) {

            //testM.getAllRelatedTasks();
            //testM.processMAYSIinsert(); 
            testM.processDrugTestinsert();
            testM.processGEDinsert();
        }
        
        testM.processSTARorTABE();
        utilMethods.updateDiplomaFieldsOnContact();
        testM.updateAllRelatedTasks();
    }
}