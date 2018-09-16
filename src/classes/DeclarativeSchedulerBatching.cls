Global class DeclarativeSchedulerBatching implements Database.Batchable<sObject>, Database.Stateful {
global string soqlQuery;
global String FieldtoUpdate;
global String ReportID;
List<Id>recordIds;
//global set<string> recordIds = new set<string>();
global integer recordsProcessed = 0;
global integer queries = 0;

    //Get the set of ids. please work
     public DeclarativeSchedulerBatching(List<Id> recordIdsList){
        recordIds = recordIdsList;
    }   
    
 global Database.QueryLocator start(Database.BatchableContext bc) { 
        // collect the batches of records or objects to be passed to execute
        	queries++;
            return Database.getQueryLocator(soqlQuery);
      		
    }

    global void execute(Database.BatchableContext bc, List<sObject> recordstobatch){
        // process each batch of records
        
        List<sObject> recordstoupdate = recordstobatch.clone();
        recordstoupdate.clear();
        
        DateTime DateTimeNow =system.now();
        
        for(SObject eachbatch : recordstobatch ){
            recordsProcessed = recordsProcessed + 1;
            eachbatch.put(FieldtoUpdate, DateTimeNow );
            //update eachbatch;
            recordstoupdate.add(eachbatch);
        }
        
        update recordstoupdate;
        
    }    

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
         System.debug(recordsProcessed + ' records processed. Shazam!');
        System.debug('ReportID '+ReportID);
      

    }    
    
    
    
    
}