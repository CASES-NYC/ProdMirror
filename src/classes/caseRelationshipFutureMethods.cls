global class caseRelationshipFutureMethods {

    @future
    //pass one list, which will indicate a list of records that were determined by the trigger
    //to meet the criteria for changes
    public static void main(list<id> lstContactIds, list<id> lstCaseIds) {
        
        //identify contacts and cases that are used to build new CRs
        list<Id> lstAccountIds = new list<Id>();
        list<Account> lstAccounts = new list<Account>();
        map<Id, Contact> mapCycles = new map<Id, Contact>();
        list<Case_Relationship__c> lstExistingCRs = new list<Case_Relationship__c>(); 
        map<String, Case_Relationship__c> mapExistingCRs = new map<String, Case_Relationship__c>();
        
        //create new Case Relationships
        list<Case_Relationship__c> lstCRsToUpsert = new list<Case_Relationship__c>();       

        if(lstCaseIds != null && lstCaseIds.size() > 0) {
        
            for(Case_Information__c ci: [select id, Client_Account__c from Case_Information__c
                                        where id in :lstCaseIds]) {
                
                lstAccountIds.add(ci.Client_Account__c); 
            }                              
        }   

        if(lstContactIds != null && lstContactIds.size() > 0) {
        
            for(Contact c: [select id, AccountId from Contact
                                            where id in :lstContactIds]) {
                    
                lstAccountIds.add(c.AccountId);               
            }             
        }           
            
        lstExistingCRs = [select id, Contact__c, Docket__c, Case_Type__c from Case_Relationship__c
            where Docket__r.Client_Account__c in :lstAccountIds];  

        for(Case_Relationship__c cr: lstExistingCRs) {
        
            mapExistingCRs.put(cr.Contact__c + ';' + cr.Docket__c, cr);
        }

        //identify all contacts and cases to process
        lstAccounts = [select id, 
                                        (select id, AccountId, CreatedDate, RecordTypeId, Intake_Date__c, Exit_Date_1__c, 
                                        Current_Intake_Date__c, Current_Exit_Date__c, Intake_Case__c, Client_Status__c 
                                        from Contacts),
                                        
                                        (select id, Client_Account__c, CreatedDate, RecordTypeId, 
                                        Arrest_Date__c, Criminal_Court_Arraignment_Date__c, Family_Court_Arraignment_Date__c,
                                        Supreme_Court_Arraignment_Date__c, Sentence_Disposition_Date__c, Sentence_Type__c
                                        from Case_Information__r 
                                        )
                                    from Account
                                    where Id in :lstAccountIds];
                                    
        list<Id> lstAllContactIds = new list<Id>();
        
        for(Account a: lstAccounts) {
        
            for(Contact c: a.Contacts) {
                
                lstAllContactIds.add(c.id);
            }
        }
                                    
        list<Contact> lstContactswithCycles = [select id, 
                                                (select id, Start_Date__c, End_Date__c from Program_Cycles__r 
                                                order by Start_Date__c asc)
                                              from Contact where id in :lstAllContactIds];
                                              
        for(Contact c: lstContactswithCycles) {
        
        
            mapCycles.put(c.id, c);
        }

        //create new CRs
        //loop through all contacts and cases to find matches
        for(Account a: lstAccounts) {
        
            for(Contact c: a.Contacts) {
                
                system.debug(c);
                
                for(Case_Information__c ci: a.Case_Information__r) {
                    
                    system.debug(ci);
                    
                    Date dteCompare = Date.NewInstance(1950,1,1);    
                    Boolean bolNoCaseDate = false;
                    
                    if(ci.Arrest_Date__c == null && ci.Criminal_Court_Arraignment_Date__c == null
                    && ci.Family_Court_Arraignment_Date__c == null && ci.Supreme_Court_Arraignment_Date__c == null
                    && ci.Sentence_Disposition_Date__c == null) {
                    
                        bolNoCaseDate = true;
                    } else if(ci.Arrest_Date__c != null) { //use arrest date if available, otherwise arraignment date
                        dteCompare = ci.Arrest_Date__c;
                    } else if(ci.Family_Court_Arraignment_Date__c != null) {
                        
                        dteCompare = ci.Family_Court_Arraignment_Date__c;
                    } else if(ci.Supreme_Court_Arraignment_Date__c != null) {
                        
                        dteCompare = ci.Supreme_Court_Arraignment_Date__c;
                    } else if(ci.Criminal_Court_Arraignment_Date__c != null) {
                        
                        dteCompare = ci.Criminal_Court_Arraignment_Date__c;
                    } else if(ci.Sentence_Disposition_Date__c != null) {
                        
                        dteCompare = ci.Sentence_Disposition_Date__c;
                    }
                    
                    system.debug(dteCompare);
                        
                    //setup new CR or find existing one
                    Case_Relationship__c newCR = new Case_Relationship__c();
                    String strCurrentCaseType = '';
                    
                    if(mapExistingCRs.containsKey(c.id+';'+ci.id)) {
                    
                        newCR = mapExistingCRs.get(c.id+';'+ci.id);
                        strCurrentCaseType = newCR.Case_Type__c;
                    } else {
                    
                        newCR.Contact__c = c.id;
                        newCR.Docket__c = ci.id;
                    }
                    
                    system.debug(newCR);
                    
                    Date dteIntake = (c.Intake_Date__c==null?c.Current_Intake_Date__c:c.Intake_Date__c);
                    boolean bolNoPublicRecord = false;
                    
                    if(dteIntake != null) {
                    
                        bolNoPublicRecord = ci.Sentence_Type__c == 'No Public Record' 
                        && ci.Sentence_Disposition_Date__c < dteIntake.addDays(14);
                    }
                    
                    //determine Case Type
                    if(c.Intake_Case__c == ci.id) {//Intake Case
                    
                        newCR.Case_Type__c = 'Intake Case';
                    } else if(dteIntake == null || c.Client_Status__c == 'Never Enrolled') {//Clients not intaked can only have intake, prior and open cases
                    
                        if(ci.Sentence_Disposition_Date__c != null) {
                        
                            newCR.Case_Type__c = 'Prior';
                        } else {
                        
                            newCR.Case_Type__c = 'Open';
                        }
                    
                    } else if(!bolNoCaseDate && dteIntake != null) {//ignore cases and contacts that do not have any dates
                    
                        if(dteCompare < dteIntake || bolNoPublicRecord) {
                        
                            if(ci.Sentence_Disposition_Date__c != null
                            && (ci.Sentence_Disposition_Date__c < c.Intake_Date__c
                            || bolNoPublicRecord)) {
                            
                                newCR.Case_Type__c = 'Prior';
                            } else {
                            
                                newCR.Case_Type__c = 'Open';
                            }
                        } else if(c.Current_Exit_Date__c != null
                        && dteCompare > c.Current_Exit_Date__c) {
                            
                            newCR.Case_Type__c = 'Post-Exit';
                        } else { //In-Program or Interim
                            
                            
                            list<Program_Cycle__c> lstPCs = mapCycles.get(c.id).Program_Cycles__r;    
                                                
                            if(lstPCs != null && lstPCs.size() > 0) {
                                
                                if(c.Current_Intake_Date__c == c.Intake_Date__c) {
                                    
                                    newCR.Case_Type__c = 'In-Program';
                                } else if(dteCompare > c.Exit_Date_1__c
                                && dteCompare < c.Current_Intake_Date__c) {
                                    
                                    newCR.Case_Type__c = 'Interim';
                                } else {
                                    
                                    newCR.Case_Type__c = 'In-Program';
                                }
                            } else { //we can do more specific calculations on programs that use cycles
                                
                                                        
                                //is the arrest date in between any cycles
                                //assume it's not
                                newCR.Case_Type__c = 'In-Program';
                                
                                system.debug(lstPCs);
                                
                                for(integer i = 1; i <= (lstPCs.size() - 1); i++) {        
                                    
                                    system.debug(lstPCs[i].Start_Date__c);
                                    system.debug(lstPCs[i-1].End_Date__c);                 
                                    
                                    if(dteCompare < lstPCs[i].Start_Date__c
                                    && dteCompare > lstPCs[i-1].End_Date__c) {
                                        
                                        newCR.Case_Type__c = 'Interim';
                                    }
                                }
                            }
                        }
                    }
                    
                    system.debug(newCR);
                    
                    if(newCR.Case_Type__c != strCurrentCaseType && newCR.Case_Type__c != null) {
                        lstCRstoUpsert.add(newCR);
                    }                    
                    
                }
            }
        }
        
        //dml
        //upsert lstCRstoUpsert;
        //use database methods so that the Unique_Id__c field can check for duplicates and only error out that specific record
        //this can happen if two future methods are executed close together, and they both query existing CRs before the other completes
        Database.UpsertResult[] result = Database.Upsert(lstCRstoUpsert,false);
    }

    public void massUpdateCRs(integer intLimit) {
    
        list<Id> lstIntakeCaseIds = new list<Id>();
        list<Contact> lstContacts = [select Intake_Case__c from Contact where RecordType.Name Like '%Client'];
        
        for(Contact c: lstContacts) {
        
            lstIntakeCaseIds.add(c.Intake_Case__c);
        }

        map<Id, Case_Information__c> mapCI = new map<Id, Case_Information__c>([select id
            from Case_Information__c
            where id not in (select Docket__c from Case_Relationship__c)
            and (Arrest_Date__c != null or Criminal_Court_Arraignment_Date__c != null
            or Family_Court_Arraignment_Date__c != null or Supreme_Court_Arraignment_Date__c != null
            or Sentence_Disposition_Date__c != null
            or Id in :lstIntakeCaseIds)
            limit :intLimit]);
        
        list<ID> lst = new list<Id>();
        lst.addAll(mapCI.keySet());
        
        CaseRelationshipFutureMethods.main(null, lst);    
    }

}