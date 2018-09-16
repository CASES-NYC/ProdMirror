public class programCycleMethods {
    
    public list<Program_Cycle__c> lstNewPcs = new list<Program_Cycle__c>();
    public list<Id> lstContactIds = new list<Id>();
    public list<Contact> lstContacts = new list<Contact>();
    
    public void getContacts() {
        
        for(Program_Cycle__c pc: lstNewPcs) {
            
            lstContactIds.add(pc.Client__c);
        }
    
        
        //get all program cycles to loop through
        //get contacts and most recent cycles in scope 
        lstContacts = [select id, Most_Recent_Program_Cycle__c, Most_Recent_Mandated_Cycle__c,
            //subquery
            (select id, Cycle_Type__c
            from Program_Cycles__r order by Start_Date__c asc)
        from Contact where id in :lstContactIds];       
        
    }
    
    public void setMostRecentFlag() {
        
        Program_Cycle__c MostRecentCycle = new Program_Cycle__c();
        Program_Cycle__c MostRecentMandatedCycle = new Program_Cycle__c();
        
        for(Contact c : lstContacts) {
            
            //reset values
            MostRecentCycle = null;
            MostRecentMandatedCycle = null;
        
        	if(c.Program_Cycles__r.size() > 0) {
	            //loop through list by ascending start date, and overwrite past cycles
	            for(Program_Cycle__c pc: c.Program_Cycles__r) {
	            	
	            	system.debug(pc);
	                
	                MostRecentCycle = pc;
	                if(pc.Cycle_Type__c != 'Voluntary') {
	                    
	                    MostRecentMandatedCycle = pc;
	                }
	            }
	            
	            c.Most_Recent_Program_Cycle__c = MostRecentCycle.id;
	            
	            //this case should not occur in general use, only when cycles are being mass uploaded
	            //when they may be in the wrong order
	            if(MostRecentMandatedCycle == null) {
	            	
	            	c.Most_Recent_Mandated_Cycle__c = null;
	            } else {
	            
	            	c.Most_Recent_Mandated_Cycle__c = MostRecentMandatedCycle.id;
	            }
        	} else {
        		
	            c.Most_Recent_Program_Cycle__c = null;
	            c.Most_Recent_Mandated_Cycle__c = null;
        	}
        }
        
        
        //dml
        update lstContacts;
        
    }
    
    public void deleteChildTiers(set<Id> lstDelIDs) {
        
        list<Tier__c> lstTierstoDelete = [select id from Tier__c where Program_Cycle__c in :lstDelIDs];
        
        delete lstTierstoDelete;
        
    }   

}