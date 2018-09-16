public class STARTInterviewPage1Controller{

    //Instance of the flow
    public Flow.Interview.Start_Screening_Part_1 flStartPart1 {get; set;}
    public Flow.Interview.START_Screening_Part_2 flStartPart2 {get; set;}
    public Contact cHeader {get;set;}    
    
    // Constructor
    public STARTInterviewPage1Controller() { 
        strContactId = ApexPages.currentPage().getParameters().get('ContactId');
    }
    
    // GETer
    public PageReference strFlow1EndPage {
        get {
            System.Debug(LoggingLevel.ERROR, 'PARSING FLOW 1 END');
            
            PageReference prRef = new PageReference('/apex/STARTInterviewPage1?ContactId=' + strContactId + '&selectedDocket=' + strDocketId);
            //PageReference prRef = new PageReference('/');
            prRef.setRedirect(true);
            
            System.Debug(LoggingLevel.ERROR, prRef);
            
            return prRef;
        }
        set {strFlow1EndPage = value;}
    }
    
    public PageReference getstrFlow2EndPage() {
        
        PageReference prRef = new PageReference('null');
        
        Contact c = [select id, P_C_Id__c from Contact where id = :strContactId];
        
        if(c.P_C_ID__c.contains('DTC')) {
        
            prRef = new PageReference('/' + strContactId);
        } else {
        
            prRef = new PageReference('/apex/programRelationshipsHistory?contact=' + strContactId);
        }
        return prRef;   
    }
    
    public String strContactId {
        get {
            
            // Pull from Query String
            if(strContactId == null) { 
                strContactId = ApexPages.currentPage().getParameters().get('ContactId'); 
            }
            
            // Test from Flow 1
            if(strContactId == null && flStartPart1 != null) { 
                strContactId = string.valueOf(flStartPart1.getVariableValue('contactId')); 
            }
            
            ApexPages.currentPage().getParameters().put('ContactId', strContactId);
            
            return strContactId;
        } 
        set {strContactId = value;}
    }   
    
    public String getstrStepProgress() {
        
        String strTemp = '';
        
        // Check ContactId if passed
        if(strContactId != null) {
            Contact c = [SELECT FirstName, LastName, P_C_ID__c, Screening_Stage__c, Client_Status__c 
                FROM Contact WHERE Id = :strContactId];
            cHeader = c;
            strTemp = c.Screening_Stage__c;
            
            // Send page to Flow 2 if "Change Screening Outcome" button is clicked
            if(c.Screening_Stage__c == 'Screening Complete' && c.Client_Status__c == 'Never Enrolled' 
                && (c.P_C_Id__c.contains('DTC') || c.P_C_Id__c.contains('CCM'))) {
                
                strTemp = 'Flow 2 - Compliance';
            }       
        } else { //if contact not created yet, use name from account, stored in temp contact
            
            cHeader = new Contact(LastName = ApexPages.currentPage().getParameters().get('accountName'));
        }
        
        
        // Check Flow 1 if open 
        if(strTemp == '' && flStartPart1 != null) { 
            strTemp = string.valueOf(flStartPart1.getVariableValue('ScreeningStage'));
        }
        
        return strTemp;
        
    }
    
    public String strDocketId {
        get {
            // Pull from Query String
            if(strDocketId == null) { 
                strDocketId = ApexPages.currentPage().getParameters().get('selectedDocket'); 
            }
            
            // Test from Flow 1
            if(strDocketId == null && flStartPart1 != null) { 
                strDocketId = string.valueOf(flStartPart1.getVariableValue('DocketID')); 
            }
            
            ApexPages.currentPage().getParameters().put('selectedDocket', strDocketId);
            
            return strDocketId;

        }
        set {strDocketId = value;}
    }
    
    public String getstrProgram() {
    
        if(flStartPart1 == null) { 
            return null;
        } else {
            return string.valueOf(flStartPart1.getVariableValue('Program'));
        }
    }
    
    public String getstrProgramCycleId() {
    
        if(flStartPart1 == null) { 
            return null;
        } else {
            return string.valueOf(flStartPart1.getVariableValue('ProgramCycleId'));
        }
    }
    
    public String getstraddressId() {
    
        if(flStartPart1 == null) { 
            return null;
        } else {
            return string.valueOf(flStartPart1.getVariableValue('addressId'));
        }
    }
    
    public String getstrBJMHSTestId() {
    
        if(flStartPart1 == null) { 
            return null;
        } else {
            return string.valueOf(flStartPart1.getVariableValue('BJMHSTestId'));
        }
    }
    
    public String getstrG_AccountId() {
    
        if(flStartPart1 == null) { 
            return null;
        } else {
            return string.valueOf(flStartPart1.getVariableValue('G_AccountId'));
        }
    }
    
    // Action
    public PageReference moveToCharges() {
    
        System.Debug(LoggingLevel.ERROR, 'MOVE TO CHARGES');
    
        Contact c = new Contact(Id=strContactId,Screening_Stage__c='Charges Page');
        update c;
        
        PageReference prRef = new PageReference('/apex/STARTInterviewPage1?ContactId=' + strContactId + '&selectedDocket=' + strDocketId);
        prRef.setRedirect(true);
        return prRef;
        
    }
    
    public PageReference moveToFlow2() {
    
        System.Debug(LoggingLevel.ERROR, 'MOVE TO FLOW 2');
    
        Contact c = new Contact(Id=strContactId,Screening_Stage__c='Flow 2 - Compliance');
        update c;
        
        PageReference prRef = new PageReference('/apex/STARTInterviewPage1?ContactId=' + strContactId + '&selectedDocket=' + strDocketId);
        prRef.setRedirect(true);
        return prRef;
        
    }
    
}