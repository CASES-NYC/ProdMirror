public class courseEnrollment {

    ///////////////////////////////////////////
    // This method manages Enrollments of Classes
    // Author:  AAB / DCS
    // Created:  20110418
    ///////////////////////////////////////////

    public courseGrading crsGrading = new courseGrading();
    public String strClassId {get;set;}
    public Class__c clCurrent {get;set;}
    public Schedule__c schClass {get;set;}
    public Event evtSearch {get;set;}
    public Integer intEnrollees {get;set;}
    public String strSchedule {get;set;}
    public String strSessionStart {get;set;}
    public Integer intSessionEnd {get;set;}
    public List<clientsForDisplay> lstEnrollees = new List<clientsForDisplay>();
    public List<Id> lstReferredClients = new List<Id>();
    public Boolean bolShowSessionEnd {get;set;}
    public Boolean bolCareerExFlag {get;set;}
    public String strConflictMessage {get;set;}
    public Integer intMaxEnrollment {get;set;}
    public Integer intSessionLimit;
    public Map<String, Id> mapClientRecTypes {get;set;}
    public Class__c clSearchClass {get;set;}
    public String lstProgramsServed {get;set;}
    public List<SelectOption> soSearchType {get;set;}
    public String strSearchType {get;set;}
    public Boolean bolConflictFlag;
    public List<Session__c> lstSessions = new list<Session__c>();
    
    
    public String strTest {get;set;}
    
    ////////////////////////////////////////////
    // Helper Classes
    ////////////////////////////////////////////
        
    public class clientsForDisplay {
        
        public Contact con {get;set;}
        public Event evtForSingleClass {get;set;}
        public Boolean chk {get;set;}
        public Boolean bolEnrolled {get;set;}
        public Boolean bolUseExistingEnrollment = false;
        public Boolean isAAExtension = false;
        public Date OrigExitDate = null;
        public String strBGColor {get;set;}
                
    }

    /////////////////////////////////////////
    // Class Constructors / GETers
    /////////////////////////////////////////
    
    public courseEnrollment() { }
    
    public void init() {
        
        if(strClassId == null) { strClassId = ApexPages.currentPage().getParameters().get('c'); }
        
        // Class and Schedule Objects
        schClass = [SELECT Id, Start_Date__c, End_Date__c, Monday__c, Tuesday__c, Wednesday__c, 
        Thursday__c, Friday__c, Saturday__c, Sunday__c, Monday_Start_Time__c, Monday_End_Time__c, 
        Tuesday_Start_Time__c, Tuesday_End_Time__c, Wednesday_Start_Time__c, Wednesday_End_Time__c, 
        Thursday_Start_Time__c, Thursday_End_Time__c, Friday_Start_Time__c, Friday_End_Time__c, 
        Saturday_Start_Time__c, Saturday_End_Time__c, Sunday_Start_Time__c, Sunday_End_Time__c 
        FROM Schedule__c WHERE Class__c = :strClassId LIMIT 1];
        
        clCurrent = [SELECT Id, AreaRPT__c, CategoryRPT__c, Program_Cycle__c, Class_Title__c, 
        Suggested_Max_Size__c, Instructor_1__r.Name, Instructor_1__c, RecordTypeId, Record_Type_RPT__c, 
        Enroll_Referral_Only_New__c, Default_Starting_Session__c, Default_Ending_Session__c, 
        Enrollment_Limit_Start__c, Programs_Served__c FROM Class__c WHERE Id = :strClassId];
        
        //holding variable for our search screen; default values will be whatever is set at the class
        this.clSearchClass = clCurrent;       

        setSessionStart();
        
        // Search Variables
        evtSearch = new Event();
        evtSearch.ActivityDate = schClass.Start_Date__c.date();
        
        // Get Max Enrollment Warning Limit
        System_Limits__c CS = System_Limits__c.getInstance();
        intMaxEnrollment = Integer.valueOf(CS.Max_Enrollment__c);
        
        // Build Weekly Schedule UI String
        strSchedule = '';
        
        if(clCurrent.RecordTypeId == Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Single').getRecordTypeId()) {
            strSchedule = schClass.Start_Date__c.format('EEEE h:mm a') + ' - ' + schClass.End_Date__c.format('h:mm a'); 
        } else {
            if(schClass.Monday__c) { strSchedule += 'Mon, ' + schClass.Monday_Start_Time__c.format('h:mm a') + ' - ' + schClass.Monday_End_Time__c.format('h:mm a') + '<br />'; }
            if(schClass.Tuesday__c) { strSchedule += 'Tue, ' + schClass.Tuesday_Start_Time__c.format('h:mm a') + ' - ' + schClass.Tuesday_End_Time__c.format('h:mm a') + '<br />'; }
            if(schClass.Wednesday__c) { strSchedule += 'Wed, ' + schClass.Wednesday_Start_Time__c.format('h:mm a') + ' - ' + schClass.Wednesday_End_Time__c.format('h:mm a') + '<br />'; }
            if(schClass.Thursday__c) { strSchedule += 'Thu, ' + schClass.Thursday_Start_Time__c.format('h:mm a') + ' - ' + schClass.Thursday_End_Time__c.format('h:mm a') + '<br />'; }
            if(schClass.Friday__c) { strSchedule += 'Fri, ' + schClass.Friday_Start_Time__c.format('h:mm a') + ' - ' + schClass.Friday_End_Time__c.format('h:mm a') + '<br />'; }
            if(schClass.Saturday__c) { strSchedule += 'Sat, ' + schClass.Saturday_Start_Time__c.format('h:mm a') + ' - ' + schClass.Saturday_End_Time__c.format('h:mm a') + '<br />'; }
            if(schClass.Sunday__c) { strSchedule += 'Sun, ' + schClass.Sunday_Start_Time__c.format('h:mm a') + ' - ' + schClass.Sunday_End_Time__c.format('h:mm a') + '<br />'; }
        }
        
        // Potential Enrollees search box
        if(clCurrent.Enroll_Referral_Only_New__c == 'Yes') {
            intEnrollees = 1;
        } else {
            intEnrollees = 0;
        }
        
        // Determine if this Class is a Fixed Type (UI Flags)
        if(clCurrent.RecordTypeId == Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Fixed').getRecordTypeId()
            && clCurrent.Default_Ending_Session__c != 'Single Session Only') 
        {
            bolShowSessionEnd = true;
        } else {
            bolShowSessionEnd = false;
        }
        
        // Determine if this Class is a CareerEx class (UI Flags)
        if(clCurrent.CategoryRPT__c == 'Career Exploration Training') {
            bolCareerExFlag = true;
        } else {
            bolCareerExFlag = false;
        }
        
        //set defaults as assigned at class level
        this.intSessionLimit = (Integer)clCurrent.Enrollment_Limit_Start__c;
        
        //20120626 ebg - get record types for clients so we can use them as search values
        //                  Strip out the word 'Client' so the values we pick match what is in the Program(s) Served picklists
        this.mapClientRecTypes = new Map<String, Id>();
        for (RecordType rt : [Select Id, Name 
                                    From RecordType 
                                    Where IsActive = true 
                                        And SobjectType = 'Contact' 
                                        And Name like '%Client%' 
                                    Order By Name]) {
            
            String strProgramName = rt.Name;
            system.debug('\n\nstrProgramName1: ' + strProgramName);
            strProgramName = strProgramName.replace('Client', '').trim();
            system.debug('\n\nstrProgramName2: ' + strProgramName);
            this.mapClientRecTypes.put(strProgramName, rt.Id);
                                        
        }
        
        //variable deteremining if search is for name only or for all filter items
        this.soSearchType = new List<SelectOption>();
        this.soSearchType.add(new SelectOption ('NameOnly', 'Search by Client Name Only'));
        this.soSearchType.add(new SelectOption ('AllFilters', 'Search using All Filters'));
        
        this.strSearchType = 'AllFilters';
                
    }
    
    public void changeSearchType() {
        //if we changed our search type, clear out the Name field if we switched back to "All Filters"
        if (this.strSearchType == 'AllFilters' && this.evtSearch.Closed_By__c == '<Enter a client name>') {
            this.evtSearch.Closed_By__c = null;
        }   
    }
    
    public List<clientsForDisplay> getClients() {
        
        String strInitialQuery = 'SELECT Id, Name, P_C_id__c, Case_Coordinator__r.Name, Current_Exit_Date__c, Current_Projected_Exit_Date__c, Client_Status__c, RecordType.Name FROM Contact ';
        String strCriteria = 'WHERE RecordType.Name like \'%Client%\' ';
        String strOrder = ' ORDER BY Name ASC';
        
        //20120626 ebg - if Program(s) Served is populated on the search page, find the associated record type id so we can limit
        //                  the client search to just those record types.  Our client record types are already stored in a list we
        //                  populated during the INIT routine, so loop through the selected values and find the corresponding ID
        if (this.clSearchClass.Programs_Served__c != null && this.strSearchType == 'AllFilters') {
            strCriteria += ' AND RecordTypeId IN (';
            for (String strProgramServed : this.clSearchClass.Programs_Served__c.split(';')) {
                strCriteria += '\'' + this.mapClientRecTypes.get(strProgramServed) + '\',';
            }
            //remove the extra comma at the end of the string
            strCriteria = strCriteria.substring(0, strCriteria.length()-1);
            strCriteria += ')';
        }

        // Name Search Only
        //we don't want to search for a blank name if our search type is 'NameOnly'
        if (evtSearch.Closed_By__c == null && this.strSearchType == 'NameOnly') 
        { 
            evtSearch.Closed_By__c = '<Enter a client name>'; 
        }
        
        if (evtSearch.Closed_By__c != null) 
        {
            strCriteria += ' AND Name LIKE \'%' + evtSearch.Closed_By__c + '%\'';
        }
        
        
        //20120626 ebg - everything below here only applies if 'AllFilters' is selected
        
        // Active
        if(intEnrollees == 0 && this.strSearchType == 'AllFilters') 
        {
            strCriteria += ' AND Client_Status__c = \'Active\'';
        }
        
        // Referred Criteria
        if(intEnrollees == 1) { //&& this.strSearchType == 'AllFilters') { MB 10/21/13: referred filter should always be applied
            lstReferredClients.clear();
            List<Task> lstEnrolledClientIds = [SELECT WhoId 
                                                FROM Task 
                                                WHERE WhatId = :strClassId 
                                                    AND RecordTypeId = :Schema.SObjectType.Task.getRecordTypeInfosByName().get('Career Exploration Referral').getRecordTypeId() 
                                                    AND Status != 'Rejected'];
            
            String strEnrolledClients = '';
            Integer intCounter = 0;
            for(Task t : lstEnrolledClientIds) {
                if(intCounter == 0) {
                    System.Debug('FIRST RUN');
                    strEnrolledClients = '\'' + t.WhoId + '\'';
                } else {
                    System.Debug('SECOND+ RUN');
                    strEnrolledClients += ', \'' + t.WhoId + '\'';
                }
                
                intCounter += 1;
            }
            
            if(lstEnrolledClientIds.size() > 0) { 
                strCriteria += ' AND Id IN (' + strEnrolledClients + ') ';
            } else {
                strCriteria += ' AND Id IN (\'003P000000xxxxx\') '; //This is a fake ContactId to return zero results
            }
            
        }
        
        // CEP Graduates within 2 yrs
        if(intEnrollees == 2 && this.strSearchType == 'AllFilters') {
            Date dteTwoYearsAgo = System.Today().addYears(-2);
            
            // 4/25/14 MB added exit type field for ABH programs and fixed logic 
            // (was previously Current_Exit_Date__c < NEXT_N_DAYS:730, which looks at the future)
            strCriteria += ' AND (Current_Exit_Type__c = \'S\' or PRP_Status__c = \'Successful Exit\' )'
            + ' AND Current_Exit_Date__c > :dteTwoYearsAgo';
        }
        
        // Non-CEP Clients       
      // QC*20120710 refine criteria, must have at least completed training in previous cycle 
      // AND contact.CX grad date is null -- to exclude those who have completed internship)
     // Completed Requirements
    if(intEnrollees == 5 && this.strSearchType == 'AllFilters') {
      Double dblProgramCycle = clCurrent.Program_Cycle__c;
      List<Program_Stage__c> lstStages = [Select Name, Client_Name__c, Stage__c, Program_Cycle__c 
                            From Program_Stage__c 
                            WHERE ((Stage_Number__c >= 50 and Stage_Number__c < 80) or Stage_Number__c =3)
                              AND Program_Cycle__c = :dblProgramCycle];
  
 
            system.debug('\n\n***dblProgramCycle: ' + dblProgramCycle + '\nlstStages: ' + lstStages);
            
            String strEnrolledClients = '';
            Integer intCounter = 0;
            for(Program_Stage__c ps : lstStages) {
                if(intCounter == 0) {
                    System.Debug('FIRST RUN');
                    strEnrolledClients = '\'' + ps.Client_Name__c + '\'';
                } else {
                    System.Debug('SECOND+ RUN');
                    strEnrolledClients += ', \'' + ps.Client_Name__c + '\'';
                }
                
                intCounter += 1;
            }
            
            if(lstStages.size() > 0) { 
                strCriteria += ' AND Id IN (' + strEnrolledClients + ') ';
            } else {
                strCriteria += ' AND Id IN (\'003P000000xxxxx\') '; //This is a fake ContactId to return zero results
            }
            
            
            strCriteria += ' AND Career_Ex_Grad_Date__c = NULL ';
            
        }
        
        String strQuery = strInitialQuery + strCriteria + strOrder;
        
        System.Debug('courseEnrollment.getClients INFO:  strQuery = ' + strQuery);
        
        List<Contact> lstContact = Database.query(strQuery + ' LIMIT 999');
        
        lstEnrollees.clear();
        
        Session__c minSession;
        if(strSessionStart == null) {
            minSession = [SELECT Id FROM Session__c WHERE Schedule__c = :schClass.Id ORDER BY Session_Start__c ASC NULLS LAST LIMIT 1];
        } else {
            minSession = [SELECT Id FROM Session__c WHERE Id = :strSessionStart];
        }
        List<Event> lstCurrentlyEnrolledEvents = [SELECT WhoID, Verification_Status__c, ClassTypeRPT__c
        from Event WHERE WhatID = :minSession.Id];
        
        Map<Id, Event> mapClientsToSingleSessions = new map<Id, Event>();
        
        for(Event e: lstCurrentlyEnrolledEvents) {
            
            if(e.ClassTypeRPT__c == Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Single').getRecordTypeId()) 
            {
                mapClientsToSingleSessions.put(e.whoId, e);
            }
        }
                
        // Initial Row Coloring BT-316
        String strLoopBGColor = '#ffffff';
        
        for(Contact c : lstContact) {
            System.Debug('courseEnrollment.init INFO:  Adding ' + c.Id + ' to List of Enrollees');
            clientsForDisplay nClientForDisplay = new clientsForDisplay();
            nClientForDisplay.con = c;
            if(mapClientsToSingleSessions.containsKey(c.id)) {
                nClientForDisplay.evtForSingleClass = mapClientsToSingleSessions.get(c.id);
            } else {
                nClientForDisplay.evtForSingleClass = new Event(Verification_Status__c = 'Not Verified');
            }
            nClientForDisplay.chk = false;
            nClientForDisplay.bolEnrolled = true;
            
            // Handle Row Coloring BT-316
            if(strLoopBGColor == '#ffffff') {
                nClientForDisplay.strBGColor = strLoopBGColor;
                strLoopBGColor = '#dfdfdf';
            } else {
                nClientForDisplay.strBGColor = strLoopBGColor;
                strLoopBGColor = '#ffffff';
            }
            
            for(Event enr : lstCurrentlyEnrolledEvents) 
            {
                if(c.Id == enr.WhoID) 
                {
                    system.debug('event: ' + enr.ID + '\n contact: ' + c.id);
                    nClientForDisplay.bolEnrolled = false;
                }
            }            
            
            lstEnrollees.add(nClientForDisplay);
            
        }
        
        System.Debug('courseEnrollment.init INFO:  Returning List of Enrollees');
        return lstEnrollees;
        
    }
    
    public List<selectOption> getSearchOptions() {
        
        List<selectOption> lstOptions = new List<selectOption>();
        
        if(clCurrent.Enroll_Referral_Only_New__c == 'Yes') {
            lstOptions.add(new selectOption('1', 'Referred'));
        } else {
            lstOptions.add(new selectOption('0', 'Active'));
            lstOptions.add(new selectOption('1', 'Referred'));
            lstOptions.add(new selectOption('2', 'Graduates within 2 yrs'));
            lstOptions.add(new selectOption('5', 'Completed Requirements'));
        }
        
        
        
        return lstOptions;
    }
    
    public void setSessionStart() {
        
        Schedule__c schCur = [SELECT Id FROM Schedule__c WHERE Class__c = :strClassId];
        lstSessions = [SELECT Id, Session_Start__c FROM Session__c WHERE Schedule__c = :schCur.Id 
                        AND Session_Start__c >= :System.now().AddDays(-45)
                        ORDER BY Session_Start__c ASC];
            
        Integer intSessionCount = 0; 
        for (Session__c s : lstSessions) {
            if (this.intSessionLimit == null || intSessionCount < this.intSessionLimit) {
                
                //set the default based on the value from the class
                if (this.clCurrent.Default_Starting_Session__c == 'First Session in Class' && intSessionCount == 0) {
                    this.strSessionStart = s.Id;
                } else if (this.clCurrent.Default_Starting_Session__c == 'Today or Next Future Session' && this.strSessionStart == null && s.Session_Start__c >= date.today()) {
                    this.strSessionStart = s.Id;
                }
                intSessionCount++;
                
            } else {
                //no need to keep looping through the sessions if we've hit our limit
                break;
                
            }
            
        }       
        
        
    }
    
    //10/21/13 MB: the list of selectOptions is now a void method, and the list is calculated from the result of that method
    // This was done because sessionStart needs to be set in init() so that the correct day's events are pulled
    //on initialization, which is before the selectOptions are loaded
    public List<selectOption> getSessionStart() {
        
        List<selectOption> lstOptions = new List<selectOption>();
         
        for (Session__c s : lstSessions) {
            
            lstOptions.add(new selectOption(string.valueOf(s.Id), string.valueOf(s.Session_Start__c.date())));             
        }
        
        return lstOptions;
        
    }
    
    public List<selectOption> getSessionEnd() {
        
        List<selectOption> lstOptions = new List<selectOption>();
        lstOptions.add(new selectOption('0', 'Sessions up to Client\'s projected exit date'));
        lstOptions.add(new selectOption('1', 'Sessions up to last Class date'));
        lstOptions.add(new selectOption('2', 'Single session only'));
        
        if (this.clCurrent.Default_Ending_Session__c != null) {
            if (this.clCurrent.Default_Ending_Session__c == 'Sessions up to Client\'s projected exit date') {
                this.intSessionEnd = 0;
            } else if (this.clCurrent.Default_Ending_Session__c == 'Sessions up to last Class date') {
                this.intSessionEnd = 1;
            } else if (this.clCurrent.Default_Ending_Session__c == 'Single session only') {
                this.intSessionEnd = 2;
            }
        }
        
        return lstOptions;
        
    }
    
    ///////////////////////////////////////////
    // Action Classes
    ///////////////////////////////////////////
    
    public void doNothing() { }
    
    public PageReference printRoster() {
        
        PageReference pfRoster = new PageReference('/apex/courseRoster?c=' + strClassId 
        + '&s=' + strSessionStart);
        pfRoster.setRedirect(true);
        return pfRoster;
        
    }
    
    public PageReference verificationPage() {
        
        PageReference pfVerify = new PageReference('/apex/courseGrading?c=' + strClassId 
        + '&t=' + clCurrent.CategoryRPT__c + '&a=' + clCurrent.AreaRPT__c);
        pfVerify.setRedirect(true);
        return pfVerify;
        
    }    
    
    public PageReference viewConflicts() {
        
        PageReference pfRoster = new PageReference('/apex/courseConflict?c=' + strClassId);
        pfRoster.setRedirect(true);
        return pfRoster;
        
    }
    
    public PageReference enrollAndCheckConflicts() {
        
        enrollClients();
        PageReference pfRoster;
        if(bolConflictFlag) {
            pfRoster = new PageReference('/apex/courseConflict?c=' + strClassId);   
            pfRoster.setRedirect(true); 
        }
        
        return pfRoster;        
    }
    
    public PageReference createCeXPInterview() {
        
        PageReference pfCeXP = new PageReference('/apex/courseEnrollment?c=' + strClassId);
        pfCeXP.setRedirect(true);
        return pfCeXP;
        
    }
    
    public PageReference cancelAndReturn() {
        
        PageReference pfCancel = new PageReference('/apex/courseCatalog');
        pfCancel.setRedirect(true);
        return pfCancel;
        
    }
    
    public void enrollClients() {
        
        System.Debug('courseEnrollment.enrollClients INFO: START');
        Boolean bolDupeCheckFlag;
        bolConflictFlag = false;
        
        // Data Check
        if(clCurrent == null) {
            clCurrent = [SELECT Id, AreaRPT__c, CategoryRPT__c, Program_Cycle__c, Class_Title__c, 
            Suggested_Max_Size__c, Instructor_1__r.Name, Instructor_1__c, RecordTypeId, Enroll_Referral_Only_New__c 
            FROM Class__c WHERE Id = :strClassId];
        }
        
        List<Event> lstCreateEvents = new List<Event>();
        List<Enrollment_Conflict__c> lstCreateConflictEnrollments = new List<Enrollment_Conflict__c>();
        List<Enrollment__c> lstOutdatedEnrollments = new List<Enrollment__c>();
        
        schClass = [SELECT Id FROM Schedule__c WHERE Class__c = :strClassId LIMIT 1];
        
        Map<Id,Contact> clientMap = new Map<Id,Contact>();
        List<Id> lstContactIds = new List<Id>();
        List<Enrollment__c> lstCurrentlyEnrolled = new List<Enrollment__c>();
        
        lstCurrentlyEnrolled = [SELECT ID, Client__c, Client_Class_Status_Field__c FROM Enrollment__c WHERE Class__c = :strClassId AND Most_Recent_Enrollment__c = true];

        system.debug('lstCurrentlyEnrolled INFO: ' + lstCurrentlyEnrolled);
        // Check for Previous Enrollments
        for(clientsForDisplay cd : lstEnrollees) {
            if(cd.chk) { 
                for(Enrollment__c e : lstCurrentlyEnrolled) {
                    if(e.Client__c == cd.con.Id && cd.bolUseExistingEnrollment == false) {
                        System.Debug('courseEnrollment.enrollClients INFO: ' + cd.con.Name + ' is already enrolled, marking previous enrollment as NOT CURRENT');
                            if(e.Client_Class_Status_Field__c == 'Active') {
                            cd.bolUseExistingEnrollment = true; 
                            } else {
                            e.Most_Recent_Enrollment__c = false;
                            lstOutdatedEnrollments.add(e);
                        }
                    }
                }
                    
                clientMap.put(cd.con.id, cd.con);
                lstContactIds.add(cd.con.id); 
            }
        }       
        
        
        // Determine Start Date Bound for Enrollments
        Session__c sesSelected;
        if(strSessionStart == null) {
            sesSelected = [SELECT Session_Start__c FROM Session__c WHERE Schedule__c = :schClass.Id LIMIT 1];
        } else {
            sesSelected = [SELECT Session_Start__c FROM Session__c WHERE Id = :strSessionStart];
        }
        

        // Get Sessions for this Class
        List<Session__c> lstSessions = new List<Session__c>();
        lstSessions = [SELECT Id, Session_Start__c, Session_End__c, Assigned_To__c FROM Session__c WHERE Schedule__c = :schClass.Id AND Session_Start__c >= :sesSelected.Session_Start__c ORDER BY Session_Start__c];
        List<Id> lstSessionIds = new List<Id>();
        
        for(Session__c s : lstSessions) {
            lstSessionIds.add(s.Id);
        }
        
        // Get List of existing events for conflict reporting
        // BT-310 20120131 AAB - Added Status != 'Cancelled' AND Status != 'Withdrawn' to SOQL statement below
        // BT-308 20120131 AAB - Moved RecordTypeId != :utilIDs.courtDate from parenthesis to full inline in SOQL statement below  
        List<Event> lstEvt = new List<Event>();
        lstEvt = [SELECT Id, RecordTypeId, ActivityDate, WhoId, WhatId, ActivityDateTime, StartDateTime, EndDateTime FROM Event 
        WHERE WhoId IN :lstContactIds
        AND Verification_Status__c != 'Cancelled' 
        AND Verification_Status__c != 'Withdrawn' 
        AND IsDeleted = false 
        AND IsRecurrence = false 
        AND StartDateTime >= :System.Now() 
        AND RecordTypeId != :Schema.SObjectType.Event.getRecordTypeInfosByName().get('Court Date').getRecordTypeId()
        AND (RecordTypeID != :Schema.SObjectType.Event.getRecordTypeInfosByName().get('Case Coordination').getRecordTypeId()
        AND Subject != 'Program Reporting')];
        
        // Get List of existing Class Events to avoid duplicates
        List<Event> lstClassEvents = new List<Event>();
        lstClassEvents = [SELECT Id, WhoId, WhatId FROM Event WHERE WhoId IN :lstContactIds AND WhatId IN :lstSessionIds];
        system.debug('lstClassEvents INFO: ' + lstClassEvents);
        system.debug('lstSessionIds INFO: ' + lstSessionIds);        
        system.debug('lstContactIds INFO: ' + lstContactIds);         
        
        //MB 10/22/12 Get existing conflicts so duplicate enrollment conflicts aren't created
        List<Enrollment_Conflict__c> lstExistingConflicts = new List<Enrollment_Conflict__c>();
        lstExistingConflicts = [select Id, Conflict_Session__c, Conflicting_Appointment__c from Enrollment_Conflict__c where Conflict_Session__c in :lstSessionIds];
        system.debug(lstExistingConflicts);
        Map<Id, Id> mapExistingConflicts = new Map<Id,Id>();
        for(Enrollment_Conflict__c ec : lstExistingConflicts) {
            mapExistingConflicts.put(ec.Conflicting_Appointment__c, ec.Conflict_Session__c);
        }
        
        
        Boolean bolCreateEvent;

        for(clientsForDisplay cd : lstEnrollees) {
            if(cd.chk) {               
                System.Debug('courseEnrollment.enrollClients INFO:  Processing Client ' + cd.con.id);
                
                ////////////////////////////////////
                // Create or Find Enrollment Object
                ////////////////////////////////////
                
                Enrollment__c enr = null;
                system.debug(enr);
                if(cd.bolUseExistingEnrollment == true) {
                    for(Enrollment__c e : lstCurrentlyEnrolled) {
                        if(e.Client__c == cd.con.id) { 
                            enr = e;
                            break;
                        }
                    }
                }
                
                
                
                // Make new Enrollment if enr = null
                if(enr == null) {
                    enr = new Enrollment__c();
                    enr.Class__c = strClassId;
                    enr.Client__c = cd.con.id;
                    //added 12/3/13 for enrollment in single session only
                    if(intSessionEnd == 2) {
                        enr.Client_Class_Status_Field__c = 'Completed';
                    } else {
                        enr.Client_Class_Status_Field__c = 'Active';
                    }   
                    enr.Most_Recent_Enrollment__c = true;
                    insert enr;
                }
                
                
                
                // Loop through Class / Schedule Sessions
                Integer intLastSession = 1;
                for(Session__c s : lstSessions) {
                    
                    // Reset Event Creation Flag
                    bolCreateEvent = true;
                    
                    // Check for Existing Event Conflict
                    for(Event e : lstEvt) {
                        system.debug('Event Conflict loop. event: ' + e.id);
                        if(e.WhoId == cd.con.id) {
                            system.debug('event start: ' + e.StartDateTime + '\n event end: ' + e.enddatetime + '\n session start: ' + s.session_start__c + '\n session end: ' + s.session_end__c);
                                    
                            if((e.StartDateTime >= s.Session_Start__c && e.StartDateTime < s.Session_End__c) ||
                                (e.EndDateTime > s.Session_Start__c && e.EndDateTime <= s.Session_End__c)) {                
                                    
                                bolCreateEvent = false;
                                
                                //////////////////////////////////////
                                // INSERT Enrollment_Conflict__c
                                //////////////////////////////////////
                                
                                    //update 10/2/12 MB: Don't create an enrollment conflict if the conflicting event is an enrollment in the same session
                                    
                                    if(e.WhatId==s.Id) {
                                        
                                    }
                                    
                                    //update 10/22/12 MB: Don't create enrollment conflict if the enrollment conflict already exists
                                    else if(mapExistingConflicts.get(e.Id)==s.Id) {
                                        
                                        //but still go to conflict page if conflicts already exist
                                        bolConflictFlag = true;
                                    }
                                    
                                    else {
                                        System.Debug('courseEnrollment.enrollClients INFO:  SCHEDULE CONFLICT! ' + s.Session_Start__c);
                                        Enrollment_Conflict__c ec = new Enrollment_Conflict__c();
                                        ec.Conflict_Session__c = s.Id;
                                        ec.Enrollment__c = enr.Id;
                                        ec.Conflicting_Appointment__c = e.Id;
                                        
                                        lstCreateConflictEnrollments.add(ec);
                                        bolConflictFlag = true;
                                    }
                                }                        
                            }
                        }
                system.debug(bolCreateEvent);    
                // update 10/2/12 MB: do not create an event if this client is being extended and this session is earlier than the first one they were originally enrolled in
                    if(cd.isAAExtension && cd.OrigExitDate >= s.Session_Start__c) {
                        bolCreateEvent = false; 
                    }               
                system.debug(bolCreateEvent);
                system.debug(cd.isAAextension);
                system.debug(cd.origexitdate);
                system.debug(s.session_start__c);                
                    
                    // END DATE LOGIC - Fixed Class is the only RecordType that has business rules - Single and Ongoing are the same across
                    // User requested Enrollment through Client's Projected Exit Date
                    // EDIT BT-272 - adding "greater than or equal to" to the s.Session_Start__c conditionality below.
                    System.Debug('courseEnrollment.enrollClients INFO:  BEGIN TEST Session Limiter - does ' + s.Session_Start__c.Date() + ' falls beyond Client\'s Projected End Date of ' + clientMap.get(cd.con.id).Current_Projected_Exit_Date__c);
                    
                    // EDIT BT-272 - for some reason this isn't working properly...
    
                    if((clientMap.get(cd.con.id).Current_Projected_Exit_Date__c < s.Session_Start__c.Date()) && (intSessionEnd == 0 
                        || (clCurrent.RecordTypeId == Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Ongoing').getRecordTypeId()  
                        && clientMap.get(cd.con.id).Client_Status__c != 'Exited'))) 
                    {
                        System.Debug('courseEnrollment.enrollClients INFO:  Session Limiter - ' + s.Session_Start__c.Date() + ' falls beyond Client\'s Projected End Date of ' + clientMap.get(cd.con.id).Current_Projected_Exit_Date__c + ' intSessionEnd = ' + intSessionEnd);
                        bolCreateEvent = false;
                    } else if(intSessionEnd == 2 && intLastSession > 1) {
                        System.Debug('Session Limiter - ' + s.Session_Start__c.Date() + ' will not be processed as this is class is Single Session Only.');
                        bolCreateEvent = false;
                        //exit loop, no need to process other sessions for this client
                        break;
                    }
                                    
                    ///////////////////////////////////
                    // INSERT Event for Client
                    ///////////////////////////////////
                    if(bolCreateEvent == true) {
                        
                        // Check for dupes
                        bolDupeCheckFlag = true;
                        
                        for(Event e : lstClassEvents) {
                            if(e.WhoId == cd.con.id && e.WhatId == s.Id) {
                                System.Debug('courseEnrollment.enrollClients INFO:  Duplicate Event found for this client on ' + s.Session_Start__c);
                                bolDupeCheckFlag = false;
                                break;
                            }
                        }
                        
                        if(bolDupeCheckFlag == true) {
                            System.Debug('courseEnrollment.enrollClients INFO:  Creating Event for ' + s.Session_Start__c);
                            Event evt = new Event();
                            
                            Long lngClassDuration = (s.Session_End__c.getTime() - s.Session_Start__c.getTime());
                            
                            evt.WhoId = cd.con.id;
                            evt.WhatId = s.Id;
                            evt.OwnerId = clCurrent.Instructor_1__c;
                            evt.Program_Cycle__c = clCurrent.Program_Cycle__c;
                            evt.Area__c = clCurrent.AreaRPT__c;
                            evt.Class_Category__c = clCurrent.CategoryRPT__c;
                            evt.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Course Catalog Class').getRecordTypeId();
                            evt.Subject = clCurrent.Class_Title__c;
                            evt.ActivityDateTime = s.Session_Start__c;
                            evt.ActivityDate = s.Session_Start__c.date();
                            evt.StartDateTime = s.Session_Start__c;
                            evt.EndDateTime = s.Session_End__c;
                            //check to make sure the event's status was set- it may not have been if the enrollClients()
                            //method was called from outside the page
                            if(cd.evtForSingleClass == null || cd.evtForSingleClass.Verification_Status__c == null) {
                                evt.Verification_Status__c = 'Not Verified';
                            } else {
                                evt.Verification_Status__c = cd.evtForSingleClass.Verification_Status__c;
                            }
                            evt.DurationInMinutes = Integer.valueOf(lngClassDuration) / 60000;
                            evt.ClassTypeRPT__c = clCurrent.RecordTypeId;
                            evt.SkipRestrictions__c = true;
                            
                            if(intLastSession == lstSessions.size() || intSessionEnd == 2) {
                                evt.LastClassRPT__c = true;
                            }
                            if(Integer.valueOf(lngClassDuration) / 60000 > 0) { lstCreateEvents.add(evt); }                     
                        }
                    }
                    
                    intLastSession ++;
                }
            }    
        
        }        
        
        // Insert Object Lists
        if(lstOutdatedEnrollments.size() > 0) { update lstOutdatedEnrollments; }
        if(lstCreateConflictEnrollments.size() > 0) { insert lstCreateConflictEnrollments; }
        if(lstCreateEvents.size() > 0) { 
            insert lstCreateEvents; 
            if(clCurrent.RecordTypeId == Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Single').getRecordTypeId()) 
            {
                crsGrading.setAttendeeEnrollmentStatus(lstCreateEvents, strClassId);
            }
        }
        
        // Set Conflict Text if necessary
        if(bolConflictFlag == true) 
        {
            //viewConflicts();
            //strConflictMessage = 'Schedule conflicts were found during the enrollment process.  You can view these conflicts ';
            //strConflictMessage += 'by clicking the \'View Conflicts\' button.';
        }
    }
}