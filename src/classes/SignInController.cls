public with sharing class SignInController{
   Public String strPassed = System.currentPagereference().getParameters().get('passPar');  
   public String boroPassed = System.currentPagereference().getParameters().get('passBoro');  
  
   public Id conClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
   public Id eventRecordType = Utility_ID__c.getValues('Case Coordination').RecordType_Id__c;
   public UtilityTimeMethods ut = new UtilityTimeMethods();   
   public string selectedBoro{get;set;}
   public Event proxyObject {get; set;}
   public boolean noSelect{get;set;}
   public date ReportDate{get;set;}
   public string currentDate{get;set;}
   public string boro{get;set;}
   public date getTodayDate(){
      date d = date.today();
      return d;
   }
   
   transient public List<clientsEvents> lstEventsShow{get;set;}  
  

 //  public List<clientsEvents> lstEventsShow{get;set;}  
  // transient public List<clientsEvents> lstEventsBrooklyn{get;set;}  
//   transient public List<clientsEvents> lstEventsHarlem{get;set;}  

 //  public List<clientsEvents> lstEventsBrooklyn{get;set;}  
 //  public List<clientsEvents> lstEventsHarlem{get;set;}  


   public string getDayofWeek(){
      dateTime dt = Datetime.newInstance(proxyObject.ActivityDate, Time.newInstance(0,0,0,0));
      return dt.format('EEEE');
   }
   public SignInController(){
          currentDate = date.today().format();
    //    system.debug('\n\n XXX ***Constructor*** printPassed: ' + printPassed);
         Event e = new Event();
         if (strPassed == null){
            e.activitydate = date.today();
            e.activitydatetime = datetime.now();}
        else{ 
            e.activitydate = date.parse(strPassed);
        }    
       e.Open_Date__c = date.today().addDays(-1);
       e.Closing_Date__c = date.today();
       proxyObject = e;   
       lstEventsShow = findClientEvents();
   }  
  
   public class clientsEvents{
      public string schedtimestr{get;set;}     
      public string VerifiedBy{get;set;}   
      public string VerifiedOn{get;set;}        
      public Id contactId {get;set;}
      public Event eventForDisplay{get;set;} 
      public List<String> lstOtherEventStrings {get;set;}
      public Task drugTest {get;set;}
      public string nextDrugTest {get;set;}     
      public string whatid {get;set;}     
      public string boro {get;set;}     
      public string cname {get;set;}     
      public string caseCoordinator {get;set;}
      public String namecolor{get;set;} 
      public String nametip{get;set;} 
      public String color{get;set;}              
      public String backcolor{get;set;}
      public string rowNumber{get;set;}     
      public string rowNumber_B{get;set;}     
      public string rowNumber_H{get;set;}     
      public string RepBoro{get;set;}  
      public string verstatus{get;set;}         
      public string timein{get;set;}         
      public string timeout{get;set;}         
      public boolean signIn{get;set;}        
      public boolean repeatName{get;set;}        
      public boolean scheduled{get;set;}
      public List<SelectOption> timesOut{get;set;}
      public List<SelectOption> timesIn{get;set;}}
   
   date selectedDate{get;set;}  
  String[] intakeStatus = new List<String>{'Active','On Program Hold','Intaked - Not Yet Active'};     
   public List<clientsEvents> findClientEvents() {
     Integer poz;
      selectedDate = proxyobject.activitydate;
       if (selectedDate > date.today()){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Future appts can not be selected.'));
          noSelect = true;
          selectedDate+=30000;
       }   
//          return null;}
     noSelect = false;  
     system.Debug('\n\n XXX proxyobject.activitydate: ' + proxyobject.activitydate);
     List<Contact> lstContacts = new List<Contact>();
      List<Contact> lstAllContact = new List<Contact>();
  
   //  String[] intakeStatus = new List<String>{'Active','On Program Hold','Intaked - Not Yet Active'};
     Set<String> contIds = new  Set<String>();    
     lstAllContact = [select id,Reporting_Borough__c,Current_Intake_Date__c,Client_Status__c
     from contact where recordtypeid =: conClient and Client_Status__c in: intakeStatus and
      Current_Intake_Date__c <= : selectedDate ];
     date datefrom = selectedDate.addDays(-30);
     date dateTo =selectedDate.addDays(3);
 
     Map<id,string> mapStatus = new Map<id,string>();
     Map<id,string> mapBoro = new Map<id,string>();
     if (selectedBoro == null || selectedBoro == 'All')
        lstContacts = lstAllContact;
      else{ 
        for (Contact cnt : lstAllContact){ 
        	if (selectedBoro == 'Brooklyn'){
        	   if (cnt.Reporting_Borough__c == 'Brooklyn')
        	      lstContacts.add(cnt);}
            else{
               if (cnt.Reporting_Borough__c == 'Harlem' || cnt.Reporting_Borough__c == 'Queens')
              lstContacts.add(cnt);}}}
     for (Contact c : lstContacts){
       mapStatus.put(c.id,c.Client_Status__c);
        contIds.add(c.id);
        mapBoro.put(c.id,c.Reporting_Borough__c);}
         
     Set<String> EventsSchedIds = new Set<String>(); 
     Set<String> EventsNotSchedIds = new Set<String>(); 
     Set<String> ContactsSchedIds = new Set<String>(); 
     Set<String> ContactNotSchedIds = new Set<String>(); 
  
    List<Event> lstEventsAll = [Select id, activitydate,subject,whoid from Event 
       where (whoid in: contIds and activitydate >=: dateFrom 
      and activitydate <=: selectedDate ) and 
      (recurrenceType =: null or isrecurrence = false)];  
   for (Event Sched : lstEventsAll){
       if (Sched.subject == 'Program Reporting' && 
           Sched.activitydate == selectedDate && 
           ContactsSchedIds.contains(sched.whoid) == false && 
           EventsSchedIds.contains(Sched.id) == false){
           ContactsSchedIds.add(sched.whoid);  
           EventsSchedIds.add(Sched.id);}
     }
         for (Event notSched : lstEventsAll){  
         if (notSched.activitydate != selectedDate && 
            ContactsSchedIds.contains(notSched.whoid) == false
            && ContactNotSchedIds.contains(notSched.whoid) == false &&
            EventsNotSchedIds.contains(notSched.id) == false){
            EventsNotSchedIds.add(notSched.id);
            ContactNotSchedIds.add(notSched.whoid);}
       }    
      List<Event> lstOtherEvents = [Select activitydate,activitydatetime, 
       Verification_Status__c, whoid,whatid, Subject from event where 
       activitydate =: selectedDate and 
       (recurrenceType =: null or isrecurrence = false) and 
       subject !=: null and subject !=: 'Program Reporting']; 
 
     List<Task> lstDrugTests = [Select Id, subject, activitydate, whoid, who.name
        From task Where whoid in: contIds and status =: 'Not started' and recurrenceType =: null 
          and isrecurrence = false and (subject =: 'Next Drug Test' 
                    or subject =: 'Exit Drug Test' or subject =: 'Init Drug Test')]; 
  
     Map<id,Contact> mapContact = new Map<id,Contact>([Select c.Case_coordinator__r.Name, 
      c.name,Case_coordinator__r.id,Current_Intake_Date__c From Contact c where id in: contIds]);
     List<clientsEvents> lstEvents = new List<clientsEvents>();    
     clientsEvents oneRecord = new clientsEvents();
     date dintake;
     integer nRow = 1;
     integer nRow_B = 1;
     integer nRow_H = 1;
     string status;
     for (Event e : [select id, who.name, subject, activitydatetime, activitydate,whatid,
                       DurationInMinutes, verification_status__c, whoid, Time_In__c, Time_Out__c,Verified_By__c, Verification_Date__c 
                       from event where (id in : EventsSchedIds or id in: EventsNotSchedIds) 
                       and (recurrenceType =: null or isrecurrence = false)
                       order by who.name]){
      dintake = mapContact.get(e.whoid).Current_Intake_Date__c;
      if (selectedDate >= dintake && selectedDate <= date.today()){
      oneRecord = new clientsEvents();   
     // oneRecord.selectedDate = proxyObject.ActivityDate;
   //   selectedDate = proxyobject.ActivityDate;
      oneRecord.scheduled = false;
      status = mapStatus.get(e.whoid);
      oneRecord.namecolor = 'black';
     oneRecord.nametip = '';
     if (status == 'On Program Hold' || status =='Intaked - Not Yet Active'){
         oneRecord.namecolor = 'red';
         oneRecord.nametip = status;
      }
      oneRecord.cname = mapContact.get(e.whoid).name;
  
    oneRecord.schedtimestr = string.valueof(e.activitydatetime.format());
     if (e.Verified_By__c != null){
     poz = (e.Verified_By__c).indexOf(' ', 1);
      oneRecord.VerifiedBy =  (e.Verified_By__c).substring(0,poz);}
      if (e.Verification_Date__c != null)
         oneRecord.VerifiedOn = e.Verification_Date__c.format();
     
      oneRecord.RepBoro = MapBoro.get(e.whoid); 
      if (oneRecord.RepBoro != null)
         oneRecord.boro = oneRecord.RepBoro.substring(0,1);  
      if (e.activitydate == selectedDate)
         oneRecord.scheduled = true;
      if (e.Verification_Status__c == 'Not Verified' || oneRecord.scheduled == false || e.activitydate != selectedDate)
          oneRecord.verStatus = '*';
      else  { 
        if (e.activitydate == selectedDate)  
            oneRecord.verStatus = e.Verification_Status__c;  
      }
      t_beg = t_begDefault;  
   //   if (e.verification_status__c != null)
    //     attendance = e.verification_status__c.trim();
       if (e.Time_In__c == null || e.Time_Out__c == '' ){
         List<SelectOption> optionForSelect = new List<SelectOption>();
         optionForSelect.add(new SelectOption('', '--------------'));
         oneRecord.timesIn = optionForSelect;
         oneRecord.timesOut = optionForSelect;}
      else{//
//        schedtime = e.activitydatetime.format('hh:mm a'); 
        schedtime = '08:00 AM'; 
        oneRecord.timesIn = BuildTimeList(schedtime, e.activitydate, 'in');    
         oneRecord.timesOut = BuildTimeList(e.Time_In__c, e.activitydate, 'out');}
      oneRecord.whatid = e.whatid;
      oneRecord.contactId = e.whoid;   
         if (math.mod(nRow,2) == 0)
          oneRecord.backcolor = '#AFEEEE';
       else 
          oneRecord.backcolor = '#FFFFFF'; 
      oneRecord.caseCoordinator = mapContact.get(e.whoid).Case_coordinator__r.Name;
      oneRecord.lstOtherEventStrings = new List<String>();
      List<String> lstContactEventStrings = new List<String>();
      for (integer i = 0;i < lstOtherEvents.Size();i++){
             if (lstOtherEvents[i].whoid == e.whoid &&
             lstOtherEvents[i].activitydate == selectedDate &&
             lstOtherEvents[i].Verification_Status__c != 'Cancelled' &&
             lstOtherEvents[i].Verification_Status__c != 'Withdrawn' ){ 
             lstContactEventStrings.add(lstOtherEvents[i].activitydatetime.format('hh:mm a') 
              + ' - ' + lstOtherEvents[i].Subject);}} 
        oneRecord.lstOtherEventStrings = lstContactEventStrings;
        oneRecord.nextDrugTest = '';
        for (Task drugTest : lstDrugTests) {
          if (drugTest.whoid == e.whoid){
            oneRecord.nextDrugTest = drugTest.activitydate.format();
            break;}}
       oneRecord.eventForDisplay = e; 
                  oneRecord.rowNumber = string.valueOf(nRow).trim();  
nRow++; 
      lstEvents.add(oneRecord);  
      //      oneRecord.rowNumber = string.valueOf(nRow).trim();  
//nRow++;         
                
      }}
      List<clientsEvents> lstEv1 = new List<clientsEvents>();
      List<clientsEvents> lstEv2 = new List<clientsEvents>();
 //     lstEventsHarlem = new List<clientsEvents>();
  //    System.Debug('\n\n XXX selectedBoro: ' + selectedBoro);
     /*-------------------
      if (boroPassed == null || boroPassed == 'All'){
         for (integer i = 0; i < lstEvents.Size(); i++){
           if (lstEvents[i].VerStatus != '*' ){
               if (lstEvents[i].repBoro == 'Brooklyn'){
                 lstEvents[i].rowNumber_B = string.valueOf(nRow_B).trim();
                   lstEv1.add(lstEvents[i]);
                    nRow_B++;}
                else{     
                 lstEvents[i].rowNumber_H = string.valueOf(nRow_H).trim();
                   lstEv2.add(lstEvents[i]);
                   nRow_H++;                 
                }
            }      
         }
         boro = 'All';
         lstEventsBrooklyn = lstEv1;
         lstEventsHarlem = lstEv2; 
      }
      else {
          if (boroPassed == 'Brooklyn'){
             boro = 'Brooklyn';
            for (integer i = 0; i < lstEvents.Size(); i++){
               if (lstEvents[i].VerStatus != '*' 
               && lstEvents[i].repBoro == 'Brooklyn'){
                 lstEvents[i].rowNumber_B = string.valueOf(nRow_B).trim();
                  lstEv1.add(lstEvents[i]);
                   lstEventsBrooklyn = lstEv1;
                   nRow_B++;}
            }}
         else{
             boro = 'Harlem';
             for (integer i = 0; i < lstEvents.Size(); i++){
            if (lstEvents[i].repBoro == 'Harlem' && lstEvents[i].VerStatus != '*'){
              lstEvents[i].rowNumber_H = string.valueOf(nRow_H).trim();
              lstEv2.add(lstEvents[i]);
                lstEventsHarlem = lstEv2;
                nRow_H++;}
         }}
   
         }
         */
       //  printReport();
     return lstEvents;
   }

  public integer t_beg{get;set;} 
  public integer t_BegDefault = 8;
  public integer t_end ;
  public string t_begA  = 'AM';
  public integer iterations = 5;
  public string schedtime{get;set;} 
  public string attendance{get;set;}  
  public List<SelectOption> BuildTimeList(string timein, date dt, string timefield) {
   string t_timeBeg;
   List<SelectOption> optionForSelect = new List<SelectOption>();
   t_timeBeg = timein;
   if (timefield == 'in'){
      if (attendance == 'Attended'){
         if (t_beg < 10)
              t_timeBeg =  '0' + t_beg + ':00 ' + t_begA;
         else 
          t_timeBeg =  t_beg + ':00 ' + t_begA;}} 
   date dtToday = date.today();
   string t_timeEnd;
   string nextitem;
   integer minbreak;
   string h_part = t_timebeg.substring(0,2);
   string am_part;
   integer t_beginning = integer.ValueOf(h_part);
   if (dtToday == dt){
     t_timeEnd = ut.LatestTimeForPickListForToday(iterations);
     am_part = t_timeEnd.substring(6,8);
     t_end = Integer.ValueOf(t_timeEnd.substring(0,2)) + 1;
     if (am_part  == 'PM')
         t_end = t_end += 12;}
     else{t_end = 22;
         t_timeEnd =  ut.LatestTimeForPickList(t_timebeg, iterations, t_end, t_beginning);}
   integer hours = t_end - t_beginning;
   if (timefield == 'in')
     {
      if (attendance == 'Late'){
         nextitem = ut.addItteration(t_timebeg, iterations);
         t_timeBeg = nextitem ;}
      else 
         t_timeEnd = schedtime; }  
   optionForSelect.add(new SelectOption(t_timeBeg,t_timeBeg));
   for (integer i = 1; i <= hours; i++){   
      for (integer n = 0; n < 60 ; n+=iterations){ 
            nextitem = ut.addItteration(t_timebeg, iterations);
            optionForSelect.add(new SelectOption(nextitem,nextitem));
            t_timebeg = nextitem;}}
   return  optionForSelect;}  

 public string eventId{get;set;}
   public string fieldName{get;set;}
   public string fieldValue{get;set;}
   public datetime fieldDateTime{get;set;}
   public integer fieldDuration{get;set;}

   public string contactId{get;set;}
   public boolean toSchedule{get;set;} 
   public  List<SelectOption> attendanceItems{ get{
       List<SelectOption> option = new List<SelectOption>();
          option.add(new SelectOption('Not Verified','Not Verified'));  
          option.add(new SelectOption('Attended',    'Attended'));
          option.add(new SelectOption('Late',        'Late'));
          option.add(new SelectOption('Unexcused',   'Unexcused'));
          option.add(new SelectOption('Excused',     'Excused'));
  return option;} set{}}
  
  public string contactSelected{get;set;}
  //public date selectedDate{get;set;}
  
 

  public void AddEvent(){
     Event ev = new Event();
     ev.Skip_Triggers__c = true;
     ev.whoid =  contactselected;
    // ev.whatid = caseid;
     ev.ActivityDate = proxyobject.activitydate;
     //selectedDate;
     ev.DurationInMinutes = 15;
     string s = proxyobject.activitydate.format() + ' 08:00 AM';
     ev.ActivityDatetime = DateTime.parse(s);
     ev.Verification_Status__c = 'Attended'; 
     ev.recordtypeid = eventRecordType;
     ev.Subject = 'Program Reporting';
     ev.IsRecurrence = false;
     string username = userInfo.getName();
     //  Profile p = [Select name from Profile where id =: userProfId limit 1];   
     ev.Verified_By__c = userName; 
     ev.Verification_Date__c = date.today(); 
     try{
        upsert ev;}
     catch (Exception e){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'event'));
     }
     lstEventsShow = findClientEvents(); 
  //   printReport();

   }

   public void findBoro() {
       lstEventsShow = findClientEvents();}
    //   lstEventsBrooklyn = Brooklyn(lstEventsShow);
   //    lstEventsHarlem = Harlem(lstEventsShow);       } 

  string BoroList{get;set;}
  public String getBoroList(){
     return BoroList;}
  public void setBoroList(String BoroList){ 
     this.BoroList = BoroList;}

   
   public void refreshData(){
        if (strPassed != null)
          proxyObject.activitydate = date.parse(strPassed);
       lstEventsShow = findClientEvents();
       } 

 public void saveRecord() { 
    Event evt = [select verification_status__c,time_in__c,time_out__c from event where id =: eventid];
     evt.Skip_Triggers__c = true;
     string timeout = evt.time_out__c;
     if (fieldName == 'Attendance'){ 
         evt.verification_status__c = fieldValue;
         if (fieldValue <> 'Attended' && fieldValue <> 'Late' ){
            evt.Time_In__c = '';
            evt.Time_Out__c = '';}  
         else{
           if (evt.verification_status__c == 'Attended'){
               evt.Time_In__c  = ut.defaultAttendanceTimes(fielddatetime, fieldDuration, true);
               evt.Time_Out__c  = ut.defaultAttendanceTimes(fielddatetime, fieldDuration, false);}         }
     }
     if (fieldName == 'Time In'){evt.Time_In__c = fieldValue;} 
     if (fieldName == 'Time Out') 
         evt.Time_Out__c = fieldValue;
 //    Id userProfId = userInfo.getProfileId();
     string username = userInfo.getName();
     //  Profile p = [Select name from Profile where id =: userProfId limit 1];   
       evt.Verified_By__c = userName; 
       evt.Verification_Date__c = date.today();
      update evt;
      lstEventsShow = findClientEvents(); }  
      
   
 }