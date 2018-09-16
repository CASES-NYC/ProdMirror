public with sharing class scheduleMandatoryController{
    public String contPassed = System.currentPagereference().getParameters().get('contactPassed');    
 
    public List<SelectOption> ContactNames{get;set;}
    public boolean wrongdateFrom{get;set;}
    public boolean isSandbox{get;set;}
    public boolean fromContact{get;set;}     
    public string attendanceValue{get;set;}
    public string dateto{get;set;}
    public string eventId{get;set;}
   
    public boolean actionProcess{get;set;} 
    public UtilityTimeMethods ut = new UtilityTimeMethods();    
    public reportQuery rq = new reportQuery();
    public utilityIds utilIds = new utilityIds();

    boolean allAssDone{get;set;}
    public date dintake{get;set;}
    public string sintake{get;set;}
    public date dueDate{get;set;}
    public string sDueDate{get;set;}
    public string userName{get;set;}
        
    public scheduleMandatoryController(){
        string loginName = UserInfo.getUserName();
        if (loginname.right(9) == 'cases.org')
           isSandbox = false;
        else    
           isSandbox = true;
       ID userId = userInfo.getUserId();
      User u = [select name from user where id =: userId];
      userName = u.name;           
  
     Event e = new Event();
     e.open_date__c =  date.today().toStartofWeek() - 14;
  //   e.closing_date__c = date.today();
     proxyObject = e; 
     dateto = date.today().format();
      if (contPassed != null && contPassed != ''){
        contactselected = contPassed;
        fromContact = true;
        e.open_date__c = date.today();
        findClientEvents();
        contPassed = '';}
        
       ContactNames = findContactNames();}

    public string ClientName{get;set;} 
    public string firstName{get;set;} 
    public string lastName{get;set;} 
    public string assType{get;set;} 
    public string assessId{get;set;}
    public class assessClass{
    public string assName{get;set;}
    public string assDate{get;set;}
    public string assWho{get;set;}
    public string assId{get;set;}
    public string recTypeId{get;set;}
    public boolean assDone{get;set;}
    public string namestring{get;set;}
    public string asscolor{get;set;}
    public string assStatus{get;set;}
    public string fontweigt{get;set;}
    public string assIcon{get;set;}}
    
    public class clsOtherEvents{
    public string other{get;set;}}
        
    public class clsAvailableClasses{
       public Boolean futureApps {get;set;}   
      public string plAttendance{get;set;}   
      public string classdate{get;set;}         
      public string classname{get;set;}         
      public string coursename{get;set;}         
      public string classfullname{get;set;}         
      public string dow{get;set;}       
      public string timefrom{get;set;}         
      public string  timeto{get;set;}         
      public string ctime{get;set;}         
     public boolean enrolled{get;set;}         
      public string verstatus{get;set;}         
      public string sessionId{get;set;}         
      public integer maxsize{get;set;}         
      public integer canenroll{get;set;}         
      public string contactid{get;set;}
      public string classesId{get;set;} 
      public date eventdate{get;set;}
      public datetime eventdatetime{get;set;}
      public integer duration{get;set;}
      public string eventsubject{get;set;}
      public string classColor{get;set;}
      public string fontweigt{get;set;}
      public string scheduled{get;set;}
      public string eventid{get;set;}
      public Boolean showclass{get;set;}
      public List<Event> lstOtherEvents {get;set;}
      public String color {get;set;}
      public String backcolor{get;set;}
      public boolean disableEnroll{get;set;}
      } 

      public String displayContact{get;set;}
      public string contactselected{get;set;}
      public string contactselected15{get;set;}
    
      public Event proxyObject {get; set;}  
      public Task obj4duedates {get; set;}  
   //   public string SelectedId{get;set;}  
      public String ContactList{get;set;}
      public Map<id,string> mapIdName = new Map<id,string>();
   
      public List<SelectOption> findContactNames(){
  
    Set<ID> IdsforAssign = new set<ID>(); 
    string name;
    ID contid;
     List<SelectOption> option = new List<SelectOption>();
     option.clear();
     integer i = 0;
    List<Contact> lstContact = new List<Contact>();
     wrongdateFrom = false;
    if (proxyobject.Open_Date__c > date.today()){
       wrongdateFrom = true;
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Intake Date can not be after today.'));}

    String cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
    List<Contact> lstAllContact = [select id, name,Reporting_Borough__c from contact  
         where  Current_Intake_Date__c >=: proxyobject.Open_Date__c  and 
         RecordTypeId =: cepClient order by name];
     
    if (lstAllContact.Size() == 0 && wrongdateFrom == false && contPassed == null)
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning,'No Intakes from ' + proxyobject.Open_Date__c.format() + '.'));
    else{          
    if (selectedBoro == null || selectedBoro == 'All')
        lstContact = lstAllContact;
    else 
        for (Contact cnt : lstAllContact){ 
          if (cnt.Reporting_Borough__c == selectedBoro)
              lstContact.add(cnt);}
     for (Contact cnt : lstContact){
        if (i == 0) 
              option.add(new Selectoption('111111111111111111', '--Select--'));
              name = cnt.name;
              contid = cnt.id;
              option.add(new Selectoption(contid, name));
             mapIdName.put(contid, name);
              i++;}
       if (i == 0)
           option.add(new Selectoption('', ''));
    }       
      return option;}
     
     public date searchClassesFrom; 
     public void findClientEvents() {
         
           if (contactselected == '111111111111111111'){
               contactSelected = '';
              return;}
       
       actionProcess = true;
          contactselected15 = contactSelected.substring(0,15);
        Map<id,contact> mapContact = rq.contactQueryIDstring(contactselected);
      clientName = mapContact.get(contactselected).name;
      lastname = mapContact.get(contactselected).lastname;
      firstname = mapContact.get(contactselected).firstname;
      dintake = mapContact.get(contactselected).Current_Intake_Date__c;
      if (dintake != null){
          sintake = dintake.format();            
          dueDate = rq.countDueDate(dintake,11);
          sDueDate = dueDate.format();}
       else{ 
               sintake = '  /  /    ';
               dintake = date.today() ;
               dueDate = rq.countDueDate(date.today(),11);
               sDueDate = dueDate.format();
            }
  

System.Debug('\n\n XXX searchClassesFrom: ' + searchClassesFrom);
            Task c = new Task();
     //       c.Closing_Date__c = dintake;
            c.Open_Date__c  = dueDate;
            if (proxyobject.Open_Date__c > date.today()){
              c.Open_Date__c-=300000;
            }  
        
            obj4duedates = c; 
        lstMandatoryAvailableShow = findLstMandatoryAvailableShow();
        //lstAssDisplay = findLstAssessInfo(contactselected); 
             showCreateCmd = true;}
  
    public List<clsAvailableClasses> lstMandatoryAvailableShow{get;set;}

   public string CousesIds{get;set;}  
 public     integer searchRange{get;set;}
   public List<clsAvailableClasses> findLstMandatoryAvailableShow(){
       string cname,sub,cid;
 
     if (proxyobject.Closing_Date__c == null)  
          proxyobject.Closing_Date__c = dintake;   
     if (proxyobject.Closing_Date__c <> dintake)
         searchClassesFrom = proxyobject.Closing_Date__c;     
       else
         searchClassesFrom = dintake;
     if (searchClassesFrom > dueDate){   
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please check date range for classes search.'));
         return null;   
       }          
       else{
         searchRange = searchClassesFrom.daysBetween(dueDate);
       if (searchClassesFrom.daysBetween(dueDate) > 31){   
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please make date range for search classes no more than one month.'));
         return null;   
       }  }

System.Debug('\n\n XXX searchRange: ' + searchRange);
      String attendedCoursesName = '';   
      integer pos;
      List<clsAvailableClasses> lstavailable = new List<clsAvailableClasses>(); 
      clsAvailableClasses available = new clsAvailableClasses(); 
      Set<String> clsIds = new Set<string>();
      Set<String> clsIdsinSess = new Set<string>();
      Map<id,string> MapclsNames = new Map<id,string>();   
      Map<id,string> MapclsTitle = new Map<id,string>();   
      Map<id,integer> MapclsSize = new Map<id,integer>();
      List<Class__c> clsList = new List<Class__c>();
      Set<String> sessIds = new Set<String>();
      Set<String> classIdsAll = new Set<String>();
      Set<Id> setCEPCourses = new Set<Id>();   
      string idName,idName1;
      Map<id,string> mapCourses  = new  Map<id,string>(); 

      List<Course__c> lstcourses = selectCourses();
      
      for (Course__c cr: lstcourses){
                   setCEPCourses.add(cr.id);}
        List<Session__c> lstSessionAll = [Select Session_Start__c, Session_End__c,id,
        Course_Name__c, Course_Category__c, Course_Area__c, ClassId__c From Session__c 
        where Session_Start__c >= : searchClassesFrom and Session_Start__c <= : dueDate  
        and Course_Category__c =: 'Mandatory Class' 
         order by Session_Start__c,Course_Name__c];
        for (Session__c lstS : lstSessionAll){
          classIdsAll.add(lstS.ClassId__c);
          sessIds.add(lstS.id);}

      List<Class__c> clsAllList = [SELECT Id, CategoryRPT__c, AreaRPT__c, Class_Title__c, 
           Section__c,No_of_Sessions_Scheduled__c,Class_Location__c,
           Suggested_Max_Size__c ,First_Session_On__c, RecordTypeId from class__c
           where id in: classIdsAll and
           (recordtypeid =: utilIDs.classOngoing or recordtypeid =:  utilIDs.classSingle) 
           and Course__c in : setCEPCourses 
           order by Class_Title__c];
     
      if (selectedClassBoro == null || selectedClassBoro == 'All')
         clsList = clsAllList; 
      else
          for (Class__c cls : clsAllList){ 
             if (cls.Class_Location__c  == selectedClassBoro)
                clsList.add(cls);}
      integer a = 0; 
      for (Class__c cls : clsList){
           a = 0;
           sub = cls.Class_Title__c;
           cname = sub.substringBeforeLast('-').trim();
           MapclsNames.put(cls.id,cls.Class_Title__c);
           MapclsTitle.put(cls.id,cls.Class_Title__c);
           if (cls.Suggested_Max_Size__c != null)
            a = integer.valueof(cls.Suggested_Max_Size__c);
           MapclsSize.put(cls.id,a);
           cid = string.valueOf(cls.id).substring(0,15);
           clsIds.add(cid);}
    List<Session__c> lstSession = new List<Session__c>();
    for (Session__c s :  lstSessionAll){
      if (clsIds.contains(s.ClassId__c))
      lstSession.add(s);}

     List<Event> lstSessionsInEvents = [Select activitydate,activitydatetime, Verification_Status__c,
          whoid,whatid, Subject, Class_Category__c from event where 
          activitydate >=: searchClassesFrom and activitydate <= : dueDate and Class_Category__c = 'Mandatory Class'];
      string attendedCourseName = '';
      string timefrom, timeto;
      decimal d;
      boolean attendance;
      String attendedCourses = '';
      attendedCourses = '';
      integer k = 0;
      string name1;
      integer nRow = 1;
      integer inEvent = 0;
      Set<String> classIds = new Set<String>();
      Set<String> sessionIds = new Set<String>();
      Set<DateTime> sessionDateTime = new Set<DateTime>();
      String classesScheduled = '';
      String classesVerified = '';
      for (Session__c s : lstSession){
        available = new clsAvailableClasses();
        attendance = false;
        available.scheduled = '';
        available.futureApps = false;
        available.classesId = s.ClassId__c;
        available.sessionId = s.id;
        available.coursename = s.Course_Name__c;
        available.dow = s.Session_Start__c.format('E');
        available.eventdatetime = s.Session_Start__c;
        available.eventdate = date.valueof(s.Session_Start__c);
        if (available.eventdatetime > datetime.now())
            available.futureApps = true;
        available.classdate = date.valueOf(s.Session_Start__c).format();
        timefrom = s.Session_Start__c.format('hh:mm a');
        timeto = s.Session_End__c.format('hh:mm a');
        available.duration = integer.valueOf(ut.counthours(timefrom,timeto));
         available.ctime = s.Session_Start__c.format('hh:mm a') + ' - ' + s.Session_End__c.format('hh:mm a');
        name1 = MapclsNames.get(s.classId__c);
        available.classname = name1;
        available.timefrom = s.Session_Start__c.format('hh:mm a');
        available.timeto = s.Session_End__c.format('hh:mm a');
        available.maxSize = integer.valueOf(MapclsSize.get(s.classId__c));
        available.eventsubject = MapclsTitle.get(s.classId__c);
         available.lstOtherEvents = new List<Event>();
        inEvent = 0;
        if (available.maxSize != null)
             available.canenroll = available.maxSize;
        else 
            available.canenroll = 0;
        for (integer i = 0; i < lstSessionsInEvents.Size(); i++){
             if (lstSessionsInEvents[i].whatid == s.id
                && lstSessionsInEvents[i].Verification_Status__c != 'Cancelled' 
                && lstSessionsInEvents[i].Verification_Status__c != 'Withdrawn' 
                && lstSessionsInEvents[i].Verification_Status__c != 'Excused' 
                && lstSessionsInEvents[i].Verification_Status__c != 'Unexcused' 
                ) 
             available.canenroll--;

            if (lstSessionsInEvents[i].whoid == contactSelected){
                if (lstSessionsInEvents[i].whatid == s.id) {
                   if (lstSessionsInEvents[i].Class_Category__c == 'Mandatory Class'){
                      available.eventid = lstSessionsInEvents[i].id;
                      available.verstatus = lstSessionsInEvents[i].Verification_Status__c;
                      if (available.verstatus == 'Cancelled' || available.verstatus == 'Withdrawn'
                        || available.verstatus == 'Excused' || available.verstatus == 'Unexcused'){
                         available.enrolled = true;
                       classesVerified = classesVerified + available.eventid;}
                       
                      else
                         available.enrolled = true;
                      if (available.verstatus == 'Attended' || available.verstatus == 'Not Verified'){
                         attendedCourseName += s.Course_Name__c;                        
                         attendedCourses =  attendedCourses + s.Course_Name__c + s.id;
                         classesScheduled = classesScheduled + available.coursename + available.classdate;}
                         
                      if (available.verstatus != 'Cancelled' 
                         && available.verstatus != 'Withdrawn'
                         && available.verstatus != 'Excused' && available.verstatus != 'Unexcused'){
                         classIds.add(s.ClassId__c);
                         sessionIds.add(s.id);
                         sessionDateTime.add(available.eventdatetime);}}}     
                else{
                  if (lstSessionsInEvents[i].activitydatetime == available.eventdatetime){
                    if (lstSessionsInEvents[i].Verification_Status__c != 'Cancelled' &&
                        lstSessionsInEvents[i].Verification_Status__c != 'Withdrawn'
                        && lstSessionsInEvents[i].Verification_Status__c != 'Excused' 
                        && lstSessionsInEvents[i].Verification_Status__c != 'Unexcused'){
                        available.lstOtherEvents.add(lstSessionsInEvents[i]);
                        if (available.scheduled == '')
                           available.scheduled = lstSessionsInEvents[i].subject;
                        else{   
                          available.scheduled = available.scheduled + ', ' + 
                      lstSessionsInEvents[i].subject;}}}}}}
                         
      available.contactid = contactSelected;        
       available.classColor = 'black';
        available.fontweigt = 'normal';       
       if (math.mod(nRow,2) == 0)
          available.backcolor = '#AFEEEE';
       else 
          available.backcolor = '#FFFFFF';       
       if (available.verstatus == 'Attended'){
           available.classColor = 'green';
           available.fontweigt = 'bold';}
      lstavailable.add(available); 
          nRow ++;}   
     List<clsAvailableClasses> lstCorrected = new List<clsAvailableClasses>();
     string chkSched = ''; 
     
       for (clsAvailableClasses clsSelected : lstavailable){
         clsSelected.disableEnroll = false; 
         chkSched = clsSelected.coursename + clsSelected.classdate;
         if (clsSelected.eventid != null)
             chkSched = chkSched + clsSelected.eventid;
       if (classesScheduled.contains(chkSched) ){
            clsSelected.disableEnroll = true;
         }       
       if (attendedCourseName.contains(clsSelected.courseName) == true){
         if (clsSelected.verstatus == 'Attended' || clsSelected.verstatus == 'Not Verified')      
           lstCorrected.add(clsSelected);}
         else
        lstCorrected.add(clsSelected);
       }
    return lstCorrected;}   
  
     Map<id,Event> mapEvents = new Map<id,Event>([Select activitydate,activitydatetime, Verification_Status__c, whoid,whatid,
           Subject, Class_Category__c from Event where whoid =: contactSelected]);
     public Set<String> attendedSubjects = new Set<String>();
 
     public id  sessionSelected{get;set;}
    // public string contact2enroll{get;set;}
    public boolean enrolledWhenClassCreated{get;set;} 
    public void enroll(){
    //  if (isEntryError)
    //     return; 
        string timefrom, timeto;
        System.Debug('\n\n XXX sessionSelected: ' + sessionSelected + ' contactselected: '  + contactselected);
        Enrollment__c enr = new Enrollment__c();   
        string eventunit, owner; 
        for (Session__c lstSession : [Select Session_Start__c, Session_End__c,id,
        Course_Name__c, Course_Category__c, Course_Area__c, ClassId__c, Assigned_To__c  From Session__c 
        where id =: sessionselected limit 1]){
           enr.class__c = lstSession.ClassId__c;
           enr.client__c = contactselected;
           enr.Client_Class_Status_Field__c = 'Active';
           enr.Most_Recent_Enrollment__c = true;  
           eventunit = lstSession.Course_Area__c;
           owner = lstSession.Assigned_To__c;
          try{
             upsert enr; 
        //       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Client enrolled'));          
          }
          catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Enroll'));
           }
          Event ev = new Event();
           ev.whoid =  contactselected;
           ev.whatid = sessionSelected;
           ev.ActivityDateTime = lstSession.Session_Start__c;
           ev.StartDateTime = lstSession.Session_Start__c;  
           ev.ActivityDate = date.valueof( lstSession.Session_Start__c);
           timefrom = lstSession.Session_Start__c.format('hh:mm a');
           timeto = lstSession.Session_End__c.format('hh:mm a');
           ev.DurationInMinutes = integer.valueOf(ut.counthours(timefrom,timeto));
           ev.type__c = 'Face to Face';  
           ev.ClassTypeRPT__c =  Utility_ID__c.getValues('Ongoing').RecordType_Id__c;            
           ev.Verification_Status__c = 'Not Verified';
           ev.Class_Category__c = 'Mandatory Class';
           ev.recordtypeid = '012600000005JTtAAM';
           ev.IsRecurrence = false;
           ev.Unit__c = eventunit;
           ev.Area__c = eventunit;
           ev.OwnerId = owner;
           for (Class__c cls : [Select Class_Title__c,id from Class__c where id =: lstSession.ClassId__c
              limit 1]){
              ev.subject = cls.Class_Title__c;
              break;}
           try{
             upsert ev;            
           }
           catch (Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'event'));
           }
           findClientEvents();}
         enrolledWhenClassCreated = true;
    //     hideCourses();
    }

     public void Refreshinfo(){
        findClientEvents();}
     
     String[] unitAssRecTypes = new List<String>{utilIds.ccAssessmentLockedRecordType,
                                                 utilIds.ccAssessmentRecordType,
                                                 utilIds.eduAssessmentRecordType,
                                                 utilIds.eduAssessmentLockedRecordType,
                                                 utilIds.psyAssessmentRecordType,
                                                 utilIds.psyAssessmentLockedRecordType,
                                                 utilIds.subAbuseAssessmentRecordType,
                                                 utilIds.subAbuseAssessmentLockedRecordType };   
             
     Map<string,string> mapAssName = new Map<string,string>();
     public List<assessClass> lstAssDisplay{get;set;}
 /*
     public List<assessClass> findLstAssessInfo(string contactselected){
         mapAssName.put(utilIds.ccAssessmentRecordType,'Case Management');
         mapAssName.put(utilIds.ccAssessmentLockedRecordType,'Case Management');
         mapAssName.put(utilIds.eduAssessmentRecordType,'Education');
         mapAssName.put(utilIds.eduAssessmentLockedRecordType,'Education');
         mapAssName.put(utilIds.psyAssessmentRecordType,'Psychosocial');
         mapAssName.put(utilIds.psyAssessmentLockedRecordType,'Psychosocial');
         mapAssName.put(utilIds.subAbuseAssessmentRecordType,'Health &Drug');
         mapAssName.put(utilIds.subAbuseAssessmentLockedRecordType,'Health &Drug');
 
         List<assessClass> lstAssFind = new List<assessClass>();
         assessClass oneRecord = new assessClass();
         String aas_in_db = ''; 
         string rectypes_in_db = '';
         for (Assessment__c ass_in_db :[Select Assessment_Completed_on__c, Assessment_Completed_by__c,
             recordtypeid,id From Assessment__c where contact__c =:contactselected and
             recordtypeid in: unitAssRecTypes]){
                rectypes_in_db += ass_in_db.RecordTypeId;
                oneRecord = new assessClass();
                oneREcord.recTypeId = ass_in_db.recordtypeid;
                oneRecord.assDone = true;
                oneREcord.assName = mapAssName.get(ass_in_db.recordtypeid);               
                oneRecord.namestring = firstname + '+' + lastname;
                oneRecord.asscolor = 'black';
                oneRecord.fontweigt = 'normal';
                oneRecord.assId = ass_in_db.Id;
                if (ass_in_db.Assessment_Completed_on__c == null){
                   oneRecord.assStatus = 'in Progress';
                   oneRecord.asscolor = 'black';
                   oneRecord.fontweigt = 'normal';}
                else {
                   oneRecord.assStatus = 'Completed';
                   oneRecord.asscolor = 'green';
                   oneRecord.fontweigt = 'bold';}
              if (ass_in_db.Assessment_Completed_on__c != null)     
                 oneRecord.assDate = ass_in_db.Assessment_Completed_on__c.format();
              oneRecord.assWho = rq.findUserName(ass_in_db.Assessment_Completed_by__c);
              lstAssFind.add(oneRecord);
        }
        if (rectypes_in_db.contains(utilIds.ccAssessmentRecordType) == false && 
            rectypes_in_db.contains(utilIds.ccAssessmentLockedRecordType) == false){
            oneRecord = new assessClass();
            oneRecord.assDone = false;
            oneRecord.assStatus = 'To Do';
            oneRecord.assId = utilIds.ccAssessmentRecordType;
            oneREcord.assName = 'Case Management';
            oneRecord.namestring = firstname + '+' + lastname;
            oneRecord.asscolor = 'black';
            oneRecord.fontweigt = 'normal';             
            lstAssFind.add(oneRecord);}
            
        if (rectypes_in_db.contains(utilIds.eduAssessmentRecordType) == false && 
            rectypes_in_db.contains(utilIds.eduAssessmentLockedRecordType) == false){
            oneRecord = new assessClass();
            oneRecord.assDone = false;
            oneRecord.assStatus = 'To Do';
            oneRecord.assId = utilIds.eduAssessmentRecordType;
            oneREcord.assName = 'Education';
            oneRecord.namestring = firstname + '+' + lastname;
            oneRecord.asscolor = 'black';
            oneRecord.fontweigt = 'normal';             
            lstAssFind.add(oneRecord);}
            
        if (rectypes_in_db.contains(utilIds.psyAssessmentRecordType) == false && 
            rectypes_in_db.contains(utilIds.psyAssessmentLockedRecordType) == false){
            oneRecord = new assessClass();
            oneRecord.assDone = false;
            oneRecord.assStatus = 'To Do';
            oneRecord.assId = utilIds.psyAssessmentRecordType;
            oneREcord.assName = 'Psychosocial';
            oneRecord.namestring = firstname + '+' + lastname;
            oneRecord.asscolor = 'black';
            oneRecord.fontweigt = 'normal';             
            lstAssFind.add(oneRecord);}
            
        if (rectypes_in_db.contains(utilIds.subAbuseAssessmentRecordType) == false && 
            rectypes_in_db.contains(utilIds.subAbuseAssessmentLockedRecordType) == false){
            oneRecord = new assessClass();
            oneRecord.assDone = false;
            oneRecord.assStatus = 'To Do';
            oneRecord.assId = utilIds.subAbuseAssessmentRecordType;
            oneREcord.assName = 'Health & Drug';
            oneRecord.namestring = firstname + '+' + lastname;
            oneRecord.asscolor = 'black';
            oneRecord.fontweigt = 'normal';             
            lstAssFind.add(oneRecord);}
        return lstAssFind;}
  */           
        public void saveRecord() { 
           Event evt = new Event(id=eventId);
           evt.verification_status__c   = attendancevalue; 
         evt.Verification_Date__c = System.Today();
         evt.Verified_By__c = UserInfo.getName();
         try{      
            update evt;}          
         catch (Exception e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'record NOT Saved'));}
          findClientEvents1();} 

     public string cdueDate{get;set;}
     public void findClientEvents1() {
      if (obj4duedates != null){  
      if (obj4duedates.Open_Date__c < dintake){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Due Date (Classes through) can not be before date of Intake.'));
         }
      else{
         dueDate = obj4duedates.Open_Date__c + 1;
  
        if (lstMandatoryAvailableShow != null)    
           lstMandatoryAvailableShow.clear();
        if (lstAssDisplay != null)
            lstAssDisplay.clear();
        lstMandatoryAvailableShow = findLstMandatoryAvailableShow();
        //lstAssDisplay = findLstAssessInfo(contactselected);
        }}   
     }
          public string selectedBoro{get;set;} 
         public void findBoro() {  
           actionProcess = true;
        //   contactSelected = '111111111111111111';
           ContactNames = findContactNames();
           showCreateCmd = false;
           if (lstMandatoryAvailableShow !=null)
           lstMandatoryAvailableShow.clear();}
        string BoroList{get;set;}
        public String getBoroList(){
        return BoroList;}
       public void setBoroList(String BoroList){
        this.BoroList = BoroList;}
        
