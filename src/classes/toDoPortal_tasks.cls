public with sharing class toDoPortal_tasks {

    public utilityIds util = new utilityIds();
    public Portal_Filter__c toDoObject = new Portal_Filter__c();
    public String validationError {get;set;}
    public String strCareerExTaskId {get;set;}
    public String strEdVisitTaskId {get;set;}
    public String selToDo = '';
    public List<String> selToDoList = new list<String>();
    public List<tasksForDisplay> tskForDisplay = new List<tasksForDisplay>();
    public String[] toDoItems = new String[]{};
    public String caseLoadSelection; 
    public string ev {get;set;} 
    public string query;
    public String unitDivInitialClass = 'display:none;';
    public String staffDivInitialClass = 'display:none;';
    public String caseloadDivInitialClass = 'display:none;';
        
    public toDoPortal_tasks() {
        
        this.validationError = '';
        
        List<Portal_Filter__c> myTaskPf = [Select   //Type__c, 
                                                    Tasks_Caseload__c, 
                                                    Filter_By__c,
                                                    Query_From__c,
                                                    Query_To__c,
                                                    Tasks_Staff__c,  
                                                    Tasks_Unit__c,
                                                    Tasks_To_Do_Selection__c 
                                                    From Portal_Filter__c 
                                                    where OwnerId = :UserInfo.getUserId() 
                                                    //AND Type__c = 'Tasks' 
                                                    Limit 1];
                                                    
        system.debug('\n\nFilters for current user: ' + myTaskPf.size());   
                                                        
        
        /////////////////////////////////////////////////////////////
        // 20110614 ebg - if no filter found, create a holding record so the filters can be pre-populated
        /////////////////////////////////////////////////////////////
        if(myTaskPf.size()== 1) {
            
            this.toDoObject = myTaskPf[0];
            
        } else {
            
            this.toDoObject = new Portal_Filter__c();
            
        }
            
        //////////////////////////////////////////////////////////////////
        // New Requirement on 3/17 call - Default dates to Today and Today + 14 days
        //////////////////////////////////////////////////////////////////
        
        //removed 9/25/14 for performance reasons    
        //this.toDoObject.Query_From__c = System.Today().addYears(-1);
        this.toDoObject.Query_To__c = System.Today().addDays(14);
            
            
        if(this.toDoObject.Tasks_Caseload__c != null) {
                
            caseLoadSelection = this.toDoObject.Tasks_Caseload__c; 
                
        }
            
        if(this.toDoObject.Filter_By__c != null) {
                
            if(this.toDoObject.Filter_By__c == 'Caseload') {
                    
                 this.caseloadDivInitialClass = 'display:block;';
                    
            }
                
            if(this.toDoObject.Filter_By__c == 'Staff') {
                    
                 this.staffDivInitialClass = 'display:block;';
                    
            }
                
            if(this.toDoObject.Filter_By__c == 'Unit') {
                    
                 this.unitDivInitialClass = 'display:block;';
                    
            }
        }
            
        if(this.toDoObject.Tasks_To_Do_Selection__c != null) {

            String selToDo = this.toDoObject.Tasks_To_Do_Selection__c;
            
            List<String> selToDoList = selToDo.split(';');
            
            for(String  thisTD:selToDoList) {
                
                this.toDoItems.add(thisTD);
            
            }
        }
        
    }
    
    public void logSearch() {

    }       
    
    public Portal_Filter__c getthisPortalFilter() {
        
        return this.toDoObject;
    }
        
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //  TASK LOGIC  
    ///////////////////////////////////////////////////////////////////////////////////////////////////

        
        ////////////////////////////////////////////////////////
        // Return the inital Styles
        ////////////////////////////////////////////////////////
        
        public String getunitDivInitialClass() {
            
            if(this.toDoObject.Filter_By__c == 'Unit') {
                    
                this.unitDivInitialClass = 'display:block;';
                    
            }
                
            return this.unitDivInitialClass;
        }
        
        public String getstaffDivInitialClass() {
            
            if(this.toDoObject.Filter_By__c == 'Staff') {
                    
                 this.staffDivInitialClass = 'display:block;';
                    
            }
                
            return this.staffDivInitialClass;
        }
        
        public String getcaseloadDivInitialClass() {
            
            if(this.toDoObject.Filter_By__c == 'Caseload') {
                    
                 this.caseloadDivInitialClass = 'display:block;';
                    
            }
            
            return this.caseloadDivInitialClass;
            
        }
        ////////////////////////////////////////////////////////
        //
        //
        //
        ////////////////////////////////////////////////////////
        
        public void saveThisTaskFilter() {
            
            
            String toDoSelectionString = '';
            
            if(caseLoadSelection != null) {this.toDoObject.Tasks_Caseload__c = caseLoadSelection;}
            
            
            for(String thisToDo:toDoItems) {
                
                toDoSelectionString += thisToDo + ';';
                
            }
            
            if(this.toDoObject.Filter_By__c != 'Staff') {
                
                this.toDoObject.Tasks_Staff__c = null;
                this.staffDivInitialClass = 'display:none;';
            }
            
            if(this.toDoObject.Filter_By__c != 'Unit') {
                
                this.toDoObject.Tasks_Unit__c = null;
                this.unitDivInitialClass = 'display:none;';
            }
            
            if(this.toDoObject.Filter_By__c != 'Caseload') {
                
                this.toDoObject.Tasks_Caseload__c = null;
                this.caseloadDivInitialClass = 'display:none;';
            }
            
            
            
            this.toDoObject.Tasks_To_Do_Selection__c =  toDoSelectionString;
            //this.toDoObject.type__c = 'Tasks';
            upsert this.toDoObject;
            
        }
        
        ////////////////////////////////////////////////////////
        //
        //
        //
        ////////////////////////////////////////////////////////
        
        public String getQUery() {
            
            return query;
        }
        
        ////////////////////////////////////////////////////////
        //
        //
        //
        ////////////////////////////////////////////////////////
        
        public void settoDoObject(Portal_Filter__c toDoObject) {
            
            this.toDoObject = toDoObject;
        }
        

        ////////////////////////////////////////////////////////
        // Accessors
        ////////////////////////////////////////////////////////

        public List<SelectOption> gettoDoItems() {
         
            return util.toDoTabList;
        }
        
        
        public String[] gettoDoSelection() {
            
            return toDoItems;
        }
           
        public void settoDoSelection(String[] todoItems) {
            
            selToDoList.clear();
            for(String td: toDoItems) {
                
                selToDoList.addAll(td.split(';'));              
            }           
            
            toDoItems = selToDoList;
            this.toDoItems = selToDoList;
        }
        
        
        public List<SelectOption> getCaseload() {
         
            List<User> ccUsers = [Select Id , firstName, lastName 
            from User where isActive = true 
            and profileId = :util.caseCoordinatorStaff];            
            
            List<SelectOption> caseLoadLists = new List<SelectOption>();
            
            for(User thisUser:ccUsers) {

                caseLoadLists.add(new SelectOption(thisUser.Id,thisUser.firstName + ' ' + thisUser.lastName));
            }
                

            return caseLoadLists;
        }
         
        public String getselectedCaseLoad() {
            return caseLoadSelection;
        }
        
        public void setSelectedCaseLoad(String caseLoadSelection) {
            
            this.caseLoadSelection = caseLoadSelection;
        }  
              
      
        ////////////////////////////////////////////////////////
        // Determine color of date 
        ////////////////////////////////////////////////////////
        
        public string determineColor(Date taskDate) {
            
            String color = '#000000';
            
            // RED
            if(taskDate < System.Today()) {
                
                color = '#FF0000';
            }
            
            // YELLOW
            if(taskDate >= System.Today() && taskDate <= System.Today().addDays(3)) {
             
                color = '#FFFF00'; 
            }
            
            // GREEN
            if(taskDate > System.Today().addDays(3) && taskDate < System.Today().addDays(6) ) {
            
                color = '#008000';  
            }
            
            return color;
        }
        
        public List<tasksForDisplay> getToDoTasksTab() {
            
            system.debug(toDoItems);
            
            /////////////////////////////////////////
            // Build the query
            /////////////////////////////////////////
             query = 'Select Who.Name,Who.Id, WhoId, WhatId, RecordTypeId, Subject, Owner.Name, Owner.Id, OwnerId, Open_Date__c, ActivityDate, Class_Category__c From Task Where ';
            
            ////////////////////////////////////////////////////////
            // We can only pick tasks where open date  <= today
            ////////////////////////////////////////////////////////
            
                query += ' open_date__c <= ' + String.valueOf(System.today().addDays(5));
            
            
            ////////////////////////////////////////////////////////
            // Filter by Staff
            /////////////////////////////////////////////////////////
            
                if(this.toDoObject.Filter_by__c == 'Staff' && this.toDoObject.Tasks_Staff__c != null) {
                
                //  BT-089 AAB - 20110610
                //  query += ' AND OwnerId = \'' + this.toDoObject.ownerId +'\'';
                    query += ' AND OwnerId = \'' + this.toDoObject.Tasks_Staff__c +'\'';
                 
                }
            
            ////////////////////////////////////////////////////////
            // Filter by UNIT
            /////////////////////////////////////////////////////////
                
                if(this.toDoObject.Filter_by__c  == 'Unit' && this.toDoObject.Tasks_Unit__c != null) {
                
                    query += ' AND Unit__c = \''  + this.toDoObject.Tasks_Unit__c + '\''; 
                    
                }
                
            //////////////////////////
            // Due date logic 1
            //////////////////////////
                
                //20110614 ebg - only set the dueDateTo field is a value was entered by the user
                //String dueDateTo = String.valueOf(System.Today());
                String dueDateTo = '';
                
                this.validationError = '';
                
                System.debug('TEST: ' + this.toDoObject);
                if(this.toDoObject != null) {
                
                    System.debug('3holdingEvent.Query_To__c: ' + this.toDoObject.Query_To__c);
                    if(this.toDoObject.Query_To__c != null) {
                    
                        dueDateTo = String.valueOf(this.toDoObject.Query_To__c);
                    }
                }
                
                if (dueDateTo == '') {

                        //20110614 ebg - require a Due Date To
                        this.validationError = 'A value must be entered in the "Due Date To" filter';
                        //this.toDoObject.Query_To__c.addError(this.validationError);
                    
                } else {

                    query += ' AND ActivityDate <= '+ dueDateTo;
                    
                }
            
            system.debug('\n\ndueDateTo: ' + dueDateTo + '\nquery: ' + query);
            
            //////////////////////////
            // Due date logic 2
            //////////////////////////
            
                String dueDateFrom = String.valueOf(System.Today());
                System.debug('TEST: ' + this.toDoObject);
                if(this.toDoObject != null) {
                
                    System.debug('3holdingEvent.Query_From__c: ' + this.toDoObject.Query_From__c);
                    if(this.toDoObject.Query_From__c != null) {
                    
                        dueDateFrom = String.valueOf(this.toDoObject.Query_From__c);
                        //20110614 EBG - moved code here because a From date is not required
                        query += ' AND ActivityDate >= '+ dueDateFrom;
                    }
                }
                //20110614 EBG - move code up so From date is not defaulted if left blank
                //query += ' AND ActivityDate >= '+ dueDateFrom;

            //////////////////////////
            // Task record Type Logic
            //////////////////////////
            
            String taskIdCondition = '';
            
            system.debug('todoItems: ' + toDoItems);
            system.debug('selToDoList: ' + selToDoList);
            
            integer i = 0;
            
            for(Id  thisId:todoItems) {
                
                if(i == 0) {
                    
                    taskIdCondition += ' AND ( recordTypeId = \'' + thisId + '\' ';
                } else {
                
                    taskIdCondition += ' OR recordTypeId = \'' + thisId + '\' ';
                
                }
                
                i++;
                
                if(i == toDoItems.size()) {
                    
                    taskIdCondition += ' )';
                }
                
            }
        
            System.debug('taskCondion :' + taskIdCondition);
            
            query += taskIdCondition;
            
            /////////////////////////////////////
            
            //////////////////////////
            // caseLoadSelection
            //////////////////////////
            
            if(this.toDoObject.Filter_by__c  == 'Caseload') {
            
                List<Contact> caseLoadContacts = [Select Id from Contact Where (Case_Coordinator__c = :caseLoadSelection OR Team_Leader__c = :caseLoadSelection)];
                
                Set<Id> caseLoadContactIds = new Set<Id>();
                String caseLoadCondition = '';
                
                integer ii = 0;
                
                for(Contact thisContact:caseLoadContacts) {
                    
                    if(ii == 0) {
                    
                        caseLoadCondition += ' AND ( whoId = \'' + thisContact.Id + '\' ';
                    
                    } else {
                    
                        caseLoadCondition += ' OR whoId = \'' + thisContact.Id + '\' ';
                    
                    }
                    
                    ii++;
                    
                    if(ii == caseLoadContacts.size()) {
                        
                        caseLoadCondition += ' )';
                    }
                    
                    
                }
                
                System.debug('caseLoadCondition :' + caseLoadCondition);
            
                query += caseLoadCondition;
            }
            
            /////////////////////////////////////

        
            query += ' AND IsClosed = false LIMIT 1000';
                    
            
            System.Debug('QUERY: ' + query);
            
            tskForDisplay.clear(); /// CLEAR OUT PREVIOUS

            //20110614 ebg - only retrieve the records if all validation rules passed
            system.debug('\n\nthis.validationError: ' + this.validationError + '\n');
            
            if (this.validationError == '') {
                
                // Query DB
                List<Task> tasksFromQuery = Database.query(query);
                
                //20111012 AAB - pull all Career Ex Appointments
                // 4/10/13 MB: Pull classes as well, to get program cycle for link to new event edit page
                Set<Id> setClientIds = new Set<Id>();
                Set<Id> setClassIds = new Set<Id>();
                for(Task thisTask:tasksFromQuery) {
                    setClientIds.add(thisTask.WhoId);
                    setClassIds.add(thisTask.whatId);
                }
                
                // CEX Interview
                List<Event> lstCEXInterview = [SELECT Id, WhoId, WhatId, ActivityDate FROM Event 
                                               WHERE WhoId IN :setClientIds and Verification_Status__c = 'Not Verified'
                                               AND RecordTypeId = :util.careerExplorationAppointment
                                               order by whoId, ActivityDate asc];
                
                // Ed Visit
                List<Event> lstEdVisits = [SELECT Id, WhoId, WhatId FROM Event 
                                           WHERE WhoId IN :setClientIds AND RecordTypeId = :util.educationExternal 
                                           AND Subject = 'Ed Program Visit' AND (Verification_Status__c = 'Not Verified' or Verification_Status__c = '') Order BY WhoID ASC, ActivityDate Desc];
                
                Map<Id,Class__c> mapCEXClasses = new Map<Id, Class__c>([SELECT Id, Program_Cycle__c FROM Class__c 
                                                                        WHERE Id in :setClassIds]);             
                
                // Program Plans
                Map<Id, Program_Plan__c> mapProgramPlans = New Map<Id, Program_Plan__c>();
                List<Program_Plan__c> lstProgramPlans = [SELECT Client_Name__c, Id FROM Program_Plan__c 
                                                         WHERE Client_Name__c IN :setClientIds ORDER BY Client_Name__c ASC, CreatedDate DESC];
                
                for(Program_Plan__c p : lstProgramPlans) { 
                    
                    if (!mapProgramPlans.containsKey(p.Client_Name__c)) {mapProgramPlans.put(p.Client_Name__c, p);} 
                }
                
                // Assessments & Surveys
                List<Assessment__c> lstAssessments = [SELECT Id, RecordTypeId, Contact__c FROM Assessment__c 
                                                      WHERE Contact__c IN :setClientIds 
                                                      AND (RecordTypeId = :util.ccAssessmentRecordType OR
                                                      RecordTypeId = :util.ccAssessmentLockedRecordType OR 
                                                      RecordTypeId = :util.eduAssessmentRecordType OR 
                                                      RecordTypeId = :util.eduAssessmentLockedRecordType OR 
                                                      RecordTypeId = :util.subAbuseAssessmentRecordType OR
                                                      RecordTypeId = :util.subAbuseAssessmentLockedRecordType OR
                                                      RecordTypeId = :util.alumniSurveyRecordType OR
                                                      RecordTypeId = :util.alumniSurveyLockedRecordType) 
                                                      order by Assessment_Completed_On__c asc, CreatedDate asc Nulls Last];
                                                      
                Map<Id, Assessment__c> mapCCAssessments = new Map<Id, Assessment__c>();
                Map<Id, Assessment__c> mapEDUAssessments = new Map<Id, Assessment__c>();
                Map<Id, Assessment__c> mapSUBAssessments = new Map<Id, Assessment__c>();
                Map<Id, Assessment__c> mapALUAssessments = new Map<Id, Assessment__c>();
                
                for(Assessment__c a : lstAssessments) {
                    
                    if(a.RecordTypeId == util.ccAssessmentRecordType || a.RecordTypeId == util.ccAssessmentLockedRecordType) {
                        mapCCAssessments.put(a.Contact__c, a); 
                    }
                    
                    else if(a.RecordTypeId == util.eduAssessmentRecordType || a.RecordTypeId == util.eduAssessmentLockedRecordType) {
                        mapEDUAssessments.put(a.Contact__c, a); 
                    }
                    
                    else if(a.RecordTypeId == util.subAbuseAssessmentRecordType || a.RecordTypeId == util.subAbuseAssessmentRecordType) {
                        mapSUBAssessments.put(a.Contact__c, a);
                    }
                        
                    else if(a.RecordTypeId == util.alumniSurveyRecordType || a.RecordTypeId == util.alumniSurveyLockedRecordType) {
                        mapALUAssessments.put(a.Contact__c, a);                         
                    }                   
                }
                
                // Begin Task Loop
                Integer ROWID_COUNTER = 0;
                for(Task thisTask:tasksFromQuery) {
                    
                    tasksForDisplay nTskForDisplay = new tasksForDisplay();
                    nTskForDisplay.tsk = thisTask;
                    
                    // 4/14/13 MB: removed this because the link was already available in the "action" column,
                    // and having it in the open date column was preventing the column from sorting (jquery.tasksorter issue)
                    // Rearrest Check
                    //if(thisTask.RecordTypeId == util.rearrestCheckTask) { nTskForDisplay.showLink = true; } else { nTskForDisplay.showLink = false; }
                    
                    // Course Reg - Career Ex Action
                    if(thisTask.RecordTypeId == util.careerExplorationReferralTask) { 
                        
                        nTskForDisplay.bolCareerExActionScheduled = false;
                        // Check to see if there is a matching appointment
                        for(Event eLink : lstCEXInterview) {
                            if(thisTask.WhoId == eLink.WhoId && thisTask.WhatId == eLink.WhatId) {
                                nTskForDisplay.bolCareerExActionScheduled = true;
                                nTskForDisplay.strCareerExActionScheduled = eLink.Id;
                                break;
                            }                           
                        }
                        if(nTskForDisplay.bolCareerExActionScheduled == false) { 
                            
                            nTskforDisplay.bolCareerExActionUnScheduled = true;
                            
                            //display a link to a new, prepopulated event edit screen
                            nTskForDisplay.strCareerExActionScheduled = '00U/e?who_id='+thisTask.whoId
                            +'&what_id='+thisTask.whatId+'&RecordType=' + util.careerExplorationAppointment
                            + '&00N60000001rlYV=' + thisTask.Class_Category__c.replace(' ','+')
                            + (mapCEXClasses.get(thisTask.whatID) != null ? 
                            '&00N60000001rlYk=' + mapCEXClasses.get(thisTask.whatId).Program_Cycle__c : '')  
                            + '&ent=Event';                         
                        }
                    }
                    
                    // Ed Visit
                    if(thisTask.RecordTypeId == util.schoolVisitTask) { 
                        
                        nTskForDisplay.bolEdVisitScheduled = false;
                        // Check to see if there is a matching appointment
                        for(Event eLink : lstEdVisits) {
                            if(thisTask.WhoId == eLink.WhoId && thisTask.WhatId == eLink.WhatId) {
                                nTskForDisplay.bolEdVisitScheduled = true;
                                nTskForDisplay.strEdVisitScheduled = eLink.Id;
                            }                           
                        }
                        if(nTskforDisplay.bolEdVisitScheduled == false) { 
                            
                            nTskforDisplay.bolEdVisitUnScheduled = true;
                            
                            //display a link to a new, prepopulated event edit screen
                            nTskForDisplay.strEdVisitScheduled = '00U/e?who_id='+thisTask.whoId
                            +'&what_id='+thisTask.whatId+'&RecordType=' + util.educationExternal 
                            + '&evt5=Ed+Program+Visit'+ '&ent=Event';
                        }
                    }                   
                    
                    // Program Plan
                    if(mapProgramPlans.get(thisTask.WhoId) != null && (thisTask.RecordTypeId == util.ccCRSNoteTask ||
                        thisTask.RecordTypeId == util.ccProgressNoteTask ||
                        thisTask.RecordTypeId == util.psProgressNoteTask ||
                        thisTask.RecordTypeId == util.psCRSNoteTask ||
                        thisTask.RecordTypeId == util.initialProgramPlanTask ||
                        thisTask.RecordTypeId == util.incidentReportNoteTask )) {
                        
                        nTskForDisplay.bolProgramPlan = true;
                        nTskForDisplay.strProgramPlan = mapProgramPlans.get(thisTask.WhoId).Id;
                    }
                    
                    // Drug Test
                    if(thisTask.RecordTypeId == util.exitDrugTestTask ||
                        thisTask.RecordTypeId == util.initialDrugTestTask ||
                        thisTask.RecordTypeId == util.nextDrugTestTask) {
                    
                        nTskForDisplay.bolDrugTest = true;
                        nTskForDisplay.strDrugTest = 'a0Y/e?CF00N60000001rJHk=' + thisTask.Who.Name + '&CF00N60000001rJHk_lkid=' + thisTask.WhoId + '&retURL=%2F' + thisTask.WhoId + '&RecordType=' + util.drugTestRecordType + '&ent=01I600000002Mjo';
                    }
                    
                    // Rearrest Check
                    if(thisTask.RecordTypeId == util.rearrestCheckTask) {
                        nTskForDisplay.bolRearrestCheck = true;
                        nTskForDisplay.strRearrestCheck = thisTask.Id;
                    }
                    
  // outReach         
                 if(thisTask.RecordTypeId == util.outReachNeeded) {
                        nTskForDisplay.bolOutReach = true;
                        nTskForDisplay.strOutReach = thisTask.Id;
                    }                    
                    // Case Coordinator Assessment
                    if(thisTask.RecordTypeId == util.caseCoordinatorAssessmentTask) {
                        
                        nTskForDisplay.bolCCAAssessment = true;
                        if(mapCCAssessments.get(thisTask.WhoId) != null) {
                            nTskForDisplay.strCCAAssessment = mapCCAssessments.get(thisTask.WhoId).Id;                          
                        } else {
                            nTskForDisplay.strCCAAssessment = 'a0U/e?CF00N60000001rJHg=' + thisTask.Who.Name + '&CF00N60000001rJHg_lkid=' + thisTask.WhoId + '&retURL=%2F' + thisTask.WhoId + '&RecordType=' + util.ccAssessmentRecordType + '&ent=01I600000002Mjk';
                        }   
                    }
                    
                    // Education Assessment
                    if(thisTask.RecordTypeId == util.educationAssessmentTask) {
                        
                        nTskForDisplay.bolEDUAssessment = true;
                        if(mapEDUAssessments.get(thisTask.WhoId) != null) {
                            nTskForDisplay.strEDUAssessment = mapEDUAssessments.get(thisTask.WhoId).Id;                         
                        } else {
                            nTskForDisplay.strEDUAssessment = 'a0U/e?CF00N60000001rJHg=' + thisTask.Who.Name + '&CF00N60000001rJHg_lkid=' + thisTask.WhoId + '&retURL=%2F' + thisTask.WhoId + '&RecordType=' + util.eduAssessmentRecordType + '&ent=01I600000002Mjk';
                        }   
                    }
                    
                    // Substance Abuse Assessment
                    if(thisTask.RecordTypeId == util.substanceAbuseAssessmenTask) {
                        
                        nTskForDisplay.bolSUBAssessment = true;
                        if(mapSUBAssessments.get(thisTask.WhoId) != null) {
                            nTskForDisplay.strSUBAssessment = mapSUBAssessments.get(thisTask.WhoId).Id;                         
                        } else {
                            nTskForDisplay.strSUBAssessment = 'a0U/e?CF00N60000001rJHg=' + thisTask.Who.Name + '&CF00N60000001rJHg_lkid=' + thisTask.WhoId + '&retURL=%2F' + thisTask.WhoId + '&RecordType=' + util.subAbuseAssessmentRecordType + '&ent=01I600000002Mjk';
                        }   
                    }
                    
                    // Alumni Survey
                    if(thisTask.RecordTypeId == util.alumniSurveyTask ) {
                        
                        nTskForDisplay.bolALUAssessment = true;
                        if(mapALUAssessments.get(thisTask.WhoId) != null) {
                            nTskForDisplay.strALUAssessment = mapALUAssessments.get(thisTask.WhoId).Id;                         
                        } else {
                            nTskForDisplay.strALUAssessment = 'a0U/e?CF00N60000001rJHg=' + thisTask.Who.Name + '&CF00N60000001rJHg_lkid=' + thisTask.WhoId + '&retURL=%2F' + thisTask.WhoId + '&RecordType=' + util.alumniSurveyRecordType + '&ent=01I600000002Mjk';
                        }   
                    }
                    
                    // Indicator Color and add to display List
                    nTskForDisplay.color = determineColor(thisTask.ActivityDate);
                    tskForDisplay.add(nTskForDisplay);
                }
            }
                        
            return tskForDisplay;
        }
        
        ////////////////////////////////////////////////////////
        // ACTION CLASSES
        ////////////////////////////////////////////////////////
        
        public void doNothing() {  }
        
        
        ////////////////////////////////////////////////////////
        //
        // Helper class
        //
        /////////////////////////////////////////////////////////
        
        public class tasksForDisplay {
            public Task tsk {get;set;}
            public String color {get;set;}
            //public boolean showLink {get;set;}
            
            // Career Ex
            public boolean bolCareerExActionScheduled {get;set;}
            public boolean bolCareerExActionUnScheduled {get;set;}
            public String strCareerExActionScheduled {get;set;}
            
            // Program Plan
            public boolean bolProgramPlan {get;set;}
            public String strProgramPlan {get;set;}
            
            // Drug Test
            public boolean bolDrugTest {get;set;}
            public String strDrugTest {get;set;}
            
            // Rearrest Check
            public boolean bolRearrestCheck {get;set;}
            public String strRearrestCheck {get;set;}

   // outReach
            public boolean bolOutReach {get;set;}
            public String strOutReach {get;set;}
                        
            // Assessments
            public boolean bolCCAAssessment {get;set;}
            public String strCCAAssessment {get;set;}
            public boolean bolEDUAssessment {get;set;}
            public String strEDUAssessment {get;set;}
            public boolean bolSUBAssessment {get;set;}
            public String strSUBAssessment {get;set;}
            public boolean bolALUAssessment {get;set;}
            public String strALUAssessment {get;set;}           
            
            // Ed Visit
            public boolean bolEdVisitScheduled {get;set;}
            public boolean bolEdVisitUnScheduled {get;set;}
            public String strEdVisitScheduled {get;set;}
            
            
        }

}