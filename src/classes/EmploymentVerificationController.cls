public without sharing class EmploymentVerificationController {
  public List<CLSEventfordisplay> events;
  public integer t_beg{get;set;} 
  public decimal HoursWorked;
  public string schedtime{get;set;}
  public string workinfo{get;set;}
  public string attendance{get;set;} 
  public string SelectedId{get;set;}  
  public String ContactList{get;set;}
  public UtilityTimeMethods ut = new UtilityTimeMethods();
 // private ApexPages.StandardController stdCtrl {get;set;}    
//  PageReference pageRef = ApexPages.currentPage();
   public Id conClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;    
   public Id conJS = Utility_ID__c.getValues('Justice Scholars Client').RecordType_Id__c;
   public Id conCJC = Utility_ID__c.getValues('Civic Justice Corps Client').RecordType_Id__c; 
  //// all programs that can be assigned to this timesheet    
//  public String[] selProgramIds = new String[]{conClient,conJS,conCJC};
  public String[] selProgramIds = new List<String>{'CE Internship Participation','Career Exploration Training','Career Exploration Support'};
  //// !!!!! all programs assigned to this timesheet 
  public Id ExternalEmployment = Utility_ID__c.getValues('Employment - External').RecordType_Id__c;
  public String[] programs = new String[]{};
  public String[] programsEmpty = new String[]{};
  public string contactID{get;set;}
  public date ActivityDate{get;set;}
  public integer t_BegDefault = 6;
  public integer t_end ;
  public string t_begA  = 'AM';
  public integer iterations = 15;
  public Event proxyObject {get; set;}  
  public List<SelectOption> getProgramItems(){
   List<SelectOption> option = new List<SelectOption>();
   option.add(new SelectOption('CE Internship Participation','CE Internship Participation'));
   option.add(new SelectOption('Career Exploration Training','Career Exploration Training'));
   option.add(new SelectOption('Career Exploration Support','Career Exploration Support'));
   return option;}
     
   public Contact clientName{get
    {Contact clientName = new Contact();
    if (selectedId <> '' && selectedId <> null)
        clientName = [select name, p_c_id__c from contact where id =: selectedId];
        return clientName;}
      set{this.clientName = clientName;}}
      
   public string clientId{get
    {string clientId = string.ValueOf(clientName.id).substring(0,15);
        return clientId;}
      set{this.clientId = clientId;}}      
 
   public void setSelectedId (){
    this.selectedId  = fieldValue ;}  
   
   public EmploymentVerificationController(){
     Event e = new Event();
     e.open_date__c =  date.today().toStartofWeek() - 6;
     e.closing_date__c = e.open_date__c + 6;
     programs = selProgramIds;
     proxyObject = e; 
   }

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
      date dtFrom = proxyObject.open_date__c;
      date dtTo = proxyObject.closing_date__c;
      Integer noOfDays = dtFrom.daysBetween(dtTo);
      if (dtFrom > dtTo)
         k = 1;
       if (noOfDays > 30)  
            k = 2;
     return k;}
   public Integer getResults(){
     Set<ID> IdsForPeriodandProgram = new set<ID>(); 
     IdsForPeriodandProgram = getContactIdForPeriodandProgram();
     List<Event> lstRes = [select id from event where subjectRPT__c in: programs and 
     activitydate >= : proxyObject.open_date__c and activitydate <= : proxyObject.closing_date__c 
     and recurrenceType = null and isrecurrence = false
     and whoid = : IdsForPeriodandProgram];
     return lstRes.size();}     
   public void resetEvents(){
    ContactList = '';
    selectedId = '';}
   public List<CLSEventfordisplay> getEvents(){
   	   System.Debug('\n\n XXX selProgramIds: ' + selProgramIds);
     List<CLSeventForDisplay> lstDE = new  List<CLSeventForDisplay>();
     HoursWorked = 0;
     CLSeventForDisplay efd = new  CLSeventForDisplay();
     System.Debug('\n\n XXX selProgramIds: ' + selProgramIds);
     for (Event evt : [select subject,activitydatetime,activitydate
            ,DurationInMinutes,verification_status__c,Time_In__c,Time_Out__c,
            whatid,what.name from event 
            where activitydate >=: proxyObject.open_date__c and activitydate <=: proxyObject.closing_date__c
            and whoid =: selectedId and subjectRPT__c in : programs and recurrenceType =: null 
            and isrecurrence =: false order by whatid,activitydatetime]){
      efd = new  CLSeventForDisplay();
      efd.eventfordisplay = evt;
      efd.dayOfWeek = DateTime.newInstance(evt.activitydate,Time.newInstance(0, 0, 0, 0)).format('EEEE');
      t_beg = t_begDefault;  
      attendance = evt.verification_status__c.trim();
      if (evt.Time_In__c == null || evt.Time_In__c == '' ){
         List<SelectOption> optionForSelect = new List<SelectOption>();
         optionForSelect.add(new SelectOption('', '--------------'));
         efd.timesIn = optionForSelect;
         efd.timesOut = optionForSelect;}
   else{schedtime = evt.activitydatetime.format('hh:mm a'); 
      efd.timesIn = BuildTimeList(schedtime, evt.activitydate, 'in');    
      efd.timesOut = BuildTimeList(evt.Time_In__c, evt.activitydate, 'out'); 
      if (evt.Time_In__c <> null && evt.Time_Out__c <> null){
          efd.actualhours = ut.counthours(evt.Time_In__c, evt.Time_Out__c);
          HoursWorked = (HoursWorked + efd.actualhours);}}
      efd.color = setColor(efd.actualhours,evt.DurationInMinutes);      
      lstDE.add(efd);}
      workinfo = 'Hours Worked: ' + string.valueof(HoursWorked/60);
      return lstDE;}
   public class CLSeventForDisplay {
   public Event eventForDisplay{get;set;}  
   public List<SelectOption> timesOut{get;set;}
   public List<SelectOption> timesIn{get;set;}
   public string dayOfWeek{get;set;}
   public decimal actualhours{get;set;}
   public String color {get;set;}}
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
     else{t_end = 23;
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
         if (t_timebeg.trim() == t_timeEnd )
            break;
            nextitem = ut.addItteration(t_timebeg, iterations);
            optionForSelect.add(new SelectOption(nextitem,nextitem));
            t_timebeg = nextitem;}}
   return  optionForSelect;}  
   public String[] getPrograms(){ 
   if (programs == programsEmpty || programs == null)
       programs = selProgramIds;
   return programs;}    
   public void setPrograms(String[] programs){
        this.programs = programs;} 
   
   public Set<ID> getContactIdForPeriodandProgram(){
     if (checkDateInput() <> 0)
        return null; 
     if (programs == programsEmpty || programs == null)
         programs = selProgramIds;
     List<ID> setContactIdForTimePeriod = new List<ID>();
     setContactIdForTimePeriod.clear();
     date dtFrom = proxyObject.open_date__c;
     date dtTo = proxyObject.closing_date__c;
     for (Event evt : [select whoid from event where subjectRPT__c in: programs 
           and activitydate >=: dtFrom and activitydate <= : dtTo and recurrenceType = null and isrecurrence = false order by who.name, activitydatetime]){ 
        setContactIdForTimePeriod.add(evt.WhoId);}     
        Set<ID> setContactIdForPeriodandProgram = new Set<ID>(); 
        setContactIdForPeriodandProgram.clear(); 
        for (Contact cnt : [select id,recordtypeid from contact where id in : setContactIdForTimePeriod]){    
             setContactIdForPeriodandProgram.add(cnt.Id);}
      return setContactIdForPeriodandProgram;} 
    public List<SelectOption> getContactNames(){
     Set<ID> IdsForPeriodandProgram = new set<ID>(); 
     IdsForPeriodandProgram = getContactIdForPeriodandProgram();
     string name;
     ID contid;
     List<SelectOption> option = new List<SelectOption>();
     option.clear();
     integer i = 0;
      for (Contact cnt : [select id, name from contact  
      where id in : IdsForPeriodandProgram order by name]){
           if (i == 0) 
              option.add(new Selectoption('', '--Select--'));
              name = cnt.name;
              contid = cnt.id;
              option.add(new Selectoption(contid, name));
              i++;}
       if (i == 0)
           option.add(new Selectoption('', ''));  
      return option;} 
    public string fieldName{get;set;}
    public string fieldValue{get;set;}
    public datetime fieldDateTime{get;set;} 
    public integer fieldDuration{get;set;}  
    public string timeInValue {get;set;}
    public string eventId {get;set;}
   public List<SelectOption> attendanceItems{ get{
       List<SelectOption> option = new List<SelectOption>();
           option.add(new SelectOption('Not Verified','Not Verified'));  
           option.add(new SelectOption('Attended',    'Attended'));
           option.add(new SelectOption('Late',        'Late'));
           option.add(new SelectOption('Unexcused',   'Unexcused'));
           option.add(new SelectOption('Excused',     'Excused'));
  return option;} set{}}
   public string setColor(decimal whours, integer schedhours){
        String color = '#000000';
        // RED
        if(whours < schedhours )
            color = '#FF0000';
            return color;}
     public void saveRecord() { 
     Event evt = [select verification_status__c,time_in__c,time_out__c from event where id =: eventid];
      string timeout = evt.time_out__c;
     if (fieldName == 'Attendance'){ 
         evt.verification_status__c = fieldValue;
         if (fieldValue <> 'Attended' && fieldValue <> 'Late' ){
            evt.Time_In__c = '';
            evt.Time_Out__c = '';}  
         else{if (evt.verification_status__c == 'Attended'){
                evt.Time_In__c  = ut.defaultAttendanceTimes(fielddatetime, fieldDuration, true);
                evt.Time_Out__c  = ut.defaultAttendanceTimes(fielddatetime, fieldDuration, false);}
            else{evt.Time_In__c = ut.convertTime(fielddatetime.hour(), true);
                evt.Time_Out__c  = ut.defaultAttendanceTimes(fielddatetime, fieldDuration, false);}}         }
       if (fieldName == 'Time In'){evt.Time_In__c = fieldValue;
           evt.Time_Out__c = evt.Time_In__c;} 
       if (fieldName == 'Time Out') 
         evt.Time_Out__c = fieldValue; 
      update evt;}
}