public class sessionMethods {


    public utilityIds utilIds = new utilityIds(); 
    
    //////////////////////////////////
    // Constructors / Helpers
    //////////////////////////////////
    public sessionMethods() { }
    

    public void additionalSessionEnrollments(List<Session__c> lstSessions) {
        
        // Build list of existing events to do a dupe check on
        /////////////////////////////
        
        List<Event> lstCreateEvents = new List<Event>();
        List<Event> lstUpdateEvents = new List<Event>();
        Set<Id> setClassIds = new Set<Id>();
        
        Map<Id, Class__c> mapClass = new Map<Id, Class__c>();
        Map<Id, Id> mapSessionSchedule = new Map<Id, Id>();
        
        List<Id> lstScheduleIds = new List<Id>();
        Set<Id> setSessionIds = new Set<Id>();
        for(Session__c s : lstSessions) { 
            lstScheduleIds.add(s.Schedule__c);
            setSessionIds.add(s.Id);
            mapSessionSchedule.put(s.Id, s.Schedule__c);
            setClassIds.add(s.ClassId__c);
        }
        
        List<Enrollment__c> lstEnrollments = [SELECT Id, Class__c, Client__c FROM Enrollment__c WHERE Class__c IN :setClassIds AND Most_Recent_Enrollment__c = true AND Client_Class_Status_Field__c = 'Active' AND Client__c != null];
		//20160303 EBG/DCS - added field "Default_Ending_Session__c" to query results
        List<Class__c> lstClasses = [SELECT Id, Instructor_1__c, Class_Title__c, AreaRPT__c, CategoryRPT__c, RecordTypeId, Program_Cycle__c, Default_Ending_Session__c FROM Class__c WHERE Id IN :setClassIds];
        for(Class__c c : lstClasses) {
            mapClass.put(c.Id, c);
        }
        
        Set<Id> setClientIds = new Set<Id>();
        for(Enrollment__c enr : lstEnrollments) {
            setClientIds.add(enr.Client__c);
        }
        
        // Removed per BT-307 - logic moved to Grading and Verification page 20120410
        // Create List of Existing Events to control "Last Session Flag"
        //List<Event> lstEvents = [SELECT Id, WhoId, WhatId, LastClassRPT__c FROM Event WHERE WhoId IN :setClientIds AND WhatId IN :mapSessionSchedule.keySet() ORDER BY WhoId ASC, ActivityDateTime ASC];
        
        // Loop through sessions to create Events for Clients
        for(Session__c ses : lstSessions) {
            //20160303 EBG/DCS - if the class being extended is a "Single session only", do not extend the enrollments for the clients
            if (mapClass.get(ses.ClassId__c).Default_Ending_Session__c == 'Single session only') {
                //move to next session
                continue;
            }
            System.Debug('sessionMethods.additionalSessionEnrollments INFO:  STEP 1');
                    
            for(Enrollment__c enr : lstEnrollments) {
                System.Debug('sessionMethods.additionalSessionEnrollments INFO:  STEP 2');
                
                if(enr.Class__c == ses.ClassId__c) {
                    System.Debug('sessionMethods.additionalSessionEnrollments INFO:  Creating Event for ' + enr.Client__c + ' on ' + ses.Session_Start__c);
                    Event evt = new Event();
                    
                    evt.WhoId = enr.Client__c;
                    evt.WhatId = ses.Id;
                    evt.OwnerId = mapClass.get(ses.ClassId__c).Instructor_1__c;
                    evt.RecordTypeId = utilIds.courseCatalogClass;
                    evt.Subject = mapClass.get(ses.ClassId__c).Class_Title__c;
                    evt.ActivityDateTime = ses.Session_Start__c;
                    
                    // BT-282 NEED TO FIX - CALCULATE CORRECT NUMBER OF MINUTES
                    //evt.DurationInMinutes = 60;
                    Long lngDiff = (((ses.Session_End__c.getTime() - ses.Session_Start__c.getTime()) / 1000) / 60);
                    System.Debug('sessionMethods.additionalSessionEnrollments INFO:  intDiff = ' + lngDiff);
                    evt.DurationInMinutes = Integer.valueOf(lngDiff);
                    
                    // BT-282 ALSO, NEED TO POPULATE THE CLASS CATEGORY AND AREA WITH VALUES ON MANUAL SESSION CREATE
                    evt.Class_Category__c = mapClass.get(ses.ClassId__c).CategoryRPT__c;
                    evt.Area__c = mapClass.get(ses.ClassId__c).AreaRPT__c;
                    evt.ClassTypeRPT__c = mapClass.get(ses.ClassId__c).RecordTypeId;
                    evt.Program_Cycle__c = mapClass.get(ses.ClassId__c).Program_Cycle__c;
                    
                    evt.ActivityDate = ses.Session_Start__c.date();
                    evt.SkipRestrictions__c = true;
                    
                    // Removed per BT-307 - logic moved to Grading and Verification page 20120410
                    // Added BT-307 Check for "Last Class RPT Flag"
                    //for(Event eEvt : lstEvents) {
                    //  // Ensure we're talking about the right WHO in the session's schedule
                    //  if(eEvt.WhoId == evt.WhoId && mapSessionSchedule.get(eEvt.WhatId) == mapSessionSchedule.get(evt.WhatId)) {
                    //      //if(eEvt.LastClassRPT__c == true && eEvt.ActivityDateTime < evt.ActivityDateTime) {
                    //      if(eEvt.ActivityDateTime < evt.ActivityDateTime) {
                    //          
                    //          evt.LastClassRPT__c = true;
                    //          eEvt.LastClassRPT__c = false;
                    //          lstUpdateEvents.add(eEvt);
                    //          
                    //      }
                    //  }
                    //}
                    
                    lstCreateEvents.add(evt);
                } // End If
            } // End Enrollment
        } // End Session
        
        if(lstCreateEvents.size() > 0) { insert lstCreateEvents; }
        if(lstUpdateEvents.size() > 0) { update lstUpdateEvents; }
        
    }
    
    public void deleteSessionEvents(List<Session__c> lstSessions) {
        
        // This will delete all Events associated to a Session
        
        List<Id> lstSessionIds = new List<Id>();
        for(Session__c s : lstSessions) { lstSessionIds.add(s.Id); }
        
        List<Event> lstEventsToDelete = [SELECT Id FROM Event WHERE WhatId IN :lstSessionIds];
        
        if(lstEventsToDelete.size() > 0) { delete lstEventsToDelete; }
        
    }

}