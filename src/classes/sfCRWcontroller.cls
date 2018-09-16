public without sharing class sfCRWcontroller { 
   public String clientPassed   = System.currentPageReference().getParameters().get('selectedClient');    

//public boolean isSandbox{get;set;}
   public string lblAll{get;set;}
   public reportQuery rq = new reportQuery();
   public string selectedBoro{get;set;} 
   public string selectedCC{get;set;} 
   public string selectedCR{get;set;} 
   public boolean initialised{get;set;}
   public boolean displayPopup {get; set;}   
   public void closePopup(){
     displayPopup = false;
   }
   public List<unsolvedReports> unsolvedReports{get;set;}
    public void showPopup() {
       List<SF_CRW__c> lstUnsolved = [select id, CourtDate__c,ReportType__c,contact__c,document__c,clientname__c,pc_id__c from SF_CRW__c 
       where courtDate__c >=: date.Today() - 15 and courtDate__c <=: date.Today() - 1 and repStage__c !=: 'Final' 
       and Deleted_in_CRW__c =: false order by clientname__c ]; 
        List<unsolvedReports> lstUrep = new List<unsolvedReports>();
        unsolvedReports oneU = new unsolvedReports(); 
        if (lstUnsolved != null && lstUnsolved.Size() > 0){
          For (SF_CRW__c u : lstUnsolved){
             oneU = new unsolvedReports();
             oneU.cepid = u.pc_id__c ;
             oneU.cname = u.ClientName__c;
             oneU.ct_date = u.CourtDate__c.format();
             oneU.reptype = u.ReportType__c; 
             oneU.document = u.Document__c; 
             oneU.repid = u.id;     
               lstUrep.add(OneU);    
          }
           unsolvedReports = lstUrep;
        }
           
      displayPopup = true;
     }

   public string CClist{get;set;}
   List<SelectOption> CCfilter = new List<SelectOption>();
   public List<SelectOption> getCCfilter(){return CCfilter;}
 
   public string CRlist{get;set;}
   List<SelectOption> CRfilter = new List<SelectOption>();
   public List<SelectOption> getCRfilter(){return CRfilter;}


   public class unsolvedReports{
       public string cepid{get;set;}
       public string cname{get;set;}
       public string ct_date{get;set;}
       public string reptype{get;set;}
      public string document{get;set;}
       public string repid{get;set;}
   }
   
   public String getclientPassed(){
      return clientPassed;}
   public void setclientPassed(String clientPassed){
      this.clientPassed = clientPassed;}

  String advancedClients;
  public String getadvancedClients(){
      return advancedClients;}
   public void setadvancedClients(String advancedClients){
      this.advancedClients = advancedClients;}

       
public boolean sfAdmin{get;set;} 
public boolean doneSearch{get;set;}
public List<String> clientLeaf = new List<String>();
public List<Case_Information__c> allCases = new List<Case_Information__c>(); 

//public string advancedClients{get;set;}
public string gender{get;set;}
public string intakeBoro{get;set;}
public string dintake{get;set;}
public string indictment{get;set;}
public Set<ID> setClientsIds = new Set<ID>();
public string clientName{get;set;}
/////public string selectedClientId{get;set;}
public string CaseCoordinator{get;set;}
public string TeamLeader{get;set;}
public string docketId{get;set;}
public string docket_ind{get;set;}
public string courtName{get;set;}
public string dexit{get;set;}
public date exit_date{get;set;}
public date prev_rep_date{get;set;}
public date next_rep_date{get;set;}
public string exitprojected{get;set;}
public string courtrep{get;set;}
public string pc_id{get;set;}
public string exittype{get;set;}
public string exitreason{get;set;}
public boolean canSign{get;set;} 
public boolean CRWuser{get;set;}
public string reportpassed{get;set;} 
public Event proxyObject {get; set;}
 public sfCRWcontroller(){
   initialised=false;
 //  Event e = new Event(); 
  Event e = [select closing_date__c,catalog_end_date__c from Event limit 1];
  if (clientPassed != null && clientPassed != ''){
     if (clientPassed.length() == 15){
        string suffix = '';
        integer flags;
        for (integer i = 0; i < 3; i++) {
          flags = 0;
          for (integer j = 0; j < 5; j++) {
               string c = clientPassed.substring(i * 5 + j,i * 5 + j + 1);
               //Only add to flags if c is an uppercase letter:
               if (c.toUpperCase().equals(c) && c >= 'A' && c <= 'Z') {
                    flags = flags + (1 << j);
               }
          }
          if (flags <= 25) {
               suffix = suffix + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(flags,flags+1);
          }else{
               suffix = suffix + '012345'.substring(flags-25,flags-24);
          }
        }
     clientPassed = clientPassed +  suffix;
      ShowClientMainInfo(); 
     }
          
     }
   searchOption = 'CEP ID';
    ID userId = userInfo.getUserId();
    User u = [select Sign_court_Report__c from user where id =: userId];
      canSign = u.Sign_court_Report__c;
    Id userProfId = userInfo.getProfileId();
    Profile p = [Select name from Profile where id =: userProfId limit 1];
           if (p.Name == 'System Administrator')
               sfAdmin = true;  
           if (p.name == 'CEP - Court Report Writers 2')    
               CRWuser = true;
    lblAll = 'All';
  date datefrom, dateto;
  datefrom = date.today();
  DateTime dt;
  String dayOfWeek;
   for (integer i = 0; i < 12; i++){
     dt = DateTime.newInstance(datefrom, Time.newInstance(0, 0, 0, 0));
     dayOfWeek=dt.format('EEEE');
     if (dayOfWeek == 'Monday'){
        datefrom -= 3;
        break;}
     else
       datefrom -= 1;}   
     dateto = datefrom + 21;
   e.closing_date__c = datefrom;
   e.catalog_end_date__c = dateto;
   proxyObject = e; 
   mainnodes = generateTree();
   }

public class clientReportList{
       public string repDate{get;set;}
       public string actionId{get;set;}
       public string repStage{get;set;}
       public string approvalStatus{get;set;}
       public string RepType{get;set;}
       public string document{get;set;}
       public string assigned{get;set;} 
       public string advancedFrom{get;set;} 
       public string reportId{get;set;}}

 public class reportDates{
    public date courtDate{get;set;}
   public string actionId{get;set;}
   public string clientname{get;set;}
   public string document{get;set;}
   public string reportid{get;set;}}
  
    public class reportInfo{
       public string clientid{get;set;}
       public date repDate{get;set;}
       public string clientName{get;set;}
       public string actionId{get;set;}
       public string repStage{get;set;}
       public boolean lCreate{get;set;}
       public string repColor{get;set;}
       public string approvalStatus{get;set;}
       public string assigned{get;set;}
       
       public string intakeBoro{get;set;}
  //     public string CC{get;set;}
       public string intakeBoroName{get;set;}
       public string documentName{get;set;}
       public string fontStyle {get;set;}     
       public string advancedfrom {get;set;}     
       public string cepid{get;set;}
       public string reportid{get;set;}
       public string reptype{get;set;}}
   //------------------------------
  /* Wrapper class to contain the nodes and their children */
     
    public class cNodes{
    public reportDates d {get; set;} 
    public List<reportInfo> r {get;set;}
    public cNodes(reportDates d1,  List<reportInfo> r1){
       d = d1;
       r = r1;}}
 
 public List<cNodes> mainnodes{get;set;}
 public List<cNodes> hierarchy;
        
  public List<cNodes> generateTree(){
      CCfilter = new List<SelectOption>();
      CCfilter.add(new SelectOption('All', 'All'));
 
      CRfilter = new List<SelectOption>();
      CRfilter.add(new SelectOption('All', 'All'));
 
    //  CCfilter = CC;
      doneSearch = false;
     hierarchy = new List<cnodes>();            
     List<reportInfo> lstReports4day = new List<reportInfo>();
     reportInfo ri_1 = new reportInfo();
     List<reportDates> lstReportDates = new List<reportDates>();
     reportDates ReportDate = new reportDates();
     string clientId,clientname,document; 
      date ctdate; 
   List<SF_CRW__c> lstReportFilter = new List<SF_CRW__c>(); 
   integer dbetween; 
   Set<Id> setRepIds = new Set<Id>();
   Set<Id> setRepIdsforNotes = new Set<Id>();
   Set<String> setClientsIds = new Set<String>();
   
  boolean del;
  date datefrom = proxyObject.closing_date__c;
  date dateto = proxyObject.catalog_end_date__c;
    String strQuery = 'select id, CourtDate__c,ReportType__c,contact__c,advancedfrom__c, approval_Status__c, '  + 
       'repStage__c,PC_Id__c,actionid__c, clientname__c,document__c,Deleted_in_CRW__c, AssignTo__c, ' + 
       'intk_boro__c, case_coordinator__c, court_rep__c from SF_CRW__c ' + 
         ' where courtdate__c >=: dateFrom and courtdate__c <=: dateTo and Deleted_in_CRW__c =: del ';

 // lstReportFilter = Database.Query(strQuery); 
 
//  return null;


        string clientsCC = '';    
    string clientsCR = '';    
    List<SF_CRW__c> allReports = [select id, CourtDate__c,ReportType__c,contact__c,advancedfrom__c,
    repStage__c,PC_Id__c,actionid__c, clientname__c,document__c,Deleted_in_CRW__c,intk_boro__c,AssignTo__c,
    case_coordinator__c, court_rep__c from SF_CRW__c
        where courtdate__c >=: proxyObject.closing_date__c
           and courtdate__c <=: proxyObject.catalog_end_date__c
           and Deleted_in_CRW__c =: false order by CourtDate__c,clientname__c];
       for (SF_CRW__c f : allReports){
            if (f.case_coordinator__c != null){
            if (clientsCC.contains(f.case_coordinator__c) == false)
                   CCfilter.add(new SelectOption
                   (f.case_coordinator__c,f.case_coordinator__c));
               clientsCC += f.case_coordinator__c;}
               if (f.court_rep__c != null){
             if (clientsCR.contains(f.court_rep__c) == false)
                CRfilter.add(new SelectOption
                   (f.court_rep__c,f.court_rep__c));
               clientsCR += f.court_rep__c;}
       }      
       string strBoro,strCC, strCR;    
      if (selectedBoro != null && selectedBoro != 'All')
          strQuery += ' and Intk_Boro__c =: selectedBoro';
      if (selectedCC != 'All' && selectedCC != null)
          strQuery += ' and case_coordinator__c =: selectedCC ';
      if (selectedCR != 'All' && selectedCR != null)
          strQuery += ' and court_rep__c =: selectedCR ';
    
    strQuery += ' order by CourtDate__c,clientname__c'   ;   
    lstReportFilter = Database.Query(strQuery); 
    
    if (lstReportFilter.Size() == 0)
        return null;     
           //  CC.CCfilter options = new List<SelectOption>();
   for (SF_CRW__c s : lstReportFilter){
      ReportDate = new reportDates();
      ReportDate.actionid = s.actionid__c;
      ReportDate.courtDate = s.courtdate__c;
      ReportDate.reportid = s.id; 
      ReportDate.clientname = s.ClientName__c;
      ReportDate.document = s.Document__c; 
      if (s.courtdate__c != ctdate){
          lstReportDates.add(ReportDate);
          setClientsIds.add(s.contact__c);
          setRepIds.add(s.id); 
          }
       ctdate = s.courtdate__c;
       setRepIdsforNotes.add(s.id);
     }
     
     advancedClients = '';
     for (integer i = 0; i < lstReportDates.Size(); i++){ 
          lstReports4day = new List<reportInfo>(); 
          ctdate = lstReportDates[i].courtDate;
          for (integer a = 0; a < lstReportFilter.Size(); a++){

              ri_1 = new reportInfo();
             if (lstReportFilter[a].CourtDate__c ==  ctdate){
                setClientsIds.add(lstReportFilter[a].contact__c);
                 ri_1 = new reportInfo();
                 ri_1.clientName = lstReportFilter[a].ClientName__c.trim();
                 ri_1.clientid = lstReportFilter[a].contact__c;
                 if (lstReportFilter[a].PC_Id__c != null)
                    ri_1.cepid = (lstReportFilter[a].PC_Id__c).mid(4,6).trim();
                 ri_1.repDate = lstReportFilter[a].CourtDate__c;
                 ri_1.actionid = lstReportFilter[a].actionid__c;
                 ri_1.reportid = lstReportFilter[a].id;
                ri_1.reptype =  (lstReportFilter[a].ReportType__c).left(1) + (lstReportFilter[a].document__c).left(1) ;

                 if ( lstReportFilter[a].document__c.trim() == 'Report')
                      ri_1.fontstyle= 'regular';
                 else 
                       ri_1.fontstyle = 'italic';
               ri_1.documentName = lstReportFilter[a].ReportType__c + ' ' + lstReportFilter[a].document__c;
               ri_1.advancedFrom = lstReportFilter[a].advancedfrom__c;
               ri_1.intakeBoroName = lstReportFilter[a].intk_boro__c;
               if (lstReportFilter[a].intk_boro__c != null){
                  if (lstReportFilter[a].intk_boro__c  == 'Bronx') 
                     ri_1.intakeBoro = lstReportFilter[a].intk_boro__c.right(1).toupperCase();
                  else
                  ri_1.intakeBoro = lstReportFilter[a].intk_boro__c.left(1);
               }   
                ri_1.repcolor = 'green';
                ri_1.repStage = (lstReportFilter[a].repStage__c); 
                if (lstReportFilter[a].approval_status__c != null){
                  if (lstReportFilter[a].approval_status__c.contains('-'))  
                      ri_1.approvalstatus = lstReportFilter[a].approval_status__c.left(5);
                  else 
                      ri_1.approvalstatus = lstReportFilter[a].approval_status__c.left(2);
                }  
                 ri_1.assigned = lstReportFilter[a].AssignTo__c;
                 dbetween = date.today().daysBetween(lstReportFilter[a].CourtDate__c);       
                 if (lstReportFilter[a].repStage__c == 'to Do'){
                    ri_1.lCreate = true;   }
                 
                   if (dbetween >= 1 && dbetween <= 5 &&  lstReportFilter[a].repStage__c != 'Final')
                       ri_1.repcolor = 'yellow'; 
                    if (dbetween <= 1 && lstReportFilter[a].repStage__c != 'Final'){
                       ri_1.repcolor = 'red';
                 }
             
             if (lstReportFilter[a].CourtDate__c >= proxyObject.closing_date__c
                 && lstReportFilter[a].CourtDate__c <= proxyObject.catalog_end_date__c){       
                 if (lstReportFilter[a].advancedfrom__c != '' && lstReportFilter[a].advancedfrom__c != null )   {   
                     if (advancedClients == '')
                        advancedClients = lstReportFilter[a].clientName__c + ' advanced ' + lstReportFilter[a].advancedfrom__c;
                     else{
                       if (advancedClients.contains(lstReportFilter[a].clientName__c) == false){
                        advancedClients += ';  ' + lstReportFilter[a].clientName__c + ' advanced ' + lstReportFilter[a].advancedfrom__c;
                     }}}}     
          lstReports4day.add(ri_1);}}
         hierarchy.add(new cnodes(lstReportDates[i],lstReports4day)); 
     }
        doneSearch = true;
     //   mainnodesNotes = generateTreeNotes(setRepIds);
         mainnodesNotes = generateTreeNotes(setRepIdsforNotes);
      return hierarchy;}
   
    public pageReference RequeryInfo(){
        PageReference pg = insertCRW();
        mainnodes = generateTree();
        showreports = false;
        displayPopUp = false;
        return pg;}
   public List<clientReportList> ClientRepsToShow {get;set;}
   public boolean showReports{get;set;}    
   ///////////////////
   ////     Client Info
   public void ShowClientMainInfo(){
       List<clientReportList> lstClientReps = new List<clientReportList>();
       if (clientpassed == null)
          return;
      Set<Id> setRepIds = new Set<Id>();
      Map<Id, SF_CRW__c> mapCRWInfoClient = new Map<Id, SF_CRW__c>
     ([select id, CourtDate__c,ReportType__c,contact__c,repStage__c,PC_Id__c,actionid__c,
       clientname__c,document__c,Deleted_in_CRW__c from SF_CRW__c where contact__c =:clientpassed
           and Deleted_in_CRW__c =: false]);
       showReports = false;
       clientReportList oneRep = new clientReportList();
       Id clientId, cmid,caserectypeid,cr,tleader;
       Map<Id, Contact> mapContact = rq.contactQueryByStringId(clientpassed);          
       docketId = mapcontact.get(clientpassed).intake_case__c;
       clientName = mapcontact.get(clientpassed).firstname + ' '  + mapcontact.get(clientpassed).lastname;
       gender = mapcontact.get(clientpassed).Gender_CC__c;
       Map<Id, Case_Information__c> mapCase = rq.caseQuery(docketId);   
       docket_ind = mapCase.get(docketId).name;
       if (mapCase.get(docketId).indictment__c != null)
           docket_ind = mapCase.get(docketId).name+ '/'  +  mapCase.get(docketId).indictment__c; 
       caserectypeid = mapCase.get(docketId).recordtypeid;
       pc_id = mapcontact.get(clientpassed).P_C_ID__c;
       cmid = mapcontact.get(clientpassed).case_coordinator__c;
       tleader = mapcontact.get(clientpassed).Team_Leader__c;
       CaseCoordinator = rq.userNamesById(cmid); 
       teamLeader = rq.userNamesById(tleader); 
       cr = mapcontact.get(clientpassed).Court_Rep__c;
       courtrep =  rq.userNamesById(cr);
       dintake = mapcontact.get(clientpassed).Current_Intake_Date__c.format();
       courtname =  mapcontact.get(clientpassed).Intake_Court_Formula__c ; 
       intakeboro = mapcontact.get(clientpassed).Borough_of_Intake_Formula__c;
       next_rep_date = mapcontact.get(clientpassed).Next_Court_Date__c;
       dexit = '__/__/____';
       if (mapcontact.get(clientpassed).Current_Exit_Date__c <> null){
          dexit = mapcontact.get(clientpassed).Current_Exit_Date__c.format();
          exit_date = mapcontact.get(clientpassed).Current_Exit_Date__c;          
       }   
       exitprojected = '__/__/____';
       if (mapcontact.get(clientpassed).Current_Projected_Exit_Date__c <> null)
          exitprojected = mapcontact.get(clientpassed).Current_Projected_Exit_Date__c.format();
        exittype = mapcontact.get(clientpassed).Current_Exit_Type__c;
        exitreason = mapcontact.get(clientpassed).Exit_Reason__c;
        if (ClientRepsToShow != null)
           ClientRepsToShow.clear();
     advancedClients = '';    
     List<SF_CRW__c> lstCRW = [Select repStage__c,actionid__c,courtdate__c,reporttype__c,id,document__c,clientName__c,
        assignTo__c,advancedFrom__c from SF_CRW__c where contact__c =: clientpassed 
        and Deleted_in_CRW__c =: false order by courtdate__c desc];
        for (SF_CRW__c s : lstCRW){ 
            oneRep = new clientReportList();
            oneRep.repDate = s.courtdate__c.format();
            oneRep.repType = s.ReportType__c;
            oneRep.repStage = s.repStage__c;
            oneRep.actionid = s.actionid__c;
            oneRep.reportid = s.id;
            oneRep.assigned = s.assignTo__c;
            oneRep.document = s.document__c;
            oneRep.advancedFrom = s.advancedfrom__c;
            lstClientReps.add(oneRep);
            setRepIds.add(s.id);}
       showReports = true;
       ClientRepsToShow = lstClientReps;
       ClientNotesToShow = findNotes(lstCRW,mapCRWInfoClient,setRepIds);}
  
    public pagereference doNothing(){
        return null;}
///////////////////
///////////////////   INSERT from Events and Admin. Actions
 
    public  pagereference insertCRW(){
     string cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
     string exitAction = Utility_ID__c.getValues('Exit Notification - Locked').RecordType_Id__c;
      Set<ID> setClientsIds  = new Set<ID>(); 
     Set<ID> setClientsDischargedIds  = new Set<ID>(); 
      Set<String> setClientsIdsInEvent = new Set<String>(); 
      Set<String> setClientsIdsInAction = new Set<String>(); 
      Set<String> setCepClientsIds = new Set<String>(); 
      Set<ID> setEvtId_inSF = new Set<ID>();
      Set<ID> setActionId_inCRW = new Set<ID>();            
      Set<ID> setActionId_inSF = new Set<ID>();    
      MAP<String,Id> mapCRW = new MAP<String,Id>();
      MAP<Id,String> mapCRWstage = new MAP<id,String>();
      MAP<String,date> mapCRWdates = new MAP<String,date>();
      MAP<String,String> mapActionCourtDates_inEvents = new MAP<String,String>();
      MAP<String,String> mapActionCourtDates_inCRW = new MAP<String,String>();
      Map<String,date> mapIdExitDates = new Map<String,date>();
//      string actionId;
 
      List<Administrative_Actions__c> lstActions = 
       [Select id,RecordTypeId, client__r.recordtypeid,Exit_Type__c,client__r.p_c_id__c,
          Exit_Reason__c, action_date__c, Client__c,RecordType.Name  
          From Administrative_Actions__c where 
          action_date__c >=: proxyObject.closing_date__c - 14
          and action_date__c <=: proxyObject.catalog_end_date__c
          and recordtypeid =: exitAction and client__r.recordtypeid =: cepClient];

      for (Administrative_Actions__c a : lstActions){ 
         setActionId_inSF.add(a.id);
        if (setClientsIds.contains(a.client__c) == false )
            setClientsIdsInAction.add(a.client__c); 
            setCepClientsIds.add(a.client__c);
            mapIdExitDates.put(a.client__c, a.action_date__c);}       
         
      List<Event> ctCEPdates = new List<Event>();
      List<Event> lstEvents = [select id,whoid,activitydate,report_type__c,Court_Report_Required__c, P_C_ID__c,who.name 
         from event where Subject = : 'Court Date' and ActivityDate >=: proxyObject.closing_date__c
              and ActivityDate <=: proxyObject.catalog_end_date__c and Report_Type__c =: 'Progress'  order by activitydate];
       for (Event e  : lstEvents){    
         if ((e.p_c_id__c).substring(0,3) == 'CEP')   {                     
          setActionId_inSF.add(e.id);
          setClientsIdsInEvent.add(e.whoid);
       if (setCepClientsIds.contains(e.whoid) == false)
            setCepClientsIds.add(e.whoid);
         ctCEPdates.add(e) ;    
         mapActionCourtDates_inEvents.put(e.id,e.activitydate.format());}}
    
     List<SF_CRW__c> lstCRWnew = new List<SF_CRW__c>();
     List<SF_CRW__c> lstCRWnewAction = new List<SF_CRW__c>();
     List<SF_CRW__c> lstCRWupdate = new List<SF_CRW__c>();
     SF_CRW__c oneCRWRecord = new SF_CRW__c();
     SF_CRW__c oneCRWRecordUpdate = new SF_CRW__c();
     Map<id,string> mapNames = new Map<id,string>(); 
     Map<Id, Contact> mapContactInfo = new Map<Id, Contact>
     ([select id, name,P_C_ID__c,accountId,Borough_of_Intake_Formula__c
       from Contact where id in: setCepClientsIds and recordtypeid =: cepClient]);

     List<SF_CRW__c> lstReps = [select id, CourtDate__c,ReportType__c,contact__c,repStage__c,
       actionId__c, document__c from SF_CRW__c 
       where actionid__c in: setActionId_inSF order by CourtDate__c];
      for (SF_CRW__c reps : lstReps){
           setActionId_inCRW.add(reps.actionid__c);            
           mapCRW.put(reps.actionid__c,reps.id);
           mapCRWstage.put(reps.actionid__c,reps.repStage__c);
           mapCRWdates.put(reps.actionid__c,reps.CourtDate__c);}
 
      string exittype;
      for (integer a = 0; a < lstActions.Size();a++){
        oneCRWRecord = new SF_CRW__c();
  //    oneCRWRecord.Client__c = lstActions[a].client__c;
        oneCRWRecord.Contact__c = lstActions[a].client__c;
        oneCRWRecord.Document__c = 'Letter';
        oneCRWRecord.actionid__c = lstActions[a].id;
        oneCRWRecord.CourtDate__c = date.today();
        exittype = lstActions[a].Exit_Type__c; 
        oneCRWRecord.repStage__c = 'to Do';
        if (exittype.substring(0,2) == '(S'){
           oneCRWRecord.ReportType__c = 'Graduation';
           oneCRWRecord.CourtDate__c = lstActions[a].Action_Date__c + 1;
        }  
        else{
          if (exittype.substring(0,2) == '(T')
               oneCRWRecord.ReportType__c = 'Transfer'; 
            else
                oneCRWRecord.ReportType__c = 'Discharge';
            }
        oneCRWRecord.PC_Id__c = mapContactInfo.get(lstActions[a].client__c).P_C_ID__c;             
        oneCRWRecord.ClientName__c = mapContactInfo.get(lstActions[a].client__c).name;   
        oneCRWRecord.account__c = mapContactInfo.get(lstActions[a].client__c).accountid;   
        if (setActionId_inCRW.contains(lstActions[a].id) == false) {
          lstCRWnew.add(oneCRWRecord);
          lstCRWnewAction.add(oneCRWRecord);
        }}
     System.Debug('\n\n XXX lstCRWnew ' + lstCRWnew); 
     string cname,ctdateInCRW,repid;
     date dt;
     boolean updateCRW;   
     Set<String> setIdToUpdate = new Set<String>();
      for (integer k = 0; k < ctCEPdates.Size(); k++){
          oneCRWRecord = new SF_CRW__c();
          oneCRWRecord.program__c = 'CEP';
          oneCRWRecord.Narrative__c = '**';
  //       oneCRWRecord.Client__c = ctCEPdates[k].whoid;
          oneCRWRecord.Contact__c = ctCEPdates[k].whoid;
          oneCRWRecord.CourtDate__c = ctCEPdates[k].activitydate;
          oneCRWRecord.ReportType__c = ctCEPdates[k].report_type__c;
          oneCRWRecord.actionid__c = ctCEPdates[k].id;
          oneCRWRecord.ClientName__c = ctCEPdates[k].who.name;
          oneCRWRecord.PC_Id__c = mapContactInfo.get(ctCEPdates[k].whoid).P_C_ID__c;             
          oneCRWRecord.account__c = mapContactInfo.get(ctCEPdates[k].whoid).accountid; 
          oneCRWRecord.Document__c = 'Report';
          dt = mapCRWdates.get(ctCEPdates[k].id);
          if (setActionId_inCRW.contains(ctCEPdates[k].id) == false){
              oneCRWRecord.repStage__c = 'to Do';
             lstCRWnew.add(oneCRWRecord);}
          else{ 
            repid = MapCRW.get(ctCEPdates[k].id);
            oneCRWRecord = new SF_CRW__c(id=repid);
            updateCRW = false;
             if (oneCRWRecordUpdate.deleted_in_CRW__c == true){
               oneCRWRecord.deleted_in_CRW__c = false;
               updateCRW = true;}
             else{
              if (dt != ctCEPdates[k].ActivityDate ){
                updateCRW = true;
               oneCRWRecord.CourtDate__c = ctCEPdates[k].ActivityDate;
             if (dt > ctCEPdates[k].ActivityDate)
                 oneCRWRecord.advancedFrom__c = 'from ' + dt.format();  
                lstCRWUpdate.add(oneCRWRecord);
                updateCRW = true;
             }}
             if (updateCRW == true)
                  lstCRWnew.add(oneCRWRecord);
                  setIdToUpdate.add(repid);
       }}
     if (lstCRWnew.Size() <> 0)     
        upsert lstCRWnew;
        
     string clientid;
     List<SF_CRW__c> lstCRW_4_exits =
     [Select contact__c,courtdate__c,reporttype__c,id,document__c,
        Deleted_in_CRW__c from SF_CRW__c where 
       contact__c in: setClientsIds order by contact__c,courtDate__c];
     date exit_dt;  
     List<SF_CRW__c> lst2delete = new List<SF_CRW__c>(); 
     integer p = 0;
     integer p1 = 0;
     boolean repchanged;
     for (integer a = p; a < lstCRW_4_exits.Size(); a++){
        clientid = lstCRW_4_exits[a].contact__c;
         exit_dt = mapIdExitDates.get(clientid);
         p1 = 0;
         repchanged = false;
         for (integer k = p; k < lstCRW_4_exits.Size(); k++){
           if (lstCRW_4_exits[k].courtDate__c > exit_dt && lstCRW_4_exits[k].document__c == 'Report'){
             if (exit_dt.daysBetween(lstCRW_4_exits[k].courtDate__c) <= 8 && repchanged == false){
                lstCRW_4_exits[k].reporttype__c = 'Graduation';
                repchanged = true;}
             else{    
               lstCRW_4_exits[k].Deleted_in_CRW__c = true;
               }
             lst2delete.add(lstCRW_4_exits[k]);
             p1++;}
           else
              break;}
                p+=p1+1;}
      
      update lst2delete;
  //    mainnodes = generateTree();
 //     initialised = true;
      return null;}
      
 ////////////   Create Report/Letter
    public void createReportNarrative(){
        SF_CRW__c c = [Select repStage__c,id, courtdate__c, Document__c,contact__c,
        narrative__c, actionid__c, assignTo__c,Deleted_in_CRW__c from SF_CRW__c where id =: reportpassed];
        c.repStage__c = 'Drafting';
        c.assignTo__c = userInfo.getFirstName();
        if (c.document__c == 'Report')
           c.narrative__c = 'System Generated';
        else {
           datetime dtime;  
           string exit_type = exittype.substring(0,1);
           //////   Letters          
           string pgrph_1,pgrph_2,pgrph_3,salut,add,s,sdate,sdate1;
           pgrph_2 = '';
           pgrph_3 = '';
           if (gender.substring(0,1) == 'M'){
               salut = 'Mr.' + ClientName;
               add = 'His ';}
           else{
              salut = 'Ms.' + ClientName;
              add = 'Her ';}   
           if (exit_type == 'T'){
              pgrph_1 = 'We have transferred ' +  salut  +  ' from our program to .. on .. ';   
           }
           else{
             if (exit_type == 'S'){
             sdate = dexit;
              pgrph_1 =  salut + ' successfully completed our program on ' + sdate + '.' ;  
              pgrph_2 = '';
              if ((prev_rep_date == null && next_rep_date == null) 
                 || next_rep_date.daysBetween(exit_date) > 8){
                 pgrph_3 = 'You will receive a Graduation Report detailing ' + salut + '\'s ' + 
                  'experience in our program within 8 consecutive days.';}
              else{       
                  if (prev_rep_date <> null && prev_rep_date.daysBetween(exit_date) <= 14 ){
                    sdate = prev_rep_date.format();
                     pgrph_3 = 'A report detailing ' + salut + '\'s ' + 
                     'experience in our program was submitted to the Court on his last court date of ' + sdate + '.';}
                 else{
                    if (next_rep_date.daysBetween(exit_date) <= 8 ){
                       sdate = next_rep_date.format();                    
                      pgrph_3 = 'You will receive a Graduation Report detailing ' + salut + '\'s ' + 
                       'experience in our program on the next Court Date, ' + sdate + '.';
                    }}}             
           }
           else{
               string lastctdate = '';
              string nextctdate = ''; 
               if (prev_rep_date <> null){
                 sdate = prev_rep_date.format();
                  lastctdate = add + 'last court date was ' + sdate + '.';}   
               if (next_rep_date <> null){
             sdate = next_rep_date.format();
                  nextctdate = add + 'next scheduled court appearance is ' + sdate + '.';   
                }
              pgrph_1 = salut + ' has been discharged from our program due to failure to comply with our program requirements.';  
           sdate = dexit;
              pgrph_2 = 'The effective date of '+ salut + 
              ' discharge is ' + sdate + '. ' + 
              lastctdate + ' ' + nextctdate;
              pgrph_3 = '';}}      
           c.narrative__c =  pgrph_1 + '\n' + pgrph_2 + '\n' + pgrph_3 + '\n' + '\n' + 'System Generated';  
        }    
       update c;          
       mainnodes = generateTree();
       ShowClientMainInfo();}

       public string listUsers{get;set;}
       public List<SelectOption> getCRWUsers(){
          Set<String> crwUsers = new Set<String>(); 
         Id userProfId = userInfo.getProfileId();
         List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('', ''));
         for (User u : [Select Id,name from User Where isActive = true and 
           Profile.Name =: 'CEP - Court Report Writers 2']){
           options.add(new SelectOption(u.name, u.name));}
       return options;}

      public string userpassed{get;set;}
      public string reportid{get;set;}
  
      public void saveAssign(){
        SF_CRW__c s = [select assignto__c from SF_CRW__c where id =: reportid];
       s.assignto__c = userpassed;   
              update s;}

    public string searchOption{get;set;}
    public list<SelectOption> getSearchItems(){
      list<SelectOption> options = new list<SelectOption>();
      options.add(new SelectOption('CEP ID', 'CEP ID'));
      options.add(new SelectOption('Full name', 'Full name'));
      options.add(new SelectOption('SalesForce ID', 'SalesForce ID'));
       return options;}
     
  public string clientSearch{get;set;}
      public void searchclient(){  
        displayPopUp = false;        
       clientPassed = '';
    //   searchOption = 'SalesForce ID';
       if (clientSearch == null || clientSearch == '')
          return ;    
        List<Contact> lstContact = new  List<Contact>();
       String strQuery = 'SELECT Id from contact where ';
       String strCriteria = '';
   //    if (searchOption == 'SalesForce ID'){   
   //         clientPassed = clientSearch;
   //         strCriteria = 'id =: clientSearch';}
    //    else{
     //      if (searchOption == 'CEP ID'){
             string pcid = 'CEP_' + clientSearch;
             strCriteria =  'p_c_id__c =: pcid';
             //}
    //    else
    //      strCriteria =  'name =: clientSearch';}   
         strQuery += strCriteria;
        lstContact = Database.Query(strQuery);
        if (lstContact.Size() <> 0){
           clientPassed = lstContact[0].id;
           ShowClientMainInfo();}           
      else
          clientPassed = '';
        return ;}
    public string getMessage(){   
     string textMessage = '';
     integer validation = checkDateInput();
     if (validation == 1)
        textMessage =  ' Date From can not be before Date To.'; 
     if (validation == 2)
        textMessage =   ' Date range can not be more than 30 days.';
   return textMessage;}
      public integer checkDateInput(){
      integer k = 0;
      date dtFrom = proxyObject.closing_date__c;
      date dtTo = proxyObject.catalog_end_date__c;
      Integer noOfDays = dtFrom.daysBetween(dtTo);
      if (dtFrom > dtTo)
         k = 1;
       if (noOfDays > 200)  
            k = 2;
     return k;}
   
     public class  notesList{
     public string ReportId{get;set;}
     public string NoteId{get;set;}
     public string Question{get;set;}
     public string Respond{get;set;}
     public string sentTo{get;set;}
     public string status{get;set;}
     public string repdate{get;set;}
     public string respondColor{get;set;}}

    public List<notesList> ClientNotesToShow{get;set;}
   
   public List<notesList> findNotes(List<SF_CRW__c> lstCRW,Map<Id, SF_CRW__c> mapCRWInfoClient,set<ID> setRepIds) {
     notesList oneRecord = new notesList();
     List<notesList> repnotes  = new List<notesList>();
     List<SF_CRW_notes__c> lstCRWnotes = [select id, luReports__c, Question__c, Respond__c,status__c
           from SF_CRW_notes__c where luReports__c in: setRepIds and status__c !=: 'Closed' order by sortorder1__c];
      string repid;
      for (integer i = 0; i < lstCRW.Size(); i++){
         repid = lstCRW[i].id;
        for (integer n = 0; n < lstCRWnotes.Size(); n++){
             oneRecord = new notesList();
           if (lstCRWnotes[n].luReports__c == repid){
              oneRecord.Question = lstCRWnotes[n].question__c;
              oneRecord.status = lstCRWnotes[n].status__c;
              oneRecord.Respond = lstCRWnotes[n].Respond__c;
              if (lstCRWnotes[n].Respond__c == '' || lstCRWnotes[n].Respond__c == null)
                 oneRecord.respondColor = 'red';
              else      
                 oneRecord.respondColor = 'white';
              oneRecord.NoteId = lstCRWnotes[n].id;
             repnotes.add(oneRecord);}}
      }        
     return repnotes;}
  
   public class notesHeader{
     public string ctdate{get;set;}
     public string cname{get;set;}
     public string header{get;set;}
     public string notedate{get;set;}
     public string repid{get;set;}
     public string commstatus{get;set;}
     public string commcolor{get;set;}
     public string commentsby{get;set;}
   }
     public class  notesInfo{
     public string Question{get;set;}
     public string Respond{get;set;}
     public string status{get;set;}
     public string respondColor{get;set;}
     public string reportid{get;set;}  }
   
    public class cNodesNotes{
    public notesHeader d {get; set;}
    public List<notesInfo> r {get;set;}
    public cNodesNotes(notesHeader d1,  List<notesInfo> r1){
       d = d1;
       r = r1;}}
 
 public List<cNodesNotes> mainnodesNotes{get;set;}
 public List<cNodesNotes> hierarchyNotes;
 
 public List<cNodesnotes> generateTreeNotes(Set<Id> setRepIds){
    hierarchynotes = new List<cnodesNotes>();
    List<notesInfo> lstnotes4client = new List<notesInfo>();
     notesInfo ri_1 = new notesInfo();
     List<notesHeader> lstnotesHeader = new List<notesHeader>();
     notesHeader header1 = new  notesHeader();
     Set<String> setIdsInNotes = new Set<string>();
     List<SF_CRW_notes__c> lstNotesSelected = [select id,  Question__c,Status_Set_by__c,
      Respond__c,status__c,lureports__c from SF_CRW_notes__c 
      where LUREPORTS__C in: setRepIds and status__c != 'Closed' order by lureports__c,sortorder1__c];
       for (integer s = 0; s < lstNotesSelected.Size();s++ ){
            setIdsInNotes.add(lstNotesSelected[s].LUREPORTS__C);}   
       List<SF_CRW__c> lstReps = [Select clientname__c, courtdate__c,id from SF_CRW__c 
       where id in: setIdsInNotes order by courtdate__c,clientname__c];
      //where id in: setIdsInNotes order by clientname__c];
     if (lstNotesSelected.size() != 0){
    date repdate;
    string h1,h2,repid;
    h2 = '';
    string d,c;
    for (integer i = 0; i < lstReps.Size(); i++){
        header1 = new  notesHeader();
         header1.cname = lstReps[i].clientname__c;
         header1.notedate = lstReps[i].courtdate__c.format();
         header1.repid = lstReps[i].id;
         lstnotesHeader.add(header1);}
      for (integer i = 0; i < lstReps.Size(); i++){ 
        lstnotes4client = new List<notesInfo>();
        repid = lstReps[i].id;
        string s;
        boolean notCheck = false;
      for (integer a = 0; a < lstNotesSelected.Size(); a++){
         if (lstNotesSelected[a].LUREPORTS__C == repid){
            if (notCheck == false){
               lstnotesHeader[i].commstatus = lstNotesSelected[a].Status__c;   
              lstnotesHeader[i].commcolor = 'red';   
               lstnotesHeader[i].commentsby = lstNotesSelected[a].Status_Set_by__c;}
            ri_1 = new notesInfo();
            ri_1.Question = lstNotesSelected[a].Question__c;
           if (lstNotesSelected[a].Respond__c != null  && lstNotesSelected[a].Respond__c != '')
             ri_1.Respond = lstNotesSelected[a].Respond__c;
           if (lstnotesHeader[i].commstatus == 'Approved' || lstnotesHeader[i].commstatus == 'Response' ){
                 notCheck = true;
                   lstnotesHeader[i].commentsby = lstNotesSelected[a].Status_Set_by__c;
              if (lstnotesHeader[i].commstatus == 'Approved')
                 lstnotesHeader[i].commcolor = 'green';
              else   
                 lstnotesHeader[i].commcolor = '#D2691E';              
           }   
           ri_1.reportid = lstNotesSelected[a].luReports__c;
           ri_1.status = lstNotesSelected[a].Status__c;
             lstnotes4client.add(ri_1);}
         if (lstNotesSelected[a].LUREPORTS__C != repid)
            notcheck = false;}
             hierarchyNotes.add(new cnodesNotes(lstnotesHeader[i],lstnotes4client));}} 
    return hierarchyNotes;}
    
   public List<SelectOption> getBoro() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('All', 'All'));
      options.add(new SelectOption('Brooklyn', 'Brooklyn'));
    options.add(new SelectOption('Manhattan', 'Manhattan'));
    options.add(new SelectOption('Bronx', 'Bronx'));
      options.add(new SelectOption('Queens', 'Queens'));
      return options;}  
     
  string BoroList{get;set;}
  public String getBoroList(){
       return BoroList;}
  public void setBoroList(String BoroList){
      this.BoroList = BoroList;}
      
          public pageReference pageClose(){
          Pagereference pg = new PageReference('/home/home.jsp');
          return pg;}
          
   public void showUnsolved(){
     
   }       
 
 }