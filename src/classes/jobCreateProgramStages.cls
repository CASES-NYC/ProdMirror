global class jobCreateProgramStages {

    global utilityIDs utilIds = new utilityIds();
    
    global void main(date dteStart, date dteEnd) {
        
        //setup and existing stage delete
        list<Task> lstTasksUpdated = new list<Task>();
        list<Event> lstEventsUpdated = new list<Event>();       
        map<String, Id> mapContactIdstoProcess = new map<String, Id>(); 
        list<Program_Stage__c> lstExistingStages = new list<Program_Stage__c>();
        list<Program_Stage__c> lstExistingStagestoDelete = new list<Program_Stage__c>();
        
        //main processing
        list<Program_Stage__c> lstNewStages = new list<Program_Stage__c>();
        map<String, Id> mapStagesAlreadyAdded = new map<String, Id>();  
        list<Task> lstAllTasks = new list<Task>();
        list<Event> lstAllEvents = new list<Event>();   
        List<String> lstStageId = new list<String>();
        String strStageId = '';         
            
        //contact reporting
        list<Contact> lstContactstoUpdate = new list<Contact>();
        
        lstTasksUpdated = [select id, ActivityDate, whoId, Subject, Program_Cycle__c, Status, CreatedDate
        from Task where RecordTypeId = :utilIds.careerExplorationReferralTask
        and LastModifiedDate >= :dteStart and LastModifiedDate <= :dteEnd
        and Program_Cycle__c > 106];
        
        lstEventsUpdated = [select id, ActivityDate, whoId, Subject, Program_Cycle__c, Verification_Status__c, 
        CreatedDate
        from Event 
        where RecordTypeId = :utilIds.courseCatalogClass and Class_Category__c LIKE 'Career Exploration%'
        and LastModifiedDate >= :dteStart and LastModifiedDate <= :dteEnd
        and Program_Cycle__c > 106];     
        
        //get existing stages
        
        for(Task t: lstTasksUpdated) {
            
            mapContactIdstoProcess.put(t.whoId+';'+t.Program_Cycle__c, t.whoId);
        }
        
        for(Event e: lstEventsUpdated) {
            
            mapContactIdstoProcess.put(e.whoId+';'+e.Program_Cycle__c, e.whoId);
        }       
        
        lstExistingStages = [select id, Client_Name__c, Program_Cycle__c from Program_Stage__c 
        where Client_Name__c in :mapContactIdstoProcess.values()
        and Automatically_Generated__c = true];
        
        for(Program_Stage__c ps: lstExistingStages) {
            
            if(mapContactIdstoProcess.containsKey(ps.Client_Name__c+';'+ps.Program_Cycle__c)) {
                
                lstExistingStagestoDelete.add(ps);
            }
        }
        
        //delete existing records
        delete lstExistingStagestoDelete;
        
        
        //find all tasks and events to work with
        lstAllTasks = [select id, ActivityDate, whoId, Subject, Program_Cycle__c, Status, CreatedDate, 
        Closing_Date__c
        from Task where RecordTypeId = :utilIds.careerExplorationReferralTask
        and whoId in :mapContactIdstoProcess.values()];
        
        lstAllEvents = [select id, ActivityDate, whoId, Subject, Program_Cycle__c, Verification_Status__c, 
        CreatedDate, RecordTypeId, Class_Category__c, FirstClassRPT__c, FirstClassSecondWeekRPT__c, LastClassRPT__c ,
        Withdrawn__c
        from Event 
        where RecordTypeId = :utilIds.courseCatalogClass and Class_Category__c LIKE 'Career Exploration%'
        and whoId in :mapContactIdstoProcess.values()]; 
        
        //TASKS
        Program_Stage__c ps1 = new Program_Stage__c();  
        Program_Stage__c ps10 = new Program_Stage__c(); 
        Program_Stage__c ps20 = new Program_Stage__c(); 
        //Stages 1, 10, and 20
        for(Task t: lstAllTasks) {
            
            if(mapContactIdstoProcess.containsKey(t.whoId+';'+t.Program_Cycle__c)) {
                                
                ps10 = new Program_Stage__c();
                ps10.Client_Name__c = t.WhoId;
                ps10.Automatically_Generated__c = true;
                ps10.Program_Cycle__c = t.Program_Cycle__c;
                ps10.Program_Name__c = t.Subject;
                ps10.Stage_Date__c = t.CreatedDate.date();
                ps10.Stage_Id__c = '10.Referred';
                ps10.Source__c = t.id;
                
                // Uppercase and Split for Reporting Fields                 
                strStageId = ps10.Stage_Id__c.toUpperCase();
                lstStageId = strStageId.split('\\.');
                ps10.Stage__c = lstStageId[1];
                ps10.Stage_Number__c = Integer.valueOf(lstStageId[0]);                  
                
                if(!mapStagesAlreadyAdded.containsKey(t.whoId+';'+t.Program_Cycle__c+';'+10)) {
                    mapStagesAlreadyAdded.put(t.whoId+';'+t.Program_Cycle__c+';'+10,t.whoId);
                    lstNewStages.add(ps10);     
                }       
                    
                if(t.Status == 'Done on Time' || t.Status == 'Done Late') {
                    ps20 = new Program_Stage__c();
                    ps20.Client_Name__c = t.WhoId;
                    ps20.Automatically_Generated__c = true;
                    ps20.Program_Cycle__c = t.Program_Cycle__c;
                    ps20.Program_Name__c = t.Subject;
                    ps20.Stage_Date__c = t.Closing_Date__c;
                    ps20.Stage_Id__c = '20.Interviewed';
                    ps20.Source__c = t.id;
                    
                    // Uppercase and Split for Reporting Fields                 
                    strStageId = ps20.Stage_Id__c.toUpperCase();
                    lstStageId = strStageId.split('\\.');
                    ps20.Stage__c = lstStageId[1];
                    ps20.Stage_Number__c = Integer.valueOf(lstStageId[0]);                  
                    
                    if(!mapStagesAlreadyAdded.containsKey(t.whoId+';'+t.Program_Cycle__c+';'+20)) {
                        mapStagesAlreadyAdded.put(t.whoId+';'+t.Program_Cycle__c+';'+20,t.whoId);
                        lstNewStages.add(ps20);
                    }
                } else if(t.Status == 'Cancelled' || t.Status == 'Rejected' || t.Status == 'Incomplete') {
                    ps1 = new Program_Stage__c();
                    ps1.Client_Name__c = t.WhoId;
                    ps1.Automatically_Generated__c = true;
                    ps1.Program_Cycle__c = t.Program_Cycle__c;
                    ps1.Program_Name__c = t.Subject;
                    ps1.Stage_Date__c = t.Closing_Date__c;
                    ps1.Stage_Id__c = '1.Not Interviewed';
                    ps1.Source__c = t.id;
                    
                    // Uppercase and Split for Reporting Fields                 
                    strStageId = ps1.Stage_Id__c.toUpperCase();
                    lstStageId = strStageId.split('\\.');
                    ps1.Stage__c = lstStageId[1];
                    ps1.Stage_Number__c = Integer.valueOf(lstStageId[0]);                   
                    
                    if(!mapStagesAlreadyAdded.containsKey(t.whoId+';'+t.Program_Cycle__c+';'+1)) {
                        mapStagesAlreadyAdded.put(t.whoId+';'+t.Program_Cycle__c+';'+1,t.whoId);
                        lstNewStages.add(ps1);
                    }                   
                }                           
            }       
        }
        
        //EVENTS
        Program_Stage__c ps = new Program_Stage__c();   
    
        
        //Stages 2, 3, 30, 40, 50, 70, 80
        for(Event e: lstAllEvents) {        
                
            if(mapContactIdstoProcess.containsKey(e.whoId+';'+e.Program_Cycle__c)) {
                
                //common data for all stages
                ps = new Program_Stage__c();
                ps.Client_Name__c = e.WhoId;
                ps.Automatically_Generated__c = true;
                ps.Program_Cycle__c = e.Program_Cycle__c;
                ps.Program_Name__c = e.Subject;
                ps.Stage_Date__c = e.ActivityDate;
                ps.Source__c = e.id;                    

                    //Training Class
                if( e.Class_Category__c == 'Career Exploration Training') {
                
                    // Stage 30 - Enrolled in Training
                    if(e.FirstClassRPT__c == true && (e.Verification_Status__c == 'Attended' 
                    || e.Verification_Status__c == 'Late' || e.Verification_Status__c == 'Tardy')) {
                    
                        ps.Stage_Id__c = '30.Enrolled In Training';                         
                                                                            
                    // Stage 2 - Withdrawn from Training    
                    } else if(e.Withdrawn__c == true) {
                        
                        ps.Stage_Id__c = '2.Withdrawn From Training';                           
                        
                    // Stage 40 - Enrolled In Training After 1 Week                         
                    } else if(e.FirstClassSecondWeekRPT__c == true && e.Verification_Status__c != 'Not Verified') {     
                        
                        ps.Stage_Id__c = '40.Enrolled In Training After 1 Week';
                                                    
                    // Stage 50 - Completed Training                                
                    } else if(e.LastClassRPT__c == true && e.Verification_Status__c != 'Not Verified') {
                        
                        ps.Stage_Id__c = '50.Completed Training';                       
                    }                               
                } else if(e.Class_Category__c == 'Career Exploration Support') {

                    // Stage 70 - Enrolled in Internship
                    if(e.FirstClassRPT__c == true && (e.Verification_Status__c == 'Attended' 
                    || e.Verification_Status__c == 'Late' || e.Verification_Status__c == 'Tardy')) {
                    
                        ps.Stage_Id__c = '70.Enrolled In Internship';                       
                                                                            
                    // Stage 3 - Withdrawn from Support / Internship    
                    } else if(e.Withdrawn__c == true) {
                        
                        ps.Stage_Id__c = '3.Withdrawn From Internship';                     
                        
                    // Stage 80 - Completed Internship                      
                    } else if(e.LastClassRPT__c == true && e.Verification_Status__c != 'Not Verified') {        
                        
                        ps.Stage_Id__c = '80.Completed Internship';                                                     
                    }                                                   
                }           
            
                if(ps.Stage_Id__c != null && ps.Stage_Id__c != '') {

                    // Uppercase and Split for Reporting Fields                 
                    strStageId = ps.Stage_Id__c.toUpperCase();
                    lstStageId = strStageId.split('\\.');
                    ps.Stage__c = lstStageId[1];
                    ps.Stage_Number__c = Integer.valueOf(lstStageId[0]);    
                
                    //check if already exists and add to lists
                    if(!mapStagesAlreadyAdded.containsKey(e.whoId+';'+e.Program_Cycle__c+';'+ps.Stage_Number__c)) {
    
                        mapStagesAlreadyAdded.put(e.whoId+';'+e.Program_Cycle__c+';'+ps.Stage_Number__c,e.whoId);
                        lstNewStages.add(ps);       
                    }   
                }                   
            }
        }
        
        //Stage DML
        if(lstNewStages.size() > 0) {
            
            insert lstNewStages;
        }
        
        //CONTACT REPORTING FIELDS
        
        //query contacts with stages for reporting
        List<Contact> lstContact = [SELECT Id, Client_Name__c, Career_Ex_Status__c, 
        Career_Ex_Grad_Date__c, Career_Ex_Grad_Cycle__c, 
        (select id, Stage_Number__c, Stage_Date__c, Stage_Id__c, Program_Cycle__c from Program_Stage__r 
        order by Sort__c asc)
        FROM Contact WHERE Id IN :mapContactIdstoProcess.values()]; 
        
        system.debug(lstContact);
        
        //calc "highest" values
        String strStatus = '';
        Date dteCurrentStage = system.today().addYears(-50);
        Date dteGradDate = system.today().addYears(-50);
        Integer intGradCycle = 0;
        
        for(Contact c: lstContact) {
            
        system.debug('Contact id: ' + c.id);
            
        //reset "highest" values
        strStatus = '';
        dteCurrentStage = system.today().addYears(-50);
        dteGradDate = system.today().addYears(-50);
        intGradCycle = 0;   
        
            for(Program_Stage__c currPS: c.Program_Stage__r) {
                
                system.debug(c.Program_Stage__r);
                
                system.debug('Program Stage, Date: ' + currPS.Stage_Date__c + '\nStage: ' + currPS.Stage_Id__c
                + '\nId: ' + currPS.id);
                    
                if(currPS.Stage_Number__c == 10 || currPS.Stage_Number__c == 1) { 
                    
                    strStatus = 'REFERRED'; 
                } else if(currPS.Stage_Number__c == 30 || currPS.Stage_Number__c == 40
                || (currPS.Stage_Number__c == 70 && c.Career_Ex_Status__c == 'WITHDRAWN')) {
                
                    strStatus = 'ENROLLED'; 
                } else if(currPS.Stage_Number__c == 2 || currPS.Stage_Number__c == 3) { 
                    
                    strStatus = 'WITHDRAWN'; 
                } else if(currPS.Stage_Number__c == 80) {
                    
                    strStatus = 'COMPLETED';
                    if ((dteGradDate == null) || (dteGradDate < currPS.Stage_Date__c)) { 
                        dteGradDate = currPS.Stage_Date__c;
                        intGradCycle =  Integer.valueOf(currPS.Program_Cycle__c);
                    }                       
                }               
                
                system.debug('Current status: ' + strStatus);
            }   
            
            //set contact values
            c.Career_Ex_Status__c = strStatus; 
            if(dteGradDate == system.today().addYears(-50) || intGradCycle == 0) {
                
                c.Career_Ex_Grad_Date__c = null;
                c.Career_Ex_Grad_Cycle__c = null;               
            } else {
                c.Career_Ex_Grad_Date__c = dteGradDate;
                c.Career_Ex_Grad_Cycle__c = intGradCycle;
            }
            lstContactsToUpdate.add(c);             
        }   
        
        //contact dml
        if(lstContactsToUpdate.size() > 0) {
            
            update lstContactsToUpdate;
        }
    }
}