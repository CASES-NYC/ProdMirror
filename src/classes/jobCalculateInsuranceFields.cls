global class jobCalculateInsuranceFields {

    global utilityIDs utilIDs = new utilityIDs();
    
    global void main(date dteStart, date dteEnd) {
        
        //list of contact Ids to process
        list<Id> lstContactIdstoQuery = new list<Id>();
        list<Contact> lstContactstoUpdate = new list<Contact>();
        
        //contacts intaked or exited in the date range
        list<ContactHistory> lstCHistory = [select ContactId from ContactHistory 
                                            where Field in ('Current_Intake_Date__c', 'Current_Exit_Date__c')
                                            and CreatedDate >= :dteStart and CreatedDate <= :dteEnd];
        
        //PRs edited in date range                                  
        list<Program_Relationships__c> lstUpdatedPRs = [select Warrant__c from Program_Relationships__c
                                                        where LastModifiedDate >= :dteStart 
                                                        and LastModifiedDate <= :dteEnd];
                                                
        for(ContactHistory ch: lstCHistory) {
            
            lstContactIdstoQuery.add(ch.ContactId);
        }       
        
        for(Program_Relationships__c pr: lstUpdatedPRs) {
            
            lstContactIdstoQuery.add(pr.Warrant__c);
        }                                           
                                                        
        list<Contact> lstContactsToQuery = [select id, Do_you_have_Insurance__c, Insurance_Status_at_Exit__c,
                                            Health_Home_at_Intake__c, Health_Home_at_Exit__c,
                                            Current_Intake_Date__c, Current_Exit_Date__c,
                                            (select id, Active_At_Intake__c, Active_at_Exit_Picklist__c,
                                            program__r.Name, program__r.Agency_Type__c
                                            from Program_Relationships__r
                                            where program__r.Name in ('Medicaid', 'Medicare', 'Private Insurance')
                                            or program__r.Agency_Type__c includes ('Health Home'))
                                            from Contact where id in :lstContactIdstoQuery
                                            and RecordTypeId in (:utilIDs.conCRT, :utilIDs.conDTC, :utilIDs.conCCM, :utilIDs.conTRP)];
                                            
        for(Contact c: lstContactsToQuery) {
            
            //default values. Only set "no" if corresponding date is filled in, otherwise leave blank
            String strInsuranceIntake = (c.Current_Intake_Date__c!=null)?'No':null;
            String strInsuranceExit = (c.Current_Exit_Date__c!=null)?'No':null;
            String strHHIntake = (c.Current_Intake_Date__c!=null)?'No':null;
            String strHHExit = (c.Current_Exit_Date__c!=null)?'No':null;
            
            for(Program_Relationships__c pr: c.Program_Relationships__r) {
                
                //Insurance
                if(pr.program__r.Name == 'Medicaid' || pr.program__r.Name == 'Medicare'
                || pr.program__r.Name == 'Private Insurance') {
                    
                    if(pr.Active_at_Intake__c && c.Current_Intake_Date__c != null) {
                        
                        strInsuranceIntake = 'Yes';
                    }
                    
                    if(pr.Active_at_Exit_Picklist__c == 'Yes'  && c.Current_Exit_Date__c != null) {
                        
                        strInsuranceExit = 'Yes';
                    }
                } else if(pr.program__r.Agency_Type__c.contains('Health Home')) {//Health Home

                    if(pr.Active_at_Intake__c && c.Current_Intake_Date__c != null) {
                        
                        strHHIntake = 'Yes';
                    }
                    
                    if(pr.Active_at_Exit_Picklist__c == 'Yes'  && c.Current_Exit_Date__c != null) {
                        
                        strHHExit = 'Yes';
                    }                   
                }
            }
            
            if(strInsuranceIntake != c.Do_you_have_Insurance__c || strInsuranceExit != c.Insurance_Status_at_Exit__c
            || strHHIntake != c.Health_Home_at_Intake__c || strHHExit != c.Health_Home_at_Exit__c) {
            
                c.Do_you_have_Insurance__c = strInsuranceIntake;
                c.Insurance_Status_at_Exit__c = strInsuranceExit;
                c.Health_Home_at_Intake__c = strHHIntake;
                c.Health_Home_at_Exit__c = strHHExit;
                lstContactstoUpdate.add(c);
            }
        }       
        
        update lstContactsToUpdate;                          
    }
}