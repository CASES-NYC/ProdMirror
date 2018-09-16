public with sharing class PEAKreportPrintController {
   public String printClient = System.currentPagereference().getParameters().get('passClient');  
   Public String sDateFrom = System.currentPagereference().getParameters().get('passFrom');  
   Public String sDateTo = System.currentPagereference().getParameters().get('passTo');  
  public string schoolName{get;set;}
  public string poName{get;set;}
  public string schoolAddress{get;set;} 
   public string reportPeriod{get;set;}
  public string sRepFrom, sRepto;
 //  public reportQuery rq = new reportQuery();   
 //  public string monthValue{get;set;}
 //  public string yearValue{get;set;}
 //  public Event proxyObject {get; set;}
   public string CC{get;set;}
   public string boro{get;set;}
   public string ClientName{get;set;}
//   Map<id, Contact> mapContactAll = new Map<id, Contact>();
 //  Date firstDayOfMonth;
 //  Date lastDayOfMonth;
//   date dateTo{get;set;}
   public String narrative{get;set;}   
   public String employment{get;set;}   
 
   date dateFrom,dateTo;
 Map<id, Zip_Code_Mapping__c> mapZip = new Map<id, Zip_Code_Mapping__c>();  

// List<Address_Information__c> listAddress = new List<Address_Information__c>(); 
  string BKrecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BK PEAK Client').getRecordTypeId();
  string BXrecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BX PEAK Client').getRecordTypeId();

public PEAKreportPrintController(){
 //     printClient = ApexPages.currentPage().getParameters().get('passClient');
//      string sDate = ApexPages.currentPage().getParameters().get('passFrom');
       dateFrom = date.parse(sDateFrom);
 //     sDate = ApexPages.currentPage().getParameters().get('passTo');
   //    sRepTo = sDate; 
      dateTo = date.parse(sDateTo);
       System.Debug('\n\n XXX in constr printClient: ' + printClient);
  //    reportPeriod = dateFrom.format() + '-' + dateTo.format();
  printReport();
  } 
   public string dIntake{get;set;}
   public string dob{get;set;}
   public string accountid{get;set;}      
      public string lname{get;set;}
      public string fname{get;set;}
      public string address{get;set;}
      public string address1{get;set;}
      public string hphone{get;set;}
      public string cell{get;set;}
      public string last_livewith{get;set;}
      public string first_livewith{get;set;}
      public string cell_livewith{get;set;}
      public string daysInPeak{get;set;}
      public string repDateString{get;set;}
     public date repDate{get;set;}
     public string city{get;set;}
    public string homephone{get;set;}
    public string state{get;set;}
     public string zip{get;set;}
    public string schoolCompleted{get;set;}
    public string schoolNotCompleted{get;set;}
   public string programCompleted{get;set;}
    public string programNotCompleted{get;set;}
    public string reportId{get;set;}
   integer PEAKdays;

   public void printReport(){
   if (printClient == null)
       return;
    string school_Id;
    Contact  cont =  clientContact(printClient);
    // if (cont.Parole_Officer__c != null)
    //   poName = cont.Parole_Officer__c;
    //else   
    //   poName = 'not entered';
          poName = 'not entered';
    List<Case_Information__c> ci = [select id, Parole_Probation_Officer_Name__c from
    Case_Information__c where id =: cont.Intake_Case__c limit 1];
    if (ci.Size() != 0){
    if (ci[0].Parole_Probation_Officer_Name__c != null)
       poName = ci[0].Parole_Probation_Officer_Name__c;
    }
    
    Account acc = [select id,DOB__c from Account where id =: cont.AccountId];
   
   List<SF_CRW__c> reps = [select reportPeriod__c, PC_Id__c, program__c,notes__c,contact__c,report_date__c,
    narrative__c, ClientName__c,report_from__c, report_to__c from  SF_CRW__c where 
    contact__c =: printClient and   
     report_from__c =: dateFrom and report_to__c =: dateTo limit 1];
    if (acc.DOB__c != null) 
        dob = acc.DOB__c.format();
    else
        dob = 'not entered';
    lname = cont.lastname;
    fname = cont.firstname;
    if (cont.intake_date__c != null)
       dintake = cont.intake_date__c.format(); 
    ClientName  = cont.name;
    CC = cont.Case_coordinator__r.Name;
    if (reps.size() != 0){
      narrative = reps[0].Narrative__c;   
      employment = reps[0].Notes__c;
    if (reps[0].report_date__c != null){
      repDateString = reps[0].report_date__c.format();}
      repDate  = reps[0].report_date__c;
    }
    else {
    	repDateString = dateTo.format();
        repDate = dateTo;
    }
    
    date dateEvents;
    if (repDate < dateTo)
       dateEvents = repDate;
    else 
      dateEvents = dateTo;   
 
     reportPeriod = dateFrom.format() + '-' + dateEvents.format(); 
    boro = cont.Borough_of_Intake_Formula__c + ' PEAK Progress Report Update - '; 
//     daysInPeak = string.ValueOf((cont.intake_date__c).daysBetween(dateTo));
 if (cont.Current_Exit_Date__c == null)
       daysInPeak = string.ValueOf((cont.intake_date__c).daysBetween(repDate));
    else{
    	if (cont.Current_Exit_Date__c > reps[0].report_date__c)
    	  daysInPeak = string.ValueOf((cont.intake_date__c).daysBetween(repDate));
    	else   
    	  daysInPeak = string.ValueOf((cont.intake_date__c).daysBetween(repDate));
    }  
    
  //  return; 
 //   repDateString = date.today().format(); 
    homephone =  cont.homephone;
    List<Address_Information__c> addr = new List<Address_Information__c>();
    addr = [Select Home_Phone__c, Contact_Person__c, City__c, Building_No__c,City_Formula__c,
       State_Formula__c,zip_code__c,Apt_No__c, Address__c, state__c, zip__c,street__c, Move_In_Date__c,
           Relation_to_client__c, Relation_to_Client_Other__c,Address_Type__c,Client__c,
           Cell_Phone__c From Address_Information__c 
             where client__c =: printClient and address_type__c =: 'Primary' limit 1]; 
      if (addr.Size() != 0 && addr != null){ 
       address = addr[0].Building_No__c;
     
       if (addr[0].street__c != null)
          address = address + ' ' + addr[0].street__c;
    
       if  (addr[0].Apt_No__c != null)
             address = address + ' Apt. ' +  addr[0].Apt_No__c;
        
       if(addr[0].City_Formula__c == null || addr[0].City_Formula__c == ''){
           address1 = addr[0].City__c;
           city = addr[0].City__c;}
         else{
           address1 = addr[0].City_Formula__c;
           city =  addr[0].City_Formula__c;}  
      } 
  //return;
     schoolCompleted = '';
     schoolNotCompleted = '';
    programCompleted = '';
     programNotCompleted = ''; 
     integer i = 0;   
     for (Event e : [select subject, verification_status__c, activitydate,whatid from event 
      where whoid =: printClient and activitydate >=: dateFrom and
      activitydate <=: dateEvents 
       and (verification_status__c =: 'Attended' or verification_status__c =: 'Late' or verification_status__c =: 'Unexcused')
       order by activitydate]){
       if (e.subject.contains('Art') || e.subject.contains('Math') || e.subject.contains('Participation')){
            if(e.WhatId != null  && i == 0 && e.subject.contains('Participation')){
               school_Id = e.WhatId;
               i++;
           } 
            if (e.verification_status__c == 'Attended' || e.verification_status__c == 'Late'){
               if (schoolCompleted == '')  
                  schoolCompleted = e.activitydate.format();
            else
               schoolCompleted = schoolCompleted + ', ' + e.activitydate.format();
            }
            else{
            if (schoolNotCompleted == '')
                schoolNotCompleted = e.activitydate.format();
            else
            schoolNotCompleted = schoolNotCompleted + ', ' + e.activitydate.format();
          }}
          if (e.subject == 'Program Reporting'){
            if (e.verification_status__c == 'Attended' || e.verification_status__c == 'Late'){
               if (programCompleted == '')  
                  programCompleted = e.activitydate.format();
            else
               programCompleted = programCompleted + ', ' + e.activitydate.format();
            }
            else{
            if (programNotCompleted == '')
                programNotCompleted = e.activitydate.format();
            else    
               programNotCompleted = programNotCompleted + ', ' + e.activitydate.format();
        }}} 
//      string repPeriod = dateFrom.format() + '-' + dateTo.format();
 //  return;
     if (school_Id != null && school_Id != ''){
    System.Debug('\n\n XXX in schoolId : ' +school_Id);
     List<Account> sc = [select billingstreet,billingstate,BillingPostalCode,name from account where id =: school_Id limit 1]; 
     if (sc.size() != 0){
       schoolName = sc[0].Name;
      schoolAddress = sc[0].billingstreet + ' ' + sc[0].billingstate + ', ' + sc[0].BillingPostalCode;
     	  System.Debug('\n\n XXX in schoolName : ' + schoolName ); 
      }
      else{
      	  schoolName = 'not entered';
      schoolAddress = 'not entered';
      }
        }
      
      }
//   List<Contact> Contacts = new List<Contact>();


    Contact clientContact(string cid){
     Contact c = new Contact();
     c = [select id,firstname, lastname,intake_date__c,name,accountid,Parole_Officer__c ,
      MobilePhone, HomePhone,Case_coordinator__r.Name,Borough_of_Intake_Formula__c,
      Current_Exit_Date__c,intake_case__c from Contact where id =: cid];
    return c; 
   }
 }