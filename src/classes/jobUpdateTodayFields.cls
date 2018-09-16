global class jobUpdateTodayFields 
{
    
    global void setToday() {
  //all tiers and cycles modified today, after the nightly run of this job (otherwise all records
        // get updated every night). Also active clients
        List<Tier__c> lstTiers = new List <Tier__c>();
        List<Program_Cycle__c>lstCycles = new List <Program_Cycle__c>();
        if(!Test.IsRunningTest())
            {lstTiers = [select id, Today__c from Tier__c
                                    where Program_Cycle__r.Client__r.Client_Status__c = 'Active'
                                    or LastModifiedDate >= :system.now().addHours(-20)];
            lstCycles = [select id, Today__c from Program_Cycle__c
                                                where Client__r.Client_Status__c = 'Active'
                                                or LastModifiedDate >= :system.now().addHours(-20)];
        }else{
            lstTiers = [select id, Today__c from Tier__c
                                    where Program_Cycle__r.Client__r.Client_Status__c = 'Active'
                                    or LastModifiedDate >= :system.now().addHours(-20)LIMIT 10];        
            lstCycles = [select id, Today__c from Program_Cycle__c
                                     where Client__r.Client_Status__c = 'Active'
                                     or LastModifiedDate >= :system.now().addHours(-20) LIMIT 10];
        }                                        

        for(Tier__c t: lstTiers) {
            
            t.Today__c = system.today();
        }   
        
        for(Program_Cycle__c p: lstCycles) {
            
            p.Today__c = system.today();
        }   
        
        //DML
        if(lstTiers.size() > 0) {
            update lstTiers;
        }
        
        if(lstCycles.size() > 0) {
            update lstCycles;           
        }
    }

}