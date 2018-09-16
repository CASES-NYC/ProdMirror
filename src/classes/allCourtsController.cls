public class allCourtsController{
   public string popupValue{get;set;} 
   public reportQuery rq = new reportQuery();   
   boolean requeryAction;
   public String strCourtURL {get;set;} 
   public string selectedClient{get;set;}
   public string staffName{get;set;}   
   ID courtDateRecType = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
   Id orientRecType = Utility_ID__c.getValues('Orientation Appointment').RecordType_Id__c;   
   String cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
   String crtClient = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c;
   String srpClient = Utility_ID__c.getValues('SRP Client').RecordType_Id__c;
 
  List<AssessmentContainer__c> assmCr = new list<AssessmentContainer__c>();
  
   Id SRP_intakeAssessm = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Intake/Needs Assessment').getRecordTypeId();    
  // Id courtRepAss = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Court Rep Assessment').getRecordTypeId();    
  // Id courtRepAssLocked = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Court Rep Assessment - Read Only').getRecordTypeId();    
   date datefrom, dateTo;
   Set<ID> setCCid = new Set<ID>();
   Set<ID> setCRid = new Set<ID>();
   date defaultFrom = rq.countDueDateBefore(date.today(),2);
   date defaultTo = rq.countDueDate(date.today(),3);
   map<ID,Contact> mapIDcontact;
   map<string,id> mapAssessmId = new map<string,id>();      
   Set<string> setAssessm = new Set<string>();
  //Set<string>  setAssessmLocked = new Set<string>();
  Set<string>  setAssessmIntake = new Set<string>();
  Set<string>  setSRPoutcome = new Set<string>();
  Map<id,string> Mapstufftext = new Map<id,string>(); 
  Map<string,string> MapAssStatus = new Map<string,string>(); 
   Map<id,string> MapStuffShort = new Map<id,string>();
  Map<string,string> map_CRIncontact = new Map<string,string>(); 
  Map<string,string> map_CRIncontactText = new Map<string,string>(); 
  Map<string,string> map_CCIncontact = new Map<string,string>(); 
   Map<string,string> map_CCIncontactText = new Map<string,string>(); 
     Set<String> setOrientAppsCreated  = new Set<String>();    
     Map<id,string> mapCaption = new Map<id,string>();
     Map<id,string> MapbtnProblemCaption = new Map<id,string>(); 
     Map<id,string> MapbtnProblemBackColor = new Map<id,string>(); 
     Map<id,string> MapbtnProblemColor = new Map<id,string>();    
    Set<String> OrientIdsnotVerif = new Set<string>();
    Map<String,String> mapOrientEventIdsnotVerif = new Map<String,String>();
      Set<Id> contInEventIntakes = new Set<Id>();
      Set<Id> docketsInEvent = new Set<Id>();
    Set<Id> docketsInCases = new Set<Id>();
       string orientStatus = 'Not Verified';  
    public List<cNodes> hierarchy;
  List<events> EventsByDate = new List<events>();    
   class events{
       date activitydate;
       string whoid;
       string whatid;
       string subject;
       string part;
       string RecordTypeId;
       string pcid;
       string name;
       string verification;
       Id eventid;}

   transient List<Case_Relationship__c> lstCasesAll;
   transient List<Contact>  lstContactsNoFilter; 
   public String[] programs = new String[]{'CEP','CIRT','SRP'};
   String[] programsEmpty = new String[]{}; 
   public String[] selProgramIds = new List<String>{cepClient,crtClient,srpClient};
   Set<String> CCids = new Set<String>();
   Set<String> CRids = new Set<String>();
 
  public String[] getPrograms(){ 
   if (programs == programsEmpty || programs == null)
       programs = selProgramIds;
   return programs;}    
   public void setPrograms(String[] programs){
        this.programs = programs;} 
 
  public List<SelectOption> getProgramItems(){
   List<SelectOption> option = new List<SelectOption>();
   option.add(new SelectOption('CEP','CEP'));
   option.add(new SelectOption('CIRT','CIRT'));
   option.add(new SelectOption('SRP','SRP'));
   return option;}

   boolean stuffMember{get;set;}
   public string crValue{get;set;}
   public string cpValue{get;set;} // court part 
   public string ccValue{get;set;}
   public List<SelectOption> crItems{get;set;}
   public List<SelectOption> ccItems{get;set;}
   public List<SelectOption> cpItems{get;set;}  
   public string timeAll{get;set;} 
   public boolean sfAdmin{get;set;} 
//   public UtilityCourtParts ucp = new UtilityCourtParts();
 
   Id userLoginStaffId{get;set;} 
 
    // CONSTRUCTOR
   public allCourtsController(){
      lSearch = false;
     searchValue = '';
     popupValue = System.currentPagereference().getParameters().get('popupValue'); 
     if (popupValue == '1')
        return;
      boroValue = 'All';
      cpValue = 'All';      
      long dt1Long,dt2long; 
      Id userProfId = userInfo.getProfileId();
      Profile p = [Select name from Profile where id =: userProfId limit 1];
      if (p.Name == 'System Administrator')
          sfAdmin = true;  
      userLoginStaffId = userInfo.getUserId();
      dt1long = datetime.now().gettime();      
      currentDate = date.today().format();
      Event e = new Event(); 
      e.closing_date__c = defaultFrom;
      e.catalog_end_date__c = defaultTo;
      proxyObject = e; 
      dt2long = datetime.now().gettime(); 
      timeAll = string.ValueOf((dt2long - dt1long)/1000);
      defaultSelection();
    if (setCCid.contains(userLoginStaffId))
        ccValue = userLoginStaffId;
      else
        ccValue = 'All';

      if (setCRid.contains(userLoginStaffId))
         crValue = userLoginStaffId;
      else
         crValue = 'All';  
      mainnodes = generateTree();
      }

   public PageReference deliverAsPDF() {
      PageReference pdf =  Page.allcourtsPage_Print;
      pdf.getParameters().put('p','p');
      return pdf;}
   public String getChooserender() {
   if (ApexPages.currentPage().getParameters().get('p') != null){
       return 'pdf';}
   else
   return null;}

   public string stageValue{get;set;}
   public string boroValue{get;set;}
   public List<SelectOption> BoroItems{get{
     List<SelectOption> Items = new List<SelectOption>();
     Items.add(new SelectOption('All','All'));
     Items.add(new SelectOption('Brooklyn', 'Brooklyn'));
     Items.add(new SelectOption('Queens', 'Queens'));
     Items.add(new SelectOption('Bronx', 'Bronx'));
     Items.add(new SelectOption('Manhattan', 'Manhattan'));
     return Items;}
     set{BoroItems = this.BoroItems;}} 
//  Map<string,string> MapCourtParts = ucp.mapCourtPartsByCourt();
  public integer numbers{get;set;}

   String[] StageNotSelected = new  List<String>{'Never Enrolled', 'Missing Intake Case'};
   String programNamesInRelShip = 'CEP_CIRT_SRP_'; 

    public List<SelectOption> StageItems{get{
       List<SelectOption> StageItems1 = new List<SelectOption>();
       StageItems1.add(new SelectOption('All','All'));
       StageItems1.add(new SelectOption('Incomplete','Incomplete Screening'));
       StageItems1.add(new SelectOption('Basic','-Basic Client Data'));
       StageItems1.add(new SelectOption('Attorney', '-Attorney Pending'));
       StageItems1.add(new SelectOption('Interview', '-Court Interv. Pending'));
       StageItems1.add(new SelectOption('Decision', '-Decision Pending'));
       StageItems1.add(new SelectOption('Orientation', '-Orientation Pending'));
       StageItems1.add(new SelectOption('Active', 'Active'));
       StageItems1.add(new SelectOption('Exited', 'Exited'));      
       return StageItems1;}
       set{StageItems = this.StageItems;}} 
   public boolean bolAllIntakes {get;set;}
  public List<clientsInfo> lstProblemShow{get;set;}     
  public List<clientsInfo> lstSchedShow{get;set;}     
  public List<clientsInfo> lstSchedShowCEP{get;set;}     
  public List<clientsInfo> lstSchedShowCRT{get;set;}     
  public List<clientsInfo> lstSchedShowSRP{get;set;}     
 
  public integer CEPnumbersAtt{get;set;}
  public integer CIRTnumbersAtt{get;set;}
  public integer SRPnumbersAtt{get;set;}
  
  public integer CEPnumbersInt{get;set;}
  public integer CIRTnumbersInt{get;set;}
  public integer SRPnumbersInt{get;set;}

  public integer CEPnumbersMan{get;set;}
  public integer CIRTnumbersMan{get;set;}
  public integer SRPnumbersMan{get;set;}

// CLASS CLIENSINFO  
public class clientsInfo{
  public string accountId{get;set;}
  public string btnTitle{get;set;}
   public string DayofWeek{get;set;}  
   public string  problem{get;set;}
   public string  StatusCaption{get;set;}
   public string  btnProblemCaption{get;set;}
   public string  btnProblemColor{get;set;} 
   public string btnProblemBackColor{get;set;} 
   public string BoroShortName{get;set;}
   public boolean dateadded{get;set;}
   public string  partColor{get;set;}
   public string  clientName{get;set;}
   public string  toolPart{get;set;}
   public string  toolDocket{get;set;}
   public string btnURL{get;set;}
   public string  NoteURL{get;set;}
   public string  CourtURL{get;set;}
   public string  clientid{get;set;}
   public string  caseid{get;set;}
   public date   activitydate{get;set;}
   public boolean StopTracking{get;set;}
   public string  courtpart{get;set;}
   public string  courtname{get;set;}
   public ID  eventId{get;set;}
   public string  documentName{get;set;}
   public boolean fontbold {get;set;} 
   public string  cNYSID{get;set;}     
   public string  pcid{get;set;}
   public string  courtCode{get;set;}     
   public string  courtBoroShort{get;set;}   
   public string  newCourtDateURL{get;set;} 
   public string intakeCase{get;set;}
   public string caseType{get;set;}
   public boolean lintakeCase{get;set;}
   public string courtdate{get;set;}
   public string CC{get;set;}
   public string CR{get;set;}
   public string CCtext{get;set;}
   public string CRtext{get;set;}
   public boolean isactive{get;set;}
   public boolean onhold{get;set;}
   public boolean assessm{get;set;}
   public string otherColor{get;set;}
   public string otherTitle{get;set;}
   public string stopURL{get;set;} 
   public boolean boolOutcome{get;set;}
   public boolean noCase{get;set;}
   public boolean stopTrack{get;set;}
   public string statusTitle{get;set;}
   public string LegalURL{get;set;}
   public string programName{get;set;}
   public boolean dateChanged{get;set;}}

    public string currentDate{get;set;}
      public string from_to{get;set;}
       public Event proxyObject {get; set;}
  
/* Wrapper class to contain the nodes and their children */

  public class cNodes{
    public clientsInfo d {get;set;} 
    public List<clientsInfo> e {get;set;}
    public cNodes(clientsInfo d1, List<clientsInfo> e1){
        d = d1;
        e = e1;
    }}
/*end of Wrapper class */ 
 public List<cNodes> mainnodes{get;set;}
  List<clientsInfo> allEvents = new List<clientsInfo>();
  
// GENERATE TREE
  public List<cNodes> generateTree(){ 
    if (popupValue == '1')
        return hierarchy;
    String programName = '';
    String[] clientsToSelect = new List<String>{};
  integer p;
    for (p = 0; p < programs.size(); p++){
        if (programs[p] == 'CEP'){
        programName += 'CEP_';
        clientsToSelect.add(cepClient);
        break;}}    
  for (p = 0; p < programs.size(); p++){
        if (programs[p] == 'CIRT'){
        programName += 'CRT_';
        clientsToSelect.add(CRTClient);
        break;}}    
    for (p = 0; p < programs.size(); p++){
        if (programs[p] == 'SRP'){
        programName += 'SRP_';
        clientsToSelect.add(SRPClient);
        break;}}    
     List<Case_Relationship__c> lstCases = new List<Case_Relationship__c>(); 
     List<Contact> contacts = new List<Contact>();  
  string BoroShortName;
     Map<String,String> mapBoroShort = new Map<String,String>();  
     mapBoroShort.put('All','A');
     mapBoroShort.put('Brooklyn','B');
     mapBoroShort.put('Manhattan','M');
     mapBoroShort.put('Queens','Q');
     mapBoroShort.put('Bronx','X');
 
    List<cNodes> hierarchy = new List<cNodes>();
     Set<Id> contInEventAll = new Set<Id>();
      Set<Id> contInCasesIntakes = new Set<Id>();
      Set<Id> contInCasesAll = new Set<Id>();

     List<Contact>  lstContactsNoCourt = new  List<Contact>(); 
     Set<String> caseIds = new Set<String>();
     Set<String> chkOption = new Set<String>();         
     Set<String> progPlans = new Set<String>();
     Set<String> intakeContactsInCase = new Set<String>(); 
     Set<String> intakeCases = new Set<String>(); 
     Set<String> IntakeDocketsInCaseNoFilter = new Set<String>();
     string strNoteURL = '/a0X/e?CF00N60000001rJHj='; 
    if (stageValue == null)
       stageValue = 'All';

     datefrom = proxyobject.closing_date__c;
     dateto = proxyobject.catalog_end_date__c;

     from_to = datefrom.format() + '-' + dateto.format();
     hierarchy = new List<cNodes>();
     string EventSubject = 'Court Date';     
     Map<String,String> mapCaseName = new Map<String,String>();  
     Map<String,String> mapBoroCode = new Map<String,String>();  
     Map<String,String> mapCaseTitle = new Map<String,String>();      
     Set<String> intakeContacts = new Set<String>();
     Set<String> contIds = new  Set<String>();
     Set<Id> allEventsContactIds = new Set<Id>();
     string courtcode,court4filter;
     List<clientsInfo> lstAllDatesDesc = new List<clientsInfo>();
     List<clientsInfo> lstAllDates = new List<clientsInfo>();
     String strQueryEvents;
     BoroShortName = 'A'; 
  
     Set<String> notSchedIds = new Set<String>();     
     Map<string,string> mapAccount = new Map<string,string>();
  string pcid;     
   List<Contact> lstContactsNotSched = new  List<Contact>();
   date notShedFrom = date.today().addDays(-30);
   date exitedFrom = date.today().addDays(-10);
   Set<String> setContactHasOrientApps = new Set<String>();
   try{
      lstContactsNotSched = [select id, name, p_c_id__c,intake_case__c,Intake_Court_Formula__c,accountid,
        case_coordinator__c, court_rep__c,NYSID__c,current_intake_date__c,firstname,lastname,
        Most_Recent_Program_Plan__c,Client_Status__c,Screening_Stage__c,Attorney_Consent__c,
        Client_Consent__c,Interview_Stage__c,Next_Court_Date__c,Arraignment_Outcome__c,
        Screening_Outcome__c,Current_Exit_Date__c
        from Contact where recordtypeid in: clientsToSelect and  
        p_c_id__c != null and Next_Court_Date__c =: null and 
        Screening_Stage__c not in : StageNotSelected and 
        Client_Status__c !=: 'Never Enrolled' and Client_Status__c !=: 'Exited'  order by name];
 
        for (Contact cnt : lstContactsNotSched){
           if(cnt.Screening_Stage__c == 'Pending Intake/Needs' && (cnt.Arraignment_Outcome__c == '' || cnt.Arraignment_Outcome__c == NULL)
               && (cnt.Screening_Outcome__c == '' || cnt.Screening_Outcome__c == NULL)) 
           setSRPoutcome.add(cnt.id); 
        }
   }
   catch (Exception e){
      ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'lstContactsNotSched too big'));
      return null;}   
   for (Contact sc : lstContactsNotSched){
      if (sc.Next_Court_Date__c == null)
            notSchedIds.add(sc.id);
    }
   date orientDateFrom = date.today().addDays(-30);
   Set<String> setcontactsInCourt = new Set<String>();
   if (searchValue== null || searchValue == ''){  
     if (boroValue != null && boroValue != 'All'){
        for (Case_Relationship__c caseAll :lstCasesAll){
             BoroShortName = mapBoroShort.get(boroValue);
             string boro = boroValue;
             If (caseAll.CaseBoro__c == boro) 
               lstCases.add(caseAll);}}
     else
        lstCases = lstCasesAll;
     searchValue = '';}
    else{
      String[] selectedCases = new String[]{'Intake Case','In-Program'};
      programName = 'CEP_SRP_CRT_';
      BoroShortName = 'A';      
      boroValue = 'All';
      stageValue = 'All';
      string s = searchValue.trim();
      string cep = 'CEP_' + s;
      string crt = 'CRT_' + s;
      string srp = 'SRP_' + s;
      string trp = 'TRP_' + s;
      string sWhere;
      if (s.length() == 6)
       sWhere = 'PCID__c =: crt or PCID__c =: cep or PCID__c =: srp or PCID__c =: trp'  ;
      else
     sWhere = ' (Docket_Name__c =: s  or indictment__c =:s or nysid__c =: s  ' + 
       'or Client_Name__c LIKE \'%' + s  + '%\')' + 
       ' and Case_Type__c in: selectedCases';
   
       string selectCases = 
       'SELECT Case_Type__c,Client_Name__c,Docket__c,Name,Program__c,Contact__c, docket_name__c, Indictment__c,  ' + 
       'Docket_Indictment__c, Boro_Court__c,CaseBoro__c,pcid__c,nysid__c,programId__c, account__c  ' + 
       'FROM Case_Relationship__c where ';
      selectCases += sWhere;
      lstCases = Database.Query(selectCases);
      if (lstCases.size() == 0){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'no Records found'));
         searchValue = '';
         return generateTree();
       }   
         string docketid; 
         docketid = lstCases[0].docket__c;
         docketsInEvent = new Set<Id>();
         docketsInCases = new Set<Id>();
     
        for (Case_Relationship__c cr : lstCases){
          if (cr.pcid__c != null){
            pcid = cr.pcid__c.left(3);
            if (programName.contains(pcid)){
               contInEventIntakes.add(cr.Contact__c); 
             //  contInEventAll.add(cr.Contact__c);
              if (docketsInEvent.contains(cr.docket__c) == false)
                  docketsInEvent.add(cr.docket__c);}}}
     List<Event> eventsSearch = new  List<Event>();
     string Outcome = 'Pending';
     strQueryEvents = 'Select Id,activitydate,subject,whoid,part__c,p_c_id__c,whatid,who.name,verification_status__c, ' +
     'recordtypeid from Event where subject =:EventSubject and whatid in: docketsInEvent ' + 
      ' and outcome__c =: Outcome order by activitydate desc, part__c,who.name limit 3';  
     try{
     eventsSearch =  Database.Query(strQueryEvents);  
     }
     catch (exception e){
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info,'Too many records. Please change a date range'));
            }
   //eventsSearch
     events oneEvent = new events();
     EventsByDate = new List<events>();
     Set<ID> EventsId = new Set<ID>();
    for (Event ev : eventsSearch){
      pcid = ev.p_c_id__c.left(3);
      oneEvent = new events();
      if ((pcid == 'CEP' || pcid == 'SRP' || pcid == 'CRT') && ev.whatid != null){
        oneEvent.activitydate = ev.activitydate;
         oneEvent.whoid = ev.whoid;
         oneEvent.whatid = ev.whatId;
         oneEvent.subject = ev.subject;
         if (ev.part__c != null && ev.part__c != '')
           oneEvent.part = ev.part__c;
        else
          oneEvent.part = 'n/p';
         oneEvent.RecordTypeId = ev.recordtypeId;
         oneEvent.pcid = pcid;
         oneEvent.name = ev.who.name;
         oneEvent.verification = ev.verification_status__c;
         oneEvent.eventId = ev.id;
        if (ev.recordTypeId == courtDateRecType && EventsId.contains(ev.id) == false){
           EventsByDate.add(oneEvent);
           EventsId.add(ev.id);
           setcontactsInCourt.add(ev.whoid);
        }
      }}
   lstContactsNoFilter = new List<Contact>();
      for (Contact cnt : [select id, name, p_c_id__c,intake_case__c,Intake_Court_Formula__c,
       accountId,case_coordinator__c, court_rep__c,NYSID__c,current_intake_date__c,
       firstname,lastname,
        Most_Recent_Program_Plan__c,Client_Status__c,Screening_Stage__c,Attorney_Consent__c,
        Client_Consent__c,Interview_Stage__c,Next_Court_Date__c,Current_Exit_Date__c
        from Contact where id in: setcontactsInCourt and p_c_id__c != null]){
         if (cnt.p_c_id__c.left(3) == 'CEP' || cnt.p_c_id__c.left(3) == 'SRP' || cnt.p_c_id__c.left(3) == 'CRT')
           lstContactsNoFilter.add(cnt);  
        }      
         mapIDcontact = new map<ID,Contact>(lstContactsNoFilter);
       for (Contact cnt : lstContactsNoFilter){
        if (cnt.Court_Rep__c != null){
          map_CRIncontact.put(cnt.id, MapStuffShort.get(cnt.Court_Rep__c));
          map_CRIncontactText.put(cnt.id, MapStuffText.get(cnt.Court_Rep__c));
       }
       else{
         map_CRIncontact.put(cnt.id, '--');
        map_CRIncontactText.put(cnt.id,'no Court Representative');  
       
       }
       if (cnt.Case_Coordinator__c != null){
           map_CCIncontact.put(cnt.id, MapStuffShort.get(cnt.Case_Coordinator__c));
          map_CCIncontactText.put(cnt.id, MapStuffText.get(cnt.Case_Coordinator__c));  
       }
       else{
         map_CCIncontact.put(cnt.id, '--');
         map_CCIncontactText.put(cnt.id,'no Case Coordinator');}}}  
    // END CASES-Evens select
 
   Map<string,string> mapCaseType = new Map<string,string>(); 
   Set<string> setcontactsSelectedByboro = new Set<string>();
   if (lstCases == null)
      return null;
   for (integer r = 0; r < lstCases.Size(); r++){
     if (programNamesInRelShip.contains(lstCases[r].Program__c)){ 
       setcontactsSelectedByboro.add(lstCases[r].Contact__c);     
       if (lstCases[r].Case_Type__c == 'Intake Case'){
         intakeCases.add(lstCases[r].Docket__c);
         intakeContacts.add(lstCases[r].Contact__c);}
    //   else
        mapCaseType.put(lstCases[r].Docket__c,lstCases[r].case_type__c);  
     mapAccount.put(lstCases[r].Contact__c,lstCases[r].Account__c);
     mapCaseName.put(lstCases[r].Docket__c,lstCases[r].Docket_Indictment__c);
     if (lstCases[r].indictment__c == '' || lstCases[r].indictment__c == null)
       mapCaseTitle.put(lstCases[r].Docket__c,'Docket #');
     else 
       mapCaseTitle.put(lstCases[r].Docket__c,'Indictment #');          
       mapBoroCode.put(lstCases[r].Docket__c,lstCases[r].Boro_Court__c);}}
 
     if (lstContactsNoFilter.Size() == 0)
       return null;
     Set<String> setclientsAdded = new Set<String>();
     boolean attorney,interview,mandate,orient,active,exited;
     string status, screenStage;
      boolean problem;
      string problemDescr;
        date ctdate;
     string caseid,progPlan;
     Set<string> contactsSelelectedId = new   Set<string>();
     boolean addClient,byStage;
     List<Contact> lstContactFilter = new List<Contact>();
    if (ccValue != 'All'){
      staffName = Mapstufftext.get(ccValue); 
      for (Contact c : lstContactsNoFilter){
        if (c.case_coordinator__c == ccValue)
          lstContactFilter.add(c);
      }}

   if (crValue != 'All'){
      if (crValue != courtDateRecType){
       staffName = Mapstufftext.get(crValue); 
       for (Contact c : lstContactsNoFilter ){
         if (c.Court_Rep__c == crValue)
           lstContactFilter.add(c);}}
      else{
        for (Contact c : lstContactsNoFilter ){
         if (c.Court_Rep__c == null)
           lstContactFilter.add(c);}}}
   if (lstContactFilter.Size() == 0)
       lstContactFilter = lstContactsNoFilter;

   for (Contact cnt : lstContactFilter){
     addClient = false;    
     problem = false;
     pcid = cnt.p_c_id__c.left(3);
     screenStage = cnt.Screening_Stage__c;
     if (screenStage == null){
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'stage NULL for contact: ' + cnt.ID + '- 484'));
       return null;}
     byStage = false;
     status = cnt.Client_Status__c;
     problemDescr = '' ;
     caseid = cnt.Intake_Case__c;
     if(screenStage == 'Pending Basic Client Data'){
       problemDescr = 'Basic';
       problem = true;
       byStage = true;}
     else{  
       if(screenStage == 'Pending Attorney Info'){
          problemDescr = 'Attorney';
          byStage = true;}
       else{
         if(screenStage == 'Pending Interview'){
           problemDescr = 'Interview';
           byStage = true;}
           else{
             if (screenStage == 'Pending Mandate'){  
               if (pcid == 'CEP'){
                 problemDescr = 'Intake';}         
               else{
               problemDescr = 'Mandate';
              }
       byStage = true;}}}}
       if (byStage == false){
           if (Status == 'Active') {
            problemDescr = 'Active';}
          else{
            if (Status == 'Exited'){
              problemDescr = 'Exited';}   
            else{
              if (status == 'On Program Hold'){
                problemDescr = 'Hold';}}
            if (pcid == 'CEP' && status != 'On Program Hold' &&
               (setOrientAppsCreated.contains(cnt.id) == false || OrientIdsNotVerif.contains(cnt.id) == true
               && screenStage != 'Pending Mandate')){
                problemDescr = 'Orientation';
       }}}
      
      if (checkFilter(problemDescr))    
           contactsSelelectedId.add(cnt.id);
       if (progPlans.contains(cnt.Most_Recent_Program_Plan__c) == false)
             progPlans.add(cnt.Most_Recent_Program_Plan__c);}

   Map<Id, Contact> mapContact = new Map<Id, Contact>(lstContactFilter);
     date dt;
 
   Map<id,Program_Plan__c> MapPP = new Map<id,Program_Plan__c>([Select id,name from 
     Program_Plan__c where id in: progPlans]);
    List<clientsInfo> lstProblem = new List<clientsInfo>();
      clientsInfo oneDate = new clientsInfo();

     if (lstProblemShow != null)
       lstProblemShow.Clear();
     List<events> lstSelectedEvents = new List<events>();      
    if (searchValue== null || searchValue == ''){  
      for (integer d = 0; d < Eventsbydate.Size();d++){      
        if (contactsSelelectedId.contains(EventsByDate[d].whoid) &&
           setcontactsSelectedByboro.contains(EventsByDate[d].whoid) && 
           programName.contains(EventsByDate[d].pcid)){
           lstSelectedEvents.add(EventsByDate[d]);  
     }}}
    else{
      contactsSelelectedId = setcontactsInCourt;
      lstSelectedEvents = EventsByDate;}
  Id assId;
  if (allEvents != null)
     allEvents.clear();
  allEvents = new List<clientsInfo>();
  string attConsent,passStatus,prgStatus;
  List<String> lstParts = new List<String>();
  Set<string> setCourtPart = new Set<string>();

   cpItems = new List<SelectOption>();
 cpItems.add(new SelectOption('All','All'));
 cpItems.add(new SelectOption('n/p','-Court w/o part')); 
 if (cpValue == null)
     cpValue = 'All';
 
  for (integer k = 0; k < lstSelectedEvents.Size();k++){
    byStage = false;
    passStatus = '';
    oneDate = new clientsInfo();
    attConsent = mapIDcontact.get(lstSelectedEvents[k].whoid).Attorney_Consent__c;
    oneDate.isActive = false; 
    oneDate.caseType = '';
    oneDate.onHold = false; 
    oneDate.btnTitle = '';
    oneDate.courtCode = mapBoroCode.get(lstSelectedEvents[k].whatid);
    if (oneDate.courtCode != null){ 
      if (oneDate.courtCode == 'Bronx')
        oneDate.BoroShortName = 'X';
      else   
        oneDate.BoroShortName = oneDate.courtCode.left(1);}
    else
      oneDate.BoroShortName = '';
     oneDate.btnTitle = ''; 
    oneDate.clientName = lstSelectedEvents[k].name;     
    oneDate.otherColor = 'black';
    oneDate.clientid = lstSelectedEvents[k].whoid;           
    oneDate.caseId = lstSelectedEvents[k].whatid;
    oneDate.btnProblemCaption = '';
    oneDate.statusCaption = '';
    oneDate.accountId = mapAccount.get(oneDate.clientid);              
    oneDate.pcid = lstSelectedEvents[k].pcid;   
    pcid = (oneDate.pcid).left(3);
    oneDate.cr = map_CRIncontact.get(lstSelectedEvents[k].whoid); 
    oneDate.crtext = map_CRIncontactText.get(lstSelectedEvents[k].whoid);
    if (mapIDcontact.get(lstSelectedEvents[k].whoid).Screening_Stage__c != null)
      screenStage = mapIDcontact.get(lstSelectedEvents[k].whoid).Screening_Stage__c.trim();     
    if (mapIDcontact.get(lstSelectedEvents[k].whoid).client_status__c != null){
       status = mapIDcontact.get(lstSelectedEvents[k].whoid).client_status__c.trim();  
    if (status == 'Active')
      oneDate.isActive = true; 
    oneDate.cc = map_CCIncontact.get(lstSelectedEvents[k].whoid); 
    oneDate.cctext = map_CCIncontactText.get(lstSelectedEvents[k].whoid);
    oneDate.eventid =  lstSelectedEvents[k].eventid;
    oneDate.activitydate =  lstSelectedEvents[k].activitydate;
    oneDate.courtdate = lstSelectedEvents[k].ActivityDate.format();
    oneDate.DayofWeek = (Datetime.newInstance(oneDate.ActivityDate, Time.newInstance(0,0,0,0))).format('EEEE');
    oneDate.cNYSID = mapContact.get(lstSelectedEvents[k].whoid).nysid__c;    
    oneDate.intakecase = mapContact.get(lstSelectedEvents[k].whoid).intake_case__c;  
    oneDate.stopTrack = false; 
    oneDate.clientName = lstSelectedEvents[k].name;
    oneDate.lintakeCase = true;
    oneDate.caseType = mapCaseType.get(oneDate.caseId);
   if (oneDate.caseType != null){
      if (oneDate.caseType.trim() != 'Intake Case'){
        oneDate.lintakeCase = false;
        oneDate.caseType = 'Re-arrest';}
      else 
        oneDate.caseType += ' Case';}
    
    oneDate.documentName = mapCaseName.get(oneDate.caseId);
    oneDate.tooldocket = mapCaseTitle.get(oneDate.caseId); 
    oneDate.courtPart = lstSelectedEvents[k].part;
    oneDate.courtCode = mapBoroCode.get(lstSelectedEvents[k].whatid); 
    oneDate.partColor = 'black';
    oneDate.legalURL = '/apex/legalHistory?case=' + oneDate.caseId + '&contact=' + oneDate.clientid;
    if (oneDate.courtpart == 'n/p' || oneDate.courtpart == null){
      oneDate.partColor = 'red';
      oneDate.toolpart = 'no court part';  
      oneDate.courtPart = 'n/p';}
    oneDate.courtUrl = '/apex/UpdateCourtDate?courtdate='+lstSelectedEvents[k].eventid+'&portalName=All' ;
    oneDate.courtUrl = '/' + lstSelectedEvents[k].eventid;
    if (setAssessm.contains(oneDate.clientid) == false  && oneDate.pcid == 'CEP'){
      oneDate.otherColor = 'red';
      oneDate.otherTitle = 'Assessment';}
    else
    {
//      if (setAssessmLocked.contains(oneDate.clientid) == false  && oneDate.pcid == 'CEP'){
 //       oneDate.otherTitle = 'Complete Assessment';
  //      oneDate.otherColor = 'red';}
    //  else
        oneDate.othertitle = 'Assessment Complete';
    }           
    if (status <> screenStage)
      oneDate.statusTitle = status + ' - ' + screenStage; 
    else
      oneDate.statusTitle = status;
    oneDate.btnProblemColor = 'white';    

   if(screenStage == 'Pending Basic Client Data'){
      oneDate.btnProblemCaption = 'Basic data';
      oneDate.btnProblemBackColor = '#68938d';
      passStatus = 'Basic';
      oneDate.btnTitle = 'Pending Basic Client Data';
      byStage = true;}
    else{
      oneDate.btnTitle = '';
      if(screenStage == 'Pending Attorney Info'){
          passStatus = 'Pending Attorney Info';
          if (attConsent == 'Hold'){
            oneDate.btnTitle = 'Pending Attorney Info';  
            oneDate.btnProblemCaption = 'Att hold';
            oneDate.btnProblemBackColor = 'RGB(66,149,249)';  
         }
         else{
         oneDate.btnProblemCaption = 'Attorney';
            oneDate.btnProblemBackColor = '#d3414a';}
       byStage = true;}
       else{
           if(screenStage == 'Pending Interview'){
             passStatus = 'Pending Interview';
       oneDate.btnProblemCaption = 'Interview';
       oneDate.btnTitle = 'Pending Interview';
           oneDate.btnProblemBackColor = '#FFC12C';
          byStage = true;}
          else{
            oneDate.btnTitle = '';
            if (screenStage == 'Pending Mandate' && status != 'Active'){
               byStage = true;
              passStatus = 'Pending Mandate';
              oneDate.btnTitle = 'Pending Mandate';
          if (pcid == 'CEP' ){
              oneDate.btnProblemCaption = 'Intake';    
                   oneDate.btnProblemBackColor = '#ffa500';
                   oneDate.btnTitle = '';}
           else{
             passStatus = 'Mandate';
             oneDate.btnProblemCaption = 'Mandate';
              oneDate.btnProblemBackColor = '#68938d';  
           }}}}} 
      
  if (byStage == false){
    if (pcid == 'CEP' && oneDate.isActive == false && 
          status != 'On Program Hold' && status != 'Exited' && screenStage != 'Pending Mandate' && status != 'Active'){
      if (setOrientAppsCreated.contains(oneDate.clientid) == false) {
         oneDate.btnProblemCaption = 'Orientation'; 
         oneDate.btnProblemBackColor = '#68938d';
         passStatus = 'Orientation';} 
      else{
        if (OrientIdsNotVerif.contains(oneDate.clientid) == true) {
            oneDate.btnProblemCaption = 'Orientation'; 
          oneDate.btnProblemBackColor = '#abbe55';
          oneDate.btnTitle = 'Orientation Scheduled';  
          passStatus = 'Orient sched';}
      }}}
    if (status == 'On Program Hold'){
             oneDate.onHold = true;
            oneDate.statusCaption = 'on Hold';
            passStatus = 'On Hold';}            
     else{
       if (oneDate.lintakeCase == true){
       if (status == 'Active')
              oneDate.statusCaption = 'Active';
        else 
       if (status == 'Exited')
          oneDate.statusCaption = 'Exited';
       }
       else{
       if (status == 'Active')
              oneDate.statusCaption = '-Active';
        else 
       if (status == 'Exited')
          oneDate.statusCaption = '-Exited';
       }}}
   progPlan = mapIdContact.get(lstSelectedEvents[k].whoid).Most_Recent_Program_Plan__c;
    if (progPlan != null && progPlan <> ''){
      oneDate.NoteURL = strNoteURL + mapPP.get(progPlan).Name;
      oneDate.NoteURL += '&RecordType=' + Utility_ID__c.getValues('Court Rep Note').RecordType_Id__c;}
   if (screenStage == null){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'stage NULL for contact: cnt.ID.-line 671'));
        return null;
    }
    oneDate.btnURL = 
            findbtnURL(oneDate.pcid,oneDate.caseid,oneDate.clientid,oneDate.accountId,passStatus,oneDate.eventid);  
 
  if (setCourtPart.contains(oneDate.courtPart) == false && oneDate.courtPart <> 'n/p'){
      lstParts.add(oneDate.courtPart);
      setCourtPart.add(oneDate.courtPart);
    }
  
  if (cpvalue == 'All' || oneDate.courtPart.trim() == cpValue.trim()){
    lstAllDates.add(oneDate);
  //  if (setCourtPart.contains(oneDate.courtPart) == false && oneDate.courtPart <> 'n/p'){
 //     lstParts.add(oneDate.courtPart);
  //    setCourtPart.add(oneDate.courtPart);
  //  }
    if (lstSelectedEvents[k].activitydate != ctdate){
      oneDate.dateadded = true;
      lstAllDatesDesc.add(oneDate);
      
      ctdate = lstSelectedEvents[k].activitydate;
    }}}
    
    //parts list
    lstParts.sort();
    for (integer m = 0; m < lstParts.size(); m++){
     cpItems.add(new SelectOption(lstParts[m],lstParts[m]));}  
 
  
    System.Debug('\n\n XXX lstParts: ' + lstParts); 
   
  string ctpart,clientid,ccid, crid,ctcode,ctcode1;
    boolean partAdded,dateadded,clientAdded;
    List<clientsInfo> ci = new List<clientsInfo>();
    clientsInfo oneClient = new clientsInfo();  
   date ctdate1;
   integer nRow = 0;
 
 numbers = 0;
     boolean include;
    if (mapContact == null)
       return null;
   integer m = 0;
   integer n = 0;
    for (integer i = 0; i < lstAllDatesDesc.Size();i++){
         ctdate = lstAllDatesDesc[i].activitydate;
         string color;
         for (integer a = i; a < lstAllDates.Size(); a++){
           ctcode = lstAllDates[a].courtCode;
           oneClient = new clientsInfo();
       if (lstAllDates[a].activitydate ==  ctdate){
                  numbers++;
              setclientsAdded.add(lstAllDates[a].clientid) ;   
              oneClient = lstAllDates[a];                
              ci.add(oneClient); 
              clientAdded = true;          
            }
          allEvents = ci;
         }  
       if (allEvents.Size() > 0)
         hierarchy.add(new cNodes(lstAllDatesDesc[i],allEvents));
         m = i;
      } 
    selectProblem(lstContactsNotSched,notSchedIds,setOrientAppsCreated,OrientIdsNotVerif);
    lSearch = false;
    return hierarchy;}
    //end left side
    //*************************************
    
    integer noOfDays{get;set;}  
    public void RequeryInfo(){
      string cc = ccValue;
      string cr = crValue;
      if (proxyObject.closing_date__c > proxyObject.catalog_end_date__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 
            'Please scheck a date range.'));
            return;}
 
     noOfDays = rq.checkDatesRange(proxyObject.catalog_end_date__c,proxyObject.closing_date__c);
     if (cc == 'All' && cr == 'All'){
       if (sfAdmin == false){
          if (noOfDays > 12){
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Please select date range no more than 12 working days.'));
            return;
          }  }
     }
     else{
     if (noOfDays > 20 && sfAdmin == false){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Please select date range no more than 20 working days.'));
       return;}
     }
  
       popupValue = System.currentPagereference().getParameters().get('popupValue'); 
        if (popupValue == '1')
        return;
         searchValue = '';
        if (proxyObject.catalog_end_date__c != defaultFrom || proxyObject.closing_date__c != defaultTo )
          defaultSelection();
         mainnodes = generateTree();}

