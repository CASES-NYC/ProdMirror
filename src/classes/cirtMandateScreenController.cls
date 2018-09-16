public class cirtMandateScreenController {
     public string portalName{get;set;}  
    public utilityIds utilIds = new utilityIds();
    public String strCourtDate = System.currentPagereference().getParameters().get('courtDate');  
    public Event thisCourtDate {get;set;}
    public Case_Information__c thisCase {get;set;}
    public Contact thisContact {get;set;}
    public Program_Cycle__c newPC {get;set;}
    public Boolean bolRejected {get;set;}
    public String strRejectReason {get;set;}
    public String strDetentionStatus {get;set;}

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public cirtMandateScreenController() { 
         portalName = ApexPages.currentPage().getParameters().get('portalName');   
        bolRejected = false;
        strRejectReason = '';
        strDetentionStatus = '';
        if (strCourtDate != null && strCourtDate != ''){
        thisCourtDate = [select id, whoId, ActivityDate, whatID, Part__c, Judge_If_other_than_Assigned_Judge__c
            from Event where id = :strCourtDate];
        thisCase = [select id, Judge__c
            from Case_Information__c where id = :thisCourtDate.whatId]; 
        thisContact = [select id, Screening_Stage__c, Client_Status__c, FirstName, LastName, P_C_Id__c,
            District_Attorney_s_Consent__c, Judge_s_Conditions__c, CIRT_Final_Outcome__c, CIRT_Final_Outcome_Date__c,
            Final_Outcome_Modified_Date__c, Detention_Status_at_Intake__c,
            Mandate_Decision_Date__c from Contact where id = :thisCourtDate.whoId]; 
            
        newPC = new Program_Cycle__c();
        newPC.Client__c = thisCourtDate.whoId;
        newPC.RecordTypeId = utilIds.progCycleCRT;  
        newPC.Cycle_Type__c = 'Intake';
        newPC.Start_Date__c = thisCourtDate.activityDate;}
    }
    
    ////////////////////////////////
    // Get picklists
    ////////////////////////////////    
    
    public List<SelectOption> getLstRejectReason() {
        
        List<SelectOption> lstTemp = new List<SelectOption>();
        
        lstTemp.add(new SelectOption('', ''));
        lstTemp.add(new SelectOption('Accepted Other ATI-Program-Offer', 'Accepted Other ATI-Program-Offer'));        
        lstTemp.add(new SelectOption('Excluded Charge', 'Excluded Charge'));    
//        lstTemp.add(new SelectOption('Already involved in another program', 'Already involved in another program'));
 //       lstTemp.add(new SelectOption('Attorney not consented', 'Attorney not consented'));  
 //       lstTemp.add(new SelectOption('Ineligible', 'Ineligible'));
        lstTemp.add(new SelectOption('Rejected by Attorney', 'Rejected by Attorney'));          
        lstTemp.add(new SelectOption('Rejected by Inmate-Client', 'Rejected by Inmate-Client'));
        lstTemp.add(new SelectOption('Rejected by Judge', 'Rejected by Judge'));
   //     lstTemp.add(new SelectOption('Sentenced-Plead at CIRT referral', 'Sentenced-Plead at CIRT referral'));  
        lstTemp.add(new SelectOption('730 Ordered', '730 Ordered'));    
        lstTemp.add(new SelectOption('Other', 'Other'));    
        return lstTemp;
        
    }      
       
    public List<SelectOption> getLstDetentionStatus() {
        
        List<SelectOption> lstTemp = new List<SelectOption>();
        lstTemp.add(new SelectOption('', ''));
        lstTemp.add(new SelectOption('ROR', 'ROR'));
        lstTemp.add(new SelectOption('In On Bail', 'In On Bail'));
        lstTemp.add(new SelectOption('Made Bail', 'Made Bail'));                                        
        
        return lstTemp;
        
    }    
    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() { }
    
    public pageReference goPortal() {
         PageReference prRef;
        if (portalName == null)
            prRef = new PageReference('/apex/courtPortal');
        else
            prRef = new PageReference('/apex/allCourtsPage');
      //      PageReference prRef = new PageReference('/apex/courtPortal');
            prRef.setRedirect(true);
            return prRef;       
    }     
    
    public pageReference saveMandate() {
         String strUrl;
         if (portalName == null)
          strUrl  = '/apex/updateCourtDate?courtdate=' + thisCourtDate.id;
         else 
           strUrl = '/apex/updateCourtDate?courtdate=' + thisCourtDate.id+'&portalName=All';
         
        /*String strURL = '/' + thisCourtDate.id + '/e?retURL=' 
            + EncodingUtil.urlEncode('00U/e?what_id=' + thisCourtDate.whatId
            +'&who_id=' + thisCourtDate.whoId + '&RecordType='
            + utilIds.courtDate + '&00N60000001NzR8=' + thisCourtDate.Part__c 
            + '&00N60000001NzRN=' + thisCourtDate.Judge_If_other_than_Assigned_Judge__c
            + '&ent=Event', 'UTF-8');*/    
            
            PageReference prRef = new PageReference(strURL);
        
        try {
            
            /*
            //Bail
            if(strBailType == 'Cash' && thisCase.Bail_Set_Cash__c == null) {
                
                thisCase.Bail_Set_Cash__c = thisCase.Bail_Set_Bond__c;
                thisCase.Bail_Set_Bond__c = null;
            } else if(strBailType == 'Bond' && thisCase.Bail_Set_Bond__c == null) {
                
                thisCase.Bail_Set_Bond__c = thisCase.Bail_Set_Cash__c;
                thisCase.Bail_Set_Cash__c = null;               
            }*/
            
            //was final outcome modified?
            if(thisContact.CIRT_Final_Outcome__c != strRejectReason
            || thisContact.CIRT_Final_Outcome_Date__c != newPC.Start_Date__c) {
                
                thisContact.Final_Outcome_Modified_Date__c = system.today();
            }
            
            //Set Final Outcome + Date
            if(strRejectReason == '' || strrejectReason == null) {
                thisContact.CIRT_Final_Outcome__c = 'Accepted for Intake';
            } else {
            thisContact.CIRT_Final_Outcome__c = strRejectReason;
            }
            
            thisContact.CIRT_Final_Outcome_Date__c = newPC.Start_Date__c;
            
            //Client Mandated Y/N
            thisContact.Mandate_Decision_Date__c = newPC.Start_Date__c;
            if(newPC.Track__c != '' && newPC.Track__c != null) {                
                thisContact.Screening_Stage__c = 'Screening Complete';
                insert newPC;
            } else {
                thisContact.Client_Status__c = 'Never Enrolled';
            }
            
            //Detention Status
            thisContact.Detention_Status_at_Intake__c = strDetentionStatus;
            
            update thisCase;
            update thisContact;
                            
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            prRef = null;
        }
          
        prRef.setRedirect(true);
        return prRef;           
        
    }
    


}