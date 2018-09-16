global class jobCreateSessionsforDTCGroups {
    
    global utilityIds utilIds = new utilityIds();

    global void createSessions(integer intLimit) {  
        
        //existing schedules
        list<Schedule__c> lstSchedules = [select id, Class__r.Course__r.Name from Schedule__c
            where Class__r.CategoryRPT__c = 'START Group' and Dummy_Schedule__c = true];
            
        map<string, Schedule__c> mapSchedules = new map<string,Schedule__c>();
        
        for(Schedule__c s: lstSchedules) {
            
            mapSchedules.put(s.Class__r.Course__r.Name, s);
        }               
        
        //existing sessions
        list<Session__c> lstExistingSessions = [select id, Course_Name__c, Session_Start__c from Session__c 
            where Course_Category__c = 'START Group' and Session_Start__c >= :system.now().addMonths(-6)];
            
        map<string, Session__c> mapExistingSessions = new map<string,Session__c>();
        
        for(Session__c s: lstExistingSessions) {
            
            mapExistingSessions.put(s.Course_Name__c+';;'+s.Session_Start__c.format('yyyy-MM-dd HH:mm:ss'), s);
        }   
        
        //pull events to be processed
        list<Event> lstEvents = [select id, Subject, whatId, activityDate, activityDateTime, DurationinMinutes, 
            Skip_Triggers__c, ownerId, Task_Source__c
            from Event 
            where RecordTypeId = :utilIds.courseCatalogClass and whatId = null 
            and (P_C_ID__c LIKE '%DTC%' or P_C_ID__c LIKE '%CCM%') limit :intLimit];
                                
        map<String, Event> mapUniqueSessionsNeeded = new map<String, Event>();
        
        for(Event e: lstEvents) {
            
            //create unique list of sessions using concatenated string. the string will be broken up later
            mapUniqueSessionsNeeded.put(e.Subject+';;'+e.ActivityDateTime.format('yyyy-MM-dd HH:mm:ss'), e);
        }       
        
        List<Session__c> lstSessionstoCreate = new list<Session__c>();
        
        Session__c newSession = new Session__c();               
        
        //loop through strings to see which exist
        for(string str: mapUniqueSessionsNeeded.keySet()) {
            
            if(!mapExistingSessions.containsKey(str)) {
                
                //mark event as error if schedule does not exist
                if(!mapSchedules.containsKey(str.split(';;')[0])) {
                    
                    for(Event e: lstEvents) {
                        
                        if(mapUniqueSessionsNeeded.get(str) == e) {
                        e.task_source__c = 'Error';
                        }
                    }               
                } else {
                
                    //create new session if does not exist
                    newSession = new Session__c();
                    newSession.Session_Start__c = dateTime.valueOf(str.split(';;')[1]);
                    newSession.Session_End__c = dateTime.valueOf(str.split(';;')[1]).addMinutes(15);
                    newSession.Assigned_To__c = mapUniqueSessionsNeeded.get(str).ownerId;
                    newSession.Schedule__c = mapSchedules.get(str.split(';;')[0]).id;
                
                    lstSessionstoCreate.add(newSession);
                }
            } 
        }
        
        //create new sessions
        
        if(lstSessionstoCreate.size() > 0) {
        
            insert lstSessionstoCreate;
        
            //re-query existing sessions (need course_name__c formula field)
            lstExistingSessions = [select id, Course_Name__c, Session_Start__c from Session__c 
                where Course_Category__c = 'START Group' and createdDate >= :system.today().addDays(-1)];
            
            for(Session__c s: lstExistingSessions) {
                
                mapExistingSessions.put(s.Course_Name__c+';;'+s.Session_Start__c.format('yyyy-MM-dd HH:mm:ss'), s);
            }   
        }   
        
        String strKey = '';
        
        system.debug(lstEvents);
        system.debug(mapExistingSessions);
                
        //now, assign events to new sessions    
        for(Event e: lstEvents) {
            
            strKey = e.Subject+';;'+e.ActivityDateTime.format('yyyy-MM-dd HH:mm:ss');
            
            system.debug(strKey);
            
            if(mapExistingSessions.containsKey(strKey)) {
                
                //link events to existing sessions
                e.whatID = mapExistingSessions.get(strKey).id;
                e.Skip_Triggers__c = true;
            }           
                    
        }   
        
        update lstEvents;               
                                
    }

}