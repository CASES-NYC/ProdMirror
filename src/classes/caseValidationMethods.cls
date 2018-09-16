public class caseValidationMethods {

    public utilityIds utilIds = new utilityIds();
    public Map<ID, Case_Information__c> mapNew = new map<Id, Case_Information__c>();
    public list<Case_Information__c> lstNewCases = new list<Case_Information__c>();
    public list<Case_Information__c> lstOldCases = new list<Case_Information__c>();
    public Boolean bolIsNew;
    
    public void createCaseRelationships() {
    
        integer i = 0;
        list<Id> lstCaseIdsforCRs = new list<Id>();
        
        if(bolIsNew) {
        
            for(Case_Information__c ciNew: lstNewCases) {
                
                lstCaseIdsforCRs.add(ciNew.id);
            }
        } else {
        
            for(Case_Information__c ciNew: lstNewCases) {

                if(ciNew.Arrest_Date__c != lstOldCases [i].Arrest_Date__c
                || ciNew.Criminal_Court_Arraignment_Date__c != lstOldCases [i].Criminal_Court_Arraignment_Date__c
                || ciNew.Family_Court_Arraignment_Date__c != lstOldCases [i].Family_Court_Arraignment_Date__c
                || ciNew.Supreme_Court_Arraignment_Date__c != lstOldCases [i].Supreme_Court_Arraignment_Date__c
                || ciNew.Sentence_Disposition_Date__c != lstOldCases [i].Sentence_Disposition_Date__c){
                
                    lstCaseIdsforCRs.add(ciNew.id);
                }  
                         
                i++;
            }      
        }
        
        if(lstCaseIdsforCRs.size() > 0) {
        
            CaseRelationshipFutureMethods.main(null, lstCaseIdsforCRs);
        }
    
    }
    
    public void validateCase(){
        
        List<String> lstDocketNames  = new list<String>();
        
        //Find out which validations need to be done
        for (Case_Information__c c_new : lstNewCases){

            if ((c_new.Name == '' || c_new.Name == null || c_new.Name == 'Docket NA')) {
            
                if(c_new.No_Docket__c == false){
                    c_new.addError('You must enter a Docket # for this case.  If this case does not require a Docket #, check the \'No Docket\' check box.');
                } else {
                    c_new.Name = 'Docket NA';
                }
            } else {
            
                lstDocketNames.add(c_new.Name);
            }
        }
        
        //Get existing docket matches
        
        list<Case_Information__c> lstDuplicateCases = [select id, Name from Case_Information__c
                                                        where Name in :lstDocketNames];
                                                        
        for(Case_Information__c ciNew: lstNewCases) {     
        
            for(Case_Information__c ciDupe: lstDuplicateCases) {  
            
                if(ciNew.Name == ciDupe.Name && ciNew.Id != ciDupe.Id) {                                         
                            
                    ciNew.Name.addError('This Docket Number already exists for this client. Click the following link '
                    + 'to view the existing docket. You may have hit the save button twice, or the client might already '
                    + 'have an existing account.\r\r' +  URL.getSalesforceBaseUrl().toExternalForm() 
                    + '/' + ciDupe.Id);
                }            
            }
        }      
        
    }
    
    public void deleteCase() {
    
        for (Case_Information__c c : mapNew.values()){
            
            //Come back to this
            /*
            if ((c.RecordTypeId == utilIds.caseInfoSupremeCourt || c.RecordTypeId == utilIds.caseInfoFamilyCourt )
            && (userInfo.getUserID() != utilIds.systemAdmin && userInfo.getUserID() != utilIDs.strategicPlanning)){
                
                c.addError('Intake cases cannot be deleted. Please post a task in the Database Helpdesk.');
            }*/
        }       
        
        //Delete children (related charges and detained dates)
            list<Case_Charges__c> lstCharges = [Select Id from Case_Charges__c where Docket_No__c in :mapNew.keySet()];   
            delete lstCharges;
        
            list<Detained_Dates__c> lstDetained = [Select Id from Detained_Dates__c where Docket_No__c in :mapNew.keySet()];
            delete lstDetained;    
            
            list<Case_Relationship__c> lstCRs = [Select Id from Case_Relationship__c where Docket__c in :mapNew.keySet()];
            delete lstCRs;                
    }
}