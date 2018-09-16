public with sharing class complianceLetterSTARTController {

    public utilityIds utilIds = new utilityIds();
    public String strContactId; 
    public String strTRPClass {get;set;}
    public String strLetterType {get;set;}   

    public String strFileName {get;set;}
    public String strTRPClassDate {get;set;}
    public String strContactType {get;set;}
    public String strTrackName {get;set;}
    public Boolean bolSuccessful {get;set;}
    public String strOutcome {get;set;}
    Public String strIntakeDate {get;set;}
    Public String strCurrentExitDate {get;set;}
    Public String strComplianceDate {get;set;}
    Public String strSalutation {get;set;}
    Public String strGenderPronoun {get;set;}
    Public String strPossessiveGenderPronoun {get;set;}
    public Contact c {get;set;}
    public Event evtMostRecentCourtDate {get;set;}
    public List<Case_Information__c> lstAttachedCases {get;set;}
    public List<Event> lstProgramReporting {get;set;}
    public list<Program_Relationships__c> lstProgramRelationships {get;set;}
    
    //TRP
    public Boolean bolTRP {get;set;}
    public list<Contact> lstTRPContacts {get;set;}

    public complianceLetterSTARTController() {
    
        strLetterType = System.currentPagereference().getParameters().get('lettertype');
        strContactId = System.currentPagereference().getParameters().get('contact');   
        strTRPClass = System.currentPagereference().getParameters().get('trpclass');  
        
        if(strTrpClass == null) {
        
            bolTRP = false;
    
            c = [select id, Name, Intake_Case__c, NYSID__c, Salutation, FirstName, LastName, PRP_Status__c,
                        P_C_Id__c, Book_Case__c, Current_Intake_Date__c, Intake_Date__c, Current_Exit_Date__c, 
                        Intake_Case__r.Top_Plea_Charge__c, Intake_Case__r.RecordTypeId, Compliance_Date_Formula__c, 
                        Mandated_Days_Sessions__c, Days_Sessions_Completed__c, RecordTypeId, Gender_CC__c, Intake_Case__r.Name
                        from Contact
                        where Id = :strContactId];

            strIntakeDate = '';
            strComplianceDate = '';
            strCurrentExitDate = '';
            strSalutation = '';
            
            if(c.Intake_Date__c != null) {
                        
                strIntakeDate = c.Intake_Date__c.format();
            }
            
            if(c.Compliance_Date_Formula__c != null) {
            
                strComplianceDate = c.Compliance_Date_Formula__c.format();
            }
            
            if(c.Current_Exit_Date__c != null) {
            
                strCurrentExitDate = c.Current_Exit_Date__c.format();
            }
            
            if(c.Salutation != null) {
            
                strSalutation = c.Salutation;
            } 
            
            if(c.Gender_CC__c == 'Male') {
                
                if(strSalutation == null) {
                    strSalutation = 'Mr.';
                }
                strGenderPronoun = 'He';
                strPossessiveGenderPronoun = 'his';
            } else {
                
                if(strSalutation == null) {
                    strSalutation = 'Ms.';
                }
                strGenderPronoun = 'She';
                strPossessiveGenderPronoun = 'her';                
            }
            
            //Contact type            
            if(c.RecordTypeId == utilIds.conDTC) {
            
                strContactType = 'DTC';
                strTrackName = 'Daytime Custody';
            } else if(c.RecordTypeId == utilIds.conCCM) {
            
                strContactType = 'CCM';
                strTrackName = 'Community Case Management';
            } else if(c.RecordTypeId == utilIds.conTRP) {
            
                strContactType = 'TRP';
                strTrackName = 'Treatment Readiness Program';
            }
            
            //Outcome based on letter type and contact exit type
            if(strLetterType == 'Extension') {
                
                strOutcome = 'Request for condition to be deemed satisfied Request for extension';
                strFileName = c.Name + ' ' + strContactType + ' ' + 'Extension Letter';
            } else if(c.PRP_Status__c == 'Successful Exit') {
            
                strOutcome = 'Successfully Completed Mandate';
                bolSuccessful = true;
                strFileName = c.Name + ' ' + strContactType + ' ' + 'Completion Letter';
            } else if(c.PRP_Status__c == 'Unsuccessful Exit'){
            
                strOutcome = 'Failed to complete';
                bolSuccessful = false;
                strFileName = c.Name + ' ' + strContactType + ' ' + 'Unsuccessful Exit Letter';
            }
            
            strFileName = strFileName.replace(' ', '_');
                        
                        
            list<Event> lstEventTemp = [select id, ActivityDate, Part__c 
                                            from Event
                                            where RecordTypeId = :utilIds.courtDate
                                            and whoId = :strContactId
                                            and Court_Date_Type__c = 'Compliance'
                                            order by ActivityDate desc limit 1];
                                            
            evtMostRecentCourtDate = new Event();
            
            if(lstEventTemp.size() > 0) {
            
                evtMostRecentCourtDate = lstEventTemp[0];
            }
                                            
            lstAttachedCases = [select id, Name from Case_Information__c
                                                          where Master_Intake_Docket__c = :c.Intake_Case__c];
            
            lstProgramReporting = new list<Event>();
            
            if(strContactType == 'CCM') {
    
                lstProgramReporting = [select id, ActivityDate
                                                    from Event
                                                    where Subject = 'Program Reporting'
                                                    and whoId = :strContactId
                                                    and Verification_Status__c = 'Attended'
                                                    and ActivityDate >= :c.Intake_Date__c
                                                    and ActivityDate <= :c.Current_Exit_Date__c];        
            } else if(strContactType == 'DTC') {
                                                          
                lstProgramReporting = [select id, ActivityDate
                                                    from Event
                                                    where Subject = 'Program Reporting'
                                                    and whoId = :strContactId
                                                    and Verification_Status__c = 'Attended'
                                                    and ActivityDate >= :c.Intake_Date__c
                                                    and ActivityDate <= :c.Compliance_Date_Formula__c];
            }
                                                
            lstProgramRelationships = [select id, Program__r.Name, Referral_Date__c
                                                                        from Program_Relationships__c
                                                                        where Warrant__c = :strContactId
                                                                        and Referral_Date__c >= :c.Current_Intake_Date__c];
        } else {
        
            bolTRP = true; 
            lstTRPContacts = [select id, Intake_Case__r.Name, Name, FirstName, LastName, TRP_Next_Class_Date__c
                                from Contact
                                where id in (Select Client__c From Enrollment__c Where Class__c = :strTRPClass)];
            Class__c clsTRP = [select id, First_Session_On__c from Class__c where id = :strTRPClass];
            Date d = clsTRP.First_Session_On__c;
            Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
            strTRPClassDate = dt.format('MM/dd/yyyy');
            strFileName = dt.format('MMM_dd_yyyy') + '_TRP_Letters';
        }                                                                        
    }
    
    public String getPrintView() {
    
        return
        '<!--[if gte mso 9]>' +
            '<xml>' +
            '<w:WordDocument>' +
            '<w:View>Print</w:View>' +
            '<w:Zoom>100</w:Zoom>' +
            '<w:DoNotOptimizeForBrowser/>' +
            '</w:WordDocument>' +
            '</xml>' +
            '<![endif]>';
    }    
    
    public String getToday() {
    
        return system.today().format();
    }

}