// PROBLEM PROC    
     void selectProblem(List<Contact> lstNotSched,Set<string> notSchedIds,Set<String> setOrientAppsCreated,
                        Set<String> OrientIdsnotVerif){
        string problemDescr;
       List<clientsInfo> lstProblem = new List<clientsInfo>();
       clientsInfo oneProblem = new clientsInfo();
       boolean attorney,interview,mandate;
       string pcid,caseid;
      Set<String> idAttended = new Set<String>();
      Map<string,string> mapDockets = new Map<string,string>();      
     for (Contact c : [SELECT intake_case__c,id,accountId from  
         Contact  where id in: notSchedIds]){
           mapDockets.put(c.id,c.intake_case__c);} 
       CEPnotSched = 0;
       CRTnotSched = 0;
       SRPnotSched = 0;   
       list<clientsInfo> lstToschedCEP = new list<clientsInfo>();
       list<clientsInfo> lstToschedCRT = new list<clientsInfo>();
       list<clientsInfo> lstToschedSRP = new list<clientsInfo>();
       list<clientsInfo> lstTosched = new list<clientsInfo>();
       clientsInfo oneSched = new clientsInfo();
       string ids = '';
       string stage, status;
       boolean byStage,addClient;
       for (Contact s : lstNotSched){
           addClient = false;
          attorney = false;
          interview = false;
          mandate = false;
          oneSched = new clientsInfo();
          oneSched.btnProblemColor = 'white';
          oneSched.btnProblemCaption = '';
          oneSched.statusCaption = '';          
          oneSched.problem = 'YYY';
          oneSched.caseid = mapDockets.get(s.id);
          oneSched.stopTrack = false;
          oneSched.noCase = false;
          oneSched.btnTitle = '';
          if (s.Screening_Stage__c != null)
             stage = s.Screening_Stage__c.trim();
          if (s.client_status__c != null){
             status = s.client_status__c.trim();     
          }
          pcid = s.p_c_id__c.left(3);
          if (status != null){
              if (status == 'Screened' && pcid == 'CEP')
                   oneSched.stopTrack = true;
           }
          byStage = false;
          if (oneSched.caseid != null){
              oneSched.newCourtDateURL = '/00U/e?what_id=' + (oneSched.caseid).trim() + 
          +'&who_id=' + s.Id + '&RecordType='
                    + Utility_ID__c.getValues('Court Date').RecordType_Id__c 
                    + '&retURL=apex/allCourtsPage' + '&ent=Event'; 
             oneSched.toolDocket = 'Create Court Date';}
           else
             oneSched.toolDocket = 'no Docket linked in Case Relationship obj.';
           
           oneSched.accountId = s.AccountId;
           oneSched.clientName = s.name;
           oneSched.clientid = s.id;
           oneSched.pcid = s.p_c_id__c.left(3);
           //   by STAGE
           if(stage  == 'Pending Basic Client Data'){
             oneSched.btnTitle = 'Pending Basic Client Data';
             oneSched.btnProblemCaption = 'Basic data';
             problemDescr = 'Basic';
             OneSched.btnProblemBackColor = '#68938d';
             oneSched.btnURL = 
          findbtnURL(oneSched.pcid,oneSched.caseid,oneSched.clientid,oneSched.accountId,'BasicClientData','');  
             byStage = true;}
           else{    
            oneSched.btnTitle = '';        
             if(stage =='Pending Attorney Info'){ 
               if(s.Attorney_Consent__c == 'Hold'){
                 oneSched.btnTitle = 'Pending Attorney Info';
                 oneSched.btnProblemCaption = 'Attrn hold';
                 OneSched.btnProblemBackColor = 'RGB(66,149,249)';}
             else{
                 oneSched.btnProblemCaption = 'Attorney';
                 OneSched.btnProblemBackColor = '#d3414a';
                 attorney = true;}
               byStage = true;
               oneSched.btnURL = 
                   findbtnURL(oneSched.pcid,oneSched.caseid,oneSched.clientid,oneSched.accountId,'Attorney','');  
               problemDescr = 'Attorney';                     
               }
             else{  
               oneSched.btnTitle = '';        
               if(stage == 'Pending Interview'){
                 oneSched.btnTitle = 'Pending Interview';
                 oneSched.btnProblemCaption = 'Interview';
                 oneSched.btnProblemBackColor = '#FFC12C';   
                 problemDescr = 'Interview';                     
                 oneSched.btnURL = findbtnURL(oneSched.pcid,oneSched.caseid,oneSched.clientid,oneSched.accountId,'Interview','');
                 byStage = true;
               }
               else{
                 oneSched.btnTitle = '';
                 if (stage == 'Pending Mandate') { 
                   if (pcid == 'CEP'){    
                     oneSched.btnProblemCaption = 'Intake';
                     oneSched.btnProblemBackColor = '#ffa500';   
                     problemDescr = 'Intake';   
                     oneSched.btnTitle = '';                  
                     byStage = true;
                     oneSched.btnURL = 
                     findbtnURL(oneSched.pcid,oneSched.caseid,oneSched.clientid,oneSched.accountId,'Intake','');}
              }}}
    
        if (byStage == false){
          if (status != null){
            if (status.trim() == 'Active') {
                   oneSched.statusCaption = 'Active'; 
                   problemDescr = 'Active';}   
             else{
                if (status.trim() == 'Exited'){
                       oneSched.statusCaption = 'Exited';
                      problemDescr = 'Exited';}      
                else{
                      if (status.trim() == 'On Program Hold'){
                       oneSched.statusCaption = 'on Hold';
                       problemDescr = 'on Hold';
                      } 
                      else{
                        if (status.trim() == 'Intaked - Not Yet Active'){
                             oneSched.statusCaption = 'not yet Active';
                  oneSched.btnProblemCaption = 'Orientation';
                  oneSched.btnProblemBackColor = '#68938d';   
                  oneSched.btnProblemColor = 'white';                        
                  problemDescr = 'Orientation';                     
                  oneSched.btnURL = 
                  findbtnURL(oneSched.pcid,oneSched.caseid,oneSched.clientid,oneSched.accountId,'Orientation','');}     
                        else{
                            if (status.trim() == 'Incomplete Screening')
                        oneSched.statusCaption = 'Incomplete';
                        }}}}}       
  
      if (pcid == 'CEP' && 
         (OrientIdsnotVerif.contains(s.id) == true || setOrientAppsCreated.contains(s.id) == false)
           && oneSched.statusCaption != 'Mandate' && oneSched.statusCaption != 'Interview'
             && status != 'Active'){
                   oneSched.btnProblemCaption = 'Orientation';
                  oneSched.btnProblemBackColor = '#68938d';
                   oneSched.btnProblemColor = 'white';                     
                   problemDescr = 'Orientation';                     
                  }}}
         if (checkfilter(problemDescr)){        
           if (pcid == 'CEP'){
                 if (crValue == 'All' || (s.Court_Rep__c == crValue && crValue != courtDateRecType)){
                lstToschedCEP.add(oneSched);
               CEPnotSched++;}
               oneSched.stopURL = 
               '/apex/cepIntakeContainer?intakeCaseId='+oneSched.caseid+
               '&contactId='+oneSched.clientid+'&accountId='+oneSched.accountId+'&stage=StopTracking&portalName=All'; 
            }else{
               if (pcid == 'CRT'){
                     if (crValue == 'All' || (s.Court_Rep__c == crValue && crValue != courtDateRecType)){
                  lstToschedCRT.add(oneSched);
                  CRTnotSched++;}}
               else{ 
                 oneSched.booloutcome = false;
                 if (setSRPoutcome.contains(oneSched.clientId)){
                   oneSched.btnProblemBackColor = '#556b2f';
                   oneSched.btnProblemColor = 'white';
                    oneSched.booloutcome = true;
                    oneSched.btnUrl = '/apex/srpOutcomeScreen?contact=' + onesched.clientid + '&caseId=' + oneSched.caseid+'&portalName=All';
                  }
                  if (crValue == 'All' || (s.Court_Rep__c == crValue && crValue !=courtDateRecType)){
                  lstToschedSRP.add(oneSched);
                  SRPnotSched++;}} }
                  if (status <> stage)         
                      oneSched.statusTitle = status + ' - ' + stage;
                  else      
                      oneSched.statusTitle = status ;
            if (status == 'Missing Intake Case'){
              oneSched.statusCaption = 'no Intake Case';
              oneSched.noCase = true;
            }
            if (crValue == 'All' || (s.Court_Rep__c == crValue && crValue !=courtDateRecType))
               lstTosched.add(oneSched);}}
           if (lstTosched != null)
              lstSchedShow = lstTosched;

        if (lstToschedCEP != null)
           lstSchedShowCEP = lstToschedCEP;
       if (lstToschedCRT != null)
          lstSchedShowCRT = lstToschedCRT;
      if (lstToschedSRP != null)
          lstSchedShowSRP = lstToschedSRP;}
      
    public pageReference  doNothing(){return null;}
  public integer CEPnotSched{get;set;}
    public integer CRTnotSched{get;set;}
    public integer SRPnotSched{get;set;}
      
   
   List<SelectOption> SearchItems;
   public List<SelectOption> getSearchItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Docket','Docket/Indictment'));
        options.add(new SelectOption('PCID','PCID'));
        options.add(new SelectOption('Name','Name'));
        options.add(new SelectOption('NYSID','NYSID'));
        return options;
   }
   public void setSearchItems(){
    SearchItems = this.SearchItems;
   }
  public string searchValue{get;set;}
  public boolean lSearch{get;set;}
  public void selectClient(){
     if (searchValue == null || searchValue == '')
        return;
      crValue = 'All';
      ccValue = 'All';
      stageValue = 'All';
      boroValue = 'All';  
      cpValue = 'All'; 
        lSearch = true;
     mainnodes = generateTree();}
     
   public boolean checkFilter(string s){
      if (stageValue == 'All'  || (stageValue == 'Basic' &&  s  ==  'Basic')
         || (stageValue == 'Attorney' && s  == 'Attorney')
         || (stageValue == 'Decision' && s ==  'Mandate')
         || (stageValue == 'Orientation' && s == 'Orientation')
         || (stageValue == 'Active' && s == 'Active')
         || (stageValue == 'Exited' && s == 'Exited')
         || (stageValue == 'Interview' &&  s == 'Interview')
         || (stageValue == 'Incomplete' && (
         s == 'Interview'|| s ==  'Basic' || s  == 'Attorney' ||
         s ==  'Mandate' || s == 'Orientation')))
        return true;
    return false;        
   }
  public string findbtnURL(string prog,string caseid,string contactid,string accountid,string stage,string eventid){
    string s = '';
    if (prog == 'CEP'){
      if (stage != null){
        if (stage.contains('Attorney'))
           s = '/apex/attorneyInfo_CEP?case='+caseid+'&contact='+contactid+'&portalName=All';
        else{
           if (stage.contains('Basic')) 
              s = '/apex/cepIntakeContainer?intakeCaseId='+caseid+'&contactId='+contactid+
              '&accountId='+accountid+'&stage=BasicClientData'+'&portalName=All';
          else{
            if (stage.contains('Interview'))
                s = '/apex/cepIntakeContainer?intakeCaseId='+caseid+'&contactId='+contactid+
                '&accountId='+accountid+'&stage=Interview'+'&portalName=All';
            else{
            if (stage.contains('Pending') || stage.contains('Intake'))
                s = '/apex/cepIntakeContainer?intakeCaseId='+caseid+'&contactId='+contactid+
                  '&accountId='+accountid+'&stage=Intake'+'&portalName=All';
            else{
               if (stage == 'Orientation')
               s = '/00U/e?who_id=' + contactid + '&RecordType='
                            + Utility_ID__c.getValues('Orientation Appointment').RecordType_Id__c 
                            + '&retURL=apex/allcourtsPage' + '&cancelURL=apex/allcourtsPage&ent=Event';   
               else{
                if (stage == 'Orient sched'){
                 
                 s = '/' + mapOrientEventIdsnotVerif.get(contactid);
            }}}}}}}}
    else{
       if (prog == 'CRT'){
          if (stage != null){
             if (stage.contains('Interview'))
             s = '/apex/CIRTInterviewContainer?ContactId='+contactid+'&portalName=All';
          else{
              if (stage.contains('Attorney')){
                 s = '/apex/attorneyInfo?case='+caseid+'&contact='+contactid+'&portalName=All';
              }else
          if (stage.contains('Mandate')){
                 s = '/apex/cirtMandateScreen?courtDate=' + eventid+'&portalName=All';       }}}}
       else{
       if (stage != null && prog == 'SRP'){
          if (stage.contains('Interview'))
             s = '/apex/SRP_Interview_Edit?id='+contactid+'&portalName=All';
          else{
              if (stage.contains('Attorney')){
                 s = '/apex/attorneyInfo?case='+caseid+'&contact='+contactid+'&portalName=All';
       }}}}}
    return s;}
  
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
             and pageName__c =:  'UCP' order by createddate desc limit 1];}
     catch (Exception e) {
          lt = new loginTracking__c();
          lt.loginName__c = cuser;
          lt.loginDateTime__c = datetime.now().format(); 
          lt.pageName__c = 'UCP';
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
           lt.pageName__c = 'UCP';
        insert lt;}}
      }  }
      
      //    DEFAULT SELECTION - Selected clients events for DATE range ONLY
