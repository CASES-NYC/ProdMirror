public with sharing class programRelationshipMethods {
    
    public void updateProgRelNonPRP(List<Id> lstPRIds) {
        
        //lists and maps
        //map<id, FollowUp__c> mapMostRecentFU = new map<id, FollowUp__c>();
        
        //find related Program Relationships
        list<Program_Relationships__c> lstPRs =  [select id, Discharge_Date_Phone_Visit__c, 
        Last_Verified_Phone_Visit__c, Program_Status_Phone_Visit__c, Discharge_Transfer_Reason__c, 
        Program_Start_Date__c,
        (select id, Program_Relationships__c, Date_Of_Follow_Up__c, Program_Status__c, 
        Discharge_Transfer_Reason__c, Discharge_Date_By_Phone_Visit__c, New_Program_Start_Date_If_Any__c 
        from FollowUps__r where Follow_Up_Outcome__c = 'Status Confirmed' 
        order by Date_Of_Follow_Up__c desc limit 1)
        from Program_Relationships__c where id in :lstPRIds];
        
        //get most recent successful follow up for each PR in scope
        /*for(Program_Relationships__c pr: [select id, name, 
        (select id, Program_Relationships__c, Date_Of_Follow_Up__c, Program_Status__c, 
        Discharge_Transfer_Reason__c, Discharge_Date_By_Phone_Visit__c, New_Program_Start_Date_If_Any__c 
        from FollowUps__r where Follow_Up_Outcome__c = 'Status Confirmed' 
        order by Date_Of_Follow_Up__c desc limit 1) from Program_Relationships__c 
        where id in :lstPRIds]) {
            
            for(FollowUp__c fu: pr.FollowUps__r) {
                
                mapMostRecentFU.put(pr.id, fu);
            }
        }*/
            
        //set values on program relationship    
        for(Program_Relationships__c pr: lstPRs) {
            
            //PR won't be in map if there were no "status confirmed" follow ups related to it
            if(pr.FollowUps__r.size() == 0) {
                
                pr.Discharge_Date_Phone_Visit__c = null;
                pr.Discharge_Transfer_Reason__c = null;
                pr.Last_Verified_Phone_Visit__c = null;
                pr.Program_Status_Phone_Visit__c = 'Pending Intake';
            } else {
                
                pr.Last_Verified_Phone_Visit__c = pr.FollowUps__r[0].Date_Of_Follow_Up__c;
                pr.Discharge_Date_Phone_Visit__c = pr.FollowUps__r[0].Discharge_Date_By_Phone_Visit__c;
                pr.Discharge_Transfer_Reason__c = pr.FollowUps__r[0].Discharge_Transfer_Reason__c;
                pr.Program_Status_Phone_Visit__c = pr.FollowUps__r[0].Program_Status__c;
                if(pr.FollowUps__r[0].New_Program_Start_Date_If_Any__c != null) {
                    
                    pr.Program_Start_Date__c = pr.FollowUps__r[0].New_Program_Start_Date_If_Any__c;
                }                
            }   
        }   
        
        //dml
        update lstPRs;
    }
}