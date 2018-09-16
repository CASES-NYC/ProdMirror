public with sharing class ChoicesComplTrackingController {
  private ApexPages.StandardController stdCtrl {get;set;}    
  PageReference pageRef = ApexPages.currentPage();
  public Event proxyObject {get; set;}
   public integer Result{get;set;}
  public boolean futureDate{get;set;}
  public string ctimeCurFew = '12:00:00';
  public string ctimeAfterSchool = '14:00:00';
  
  public boolean saving{get;set;}
  public String cmNames{get;set;} 
  public String userBorough {get;set;}
  public List<clsContacts> lst2track = new List<clsContacts>();
  public List<clsContacts> Contacts;
  
  public UtilityIDs uid = new  UtilityIDs();
  public Id curFewId_Internal = Utility_ID__c.getValues('Case Coordination').RecordType_Id__c;
  public Id afterShcoolExternalId = Utility_ID__c.getValues('Case Coordination External').RecordType_Id__c;
//  curFewId_Internal = '012600000005JU3AAM'
//  afterShcoolExternalId = '012600000005MEsAAM'

   public string apptype{get;set;}
   public string appStatus{get;set;}
   public ID contid{get;set;}
   public ID docket{get;set;} 

   public ChoicesComplTrackingController(){
    Event e = new Event();
    proxyObject = e;   
    proxyObject.activitydate = date.today();
    cmNames = 's'; 
    User u = [select id, Borough__c from User where id = :userInfo.getUserId()];
    if(u.Borough__c == 'Bronx' || u.Borough__c == 'Manhattan') {
    
        userBorough = u.Borough__c;
    } else {
        
        userBorough = 'All Clients';
    }
  } 
  
    public list<SelectOption> getlstBoroughs() {
    
        List<SelectOption> lst = new List<SelectOption>();
        lst.add(new SelectOption('All Clients','All Clients'));
        lst.add(new SelectOption('Bronx','Bronx'));
        lst.add(new SelectOption('Manhattan','Manhattan'));
        
        return lst;
    }  

   // helper class
   public class clsContacts{
    public Id contId{get;set;}
    public Contact ContactsForDisplay{get;set;} 
    public string name{get;set;}
    public string current_tier{get;set;}
    public date Detained_Date{get;set;}
    public string intakeDate{get;set;}
    public string curfew{get;set;}
    public string afterSchool{get;set;}
    public string afterSchoolExternal{get;set;}
    public boolean displayCurFewApp{get;set;}
    public boolean displayAafterSchoolApp{get;set;}
    public boolean displayExternalApp{get;set;}
    public boolean inDetention{get;set;}
    public string timefreq{get;set;}
    public string curFewStatus{get;set;}
    public string afterSchoolStatus{get;set;}
    public string afterSchoolExternalStatus{get;set;}
    public Id  curFewAppId{get;set;} 
    public Id  AfterSchoolAppId{get;set;}
    public string docket{get;set;}
    public string link2external{get;set;}
    public string SchoolName{get;set;}
    public string borough{get;set;}
    public clsContacts(){
    
        
    }
    }
    public List<ClsContacts> getContacts(){
    if (proxyObject.activitydate > date.today()){
      futureDate = true;return null;}
      boolean checkDow; 
      result = 0;
      lst2track = new List<clsContacts>();
      selectedDate = proxyObject.activitydate;
      List<Event> lstEvents = [select id,whoid,subject,activitydatetime,activitydate,verification_status__c,recordtypeid,what.Name
       from Event where activitydate =: selectedDate and (recordtypeid =: curFewId_Internal or recordtypeid =: afterShcoolExternalId)
      and (subject =: 'Program Reporting' or subject =: 'Curfew') order by whoid];
      date appDate;  
     string appStatus;
     date emptyDate;
     String stringQuery;
     Id appId;
     id rectypeid;
     string subject;
     boolean appFound;
     boolean inDetention;
     boolean displayCurFewApp;
     boolean displayAafterSchoolApp;
     boolean displayExternalApp;
     string timefreq1;
     string timefreq2;
     // Determine whether to query Bronx and/or Manhattan
     list<Id> lstContactRecordTypes = new list<Id>();
     if(userBorough == 'All Clients') {
         
         lstContactRecordTypes.add(uid.conBXChoices);
         lstContactRecordTypes.add(uid.conMNChoices);
     } else if(userBorough == 'Bronx') {
         lstContactRecordTypes.add(uid.conBXChoices);
     } else if(userBorough == 'Manhattan') {
         lstContactRecordTypes.add(uid.conMNChoices);
     }
     
     if (cmNames == 's')
        stringQuery = 'select Id, name,p_c_id__c,current_tier_formula__c,current_intake_date__c,aka_3__c,Case_Coordinator__r.Name, '+
        'Case_Coordinator__c,Curfew_Frequency__c,Curfew_Time__c, Curfew_Details__c, Curfew_Frequency_Full__c, RecordType.Name from contact c WHERE recordtypeId in :lstContactRecordTypes and '+
        'current_intake_date__c <=: selectedDate and (Current_Exit_date__c >=: selectedDate or Current_Exit_date__c =: emptyDate ) order by id';
     //////////////////   filter by case coordinator
     else stringQuery = 'select Id, name,p_c_id__c,current_tier_formula__c,current_intake_date__c,aka_3__c,Case_Coordinator__r.Name, ' +
        'Case_Coordinator__c,Curfew_Frequency__c,Curfew_Time__c, Curfew_details__c, Curfew_Frequency_Full__c, RecordType.Name from contact c WHERE recordtypeId in :lstContactRecordTypes and '+
        'Case_Coordinator__c =: cmNames and current_intake_date__c <=: selectedDate and (Current_Exit_date__c >=: selectedDate or Current_Exit_date__c =: emptyDate) order by id';
     List<Contact> lstContact = new List<Contact>();
     lstContact = database.query(stringQuery);
     List<Detained_Dates__c> lstDetention = [Select Contact_Detained_Dates_Lookup__c From Detained_Dates__c d 
         WHERE Detained_date__c <=: selectedDate and (date_Released__c >=: selectedDate or date_Released__c =: emptyDate)];
     for(Contact c : lstContact){
         // checkDow = showCurfewPL(c.Curfew_Frequency__c); 
         result++;
         clsContacts rec2Display = new clsContacts();
         rec2Display.ContactsForDisplay = c;
         if(rec2Display.ContactsForDisplay.RecordType.Name.contains('Manhattan')) {
         
             rec2Display.Borough = 'Manhattan';
         } else {
             rec2Display.Borough = 'Bronx';
         }
         appDate = null;
         AppFound = false;
         inDetention = false;
         rec2Display.inDetention = false;
         rec2Display.current_tier = c.current_tier_formula__c;
         // 1. first check if client in Detention
         if (c.Curfew_Frequency__c <> null)
             rec2Display.timefreq = c.Curfew_Time__c + ' ' + c.Curfew_Frequency__c + ',' + ' ' + c.Curfew_Details__c;
         else rec2Display.timefreq = c.Curfew_Frequency_Full__c;
           for (Detained_Dates__c d : lstDetention){   
            if (d.Contact_Detained_Dates_Lookup__c == c.id){
             rec2Display.inDetention = true;break;}}
         // 2. if not in Detention
         if (rec2Display.inDetention == false){
           // default values for every type of appointments
            rec2Display.inDetention = false;
            displayCurFewApp = false;
            displayAafterSchoolApp = false;
            displayExternalApp = false;
            for (Event e : lstEvents ){
                 if (e.whoid == c.id){
                  //3a. Check if Curfew appt exists for date selected
                  if (e.recordtypeid == this.curFewId_Internal && e.subject == 'Curfew'){
                     displayCurFewApp = true;
                      rec2Display.curFewStatus = e.verification_status__c.trim();
                      rec2Display.curFewAppId = e.id;}
                  // 3.b    if no Curfew appt default values will be set   
                  //4.a  Check if After School Internal appt exists for date selected
                  if (e.recordtypeid == curFewId_Internal && e.subject == 'Program Reporting'){
                     displayAafterSchoolApp = true;
                     rec2Display.afterSchoolStatus = e.verification_status__c.trim();
                     rec2Display.AfterSchoolAppId = e.id;}
                  // 4.b if no After School Internal appt default values will be set   
                  //5.a  Check if After School External appt exists for date selected
                  if (e.recordtypeid == afterShcoolExternalId && e.subject == 'Program Reporting'){
                     displayExternalApp = true;
                     rec2Display.SchoolName = e.what.Name;
                     rec2Display.afterSchoolExternalStatus = e.verification_status__c.trim();
                     rec2Display.AfterSchoolAppId = e.id;}}}
                  // 5.b if no After School External appt default values will be set
             }
         rec2Display.displayExternalApp = displayExternalApp;  
         rec2Display.displayCurFewApp = displayCurFewApp;
         rec2Display.displayAafterSchoolApp = displayAafterSchoolApp;
         rec2Display.intakeDate = c.current_intake_date__c.format();
          rec2Display.contId = c.id;
         lst2track.add(rec2Display);}
         futureDate = false;
     return lst2track;}
  public date selectedDate{get;set;}
  public List<SelectOption> getStatusItems() {
       String sDate = String.valueOf(selectedDate);
       datetime appdatetime = datetime.valueOf(sDate + ' ' + ctimeCurFew); 
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('Select Status','Select Status'));
       if (appdatetime < datetime.now()){
       options.add(new SelectOption('Attended','Attended'));
       options.add(new SelectOption('Excused','Excused'));
       options.add(new SelectOption('Unexcused','Unexcused'));}
       return options;}
    public List<SelectOption> getCmItems() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('s','--All Case Coordinators--'));
         for (User u : [select name, id from User where ProfileId =: uid.choicesStandardUser order by name]){
            options.add(new SelectOption(u.id,u.name.trim()));}
         return options;}
   public void doNothing(){}    
   public void createApp(){
    Event newApp = new Event();
    newApp.whoid = this.contid;
    newApp.activitydate = selectedDate;
    string s_datetime = String.valueOf(selectedDate) + ' ' + ctimeCurFew;
    if (apptype == 'Curfew'){newApp.subject = 'Curfew';
        newApp.durationinminutes = 15;}  
    else {newApp.subject = 'Program Reporting';
          newApp.durationinminutes = 300;} 
    newApp.activitydatetime = datetime.valueOf(s_datetime);
    newApp.RecordtypeId = curFewId_Internal;
    newApp.verification_status__c = appstatus;
    newApp.Verification_Due_Date__c = selectedDate;  
    insert(newApp);} 
    public string getDayOfWeek() {
       date dtSelected = proxyObject.activitydate;
       DateTime dt = DateTime.newInstance(dtSelected, Time.newInstance(0, 0, 0, 0));
       String dayOfWeek = dt.format('EEEE');
       return dayOfWeek;}
    public string getDateDow(){
        DateTime dt = DateTime.newInstance(proxyObject.activitydate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = dt.format('EEEE');
        string s_dt = proxyObject.activitydate.format();
        return dayOfWeek + ' - ' + s_dt;}
 }