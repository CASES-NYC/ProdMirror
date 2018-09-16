public without sharing class courseGrading {

    ///////////////////////////////////////////
    // This method manages the Course Grading and Verification VF Page
    // Author:  AAB / DCS
    // Created:  20110510
    ///////////////////////////////////////////
    public utilityIds utilIds = new utilityIds();
    public List<SelectOption> soClass {get;set;}
    public List<SelectOption> soSession {get;set;}
    public Map<Id, clsSessionDetails> mapSessions {get;set;}
    public String strSelectedClassId {get;set;}
    public String strSelectedClassName {get;set;}
    public String strSelectedScheduleId {get;set;}
    public String strSelectedSession {get;set;}
    public clsSessionDetails sesSelected {get;set;}
    public Task tskSearch {get;set;}
    public Course__c coSearch {get;set;}
    public Boolean bDisplaySessionDetails {get;set;}
    public List<Event> sessionAttendees {get;set;}
    public Boolean bShowRoster {get;set;}
    public Boolean bShowRosterEmpty {get;set;}
    public Boolean bShowChooseSession {get;set;}
    public String sTimeZone {get;set;}  
    public Set<Id> setContactIds {get;set;}
    public Set<Id> setVerifiedAttendeeIds {get;set;}
    public String strErrorMessage {get;set;}
    public Progress_Note__c pgProgressNote {get;set;}
    public ID idCurrentContact {get;set;}
    public ID idCurrentEvent {get;set;}
    //public ID apiSessionId {get;set;}
    //public ID apiServerURL {get;set;}
    public Date dteStartDate {get;set;}
    public Date dteEndDate {get;set;}
    public Task tskDummy {get;set;}    

    //BT-301 ebg - set to hold ids of contacts who have attended the first class of the second week
    public Set<Id> setSecondWeekAttendeeIds {get;set;}  

    ////////////////////////////////////////////
    // Helper Classes
    ////////////////////////////////////////////
    public class clsStudentsToGrade {
        
        public Event evt {get;set;} 
                
    }
    
    public class clsSessionDetails {
        public Session__c session {get;set;}
        public String AssignedTo {get;set;}
        public String SessionDate {get;set;}        
        public String StartTime {get;set;}
        public String EndTime {get;set;}
    }
    
    
    //20120919 ebg - helper class for easier modification of progress notes
    public Map<Id, clsSessionAttendee> mapSessionAttendees {get;set;}
    public List<clsSessionAttendee> lstSessionAttendees {get;set;}
   
    public class clsSessionAttendee {
        public string lastfirst{get;set;}
        public Event oEvt {get;set;}
        public Progress_Note__c oProgressNote {get;set;}
        public Program_Plan__c  oProgramPlan {get;set;}
    }
    
    ////////////////////////////////////////////
    // Constructor and GET Methods
    ////////////////////////////////////////////
    public courseGrading() { 
    
        // Instanciate UI Components
        tskSearch = new Task(); // Comments = Group Note, SkipRestrictions = Cancel Class
        tskSearch.Description = '';
        tskSearch.SkipRestrictions__c = false; 
        // Create instance of "dummy task" for field formatting and set defaults based on custom setting values
        this.tskDummy = new Task();

        System_Limits__c csSystemDefaults = System_Limits__c.getInstance();

    /*///////////////////////////////////////////
        if (csSystemDefaults.Course_Catalog_Start_Date_Offset__c != null) {
            this.tskDummy.ActivityDate = System.Today().addDays(Integer.valueOf(csSystemDefaults.Course_Catalog_Start_Date_Offset__c));
        }   
            
        if (csSystemDefaults.Course_Catalog_End_Date_Offset__c != null) {
            this.tskDummy.Catalog_End_Date__c = System.Today().addDays(Integer.valueOf(csSystemDefaults.Course_Catalog_End_Date_Offset__c));
        }
    *////////////////////////////////////////////        
        coSearch = new Course__c();
                
    }
    
    ////////////////////////////////////////////
    // Action Methods
    ////////////////////////////////////////////

    public void doNothing() {  }
    
    public void initPage() {

        //get the current user's timezone
        User u = [SELECT Id, TimeZoneSidKey From User where Id = :UserInfo.getUserId()];
        this.sTimeZone = u.TimeZoneSidKey;  
             
        this.mapSessions = new Map<ID, clsSessionDetails>();
        this.sesSelected = new clsSessionDetails();
        this.sesSelected.session = null;
        this.bShowRoster = false;
        this.bShowRosterEmpty = false;
        this.bShowChooseSession = true;
        this.strErrorMessage = '';
        
        system.debug('\n\n***Inside courseGrading.  New sesSelected variable: ' + this.sesSelected + '\n');
        
        // Populate Initial List of Classes
        soClass = new List<SelectOption>();
        soClass.add(new SelectOption('','- Select Area / Category -'));
        
        // Populate Initial List of Sessions
        soSession = new List<SelectOption>();
        soSession.add(new SelectOption('','- Choose a Class -'));
        
        PageReference prCurrPage = ApexPages.currentPage();
        coSearch.Area__c = prCurrPage.getParameters().get('a');
        coSearch.Category__c = prCurrPage.getParameters().get('t');
        tskDummy.ActivityDate = Date.parse(prCurrPage.getParameters().get('s'));
        system.debug('End Date Parameter'+ prCurrPage.getParameters().get('e'));
        String prEndDate = prCurrPage.getParameters().get('e');
        if (prEndDate.length() > 0)
        {
            tskDummy.Catalog_End_Date__c = Date.parse(prCurrPage.getParameters().get('e'));
            if (tskDummy.Catalog_End_Date__c == tskDummy.ActivityDate)
                tskDummy.Catalog_End_Date__c = tskDummy.ActivityDate.addDays(1);
        }
        else
            tskDummy.Catalog_End_Date__c = tskDummy.ActivityDate.addDays(30);
        this.returnClassList();
        this.strSelectedClassId = prCurrPage.getParameters().get('c');
        if (this.strSelectedClassId != null && this.strSelectedClassId != '') {
            this.returnSessionList();
        }
        if(this.strSelectedSession != null && this.strSelectedSession != '') {
            this.bDisplaySessionDetails = true;
        } else {
            this.bDisplaySessionDetails = false;
        }
        
    }
    
    public void returnClassList() {
        //when a category is selected, locate the classes associated to it      
        this.bDisplaySessionDetails = false;
        this.bShowChooseSession = true;
        this.bShowRoster = false;
        this.bShowRosterEmpty = false;
        this.strErrorMessage = '';

        // Populate List of Classes
        List<Class__c> lstClasses = [SELECT Class_Title__c 
                                    FROM Class__c 
                                    WHERE AreaRPT__c = :coSearch.Area__c 
                                        AND CategoryRPT__c = :coSearch.Category__c 
                                        AND (RecordType.Name = 'Ongoing' OR Last_Session_On__c >= :tskDummy.ActivityDate)];
                                            //:System.Today()-60)];
        Schedule__c scSelected; 
        
        soClass = new List<SelectOption>();
        
        if(lstClasses.size() == 0) {
            soClass.add(new SelectOption('','- No Classes Found -'));
            soSession.clear();
            soSession.add(new SelectOption('','- Choose a Class -'));
            this.strSelectedClassId = null;
            this.strSelectedSession = null;
            return;
        } else {
            
            soClass.add(new SelectOption('','- Choose a Class -'));
            this.strSelectedClassId = null;
            
            for(Class__c c : lstClasses) {
                soClass.add(new SelectOption(c.Id, c.Class_Title__c));
            }
            
            returnSessionList();
        }       
    }
    
    
    public void returnSessionList() {
        //when a class is selected, locate the sessions associated to it        
        this.bDisplaySessionDetails = false;
        this.bShowChooseSession = true;
        this.bShowRoster = false;
        this.bShowRosterEmpty = false;
        this.strErrorMessage = '';

        soSession = new List<SelectOption>();
        this.mapSessions = new Map<ID, clsSessionDetails>();
        clsSessionDetails sessionDetails = new clsSessionDetails();
        String sSessionListName;

        
        if(strSelectedClassId == null) {
            soSession.clear();
            soSession.add(new SelectOption('','- Choose a Class -'));
            return;
        }
        
        // Get ScheduleId from Class
        Schedule__c sch = null;
        try {
            sch = [SELECT Id FROM Schedule__c WHERE Class__c = :strSelectedClassId LIMIT 1];
        } catch (Exception e) {
            sch = null;
        }
        
        if(sch == null) {
            soSession.add(new SelectOption('','- No Sessions Found -'));
            return;
        } else {
            this.strSelectedScheduleId = sch.Id;
            // Populate List of Sessions
            
            //20120621 ebg - added range offsets to custom settings rather than hard coded
            // set default session search range based on custom setting values
            System_Limits__c csSystemDefaults = System_Limits__c.getInstance();
            Integer intStartOffset = -7;
            if (csSystemDefaults.Course_Grading_Sess_Range_Start_Offset__c != null) {
                intStartOffset = (Integer)csSystemDefaults.Course_Grading_Sess_Range_Start_Offset__c;
            }
            //Date dtStartRange = system.today().addDays(intStartOffset);
            Date dtStartRange = tskDummy.ActivityDate;
            Integer intEndOffset = 7;
            if (csSystemDefaults.Course_Grading_Sess_Range_End_Offset__c != null) {
                intEndOffset = (Integer)csSystemDefaults.Course_Grading_Sess_Range_End_Offset__c;
            }
            //Date dtEndRange = system.today().addDays(intEndOffset);
            Date dtEndRange = tskDummy.Catalog_End_Date__c;     
            
            List<Session__c> lstSessions = [SELECT Id, Session_Start__c, Session_End__c, Assigned_To__c
                                                    , Assigned_To__r.Name, Cancelled__c, Group_Note__c 
                                                    , Schedule__c, Name
                                            FROM Session__c 
                                            WHERE Schedule__c = :this.strSelectedScheduleId
                                            AND Session_Start__c >= :dtStartRange
                                            AND Session_Start__c <= :dtEndRange
                                            ORDER BY Session_Start__c LIMIT 50];
            
            // 3/14/13 MB: Populate Last Class RPT based on list of all sessions, not just those in the range
            // set by the custom settings. This prevents cases where a class is followed by say, a holiday week,
            // and there is no next class for 10 days (current setting). Last Class RPT would be incorrectly
            // set in this case, which might cause (among other things) a career ex program stage to be created
            // when the client had not in fact completed the class.    
            
            //3/19/13 MB: Ok, this recent modfication was causing a Too Many Code Statements error
            // for classes with many sessions or students. The real need here is to make sure that a few past
            // and future sessions are each included.                           
            /*List<Session__c> lstAllSessions = [SELECT Id FROM Session__c 
                                       WHERE Schedule__c = :this.strSelectedScheduleId
                                       AND Session_Start__c >= :system.today().addDays(-22)
                                       AND Session_Start__c <= :system.today().addDays(22)
                                       ORDER BY Session_Start__c desc LIMIT 30]; */
                                       
           List<Session__c> lstAllSessions = [SELECT Id FROM Session__c 
                                              WHERE Schedule__c = :this.strSelectedScheduleId
                                              AND Session_Start__c < :system.today()
                                              ORDER BY Session_Start__c desc LIMIT 10];   
                                       
          List<Session__c> lstAllSessions2 = [SELECT Id FROM Session__c 
                                             WHERE Schedule__c = :this.strSelectedScheduleId
                                             AND Session_Start__c >= :system.today()
                                             ORDER BY Session_Start__c asc LIMIT 5];  
                                             
         lstAllSessions.addAll(lstAllSessions2);                                                                                                                                     
            
            if(lstSessions.size() == 0) {
                soSession.add(new SelectOption('','- No Sessions Found -'));
                return;
            } else {
                
                // BT-307 Go through all session and map Last Class Flag on Events 20120410 AAB / DCS
                // 3/19/13 MB: list of Ids is now directly populated above, don't need this loop
                Set<Id> setAllSessionIds = new Set<Id>();
                for(Session__c sSet : lstAllSessions) { setAllSessionIds.add(sSet.Id); }
                
                // Get list of all Events for scoped sessions
                List<Event> lstSessionEvents = new List<Event>
                ([SELECT Id, WhoId, LastClassRPT__c FROM Event 
                WHERE WhatId IN :setAllSessionIds ORDER BY WhoId ASC, StartDateTime DESC]);
                
                // 3/19/13 MB: added lstEventstoUpdate to reduce the number of events being edited here
                list<Event> lstEventstoUpdate = new list<Event>();
                Id idWho = null;
                for(Event evt : lstSessionEvents) {
                    if(idWho == evt.WhoId) {
                        if(evt.LastClassRpt__c != false) {
                            evt.LastClassRPT__c = false;
                            lstEventstoUpdate.add(evt);
                        }
                    } else {                        
                        idWho = evt.WhoId;
                        if(evt.LastClassRpt__c != true) {
                            evt.LastClassRPT__c = true;
                            lstEventstoUpdate.add(evt);
                        }
                    }
                }
                
                //if(lstSessionEvents.size() > 0) { update lstSessionEvents; }
                if(lstEventstoUpdate.size() > 0) { update lstEventstoUpdate; }
                
                
                soSession.add(new SelectOption('','- Choose a Session (' + lstSessions.size() + ') -'));
                
                for(Session__c s : lstSessions) {                   
                    //soSession.add(new SelectOption(s.Id, String.valueOf(s.Session_Start__c.Date())));
                    sSessionListName = s.Session_Start__c.Date().Month() + '/' + s.Session_Start__c.Date().Day() + '/' + s.Session_Start__c.Date().Year();
                    soSession.add(new SelectOption(s.Id, sSessionListName));
                    sessionDetails = new clsSessionDetails();
                    sessionDetails.session = s;
                    sessionDetails.AssignedTo = s.Assigned_To__r.Name;
                    sessionDetails.SessionDate = s.Session_Start__c.format('EEEE, MMMM d, yyyy', this.sTimeZone);
                    sessionDetails.StartTime = s.Session_Start__c.format('h:mm a', this.sTimeZone);
                    sessionDetails.EndTime = s.Session_End__c.format('h:mm a', this.sTimeZone);
                    this.mapSessions.put(s.Id, sessionDetails);                 
                }
                
                //added 9/24/13 MB: if there is only one session, load the enrollees list automatically
                if(lstSessions.size() == 1) {
                    
                    this.strSelectedSession = lstSessions[0].id;
                    returnSessionInfo();
                }
            }
        }
        
    }


    public void returnSessionInfo() {
        //when the Session dropdown changes, retrieve the session info and notify the page it can be displayed
        system.debug('\n\n***Selected session: ' + this.strSelectedSession);

        //find the selected class label
        for (SelectOption so : soClass) {
            if (so.getValue() == this.strSelectedClassId) {
                this.strSelectedClassName = so.getLabel();
                break;
            }
        }

        if (this.strSelectedSession != '' && this.strSelectedSession != null) {
            
            system.debug('\n\n***Found a session');
            this.bDisplaySessionDetails = true;
            this.bShowChooseSession = false;
            ID sesSelectedId = (ID)this.strSelectedSession;
            this.sesSelected = this.mapSessions.get(sesSelectedId);
            this.bShowRoster = false;
            //if we dont' want the attendees to display as soon as a session is selected, comment out the next line
            this.returnAttendees();

        } else {
            
            system.debug('\n\n***Did not find a session');
            this.sesSelected = null;
            this.bDisplaySessionDetails = false;
            this.bShowChooseSession = true;
            this.bShowRoster = false;
            this.bShowRosterEmpty = false;
            
        }
        
        system.debug('\n\n***bDisplaySessionDetails: ' + bDisplaySessionDetails);                       
    }
    
    //find the events (attendee sessions) for these selected session
    public void returnAttendees() { 
        this.strErrorMessage = '';     
        List<ID> lstContactIdsAtt = new List<ID>();      
        List<ID> lstContactIds = new List<ID>();      
        this.mapSessionAttendees = new Map<Id, clsSessionAttendee>();
    
        
        //find the events linking contacts to the selected session
     
 
        this.sessionAttendees = [Select e.Who.Name, e.WhoId, e.Verification_Status__c, e.Withdrawn__c, e.Withdrawal_Reason__c,
                                e.RecordType.Name, e.RecordTypeId, e.Participation__c, e.WhatId, e.Subject, e.FirstClassRpt__c,
                                e.LastClassRpt__c, e.FirstClassSecondWeekRpt__c, e.ActivityDate, e.Program_Cycle__c, 
                                e.Class_Category__c, e.Area__c, e.ClassTypeRPT__c
                                    From Event e 
                                    Where e.RecordTypeId = :this.utilIds.courseCatalogClass
                                        and WhatId = :this.strSelectedSession
                                        and IsDeleted = false 
                                    Order by e.Who.Name];
       
        for (Event e : this.sessionAttendees){
          lstContactIdsAtt.add(e.whoid);
        } 
        if (this.sessionAttendees.size() > 0) {
            
            this.bShowRoster = true;
            this.bShowRosterEmpty = false;
            
            //store the contact ids in a set to be used when updating progress notes
            this.setContactIds = new Set<ID>();
            this.setVerifiedAttendeeIds = new Set<ID>();
            
            
            
            //store the session attendee info in a map
            clsSessionAttendee cSessAtt = new clsSessionAttendee();
            Map<id,Contact> MapContact = createMapcontact(lstContactIdsAtt);
   
        for (Event e : this.sessionAttendees) {
             cSessAtt.oEvt = e;
             cSessAtt.lastfirst = MapContact.get(e.whoid).lastname + ', ' + 
                  MapContact.get(e.whoid).firstname;

             this.mapSessionAttendees.put(e.WhoId, cSessAtt);
             this.setContactIds.add(e.WhoId);
             lstContactIds.add(e.WhoId);
                
                if (e.Verification_Status__c == 'Attended' || e.Verification_Status__c == 'Late' || e.Verification_Status__c == 'Tardy') {
                    this.setVerifiedAttendeeIds.add(e.WhoId);
                }

                //reset our variable
                cSessAtt = new clsSessionAttendee();

            }
            
            //fill the rest of the attendee info
            this.loadAttendeeDetails(lstContactIds);
            
            
        } else {
            
            this.bShowRoster = false;
            this.bShowRosterEmpty = true;
            
        }
    }

    ///////////////////////////////////////////////////
    // 20120919 - ebg/DCS
    // Load the map of session attendees with related program plan and progress note
    ///////////////////////////////////////////////////
    public void loadAttendeeDetails(List<ID> lstContactIds) {
        
        system.debug('\n\n*** Inside loadAttendeeDetails\n');
        
        // Determine what kind of PN to deal with
        Id idProgressNoteRecordType;
        if(UserInfo.getProfileId() == utilIds.caseCoordinatorStaff) {
            idProgressNoteRecordType = utilIds.progressNoteCCPN;
        } else {
            idProgressNoteRecordType = utilIds.progressNotePSPN;
        }

        system.debug('\n\n***INFO: idProgressNoteRecordType: ' + idProgressNoteRecordType + '   NOTHING ELSE\n');

        
        //get the programs for the selected clients and update our attendee map.
        //A client will always have at least one program assigned, so pull the most recent one by looping through the earliest created
        //and updating our map until the last once overwrites the previous ones
        clsSessionAttendee cSessAtt = new clsSessionAttendee();
        Progress_Note__c pgn = new Progress_Note__c();
        Map<id,Contact> MapContact = createMapcontact(lstContactIds);
  
        for (Program_Plan__c pp : [Select Id, Name, Client_Name__c 
                                From Program_Plan__c
                                //Where Client_Name__c in :this.setContactIds
                                Where Client_Name__c in :lstContactIds
                                and Most_Recent_Program_Plan__c = true
                                Order By Client_Name__c, CreatedDate ASC]) {
                                
            cSessAtt = this.mapSessionAttendees.get(pp.Client_Name__c);
            cSessAtt.oProgramPlan = pp;
            cSessAtt.lastfirst = MapContact.get(pp.Client_Name__c).lastname + ', ' + 
                  MapContact.get(pp.Client_Name__c).firstname;
            //create a holding place for a progress note.  If one is already assigned to the client, we'll find it in the next step
            pgn = new Progress_Note__c();
            pgn.RecordTypeId = idProgressNoteRecordType;
            pgn.Program_Plan__c = pp.id;
            pgn.Area__c = this.mapSessionAttendees.get(pp.Client_Name__c).oEvt.Area__c;
            pgn.Session__c = this.sesSelected.session.Id;   
            pgn.Progress_Note__c = '';      
            cSessAtt.oProgressNote = pgn;
//            cSessAtt.lastfirst = MapcontactLastFirst.get(pp.Client_Name__c).lastfirst;
            this.mapSessionAttendees.put(pp.Client_Name__c, cSessAtt);
            

        }
                                        
                                
        //get the course catalog progress notes for each client linked to this session
        this.pgProgressNote = null;
        
        for (Progress_Note__c p : [select Id
                                    , Progress_Note__c
                                    , Session__c
                                    , RecordTypeId
                                    , Client_Id__c
                                    , Client_Name__c
                                    , Program_Plan__c
                                    , Program_Plan__r.Client_Name__r.Id
                                    , Area__c
                                from Progress_Note__c
                                where Program_Plan__r.Client_Name__r.Id in :this.setContactIds
                                    and RecordTypeId = :idProgressNoteRecordType
                                    and Session__c = :this.sesSelected.session.Id
                                order by Client_Name__c
                                        , Client_Id__c
                                        , CreatedDate ASC]) {

            cSessAtt = this.mapSessionAttendees.get(p.Program_Plan__r.Client_Name__r.Id);
            cSessAtt.oProgressNote = p;
            this.mapSessionAttendees.put(p.Program_Plan__r.Client_Name__r.Id, cSessAtt);
                                    
        }
        
        //create the final list that is used on the VF page by looping through the list of contact ids passed into the function
        //Take this approach versus the map method ".values" because we want the list to be sorted in the same order as it was passed to us        
        this.lstSessionAttendees = new List<clsSessionAttendee>();
        for (ID conID : lstContactIds) { 
            this.lstSessionAttendees.add(this.mapSessionAttendees.get(conID));
        }

    }



    ///////////////////////////////////////////////////
    // 20111006 - ebg/DCS
    //
    // Find all sessions associated to the selected class/schedule that occurred prior to the current session
    // and store their ids in a set.  We then use this set to retrieve the events tied to those sessions so we 
    // can determine if the client's current session is the first class of the second week
    ///////////////////////////////////////////////////
    
    public Map<ID, Date> calculateClassWeek() {

        Set<ID> setPreviousSessionIDs = new Set<ID>();
        
        for (Session__c oSession : [SELECT Id
                                                , Session_Start__c
                                                , Session_End__c
                                                , Assigned_To__c
                                                , Assigned_To__r.Name
                                                , Cancelled__c
                                                , Group_Note__c 
                                                , Schedule__c
                                                , Name
                                        FROM Session__c 
                                        WHERE Schedule__c = :this.strSelectedScheduleId
                                            And Session_Start__c < :this.sesSelected.Session.Session_Start__c
                                        Order By Session_Start__c]) {

            setPreviousSessionIDs.add(oSession.Id);     

        }
        


        //find the date of the first attended class for each contact in the session and store in a map.  We use this 
        //map to determine if the current session is the first session of the second week
        Map<ID, Date> mapContactFirstClass = new Map<ID, Date>();
        this.setSecondWeekAttendeeIds = new Set<ID>();
        Date dteFirstClass = date.newinstance(1980, 1, 1);
        Id idPrevClient;
        Integer intAttendedClassWeek;
        Boolean blnFirstClassFound = false;
        for (Event evtFirstClass : [Select WhoId, ActivityDate, FirstClassRPT__c, FirstClassSecondWeekRpt__c
                                            From Event
                                            Where RecordTypeId = :this.utilIds.courseCatalogClass
                                                and WhatId in :setPreviousSessionIDs
                                                and (Verification_Status__c = 'Attended'
                                                or Verification_Status__c = 'Tardy'
                                                or Verification_Status__c = 'Late')
                                            Order By WhoId, ActivityDate]) {
                                                
            //BT-301 ebg - build a set of contacts who have already attended the first class of the second week
            if (evtFirstClass.FirstClassSecondWeekRpt__c == true) { this.setSecondWeekAttendeeIds.add(evtFirstClass.WhoId); }                                   

            //processing the first record                                               
            if (idPrevClient == null) {
                intAttendedClassWeek = 1;
                dteFirstClass = evtFirstClass.ActivityDate.toStartOfWeek();
                idPrevClient = evtFirstClass.WhoId;
                //BT-301 ebg - if the flag is already set for the first class, add it to our map right away
                if (evtFirstClass.FirstClassRPT__c == true) {
                    mapContactFirstClass.put(evtFirstClass.WhoId, dteFirstClass);
                    blnFirstClassFound = true;      
                }
            } 

            //while processing a specific contact, determine how many weeks the client has attended.  If only one week, then add
            //the contact to the map of potentially attending the first class of the second week
            if (evtFirstClass.WhoId == idPrevClient) {
                //if the event we are reviewing is in any week after the first class, increment our week counter
                if (dteFirstClass.daysBetween(evtFirstClass.ActivityDate.toStartOfWeek()) >=7) {
                    intAttendedClassWeek++;
                }
            } else {
                
                if (intAttendedClassWeek == 1 && blnFirstClassFound == true) {
                    //BT-301 ebg - should be passing the previous contact into the map because we just moved onto a new contact
                    //mapContactFirstClass.put(evtFirstClass.WhoId, dteFirstClass);
                    mapContactFirstClass.put(idPrevClient, dteFirstClass);
                }
                
                //reset variables because we are on a new contact
                intAttendedClassWeek = 1;
                dteFirstClass = evtFirstClass.ActivityDate.toStartOfWeek();
                blnFirstClassFound = false;     
                //BT-301 ebg - if the flag is already set for the first class on the next contact, add it to our map right away
                if (evtFirstClass.FirstClassRPT__c == true) {
                    mapContactFirstClass.put(evtFirstClass.WhoId, dteFirstClass);
                    blnFirstClassFound = true;      
                }
            }


            idPrevClient = evtFirstClass.WhoId;
                                                
        }
        
        //process last record in the list
        if (idPrevClient != null && intAttendedClassWeek == 1) {
            mapContactFirstClass.put(idPrevClient, dteFirstClass);
        }


        return mapContactFirstClass;
        
    }


    public Boolean isWithdrawalVerified() {

        Boolean bVerified = true;
        //loop through the attendees for the selected session and if there are any withdrawn attendees, update their verification status
        for (Integer i=0; i<this.sessionAttendees.size(); i++) {
            if (this.sessionAttendees[i].Withdrawn__c == true) {
                
                //Withdrawing from a Career Ex course requires a reason for withdrawal
                if (this.coSearch.Category__c.contains('Career Exploration') == true && this.sessionAttendees[i].Withdrawal_Reason__c == null) {
                    this.strErrorMessage = '*** Error: Withdrawal Reason required when withdrawing a client from a Career Exploration class.  Choose one or more Withdrawal Reasons and save again. ***';
                    bVerified = false;
                } else {
    
                    this.sessionAttendees[i].Verification_Status__c = 'Withdrawn';
                    
                }
                
                
            }
        }       
        
        return bVerified;
    }

    
    public Boolean isVerificationStatusValid() {
        Boolean bVerified = true;
        //verification status may only be blank, 'Not Verified', 'Cancelled', or 'Withdrawn' for sessions greater than today
        if (this.sesSelected.session.Session_Start__c.date() > system.today()) {
            
            for (Event e : this.sessionAttendees) {
                
                if (e.Verification_Status__c != null && e.Verification_Status__c != 'Not Verified' && e.Verification_Status__c != 'Cancelled' && e.Verification_Status__c != 'Withdrawn') {
                    if (this.strErrorMessage != '') { this.strErrorMessage += '\n\n'; }
                    this.strErrorMessage += '*** Verification status may only be blank, \'Not Verified\', \'Cancelled\', or \'Withdrawn\' for sessions later than today.  Change verification status and save again. ***';
                    bVerified = false;
                    break;
                }
                
            }
            
        }
        
        return bVerified;
    }

    //save changes made to the client's event record
    public void saveSessionAttendees2() {
        
            system.debug('\n\n***INFO: inside saveSessionAttendees***\n\n');


        //clear the error message.  It will be set in the function isWithdrawalVerified
        this.strErrorMessage = '';
        if (this.isWithdrawalVerified() == true && this.isVerificationStatusValid() == true) {
            
            //call the routine which determines which week a class is in
            Map<ID, Date> mapContactFirstClass = new Map<ID, Date>();
            mapContactFirstClass = calculateClassWeek();            
            
            //loop through our list of records and set the flag FirstClassSecondWeek    
            List<Event> lstEventUpdates = new List<Event>();
            List<Progress_Note__c> lstProgressNoteUpdates = new List<Progress_Note__c>();
            List<Progress_Note__c> lstProgressNoteInserts = new List<Progress_Note__c>();
            
            
            for (Integer i = 0; i < this.lstSessionAttendees.size(); i++) {
                Event objCurrentEvent = this.lstSessionAttendees[i].oEvt;
                
                if (mapContactFirstClass.containsKey(objCurrentEvent.WhoId)) {
                    Date dteFirstClass = mapContactFirstClass.get(objCurrentEvent.WhoId);

                    //BT-301 ebg - add check to see if contact has already attended the first class of the second week
                    if ((dteFirstClass.daysBetween(objCurrentEvent.ActivityDate) >= 7) 
                    && (this.setSecondWeekAttendeeIds.contains(objCurrentEvent.WhoId) == false) 
                    && (objCurrentEvent.Verification_Status__c == 'Attended' 
                    || objCurrentEvent.Verification_Status__c == 'Tardy' 
                    || objCurrentEvent.Verification_Status__c == 'Late')) {
                        this.lstSessionAttendees[i].oEvt.FirstClassSecondWeekRpt__c = true;
                    }
                } else {
                    //since the attendee did not have a first attended class, this must be it
                    this.lstSessionAttendees[i].oEvt.FirstClassRPT__c = true;
                }
                lstEventUpdates.add(this.lstSessionAttendees[i].oEvt);
                if (this.lstSessionAttendees[i].oProgressNote.Id == null) {
                    // 11/14/12 MB add check to make sure not is not null, otherwise blank progress notes get created whenever "save" is clicked
                    if(this.lstSessionAttendees[i].oProgressNote.Progress_Note__c != null && this.lstSessionAttendees[i].oProgressNote.Progress_Note__c != '') {
                        lstProgressNoteInserts.add(this.lstSessionAttendees[i].oProgressNote);  
                    }                   
                } else {
                    lstProgressNoteUpdates.add(this.lstSessionAttendees[i].oProgressNote);
                }
                                
            }
            
            system.debug('\n\n***INFO: saving session attendees: ' + lstEventUpdates + '\n\n');
            update lstEventUpdates;
            if (lstProgressNoteInserts.size() > 0) {
                system.debug('\n\n***INFO: inserting progress notes: ' + lstProgressNoteUpdates + '\n\n');
                insert lstProgressNoteInserts;
            }
            if (lstProgressNoteUpdates.size() > 0) {
                system.debug('\n\n***INFO: updating progress notes: ' + lstProgressNoteUpdates + '\n\n');
                update lstProgressNoteUpdates;
            }

            //refresh our list
            this.returnAttendees();
            //this.withdrawAttendees();

            system.debug('\n\n***INFO: before setAttendeeEnrollmentStatus: ' +  + this.sessionAttendees + '\n\n');
            this.setAttendeeEnrollmentStatus(null, null);
            
            system.debug('\n\n***INFO: before saveGroupNote: ' +  + this.sessionAttendees + '\nthis.sesSelected.session.Group_Note__c: ' + this.sesSelected.session.Group_Note__c + '\n');
            this.saveGroupNote();

            system.debug('\n\n***INFO: after saveGroupNote: ' +  + this.sessionAttendees + '\n\n');

            //calls for Career Ex functionality
            /*programStages cps = new programStages();
            cps.createStageRecord(null, this.sessionAttendees, null, null);*/
            
        }
        
    }




    public void cancelSession() {
        system.debug('\n\n***Inside cancelSession');
        //update the session record to indicate it was cancelled
        this.sesSelected.session.Cancelled__c = true;
        update this.sesSelected.session;
            
        this.mapSessions.put(this.sesSelected.session.Id, this.sesSelected);
        
        //make sure we have the most recent list of attendees to start
        returnAttendees();

        //set every attendee's status to cancelled
        system.debug('\n\n***this.sesSelected: ' + this.sesSelected);
        system.debug('\n\n***this.sesSelected: ' + this.sesSelected);
        if (this.sesSelected != null && this.sessionAttendees != null) {
            
            List<Event> lstEventUpdates = new List<Event>();

            for (Event e : this.sessionAttendees) {
                e.Verification_Status__c = 'Cancelled';
                system.debug('\n\n***Processing Event ' + e.Id + ' - ' + e.Subject + ' for ' + e.Who.Name + ': ' + e);
                lstEventUpdates.add(e);
            }
            update lstEventUpdates;
            
            //added 6/9/14 MB to close enrollments
            this.setAttendeeEnrollmentStatus(null, null);
                        
            returnAttendees();          
            
        }       
    }
    
    public void getAttendeeProgressNote() {
        
        system.debug('\n\n*** Inside getAttendeeProgressNote\n');
        
        // Determine what kind of PN to deal with
        Id idProgressNoteRecordType;
        if(UserInfo.getProfileId() == utilIds.caseCoordinatorStaff) {
            idProgressNoteRecordType = utilIds.progressNoteCCPN;
        } else {
            idProgressNoteRecordType = utilIds.progressNotePSPN;
        }

        system.debug('\n\n***INFO: idProgressNoteRecordType: ' + idProgressNoteRecordType + '   NOTHING ELSE\n');

        
        //get the program for the selected client.  A client will always have at least one program assigned, so pull the most recent one
        ID currProgramId;
        
        system.debug('\n\n***INFO: this.idCurrentEvent: ' + this.idCurrentEvent + '   NOTHING ELSE\n');
        
        Event e = [Select Id, WhoId, Area__c From Event Where Id = :this.idCurrentEvent LIMIT 1];
        this.idCurrentContact = e.WhoId;
        
        system.debug('\n\n***INFO: this.idCurrentContact: ' + this.idCurrentContact + '   NOTHING ELSE\n');
        Program_Plan__c pp = [Select Id 
                                From Program_Plan__c
                                Where Client_Name__c = :this.idCurrentContact
                                and Most_Recent_Program_Plan__c = true
                                //Order By CreatedDate DESC
                                LIMIT 1];
                                
        //get the course catalog progress note for the client's program
        this.pgProgressNote = null;
        
        for (Progress_Note__c p : [select Id
                                    , Progress_Note__c
                                    , Session__c
                                    , RecordTypeId
                                    , Client_Id__c
                                    , Client_Name__c
                                    , Program_Plan__c
                                    , Program_Plan__r.Client_Name__r.Id
                                    , Area__c
                                from Progress_Note__c
                                where Program_Plan__r.Client_Name__r.Id = :this.idCurrentContact
                                    and RecordTypeId = :idProgressNoteRecordType
                                    and Session__c = :this.sesSelected.session.Id
                                order by Client_Name__c
                                        , Client_Id__c
                                LIMIT 1]) {

            system.debug('\n\n***INFO: found existing progress note: ' + p + '\n');                                 
            this.pgProgressNote = p;
                                    
        }


        //If there isn't an existing progress note already started for this session,
        //create a new one that can be populated in the progress note screen
        if (this.pgProgressNote == null || this.pgProgressNote.Id == null) {
            this.pgProgressNote = new Progress_Note__c();           
            this.pgProgressNote.RecordTypeId = idProgressNoteRecordType;
            this.pgProgressNote.Program_Plan__c = pp.id;
            this.pgProgressNote.Area__c = e.Area__c;
            this.pgProgressNote.Session__c = this.sesSelected.session.Id;   
            this.pgProgressNote.Progress_Note__c = '';      
            system.debug('\n\n***INFO: creating new progress note: ' + this.pgProgressNote + '\n');                                 
        }
        
        system.debug('\n\n---------- progress note: ' + this.pgProgressNote + '\n');                
        
    }


/////////////////////
    public PageReference gotoAttendeeProgressNote() {
        
        PageReference pg;
        
        system.debug('\n\n*** Inside gotoAttendeeProgressNote\n');
        
        // Determine what kind of PN to deal with
        Id idProgressNoteRecordType;
        if(UserInfo.getProfileId() == utilIds.caseCoordinatorStaff) {
            idProgressNoteRecordType = utilIds.progressNoteCCPN;
        } else {
            idProgressNoteRecordType = utilIds.progressNotePSPN;
        }

        system.debug('\n\n***INFO: idProgressNoteRecordType: ' + idProgressNoteRecordType + '   NOTHING ELSE\n');

        
        //get the program for the selected client.  A client will always have at least one program assigned, so pull the most recent one
        ID currProgramId;
        
        system.debug('\n\n***INFO: this.idCurrentEvent: ' + this.idCurrentEvent + '   NOTHING ELSE\n');
        
        Event e = [Select Id, WhoId, Area__c From Event Where Id = :this.idCurrentEvent LIMIT 1];
        this.idCurrentContact = e.WhoId;
        
        system.debug('\n\n***INFO: this.idCurrentContact: ' + this.idCurrentContact + '   NOTHING ELSE\n');
        Program_Plan__c pp = [Select Id, Name
                                From Program_Plan__c
                                Where Client_Name__c = :this.idCurrentContact
                                and Most_Recent_Program_Plan__c = true
                                //Order By CreatedDate DESC
                                LIMIT 1];
                                
        //get the course catalog progress note for the client's program
        this.pgProgressNote = null;
        
        for (Progress_Note__c p : [select Id
                                    , Progress_Note__c
                                    , Session__c
                                    , RecordTypeId
                                    , Client_Id__c
                                    , Client_Name__c
                                    , Program_Plan__c
                                    , Program_Plan__r.Client_Name__r.Id
                                    , Area__c
                                from Progress_Note__c
                                where Program_Plan__r.Client_Name__r.Id = :this.idCurrentContact
                                    and RecordTypeId = :idProgressNoteRecordType
                                    and Session__c = :this.sesSelected.session.Id
                                order by Client_Name__c
                                        , Client_Id__c
                                LIMIT 1]) {

            system.debug('\n\n***INFO: found existing progress note: ' + p + '\n');   
            this.pgProgressNote = p;                              
            pg = new PageReference('/' + p.Id);                        
                                    
        }


        //If there isn't an existing progress note already started for this session,
        //create a new one that can be populated in the progress note screen
        if (this.pgProgressNote == null || this.pgProgressNote.Id == null) {
            this.pgProgressNote = new Progress_Note__c();           
            this.pgProgressNote.RecordTypeId = idProgressNoteRecordType;
            this.pgProgressNote.Program_Plan__c = pp.id;
            this.pgProgressNote.Area__c = e.Area__c;
            this.pgProgressNote.Session__c = this.sesSelected.session.Id;   
            this.pgProgressNote.Progress_Note__c = '';      
            system.debug('\n\n***INFO: creating new progress note: ' + this.pgProgressNote + '\n');  

            pg = new PageReference('/a0X/e?CF00N60000001rJHj=' + pp.Name + '&CF00N60000001rJHj_lkid=' + pp.id + '&RecordType=' + idProgressNoteRecordType + '&CF00N60000001rqDi_lkid=' + this.sesSelected.session.Id + '&CF00N60000001rqDi=' + this.sesSelected.session.Name + '&00N60000001rJKa=' + e.Area__c + '&ent=01I600000002Mjn');                              
        }
        
        system.debug('\n\n---------- page ref: ' + pg + '\n');  
        pg.setRedirect(true);
        return pg;             
        
    }
/////////////////////



    
    
    public void saveAttendeeProgressNote() {
        
        //create a new progress note just for given client and the selected session
        //this.idCurrentContact = Apexpages.currentPage().getParameters().get('contactId');     
        //this.pgProgressNote.Progress_Note__c = Apexpages.currentPage().getParameters().get('progressNote');

        system.debug('\n\n***Inside saveAttendeeProgressNote: idCurrentContact->' + this.idCurrentContact + '   Progress Note->' + this.pgProgressNote);

        if (this.pgProgressNote != null) {
            if (this.pgProgressNote.Id != null) {
                system.debug('\n\n***INFO: updating progess note: ' + this.pgProgressNote);
                update this.pgProgressNote;
            } else {
                system.debug('\n\n***INFO: inserting progess note: ' + this.pgProgressNote);
                insert this.pgProgressNote;
                system.debug('\n\n***INFO: after inserting progess note: ' + this.pgProgressNote);
            }
        }
        
    }

    
    
    
    public void saveGroupNote() {
        //add the text from the Group Note field to each client's Progress Notes area and also save the note with the session
        system.debug('\n\n***Inside saveGroupNote');
        system.debug('\n\n*** this.this.setContactIds: ' + this.setContactIds);
        system.debug('\n\n*** this.utilIds.progressNoteGroup: ' + this.utilIds.progressNoteGroup);
        system.debug('\n\n*** this.sesSelected.session.Id: ' + this.sesSelected.session.Id);
        system.debug('\n\n*** this.setVerifiedAttendeeIds ' + this.setVerifiedAttendeeIds);
        system.debug('\n\n*** this.sesSelected.session.Group_Note__c ' + this.sesSelected.session.Group_Note__c);
        
        //20111202 - prevent note from being saved if it is empty
        if (this.sesSelected.session.Group_Note__c != null) {
        
            //find all group progress notes linked to clients in the session
            Map<Id, Progress_Note__c> mapProgressNotes = new Map<Id, Progress_Note__c>();
            List<Progress_Note__c> lstProgressNotes_Updates = new List<Progress_Note__c>();
            List<Progress_Note__c> lstProgressNotes_Inserts = new List<Progress_Note__c>();
            for (Progress_Note__c pg :  [select Id
                                                , Progress_Note__c
                                                , Session__c
                                                , RecordTypeId
                                                , Client_Id__c
                                                , Client_Name__c
                                                , Program_Plan__c
                                                , Program_Plan__r.Client_Name__r.Id
                                                , Area__c
                                            from Progress_Note__c
                                            where Program_Plan__r.Client_Name__r.Id in :this.setVerifiedAttendeeIds
                                                and RecordTypeId = :this.utilIds.progressNoteGroup
                                                and Session__c = :this.sesSelected.session.Id
                                            order by Client_Name__c
                                                    , Client_Id__c]) {
    
                //update the progress note
                pg.Progress_Note__c = this.sesSelected.session.Group_Note__c;
                lstProgressNotes_Updates.add(pg);
                mapProgressNotes.put(pg.Client_Id__c, pg);
                                                                    
            }
            system.debug('\n\nProgress Notes to update: ' + lstProgressNotes_Updates);
            system.debug('\n\n***INFO: map of progress notes: ' + mapProgressNotes);
            //update the existing progress notes
            if (lstProgressNotes_Updates.size() > 0) {
                update lstProgressNotes_Updates;
            }
            
    
            //retrieve the program plans for the contacts and keep them in a map for easy retrieval
            Map<Id, Program_Plan__c> mapProgramPlans = new Map<Id, Program_Plan__c>();
            
            for (Program_Plan__c pp : [Select Id
                                            , Client_Name__c
                                        From Program_Plan__c
                                        Where Client_Name__c in :this.setContactIds
                                        and Most_Recent_Program_Plan__c = true]) {
                                            
                mapProgramPlans.put(pp.Client_Name__c, pp);
            }
            
            
            //for each attendee, determine if a progress note exists.  If not, create one.  But only create it
            //if the attendee has a program plan and had verified attendance
            system.debug('\n\n***Build list of new progress notes');
            Progress_Note__c newProgressNote;
            for (Event sat : this.sessionAttendees) {
    
                
                String strTempId = sat.WhoId;
                //strTempId = strTempId.substring(0,15);
    
                system.debug('\n\n***INFO: checking out contact ' + strTempId + '    mapProgressNotes.containsKey(strTempId): ' + mapProgressNotes.containsKey(strTempId) + '\n' + mapProgressNotes + '\n\n');
    
                //20111202 - ebg - Added Cancelled 
                if (!mapProgressNotes.containsKey(strTempId) 
                        && mapProgramPlans.get(sat.WhoId) != null 
                        && (sat.Verification_Status__c == 'Attended' || sat.Verification_Status__c == 'Late' || sat.Verification_Status__c == 'Tardy' || sat.Verification_Status__c == 'Cancelled') ) {
                            
                    system.debug('\n\n***Creating a new group progress note with text: ' + this.sesSelected.session.Group_Note__c); 
                    newProgressNote = new Progress_Note__c();
                    newProgressNote.Date__c = Date.today();
                    newProgressNote.RecordTypeId = this.utilIds.progressNoteGroup;
                    newProgressNote.Progress_Note__c = this.sesSelected.session.Group_Note__c;
                    newProgressNote.Area__c = this.coSearch.Area__c;
                    newProgressNote.Class__c = strSelectedClassName;
                    newProgressNote.Session__c = this.sesSelected.session.Id;
                    newProgressNote.Class_Session_Date_Time__c = this.sesSelected.session.Session_Start__c;
                    newProgressNote.System_Generated__c = true;
                    newProgressNote.Program_Plan__c = mapProgramPlans.get(sat.WhoId).Id;
                    //populate the list of notes to be inserted
                    lstProgressNotes_Inserts.add(newProgressNote);
                }
            }   
                 
            system.debug('\n\nProgress Notes to create: ' + lstProgressNotes_Inserts);
    
            //insert the new progress notes
            if (lstProgressNotes_Inserts.size() > 0) {
                insert lstProgressNotes_Inserts;
            }
            
    
            update this.sesSelected.session;

        }
                
    }



    public void setAttendeeEnrollmentStatus(list<Event> lstSingleSessions, Id importedClassId) {
        
        //6/19/13 MB: This can now be called from courseEnrollment for single session classes. 
        // Added an argument so that a list of contacts can be passed in
        List<Event> lstEventsToProcess = new list<Event>();         
        Set<ID> setContactIDs = new Set<ID>();
        // 6/18/13 MB: Changed this set of contact ids to a map of contact id to event. 
        // This map is used to determine the client_class_status field on enrollment for single session
        // classes. Previously, these enrollments would be marked complete even if the client did not attend.
        // From this point forward, the enrollments will be marked "withdrawn". 
        //Set<ID> setCompletedContactIDs = new Set<ID>();
        map<Id, Event> mapCompletedContactIds = new map<Id, Event>();
        Set<ID> setWithdrawnContactIDs = new Set<ID>();
        Map<ID, String> mapContactWithdrawReasons = new Map<ID, String>();
        
        if (lstSingleSessions != null) {
            lstEventstoProcess = lstSingleSessions;
            this.strSelectedClassId = importedClassId;
        } else {
            lstEventstoProcess = this.sessionAttendees;
        }
        
        //loop through the events and get the withdrawn contacts and the reason for the withdrawal
        for (Event e : lstEventstoProcess) {
            //add the contact linked to the event to our main set of contact ids
            setContactIDs.add(e.WhoId);

            if (e.Withdrawn__c == true) {
                //get the people who withdrew
                setWithdrawnContactIDs.add(e.WhoId);
                mapContactWithdrawReasons.put(e.WhoId, e.Withdrawal_Reason__c);
            } else if (e.LastClassRPT__c == true) {
                //get the people attending their last class
                //setCompletedContactIDs.add(e.WhoId);
                mapCompletedContactIds.put(e.whoId, e);
            }

        }
        
        //if we have contacts to withdraw, call the withdrawAttendees routine
        if (setWithdrawnContactIDs.size() > 0) {
            this.withdrawAttendees(setWithdrawnContactIDs);
        }


        //get the enrollment records for every contact we're processing
        List<Enrollment__c> lstEnrollment = [Select Id
                                                    , Class__c
                                                    , Client__c
                                                    , Withdrawn_Date__c
                                                    , Withdrawn_Reason__c
                                                    , Client_Class_Status_Field__c
                                            From Enrollment__c
                                            Where Client__c in :setContactIds
                                                And Class__c = :this.strSelectedClassId];

        //loop through the enrollment records and set the status for each attendee                                              
        for (Enrollment__c enr: lstEnrollment) {            
            
            system.debug(enr);
            system.debug(mapCompletedContactIds);
            
            if (setWithdrawnContactIDs.contains(enr.Client__c)) {
                //process withdrawn attendees
                enr.Withdrawn_Date__c = system.today();
                enr.Client_Class_Status_Field__c = 'Withdrawn';
                if (mapContactWithdrawReasons.containsKey(enr.Client__c)) {
                    enr.Withdrawn_Reason__c = mapContactWithdrawReasons.get(enr.Client__c);
                }
           
            } else if (mapCompletedContactIDs.containsKey(enr.Client__c)) {
                
                //process those attending their last class 
                // If the class was single session and it was not attended, mark the enrollment
                // as withdrawn instead. Otherwise, mark it as completed   
                if(mapCompletedContactIds.get(enr.Client__c).Verification_Status__c != 'Attended'
                && mapCompletedContactIds.get(enr.Client__c).Verification_Status__c != 'Late'
                && mapCompletedContactIds.get(enr.Client__c).Verification_Status__c != 'Tardy'
                && mapCompletedContactIds.get(enr.Client__c).Verification_Status__c != 'Not Verified'
                && mapCompletedContactIds.get(enr.Client__c).ClassTypeRPT__c == utilIds.classSingle) {
                    
                    enr.Client_Class_Status_Field__c = 'Withdrawn';
                    enr.Withdrawn_Date__c = system.today();
                } else if (mapCompletedContactIds.get(enr.Client__c).Verification_Status__c != 'Not Verified'){
                
                    enr.Client_Class_Status_Field__c = 'Completed';
                }
           
            } else if (enr.Client_Class_Status_Field__c != 'Completed' 
            && enr.Client_Class_Status_Field__c != 'Withdrawn') {
                //if not withdrawn or attending last class, enrollment is still active
                //we check the existing status so we don't overwrite it if classes are not verified in order
                enr.Client_Class_Status_Field__c = 'Active';               
            }
            
        }
        
        if (lstEnrollment.size() > 0) {
            update lstEnrollment;
        }

    }
    

    public void withdrawAttendees(Set<ID> setContactIDs) {

        ///////////////////////////////////////////
        // This procedure withdraws the given attendees from any future sessions 
        // for the selected class schedule
        // Author:  EBG / DCS
        // Created:  20110914
        ///////////////////////////////////////////

        Set<ID> setSessionIDs = new Set<ID>();
        
        //get the future sessions for the schedule linked to our selected session
        List<Schedule__c> lstSchedules = [Select (Select Id From relScheduleSessions__r Where Session_Start__c > :this.sesSelected.session.Session_Start__c) 
                                            From Schedule__c s WHERE Id = :this.sesSelected.session.Schedule__c];
        for(Schedule__c sWithdraw : lstSchedules) {
            for(Session__c seWithdraw : sWithdraw.relScheduleSessions__r) {
                setSessionIDs.add(seWithdraw.Id);
            }
        }
        
        List<Event> lstEventsToDelete = [Select Id From Event Where WhatId in :setSessionIDs And WhoID in :setContactIds];
        
        //delete any future sessions assigned to the contacts
        if (lstEventsToDelete.size() > 0) {
            delete lstEventsToDelete;
        }
    }
    
/*

    public void withdrawAttendees() {

        ///////////////////////////////////////////
        // This procedure withdraws an attendee from any future sessions for the selected class schedule
        // Author:  EBG / DCS
        // Created:  20110914
        ///////////////////////////////////////////

        Set<ID> setContactIDs = new Set<ID>();
        Set<ID> setSessionIDs = new Set<ID>();
        Map<ID, String> mapContactReasons = new Map<ID, String>();
        
        //loop through the events and get the withdrawn contacts and the reason for the withdrawal
        for (Event e : this.sessionAttendees) {
            if (e.Withdrawn__c == true) {
                setContactIDs.add(e.WhoId);
                mapContactReasons.put(e.WhoId, e.Withdrawal_Reason__c);
            }

        }
        
        //get the future sessions for the schedule linked to our selected session
        List<Schedule__c> lstSchedules = [Select (Select Id From relScheduleSessions__r Where Session_Start__c > :this.sesSelected.session.Session_Start__c) From Schedule__c s WHERE Id = :this.sesSelected.session.Schedule__c];
        for(Schedule__c sWithdraw : lstSchedules) {
            for(Session__c seWithdraw : sWithdraw.relScheduleSessions__r) {
                setSessionIDs.add(seWithdraw.Id);
            }
        }
        
        List<Event> lstEventsToDelete = [Select Id From Event Where WhatId in :setSessionIDs And WhoID in :setContactIds];
        
        //delete any future sessions assigned to the contacts
        if (lstEventsToDelete.size() > 0) {
            delete lstEventsToDelete;
        }
        
        //update the enrollment record to indicate the client withdrew
        List<Enrollment__c> lstEnrollment = [Select Id
                                                    , Class__c
                                                    , Client__c
                                                    , Withdrawn_Date__c
                                                    , Withdrawn_Reason__c
                                            From Enrollment__c
                                            Where Client__c in :setContactIds
                                                And Class__c = :this.strSelectedClassId];
                                                
        for (integer i = 0; i < lstEnrollment.size(); i++) {
            lstEnrollment[i].Withdrawn_Date__c = system.today();
            lstEnrollment[i].Client_Class_Status_Field__c = 'Withdrawn';
            if (mapContactReasons.containsKey(lstEnrollment[i].Client__c)) {
                lstEnrollment[i].Withdrawn_Reason__c = mapContactReasons.get(lstEnrollment[i].Client__c);
            }
        }
        
        if (lstEnrollment.size() > 0) {
            update lstEnrollment;
        }

            
    }


*/  
    public PageReference printRoster() {
        
        PageReference pfRoster = new PageReference('/apex/courseRoster?c=' + this.strSelectedClassId + '&s=' + this.sesSelected.session.Id);
        pfRoster.setRedirect(true);
        return pfRoster;
        
    }
    
    public map<id,contact> createMapContact(List<ID> s){
         Map<Id, Contact> mapContact = new Map<Id, Contact>
       ([Select firstname, lastname, id from Contact where id in: s
           order by lastname, firstname]);
        return mapContact;   
    }
    
}