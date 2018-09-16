trigger taskLogic on Task (before insert, before update, 
after update, after insert, after delete, after undelete) {

    taskMethods taskMethods = new taskMethods();
    //programStages clsProgramStages = new programStages();
    public utilityIds utilIds = new utilityIds();
    
    taskMethods.lstNewTasks = trigger.New;
    Set<Id> whoIds = new Set<Id>();
    
    
    // if tasks are set to "skip triggers" via data loader
    // and current user is sysAdmin, don't run any triggers
    
    if(userInfo.getProfileId() == utilIds.systemAdmin
    && utilityIds.bolSkipTriggersAlreadyChecked != true) {
        if(Trigger.isInsert || trigger.isUpdate) {
            for(task t: trigger.New) {
                
                if(t.Skip_Triggers__c == true) {
                    
                    utilityIds.bolSkipTaskTriggers = true;
                    break;          
                }       
            }       
        }
        
        if(Trigger.isDelete) {
            for(task t: trigger.Old) {
                
                if(t.Skip_Triggers__c == true) {
                    
                    utilityIds.bolSkipTaskTriggers = true;
                    break;          
                }       
            }
        }
        
        utilityIds.bolSkipTriggersAlreadyChecked = true;
    }
    
    if(utilityIds.bolSkipTaskTriggers != true) {
    
        if(trigger.isBefore) {
            
            taskMethods.mapUnit();
            
            if(trigger.isInsert) {
                
                taskMethods.modifyChoices30DayDetainedTask();
                taskMethods.modifyRearrestCheckTask();
                taskMethods.manualTaskCreationUpdates();
                taskMethods.getExistingStarTests();
                taskMethods.starTestCreation(); 
                //taskMethods.resetSkipRestrictions();
                //clsProgramStages.createStageRecord(trigger.new, null, null, null);
            }
        
            if(trigger.isUpdate) {
                
                
                taskMethods.lstOldTasks = trigger.Old;
                taskMethods.areEditsAcceptable();
                taskMethods.closeTasksManually();
                //taskMethods.resetSkipRestrictions();      
            }
            
            taskMethods.resetSkipRestrictions();   
        }
        
        
        if(trigger.isAfter) {
            
            /*
            //////////////////////////////
            // Career Ex
            //////////////////////////////
            if(trigger.isUpdate) {
                taskMethods.lstOldTasks = trigger.Old;
                taskMethods.checkForCareerExStage();
            }*/
            
            //////////////////////////////
            // Re-arrest checks
            //////////////////////////////      
            
            if (Trigger.isInsert || Trigger.isUnDelete || Trigger.isUpdate){
                for (Task t : Trigger.new){
                    //if this is a rearrest check that's completed
                    if ((t.RecordTypeId == '0126000000053xp' && t.Status == 'Completed')
                        || (Trigger.oldMap != null &&Trigger.oldMap.get(t.Id) != null &&t.RecordTypeId == '0126000000053xp'
                             &&Trigger.oldMap.get(t.Id).Status == 'Completed' &&t.Status != 'Completed')
                    ){
                        //Add the client to the set
                        String s = t.WhoId;
                        if (t.WhoId != null && s.substring(0,3) == '003'){
                            whoIds.add(t.whoId);
                        }
                    }
                    System.debug('t.RecordTypeId  ' +t.RecordTypeId );
                    if (((t.RecordTypeId == '012T0000000CvIg' || t.RecordTypeId == '012600000005DUG') && t.Status == 'Completed')
                        ||(Trigger.oldMap != null &&Trigger.oldMap.get(t.Id) != null &&(t.RecordTypeId == '012T0000000CvIg' || t.RecordTypeId == '012600000005DUG')
                             &&Trigger.oldMap.get(t.Id).Status == 'Completed' &&t.Status != 'Completed')
                    ){
                        //Add the client to the set
                        String s = t.WhoId;
                        System.debug('Substring = ' +s.substring(0,3));
                        if (t.WhoId != null && s.substring(0,3) == '003'){
                            whoIds.add(t.whoId);
                        }
                    }
                }
            }
            
            if (Trigger.isDelete){
                for (Task t : Trigger.old){
                    //if this was a rearrest check that's completed
                    if (t.RecordTypeId == '0126000000053xp' && t.Status == 'Completed'){
                        //Add the client to the set
                        String s = t.WhoId;
                        if (t.WhoId != null && s.substring(0,3) == '003'){
                            whoIds.add(t.whoId);
                        }
                    }
                    if ((t.RecordTypeId == '012T0000000CvIg' || t.RecordTypeId == '012600000005DUG') && t.Status == 'Completed'){
                        System.debug('Adding contact to list for CBO Placement task deletion');
                        //Add the client to the set
                        String s = t.WhoId;
                        if (t.WhoId != null && s.substring(0,3) == '003'){
                            whoIds.add(t.whoId);
                        }
                    }
                }
            }
            
            list<Contact> lstContactsForUpdate = new list<Contact>(); 
            
            if (whoIds.size() > 0){
                List<Contact> lstClients = [Select Id, Last_Completed_Rearrest_Check__c, CBO_Placement_at_Exit__c, 
                        (Select Id, WhoId, RecordTypeId, ActivityDate, Status, Re_arrest_Check_Completed_On__c from Tasks where 
                        (RecordTypeId = '0126000000053xp' or RecordTypeId = '012T0000000CvIg' or RecordTypeId = '012600000005DUG') 
                        and Status = 'Completed' order by ActivityDate)
                        from Contact where Id IN: whoIds];

                for (Contact c : lstClients){
                    Date dte;
                    Boolean isCBOPlace = false;
                    for (Task t : c.Tasks){
                        if (t.WhoId == c.Id &&t.RecordTypeId == '0126000000053xp' && t.Status == 'Completed'){
                            dte = t.Re_arrest_Check_Completed_On__c;
                        }
                        if (t.WhoId == c.Id &&(t.RecordTypeId == '012T0000000CvIg' || t.RecordTypeId == '012600000005DUG')
                            && t.Status == 'Completed'
                        ){
                            isCBOPlace = true;
                        }
                    }
                    
                    if(c.Last_Completed_Rearrest_Check__c != dte || c.CBO_Placement_at_Exit__c != isCBOPlace) {
                    	
                    	c.Last_Completed_Rearrest_Check__c = dte;
                    	c.CBO_Placement_at_Exit__c = isCBOPlace;
                    	lstContactsForUpdate.add(c);	
                    }
                }
                update lstContactsForUpdate;
            }
        }
    }
}