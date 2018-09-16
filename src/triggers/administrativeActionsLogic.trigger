trigger administrativeActionsLogic on Administrative_Actions__c 
(before insert, before update, after insert, after update, after delete, after undelete) {

    if(trigger.isInsert || trigger.isUpdate) {
        administrativeActionMethods administrativeActionLogic = new administrativeActionMethods();
        administrativeActionLogic.newAdministrativeActions = Trigger.new;
        administrativeActionLogic.oldAdministrativeActions = Trigger.old;
        administrativeActionLogic.isInsert = Trigger.isInsert;
        administrativeActionLogic.clientToStatus();
        
        
        if(Trigger.isBefore) {
            
         
            // 2/13/13 MB: This class removed and its contents incorporporated into administrativeActionLogic.blockInvalidAdministrativeActions
            //classAdminActionValidation.AAValidation(Trigger.new); //added 2/1/13 by MB, moved from TriggerAdminActionInsertBefore     
            if(trigger.isInsert) { // 8/7/14 MB only run on insert or contact will overwrite value
                administrativeActionLogic.setAAFieldValues(); // added 2/12/13 by MB
            }
            administrativeActionLogic.clientStatusValidation();
            if(trigger.isUpdate) {
                administrativeActionLogic.validateApproval();
            }
            administrativeActionLogic.updateCBOClosingDate();
            administrativeActionLogic.massDML();
        }
                
        if(Trigger.isAfter) {
               
            System.Debug('CEP_administrativeActionsLogic.isAfter TRIGGER INFO:  Starting isAfter');

            //administrativeActionLogic.setClientandEventStatus(); 
            administrativeActionLogic.processReintake();
            administrativeActionLogic.processReinstatement();                  
            administrativeActionLogic.processExtension();
            administrativeActionLogic.processExitNotification();
            //administrativeActionLogic.setExitNotificationTaskDates();
            administrativeActionLogic.massDML();
           
            System.Debug('CEP_administrativeActionsLogic.isAfter TRIGGER INFO:  Ending isAfter');
        }
    }
    
    // added 2/1/13 by MB, code moved from TriggerAdminActionDeleteUnAfter
    if(trigger.isDelete || trigger.isUnDelete) {
                
        Set<Id> clientIds = new Set<Id>();
        
        if (Trigger.IsDelete){
            for (Administrative_Actions__c a : Trigger.old){
                clientIds.add(a.Client__c);
                
             }
        } else {
            //for recovered (undelete) admin actions
            for (Administrative_Actions__c a : Trigger.new){
                clientIds.add(a.Client__c);
                
             }
        }
         
        //ClassClientStatus.SetClientStatus(clientIds,true);      
    }
                
}