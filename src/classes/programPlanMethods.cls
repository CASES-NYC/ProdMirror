public with sharing class programPlanMethods {

    public utilityIds util = new utilityIds();
    
    // Method called to lock the record
    // and redirect to the record

    public PageReference lockRecord() {
        
        String recordId = ApexPages.currentPage().getParameters().get('id');
        
        if(recordId != null) {
            
            list<Program_Plan__c> lstProgramPlans = [Select Id, 
                                                    Client_name__c,
                                                    Program_Plan_locked__c, 
                                                    Program_Plan_Completed_by__c,
                                                    Program_Plan_Completed_On__c, 
                                                    RecordTypeId, //Initial_Objectives__c,
                                                    (select id, Goal__c, Other_Goal__c from Goals__r)
                                                    From Program_Plan__c where Id = :recordId];
            list<Id> lstContactIds = new List<Id>();
            
            for(Program_Plan__c p: lstProgramPlans) {
                
                lstContactIds.add(p.client_name__c);
            }

            
            lockProgramPlan(lstProgramPlans);
            closeAssociatedTask( lstContactIds);
            
            //// reload the page
            PageReference newPage = new PageReference('/' + recordId);
            newPage.setRedirect(true);
            return newPage;
                    
        } else {    
            return null;
        }
    }
    
    public void lockProgramPlan(List<Program_Plan__c> lstProgramPlans) {
        
        // Flip the record type to the locked one
                                               
        for(Program_Plan__c pp: lstProgramPlans) {
            pp.recordTypeId =   util.programPlanLockedRecordType;
            pp.Program_Plan_locked__c = true;
            pp.Program_Plan_Completed_On__c = System.Today();
            pp.Program_Plan_Completed_by__c = UserInfo.getUserId();
            /*pp.Initial_Objectives__c = null;
            for(Goal__c g: pp.Goals__r) {
                
                if(pp.Initial_Objectives__c != null) {
                    
                    pp.Initial_Objectives__c += ', ' + (g.Goal__c == 'Other'?g.Other_Goal__c:g.Goal__c);
                } else {
                    pp.Initial_Objectives__c = (g.Goal__c == 'Other'?g.Other_Goal__c:g.Goal__c);
                }
            }*/
        }                                                 
    
        update lstProgramPlans; 
        
    }
    
    public void closeAssociatedTask(List<Id> lstcontactIds) {
        
        list<Task> lstprogramPlanTasks = [Select    Id,
                                        Status,
                                        ActivityDate,
                                        Closing_Date__c,
                                        Closed_By_System__c,
                                        SkipRestrictions__c
                                        From Task
                                        Where WhoId in :lstcontactIds
                                        AND recordTypeId = :util.initialProgramPlanTask
                                        AND isClosed = false];
                    
        for(Task programPlanTask: lstprogramPlanTasks) {
            
            if(System.Today()  <= programPlanTask.ActivityDate ) {
                
                programPlanTask.Status = 'Done on Time';        
            } else {
                
                programPlanTask.Status = 'Done Late';
            }
            
            programPlanTask.Closing_Date__c = System.Today();
            programPlanTask.Closed_By_System__c = true;
            programPlanTask.SkipRestrictions__c = true; 
        }
                    
        update lstprogramPlanTasks;                         
    
    }
    
    public void setMostRecentProgramPlan(List<Program_Plan__c> lstNewPlans) {
        
        list<Id> lstContactIds = new list<Id>();       
        
        for(Program_Plan__c p: lstNewPlans) {
            
            lstContactIds.add(p.Client_Name__c);
        }
        
        list<Contact> lstContacts = [select Id, Most_Recent_Program_Plan__c,
                                            (select Id, CreatedDate
                                            from Program_Plans__r order by CreatedDate asc) 
                                            from Contact where Id in :lstContactIds];
        
        Program_Plan__c mostRecentPlan = new Program_Plan__c();
                                            
        for(Contact c: lstContacts) {
            
            mostRecentPlan = new Program_Plan__c();
            
            for(Program_Plan__c currentPlan: c.Program_Plans__r) {
                            
                MostRecentPlan = currentPlan;
            }
            
            c.Most_Recent_Program_Plan__c = mostRecentPlan.Id;
        }                                   
        
        update lstContacts;
    }
    
    public void setDOHMHDiagnosisFields(List<Program_Plan__c> lstProgramPlans) {
    
        for(Program_Plan__c pp: lstProgramPlans) {
        
            if(pp.Current_Diagnosis_New__c != null) {
                pp.Current_Diagnosis_for_DOHMH__c 
                    = pp.Current_Diagnosis_New__c.replaceAll('[A-z]|[ ]|[(]|[/]|[-]', '').replace(';','').replace(')',';');
            } else {
                pp.Current_Diagnosis_for_DOHMH__c = null;
            }
            
            if(pp.Jail_Based_Diagnosis_New__c!= null) {
                pp.Jail_Based_Diagnosis_for_DOHMH__c 
                    = pp.Jail_Based_Diagnosis_New__c.replaceAll('[A-z]|[ ]|[(]|[/]|[-]', '').replace(';','').replace(')',';');
            } else {
            
                pp.Jail_Based_Diagnosis_for_DOHMH__c = null;
            }            
        }
    }
}