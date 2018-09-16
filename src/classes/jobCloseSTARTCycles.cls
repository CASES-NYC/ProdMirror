global class jobCloseSTARTCycles {
    
    global utilityIds utilIds = new utilityIds();
    
    global void closeSTARTCycles() {
        
        list<Id> lstClients = new list<Id>();
        list<Event> lstEventstoFire = new list<Event>();
        
        //cycles for active DTC clients who have hit or past (rare) their compliance date, and are not voluntary 
        list<Program_Cycle__c> lstCyclestoCheck = [select id, Client__c from Program_Cycle__c
                                                   where Client__r.Client_Status__c = 'Active'
                                                   and Compliance_Date__c <= :system.today()
                                                   and RecordTypeId  = :utilIds.progCycleDTC];
                                                   
        for(Program_Cycle__c pc: lstCyclestoCheck) {
            
            lstClients.add(pc.Client__c);
        }                                          
        
        lstEventstoFire = [select id from Event where whoId in :lstClients 
                           and subject = 'Program Reporting'];
                           
        update lstEventstoFire;
        
    }

}