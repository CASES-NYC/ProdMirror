public with sharing class ProgramReportScheduleController {
   public List<CLScontactForDisplay> lst2schedule = new List<CLScontactForDisplay>();
   public String serverURL{get;set;} 
   public string timeValue{get;set;}
   public string cperiod{get{
   string d1 = convert2dateString(proxyobject.school_start_date__c);
   string d2 = convert2dateString(proxyobject.school_end_date__c);
   return 'Scheduled from ' + d1 + ' to ' + d2;}
    set;}
   public string cdateBeg;
   public string cdateEnd;
 
   private ApexPages.StandardController stdCtrl {get;set;}    
   public UtilityTimeMethods ut = new UtilityTimeMethods();
   
   public integer t_beg = 8;
   public string t_timebeg = '08:00 AM';
   public string t_timeend = '09:00 PM';
   public integer t_end = 21;
   public integer iterations = 30;
   public string t_begA  = 'AM';
   public string checkBoxId{get;set;}   
   public boolean checkBoxValue{get;set;} 
   
    public string getMessage(){   
     string textMessage = '';
     date dtFrom = proxyObject.school_start_date__c;
      date dtTo = proxyObject.school_end_date__c;
      if (dtFrom > dtTo)
        textMessage =  ' Date From can not be before Date To.'; 
      return textMessage;}

   public Id conJS = Utility_ID__c.getValues('Justice Scholars Client').RecordType_Id__c;
   public Id conCJC = Utility_ID__c.getValues('Civic Justice Corps Client').RecordType_Id__c; 
 
   public Id CM = Utility_ID__c.getValues('Case Coordination').RecordType_Id__c;

   public String[] selProgramIds = new String[]{conJS,conCJC};

   public String times = '';
   public String gettimes() {return times;}
   public void settimes(String times) {this.times = times;}
   public String[] programs = new String[]{};
 
 
  public String[] programsEmpty = new String[]{};
  public List<SelectOption> getProgramItems(){
   List<SelectOption> option = new List<SelectOption>();
   option.add(new SelectOption(conJS,'Justice Scholars Client'));
   option.add(new SelectOption(conCJC,'Civic Justice Corps Client'));
   return option;}
   public String[] getPrograms(){ 
   if (programs == programsEmpty || programs == null)
       programs = selProgramIds;
   return programs;} 
     public void setPrograms(String[] programs){
        this.programs = programs;}   
   
   public Contact proxyObject {get; set;}
   
   public ProgramReportScheduleController(){
      string RepId;
      serverURL = URL.getSalesforceBaseUrl().toExternalForm();
      string spart =serverUrl.substring(0,12);
      System.Debug('\n\n\n spart: ' + spart);
      boolean production;
      if (spart.contains('na') == true)
          RepId = '/00O600000038cdx?pv0=';
     else 
          RepId = '/00Og0000000SJwV?pv0=';
      
       serverURL += RepId;
      
   //   + '/00O6000000376Pl?pv0=';
    System.Debug('\n\n\n Server Url: ' + serverURL);
    
         //003J000000AfrEiIAJ';
                           //     '/?pv0={!c.contactForDisplay.id}'; 
         
      //   system.debug('\n\n****XXXXXXXXXXX serverURL: ' + serverURL);
     timeInValue = '08:00 AM';
     Contact c = new Contact();
 
     date dt = date.today();
     integer cm = dt.month();
     integer nm;
     date nextday = dt;
     for (integer i = 1; i<=31; i++)
     {
        nextday = nextday.addDays(1);
        nm =  nextday.month();
        if (cm <> nm)
        break;
     } 
//      system.debug('\n\n\nXXX first day: ' + nextday);
      cm = nm;
      integer y = nextday.year();
      integer dm = date.daysinmonth(y,nm);
      c.school_start_date__c = nextday;
      c.school_end_date__c = nextday.addDays(dm - 1);
      programs = selProgramIds;
      proxyObject = c; 
      TimeItems = buildTimeItems();
      Contacts = buildContacts();
  //    system.debug('\n\n****XXXXXXXXXXX inside constructor: ');
     }
//   public List<SelectOption> timeoption = new List<SelectOption>();
   public class CLScontactForDisplay {
   public Contact cont{get;set;}  
   public Boolean chk {get;set;}
   public string partname{get;set;}
   public String color {get;set;}
   public String schedUrl{get;set;}
   public integer numberOfApps{get;set;}
   public string sched_dow{get;set;}
   public integer nrow{get;set;}
   public CLScontactForDisplay(){}}     
  
    public void resetEvents(){
  
    //   TimeItems = buildTimeItems();
       Contacts.Clear();
       Contacts = buildContacts();}
  
   public integer nLimit{get;set;}
   public List<CLScontactForDisplay> Contacts{get;set;}
    public List<CLScontactForDisplay> buildContacts(){
       if (getMessage() <> '')
        return null; 
        if (programs == programsEmpty || programs == null)
         programs = selProgramIds;
           string lvid15;
       integer nrow = 1;
       System.Debug('\n\n\nXXX Inside buildcontact programs: ' + programs);
       integer nSize;
       integer i = 0;
       string dayOfWeek = '';
       string s_dow;
       List<Event>  lstAppsInPeriod = [select whoid, activitydate, isrecurrence from event where
               subject = 'Program Reporting' 
               and activitydate >=: proxyObject.school_start_date__c
               and activitydate <=: proxyObject.school_end_date__c
               and subject = 'Program Reporting'
               and IsRecurrence = false];
       for (Contact c : [select firstname, lastname, id, P_C_ID__c  from contact
          where Client_Status__c =: 'Active' and 
          recordtypeid in : programs order by firstname ]){
          CLScontactForDisplay ClientForDisplay = new CLScontactForDisplay();
          ClientForDisplay.cont = c;
          ClientForDisplay.chk = false;
          lvId15 = c.id;
          ClientForDisplay.schedUrl = lvId15.left(15);
          ClientForDisplay.numberOfApps = 0;
          s_dow = '';
          for (Event evtSched : lstAppsInPeriod)
          {
            
              if (evtSched.whoid == c.id)
              {
                ClientForDisplay.numberOfApps++;
                if (evtSched.isrecurrence == false )
                {
                  dayOfWeek = DateTime.newInstance(evtSched.activitydate, 
                    Time.newInstance(0, 0, 0, 0)).format('EEEE');                   
                  if (s_dow == '')
                        s_dow = dayOfWeek;
                  else 
                       { 
                   if (s_dow.contains(dayOfweek) == false)
                            s_dow = s_dow + ', ' +  dayOfWeek;
                       }
                }
              }
          }
           ClientForDisplay.sched_dow = s_dow;
          nrow++;
          if (math.mod(nrow,2) == 0)
             ClientForDisplay.color = '#0000FF';
          else 
              ClientForDisplay.color = '#800000';   
          lst2schedule.add(ClientForDisplay);
          i++;
     //     if (lTest == true && i == 1)
       //       break;

       } 
         
      return lst2schedule;} 
   
      public List<SelectOption> TimeItems{get;set;}
      
      public List<selectOption> buildTimeItems()
      {
          system.debug('\n\n\nXXX in buildTimeItems');
         List<SelectOption> timeoption = new List<SelectOption>();
      //    timeoption.clear();
          timeoption.add(new SelectOption('', '--------------'));
          date dtToday = date.today();
          string nextitem;
          string h_part = t_timebeg.substring(0,2);
          string am_part;
          integer t_beginning = integer.ValueOf(h_part);
          integer hours = t_end - t_beg;
          nextitem = ut.addItteration(t_timebeg, iterations);
          timeoption.add(new SelectOption(t_timeBeg,t_timeBeg));
          for (integer i = 1; i <= hours; i++){   
             for (integer n = 0; n < 60 ; n+=iterations){ 
                if (t_timebeg.trim() == t_timeEnd )
                   break;
                  nextitem = ut.addItteration(t_timebeg, iterations);
                timeoption.add(new SelectOption(nextitem,nextitem));
                t_timebeg = nextitem;}}
           return  timeoption;
     }    

       public List<SelectOption> TimeOutItems1{get;set;}
       public List<SelectOption> TimeOutItems2{get;set;}
       public List<SelectOption> TimeOutItems3{get;set;}
       public List<SelectOption> TimeOutItems4{get;set;}
       public List<SelectOption> TimeOutItems5{get;set;}
//       public List<SelectOption> getTimeOutItems(){
  
       public List<SelectOption> buildTimeOutItems(string timeInValue){
        
       System.Debug('\n\n\n XXX getTimeOutItems  timein ' + timeInValue);
       t_timebeg = timeInValue; 
       List<SelectOption> timeoption = new List<SelectOption>();
       timeoption.add(new SelectOption('', '--------------'));
       if (timeInValue == '')
         return timeoption;
      System.Debug('\n\n\nXXX Inside getTimeOutItems t_timeBeg: ' + t_timeBeg);
      date dtToday = date.today();
      string nextitem;
      string h_part = t_timebeg.substring(0,2);
      string am_part;
      integer t_beginning = integer.ValueOf(h_part);
      integer hours = t_end - t_beg;
      nextitem = ut.addItteration(t_timebeg, iterations);
      timeoption.add(new SelectOption(t_timeBeg,t_timeBeg));
      for (integer i = 1; i <= hours; i++){   
         for (integer n = 0; n < 60 ; n+=iterations){ 
            if (t_timebeg.trim() == t_timeEnd )
               break;
              nextitem = ut.addItteration(t_timebeg, iterations);
            timeoption.add(new SelectOption(nextitem,nextitem));
            t_timebeg = nextitem;}}
   return  timeoption;}   
  

  public pageReference doNothing(){
     return null;}
 
   public pageReference cmdAction()
   {
    return null;
   }
     public void scheduleClients(){
      cDateBeg = convert2dateString(proxyobject.school_start_date__c);
      string tbeg;
      if (mask1 == 0 && mask2 == 0 && mask2 == 0 && mask4 == 0 && mask5 == 0)
      {  // give a message
         return;
      }
      string s_date;
      system.debug('\n\n\n XXX s_date: ' + s_date);
      datetime dt;
      List<Id> listContactIds = new List<Id>();
      for(CLScontactForDisplay cd : lst2schedule)
         {
           if(cd.chk) 
             listContactIds.add(cd.cont.Id); 
         } 
      integer lstsize = listContactIds.size();
       System.Debug('\n\n\nXXX checked list: ' +  lstsize);   
     if (mask1 <> 0 && in1 <> null && out1 <> null){
           s_date = cDateBeg + ' ' + in1;
           dt = datetime.parse(s_date);
           System.Debug('\n\n\nXXX inside mask1 date: ' + dt + ' in1: ' + in1 + ' out1: ' + out1 +
           ' mask1: ' + mask1);   
         integer i;        
         for(Id idClient : listContactIds)
         {
             insertSchedule(in1, out1, mask1, dt, idClient);
             System.Debug('\n\n\nXXX for loop in mask1 i: ' + i); 
             i++;
          }
      }
      if (mask2 <> 0 && in2 <> null && out2 <> null){
         s_date = cDateBeg + ' '+ in2;
         dt = datetime.parse(s_date);
         for(Id idClient : listContactIds)
         {   
             System.Debug('\n\n\nXXX Inside second loop');
             insertSchedule(in2, out2, mask2,dt,  idClient);
          }
       } 
       if (mask3 <> 0 && in3 <> null && out3 <> null){
         s_date = cDateBeg + ' '+ in3;
           dt = datetime.parse(s_date);
         for(Id idClient : listContactIds)
         {   
           System.Debug('\n\n\nXXX Inside second loop');
           insertSchedule(in3, out3, mask3,dt, idClient);
          }
       } 
      if (mask4 <> 0 && in4 <> null && out4 <> null){
          s_date = cDateBeg + ' '+ in4;
          dt = datetime.parse(s_date);
 
       for(Id idClient : listContactIds)
         {   
              System.Debug('\n\n\nXXX Inside second loop');
                 insertSchedule(in4, out4, mask4, dt, idClient);
          }
       }  
      if (mask5 <> 0 && in5 <> null && out5 <> null){
          s_date = cDateBeg + ' '+ in5;
          dt = datetime.parse(s_date);
 
        for(Id idClient : listContactIds)
         {   
              System.Debug('\n\n\nXXX Inside second loop');
              insertSchedule(in5, out5, mask5, dt, idClient);
          }
       }
      resetEvents();
      selectedInfo = 'Schedule Completed!';
       
     }

      public string timeInValue {get;set;}
  
      public void  PK_timeInValue1()
      {
         System.Debug('\n\n\n XXX PK_timeInValue  timein ' + timeInValue) ;
         t_timebeg = timeInValue; 
         TimeOutItems1 = buildTimeOutItems(t_timebeg);
      }    
    public void  PK_timeInValue2()
      {
         System.Debug('\n\n\n XXX PK_timeInValue  timein ' + timeInValue) ;
         t_timebeg = timeInValue; 
         TimeOutItems2 = buildTimeOutItems(t_timebeg);
      }    
          public void  PK_timeInValue3()
      {
         System.Debug('\n\n\n XXX PK_timeInValue  timein ' + timeInValue) ;
         t_timebeg = timeInValue; 
         TimeOutItems3 = buildTimeOutItems(t_timebeg);
      }    
          public void  PK_timeInValue4()
      {
         System.Debug('\n\n\n XXX PK_timeInValue  timein ' + timeInValue) ;
         t_timebeg = timeInValue; 
         TimeOutItems4 = buildTimeOutItems(t_timebeg);
      }    
          public void  PK_timeInValue5()
      {
         System.Debug('\n\n\n XXX PK_timeInValue  timein ' + timeInValue) ;
         t_timebeg = timeInValue; 
         TimeOutItems5 = buildTimeOutItems(t_timebeg);
      }    

     public string convert2dateString(date dd)
      {
        string  y = string.valueof(dd.year());
        string m = string.valueof(dd.month());
        
       if (m.length() == 1)
           m = '0' + m;
        
        string d = string.valueof(dd.day());
       if (d.length() == 1)
           d = '0' + d;

        string datestring = m + '/'+ d + '/' + y; 
        return datestring;
      }
  
     public integer mask1{get;set;} 
     public integer mask2{get;set;} 
     public integer mask3{get;set;} 
     public integer mask4{get;set;} 
     public integer mask5{get;set;} 
     
     public string  in1{get;set;}
     public string  out1{get;set;}
     public string  in2{get;set;}
     public string  out2{get;set;}
     public string  in3{get;set;}
     public string  out3{get;set;}
     public string  in4{get;set;}
     public string  out4{get;set;}
     public string  in5{get;set;}
     public string  out5{get;set;}
     
     
     public void insertSchedule(string tbeg, string tend, integer dowmask, datetime dt, string cid)
     {
        date verificationDueDate; 
        System.Debug('\n\n\nXXX Inside insertSchedule: tbeg ' + tbeg + ' tend: ' + tend);
        
        decimal duration_dec = ut.counthours(tbeg, tend); 
        integer duration = integer.valueOf(duration_dec);
        System.Debug('\n\n\nXXX Inside insertSchedule: mask ' + dowmask + ' id: ' + cid);
        System.Debug('\n\n\nXXX Inside insertSchedule: tbeg ' + tbeg + ' dt: ' +dt);
        Event masterRecord = new Event();
        masterRecord.recordtypeid = cm;
        masterRecord.recurrencetype = 'RecursWeekly';
        masterRecord.RECURRENCETIMEZONESIDKEY='America/New_York';
        masterRecord.subject = 'Program Reporting';
        masterRecord.isrecurrence = true;
        masterRecord.External_Event_ID__c = 'PRsys';
        masterRecord.recurrencedayofweekmask = dowmask;
        masterRecord.RecurrenceStartDateTime = dt;
        masterRecord.startdatetime = dt;
        masterRecord.whoid = cid;
        masterRecord.durationinminutes = duration;
        masterRecord.recurrenceinterval = 1;
        masterRecord.recurrenceenddateonly = proxyobject.school_end_date__c;
        masterRecord.Skip_Triggers__c = true;
        insert(masterRecord);
   
        ID mid = masterRecord.Id;     
        System.Debug('\n\n\n XXX masterId: ' + mid);
        integer i = 0; 
        for (Event e : [select Verification_Due_Date__c, activitydate 
          from event where isrecurrence =: false and recurrenceactivityid =: mid])
        {
          verificationDueDate = e.activitydate;
          verificationDueDate = verificationDueDate.addDays(7);
          verificationDueDate = verificationDueDate.toStartOfWeek();
          verificationDueDate = verificationDueDate.addDays(2);
          e.Verification_Due_Date__c = verificationDueDate;  
    //System.Debug('\n\n\n XXX in addDueDate: ' + verificationDueDate);
         update e;
        }
     }
 
      public string selectedInfo{get;set;}
      public void resetLabel()
      {selectedInfo = '';
       times = '';
       TimeOutItems1 = buildTimeOutItems('');
       TimeOutItems2 = buildTimeOutItems('');
       TimeOutItems3 = buildTimeOutItems('');
       TimeOutItems4 = buildTimeOutItems('');
       TimeOutItems5 = buildTimeOutItems('');
       resetEvents(); 
      }
 }