public void defaultSelection(){ 
      popupValue = System.currentPagereference().getParameters().get('popupValue'); 
      if (popupValue == '1')
         return;
     datefrom = proxyobject.closing_date__c;
    dateto = proxyobject.catalog_end_date__c;
      docketsInEvent = new Set<Id>();
      docketsInCases = new Set<Id>();
    List<Event> eventsAllProgram = new List<Event>();
      try{
   eventsAllProgram = new List<Event>([Select Id,activitydate,subject,whoid,part__c,RecordTypeId,
       p_c_id__c,whatid,who.name,verification_status__c
       from Event where subject =: 'Court Date' and outcome__c =: 'Pending'
       and verification_status__c =: 'Not Verified' and whatid !=: null
        and 
       p_c_id__c !=: null and 
       activitydate >=: datefrom and activitydate <=: dateto and  
       (p_c_id__c like 'CEP_%' or p_c_id__c like 'CRT_%' or p_c_id__c like 'SRP_%') 
       order by activitydate, part__c,who.name]);
      }
      catch (Exception e){
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'eventsAllProgram in default'));
       return ;} 
   string pcid;   
   Set<String> setContactsIdsWithCourt = new Set<String>(); 
   String[] clientsProgs = new List<String>{'CEP','CRT','SRP'};
   Set<String> contInEventAll = new Set<String>();
   Set<String> eventsIntakeRearrest = new Set<String>();
   Set<String> setAllCasesEvents = new Set<String>();
   for (Event ev : eventsAllProgram){
        setAllCasesEvents.add(ev.whatid);
        if (setContactsIdsWithCourt.contains(ev.whoid) == false)
        setContactsIdsWithCourt.add(ev.whoid);}

   lstCasesAll = new List<Case_Relationship__c>([SELECT Case_Type__c,Client_Name__c,Docket__c,
   Name,Program__c, Contact__c, Account__c,Docket_Indictment__c, Boro_Court__c,
   CaseBoro__c,indictment__c,pcid__c  
         FROM Case_Relationship__c where docket__c in: setAllCasesEvents
         and (Case_Type__c =: 'Intake Case' or Case_Type__c =: 'In-Program')]);
  Set<string> setDockets = new Set<String>();
  for (Case_Relationship__c rs : lstCasesAll) {
    if (rs.pcid__c != null){
       pcid = rs.pcid__c.left(3);
     if (pcid == 'CEP' || pcid == 'SRP' || pcid == 'CRT')
       setDockets.add(rs.docket__c);
    }}     
   
  events oneEvent = new events();
 EventsByDate = new List<events>();

