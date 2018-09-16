public class classMethods 
{
    ///////////////////////////////////////////
    // This method manages Classes
    // Author:  AAB / DCS
    // Created:  20110418
    ///////////////////////////////////////////

    public Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();    
    public String strResult {get;set;}
    public String idClass {get;set;}
    public Integer intReferralOpen {get;set;}   
    public Class__c clCurrent {get;set;}
    public Task tskRef {get;set;}
    public System_Limits__c sd {get;set;}
    public Integer intDaysLapsed {get;set;}
    
    /////////////////////////////////////////
    // Class Constructors
    /////////////////////////////////////////
    public classMethods(ApexPages.StandardController controller) {}
    
    public classMethods() { }
    
    ///////////////////////////////////////////
    // Action Classes
    ///////////////////////////////////////////
    public void verifyCareerExReferral() 
    {
        idClass = ApexPages.currentPage().getParameters().get('id');
        System.Debug('classMethods.Constructor INFO:  idClass = ' + idClass);
        
        // Get Org System Defaults
        sd = System_Limits__c.getOrgDefaults();
        intDaysLapsed = Integer.valueOf(sd.CEXReferralWindow__c);
        
        // Get User List
        List<User> lstUsers = [SELECT Id, Name FROM User WHERE IsActive = true];
        Map<Id, User> mapUsers = new Map<Id, User>();
        for(User u : lstUsers) 
        {
            mapUsers.put(u.Id, u);
        }
        
        clCurrent = [SELECT Id, CategoryRPT__c, AreaRPT__c, Class_Title__c, Instructor_1__c, Program_Cycle__c, First_Session_On__c, RecordTypeId FROM Class__c WHERE Id = :idClass];
        
        // TEST CASE 1 - ONLY CareerEx Training Classes are eligible
        if(clCurrent.CategoryRPT__c != 'Career Exploration Training') 
        {
            // FAIL - Only class eligible for Referral are CareerEx Training
            intReferralOpen = 1;
        }
        
        // TEST CASE 1a - needs to have a schedule
        if(clCurrent.First_Session_On__c == null) 
        {
            intReferralOpen = 3;
        }
        
        // TEST CASE 2 - Class Start + 7 = no referrals can be made, return error message
        // Edited 20111109 AAB per Bug BT-271
        if(clCurrent.First_Session_On__c.AddDays(Integer.valueOf(sd.CEXReferralWindow__c)) >= System.Today()) 
        {
            // PASS - Process
            intReferralOpen = 0;
        } else {
            // FAIL - Present
            intReferralOpen = 2;
        }   
        
        // Instanciate new Task
        tskRef = new Task();
    }
    
    public PageReference createCareerExReferral() 
    {
        // Find out if there is an existing Career Ex Task
        // BT-333 Removed "AND IsClosed = false" and added Program Cycle info from the query per PA
        List<Task> lstExistingTask = [SELECT Id FROM Task 
            WHERE WhoId = :tskRef.WhoId 
            AND RecordTypeId = :Schema.SObjectType.Task.getRecordTypeInfosByName().get('Career Exploration Referral').getRecordTypeId()
            AND Program_Cycle__c = :clCurrent.Program_Cycle__c];
        if(lstExistingTask.size() > 0) 
        {
            tskRef.addError('There is already an existing Referral Task for this Client and this Cycle.  Please check your data and try again.');
            
            return null;
            
        } else {
        
            // Determine Proper Due Date
            Date dteActivityDate;
            if(System.Today() > clCurrent.First_Session_On__c) 
            {
                dteActivityDate = clCurrent.First_Session_On__c.addDays(7);
            } else {
                dteActivityDate = clCurrent.First_Session_On__c;
            }
            
            // Fill in remaining fields
            tskRef.WhatId = clCurrent.Id;
            tskRef.OwnerId = clCurrent.Instructor_1__c;
            tskRef.Subject = 'Career Exploration Referral';
            tskRef.Program_Cycle__c = clCurrent.Program_Cycle__c;
            tskRef.Class_Category__c = clCurrent.CategoryRPT__c;
            tskRef.Area__c = clCurrent.AreaRPT__c;
            tskRef.ActivityDate = dteActivityDate;
            tskRef.Open_Date__c = System.Today();
            tskRef.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Career Exploration Referral').getRecordTypeId();  
            tskRef.Automatically_Generated__c = True;
            insert tskRef;

            
            PageReference pfSuccess = new PageReference('/' + tskRef.Id + '?retURL=/' + clCurrent.Id);
            pfSuccess.setRedirect(true);
            return pfSuccess;
        }
        
        
    }
    
    public PageReference returnToClass() 
    {
        PageReference pfCancel = new PageReference('/' + idClass);
        pfCancel.setRedirect(true);
        return pfCancel;
    }
    
    /////////////////////////////////////////////////
    // Trigger-invoked Methods
    /////////////////////////////////////////////////
    
    public void classReporting(List<Class__c> lstClasses) 
    {
        System.Debug('classMethods.classReporting INFO:  Method Start');
        
        List<Id> lstCourseIds = new List<Id>();
        for(Class__c c : lstClasses) {
            lstCourseIds.add(c.Course__c);
        }
        
        // Populate Cycle Number Map (Career Ex)
        Map<Id, Integer> mapCycleNumbers = new Map<Id, Integer>();
        List<AggregateResult> lstCycle = [SELECT Course__c, MAX(Program_Cycle__c) MaxProgramCycle FROM Class__c WHERE CategoryRPT__c IN('Career Exploration Training', 'Career Exploration Support') GROUP BY Course__c];
        for(AggregateResult ar : lstCycle) 
        {
            Integer intMaxProgramCycle = Integer.valueOf(ar.get('MaxProgramCycle'));
            
            if(intMaxProgramCycle == null) 
            {
                intMaxProgramCycle = 1;
            } else {
                intMaxProgramCycle = intMaxProgramCycle + 1;
            }
            
            mapCycleNumbers.put(String.valueOf(ar.get('Course__c')), intMaxProgramCycle);
        }       
        
        List<Course__c> lstCourses = [SELECT Id, Area__c, Category__c FROM Course__c WHERE Id IN :lstCourseIds];
        
        for(Class__c c : lstClasses) {
            
            // Update Cycle Number 
            
            for(Course__c co : lstCourses) 
            {
                if(co.Id == c.Course__c) 
                {
                    System.Debug('classMethods.classReporting INFO:  Updating Area to ' + co.Area__c + ' and Category to ' + co.Category__c);
                    c.AreaRPT__c = co.Area__c;
                    c.CategoryRPT__c = co.Category__c;
                    
                    if(c.Program_Cycle__c == null && (co.Category__c == 'Career Exploration Training' || co.Category__c == 'Career Exploration Support')) 
                    {
                        c.Program_Cycle__c = mapCycleNumbers.get(co.Id);
                    }
                }
            }
        }       
    }
    
    public void createClass(List<Class__c> lstClasses) 
    {
        List<Id> lstCourseIds = new List<Id>();
        
        // TEST 1:  Only certain profiles can add Classes
        for(Class__c clAdd : lstClasses) 
        {
            if(csApexDefaults.Profiles_Authorized_to_Manage_Classes__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_2__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_3__c.contains(userInfo.getProfileId())) 
            {
            	//doNothing
            } else {
                clAdd.Name.addError('You are not authorized to create a Class.  Please see your manager if you feel this message is being displayed in error.');
            }
            
            lstCourseIds.add(clAdd.Course__c);
        }
        
        // Map through Course Description to Class Description - BT-220
        Map<Id, Course__c> mapCourses = new Map<Id, Course__c>([SELECT Course_Description__c, Serves_All_Programs__c, 
                                                                Programs_Served__c, Enroll_Referral_Only__c
                                                                FROM Course__c WHERE Id IN :lstCourseIds]);

        // set values on class if needed
        for(Class__c c : lstClasses) 
        {
            if(c.Class_Description__c == null || c.Class_Description__c == '') 
            {
                c.Class_Description__c = mapCourses.get(c.Course__c).Course_Description__c; 
            }
            
            if (c.Serves_All_Programs__c == false && c.Programs_Served__c == null) 
            {
                c.Serves_All_Programs__c = mapCourses.get(c.Course__c).Serves_All_Programs__c;
                c.Programs_Served__c = mapCourses.get(c.Course__c).Programs_Served__c;              
            }
            
            if (c.Enroll_Referral_Only_New__c == null) 
            {
                c.Enroll_Referral_Only_New__c = mapCourses.get(c.Course__c).Enroll_Referral_Only__c;        
            }           
        }           
    }
    
    public void editClass(List<Class__c> lstClasses) 
    {
        // TEST 1:  Only certain profiles can add Classes
        for(Class__c clEdit : lstClasses) 
        {
            // Test 1:  Profile Permissions
            if(csApexDefaults.Profiles_Authorized_to_Manage_Classes__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_2__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_3__c.contains(userInfo.getProfileId())) 
            {
            	//doNothing
            } else {
                clEdit.Name.addError('You are not authorized to edit a Class.  Please see your manager if you feel this message is being displayed in error.');
            }
        }
    }
    
    public void deleteClass(List<Class__c> lstClasses) 
    {
        // Get Class Ids to query for Enrollments
        List<Id> lstClassIds = new List<Id>();
        for(Class__c c : lstClasses) 
        {
            lstClassIds.add(c.Id);
        }
        
        // Get Schedules from Class
        List<Schedule__c> lstSchedules = [SELECT Id, (SELECT Id FROM relScheduleSessions__r) FROM Schedule__c WHERE Class__c IN :lstClasses];
        List<Id> lstSessionIds = new List<Id>();
        for(Schedule__c s : lstSchedules) 
        {
            for(Session__c se : s.relScheduleSessions__r) 
            {
                lstSessionIds.add(se.Id);
            }
        }
        
        // Get Events from Sessions
        List<Event> lstEvents = [SELECT WhoId, WhatId, Verification_Status__c FROM Event WHERE WhatId IN :lstSessionIds];
        List<Event> lstEventsDelete = new List<Event>();
        
        // Loop through classes
        for(Class__c clDel : lstClasses) 
        {
            // CASE 1:  Authorized Profiles only
            if(csApexDefaults.Profiles_Authorized_to_Manage_Classes__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_2__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_3__c.contains(userInfo.getProfileId())) 
            {
            	//doNothing
            } else {
                    clDel.Name.addError('You are not authorized to delete a Class.  Please see your manager if you feel this message is being displayed in error.');
            }
            
            // CASE 2:  Test for Clients verified for the Class
            for(Event e : lstEvents) 
            {
                // No additional scope limiting - per the requirements a Class can only have ONE schedule.  If that turns
                // out to not be the case, put additional scope limiting logic in here. 
                if(e.Verification_Status__c != 'Not Verified' && e.Verification_Status__c != 'Cancelled') {
                    clDel.Name.addError('You cannot delete this Class.  There are clients that have been verified for this Class.');
                } else {
                    lstEventsDelete.add(e);
                }
            }       
        }
        
        // Commit Lists to SFDC
        if(lstEventsDelete.size() > 0) { delete lstEventsDelete; }
        
    }

    //when a class is created and it does not have any values in Programs Served, pull the values from the Class's parent Course
    //Receives a list of classes
}