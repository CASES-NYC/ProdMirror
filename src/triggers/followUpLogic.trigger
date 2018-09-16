trigger followUpLogic on FollowUp__c (after insert, after update, after delete) {
    
    utilityIds utilIds = new utilityIds();
    programRelationshipMethods pr = new programRelationshipMethods();   
    
    Id[] lstPRIds = new Id[]{};
    
    if(trigger.isInsert || trigger.isUpdate) {
    
        for (FollowUp__c fu : Trigger.new) {
            
          if(fu.RecordTypeId == utilIds.FollowUpReferral) { // non PRP logic
            
            lstPRIds.add(fu.Program_Relationships__c);
          }
            
        }
    } else if (trigger.isDelete) {
        
        for (FollowUp__c fu : Trigger.old) {
            
          if(fu.RecordTypeId == utilIds.FollowUpReferral) { // non PRP logic
            
            lstPRIds.add(fu.Program_Relationships__c);
          }
        }
    }
    
    if(lstPRIds.size() > 0) {
        pr.updateProgRelNonPRP(lstPRIds);
    }
    
}