public List<SelectOption> getBoro() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('All', 'All'));
      options.add(new SelectOption('Brooklyn', 'Brooklyn'));
      options.add(new SelectOption('Harlem', 'Harlem'));
      options.add(new SelectOption('Queens', 'Queens'));
      options.add(new SelectOption('510 Gates Ave', '510 Gates Ave'));      
      return options;}        

     public List<SelectOption> getBoro4create() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      options.add(new SelectOption('Brooklyn', 'Brooklyn'));
      options.add(new SelectOption('Harlem', 'Harlem'));
      options.add(new SelectOption('Queens', 'Queens'));
      options.add(new SelectOption('510 Gates Ave', '510 Gates Ave'));      
      return options;}   

    public string selectedClassBoro{get;set;} 
    public List<SelectOption> getClassBoro() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('All', 'All'));
      options.add(new SelectOption('Brooklyn', 'Brooklyn'));
      options.add(new SelectOption('Harlem', 'Harlem'));
      options.add(new SelectOption('Queens', 'Queens'));
      options.add(new SelectOption('510 Gates Ave', '510 Gates Ave'));      
      return options;}
 
   public void findClassBoro() {
       if (lstMandatoryAvailableShow != null)
           lstMandatoryAvailableShow.clear();
        if (lstAssDisplay != null)
        lstAssDisplay.clear();
        lstMandatoryAvailableShow = findLstMandatoryAvailableShow();
        //lstAssDisplay = findLstAssessInfo(contactselected);
        }

   public  string ClassBoroList{get;set;}
   public  string ClassBoroList4create{get;set;}
   public pageReference refreshContactsList(){
        ContactNames = findContactNames();
         return null;} 
  
   public void donothing(){}    
   
   public void findCoursesNames(){
      timeInList = '';
      isEntryError= false;
      AgencyList = '';
      InstructorsList = '';
      ClassBoroList = '';
      durationList = '';
      CoursesList = '';
      classCreated = false;
      List<Course__c> lstcourses = selectCourses();
      List<SelectOption> options = new List<SelectOption>();
     options.add(new SelectOption('', ''));
        for (Course__c c : lstcourses){
            options.add(new SelectOption(c.id, c.name));}
            
     displayCourses = true;   
    proxyobject.activitydate = date.today();
     CoursesNames = options;
     findInstructors();}
     
   
   public String CoursesList{get;set;}
   public List<SelectOption> CoursesNames{get;set;}
   public boolean displayCourses {get; set;} 
   
   public void showCourses() {
      displayCourses = true;}    
   public void hideCourses() {
     findClientEvents1();    
      displayCourses = false;}    
  
  public boolean classCreated{get;set;} 
 public boolean  isEntryError{get;set;} 
  public string selectedCourse{get;set;} 
  public string selectedClassLocation{get;set;} 
  public string selectedAgency{get;set;}   
  public string selectedInstructor{get;set;}
    public void saveClass(){
      isEntryError = false;  
      classCreated = false;
      Id accExternalEntities = Utility_Id__c.getValues('External Entities').RecordType_Id__c;
      Id classRecType = Utility_Id__c.getValues('Single').RecordType_Id__c;
      Id scheduleRecType = Utility_Id__c.getValues('Single Schedule').RecordType_Id__c;
      System.Debug('\n\n XXX in class save: ');
 
    if (selectedCourse == '' || selectedClassLocation == '' || selectedAgency == '' || selectedInstructor == '' 
        || selectedTimeIn == '' || selectedDuration == ''){
      isEntryError  = true;
        return;}
     Class__c cls = new Class__c();
    cls.Course__c = selectedCourse;    
    cls.Agency__c = selectedAgency;
    cls.class_location__c = selectedClassLocation;
    cls.programs_served__c = 'CEP';
    cls.recordtypeid = classRecType;
    cls.subtitle__c = selectedTimeIn + ' *';
    cls.instructor_1__c = selectedInstructor;
    cls.default_Ending_Session__c = 'Single session only';
    cls.default_Starting_Session__c = 'Single session only';
    cls.Suggested_Max_Size__c = 1;
    cls.No_of_Sessions_Scheduled__c = 1;
    cls.Class_Description__c = 'Class created from Client Mandatory page';
    cls.Last_Session_On__c = proxyobject.activitydate;   
    cls.First_Session_On__c = proxyobject.activitydate;   
    insert cls;
 
    Schedule__c sc = new Schedule__c(); 
    sc.RecordTypeId = scheduleRecType;
    sc.UI_Start_Date__c = proxyobject.activitydate;
    string sdate = proxyobject.activitydate.format();
    string sStart = sdate + ' ' + selectedTimeIn;
    sc.Start_Date__c =  DateTime.parse(sStart);
    integer d = integer.valueOf(selectedDuration);
    string tEnd = ut.endtime(selectedTimeIn, d);
    string sEnd = sdate + ' ' +  tEnd;

    datetime dt =  DateTime.parse(sEnd);
    sc.End_Date__c = DateTime.parse(sEnd);
    sc.class__c =  cls.id;
    insert sc;   
    
    string classId = cls.id;
    string scheduleId = sc.id;
    
    List<Session__c> lstSession = [select id from  Session__c 
       where schedule__c  =: scheduleId limit 1]; 
    sessionSelected = lstSession[0].id; 
    
    classCreated = true;
 //   contactSelected = contPassed;
    enroll();
    findClientEvents1();
    sendEmail(cls.instructor_1__c,sStart,sessionSelected,selectedClassLocation,selectedDuration);
    }
 
    public List<Course__c> selectCourses(){
      List<Course__c> listCourses = new List<Course__c>();
       listCourses = [Select Programs_Served__c, Id, Category__c, Area__c,name From Course__c
            where Category__c =: 'Mandatory Class' and programs_served__c =: 'CEP' order by name];
      return listCourses;}
    
   string AgencyList{get;set;}
        public String getAgencyList(){
        return AgencyList;}
       public void setAgencyList(String AgencyList){
        this.AgencyList = AgencyList;} 
   public List<SelectOption> getAgency() {
       Id accExternalEntities = Utility_Id__c.getValues('External Entities').RecordType_Id__c;
      List<SelectOption> options = new List<SelectOption>();
  //    options.add(new SelectOption('00111000019BSTK', 'CASES'));
      List<Account> lstAgency = [Select id,name from account where 
            recordtypeId =: accExternalEntities and   
           agency_type__c !=: '' order by name]; 
      Id  CASESid; 
      for (Account a : lstAgency){
          if (a.name == 'CASES'){
             options.add(new SelectOption(a.id, 'CASES'));
         break;    }
      }
      /*
      for (Account c : lstAgency){
          if (c.name != 'CASES')
             options.add(new SelectOption(c.id, c.name));
      }
      */
      return options;}        
    public string selectedClassAgency{get;set;} 
 
   /* 
   public List<SelectOption> getClassBoro4Create() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      options.add(new SelectOption('Brooklyn', 'Brooklyn'));
      options.add(new SelectOption('Harlem', 'Harlem'));
      options.add(new SelectOption('Queens', 'Queens'));
      options.add(new SelectOption('510 Gates Ave', '510 Gates Ave'));      
      return options;}
 */
    string TimeInList{get;set;}
      public String getTimeInList(){
      return TimeInList;}
       public void setTimeInList(String TimeInList){
        this.TimeInList = TimeInList;} 
   string TimeIn{get;set;}     
   public List<SelectOption> getTimeIn() {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      string nextitem;
      string t_timebeg = '09:00 AM';
      options.add(new SelectOption(t_timebeg, t_timebeg));
         for (integer i = 1; i <= 7; i++){ 
      integer   iterations = 30;    
      for (integer n = 0; n < 60 ; n+=30){ 
            nextitem = ut.addItteration(t_timebeg, iterations);
            options.add(new SelectOption(nextitem,nextitem));
            t_timebeg = nextitem;}}
      options.add(new SelectOption('04:30 PM', '04:30 PM'));
      return options;}  

   public void setTimeIn(String TimeIn){ 
        this.TimeIn = TimeIn;} 

    public string selectedTimeIn{get;set;}
    public string selectedDuration{get;set;}

    string durationList{get;set;}
    public String getdurationList(){
      return durationList;}
       public void setdurationList(String durationList){
        this.durationList = durationList;} 
        
     public List<SelectOption> getduration() {
      List<SelectOption> options = new List<SelectOption>();    
      options.add(new SelectOption('', ''));
      options.add(new SelectOption('30', '30'));
      options.add(new SelectOption('60', '60'));
      options.add(new SelectOption('90', '90'));
      options.add(new SelectOption('120', '120'));
      options.add(new SelectOption('150', '150'));
     return options;}
   
    public string timeOut{get;set;}  
    public void makeTimeOut(){
         integer d = integer.valueOf(selectedDuration);
      timeOut =  ut.endtime(selectedTimeIn, d);} 

    public String InstructorsList{get;set;}       
    public List<SelectOption> InstructorsNames{get;set;}
    
    public void findInstructors(){
       String[]  profNames1 = new List<String>{'CEP - Admin Support Supervisor','CEP - Case Coordinator Staff'};
       String[]  profNames2 = new List<String>{'CEP - Deputy Director','CEP - Director','CEP - Case Coordinator'};
       String[]  profNames3 = new List<String>{'CEP - ICD Supervisor','CEP - Substance Abuse Supervisor'};
       String[]  profNames4 = new List<String>{'CEP - Substance Abuse Staff','CEP - ICD Staff'};
       String[]  profNames5 = new List<String>{'CEP - Mental Health Staff','Case Coordinator Supervisor'};

       String[] profIds =new List<String>();
       for (Profile  prof : [Select id from Profile where name  in :  profNames1 or name  in :  profNames2
            or name  in :  profNames3 or name  in :  profNames4 or name  in :  profNames5]){
       profIds.add(prof.id);}
       
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      for (User u  : [select name,id from user where profileid in:  profIds 
         and isactive =: true order by name]){
           options.add(new SelectOption(u.id,u.name));}    
      InstructorsNames = options;}
      
        public boolean showCreateCmd{get;set;}
        
   //cls.instructor_1__c,sStart,cls.id,sessionSelected     
   public void sendEmail(string instructor,string classdatetime, string session,
      string location, string duration){
//       String baseURL = URL.getSalesforceBaseUrl().toExternalForm() + 
 //      '/apex/sfCRWdocument?selectedReport='+reportPassed+'&fromMail='+'1';
       User u = [select email,firstname from user where id =: instructor];
       string instructorname = u.firstname;         
       string instremail = u.Email;  
    //   string classname,sessionname;
       Session__c s = [Select Course_Name__c From Session__c where id=:session];
       string sessionname = s.Course_Name__c; 
       string subject = 'Single class created';        
       string comment =  instructorname + ', a ' +  ' ' + 
        sessionname + ' session has been scheduled with you for ' + classdatetime + ' (' + 
        duration + 'min.)' + ' in ' +  location + ' with client ' + Clientname + ' by ' + username + 
        '. If you are not available at this time, please contact ' 
        + username + ' and IT.'; 
//        string comment = baseURL  +  '<br/>' + '<br/>' + instr + '<br/>' + '<br/>' + s1; 
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>();
     //   sendTo.add('lzykova@cases.org');
   //   sendTo.add('mmillan@cases.org');
       sendTo.add(instremail);

   //  List<User> lstMail = new List<User>();
    // sendTo.add(lstMail[i].email);
    
     Messaging.SingleEmailMessage mail = 
     new Messaging.SingleEmailMessage();
     mail.setSubject(subject);
     mail.setHtmlBody(comment);
     mail.setToAddresses(sendTo);
     
 //    System.Debug('\n\n XXX sendTo' + sendTo);
   //  return;
     mails.add(mail);
     Messaging.sendEmail(mails);
     
     }          
     
     public pageReference dataForCreateClass(){
       findCoursesNames();
       return null;
     }   
}