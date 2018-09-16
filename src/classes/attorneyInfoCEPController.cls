public with sharing class attorneyInfoCEPController {
   public string portalName{get;set;}    
    public utilityIds utilIds = new utilityIds();
    public String strCase = System.currentPagereference().getParameters().get('case');  
    public String strContact = System.currentPagereference().getParameters().get('contact');  
    public Case_Information__c thisCase {get;set;}
    public Contact thisContact {get;set;}
    public Boolean bolSaveSuccessful {get;set;}


    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public attorneyInfoCEPController() { 
        portalName = ApexPages.currentPage().getParameters().get('portalName');
        if (strCase != null && strCase != ''){
        
        thisCase = [select id, Defense_Attorney_Law_Guardian__c, Affiliation__c, Prosecutor__c, 
            Judge__c, Probation_Officer__c, PSI_Officer__c
            from Case_Information__c where id = :strCase];
            
        thisContact = [select id, accountId, FirstName, LastName, P_C_Id__c, Screening_Stage__c,
            Attorney_Called_On__c, Attorney_Consent__c, Attorney_Decision_Date__c, Attorney_Notes__c
            from Contact where id = :strContact];
            
        }  

    }
    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() { }
    
    public pageReference goPortal() {
    	PageReference prRef;
        if (portalName == null)
            prRef = new PageReference('/apex/courtPortal_CEP');
        else
            prRef = new PageReference('/apex/allCourtsPage');
        
            prRef.setRedirect(true);
            return prRef;       
    }    
    
    public pageReference goAttorneyConsent() {
       	PageReference prRef;
        if (portalName == null)
            prRef = new PageReference('/apex/cepIntakeContainer?contactId=' + thisContact.Id
                + '&accountId=' + thisContact.accountId + '&intakeCaseId=' + case.id + '&stage=Attorney');
        else
            prRef = new PageReference('/apex/cepIntakeContainer?contactId=' + thisContact.Id
                + '&accountId=' + thisContact.accountId + '&intakeCaseId=' + case.id
                + '&stage=Attorney&portalName=All');
        
            prRef.setRedirect(true);
            return prRef;       
    }  
    
    public void updateAttorneyInfo() {
        
        try {
        
            if(thisContact.Attorney_Consent__c == 'Yes') {
            
                thisContact.Screening_Stage__c = 'Pending Interview';
            }            
            update thisCase;
            update thisContact;
            bolSaveSuccessful = true;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            bolSaveSuccessful = false;
        }
        
    }
    


}