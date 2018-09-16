public with sharing class programRelationshipsHistoryController {
      public string portalName{get;set;}  
    public utilityIds utilIds = new utilityIds();
    public String strContact = System.currentPagereference().getParameters().get('contact');  
    public list<Program_Relationships__c> lstPrograms {get;set;}
    public Contact thisContact {get;set;}
    public String strPR = '';
    public Id prRecordTypeId = null;

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public programRelationshipsHistoryController() { 
      portalName = ApexPages.currentPage().getParameters().get('portalName');         
      thisContact = [select id, FirstName, LastName, P_C_Id__c
            from Contact where id = :strContact];   
            
        //CIRT or START user?
            Id prRecordTypeId = null;
            if(thisContact.P_C_ID__c.contains('CRT')) {
                
    //            strPR = '/apex/courtPortal';
      strPR = '/apex/allCourtsPage';
                prRecordTypeID = utilIds.progRelProgramHistoryCIRT;
            } else {
                
                strPR = '/apex/searchPortal_new'; 
                prRecordTypeID = utilIds.progRelProgramHistory;             
            }                   
        
        lstPrograms = new list<Program_Relationships__c>{
            new Program_Relationships__c(Warrant__c = thisContact.Id, 
                RecordTypeId = prRecordTypeID), 
            new Program_Relationships__c(Warrant__c = thisContact.Id, 
                RecordTypeId = prRecordTypeID),
            new Program_Relationships__c(Warrant__c = thisContact.Id, 
                RecordTypeId = prRecordTypeID), 
            new Program_Relationships__c(Warrant__c = thisContact.Id, 
                RecordTypeId = prRecordTypeID), 
            new Program_Relationships__c(Warrant__c = thisContact.Id, 
                RecordTypeId = prRecordTypeID)};                            
    }
    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() { }   
    
    public pageReference goPortal() {
        pageReference prRef;
        if (portalName != null)
           prRef = new PageReference('/apex/allCourtsPage');
        else
             prRef = new pageReference(strPR);
             prRef.setRedirect(true);
        return prRef;       
    }        
    
    public void savePRS() {  
                       
        try {
            
            list<Program_Relationships__c> lstPRstoInsert = new list<Program_Relationships__c>();
            
            //add cases
            for(Program_Relationships__c pr: lstPrograms) {
            
                //add other cases
                if(pr.Program__c != null) {
                                    
                    lstPRstoInsert.add(pr);
                }           
            }
            
            //cases DML
            if(lstPRstoInsert.size() > 0) {
                
                insert lstPRstoInsert;
                lstPrograms = new list<Program_Relationships__c>{
                    new Program_Relationships__c(Warrant__c = thisContact.Id, 
                        RecordTypeId = prRecordTypeID), 
                    new Program_Relationships__c(Warrant__c = thisContact.Id, 
                        RecordTypeId = prRecordTypeID),
                    new Program_Relationships__c(Warrant__c = thisContact.Id, 
                        RecordTypeId = prRecordTypeID), 
                    new Program_Relationships__c(Warrant__c = thisContact.Id, 
                        RecordTypeId = prRecordTypeID), 
                    new Program_Relationships__c(Warrant__c = thisContact.Id, 
                        RecordTypeId = prRecordTypeID)};
            }
                        
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
        }         
        
    }
    


}