public with sharing class srp_NotificationController{ 
  public string namePassed{get;set;}
  string srpClient = Utility_ID__c.getValues('SRP Client').RecordType_Id__c;
  public boolean sfAdmin{get;set;} 
  public date currentDate{get;set;}
  List<Contact> lstContactsNoFilter;
  Set<String> id_Exited = new Set<String>();
     Set<String> str_noIntakeDate = new Set<String>();
// CASE Coordinator
   public string docValue{get;set;}
   public string ccValue{get;set;}
   public List<SelectOption> ccItems{get;set;}
   Map<id,string> MapStuffShort = new Map<id,string>();
   Map<string,string> map_CCIncontact = new Map<string,string>(); 
   Map<string,string> map_contId_CCID_Incontact = new Map<string,string>(); 
   Map<string,string> map_CCIncontactText = new Map<string,string>(); 
   Set<String> setCCid = new Set<String>();
   string pcid;
   Map<id,string> Mapstufftext = new Map<id,string>(); 
   Id userLoginStaffId{get;set;}    
    string ccid;
 Set<string> setSRPid = new Set<string>();   
   Set<string> setCCfilter = new Set<string>();
   Map<string,string> mapclientIntakeCase =  new Map<string,string>(); 
   Map<string,string> mapClientName = new Map<string,string>();
 
  List<Delinquency_Tracking__c> fixFTA = new  List<Delinquency_Tracking__c>();   
  public List<SelectOption> getDocumentItems() {
    List<SelectOption> options = new List<SelectOption>();    
    options.add(new SelectOption('All', 'All'));
    options.add(new SelectOption('Letter', 'Compliance Letter'));
    options.add(new SelectOption('Report', 'Report'));
    options.add(new SelectOption('Rearrest', 'Rearrest Letter'));
    options.add(new SelectOption('FTA', 'FTA'));
    return options;}
 
  public class deliqtrk{
  public string clientName{get;set;}
    public string clientId{get;set;}
    public string courtPart{get;set;}  
    public string appDate{get;set;} 
    public string appType{get;set;} 
    public string dueDate{get;set;} 
    public string PrintWhat{get;set;}
    public string PrintWhat1{get;set;}
    public string OpenWhat{get;set;}
    public string appColor{get;set;}
    public string complId{get;set;}
    public string actionId{get;set;}
    public boolean clockRun{get;set;} 
    public boolean create{get;set;}
    public string s_create{get;set;}
    public string verstatus{get;set;}
    public boolean exited{get;set;}
    public boolean notVerified{get;set;}
    public string noCourt{get;set;} 
    public string noIntakeDate{get;set;} 
 //   public boolean rearest{get;set;}  
    public boolean intakeCase{get;set;}  
    public string caseType{get;set;}  
    public string arrestStatus{get;set;} 
    public boolean SRPsuper{get;set;}
    public boolean FTA{get;set;}
    public boolean letter{get;set;}
    public string CCid{get;set;}
    public string CC{get;set;}
    public string CCtext{get;set;}   }
 //   public string arrestStatus{get;set;}

    public Event proxyObject {get; set;}
    public reportQuery rq = new reportQuery();
      Map<string,string> mapClientAccount = new Map<string,string>();

 public srp_NotificationController(){ 
   currentDate = date.today();
    Event e = new Event();
    e.closing_date__c = rq.countDueDateBefore(date.today(),7);
    e.catalog_end_date__c = date.today().addDays(7);
    proxyObject = e;
        Id userProfId = userInfo.getProfileId();
      Profile p = [Select name from Profile where id =: userProfId limit 1];
      if (p.Name == 'System Administrator')
          sfAdmin = true;  
            userLoginStaffId = userInfo.getUserId();}
    
   public List<deliqtrk> lstDeliqToShow{get;set;}


   public List<deliqtrk> checkDeliqTrack(){
      Set<String> complianceShow = new Set<String>(); 
     List<deliqtrk> lstSelected = new List<deliqtrk>();            
     if (sfAdmin == false){
         Integer noOfDays = proxyObject.closing_date__c.daysBetween(proxyObject.catalog_end_date__c);
      if (noOfDays > 25){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select date range less than 21 working days.'));
        return null;
      }
     }
     Map<Date, ID> mapHolidays = new Map<Date, ID>();
     List<Holidays__c>lstHolidays = [SELECT Id, Date__c FROM Holidays__c];
     for(Holidays__c h: lstHolidays) {
      mapHolidays.put(h.Date__c, h.Id);
     }    
    
     Set<String> setNotAttended = new Set<String>();
     Set<String> setNotVerified = new Set<String>();
     Set<String> setAttended = new Set<String>();
  //   Set<string> setSRPid = new Set<string>();  
     Set<string> setRearrDocketsIds = new Set<string>();
       for (Contact c : lstContactsNoFilter){ 
       setSRPid.add(c.id);
       if (ccValue <> 'All' && ccValue <> null){
          if (c.case_coordinator__c <> null){
             if (ccValue == c.case_coordinator__c)
                complianceShow.add(c.id);}
       } 
       else
         complianceShow.add(c.id);}
     Map<string,string> mapCaseClientName = new Map<string,string>();
//     Map<string,string> 
     Map<string,string> mapCaseClientId = new Map<string,string>();
     Set<String> ArrestPendingCases = new Set<String>();
     string doc;
     Set<String> setAllCases = new Set<String>();
     map<string,string> mapCaseType = new map<string,string>();
    List<Case_Relationship__c> lstAllCases = new List<Case_Relationship__c>();
    Set<String> setSRP = new Set<String>();
    Set<String> setSRPsuper = new Set<String>();
    for (Case_Relationship__c lstAllCasesActive : [select Id, Docket__c,Client_Name__c,contact__c,pcid__c,
     docket_indictment__c,Case_Court_Status_Calc__c,case_type__c,ArrestDate__c,
     Supervised_by_SRP__c From Case_Relationship__c 
     where program__c =: 'SRP' order by id desc limit 1000]){
       if (lstAllCasesActive.Case_Type__c == 'Intake Case'){
           lstAllCases.add(lstAllCasesActive);
           setAllCases.add(lstAllCasesActive.docket__c);  
       }
       else{
         if (lstAllCasesActive.Supervised_by_SRP__c == true)
            setSRPsuper.add(lstAllCasesActive.docket__c);
       }
        mapCaseType.put(lstAllCasesActive.Docket__c,lstAllCasesActive.case_type__c)  ;    
     }

    List<Case_Relationship__c> lstAllRearrest = new List<Case_Relationship__c>();
 
   date dCreated = date.today() - 400;
 //  string arrestDate = dcreated.format();
/*
   lstAllRearrest = [select Id, Docket__c,Client_Name__c,contact__c,pcid__c,
     docket_indictment__c,Case_Court_Status_Calc__c,case_type__c,ArrestDate__c,
     firstname__c, lastname__c From Case_Relationship__c 
      where Docket__r.Arrest_Date__c != null and Docket__r.Arrest_Date__c  >=: dCreated
      and Case_Type__c =: 'In-Program'  and Supervised_by_SRP__c =: true 
      and program__c =: 'SRP'  and Case_Court_Status_Calc__c != : 'Never Arraigned' 
       order by id desc limit 1000];
*/
  lstAllRearrest = [select Id, Docket__c,Client_Name__c,contact__c,pcid__c,
     docket_indictment__c,Case_Court_Status_Calc__c,case_type__c,ArrestDate__c,
     firstname__c, lastname__c From Case_Relationship__c 
      where Docket__r.Arrest_Date__c != null and Docket__r.Arrest_Date__c  >=: dCreated
      and Case_Type__c =: 'In-Program' 
      and program__c =: 'SRP'  and Case_Court_Status_Calc__c != : 'Never Arraigned' 
       order by id desc limit 1000];
//      and ArrestDate__c != : null order by id desc limit 300];

      if (lstAllRearrest.Size() != 0){
      for (Case_Relationship__c cr : lstAllRearrest){
        lstAllCases.add(cr);
        setRearrDocketsIds.add(cr.docket__c);
        mapCaseClientName.put(cr.Docket__c,cr.firstname__c.trim() + ' ' + cr.lastname__c.trim());
        mapCaseClientId.put(cr.Docket__c,cr.contact__c); 
        doc = cr.docket__c;
        if (cr.docket_indictment__c.contains(doc) == false){
            if (cr.Case_Court_Status_Calc__c == 'Pending' || cr.Case_Court_Status_Calc__c == '')
        ArrestPendingCases.add(cr.Docket__c);}
        setAllCases.add(cr.docket__c);
//        setSRPsuper.add(cr.contact__c);
        setSRPsuper.add(cr.docket__c);
        mapCaseType.put(cr.Docket__c,cr.case_type__c)  ;    
      }}
      string Supervision,IntakeNeedsAssessment,courtRecType; 
      List<RecordType> lstRecType = [Select id,developername,name from RecordType
       where developername =: 'Court_Ordered_Supervision' or 
       developername =: 'Intake_Needs_Assessment' or developername =: 'CourtDate'];
         for (integer i = 0;i < lstRecType.Size();i++){
             if (lstRecType[i].developername == 'Court_Ordered_Supervision')
                Supervision = lstRecType[i].id;
             if (lstRecType[i].developername == 'Intake_Needs_Assessment')
                IntakeNeedsAssessment = lstRecType[i].id; 
             if (lstRecType[i].developername == 'CourtDate')
                courtRecType = lstRecType[i].id;     
      }
   Set<String> setActIdsInEvent = new Set<String>();
   string outcome = 'Entered in Error';
 
   List<Event> lstEvent = [select who.name,activityDate,Part__c,Outcome__c,
         action__c,id,verification_status__c,subject,RecordTypeId,
         whoid, whatid from event where whoid in: setSRPid and Outcome__c !=: outcome and 
         activitydate >=: proxyObject.closing_date__c and 
         activitydate <=: proxyObject.catalog_end_date__c and
         Verification_Status__c !=: 'Excused' and Verification_Status__c !=: 'Cancelled'
         and ((recordtypeid =: Supervision and subject != 'Reminder Call') or recordtypeid =: IntakeNeedsAssessment
         or recordtypeid =: courtRecType)
         order by activitydate,Part__c,who.name]; 

  Set<String> setFTA = new Set<String>();
  Set<String> setLetters = new Set<String>();
  Set<String> setCourtsIds = new Set<String>();
  for (Event e : lstEvent){
     setActIdsInEvent.add(e.id);
       if (e.Verification_Status__c == 'Attended')
           setAttended.add(e.id);
    if (e.Subject == 'Court Date')
       setCourtsIds.add(e.id);
     if (e.Verification_Status__c == 'Unexcused'){
       setNotAttended.add(e.id);  
       if (e.Subject == 'Court Date')
       setFTA.add(e.id);
       else
       setLetters.add(e.id);
     }
     else{    
       if (e.Verification_Status__c == 'Not Verified' && e.ActivityDate < date.today() )
         setNotVerified.add(e.id);}}
         
   Set<String> SetHasCourts = new Set<String>();
   if (setActIdsInEvent != null){
       for (Event lstCourts : [select whoid from event where 
          whoid in:setSRPid and subject =: 'Court Date']){
             SetHasCourts.add(lstCourts.whoid)   ;         
    }}   
    Set<String> setActIdsInTracking = new Set<String>();  
    Set<String> setActIdsClockRunInTracking = new Set<String>();  
      
    List<Delinquency_Tracking__c> lstDeliqApp = 
      [Select actionId__c, id,Stop_Clock__c,document_type__c,client__c,
      FTA_reason__c,Outcome__c,Returned_to_Program__c from
      Delinquency_Tracking__c where actionId__c in: setActIdsInEvent and deleted_by_user__c =: false
      order by client__c,id desc];
      List<Delinquency_Tracking__c> lstDeliqRearr =
      [Select actionId__c, id,Stop_Clock__c,document_type__c,client__c from
      Delinquency_Tracking__c where actionId__c in: setRearrDocketsIds
      and deleted_by_user__c =: false];
      
      if (lstDeliqApp != null){
         if (lstDeliqRearr != null)
           for (integer i = 0; i < lstDeliqRearr.size(); i++){
             lstDeliqApp.add(lstDeliqRearr[i]);} 
      }
       Set<String> setActIdsChecked = new Set<String>();
    boolean lFix;
    Delinquency_Tracking__c fixFTAone = new  Delinquency_Tracking__c(); 
    for (Delinquency_Tracking__c d : lstDeliqApp){
      lFix = false;
      if (setAttended.contains(d.actionid__c) == true){
        fixFTAone = new  Delinquency_Tracking__c(id=d.id); 
        if (d.FTA_reason__c <> null && d.FTA_reason__c <> ''){
            lFix = true;
            fixFTAone.FTA_reason__c = '';
        }
        if (d.Outcome__c <> null && d.Outcome__c <> ''){
            lFix = true;
            fixFTAone.Outcome__c = '';
        }    
        if (d.Returned_to_Program__c <> null && d.Returned_to_Program__c <> ''){
            lFix = true;
            fixFTAone.Returned_to_Program__c = '';
        }
        if (lFix)
           fixFTA.add(fixFTAone);
       }
       if (d.document_type__c != 'Contact')
         setActIdsInTracking.add(d.actionId__c);
         if (d.Stop_Clock__c == false && d.document_type__c == 'Letter'
         && setActIdsChecked.contains(d.actionId__c) == false){
           if (setActIdsClockRunInTracking.contains(d.actionId__c) == false)
             setActIdsClockRunInTracking.add(d.actionId__c);
            setActIdsChecked.add(d.actionId__c);
      }}  
      if (fixFTA <> null)
        update fixFTA;    
      date courtDate;
      string clientId, actionId; 
      List<deliqtrk> lstDeliq = new List<deliqtrk>();
      deliqtrk oneRecord = new deliqtrk();
      id intakeCase;
      date dateLetters = date.today();
      for (integer ev = 0; ev < lstEvent.Size(); ev++){
         oneRecord = new deliqtrk();
         oneRecord.s_create = ''; 
         oneRecord.CCid =  map_contId_CCID_Incontact.get(lstEvent[ev].whoid);
         oneRecord.CC = 'no CC assigned';
         if (oneRecord.CCid != 'no CC'){
         oneRecord.CCtext = MapStuffShort.get(oneRecord.CCid);
         oneRecord.CC = Mapstufftext.get(oneRecord.CCid);
         }
         oneRecord.FTA = false;  
         oneRecord.letter = false;  
         oneRecord.exited = false;
         oneRecord.clockRun = false;
         oneRecord.SRPsuper = false;
         intakeCase = mapclientIntakeCase.get(lstEvent[ev].whoid);
         if (intakeCase == lstEvent[ev].whatid){ 
            oneRecord.intakecase = true;       
            oneRecord.SRPsuper = true;
         }  
         else{
            oneRecord.intakecase = false; 
            if (setSRPsuper.contains(lstEvent[ev].whatid) == true)  
              oneRecord.SRPsuper = true;     
         }
         oneRecord.clientId = lstEvent[ev].whoid;
         if (id_exited.contains(oneRecord.clientId))
            oneRecord.exited = true;
          oneRecord.nocourt = 'N';
//         if (SetHasCourts.contains(lstEvent[ev].whoid) == false && lstEvent[ev].recordtypeid != courtRecType)
       if (SetHasCourts.contains(lstEvent[ev].whoid) == false)
            oneRecord.nocourt  = 'Y';  
         if (str_noIntakeDate.contains(lstEvent[ev].whoid) == true)
            oneRecord.noIntakeDate = 'Y';                  
         oneRecord.clientName = lstEvent[ev].who.name;
         oneRecord.actionId = lstEvent[ev].id;
         oneRecord.appDate = lstEvent[ev].activitydate.format();
         oneRecord.courtPart = lstEvent[ev].part__c; 
         oneRecord.appColor = 'black';
         oneRecord.create = false;  
        
         oneRecord.verStatus = lstEvent[ev].verification_status__c;               
         if (lstEvent[ev].RecordTypeId == Supervision)
           oneRecord.appType = 'Supervision (' + lstEvent[ev].Subject + ')';
         else {
            if (lstEvent[ev].RecordTypeId == IntakeNeedsAssessment)
               oneRecord.appType = 'Intake/need Assessment';
            else 
               if (lstEvent[ev].RecordTypeId == courtRecType){
                  oneRecord.appType = 'Court Date';
                 if (setFTA.contains(lstEvent[ev].id))
                    oneRecord.FTA = true; 
         }}
         if (setLetters.contains(lstEvent[ev].id))
            oneRecord.letter = true;
         if (setNotVerified.contains(lstEvent[ev].id)){
            oneRecord.notVerified = true; 
            oneRecord.appColor = 'red'  ;                   
         }  
         if (lstEvent[ev].RecordTypeId == Supervision || lstEvent[ev].RecordTypeId == IntakeNeedsAssessment){ 
            oneRecord.PrintWhat = 'Letter';
           if (setNotAttended.contains(lstEvent[ev].id) == true){   
            oneRecord.dueDate = rq.countDueDate_1(mapHolidays,lstEvent[ev].activitydate,2).format();
            if (lstEvent[ev].activitydate < date.today()){
            if (setActIdsClockRunInTracking.contains(lstEvent[ev].id) == true || 
              setActIdsInTracking.contains(lstEvent[ev].id) == false)
            oneRecord.clockRun = true;}}
            if (lstEvent[ev].activitydate <= date.today()){
            if (setActIdsInTracking.contains(lstEvent[ev].id) == false)        
              oneRecord.s_create = 'Create';
            else     
              oneRecord.s_create = 'Open';
            }    }
         else{
           if (lstEvent[ev].RecordTypeId == courtRecType){ 
               oneRecord.PrintWhat = 'Report';  
               if (setFTA.contains(lstEvent[ev].id))
                  oneRecord.PrintWhat1 = 'FTA';
               oneRecord.dueDate = rq.countDueDateBefore_1(mapHolidays,lstEvent[ev].activitydate,1).format();
               if (setActIdsInTracking.contains(lstEvent[ev].id) == false){
                   oneRecord.s_create = 'Create';
               }
               else 
                 oneRecord.s_create = 'Open';
               }
          }
          if (lstEvent[ev].RecordTypeId == courtRecType){
              oneRecord.caseType = mapCaseType.get(lstEvent[ev].whatid);
          }    
        if (lstEvent[ev].RecordTypeId == Supervision || 
            lstEvent[ev].RecordTypeId == IntakeNeedsAssessment){
           if (setAttended.contains(lstEvent[ev].id) == false &&
              complianceShow.contains(lstEvent[ev].whoid)&& 
              lstEvent[ev].activityDate <= date.today())     
               lstDeliq.add(oneRecord);}
          else{   
            if ((ccValue <> 'All' && complianceShow.contains(oneRecord.clientId)) || ccValue == 'All')       
               lstDeliq.add(oneRecord);
         }}
         date dArrestShowFrom = proxyobject.closing_date__c.addDays(-30);
         if (setRearrDocketsIds != null){
         for (Case_Information__c lstRearrCases : [Select No_Docket__c, Name, Arrest_Number__c, 
            Arrest_Date__c,Case_Court_Status__c
              From Case_Information__c c where id in: setRearrDocketsIds
              and Arrest_Date__c >: dArrestShowFrom]){
         //       if (setSRPsuper.contains(lstRearrCases.id) == true){
              // limit 100]){
                oneRecord = new deliqtrk();
                oneRecord.SRPsuper = true;
                oneRecord.appDate = lstRearrCases.Arrest_Date__c.format();
                oneRecord.clientName = mapCaseClientName.get(lstRearrCases.id);
                oneRecord.PrintWhat = 'Rearrest';
                oneRecord.actionId = lstRearrCases.id;
                oneRecord.clientId = mapCaseClientId.get(lstRearrCases.id); 
                oneRecord.CCid =  map_contId_CCID_Incontact.get(oneRecord.clientId);
                oneRecord.CC = 'no CC assigned';
                if (oneRecord.CCid != 'no CC'){
                  oneRecord.CCtext = MapStuffShort.get(oneRecord.CCid);
                  oneRecord.CC = Mapstufftext.get(oneRecord.CCid);
               }                
             if (id_exited.contains(oneRecord.clientId))
                    oneRecord.exited = true;                  
                oneRecord.arrestStatus =  lstRearrCases.Case_Court_Status__c;          
                if (lstRearrCases.Case_Court_Status__c.contains('Arraigned'))
                    oneRecord.appType = 'Rearrest - ' + lstRearrCases.name; 
                else 
                  oneRecord.appType = 'Rearrest - ' + lstRearrCases.Case_Court_Status__c;
                if (lstRearrCases.Arrest_Date__c != null)
                    oneRecord.dueDate = rq.countDueDate_1(mapHolidays,lstRearrCases.Arrest_Date__c,2).format();
                if (setActIdsClockRunInTracking.contains(oneRecord.actionId) == true || 
                   setActIdsInTracking.contains(oneRecord.actionId) == false) 
                oneRecord.clockRun = true;
                if (ArrestPendingCases.contains(lstRearrCases.id) == false ){
                   if (setActIdsInTracking.contains(oneRecord.actionId) == false)
                      oneRecord.s_create = 'Create';
                    else     
                       oneRecord.s_create = 'Open';
                }  
                   
            if ((ccValue <> 'All' && complianceShow.contains(oneRecord.clientId)) || ccValue == 'All')    
                   lstDeliq.add(oneRecord);                 
            }//}
       }
   if (docValue == 'All' || docValue == null)
          lstSelected = lstDeliq; 
       else{
         if (lstSelected <> null)
           lstSelected.Clear();
           for (deliqtrk dlq : lstDeliq){
            if (dlq.PrintWhat == docValue || dlq.PrintWhat1 == docValue )
              lstSelected.add(dlq);
       }}
//    return null;
      return lstSelected;
    }
   public pageReference RequeryInfo(){
      if (sfAdmin == false){
        Integer noOfDays = proxyObject.closing_date__c.daysBetween(proxyObject.catalog_end_date__c);
      if (noOfDays > 25){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select date range less than 21 working days.'));
        return null;
      }}
      lstDeliqToShow = checkDeliqTrack();
     return null;
       }
     public void checkCourt(){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please create a court date for ' + namePassed));}
      
    public void checkIntake(){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No Intake Date entered for' + namePassed));}
    public void doNothing(){
            }  
    public boolean displayPopup {get; set;}     
    public pageReference closePopup() {displayPopup = false;
    return null;}       
    
    public string clientName{get;set;}
    public string courtId{get;set;}
    public string appDate{get;set;}
    public string docName{get;set;}
    
    string FTAValueOld;
    string OutcomeValueOld;
    string ReturnedValueOld;
    string CaseRelIdOld;
    
    public PageReference showPopup() {
    List<Delinquency_Tracking__c> d = 
        [select Returned_to_Program__c,FTA_reason__c,Outcome__c,warrant_issued__c,Case_Relationship__c from 
       Delinquency_Tracking__c  where actionid__c =: courtid limit 1];
   if (d.Size() == 0){
      FTAValue = '';             
      OutcomeValue = '';
      ReturnedValue = '';}
   else{
      CaseRelIdOld = d[0].Case_Relationship__c;
      if (docName == 'Report')
         FTAValue = d[0].FTA_reason__c;
      else
        FTAValue = d[0].warrant_issued__c;
        OutcomeValue = d[0].Outcome__c;
        ReturnedValue = d[0].Returned_to_Program__c;
      }
    FTAValueOld = FTAValue;
    OutcomeValueOld = OutcomeValue;
    ReturnedValueOld = ReturnedValue;
    displayPopup = true;
     checkDeliqTrack();
     return null;}
  
  List<SelectOption> WarrantItems;
  public List<SelectOption> getWarrantItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Warrant_issued__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setWarrantItems(){
        WarrantItems = this.WarrantItems;}
  
     public String FTAValue{get;set;} 
     public string ReasonValue{get;set;}
   List<SelectOption> ReasonItems;
    public List<SelectOption> getReasonItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.FTA_reason__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setReasonItems(){
        ReasonItems = this.ReasonItems;}
  
  string pickLabel;
  public string outcomeValue{get;set;}
   List<SelectOption> FTAOutcomeItems;
  public List<SelectOption> getFTAOutcomeItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Outcome__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
         pickLabel = f.getLabel();
         if (pickLabel <> 'Warrant Vacated' && pickLabel <> 'Warrant Stayed')  
            options.add(new SelectOption(pickLabel, f.getValue()));}       
        return options;}
    public void setFTAOutcomeItems(){
        FTAOutcomeItems = this.FTAOutcomeItems;}
 
   List<SelectOption> LetterOutcomeItems;
  public List<SelectOption> getLetterOutcomeItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Outcome__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          pickLabel = f.getLabel();  
          if (pickLabel == 'Warrant Vacated' || pickLabel == 'Warrant Stayed')
          options.add(new SelectOption(pickLabel, f.getValue()));}       
        return options;}
    public void setLetterOutcomeItems(){
        LetterOutcomeItems = this.LetterOutcomeItems;}
 
     public String ReturnedValue{get;set;} 
    List<SelectOption> ReturnItems;
    public List<SelectOption> getReturnItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Returned_to_Program__c  .getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setReturnItems(){
        ReturnItems = this.ReturnItems;}
   public string selectedClient{get;set;} 
  
   public void saveFTA(){
    // If Rearrest: actionId is Case Id
     boolean recInDelinq = false;
   Id recid, CaseRel_Id,clientId;
   
   if (docName == 'Rearrest'){
  //and Supervised_by_SRP__c =: true
      Case_Relationship__c caseRelRecord = [select docket__c,id,pcid__c,contact__c 
      From Case_Relationship__c where 
      Case_Type__c =: 'In-Program' 
      and program__c =: 'SRP'  
      and Case_Court_Status_Calc__c != : 'Never Arraigned' 
      and docket__c =: courtId limit 1];
      CaseRel_Id = caseRelRecord.id; 
      pcid = caseRelRecord.pcid__c; 
      clientId = caseRelRecord.contact__c;
      
   }
   for(Delinquency_Tracking__c d : [select id,actionid__c from 
       Delinquency_Tracking__c  where actionid__c =: courtid and document_type__c =: docName limit 1]){
       recInDelinq = true;  
       recid = d.id;}
    string ftaClient,caseid,accountid; 
   boolean lUpdate = false;
  // boolean updatecaseRel = false;
   
   // new record
   if (recInDelinq == false){  
     for (Event e : [select whatid,whoid,id from event where id =: courtId limit 1]){
        ftaClient = e.whoid;
        caseid = e.whatid;
     accountId = mapClientAccount.get(ftaClient);}
     Delinquency_Tracking__c addRec = new Delinquency_Tracking__c();
    addRec.accountId__c = accountId;
    addRec.caseId__c = caseid;
    addRec.client__c = ftaClient;
    addRec.Document_Type__c = docName;
    addRec.ActionId__c = courtId;
    if (docName <> 'Report'){
       addRec.warrant_Issued__c = FTAValue;
       addRec.Letter_Date__c = date.today();}
    else   
       addRec.FTA_reason__c = FTAValue;
    addRec.Returned_to_Program__c = ReturnedValue;
    addRec.Outcome__c = OutcomeValue;
    addRec.Appointment_Date__c = date.parse(appDate.trim());
    addRec.pcid__c = pcid;
    addRec.Case_relationship__c = CaseRel_Id;
    addRec.client__c = clientId;
    insert addRec;
    system.Debug('\n\n XXX addRec: ' + addRec);
    if (docName == 'Rearrest'){
      Case_Relationship__c updateCR = new Case_Relationship__c(id=CaseRel_Id);
      updateCR.DelinquencyTrackingLKID__c = addRec.id;
      update updateCR;
    }
    }
   else{
   //record already created
    Delinquency_Tracking__c updateRec = new Delinquency_Tracking__c(id=recid);
    if (FTAValue <> FTAValueOld ||OutcomeValue <> OutcomeValueOld || ReturnedValue <> ReturnedValueOld)
        lUpdate = true;
  //  if (docName == 'Rearrest' && updateRec.Case_Relationship__c <> CaseRelIdOld){
  //     updatecaseRel = true;
   //    updateRec.Case_Relationship__c = CaseRel_Id;
   // }
    if (FTAValue <> FTAValueOld)
       if (docName == 'Report')
          updateRec.FTA_reason__c = FTAValue;
    else
        updateRec.warrant_Issued__c = FTAValue;
    if (outcomeValue <> OutcomeValueOld)
      updateRec.Outcome__c = OutcomeValue;
    if (ReturnedValue <> ReturnedValueOld)        
       updateRec.Returned_to_Program__c = ReturnedValue;
   /// if (lUpdate || updatecaseRel)
       update updateRec;
   }
 
    lstDeliqToShow = checkDeliqTrack();
   closePopUp();
   }
   
   public void defaultSelection(){
     //  lstContactsNoFilter = new List<Contact>();  
           date dFrom = rq.countDueDateBefore(date.today(),30);
      
     lstContactsNoFilter =[Select id,name,current_intake_date__c,Current_Exit_Date__c,
     intake_case__c,accountid,case_coordinator__c from contact where recordtypeid =: srpClient
        and (client_status__c =: 'Active' or Current_Exit_Date__c >=: dFrom)];
     
     for (Contact c : lstContactsNoFilter){
      //  setContacts.add(c.id);    
       ccId = c.Case_Coordinator__c;
       if (ccId != null && setCCid.contains(ccId) == false)
          setCCid.ADD(ccId);         
       if (c.Case_Coordinator__c != null){
          map_CCIncontact.put(c.id, MapStuffShort.get(c.Case_Coordinator__c));
          map_CCIncontactText.put(c.id, MapStuffText.get(c.Case_Coordinator__c));  
          map_contId_CCID_Incontact.put(c.id,c.Case_Coordinator__c);
        }
      else{ 
         map_CCIncontact.put(c.id, '--');
         map_CCIncontactText.put(c.id,'no Case Coordinator');}  
              
       mapClientAccount.put(c.id,c.accountId);   
       if (c.Intake_Case__c != null)
           mapclientIntakeCase.put(c.id,c.Intake_Case__c);
           mapClientName.put(c.id,c.name);
           if (c.current_intake_date__c == null)
           str_noIntakeDate.add(c.id);
           if (c.current_exit_date__c != null)
             id_Exited.add(c.id);
           }
          string intitials;  
   
       ccItems = new List<SelectOption>();
       ccItems.add(new SelectOption('All','All'));            
   for (User u : [select id,name,firstname,lastname,Department__c,unit__c  from user where id in:setCCid
      and  department__c =: 'Supervised Release' and unit__c != 'Mental Health']){
       intitials = (u.firstname).left(1) + u.lastname.left(1);
       if (setCCid.contains(u.id)){
          ccItems.add(new SelectOption(u.Id,u.Name));
          Mapstufftext.put(u.id,u.Name);
          MapStuffShort.put(u.id,intitials);
       }}
      
         if (setCCid.contains(userLoginStaffId)){
       if (userLoginStaffId != '00560000005Gn6j' && userLoginStaffId != '00560000006AJTV')
           ccValue = userLoginStaffId;
       else
           ccValue = 'All';
       docValue = 'Letter';
      }
      else
        ccValue = 'All';
        lstDeliqToShow = checkDeliqTrack();
  
      }
/*
   for (User u : [select id,name,firstname,lastname,Department__c,unit__c  from user where id in:setCCid
      and  department__c =: 'Supervised Release' and 
      (unit__c =: 'Court Services' or unit__c =: 'Admin Services')]){
       intitials = (u.firstname).left(1) + u.lastname.left(1);
       if (setCCid.contains(u.id)){
          ccItems.add(new SelectOption(u.Id,u.Name));
          Mapstufftext.put(u.id,u.Name);
          MapStuffShort.put(u.id,intitials);
       }}}
  */
  
   
  }