public class cepIntakeContainerController{
   public string portalName{get;set;}
    //Instance of the flow
    public Contact c {get;set;}    
    public String contactId {get;set;}
    public String accountId {get;set;}
    public String intakeCaseId {get;set;}
    public String stage {get;set;}
    
    // Constructor
    public cepIntakeContainerController() { 
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
    
    public String getcourtPortalURL() {
  //  	string retPortalURL;
        if (portalName != null)
          return '/apex/allCourtsPage';
        else
          return '/apex/courtPortal_CEP';

        //change for Production
       
//        return '/apex/courtPortal_CEP?sfdc.tabName=01rm00000004PyA';
    }   
    
    public String getaddChargesURL() {
        
        //change for Production
        return '/apex/addChargesPage?SelectedDocket=' + intakeCaseId + '&ChargeList=Arrest,Criminal,Indictment,Plea';
    } 
    
    public String getattorneyInfoURL() {
        
        //change for Production
        return '/apex/attorneyInfo_CEP?case=' + intakeCaseId + '&contact=' + contactId;
    }          
}