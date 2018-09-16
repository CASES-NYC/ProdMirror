public with sharing class PEAKreportController {
   public string sRepFrom, sRepto;
//   public string Chooserender{get;set;}  
   public reportQuery rq = new reportQuery();   
   public string monthValue{get;set;}
   public string yearValue{get;set;}
   public Event proxyObject {get; set;}
   public string CC{get;set;}
   public string boro{get;set;}
   public string ClientName{get;set;}
   public boolean showPrint{get;set;}
  public string boroValue{get;set;}
   public date reportDate{get;set;}
   public string reportID{get;set;}
   public boolean canPrint{get;set;}
   date dFrom,dTo;
   
   public List<SelectOption> BoroItems{get{
     List<SelectOption> Items = new List<SelectOption>();
     Items.add(new SelectOption('All','All'));
     Items.add(new SelectOption('Brooklyn', 'Brooklyn'));
 //    Items.add(new SelectOption('Queens', 'Queens'));
     Items.add(new SelectOption('Bronx', 'Bronx'));
 //    Items.add(new SelectOption('Manhattan', 'Manhattan'));
     return Items;}
     set{BoroItems = this.BoroItems;}}   
   Date firstDayOfMonth;
   Date lastDayOfMonth;

   Date firstDayOfReport;
   Date lastDayOfReport;



  // date dateTo{get;set;}
   public String narrative{get;set;}   
   public String employment{get;set;}   
   
   public String strRepDate{get;set;}   
   public string selectedClient{get;set;}
   string pcid;
   date dateFrom,dateTo;
   public string sDateFrom{get;set;}
   public string sDateTo{get;set;}
   Map<id, Zip_Code_Mapping__c> mapZip = new Map<id, Zip_Code_Mapping__c>();  

  string BKrecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BK PEAK Client').getRecordTypeId();
  string BXrecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BX PEAK Client').getRecordTypeId();

public PEAKreportController(){
  boroValue = 'All';
  Event e = new Event();
    proxyObject = e;
    lname = '';  
    defaultReportDates();
  } 
  public string repDate{get;set;}
  public List<SelectOption> monthItems{get{
     List<SelectOption> monthItems = rq.lstMonths();      
       return monthItems;}
       set{monthItems = this.monthItems;}} 

  public List<SelectOption> yearItems{get{
     List<SelectOption> yearItems = rq.lstYears();      
       return yearItems;}
       set{yearItems = this.yearItems;}} 

  public void defaultReportDates(){
    yearValue = string.ValueOf(date.today().year());
    Event e = new Event();
    proxyObject = e;

    date dt =  date.today().toStartOfMonth().addDays(-1);
 //   firstDayOfReport = dt.toStartOfMonth();
 //   dt = firstDayOfReport - 1;
    firstDayOfReport = dt.toStartOfMonth().addDays(25);
    lastDayOfReport = 
    firstDayOfReport.addDays(Date.daysInMonth(firstDayOfReport.year(),firstDayOfReport.month()) - 1);

 
    system.debug('\n\n XXX  lastDayOfMonth for to: ' + lastDayOfMonth);
 // proxyObject.catalog_end_date__c = lastDayOfReport;
  dTo = lastDayOfReport;
//  proxyObject.activitydate =  firstDayOfReport;
  dFrom = firstDayOfReport;
  string y;
  string s = string.ValueOf(date.today().month() - 1).trim();
//  string s = string.ValueOf(date.today().month()).trim();
  if (s.length() == 1)
     s = '0' + s; 
 //  repDate = findReportText(s);  
   
 //    
   system.debug('\n\n XXX  repDate: ' + repDate);
  monthValue = s;
  // sDateFrom = proxyObject.activitydate.format();
  // sDateTo = proxyObject.catalog_end_date__c.format();
   
    sDateFrom = dFrom.format();
   sDateTo = dTo.format();
    repDate = sDateFrom + ' - ' + sDateTo;
   selectClients();  
  }
  boolean lFrom;
  date firstDateReport;
  string dowFrom;
  string dowTo;

  public void changeDates(){
  	 string s ;
   s = monthValue + '/' + '01/' + yearValue;
  //  if (monthValue <> '01') 
  //    s = monthValue + '/' + '26/' + yearValue;
  //  else{
   //     s = '12' + '/' + '26/' + yearValue;
   // }
    date dt;
 //   proxyobject.activitydate = date.parse(s);
   dFrom = date.parse(s);
 //  if (monthValue <> '01')
 //     dt =  dFrom.toStartOfMonth().addDays(-1);
 //  else
      dt =  dFrom.toStartOfMonth();
   
   firstDayOfReport = dt.toStartOfMonth();
//   dt = firstDayOfReport - 1;
   dFrom = firstDayOfReport + 25;
 //  dFrom =  dFrom.toStartOfMonth().addDays(-1);



   Integer numberOfDays = Date.daysInMonth(dFrom.year(),dFrom.month());
   lastDayOfmonth = 
   Date.newInstance(dFrom.year(),dFrom.month(), numberOfDays);
   dTo = lastDayOfmonth.addDays(25);
   
   
   // proxyobject.catalog_end_date__c = 
   // proxyobject.activitydate.addDays(Date.daysInMonth(proxyobject.activitydate.year(),proxyobject.activitydate.month()) - 1);
    lname = '';
    sDateFrom = dFrom.format();
    sDateTo = dTo.format();
   string m = string.ValueOf(dFrom.month()).trim();
  if (m.length() == 1)
     m = '0' + m; 
 //  repDate = findReportText(m); 
        repDate = sDateFrom + ' - ' + sDateTo;

    system.debug('\n\n XXX in change repDate: ' + repDate); 
    selectClients();} 
  
  public class clientsInfo{
    public string name{get;set;}
    public string clientId{get;set;}
    public string accountid{get;set;}
    public string pcid{get;set;}
    public string sIntake{get;set;}
    public date dExit{get;set;}
    public string appDate{get;set;}
   public string repPeriod{get;set;}    
   public string repStatus{get;set;}    
   public string clientStatus{get;set;}    
   public boolean exited{get;set;}    
   public string title{get;set;} 
   public string RowNumb{get;set;} 
   public string statuscolor{get;set;}  
   public string statusBackcolor{get;set;}  
  }
//  Map<string,string> mapDob = new Map<string,string>();
  public List<clientsInfo> clientsShow{get;set;}
      public string lname{get;set;}
      public string fname{get;set;}

   public void showClientInfo(){
      narrative = '';   
      employment = '';   
    Contact cont =  clientContact(selectedClient);
    
    List<Address_Information__c> addr = new List<Address_Information__c>();
    addr = [Select id From Address_Information__c 
             where client__c =: selectedClient and address_type__c =: 'Primary' limit 1]; 
   
 
    lname = cont.lastname;
    fname = cont.firstname;
    ClientName  = cont.name;
   CC = cont.Case_coordinator__r.Name;
    List<SF_CRW__c> reps = [select reportPeriod__c, PC_Id__c, program__c,notes__c,contact__c,report_date__c,
    narrative__c, ClientName__c,report_from__c, report_to__c from  SF_CRW__c where 
    contact__c =: selectedclient and   
     report_from__c =: dFrom and report_to__c =: dTo limit 1];
    if (reps.Size() == 0){
      SF_CRW__c crw = new SF_CRW__c();
      crw.Contact__c = selectedclient;
      crw.program__c = 'PEAK';
   //   crw.report_date__c = proxyobject.verification_date__c; 
      crw.ClientName__c = cont.name;
      crw.report_from__c = dFrom;
      crw.report_to__c = dTo;
      crw.Account__c = cont.accountId;
      crw.PC_Id__c = pcid;
      if (dTo > date.today() &&
         dFrom < date.today()){
         crw.report_date__c = date.today();  
         proxyobject.verification_date__c = date.today();
         }
      else{
        crw.report_date__c = dTo + 1; 
        proxyobject.verification_date__c =  crw.report_date__c;
      }
      insert crw;
      reportId = crw.id;
    }
    else{
       proxyObject.Verification_Date__c = reps[0].report_date__c;
       employment = reps[0].Notes__c;
       narrative = reps[0].Narrative__c;
       dTo = reps[0].report_to__c;
//       proxyObject.Verification_Date__c = reps[0].Report_Date__c;
       sDateFrom = reps[0].report_from__c.format();
       sDateTo = reps[0].report_to__c.format();
    }
    if (dFrom > date.today())
       canPrint = false;
    else
       canPrint = true;   
    }
    
    List<clientsInfo> lstSelect = new List<clientsInfo>();
 
  public void selectClients(){ 
    if (clientsShow <> null)
         clientsShow.Clear();           
 
     clientsInfo oneRecord = new clientsInfo();
     string contid;
     List<clientsInfo> ci = new List<clientsInfo>();
     List<Contact> Contacts = new List<Contact>();
     Set<String> setPEAKIds = new Set<String>(); 
   
        if (Contacts <> null)
      Contacts.Clear();
  //  date dateFrom = proxyObject.activitydate;
  //  date dateTo = dTo;
    date dtNull;
    string cWhere = '';
    //dTo;
    string selectContacts = 'select name, intake_date__c, current_exit_date__c,accountid, ' + 
       'Borough_of_Intake_Formula__c from Contact where ' +  
       '(recordtypeid =: BKrecTypeId or recordtypeid =: BXrecTypeId) and ' + 
       'intake_date__c !=: dtnull and intake_date__c <=: dateTo '+ 
       'and (current_exit_date__c =: dtnull or '+   
       '(current_exit_date__c >=: dFrom ' + 
       'and current_exit_date__c <=: dateTo))';
     
      if (boroValue != 'All')
         cWhere = ' and Borough_of_Intake_Formula__c =: boroValue';
      cWhere += ' order by name';
     selectContacts += cWhere;

     Contacts = Database.Query(selectContacts);  
    for (Contact c : Contacts){
      setPEAKIds.add(c.id);
    }
    List<clientsInfo> lstContacts = new List<clientsInfo>();
    if (lstContacts <> null)
         lstContacts.Clear();
    List<clientsInfo> allPeriods = new List<clientsInfo>();
    
    List<SF_CRW__c> reps = [select reportPeriod__c, PC_Id__c, program__c,notes__c,contact__c,
    narrative__c, ClientName__c from  SF_CRW__c where contact__c in: setPEAKIds and
    report_from__c =: dFrom
    and  report_to__c =: dTo];
     
     Set<string> setRepsCreated = new Set<string>();
     for (SF_CRW__c r : reps){
       setRepsCreated.add(r.contact__c);
     }
     
     System.Debug('\n\n XXX setRepsCreated: ' + setRepsCreated);
   string repPeriod = dFrom.format() + '-' + dTo.format();
    string cid;
    integer nRow = 1;
    for (integer i = 0; i < Contacts.Size();i++){
      oneRecord = new clientsInfo();
      oneRecord.exited = false;
      cid = Contacts[i].id; 
      oneRecord.clientId  = cid.left(15);
      oneRecord.accountId  = Contacts[i].accountid;      
      oneRecord.name      = Contacts[i].Name;
      oneRecord.repPeriod = repPeriod;
      if (setRepsCreated.contains(cid)){
         oneRecord.repStatus = 'Open';
         oneRecord.statusBackcolor = '#AFEEEE'; }
      else{
         oneRecord.repStatus = 'To do';
    //     oneRecord.statuscolor = 'black';
         oneRecord.statusBackcolor = 'white';}
      if (Contacts[i].current_exit_date__c == null)
          oneRecord.title = 'Active client';
         else{
            oneRecord.exited = true;  
            if (Contacts[i].current_exit_date__c >= dFrom
             && Contacts[i].current_exit_date__c <= dTo)
             oneRecord.title = 'Exited on this month: ' + Contacts[i].current_exit_date__c.format();
           else
             oneRecord.title = 'Exited on: ' + Contacts[i].current_exit_date__c.format();}    
         oneRecord.rownumb = string.valueOf(nRow);
         lstContacts.add(oneRecord);
         nRow++;
    }
     clientsShow = lstContacts;
   } 
   public void saveInfo(){
      System.Debug('\n\n XXX in save  selectedclient: ' + selectedclient ); 
      if (proxyobject.verification_date__c > date.today()){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Report Date can not be after today'));
        return;
     }
     if (proxyobject.verification_date__c < dFrom){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Report Date can not be before report start date'));
        return;
     }
     SF_CRW__c crw = new SF_CRW__c();
     List<SF_CRW__c> reps = [select id,contact__c, account__c,report_date__c, reportperiod__c from  SF_CRW__c where 
     contact__c =: selectedclient  and  
     report_from__c =: dFrom and report_to__c =: dTo limit 1];
      boolean lUpdate = false;
      if (reps.Size() != 0){
         crw = new SF_CRW__c(id=reps[0].id);
         lUpdate = true;
      }   
      else
         crw = new SF_CRW__c();
      crw.report_date__c = proxyobject.verification_date__c;      
      crw.report_from__c = dFrom;
      crw.report_to__c = dTo;
      crw.Notes__c = employment;
      crw.Narrative__c = narrative;
      crw.PC_Id__c = pcid;
      if (lUpdate)
         update crw;
      else
        insert crw;
     // catch(Exception s ){
     //    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'please try again'));
     // }      
   }
   void calculateReportPeriod(){
        string s = monthValue + '/' + '01/' + yearValue;
     firstDayOfMonth = date.parse(s);
    proxyObject.activitydate = firstDayOfMonth;
    lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(),firstDayOfMonth.month())-1);
    dTo = lastDayOfMonth;
    proxyObject.verification_date__c = date.today();
  //  dateFrom = proxyObject.activitydate;
  //  dateTo = proxyObject.catalog_end_date__c;
    sDateFrom = dFrom.format();
    sDateTo = dTo.format();}
   
    Contact clientContact(string cid){
     Contact c = new Contact();
     c = [select id,firstname, lastname,intake_date__c,name,accountid,p_c_id__c,
      MobilePhone, HomePhone,Case_coordinator__r.Name,Borough_of_Intake_Formula__c,Current_Exit_Date__c
      from Contact where id =: cid];
    pcid = c.P_C_ID__c;  
    return c; 
   }
      public void saveLogin(){
            string cuser = UserInfo.getUserName();
      string sDateToday = date.today().format();
      string sDateIntrack;
      integer i; 
      loginTracking__c logchk = new loginTracking__c();
       loginTracking__c lt = new loginTracking__c();
        try{
        logchk = [select pageName__c, loginName__c, loginDateTime__c,createddate 
           from loginTracking__c where loginName__c =: cuser
             and pageName__c =:  'PEAK reports' order by createddate desc limit 1];
     }
     catch (Exception e) {
          lt = new loginTracking__c();
          lt.loginName__c = cuser;
          lt.loginDateTime__c = datetime.now().format(); 
          lt.pageName__c = 'PEAK reports';
        insert lt;}
     finally {
        if (logchk != null && logchk.loginDateTime__c != null){        
          i = logchk.loginDateTime__c.IndexOf(' ');
          sDateIntrack = logchk.loginDateTime__c.substring(0,i);
        if (sDateIntrack != sDateToday){
           lt = new loginTracking__c();          
           lt = new loginTracking__c();
           lt.loginName__c = cuser;
           lt.loginDateTime__c = datetime.now().format(); 
           lt.pageName__c = 'PEAK reports';
        insert lt;}}
      }  }
      
     public string findReportText(string s){
       string r;
       For(SelectOption m : monthItems){
         if (s == m.getValue()){
         r = m.getLabel();
           break;
          }
      }  
      r = r + ', ' + string.ValueOf(yearValue);
         system.debug('\n\n XXX r: ' + r);
      return r;
     }
 }