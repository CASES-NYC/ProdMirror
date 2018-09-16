public with sharing class setCIRTClientNotEligibleController {
    
    public utilityIds utilIds = new utilityIds();
    public String strContact = System.currentPagereference().getParameters().get('contact');  

    public Contact thisContact {get;set;}
    public Program_Plan__c thisPP {get;set;}
    public Progress_Note__c thisPN {get;set;}
    public Task tskDummy {get;set;}
    public String strRejectReason {get;set;}
    public Boolean bolSaveSuccessful {get;set;}

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public setCIRTClientNotEligibleController() { 
        
        thisContact = [select id, FirstName, LastName, P_C_ID__c, Client_Status__c, Intake_Case__c
            from Contact where id = :strContact];           
            
        thisPP = [select id from Program_Plan__c where Most_Recent_Program_Plan__c = true
            and Client_Name__c = :strContact];  
            
        thisPN = new Progress_Note__c(Program_Plan__c = thisPP.id, 
            recordTypeId = utilIds.progressNoteCIRT, Area__c = 'Judicial and Civic Accountability');
            
        tskDummy = new Task(ActivityDate = system.today()); 
            
    }
    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() { }
    
    public List<SelectOption> getLstReasons() {
        
        List<SelectOption> lstTemp = new List<SelectOption>();
        
        lstTemp.add(new SelectOption('', ''));
        lstTemp.add(new SelectOption('Accepted Other ATI-Program-Offer', 'Accepted Other ATI-Program-Offer'));        
        lstTemp.add(new SelectOption('Already involved in another program', 'Already involved in another program'));
        lstTemp.add(new SelectOption('Discharged from DOC', 'Discharged from DOC'));
        lstTemp.add(new SelectOption('Excluded Charge', 'Excluded Charge'));
 //       lstTemp.add(new SelectOption('Attorney not consented', 'Attorney not consented'));  
        lstTemp.add(new SelectOption('Ineligible', 'Ineligible'));
        lstTemp.add(new SelectOption('Rejected by Attorney', 'Rejected by Attorney'));
        lstTemp.add(new SelectOption('Rejected by ADA', 'Rejected by ADA'));          
        lstTemp.add(new SelectOption('Rejected by Inmate-Client', 'Rejected by Inmate-Client'));
        lstTemp.add(new SelectOption('Rejected by Judge', 'Rejected by Judge'));
        lstTemp.add(new SelectOption('Sentenced-Plead at CIRT referral', 'Sentenced-Plead at CIRT referral'));  
        lstTemp.add(new SelectOption('730 Ordered', '730 Ordered'));
        lstTemp.add(new SelectOption('Unfit', 'Unfit'));
        lstTemp.add(new SelectOption('Other', 'Other'));
 
  
        return lstTemp;
        
    }      
      
    
    public void updateClient() {
        
        string strTempOutcome = '';
        
        try {
            
            //old code for multipicklist
            /*
            for(string s: strRejectReasons.split(';', 0)) {
                
                strTempOutcome += s;
                strTempOutcome += ', ';
            }
            
            strTempOutcome = strTempOutcome.substring(1, strTempOutcome.length()-3);
            thisCase.Final_Outcome__c = strTempOutcome;*/
        
                
            thisContact.Client_Status__c = 'Never Enrolled';                
            thisContact.CIRT_Final_Outcome__c = strRejectReason; 
            thisContact.CIRT_Final_Outcome_Date__c = tskDummy.ActivityDate;
            thisContact.Final_Outcome_Modified_Date__c = system.today();
                        
            update thisContact;
            
            if(thisPN.Progress_Note__c != null) {
                
                thisPN.Date__c = tskDummy.ActivityDate;
                insert thisPN;
            }
            
            bolSaveSuccessful = true;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            bolSaveSuccessful = false;
        }
        
    }
    


}