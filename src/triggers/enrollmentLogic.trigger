trigger enrollmentLogic on Enrollment__c (before delete) {

    ///////////////////////////////////////////////
    // Created AAB / DCS
    // 20110811
    ///////////////////////////////////////////////
    courseEnrollment clsCourseEnr = new courseEnrollment();

    if(trigger.isBefore && trigger.isDelete) {
        
        // This is called to clean up any Events created from an Enrollment before deletion
        
        List<Id> lstClientIds = new List<Id>();
        List<Id> lstClassIds = new List<Id>();
        List<Schedule__c> lstScheduleIds = new List<Schedule__c>();
        List<Session__c> lstSessions = new List<Session__c>();
        List<Id> lstSessionIds = new List<Id>();
        List<Event> lstEventsToDelete = new List<Event>();
    
        // Find Clients and Classes in scope
        for(Enrollment__c e : trigger.old) {
            lstClientIds.add(e.Client__c);
            lstClassIds.add(e.Class__c);
        }
        
        // Find Schedules in scope
        lstScheduleIds = [SELECT Id FROM Schedule__c WHERE Class__c IN :lstClassIds];
        
        // Find Sessions in scope
        lstSessions = [SELECT Id FROM Session__c WHERE Schedule__c IN :lstScheduleIds];
        for(Session__c s : lstSessions) {
            lstSessionIds.add(s.Id);
        }
        
        // Find Events in scope
        lstEventsToDelete = [SELECT Id FROM Event WHERE WhoId IN :lstClientIds AND WhatId IN :lstSessionIds AND Verification_Status__c = 'Not Verified'];
        
        // Delete!
        if(lstEventsToDelete.size() > 0) { delete lstEventsToDelete; }
        
    }

}