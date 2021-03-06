public with sharing class STRT_ProgramRepController 
{  
  private ApexPages.StandardController stdCtrl {get;set;}    
  PageReference pageRef = ApexPages.currentPage();
  
  
  public Event proxyObject {get; set;}
  public integer Result{get;set;}
  public boolean futureDate{get;set;}
  public string ctimeStart = '08:00:00'; 
  
  public String Programs{get;set;}
  public String selectProgs{get;set;}
 
  public boolean saving{get;set;}
  public String cmNames{get;set;} 
  public List<clsContacts> lst2track = new List<clsContacts>();
  public List<clsContacts> Contacts{get;set;}
  public List<String> lstProgs = new List<String>();
  
  public UtilityIDs uid = new  UtilityIDs();
  public ID CaseCoordination = uid.caseCoordination;
  public Id CourseCatalog = uid.courseCatalogClass;
  public string apptype{get;set;}
  public string appStatus{get;set;}
  public boolean grpStatus{get;set;}
  public string grpName{get;set;}
  public ID contid{get;set;}
  public ID grpid{get;set;}
  public string grp2save{get;set;}
  public ID docket{get;set;} 
  public ID groupAppId{get;set;}

	public STRT_ProgramRepController()
  	{
    	Event e = new Event();
		selectProgs = 'ALL';
      proxyObject = e;   
    proxyObject.activitydate = date.today();
    cmNames = 's'; 
    Programs = 'a';
    buildContacts();
  } 

   // helper class
    public class clsContacts{
    public Id contId{get;set;}
    public Contact ContactsForDisplay{get;set;} 
    public string name{get;set;}
    public integer MandatedDays{get;set;}
    public integer DaysRemaining{get;set;}
    public string ComplianceDate{get;set;}
    public string StartDate{get;set;}
    public boolean DisplayStatus{get;set;}
    public string Status {get;set;}
    public Id eventid {get;set;}
    public Id grpEventid {get;set;}
    public boolean groupAtt{get;set;}
    public boolean canVerify{get;set;}
    public List<String> lstSTRT_Events{get;set;}
    public clsContacts(){}}
    
    public void buildContacts()
    { 
        if (proxyObject.activitydate > date.today())
        {
          futureDate = true;
          Contacts = null;
          return;
        }
        Contacts = new List<clsContacts>();
        boolean checkDow; 
        result = 0; 
        lst2track = new List<clsContacts>();
        selectedDate = proxyObject.activitydate;
        List<string> lstGroups = new List<string>();
        for (Group__c g :[SELECT Name, displayname__c FROM Group__c WHERE Active__c = true])
        {
          lstGroups.add(g.displayname__c);
        }
        List<Contact> lstInitialContact = new List<Contact>();   
        List<Event> lstEvents = [SELECT Id,WhoId,Subject,ActivityDateTime,ActivityDate,Verification_Status__c,RecordTypeId,What.Name
                               FROM Event WHERE activitydate =: selectedDate 
                               AND (RecordTypeId =: CaseCoordination OR RecordTypeId =:CourseCatalog) 
                               AND (Subject =: 'Program Reporting' OR Subject IN :lstGroups) 
                               ORDER BY WhoId];
      date appDate;  
     string appStatus;
     date emptyDate;
     ID emptyId;
     String stringQuery;
     Id appId; 
     id rectypeid;
     string subject;
     boolean appFound;
     boolean displayStatus;
     string groupSummary;
     string s_add;         
     integer index;
        if(selectProgs == 'All'){        
     lstInitialContact = [SELECT Id, P_C_Id__c, Name,Current_intake_date__c, Case_Coordinator__r.Name, Case_Coordinator__c,
     Mandated_days_sessions__c, Days_Sessions_Remaining__c, Compliance_date_formula__c, 
     (SELECT id, Start_Date__c, End_Date__c, Compliance_Date__c, Exit_Type__c FROM Program_Cycles__r WHERE Cycle_Type__c != 'Voluntary') 
     FROM Contact c
     WHERE Mandate_Type__c IN ('DTC','CCM','ONE','CEO') AND Intake_Date__c <=: selectedDate
     AND (Compliance_Date_Formula__c >=: selectedDate OR Compliance_Date_Formula__c = null)
     ORDER BY Name asc];
   }else{
     lstInitialContact = [SELECT Id, P_C_Id__c, name,current_intake_date__c,Case_Coordinator__r.Name, Case_Coordinator__c,
     mandated_days_sessions__c, Days_Sessions_Remaining__c, compliance_date_formula__c, 
     (SELECT id, Start_Date__c, End_Date__c, Compliance_Date__c, Exit_Type__c FROM Program_Cycles__r WHERE Cycle_Type__c != 'Voluntary') 
     FROM Contact c
     WHERE Mandate_Type__c = :selectProgs AND Intake_Date__c <=: selectedDate
     AND (Compliance_Date_Formula__c >=: selectedDate OR Compliance_Date_Formula__c = null)
     ORDER BY Name asc];
    } 
     List<Contact> lstContact = new list<Contact>();
     Boolean bolAddContact = false;
     
     for(Contact c: lstInitialContact) {
     
         for(Program_Cycle__c pc: c.Program_Cycles__r) {
     
             if(pc.Start_Date__c <= selectedDate && ( pc.End_Date__c >= selectedDate || pc.End_Date__c == null
             || (pc.compliance_date__c >= selectedDate && pc.Exit_Type__c == 'Unsuccessful Exit'))) {
             
                 lstContact.add(c);
                 break;
             }
         }
     }
     
     for(Contact c : lstContact){
         // checkDow = showCurfewPL(c.Curfew_Frequency__c); 
         result++;
         clsContacts rec2Display = new clsContacts();
         rec2Display.ContactsForDisplay = c;
         rec2Display.displayStatus = false;
          rec2Display.Status = '';
          rec2Display.ComplianceDate = '';
      //    rec2Display.DaysRemaining = 0;
      //    rec2Display.MandatedDays = 0;
          rec2Display.groupAtt = false;
          rec2Display.grpEventid = emptyId;
          index = 1;
          rec2Display.lstSTRT_Events = new List<String>();
          for (Event e : lstEvents ){
               rec2Display.DaysRemaining = 0;
               rec2Display.MandatedDays = 0;
            if (e.whoid == c.id){
                // Program Reporting appointments
                if (e.RecordtypeId == CaseCoordination){
                   rec2Display.displayStatus = true;
                   rec2Display.Status = e.verification_status__c.trim();
                   rec2Display.eventId = e.id;
                   rec2Display.canVerify = false;
                   if (rec2Display.Status == 'Attended')
                      rec2Display.canVerify = true;}
                // STRT appointments
                if (e.RecordtypeId == CourseCatalog){
                   rec2Display.lstSTRT_Events.add(string.valueof(index) + '.' + e.subject); 
                   index++;
                   if (e.subject == Programs && e.activitydate == selectedDate ){
                      rec2Display.grpEventid = e.id; 
                      if (e.verification_status__c.trim() == 'Attended' )
                          rec2Display.groupAtt = true;}}}}
         rec2Display.StartDate = c.current_intake_date__c.format();
         if (c.compliance_date_formula__c <> null) {
            rec2Display.ComplianceDate = c.compliance_date_formula__c.format();
         } else {
            rec2Display.ComplianceDate = null;
         }
         rec2Display.DaysRemaining = integer.valueOf(c.Days_Sessions_Remaining__c);
         rec2Display.MandatedDays = integer.valueOf(c.mandated_days_sessions__c);
         rec2Display.contId = c.id;
         Contacts.add(rec2Display);}
         futureDate = false;}
         
         
  public date selectedDate{get;set;} 
  public List<SelectOption> getStatusItems() {
       String sDate = String.valueOf(selectedDate);
       datetime appdatetime = datetime.valueOf(sDate + ' ' + ctimeStart); 
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('SELECT Status','SELECT Status'));
       if (appdatetime < datetime.now()){
       options.add(new SelectOption('Attended','Attended'));
       options.add(new SelectOption('Excused','Excused'));
       options.add(new SelectOption('Unexcused','Unexcused'));} 
       return options;}
    public List<SelectOption> getCmItems() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('s','--All Case Coordinators--'));
      //   for (User u : [SELECT name, id FROM User WHERE ProfileId =: uid.choicesStandardUser ORDER BY name]){
        //    options.add(new SelectOption(u.id,u.name.trim()));}
         return options;}
   public void doNothing(){}    
   public void createApp(){
    Event newApp = new Event(); 
    newApp.whoid = this.contid;
    newApp.activitydate = selectedDate;
    string s_datetime = String.valueOf(selectedDate) + ' ' + ctimeStart;
    newApp.durationinminutes = 15;  
    newApp.subject = 'Program Reporting';
    newApp.activitydatetime = datetime.valueOf(s_datetime);
    newApp.RecordtypeId = CaseCoordination;
    newApp.verification_status__c = appstatus;
    newApp.Verification_Due_Date__c = selectedDate;   
    insert(newApp);
    buildcontacts();} 
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
   public List<SelectOption> getGroupsItems() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('a',''));
         for (Group__c g : [SELECT DisplayName__c, name FROM Group__c WHERE Active__c = true ORDER BY DisplayName__c]){
            options.add(new SelectOption(g.DisplayName__c,g.DisplayName__c));}
         return options;}     
   public void createGroupAtt()
   {
    if (grpStatus == false){
      Event e = new Event(id=groupAppId);
      if (e <> null)
         delete e;} 
    else{ 
       Event newApp = new Event();
       newApp.whoid = this.contid;
       newApp.activitydate = selectedDate;
       string s_datetime = String.valueOf(selectedDate) + ' ' + '8:00:00';
       newApp.durationinminutes = 15;  
       newApp.subject = programs;
      newApp.activitydatetime = datetime.valueOf(s_datetime);
       newApp.RecordtypeId = CourseCatalog;
       newApp.verification_status__c = 'Attended';
       newApp.Verification_Due_Date__c = selectedDate;   
       insert(newApp);}
       buildcontacts();}   
 }