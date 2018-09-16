public class tierMethods {

    public list<Id> lstPCIds = new list<Id>();
    public list<Tier__c> lstTiers = new list<Tier__c>();
    
    public void setMostRecentFlag() {
        
        //get all tiers to loop through
        list<Program_Cycle__c> lstPCs = [select id, Most_Recent_Tier__c,
        (select id, Start_Date__c from Tiers__r order by Start_Date__c asc)
        from Program_Cycle__c
        where id in :lstPCIds];
        
        Tier__c tierMR = new Tier__c();
        
        for(Program_Cycle__c pc: lstPCs) {
        
            tierMR = new Tier__c();
            
            for(Tier__c t: pc.Tiers__r) {
            
                tierMr = t;
            }
            
            pc.Most_Recent_Tier__c = tierMr.Id;
        }
        
        //dml
        update lstPCs;
                                
    }
    
    public void setContact() {
        
        map<Id, Program_Cycle__c> mapPCs = new map<Id, Program_Cycle__c>([select id, Client__c 
                                                                      from Program_Cycle__c
                                                                      where id in :lstPCIDs]);
                                         
        for(Tier__c t: lstTiers) {
            
            t.Contact__c = mapPCs.get(t.Program_Cycle__c).Client__c; 
        }                                
    }

}