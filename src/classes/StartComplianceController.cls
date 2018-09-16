public with sharing class StartComplianceController {
 public String getChooserender() { 
   if (ApexPages.currentPage().getParameters().get('p') != null){
      return 'pdf';}
   else
   return null;} 
    public utilityIds utilIds = new utilityIds();
    public String strContactId; 
    public String strTRPClass {get;set;}
    public String strLetterType {get;set;}   
    string conCCI = 
       Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CCI START Client').getRecordTypeId();
    string conCEO = 
       Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CEO Client').getRecordTypeId();
 
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
    public Boolean boolONE {get;set;}
    public list<Contact> lstTRPContacts {get;set;}

    public StartComplianceController() {
    
        strLetterType = System.currentPagereference().getParameters().get('lettertype');
        strContactId = System.currentPagereference().getParameters().get('contact');   
        strTRPClass = System.currentPagereference().getParameters().get('trpclass');
        
               c = [select id, Name, Intake_Case__c, NYSID__c, Salutation, FirstName, LastName, PRP_Status__c,accountid,
               Current_Exit_Type__c,
                        P_C_Id__c, Book_Case__c, Current_Intake_Date__c, Intake_Date__c, Current_Exit_Date__c, 
                        Intake_Case__r.Top_Plea_Charge__c, Intake_Case__r.RecordTypeId, Compliance_Date_Formula__c, 
                        Mandated_Days_Sessions__c, Days_Sessions_Completed__c, RecordTypeId, Gender_CC__c, Intake_Case__r.Name
                        from Contact
                        where Id = :strContactId];
     System.Debug('\n\n XXX strContactType: ' + strContactType);
     //   strContactId = '003f200002KdyGX';
        if (c.P_C_Id__c.left(3) == 'ONE'){
           strContactType = 'ONE';
                     selectData(c);
            boolONE = true;         
            return ;
         }else{   
        if(strTrpClass == null) {
        
            bolTRP = false;
    /*
            c = [select id, Name, Intake_Case__c, NYSID__c, Salutation, FirstName, LastName, PRP_Status__c,
                        P_C_Id__c, Book_Case__c, Current_Intake_Date__c, Intake_Date__c, Current_Exit_Date__c, 
                        Intake_Case__r.Top_Plea_Charge__c, Intake_Case__r.RecordTypeId, Compliance_Date_Formula__c, 
                        Mandated_Days_Sessions__c, Days_Sessions_Completed__c, RecordTypeId, Gender_CC__c, Intake_Case__r.Name
                        from Contact
                        where Id = :strContactId];
*/
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
            } else if(c.RecordTypeId == conCCI) {
            
                strContactType = 'CCI';
                strTrackName = 'Center for Court Innovation';
           } else if(c.RecordTypeId == conCEO) {
            
                strContactType = 'CEO';
                strTrackName = 'Center for Employment Opportunities';                
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
            
            if(strContactType == 'CCM' || strContactType == 'CCI' || strContactType == 'CEO') {
    
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
    }}
    
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
    
     public string cName{get;set;}
  //public string dsent{get;set;}
  public string Expession1{get;set;}
  public string Expession2{get;set;}
  public string docket{get;set;}
  public string letterDate{get;set;}
  public string outcome{get;set;}
    void selectData(Contact c){
      letterDate = date.today().format();
    //Contact c = [Select name,accountid,current_intake_date__c,current_exit_type__c from Contact where id =: strContactId];
    cName = c.name;
    string accId = c.AccountId;
    string exittype = c.Current_Exit_Type__c;
    string dsent = c.Current_Intake_Date__c.format();
    Account a = [Select gender__c from Account where id =: accId];
    string gender = a.Gender__c;
    
    List<Case_Relationship__c> lstDocket = [select Id, Docket__c,Client_Name__c,contact__c,pcid__c,docket_Name__c,
     docket_indictment__c,Case_Court_Status_Calc__c,case_type__c,ArrestDate__c From Case_Relationship__c 
     where contact__c =: strContactId and Case_Type__c =: 'Intake Case' order by ArrestDate__c desc limit 1];
     if (lstDocket.size() != 0)
        docket = lstDocket[0].docket_Name__c;
     else   
       docket = 'not entered';
     string g1,g2,g3;
     if (gender == 'Male'){
       g1 = 'Mr.';
       g2 = 'his';
       g3 = 'He';
     }
     else{
     g1 = 'Ms.';
       g2 = 'her';
       g3 = 'She';
     }
     if (exitType == 'Successful Exit'){
       Expession1 = 'Please be advised that the above referenced individual ' + '\'' + 's'  + ' participation in the CASES ' + 
       'Manhattan START ONE track fully satisfies the conditional discharge sentence received on ' + dsent + '.'; 
       Expession2 = g1 + cName + ' received a compehensive clinical assessment of ' + g2 + ' treatment needs. '  +
       g3 + ' has completed mandated case management sessions required by the terms of ' + g2 + ' release into the community and is ' +          
       'in full in compliance.';
       outcome = 'Successfully Completed Mandate';
     }
     else{
       Expession1 = 'Please be advised that the above referenced individual ' + '\'' + 's'  + ' participation in the CASES ' + 
       'Manhattan START ONE track does not fully satisfy the conditional discharge sentence received on ' + dsent + '.'; 
        Expession2 = g1 + cName + ' received a compehensive clinical assessment of ' + g2 + ' treatment needs '  +
       'and developed a treatment plan with our program. Despite outreach efforts, ' + 
       g1 + cname + ' did not complete mandated case management sessions which were required under ' + 
       'the conditions of ' + g2 + ' plea agreement.';
       outcome = 'Failed to complete';
     }
  }
}