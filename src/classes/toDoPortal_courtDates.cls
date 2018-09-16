public class toDoPortal_courtDates {

public utilityIds util = new utilityIds();


public Portal_Filter__c thisPortalFilter = new Portal_Filter__c();
    
        
    public toDoPortal_courtDates() {
        
        List<Portal_Filter__c> myTaskPf = [Select   Borough__c,
                                                    Case_Coordinator__c,
                                                    Court_Date_From__c,
                                                    Court_Date_To__c,
                                                    Court_Staff__c
                                                    From Portal_Filter__c 
                                                    where OwnerId = :UserInfo.getUserId() 
                                                    Limit 1];
        
        if(myTaskPf.size()== 1) {
            
            thisPortalFilter = myTaskPf[0];
        }
    }
    
    public Portal_Filter__c getthisPortalFilter() {
        
        return this.thisPortalFilter;
    }
    
    public void setThisPortalFilter(Portal_Filter__c thisPortalFilter) {
        
        
        this.thisPortalFilter = thisPortalFilter;
        
    }
    
    public void logSearch() {

    }
        
    public void saveThisTaskFilter() {

        upsert thisPortalFilter;
            
    }
        
    public void doNothing() {
            
            
    }
        

    public string caseQuery;
    
    public String getThisQuery() {
        
        
        return caseQuery;
    }
        
        public List<eventForDisplay> getCasesTab() {
            
            List<eventForDisplay> eventForTable = new List<eventForDisplay>();
            
            /////////////////////////////////////////
            // Build the query
            /////////////////////////////////////////
            
            caseQuery = 'Select OwnerId,Verification_Due_Date__c, Owner.Name,WhoId,WhatId,Who.Name,Report_Type__c,Appearance_Required__c,ActivityDate From Event Where whatId != null AND Outcome__c = \'Pending\' AND recordTypeId =\''+ util.courtDate +'\' ';
            

            // Due Date
            
            if(thisPortalFilter.Court_Date_To__c != null) {
                
                
                //caseQuery += ' AND ActivityDate <= ' + String.valueOf(thisPortalFilter.Court_Date_To__c);
                caseQuery += ' AND Verification_Due_Date__c <= ' + String.valueOf(thisPortalFilter.Court_Date_To__c);
            }
            
            if(thisPortalFilter.Court_Date_From__c != null) {

                caseQuery += ' AND Verification_Due_Date__c >= ' + String.valueOf(thisPortalFilter.Court_Date_From__c);
            }
            

            // Due Date
            if(thisPortalFilter.Court_Staff__c != null) {
                
                caseQuery += ' AND ownerId = \'' + thisPortalFilter.Court_Staff__c+ '\'';   
                
            }
 
            // Caseload
            
            if(thisPortalFilter.Case_Coordinator__c != null) {
            
                List<Contact> caseLoadContacts = [Select Id from Contact Where Case_Coordinator__c = :thisPortalFilter.Case_Coordinator__c];
                
                System.debug('TEST 123: ' + caseLoadContacts.size());
                Set<Id> caseLoadContactIds = new Set<Id>();
                String caseLoadCondition = '';
                
                integer ii = 0;
                
                for(Contact thisContact:caseLoadContacts) {
                    
                    if(ii == 0) {
                    
                        caseLoadCondition += ' AND ( whoId = \'' + thisContact.Id + '\' ';
                    
                    } else {
                    
                        caseLoadCondition += ' OR whoId = \'' + thisContact.Id + '\' ';
                    
                    }
                    
                    ii++;
                    
                    if(ii == caseLoadContacts.size()) {
                        
                        caseLoadCondition += ' )';
                    }
                    
                }
                
                System.debug('caseLoadCondition :' + caseLoadCondition);
            
                caseQuery += caseLoadCondition;
            }
            
            /////////////////////////////////////////
            // END
            /////////////////////////////////////////
            
            caseQuery += ' Order By ActivityDateTime ASC LIMIT 1000';
            
            List<Event> eventFromQuery = Database.query(caseQuery);
            
            Set<Id> caseIds = new Set<Id>();
            
            //////////////////////////////////////////////////////////////
            /// Figure out all the cases so I can get thier information
            //////////////////////////////////////////////////////////////
            
            for(Event thisEvent:eventFromQuery) {
                
                if(thisEvent.whatId != null) {
            
                    caseIds.add(thisEvent.whatId);  
                    
                }
            }
            
            //////////////////////////////////////////////////////////////
            /// Get all the related Case_information__c
            //////////////////////////////////////////////////////////////
            
                ///////////////////////////////////
                //
                // Intake borough filter
                //
                ///////////////////////////////////
                
                Set<String> boroughList = new Set<String>();
                
                if(thisPortalFilter.Borough__c != null) {
                    
                    boroughList.add(thisPortalFilter.Borough__c);
                    
                } else {
                    
                    boroughList.add('Bronx');
                    boroughList.add('Brooklyn');
                    boroughList.add('Manhattan');
                    boroughList.add('Nassau');
                    boroughList.add('Out of NY State');
                    boroughList.add('Putnam');
                    boroughList.add('Queens');
                    boroughList.add('Staten Island');
                    boroughList.add('Suffolk');
                    boroughList.add('Unknown');
                    boroughList.add('Westchester');
                    
                }
                
                
                //////////////////////////////////////
                //
                // EOF Intake borough filter
                //
                //////////////////////////////////////

                
            Map<Id,Case_Information__c> caseMap = new Map<Id,Case_Information__c>([Select Id,
                                                            Borough__c,
                                                            Name,
                                                            RecordType.Name
                                                            From Case_Information__c 
                                                            Where Id in :caseIds
                                                            AND Borough__c in :boroughList
                                                            ]);
        
            
            
            for(Event thisEvent:eventFromQuery) {
                
                if(caseMap.containsKey(thisEvent.whatId)) {
                        
                        eventForDisplay thisEventForDisplay = new eventForDisplay();
                        
                        thisEventForDisplay.eventDueDate = thisEvent.Verification_Due_Date__c;
                        thisEventForDisplay.clientName = thisEvent.Who.Name;
                        thisEventForDisplay.clientId= thisEvent.WhoId;
                        thisEventForDisplay.eventCourtDate = thisEvent.ActivityDate;
                        thisEventForDisplay.eventId = thisEvent.id;
                        thisEventForDisplay.courtDateId = caseMap.get(thisEvent.whatId).id;
                        thisEventForDisplay.eventOwnerId = thisEvent.OwnerId;
                        thisEventForDisplay.eventOwnerName = thisEvent.Owner.name;
                        
                        thisEventForDisplay.reportType = thisEvent.Report_Type__c;
                        thisEventForDisplay.docket = caseMap.get(thisEvent.whatId).Name;
                        thisEventForDisplay.Borough = caseMap.get(thisEvent.whatId).Borough__c;
                        
                        if(thisEvent.Appearance_Required__c) {
                        
                            thisEventForDisplay.apperanceRequired = 'Yes';
                        
                        } else {
                        
                            thisEventForDisplay.apperanceRequired = 'No';
                        }
                        
                        eventForTable.add(thisEventForDisplay);
                        
                }
            }
            
            
            return eventForTable;
        }

        // Helper class to stage data properly
        
        class eventForDisplay {
            public string apperanceRequired{get;set;}
            public string clientName{get;set;}
            public id clientId{get;set;}
            public id courtDateId{get;set;}
            public id eventId{get;set;}
            public id eventOwnerId{get;set;}
            public string eventOwnerName {get;set;}
            public dateTime eventDueDate{get;set;}
            public dateTime eventCourtDate{get;set;}
            public string docket {get;set;}
            public String reportType {get;set;}
            public String borough {get;set;}
        }
}