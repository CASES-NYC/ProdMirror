global class jobDeleteIncompleteScreenings {
    
    
    global utilityIds utilIds = new utilityIds();
    
    global void deleteIncompleteScreenings(integer intDaysOld) {
        
        list<Id> lstAllAccountIds = new list<Id>();
        set<Id> setIntakeCaseIds = new set<Id>();
        list<Account> lstAccountstoDelete = new list<Account>();
        
        map<Id, Contact> mapContacts = new map<Id, Contact>([select id, AccountId, Intake_Case__c from Contact 
                                     where RecordtypeId in(:utilIds.conDTC, :utilIds.conCCM, 
                                     :utilIds.conBXChoices, :utilIds.conMNChoices) 
                                     and (Not Screening_Stage__c Like '%Complete')
                                     and CreatedDate <= :system.today().addDays(-1*intDaysOld)]);
        
        set<Id> setContactIds = mapContacts.keySet();   
        
        for(Contact c: mapContacts.values()) {
            
            lstAllAccountIds.add(c.AccountId);
            if(c.Intake_Case__c != null) {
                setIntakeCaseIDs.add(c.Intake_Case__c);
            }
        }                
        
        list<Program_Cycle__c> lstCycles = [select id from Program_Cycle__c where Client__c in :setContactIds];
        
        list<Tier__c> lstTiers = [select id from Tier__c where Contact__c in :setContactIds];
        
        list<Test__c> lstTests = [select id from Test__c where Contact__c in :setContactIds];
        
        list<Address_Information__c> lstAddresses = [select id from Address_Information__c where Client__c in :setContactIds];
        
        list<Medication__c> lstMeds = [select id from Medication__c where Contact__c in :setContactIDs];
        
        list<Case_Information__c> lstDockets = [select id from Case_Information__c where Client_Account__c in :setIntakeCaseIds];
        
        list<Event> lstEvents = [select id from Event where whoId in :setContactIds and isRecurrence = false and isDeleted = false];
        
        list<Event> lstRecurringEvents = [select id from Event where whoId in :setContactIds and isRecurrence = true];                
        
        list<Program_Plan__c> lstPPs = [select id from Program_Plan__c where Client_Name__c in :setContactIds];  
        
        list<Program_Relationships__c> lstProgRels = [select id from Program_Relationships__c 
                                                      where Client_Name__c in :setContactIds];
        
        //only delete accounts if there are no other contacts attached                                                                                                            
        for(Account a: [select id, (select id from contacts) from Account where id in :lstAllAccountIds]) {
            
            if(a.Contacts.size() == 1) {
                
                lstAccountstoDelete.add(a);
            }
        }
        
        //dml
        delete lstProgRels; 
        delete lstPPs; 
        delete lstEvents;
        
        for(Event e: lstRecurringEvents) {
                
            delete e;
        }
                
        delete lstDockets;
        delete lstMeds; 
        delete lstAddresses; 
        delete lstTests;
        delete lstTiers;
        delete lstCycles;
        delete mapContacts.values();
        delete lstAccountstoDelete;                                                   
        
    }
}