// List<String> lstParts = new List<String>();
//List<String> lstIds = new List<String>();
// setCourtPart.add('-Court w/o part');
 string addPart = '';
 for (Event ev : eventsAllProgram){
    if (setDockets.contains(ev.whatid)){
      pcid = ev.p_c_id__c.left(3);
      oneEvent = new events();
      oneEvent.activitydate = ev.activitydate;
      oneEvent.whoid = ev.whoid;
      oneEvent.whatid = ev.whatId;
      oneEvent.subject = ev.subject;
      if (ev.part__c != null && ev.part__c != '')
         oneEvent.part = ev.part__c;
      else
         oneEvent.part = 'n/p';
      oneEvent.RecordTypeId = ev.recordtypeId;
      oneEvent.pcid = pcid;
      oneEvent.name = ev.who.name;
      oneEvent.eventid = ev.id;
      oneEvent.verification = ev.verification_status__c;
    
     if (docketsInEvent.contains(ev.whatid) == false)
         docketsInEvent.add(ev.whatid);
      if (contInEventAll.contains(ev.whoid) == false)
         contInEventAll.add(ev.whoid);
         if (ev.recordTypeId == courtDateRecType )
                EventsByDate.add(oneEvent);
           if (ev.p_c_id__c.trim().length() != 4) 
                  contInEventIntakes.add(ev.whoid); }
 }
 
 for (Event e : [Select Id,activitydate,subject,whoid,part__c,RecordTypeId,
       p_c_id__c,whatid,who.name,verification_status__c
       from Event where subject =: 'Orientation Appointment' 
       and outcome__c !=: 'Entered in Error'
       and whoid in: setContactsIdsWithCourt
       and p_c_id__c like 'CEP_%']){
       setOrientAppsCreated.add(e.whoid);
       if ( e.verification_status__c == 'Not Verified'){
            OrientIdsNotVerif.add(e.whoid);
           mapOrientEventIdsnotVerif.put(e.whoid,e.id);
       }}
   string ccName, crName;
  string ccid,crid;  
  lstContactsNoFilter = [select id, name, p_c_id__c,intake_case__c,Intake_Court_Formula__c,accountId,firstname,lastname,
        case_coordinator__c, court_rep__c,NYSID__c,current_intake_date__c,
        Most_Recent_Program_Plan__c,Client_Status__c,Screening_Stage__c,Attorney_Consent__c,
        Client_Consent__c,Interview_Stage__c,Next_Court_Date__c,Arraignment_Outcome__c,
        Screening_Outcome__c,Current_Exit_Date__c
        from Contact where id in: contInEventAll and p_c_id__c !=: null and
        (p_c_id__c like 'CEP_%' or p_c_id__c like 'CRT_%' or p_c_id__c like 'SRP_%') and   
         Screening_Stage__c not in : StageNotSelected and 
        Client_Status__c !=: 'Never Enrolled'];         



  mapIDcontact = new map<ID,Contact>(lstContactsNoFilter);
    date exitedFrom = date.today().addDays(-10); 
   boolean byStage,problem;
   string caseid, screenStage, status, problemDescr;    
  Set<string> setIdselected = new Set<string>();
  List<string> lstcont = new  List<string>();
 Set<string> setSRPselected = new Set<string>();
  for (Contact cnt : lstContactsNoFilter){
    setIdselected.add(cnt.id);
 //   lstcont.add((cnt.id);
    if (cnt.p_c_id__c.left(3) == 'SRP'){
       setSRPselected.add(cnt.id);
       if(cnt.Screening_Stage__c == 'Pending Intake/Needs' && (cnt.Arraignment_Outcome__c == '' || cnt.Arraignment_Outcome__c == NULL)
                && (cnt.Screening_Outcome__c == '' || cnt.Screening_Outcome__c == NULL)) 
       setSRPoutcome.add(cnt.id);}
    ccId = cnt.Case_Coordinator__c;
    crId = cnt.Court_Rep__c;
    if (ccId != null && setCCid.contains(ccId) == false)
      setCCid.ADD(ccId);
      if (cRId != null && setCRid.contains(crId) == false)
        setCRid.ADD(crId);}    

  String[] verstatus= new String[]{'Not Verified','Attended'};
  for (Event lstEvent : [select id,whoid,subject from event where 
   whoid in: setSRPselected and subject like 'Intake/Needs Assessment%' 
   and verification_status__c in: verstatus]){
      setAssessmIntake.add(lstEvent.whoid);
      mapAssessmId.put(lstEvent.whoid,lstEvent.id);}
  
   assmCR = [select client__c,id from AssessmentContainer__c where
     client__c in: setIdselected and assessmentName__c =: 'Court Rep'];
   for (AssessmentContainer__c ac : assmCR){   
        setAssessm.add(ac.client__c);}
   crItems = new List<SelectOption>();
   ccItems = new List<SelectOption>();
   ccItems.add(new SelectOption('All','All'));
   crItems.add(new SelectOption('All','All'));
   crItems.add(new SelectOption(courtDateRecType,'-Clients w/o CR'));
 
    string intitials;
   for (User u : [select id,name,firstname,lastname from user where id in: setCCid or id in: setCRid order by name]){
       intitials = (u.firstname).left(1) + u.lastname.left(1);
       if (setCCid.contains(u.id))
          ccItems.add(new SelectOption(u.Id,u.Name));
       if (setCRid.contains(u.id))
          crItems.add(new SelectOption(u.Id,u.Name));
       Mapstufftext.put(u.id,u.Name);
       MapStuffShort.put(u.id,intitials);}
    for (Contact cnt : lstContactsNoFilter){
      if (cnt.Court_Rep__c != null){
          map_CRIncontact.put(cnt.id, MapStuffShort.get(cnt.Court_Rep__c));
          map_CRIncontactText.put(cnt.id, MapStuffText.get(cnt.Court_Rep__c));}
       else{
         map_CRIncontact.put(cnt.id, '--');
        map_CRIncontactText.put(cnt.id,'no Court Representative');}
       if (cnt.Case_Coordinator__c != null){
          map_CCIncontact.put(cnt.id, MapStuffShort.get(cnt.Case_Coordinator__c));
          map_CCIncontactText.put(cnt.id, MapStuffText.get(cnt.Case_Coordinator__c)); }
       else{
         map_CCIncontact.put(cnt.id, '--');
         map_CCIncontactText.put(cnt.id,'no Case Coordinator');}}}
  
  public string clientOther{get;set;}
  public string otherButtonsAction{get;set;}
  public boolean displayPopup {get; set;}
  public pageReference closePopup() {displayPopup = false;
    selectedClient = '';
    requeryAction = true;
    return null;}
  public string otherAction{get;set;}
  public string assURL{get;set;}
  public string LegalURL{get;set;}
  public string outcomeURL{get;set;}
  public string stopURL{get;set;}  
  public boolean ass2complete{get;set;}
  public boolean newAssm{get;set;}
  public boolean assCompleted{get;set;}
  public boolean enableStopTracking{get;set;}
  public boolean enableOutcome{get;set;}
  public string srpRepURL{get;set;}
  public string progOther{get;set;}
  public string immedURL{get;set;}
  public boolean isActive{get;set;}
  public string courtId{get;set;}
  public boolean enableSRPreport{get;set;}
  
  public pageReference showPopup() {
   requeryAction = false;
    isActive = false;
    displayPopup = true;
    ass2complete = false;
    enableSRPreport = true;
    progOther = '';
    System.Debug('\n\n XXX selectedClient: ' + selectedClient);
    if (selectedClient != null && selectedClient != ''){
      Contact cnt = [select id,p_c_id__c,client_status__c,current_intake_date__c,
      accountId,intake_case__c,firstname,lastname,current_exit_date__c,name from Contact where 
      id =: selectedClient limit 1];    
      string prg = cnt.p_c_id__c;
      if (prg != null)
        progOther = prg.left(3);
      else   
        return null;
      enableStopTracking = false;
      string status = cnt.client_status__c.trim();
      if (status == 'Screened' && progOther == 'CEP')
         enableStopTracking = true;
      if (cnt.current_intake_date__c == null) 
        enableSRPreport = false;
     
      string accountId =cnt.accountId;
      string caseOther =cnt.intake_case__c;
      string f_name =cnt.firstname;
      string l_name =cnt.lastname;
      date dExit =cnt.current_exit_date__c;
      boolean lAssessm = false;
      boolean locked = false;
      id assmId;
      newAssm = true;
       assCompleted = false;
       for (AssessmentContainer__c ac : assmCR){   
        if (ac.client__c == selectedClient){ 
            assmId = ac.id;
            assCompleted = true;
            newAssm = false;
            break;}}   
      clientOther =cnt.name;
      assURL = '';
      legalURL = '';
      stopURL = '/apex/cepIntakeContainer?intakeCaseId='+caseOther+'&contactId='+selectedClient+'&accountId='+accountId+'&stage=StopTracking&portalName=All';  
       string assmcode;
      if (progOther == 'CEP'){
         if (assmId <> null)
           assURL = 'apex/AssessmentPage?contactPassed=' + selectedClient + '&assmFromContact=' + assmId;
         else{
            assessmentList__c lu = [Select assessmentName__c,name,pageName__c,programs__c
         From assessmentList__c where assessmentName__c = 'Court Rep' limit 1] ; 
         assmcode = lu.name;
     
         assURL = 'apex/AssessmentPage?contactPassed=' + selectedClient + '&newCodePassed=' + assmcode;
         } 
        immedURL = '/00U/e?what_id=' + caseOther
                +'&who_id=' + selectedClient + '&RecordType='
                + Utility_ID__c.getValues('Immediate Notification').RecordType_Id__c 
                + '&retURL=' + selectedClient + '&ent=Event'; 
        if (dExit == null)
           isActive = true;}
     else{
       if (progOther == 'CRT')
         LegalURL = '/apex/legalHistory?case=' + caseOther + '&contact=' + selectedClient;
       else{
         if (progOther == 'SRP'){
             outcomeUrl = '/apex/srpOutcomeScreen?contact=' + selectedClient + 
             '&caseId=' + caseOther +'&portalName=All';   
         assURL = '/00U/e?evt2_lkid='+selectedClient+'&evt2='+ clientOther+
              '&aid=023600000035X7y&anm=SRP+Pre-Trial&RecordType=012600000001GfD&retURL=/apex/allCourtsPage';
           srpRepURL = '/apex/srp_ComplianceTrackingPage?actionPassed='+courtId+'&clientPassed='+selectedClient;
     }}}}
    return null;}
}