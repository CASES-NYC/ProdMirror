public class u_cepIntakeContainerController {
    public string portalName{get;set;}
    //Instance of the flow
    public Contact c {get;set;}    
    public String contactId {get;set;}
    public String accountId {get;set;}
    public String intakeCaseId {get;set;}
    public String stage {get;set;}
    
    // Constructor
    public u_cepIntakeContainerController() { 
  	    portalName = ApexPages.currentPage().getParameters().get('portalName');    	
        contactId = ApexPages.currentPage().getParameters().get('contactId');
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        intakeCaseId = ApexPages.currentPage().getParameters().get('intakeCaseId');
        stage = ApexPages.currentPage().getParameters().get('stage');
        if(contactId != null) {
            c = [SELECT id, FirstName, LastName, Name, Intake_Case__r.Name
                FROM Contact WHERE Id = :contactId limit 1];  
        }
    }
    
    public pageReference getcourtPortalURL() {
            string retPortalURL;
  //          if (portalName != null)
                retPortalURL = '/apex/allcourtsPage';
  //          else
     //          retPortalURL = '/apex/courtPortal_CEP';
/*
            else{
   	          if (portalName == 'CIRT')
               retPortalURL = '/apex/courtPortal';
              else{
               if (portalName == 'SRP')
                  retPortalURL = '/apex/courtPortal_SRP';
               else
              
            }}   
   */
            PageReference prRef = new PageReference(retPortalURL);
            prRef.setRedirect(true);
            return prRef;
    }   
    
    public String getaddChargesURL() {
        
        //change for Production
        return '/apex/addChargesPage?SelectedDocket=' + intakeCaseId + '&ChargeList=Arrest,Criminal,Indictment,Plea';
    } 
    
    public String getattorneyInfoURL() {
        
        //change for Production
        return '/apex/Unified_AttorneyInfo?case=' + intakeCaseId + '&contact=' + contactId;
    }          
}