public with sharing class courseRoster {

    ///////////////////////////////////////////
    // This method manages the Class Roster (printing)
    // Author:  AAB / DCS
    // Created:  20110421
    ///////////////////////////////////////////
    public utilityIds utilIds = new utilityIds();
    public String strClassId {get;set;}
    public String strSessionId {get;set;}
    public String strInstructors {get;set;}
    public String strSessionStart {get;set;}
    public String strClassDateRange {get;set;}
    public Class__c clCurrent {get;set;}
    public Session__c seCurrent {get;set;}
    public List<Enrollment__c> lstEnrollments {get;set;}
    public List<Event> lstEvents {get;set;}
    public List<Contact> lstContacts {get;set;}
    public List<clientsForDisplay> lstRoster = new List<clientsForDisplay>();
    
    /////////////////////////////////////////
    // Helper Classes
    /////////////////////////////////////////
    public class clientsForDisplay {
        
        public Contact con {get;set;}
        public String strVerification {get;set;}
        public String strParticipation {get;set;}
                
    }
    
    /////////////////////////////////////////
    // Class Constructors / GETers
    /////////////////////////////////////////
    public courseRoster() {
        
        strClassId = ApexPages.currentPage().getParameters().get('c');
        strSessionId = ApexPages.currentPage().getParameters().get('s');
        
        // Get Data from Passed vars
        clCurrent = [SELECT Id, AreaRPT__c, CategoryRPT__c, Class_Title__c, Instructor_1__r.Name, Instructor_2__r.Name, Instructor_3__r.Name, First_Session_On__c, Last_Session_On__c FROM Class__c WHERE Id = :strClassId];
        seCurrent = [SELECT Session_Start__c, Session_End__c FROM Session__c WHERE Id = :strSessionId];
        lstEvents = [SELECT Verification_status__c, WhoId FROM Event WHERE RecordTypeId = :utilIds.courseCatalogClass AND WhatId = :strSessionId];
        
        //added 11/5/13 MB display class start time
        strSessionStart = seCurrent.Session_Start__c.format('M/d/yyyy H:mm a');
        system.debug(clCurrent.Last_Session_On__c);
        strClassDateRange = clCurrent.First_Session_On__c.format()+' - '+(clCurrent.Last_Session_On__c==null?'Ongoing':clCurrent.Last_Session_On__c.format());
        
        // Format List of Instructors
        strInstructors = clCurrent.Instructor_1__r.Name;
        if(clCurrent.Instructor_2__r.Name != null) { strInstructors += '<br />' + clCurrent.Instructor_2__r.Name; }
        if(clCurrent.Instructor_3__r.Name != null) { strInstructors += '<br />' + clCurrent.Instructor_3__r.Name; }
        
        // Get list of Contact Ids for list
        List<Id> lstContactIds = new List<Id>();
        for(Event e : lstEvents) {
            lstContactIds.add(e.WhoId);
        }
        
        // Get Data from lists
        // QC 20120214 add ORDER BY Name to select statement - roster should print alphabetically
        lstContacts = [Select Name, Current_Projected_Exit_Date__c, Current_Exit_Date__c, Case_Coordinator__r.Name, Case_Coordinator__c, P_C_ID__c, Contract_Formula__c FROM Contact WHERE Id IN :lstContactIds ORDER BY Name ASC];
        
        // Assemble Client Roster
        for(Contact c : lstContacts) {
            
            clientsForDisplay nClientForDisplay = new clientsForDisplay();
            nClientForDisplay.con = c;
            
            for(Event e : lstEvents) {
                if(e.WhoId == c.Id) {
                    nClientForDisplay.strVerification = e.Verification_status__c;
                    break;
                }
            }
            
            lstRoster.add(nClientForDisplay);           
        }
        
    }
    
    public List<clientsForDisplay> getRoster() {
        
        return lstRoster;
        
    }

}