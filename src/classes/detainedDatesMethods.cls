public with sharing class detainedDatesMethods {

    public List<Detained_Dates__c> newDetainedDates = new List<Detained_Dates__c>();
    public List<Detained_Dates__c> oldDetainedDates = new List<Detained_Dates__c>();

    ///////////////////////
    // TRIGGER ACTIONS
    ///////////////////////
    
    public void checkForOpenEndedRecordsInsert() {
        
        for (Detained_Dates__c newDate : newDetainedDates) {
            for (Detained_Dates__c dd : [SELECT Id, Date_Released__c, Detained_Date__c 
                                        FROM Detained_Dates__c 
                                        WHERE Contact_Detained_Dates_Lookup__c = :newDate.Contact_Detained_Dates_Lookup__c]) {
                
                // Provide a check on the detained date object record that if there is an open
                // ended detained date (one without an end date), user cannot create 
                // a new detained date record.
                
                if (string.valueOf(dd.Date_Released__c) == null 
                // 2/7/13 MB: Added so that users can enter past, closed detained dates while the client is currently in detention (cls.a.BT-0341)
                && (string.ValueOf(newDate.Date_Released__c) == null ||
                newDate.Date_Released__c.DaysBetween(dd.Detained_Date__c) < 0 )) {
                    newDate.Detained_Date__c.addError('This client has an open Detained Date record without a Release Date.  Only one open Detainment record can exist per Client.');
                }
            }   
        }
    }
    
    public void checkForOpenEndedRecordsUpdate() {
        
        for (Detained_Dates__c updateDate : newDetainedDates) {
            for (Detained_Dates__c dd : [SELECT Id, Date_Released__c, Detained_Date__c 
                                        FROM Detained_Dates__c 
                                        WHERE Id != :updateDate.Id 
                                        AND Contact_Detained_Dates_Lookup__c = :updateDate.Contact_Detained_Dates_Lookup__c]) {
                
                // Provide a check on the detained date object record that if there is an open
                // ended detained date (one without an end date), user cannot update the  
                // existing date record.
                
                if (string.valueOf(dd.Date_Released__c) == null 
                // 2/7/13 MB: Added so that users can enter past, closed detained dates while the client is currently in detention (cls.a.BT-0341)
                && (string.ValueOf(UpdateDate.Date_Released__c) == null ||
                UpdateDate.Date_Released__c.DaysBetween(dd.Detained_Date__c ) < 0 )) {
                    updateDate.Detained_Date__c.addError('This client has an open Detained Date record without a Release Date.  Only one open Detainment record can exist per Client.');
                    break;
                }
            }   
        }
    }
    
    /*public void calculateDaysInDetention(Boolean deleteFlag) {
  QC: 20111029 commenting out entire block, can't handle this way unless we change specs    
        Decimal decDayCount = 0;
        
        List<Detained_Dates__c> lstDates;
        
        if(deleteFlag) {
            lstDates = oldDetainedDates;
        } else {
            lstDates = newDetainedDates;
        }
        
        
        for (Detained_Dates__c updateDate : lstDates) {
            
            system.debug('\n\n***Inside calculateDaysInDetension.  Processing updateDate.Contact_Detained_Dates_Lookup__c: ' + updateDate.Contact_Detained_Dates_Lookup__c);
            
            //if (updateDate.Contact_Detained_Dates_Lookup__c != null || updateDate.Contact_Detained_Dates_Lookup__c != '') {
            //20110622 ebg - removed check for a blank value; since this is an ID field, blank is not a valid entry
            if (updateDate.Contact_Detained_Dates_Lookup__c != null) {
                
                // 
                
                decDayCount = 0;
                Contact c = [SELECT Id, Current_In_Program_Days_In_Detention__c FROM Contact WHERE Id = :updateDate.Contact_Detained_Dates_Lookup__c];
                
                for (Detained_Dates__c dd : [SELECT Program_Days_Num_Days__c FROM Detained_Dates__c WHERE Contact_Detained_Dates_Lookup__c = :c.Id]) {
                
                    // Add up all of the Program Day calculations and update the Related Contact Object
                    if (dd.Program_Days_Num_Days__c != null ) {
                        decDayCount = decDayCount + dd.Program_Days_Num_Days__c;
                    }
                }
                
                c.Current_In_Program_Days_In_Detention__c = decDayCount;
                update c;
            }
        } 
    }*/
    
    //this method deprecated 12/9/13, as client status is now calculated entirely in contact methods
    
    /*
    public void checkForClientDetained() {
        
        ///////////////////////////////////////
        // Added 20110414 AAB
        ///////////////////////////////////////
        
        // 2/7/13 MB: Old crappy code. New code is bulkified 
        //and checks all detention dates to see if there are any open ones, then sets status accordingly
        
        list<id> lstClientIds = new list<Id>();
        list<Contact> lstContacts = new list<Contact>();
        list<Detained_Dates__c> lstAllOpenDetainedDates = new list<Detained_Dates__c>();
        map<Id,Id> mapOpenDetainedDates = new map<Id, Id>();
        
        for(Detained_Dates__c dd: newDetainedDates) {
            
            lstclientIds.add(dd.Contact_Detained_Dates_Lookup__c);
            
        }
        
        lstContacts = [select id, client_status__c from contact where id in :lstClientIds];
        lstAllOpenDetainedDates = [select id, Contact_Detained_Dates_Lookup__c from Detained_Dates__c
                                  where Contact_Detained_Dates_Lookup__c in :lstClientIds
                                  and Date_Released__c = null];
        
        if(lstAllOpenDetainedDates.size() > 0) {                          
            for(Detained_Dates__c d: lstAllOpenDetainedDates) {
                
                mapOpenDetainedDates.put(d.Contact_Detained_Dates_Lookup__c, d.id);
            }
        }                         
        
        for(Contact c: lstContacts) {
            
            if(mapOpenDetainedDates.containsKey(c.id)) {
                
                // 5/2/13 MB: added this IF because exited clients were getting set to "On Program Hold"
                // when a detained date was created after the exit was approved
                if(c.Client_Status__c == 'Active') {
                    
                    c.Client_Status__c = 'On Program Hold';
                }
            }
            
            else if (c.Client_Status__c == 'On Program Hold' ){
                
                c.Client_Status__c = 'Active';
            }
                    
        }
        
        update lstContacts;
        
        
        for(Detained_Dates__c ddDetained : newDetainedDates) {
            // QC: 20111029: uncommented this block, need it for changing the status.
            if(ddDetained.Detained_Date__c != null && ddDetained.Date_Released__c == null) {
                Contact c = [SELECT Id, Client_Status__c FROM Contact WHERE Id = :ddDetained.Contact_Detained_Dates_Lookup__c];
                if(c.Client_Status__c == 'Active') {
                    c.Client_Status__c = 'On Program Hold';
                    update c;
                }
            }
            
            if(ddDetained.Detained_Date__c != null && ddDetained.Date_Released__c != null) {
                Contact c = [SELECT Id, Client_Status__c FROM Contact WHERE Id = :ddDetained.Contact_Detained_Dates_Lookup__c];
                if(c.Client_Status__c == 'On Program Hold') {
                    c.Client_Status__c = 'Active';
                    update c;
                }
            }
            
        }
        
    }*/
    
    ///////////////////////
    // STANDARD / PAGE ACTIONS
    ///////////////////////
    
    /*
    public void bulkRecalculateDaysInDetention() {
        
                
        
    }
    */
    
    public void updateContacts() {
        
        set<Id> setContactIds = new set<Id>();
        
        for(Detained_Dates__c dd: newDetainedDates) {
            
            setContactIds.add(dd.Contact_Detained_Dates_Lookup__c);
        }
        
        update new list<Contact>([select id from Contact where id in :setContactIDs]);
        
    }
    
}