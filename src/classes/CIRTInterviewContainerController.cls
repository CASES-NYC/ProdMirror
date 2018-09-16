public class CIRTInterviewContainerController{
     public string portalName{get;set;} 
    //Instance of the flow
    public utilityIds utilIds = new utilityIds();
    public Contact c {get;set;}    
    
    // Constructor
    public CIRTInterviewContainerController() { 
    	portalName = ApexPages.currentPage().getParameters().get('portalName');      	  
        String strContactId = ApexPages.currentPage().getParameters().get('ContactId');
        if(strContactId != null) {
            c = [SELECT id, FirstName, LastName, Name, P_C_ID__c
                FROM Contact WHERE Id = :strContactId limit 1];  
        }
    }
    
    public String getstrURL() {
      if (portalName == null) 
         return '/apex/programRelationshipsHistory?contact=' + encodingUtil.urlEncode(c.id, 'UTF-8');
      else
         return '/apex/programRelationshipsHistory?contact=' + encodingUtil.urlEncode(c.id, 'UTF-8')
         +'portalName=All';
                        
        /*return '/a0O/e?CF00N60000001p94o=' + c.FirstName + c.LastName
        + '&CF00N60000001p94o_lkid=' + encodingUtil.urlEncode(c.id, 'UTF-8')
        + '&RecordType=' + encodingUtil.urlEncode(utilIds.progRelProgramHistoryCIRT, 'UTF-8');*/
        
        //return '/a0O/e?CF00N60000001p94o=' + encodingUtil.urlEncode(c.Name, 'UTF-8');
    }   
}