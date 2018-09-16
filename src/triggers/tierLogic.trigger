trigger tierLogic on Tier__c (after delete, before insert, after insert) {

    tierMethods tierMethods = new tierMethods();
    
    //create list of Program Cycle Ids
    if(trigger.isInsert) {
            
        for(Tier__c t: trigger.New) {
            
            tierMethods.lstPCIds.add(t.Program_Cycle__c);
        }
    } else if (trigger.isDelete) {
        for(Tier__c t: trigger.Old) {
            
            tierMethods.lstPCIds.add(t.Program_Cycle__c);
        }
    }

    //set most recent flag
    if(trigger.isAfter) {       
        
        if( trigger.isInsert || trigger.isDelete) {
                    
            tierMethods.setMostRecentFlag();
        }
    }
    
    //set contact lookup
    if(trigger.isBefore) {
        if( trigger.isInsert) {
            
            tierMethods.lstTiers = trigger.New; 
            tierMethods.setContact();
        }
    }

}