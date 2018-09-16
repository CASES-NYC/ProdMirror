public with sharing class attorneyInfoController {
   public string portalName{get;set;}   
    public utilityIds utilIds = new utilityIds();
    public String strCase = System.currentPagereference().getParameters().get('case');  
    public String strContact = System.currentPagereference().getParameters().get('contact');  
    public Case_Information__c thisCase {get;set;}
    public Contact thisContact {get;set;}
    public Boolean bolSaveSuccessful {get;set;}
    public Boolean bolConsentYes {get;set;}
    public String strOriginalOutcome = '';

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public attorneyInfoController() { 
       	portalName = ApexPages.currentPage().getParameters().get('portalName');   
        if (strCase != null && strCase != ''){
        thisCase = [select id, Defense_Attorney_Law_Guardian__c, Affiliation__c
            from Case_Information__c where id = :strCase];
            
        thisContact = [select id, Attorney_Consent__c, Attorney_Consent_Description__c,
            Attorney_Decision_Date__c, Supervising_Attorney__c, Resource_Coordinator_s_Comments__c,
            FirstName, LastName, P_C_ID__c, Screening_Stage__c, Client_Status__c, Interview_Stage__c,
            CIRT_Final_Outcome__c, CIRT_Final_Outcome_Date__c, Final_Outcome_Modified_Date__c
            from Contact where id = :strContact];
        
        strOriginalOutcome = thisContact.CIRT_Final_Outcome__c; 
            
        }  

    }
    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() { }
      
    
    public pageReference goNewAttorney() {
        
            PageReference prRef = new PageReference('/003/e?RecordType=012600000004zCA&ent=Contact');
            prRef.setRedirect(true);
            return prRef;       
    }
    
    public pageReference goPortal() {
    	 	PageReference prRef;
        if (portalName == null)
            prRef = new PageReference('/apex/courtPortal');
        else
            prRef = new PageReference('/apex/allCourtsPage');
        
//            PageReference prRef = new PageReference('/apex/courtPortal');
            prRef.setRedirect(true);
            return prRef;       
    }    
    
    public pageReference goInterview() {
        
            PageReference prRef = new PageReference('/apex/CIRTInterviewContainer?ContactId=' + thisContact.Id);
            prRef.setRedirect(true);
            return prRef;       
    }  
    
    public void updateAttorneyInfo() {
        
        try {
            if(thisContact.Attorney_Consent__c == 'Yes') {
                
                thisContact.Screening_Stage__c = 'Pending Interview';
                thisContact.Interview_Stage__c = 'Consent';
                bolConsentYes = true;
                
                if(strOriginalOutcome != '' && strOriginalOutcome != null) {
                    
                    thisContact.CIRT_Final_Outcome__c = null;
                    thisContact.CIRT_Final_Outcome_Date__c = null;
                    thisContact.Final_Outcome_Modified_Date__c = system.today();
                    thisContact.Client_Status__c = 'Incomplete Screening';
                }
                
            } else if(thisContact.Attorney_Consent__c == 'No'){
                
                thisContact.Client_Status__c = 'Never Enrolled';                
                thisContact.CIRT_Final_Outcome__c = 'Attorney not consented';
                thisContact.CIRT_Final_Outcome_Date__c = thisContact.Attorney_Decision_Date__c;
                thisContact.Final_Outcome_Modified_Date__c = system.today();
            }
                        
            update thisContact;
            update thisCase;
            bolSaveSuccessful = true;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            bolSaveSuccessful = false;
        }
        
    }
    


}