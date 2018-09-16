public class STARTFlowContainerController{

    //Instance of the flow
    public Flow.Interview.START_Reinstatement_Flow flReinstatement {get; set;}
    public Flow.Interview.START_Enroll_in_Voluntary flVoluntary {get; set;}
    public Flow.Interview.START_Intake_Flow flOrientation {get; set;}
    public Contact cHeader {get;set;}    
    
    // Constructor
    public STARTFlowContainerController() { 
        strContactId = ApexPages.currentPage().getParameters().get('ContactId');
        strFlow = ApexPages.currentPage().getParameters().get('Flow');
        strdocketId = ApexPages.currentPage().getParameters().get('docketId');
        if(strContactId != null) {
            cHeader = [SELECT FirstName, LastName, P_C_ID__c
                FROM Contact WHERE Id = :strContactId limit 1];  
        }
    }
    
    // GETer
    public String strContactId {
        get {
            
            // Pull from Query String
            if(strContactId == null) { 
                strContactId = ApexPages.currentPage().getParameters().get('ContactId'); 
            }       
            
            if(strContactId != null) {
                cHeader = [SELECT FirstName, LastName, P_C_ID__c
                    FROM Contact WHERE Id = :strContactId limit 1];  
            }       
            
            ApexPages.currentPage().getParameters().put('ContactId', strContactId);
            
            return strContactId;
        } 
        set {strContactId = value;}
    }   
    
    public String strDocketId {
        get {
            // Pull from Query String
            if(strDocketId == null) { 
                strDocketId = ApexPages.currentPage().getParameters().get('docketId'); 
            }
            
            ApexPages.currentPage().getParameters().put('docketId', strDocketId);
            
            return strDocketId;

        }
        set {strDocketId = value;}
    }    
    
    public String strFlow {
        get {
            
            // Pull from Query String
            if(strFlow == null) { 
                strFlow = ApexPages.currentPage().getParameters().get('Flow'); 
            }   
            
            ApexPages.currentPage().getParameters().put('Flow', strFlow);
            
            return strFlow;
        } 
        set {strFlow = value;}
    } 
     
    public Boolean getbolComplete() {
    
        String strComplete = '';    
        
        if(flReinstatement == null && flVoluntary == null && flOrientation == null) { 
            return false;
        } else {
            
            if (strFlow == 'Reinstatement'){
                strComplete = string.valueOf(flReinstatement.getVariableValue('bolComplete'));
            } else if (strFlow == 'Voluntary'){
                strComplete = string.valueOf(flVoluntary.getVariableValue('bolComplete'));
            } else {
                strComplete = string.valueOf(flOrientation.getVariableValue('bolComplete'));
            }
            
            if(strComplete == null) {
                return false;
            } else {
                return boolean.valueOf(strComplete);
            }
        }
    }
    
}