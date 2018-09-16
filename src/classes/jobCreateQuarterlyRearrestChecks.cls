global class jobCreateQuarterlyRearrestChecks {
    
    global utilityIds utilIds = new utilityIds();
    global Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
    
    global void createRearrestChecks(date dteEndofQuarter) {
        
        list<Task> lstTaskstoCreate = new list<Task>();
        Task t = new Task();
        Integer intDaysinProgram = 0;
        
        if(dteEndofQuarter == null) {
            
            dteEndofQuarter = system.today();
        }
        
        //all CEP, ACT, DTC, and CCM that were active on the last day of the last quarter
        //get tasks that are open or were closed since the end of the quarter to avoid creating dupes
        list<Contact> lstContacts = [select id, RecordTypeId, Current_Intake_Date__c, 
            Intake_Date__c, Current_Exit_Date__c,
            (select id from Tasks where Subject = 'Rearrest Check - Quarterly' and 
            ActivityDate = :dteEndOfQuarter.addDays(7) and
            (isClosed = false or Re_arrest_Check_Completed_On__c >= :dteEndofQuarter)),
            (select id, Start_Date__c, End_Date__c, Cycle_Type__c from Program_Cycles__r 
            where Start_Date__c <= :dteEndofQuarter
            order by Start_Date__c asc)
            from Contact
            where ((RecordTypeId in (:utilIDs.conClient, :utilIDs.conDTC, :utilIDs.conCCM)
            and Current_Intake_Date__c <= :dteEndofQuarter)
            or (RecordTypeId = :utilIDs.conACT and Intake_Date__c <= :dteEndofQuarter))
            and Do_Not_Bill__c != true
            and (Current_Exit_Date__c = null or Current_Exit_Date__c >= :dteEndofQuarter)];
        
        for(Contact c: lstContacts) {
            
            intDaysinProgram = 0;
            
            if(c.RecordTypeId == utilIds.conClient || c.RecordTypeId == utilIds.conACT) {
                
                intDaysinProgram = 1 + c.Intake_Date__c.daysBetween(dteEndOfQuarter);
                
            } else {
                    
                for(Program_Cycle__c pc: c.Program_Cycles__r) {
                    
                    if(pc.Cycle_Type__c == 'Voluntary') {
                        
                        //if the cycle active at the end of the quarter is voluntary, then no task
                        intDaysinProgram = 0;
                    
                    } else if(pc.End_Date__c == null || pc.End_Date__c > dteEndofQuarter) {
                        
                        intDaysinProgram += 1+pc.Start_Date__c.daysBetween(dteEndofQuarter);
                    } else {
                        intDaysinProgram += 1+pc.Start_Date__c.daysBetween(pc.End_Date__c);
                    }
                }
            }
            
            if(intDaysinProgram < 15) {
                
                //do nothing if client has been in the program less than 15 days
            }
        
            else if(c.Tasks.size() > 0) {
                
                //do nothing if task already exists
            } else {
                
                t = new Task();
                t.whoId = c.Id;
                t.RecordTypeId = utilIds.rearrestCheckTask;
                t.Subject = 'Rearrest Check - Quarterly';
                t.Open_Date__c = dteEndofQuarter;
                t.ActivityDate = dteEndofQuarter.addDays(7);
                t.Automatically_Generated__c = true;
                t.SkipRestrictions__c = true;
                if(c.RecordTypeId == utilIds.conClient) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CEP__c;
                } else if (c.RecordTypeID == utilIDs.conCCM) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CCM__c;             
                } else if (c.RecordTypeID == utilIDs.conACT) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_ACT__c;             
                } else if (c.RecordTypeID == utilIDs.conDTC) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_DTC__c;             
                } 
                
                lstTaskstoCreate.add(t);
            }
        }
        
        insert lstTaskstoCreate;    
        
    }

}