public with sharing class courseConflict {

    ///////////////////////////////////////////
    // This method manages Conflict of Class Enrollments
    // Author:  AAB / DCS
    // Created:  20110427
    ///////////////////////////////////////////
    
    public utilityIds utilIds = new utilityIds();
    public String strClassId {get;set;}
    public Class__c clCurrent {get;set;}
    public List<conflictsForDisplay> lstConflicts = new List<conflictsForDisplay>();
    public String strConflictId {get;set;}
    public String strContactId {get;set;}
    public String strMessage {get;set;}
    
    ////////////////////////////////////////////
    // Helper Classes
    ////////////////////////////////////////////
    
    public class conflictsForDisplay {
        
        public Enrollment_Conflict__c ec {get;set;}
        public Event evtConflict {get;set;}
        public Contact c {get;set;}
        public Session__c s {get;set;}
                
    }
    
    /////////////////////////////////////////
    // Class Constructor / GETers
    /////////////////////////////////////////
    public courseConflict () {
        
        strClassId = ApexPages.currentPage().getParameters().get('c');
        clCurrent = [SELECT Id, Class_Title__c, First_Session_On__c, Last_Session_On__c, Instructor_1__r.Name FROM Class__c WHERE Id = :strClassId];
        
    }
    
    public List<conflictsForDisplay> getConflicts() {
        
        // Clear out the list
        lstConflicts.clear();
        
        // Get Initial List
        List<Enrollment__c> lstEnrollments = [SELECT Id, Client__c FROM Enrollment__c WHERE Class__c = :clCurrent.Id AND Client_Class_Status_Field__c = 'Active'];
        
        // Build Id Lists for Dependent Lists
        List<Id> lstEnrollmentIds = new List<Id>();
        List<Id> lstClientIds = new List<Id>();
        for(Enrollment__c e : lstEnrollments) {
            lstEnrollmentIds.add(e.Id);
            lstClientIds.add(e.Client__c);
        }
        
        List<Enrollment_Conflict__c> lstEnrollmentConflicts = [SELECT Enrollment__c, Conflict_Session__c, Conflicting_Appointment__c FROM Enrollment_Conflict__c WHERE Enrollment__c IN :lstEnrollments];
        System.Debug('Confict Count = ' + lstEnrollmentConflicts.size());
        
        List<Id> lstEventIds = new List<Id>();
        List<Id> lstSessionIds = new List<Id>();
        for(Enrollment_Conflict__c eConflict : lstEnrollmentConflicts) {
            lstEventIds.add(eConflict.Conflicting_Appointment__c);
            lstSessionIds.add(eConflict.Conflict_Session__c);
        }
        
        // Get Dependent Lists
        List<Session__c> lstConflictSessions = [SELECT Id, Session_Start__c, Session_End__c, Assigned_To__r.Name FROM Session__c WHERE Id IN :lstSessionIds];
        //List<Contact> lstConflictContacts = [SELECT Id, Name, Current_Projected_Exit_Date__c FROM Contact WHERE Id IN :lstClientIds];
        Map<Id, Contact> mapConflictContacts = new Map<Id, Contact>([SELECT Id, Name, Current_Projected_Exit_Date__c FROM Contact WHERE Id IN :lstClientIds]); 
        //List<Event> lstConflictEvents = [SELECT Id, WhoId, StartDateTime, EndDateTime, Subject FROM Event WHERE Id IN :lstEventIds];
        Map<Id, Event> mapConflictEvents = new Map<Id, Event>([SELECT Id, WhoId, StartDateTime, EndDateTime, Subject FROM Event WHERE Id IN :lstEventIds]);
        
        for(Enrollment_Conflict__c eConflict : lstEnrollmentConflicts) {
            
            conflictsForDisplay cfdNew = new conflictsForDisplay();
            
            // Enrollment Conflict
            cfdNew.ec = eConflict;
            
            // Session that is in conflict
            for(Session__c seConflict : lstConflictSessions) {
                if(seConflict.Id == eConflict.Conflict_Session__c) {
                    cfdNew.s = seConflict;
                    break;
                }
            }
            
            // Event that is in conflict
            if(mapConflictEvents.get(eConflict.Conflicting_Appointment__c) != null) {
                
                // Assign Event
                cfdNew.evtConflict = mapConflictEvents.get(eConflict.Conflicting_Appointment__c);
                
                // Assign Contact
                cfdNew.c = mapConflictContacts.get(cfdNew.evtConflict.WhoId);
                
            }
/*          for(Event evtConflictEvent : lstConflictEvents) {
                if(string.valueOf(evtConflictEvent.Id) == eConflict.Conflicting_Appointment__c) {
                    
                    // Assign Event
                    cfdNew.evtConflict = evtConflictEvent;
                    
                    // Assign Contact
                    for(Contact conConflict : lstConflictContacts) {
                        if(conConflict.Id == evtConflictEvent.WhoId) {
                            cfdNew.c = conConflict;
                            break;
                        }
                    }
                    
                    break;
                }
            }
*/
            if(lstConflicts.size() < 999 && cfdNew.evtConflict != null) {
                lstConflicts.add(cfdNew);
            }   
            
        }
        
        
        return lstConflicts;
        
    }
    
    public void resubmitConflict() {
            
        Boolean bolCreateEvent = true;
        
        Enrollment_Conflict__c ec = [Select Id, Name, Enrollment__c, Conflict_Session__c, Conflicting_Appointment__c From Enrollment_Conflict__c WHERE Id = :strConflictId];
        Session__c s = [SELECT Id, Session_Start__c, Session_End__c FROM Session__c WHERE Id = :ec.Conflict_Session__c];
        Enrollment__c enr = [SELECT Class__c FROM Enrollment__c WHERE Id = :ec.Enrollment__c];
        Class__c clCurrent = [SELECT RecordTypeId, Instructor_1__c, Program_Cycle__c, CategoryRPT__c, Class_Title__c, AreaRPT__c FROM Class__c WHERE Id = :enr.Class__c];
        
        //9/13/13 MB modifying the list of events pulled so that it ignores cancelled and withdrawn events, and uses
        //the same code as the conflict creator in courseEnrollment
        List<Event> lstEvt = [SELECT Id, RecordTypeId, ActivityDate, WhoId, ActivityDateTime, StartDateTime, EndDateTime 
                                FROM Event 
                                WHERE WhoId = :strContactId 
                                AND Verification_Status__c != 'Cancelled' 
                                AND Verification_Status__c != 'Withdrawn' 
                                AND IsDeleted = false 
                                AND IsRecurrence = false 
                                AND StartDateTime >= :System.Now() 
                                AND RecordTypeId != :utilIds.courtDate 
                                AND (RecordTypeID != :utilIds.caseCoordination 
                                AND Subject != 'Program Reporting')];
        
        for(Event e : lstEvt) {
            
            System.Debug('TESTING = ' + e.Id);
        
            //BT-266 ebg - added check for other event covering exact timeframe as the session
            if((e.StartDateTime < s.Session_Start__c && e.EndDateTime > s.Session_Start__c) ||
                (e.StartDateTime < s.Session_End__c && e.EndDateTime > s.Session_End__c) ||
                (e.StartDateTime < s.Session_Start__c && e.EndDateTime > s.Session_End__c) ||
                (e.StartDateTime == s.Session_Start__c && e.EndDateTime == s.Session_End__c)) {
                
                bolCreateEvent = false;
                strMessage = 'There is a conflict that is preventing you from proceeding.  Please review the Events for this Client and try again.';
            }
        }
        
        if(bolCreateEvent == true) {
            
            Event evt = new Event();
                        
            Long lngClassDuration = (s.Session_End__c.getTime() - s.Session_Start__c.getTime());
            
            evt.WhoId = strContactId;
            evt.WhatId = s.Id;
            evt.OwnerId = clCurrent.Instructor_1__c;
            evt.Program_Cycle__c = clCurrent.Program_Cycle__c;
            evt.Area__c = clCurrent.AreaRPT__c;
            evt.Class_Category__c = clCurrent.CategoryRPT__c;
            evt.RecordTypeId = utilIds.courseCatalogClass;
            evt.Subject = clCurrent.Class_Title__c;
            evt.ActivityDateTime = s.Session_Start__c;
            evt.ActivityDate = s.Session_Start__c.date();
            evt.StartDateTime = s.Session_Start__c;
            evt.EndDateTime = s.Session_End__c;
            evt.Verification_Status__c = 'Not Verified';
            evt.DurationInMinutes = Integer.valueOf(lngClassDuration) / 60000;
            evt.SkipRestrictions__c = true;
            evt.ClassTypeRPT__c = clCurrent.RecordTypeId;
            if(Integer.valueOf(lngClassDuration) / 60000 > 0) { 
                // Insert Event
                insert evt; 
                
                // Delete Enrollment Conflict Record
                delete ec;
                strMessage = 'The conflict has been resolved and the Client is now scheduled in the Class.';
            }
        }
    
        
        getConflicts();
    }
    
}