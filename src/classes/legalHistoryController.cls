public with sharing class legalHistoryController {
    
    public utilityIds utilIds = new utilityIds();
    public String strCase = System.currentPagereference().getParameters().get('case');  
    public String strContact = System.currentPagereference().getParameters().get('contact');  
    public Case_Information__c thisCase {get;set;}
    public Case_Charges__c arrestCharge {get;set;}
    public Case_Charges__c arraignmentCharge {get;set;} 
    public Boolean bolArrChargeMissing {get;set;}
    public String strArrCharge {get;set;}
    public list<hClass> lstCases {get;set;}
    public Contact thisContact {get;set;}
    public Boolean bolSaveSuccessful {get;set;}

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public legalHistoryController() { 
    
        if (strCase != null){
        
        thisCase = [select id, Name, RecordTypeId,
            Indictment__c, Arrest_Date__c, Arrest_Number__c, Top_Criminal_Court_Arraignment_Charge__c
            from Case_Information__c where id = :strCase];
        
        arrestCharge = new Case_Charges__c(Docket_No__c = thisCase.Id, Type__c = 'Arrest Charges');                                                 
        
        if(thisCase.Top_Criminal_Court_Arraignment_Charge__c == null) {
                                                  
            arraignmentCharge = new Case_Charges__c(Docket_No__c = thisCase.Id, 
                Type__c = 'Criminal Court Arraignment Charges'); 
            bolArrChargeMissing = true;
        } else {
            
            strArrCharge = thisCase.Top_Criminal_Court_Arraignment_Charge__c;
            bolArrChargeMissing = false;
        }
                    
        thisContact = [select id, FirstName, Lastname, P_C_ID__c, AccountId,
            AKA_1__c, AKA_2__c, AKA_3__c, True_First_Name__c, True_Last_Name__c, True_Middle_Name__c,
            Criminal_Justice_Involvement__c, Prior_Violent_Conviction__c, 
            Prior_Violent_Conviction_Date__c, Prior_Violent_Conviction_Charge__c, Inmate_Location__c,
            Prior_Felony_Convictions__c, Prior_Misdemeanor_Convictions__c
            from Contact where id = :strContact];}   
        
        lstCases = new list<hClass>{new hClass(new Case_Information__c(), new Case_Charges__c(), new Event()), 
            new hClass(new Case_Information__c(), new Case_Charges__c(), new Event()), 
            new hClass(new Case_Information__c(), new Case_Charges__c(), new Event())};                         
    }
    
    //helper class
    
    public class hClass {
        
        public Case_Information__c hCase {get;set;}
        public Case_Charges__c hCharge {get;set;}
        public Event hCourtDate {get;set;}
        
        public hClass(Case_Information__c inputCase, Case_Charges__c inputCharge, Event inputCourtDate){                
            
            hCase = inputCase;
            hCharge = inputCharge;
            hCourtDate = inputCourtDate;
            hCourtDate.RecordTypeID = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
        }
    }
    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() { }     
    
    public pageReference saveLegalInfo() {  
            
        PageReference prRef = new PageReference('/apex/courtPortal'); 
                       
        try {
            
            update thisContact;
            
            //get level of arraignment charge (if set) before case is updated
            //so recordtype can be changed if necessary
            
            if(arraignmentCharge!= null && arraignmentCharge.Charge__c != null) {
                
                Penal_Code__c pcTemp = [select id, Level__c from Penal_Code__c
                                            where id = :arraignmentCharge.Charge__c];   
                
                if(pcTemp.Level__c == 'F') {
                    
                    thisCase.RecordTypeId = utilIds.caseInfoSupremeCourt;
                } else {
                    
                    thisCase.RecordTypeId = utilIds.caseInfoCriminalCourt;
                }
            }
            
            update thisCase;
            
            list<Case_Information__c> lstCasestoInsert = new list<Case_Information__c>();
            list<Case_Charges__c> lstChargestoInsert = new list<Case_Charges__c>();
            list<Event> lstEventstoInsert = new list<Event>();
            
            if(arrestCharge.Charge__c != null) {
                
                lstChargestoInsert.add(arrestCharge);
            }
            
            if(bolArrChargeMissing && arraignmentCharge.Charge__c != null) {
                
                lstChargestoInsert.add(arraignmentCharge);
            }            
            
            //add cases
            for(hClass hc: lstCases) {
            
                //add other cases
                if(hc.hCase.Name != null) {
                    
                    hc.hCase.RecordTypeId = utilIds.caseInfoCriminalCourt;
                    hc.hCase.Client_Account__c = thisContact.AccountId;                
                    lstCasestoInsert.add(hc.hCase);
                }           
            }
            
            //cases DML
            if(lstCasestoInsert.size() > 0) {
                
                insert lstCasestoInsert;
            } 
            
                    
            //add charges
            for(hClass hc: lstCases) {  
                            
                if(hc.hCharge.Charge__c != null) {
                    
                    hc.hCharge.Docket_No__c = hc.hCase.Id;
                    hc.hCharge.Type__c = 'Arrest Charges';
                    lstChargestoInsert.add(hc.hCharge);
                }
                
                if(hc.hCourtDate.ActivityDate != null) {
                    
                    hc.hCourtDate.whoId = thisContact.Id;
                    hc.hCourtDate.whatId = hc.hCase.Id;
                    hc.hCourtDate.ActivityDateTime = dateTime.newInstance(hc.hCourtDate.ActivityDate, time.newInstance(9,0,0,0));
                    hc.hCourtDate.EndDateTime = hc.hCourtDate.ActivityDateTime.addHours(1);
                    lstEventstoInsert.add(hc.hCourtDate);
                }
                
            }
            
            //charges DML   
            if(lstChargestoInsert.size() > 0) {
                
                insert lstChargestoInsert;
            }
            
            if(lstEventstoInsert.size() > 0) {
                
                insert lstEventstoInsert;
            }     
            
            //done!
            prRef.setRedirect(true);      
                        
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
            'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' 
            + string.valueOf(e)));
            prRef = null;
        }
        
 

        return prRef;           
        
    }
    


}