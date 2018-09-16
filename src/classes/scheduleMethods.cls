public class scheduleMethods {
    
    ///////////////////////////////////////////
    // This method manages Schedule Sessions on Schedule__c Triggers
    // Author:  AAB / DCS
    // Created:  20110324 
    ///////////////////////////////////////////
    
    public utilityIds utilIds = new utilityIds();
    public utilityMethods utilMethods = new utilityMethods();
    public Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();    
    public String strScheduleId {get;set;}
    public Schedule__c schCurrent {get;set;}
    public Schedule__c schExisting {get;set;}
    public Class__c clCurrent {get;set;}
    
    public String strTimeStartMonday {get;set;}
    public String strTimeEndMonday {get;set;}
    public String strStartMondayAMPM {get;set;}
    public String strEndMondayAMPM {get;set;}
    public String strTimeStartTuesday {get;set;}
    public String strTimeEndTuesday {get;set;}
    public String strStartTuesdayAMPM {get;set;}
    public String strEndTuesdayAMPM {get;set;}
    public String strTimeStartWednesday {get;set;}
    public String strTimeEndWednesday {get;set;}
    public String strStartWednesdayAMPM {get;set;}
    public String strEndWednesdayAMPM {get;set;}
    public String strTimeStartThursday {get;set;}
    public String strTimeEndThursday {get;set;}
    public String strStartThursdayAMPM {get;set;}
    public String strEndThursdayAMPM {get;set;}
    public String strTimeStartFriday {get;set;}
    public String strTimeEndFriday {get;set;}
    public String strStartFridayAMPM {get;set;}
    public String strEndFridayAMPM {get;set;}
    public String strTimeStartSaturday {get;set;}
    public String strTimeEndSaturday {get;set;}
    public String strStartSaturdayAMPM {get;set;}
    public String strEndSaturdayAMPM {get;set;}
    public String strTimeStartSunday {get;set;}
    public String strTimeEndSunday {get;set;}
    public String strStartSundayAMPM {get;set;}
    public String strEndSundayAMPM {get;set;}
    
    public List<SelectOption> soStartAMPM {get;set;}
    public List<SelectOption> soEndAMPM {get;set;}

    ///////////////////////////////////////////////////////////
    // Class Constuctors and GETers
    ///////////////////////////////////////////////////////////
    
    public scheduleMethods() { }
    
    public scheduleMethods(ApexPages.StandardController controller) {
    
        strScheduleId = ApexPages.currentPage().getParameters().get('id');
        
        schCurrent = [SELECT Id, UI_Start_Date__c, UI_End_Date__c, Change_Schedule_As_Of__c, End_Date__c, 
                        Class__c, Start_Date__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Saturday__c, Sunday__c, 
                        Monday_Start_Time__c, Monday_End_Time__c, Tuesday_Start_Time__c, Tuesday_End_Time__c, Wednesday_Start_Time__c, 
                        Wednesday_End_Time__c, Thursday_Start_Time__c, Thursday_End_Time__c, Friday_Start_Time__c, Friday_End_Time__c, 
                        Saturday_Start_Time__c, Saturday_End_Time__c, Sunday_Start_Time__c, Sunday_End_Time__c 
                        FROM Schedule__c WHERE Id = :strScheduleId LIMIT 1];
        
        // Duplicate this for save method
        schExisting = schCurrent;

        // Get Class Info
        clCurrent = [SELECT Id, Months_of_Sessions_to_Generate__c, AreaRPT__c, CategoryRPT__c, Class_Title__c, Suggested_Max_Size__c, 
        Instructor_1__r.Name, Instructor_1__c, RecordTypeId, Record_Type_RPT__c FROM Class__c WHERE Id = :schCurrent.Class__c];
        
        soStartAMPM = new List<SelectOption>();
        soStartAMPM.add(new SelectOption('AM', 'AM'));
        soStartAMPM.add(new SelectOption('PM', 'PM'));
        soEndAMPM = new List<SelectOption>();
        soEndAMPM.add(new SelectOption('AM', 'AM'));
        soEndAMPM.add(new SelectOption('PM', 'PM'));
        
        // Format Time Fields
        
        // Monday
        strTimeStartMonday = parseTime(schCurrent.Monday_Start_Time__c);
        strStartMondayAMPM = parseAMPM(schCurrent.Monday_Start_Time__c);
        strTimeEndMonday = parseTime(schCurrent.Monday_End_Time__c);
        strEndMondayAMPM = parseAMPM(schCurrent.Monday_End_Time__c);
        
        // Tuesday
        strTimeStartTuesday = parseTime(schCurrent.Tuesday_Start_Time__c);
        strStartTuesdayAMPM = parseAMPM(schCurrent.Tuesday_Start_Time__c);
        strTimeEndTuesday = parseTime(schCurrent.Tuesday_End_Time__c);
        strEndTuesdayAMPM = parseAMPM(schCurrent.Tuesday_End_Time__c);
        
        // Wednesday
        strTimeStartWednesday = parseTime(schCurrent.Wednesday_Start_Time__c);
        strStartWednesdayAMPM = parseAMPM(schCurrent.Wednesday_Start_Time__c);
        strTimeEndWednesday = parseTime(schCurrent.Wednesday_End_Time__c);
        strEndWednesdayAMPM = parseAMPM(schCurrent.Wednesday_End_Time__c);
        
        // Thursday
        strTimeStartThursday = parseTime(schCurrent.Thursday_Start_Time__c);
        strStartThursdayAMPM = parseAMPM(schCurrent.Thursday_Start_Time__c);
        strTimeEndThursday = parseTime(schCurrent.Thursday_End_Time__c);
        strEndThursdayAMPM = parseAMPM(schCurrent.Thursday_End_Time__c);
        
        // Friday
        strTimeStartFriday = parseTime(schCurrent.Friday_Start_Time__c);
        strStartFridayAMPM = parseAMPM(schCurrent.Friday_Start_Time__c);
        strTimeEndFriday = parseTime(schCurrent.Friday_End_Time__c);
        strEndFridayAMPM = parseAMPM(schCurrent.Friday_End_Time__c);
        
        // Saturday
        strTimeStartSaturday = parseTime(schCurrent.Saturday_Start_Time__c);
        strStartSaturdayAMPM = parseAMPM(schCurrent.Saturday_Start_Time__c);
        strTimeEndSaturday = parseTime(schCurrent.Saturday_End_Time__c);
        strEndSaturdayAMPM = parseAMPM(schCurrent.Saturday_End_Time__c);
        
        // Sunday
        strTimeStartSunday = parseTime(schCurrent.Sunday_Start_Time__c);
        strStartSundayAMPM = parseAMPM(schCurrent.Sunday_Start_Time__c);
        strTimeEndSunday = parseTime(schCurrent.Sunday_End_Time__c);
        strEndSundayAMPM = parseAMPM(schCurrent.Sunday_End_Time__c);
    }
    
    ///////////////////////////////////////////////////////////
    // Action Methods
    ///////////////////////////////////////////////////////////
    
    public String parseTime(Datetime dteSource) {
        
        if(dteSource == null) { return null; } 
        else {
        
            String strTime = '';
            Integer intHour = dteSource.hour();
            String strMinute = string.valueOf(dteSource.minute());
            
            if(intHour > 12) {intHour = intHour - 12;}
            if(strMinute.length() == 1) { strMinute = '0' + strMinute; }
            
            strTime = string.valueOf(intHour + ':' + strMinute);
            
            return strTime;
        }
        
    }
    
    public String parseAMPM(Datetime dteSource) {
        
        if(dteSource == null) { return 'AM'; } 
        else {
        
            String strAMPM = '';
        
            if(dteSource.hour() > 12) {
                strAMPM = 'PM';
            } else {
                strAMPM = 'AM';
            }
            
            return strAMPM;
        }
        
    }
    
    public PageReference returnToClass() {
        
        PageReference prCancel = new PageReference('/' + clCurrent.Id);
        prCancel.setRedirect(true);
        return prCancel;
        
    }
    
    public void convertClass() {  }
    
    public void trackOriginalDates(List<Schedule__c> lstSchedule) {
        
        for(Schedule__c s : lstSchedule) {
            
            if(s.Dummy_Schedule__c != true) {
            
                // Track Originally Entered Start / End Date
                if(s.Original_Start_Date__c == null) {
                    s.Original_Start_Date__c = s.Start_Date__c;
                }
                if(s.Original_End_Date__c == null) {
                    s.Original_End_Date__c = s.End_Date__c;
                }
            }
        }
    }
    
    public PageReference saveSchedule() {
        
        // Quick Data Verifications
        Boolean bolDataValidated = true;
        
        // Schedule Change Date is in the FUTURE!  (BACK TO THE FUTURE!!!)
        if(schCurrent.Change_Schedule_As_Of__c < System.Today()) {
            schCurrent.addError('You can only specifiy Schedule changes to be in the future - please review your selection and try again');
        }
        
        // Monday
        if(schCurrent.Monday__c == true && strTimeStartMonday.contains(':') == false) { bolDataValidated = false; }
        if(schCurrent.Monday__c == true && strTimeEndMonday.contains(':') == false) { bolDataValidated = false; }
        // Tuesday
        if(schCurrent.Tuesday__c == true && strTimeStartTuesday.contains(':') == false) { bolDataValidated = false; }
        if(schCurrent.Tuesday__c == true && strTimeEndTuesday.contains(':') == false) { bolDataValidated = false; }
        // Wednesday
        if(schCurrent.Wednesday__c == true && strTimeStartWednesday.contains(':') == false) { bolDataValidated = false; }
        if(schCurrent.Wednesday__c == true && strTimeEndWednesday.contains(':') == false) { bolDataValidated = false; }
        // Thursday
        if(schCurrent.Thursday__c == true && strTimeStartThursday.contains(':') == false) { bolDataValidated = false; }
        if(schCurrent.Thursday__c == true && strTimeEndThursday.contains(':') == false) { bolDataValidated = false; }
        // Friday
        if(schCurrent.Friday__c == true && strTimeStartFriday.contains(':') == false) { bolDataValidated = false; }
        if(schCurrent.Friday__c == true && strTimeEndFriday.contains(':') == false) { bolDataValidated = false; }
        // Saturday
        if(schCurrent.Saturday__c == true && strTimeStartSaturday.contains(':') == false) { bolDataValidated = false; }
        if(schCurrent.Saturday__c == true && strTimeEndSaturday.contains(':') == false) { bolDataValidated = false; }
        // Sunday
        if(schCurrent.Sunday__c == true && strTimeStartSunday.contains(':') == false) { bolDataValidated = false; }
        if(schCurrent.Sunday__c == true && strTimeEndSunday.contains(':') == false) { bolDataValidated = false; }
        
        // Compile and report errors
        if(bolDataValidated == false) {
            schCurrent.addError('A time value entered below is not formatted correctly.  Make sure the time is formatted as \'hh:mm\'');
        }
        
        
        ////////////////////////////////////
        // Compute Single Class Variables
        ////////////////////////////////////
        if(schCurrent.RecordTypeId == utilIds.scheduleSingle) {
                        
            // All fields are as-is - just update
            update schCurrent;
        }
        
        ////////////////////////////////////
        // Compute Fixed and Ongoing Class Variables
        ////////////////////////////////////
        if(schCurrent.RecordTypeId == utilIds.scheduleFixed || schCurrent.RecordTypeId == utilIds.scheduleOngoing) {
            
            //////////////////////////////////
            // Process Time
            //////////////////////////////////          
            
            // 3/12/13 MB moved from outside this IF. Otherwise null values throw an error when editing 
            // the schedule for single classes. 
            Time tmeRecurMondayStart = formatTime(strTimeStartMonday, strStartMondayAMPM);
            Time tmeRecurMondayEnd = formatTime(strTimeEndMonday, strEndMondayAMPM);
            Time tmeRecurTuesdayStart = formatTime(strTimeStartTuesday, strStartTuesdayAMPM);
            Time tmeRecurTuesdayEnd = formatTime(strTimeEndTuesday, strEndTuesdayAMPM);
            Time tmeRecurWednesdayStart = formatTime(strTimeStartWednesday, strStartWednesdayAMPM);
            Time tmeRecurWednesdayEnd = formatTime(strTimeEndWednesday, strEndWednesdayAMPM);
            Time tmeRecurThursdayStart = formatTime(strTimeStartThursday, strStartThursdayAMPM);
            Time tmeRecurThursdayEnd = formatTime(strTimeEndThursday, strEndThursdayAMPM);
            Time tmeRecurFridayStart = formatTime(strTimeStartFriday, strStartFridayAMPM);
            Time tmeRecurFridayEnd = formatTime(strTimeEndFriday, strEndFridayAMPM);
            Time tmeRecurSaturdayStart = formatTime(strTimeStartSaturday, strStartSaturdayAMPM);
            Time tmeRecurSaturdayEnd = formatTime(strTimeEndSaturday, strEndSaturdayAMPM);
            Time tmeRecurSundayStart = formatTime(strTimeStartSunday, strStartSundayAMPM);
            Time tmeRecurSundayEnd = formatTime(strTimeEndSunday, strEndSundayAMPM);            
            
            
            // Check for Changes in Schedule
            Boolean bolChangeMonday = false;
            Boolean bolChangeTuesday = false;
            Boolean bolChangeWednesday = false;
            Boolean bolChangeThursday = false;
            Boolean bolChangeFriday = false;
            Boolean bolChangeSaturday = false;
            Boolean bolChangeSunday = false;
            
            if(schExisting.Monday__c != schCurrent.Monday__c) { bolChangeMonday = true; }
            if(schExisting.Tuesday__c != schCurrent.Tuesday__c) { bolChangeTuesday = true; }
            if(schExisting.Wednesday__c != schCurrent.Wednesday__c) { bolChangeWednesday = true; }
            if(schExisting.Thursday__c != schCurrent.Thursday__c) { bolChangeThursday = true; }
            if(schExisting.Friday__c != schCurrent.Friday__c) { bolChangeFriday = true; }
            if(schExisting.Saturday__c != schCurrent.Saturday__c) { bolChangeSaturday = true; }
            if(schExisting.Sunday__c != schCurrent.Sunday__c) { bolChangeSunday = true; }
            
            // Set Common Fields
            schCurrent.Start_Date__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), schCurrent.UI_Start_Date__c.Month(), 
                schCurrent.UI_Start_Date__c.Day(), 0, 0, 0);
            
            if(schCurrent.RecordTypeId == utilIds.scheduleFixed) {
                schCurrent.End_Date__c = DateTime.newInstance(schCurrent.UI_End_Date__c.Year(), schCurrent.UI_End_Date__c.Month(), 
                schCurrent.UI_End_Date__c.Day(), 0, 0, 0);
            }
            
            if(schCurrent.RecordTypeId == utilIds.scheduleOngoing) {
                // 2/4/14 MB this logic in incorrect. The end date should be set in the future if the class
                // is ongoing. The logic here only applies when the schedule is created
                schCurrent.End_Date__c = schCurrent.Change_Schedule_As_Of__c.addMonths(Integer.valueOf(clCurrent.Months_of_Sessions_to_Generate__c));               
                //schCurrent.End_Date__c = schCurrent.Start_Date__c.addMonths(Integer.valueOf(clCurrent.Months_of_Sessions_to_Generate__c));
                System.Debug('****scheduleMethods.saveSchedule INFO:  Setting End Date of Ongoing Schedule to ' + schCurrent.End_Date__c);
            }
            
            if(schCurrent.Monday__c) {
                System.Debug('Saving Monday__c');
                schCurrent.Monday_Start_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurMondayStart.Hour(), 
                tmeRecurMondayStart.Minute(), 0);
                
                schCurrent.Monday_End_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurMondayEnd.Hour(), 
                tmeRecurMondayEnd.Minute(), 0);
            } else {
                schCurrent.Monday_Start_Time__c = null;
                schCurrent.Monday_End_Time__c = null;
            }
            if(schCurrent.Tuesday__c) {
                System.Debug('Saving Tuesday__c');
                schCurrent.Tuesday_Start_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurTuesdayStart.Hour(), 
                tmeRecurTuesdayStart.Minute(), 0);
                
                schCurrent.Tuesday_End_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurTuesdayEnd.Hour(), 
                tmeRecurTuesdayEnd.Minute(), 0);
            } else {
                schCurrent.Tuesday_Start_Time__c = null;
                schCurrent.Tuesday_End_Time__c = null;
            }
            if(schCurrent.Wednesday__c) {
                System.Debug('Saving Wednesday__c');
                schCurrent.Wednesday_Start_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurWednesdayStart.Hour(), 
                tmeRecurWednesdayStart.Minute(), 0);
                
                schCurrent.Wednesday_End_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurWednesdayEnd.Hour(), 
                tmeRecurWednesdayEnd.Minute(), 0);         
            } else {
                schCurrent.Wednesday_Start_Time__c = null;
                schCurrent.Wednesday_End_Time__c = null;
            }
            if(schCurrent.Thursday__c) {
                System.Debug('Saving Thursday__c');
                schCurrent.Thursday_Start_Time__c =DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurThursdayStart.Hour(), 
                tmeRecurThursdayStart.Minute(), 0);
                
                schCurrent.Thursday_End_Time__c =DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurThursdayEnd.Hour(), 
                tmeRecurThursdayEnd.Minute(), 0);         
            } else {
                schCurrent.Thursday_Start_Time__c = null;
                schCurrent.Thursday_End_Time__c = null;
            }
            if(schCurrent.Friday__c) {
                System.Debug('Saving Friday__c');
                schCurrent.Friday_Start_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurFridayStart.Hour(), 
                tmeRecurFridayStart.Minute(), 0);
                
                schCurrent.Friday_End_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurFridayEnd.Hour(), 
                tmeRecurFridayEnd.Minute(), 0);
            } else {
                schCurrent.Friday_Start_Time__c = null;
                schCurrent.Friday_End_Time__c = null;
            }
            if(schCurrent.Saturday__c) {
                System.Debug('Saving Saturday__c');
                schCurrent.Saturday_Start_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurSaturdayStart.Hour(), 
                tmeRecurSaturdayStart.Minute(), 0);
                
                schCurrent.Saturday_End_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurSaturdayEnd.Hour(), 
                tmeRecurSaturdayEnd.Minute(), 0);            
            } else {
                schCurrent.Saturday_Start_Time__c = null;
                schCurrent.Saturday_End_Time__c = null;
            }
            if(schCurrent.Sunday__c) {
                System.Debug('Saving Sunday__c');
                schCurrent.Sunday_Start_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurSundayStart.Hour(), 
                tmeRecurSundayStart.Minute(), 0);
                
                schCurrent.Sunday_End_Time__c = DateTime.newInstance(schCurrent.UI_Start_Date__c.Year(), 
                schCurrent.UI_Start_Date__c.Month(), schCurrent.UI_Start_Date__c.Day(), tmeRecurSundayEnd.Hour(), 
                tmeRecurSundayEnd.Minute(), 0);
            } else {
                schCurrent.Sunday_Start_Time__c = null;
                schCurrent.Sunday_End_Time__c = null;
            }
            
            update schCurrent;
        }
        
        ////////////////////////////////////
        // Insert New Schedules and return to Course Catalog
        ////////////////////////////////////
        
        PageReference pfSuccess = new PageReference('/apex/scheduleEdit?id=' + schCurrent.Id);
        pfSuccess.setRedirect(true);
        return pfSuccess;

    }
    
    
    //////////////////////////////////////////////////
    // Trigger-based Methods
    //////////////////////////////////////////////////
    public void autoExtendOngoingSchedule(List<Schedule__c> lstSchedule) {
        
        for(Schedule__c s : lstSchedule) {
            if(s.AutoExtendFlag__c == true) {
                s.End_Date__c = s.End_Date__c.AddDays(8);
                s.AutoExtendFlag__c = false;
            }
        }
        
    }
    
    public void deleteSchedule(List<Schedule__c> lstSchedule) {
        
        // Check to see if any clients / events have been VERIFIED for any sessions under this Schedule
        List<Event> lstEventsToDelete = new List<Event>();
        List<Class__c> lstClassesToUpdate = new List<Class__c>();
        
        List<Id> lstScheduleIds = new List<Id>();
        for(Schedule__c s : lstSchedule) { lstScheduleIds.add(s.Id); }
        
        List<Session__c> lstSessions = [SELECT Id, Schedule__c FROM Session__c WHERE Schedule__c IN :lstScheduleIds];
        List<Id> lstSessionIds = new List<Id>();
        for(Session__c s : lstSessions) { lstSessionIds.add(s.Id); }
            
        List<Event> lstEvents = [SELECT WhatId, Verification_Status__c FROM Event WHERE WhatId IN :lstSessionIds];
        
        for(Schedule__c sch : lstSchedule) {
            for(Session__c ses : lstSessions) {
                if(ses.Schedule__c == sch.Id) {
                    for(Event evt : lstEvents) {
                        if(evt.WhatId == ses.Id) {
                            if(evt.Verification_Status__c != 'Not Verified' || evt.Verification_Status__c != 'Cancelled') {
                                sch.addError('This Schedule / Class cannot be deleted because there are appointments that have been verified!');
                            } else {
                                evt.SkipRestrictions__c = true;
                                lstEventsToDelete.add(evt);
                            }
                        }
                    }
                }
            }
            
            Class__c c = new Class__c(Id=sch.Class__c);
            c.No_of_Sessions_Scheduled__c = 0;
            lstClassesToUpdate.add(c);
        }
        
        // Delete all associated Events
        delete lstEventsToDelete;
        upsert lstClassesToUpdate;
        
    }
    
    public void createSchedule(List<Schedule__c> lstSchedule) {
        
        for(Schedule__c schNew : lstSchedule) {
            
            // Test 1:  Authorized Profiles Only
            if(csApexDefaults.Profiles_Authorized_to_Manage_Classes__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_2__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_3__c.contains(userInfo.getProfileId())) {
            } else {
                    schNew.addError('You are not authorized to create a Schedule.  Please see your manager if you feel this message is being displayed in error.');
            }
        }
        
    }
    
    public void modifySchedule(List<Schedule__c> lstSchedule) {
        
        // Test for Access First
        for(Schedule__c schEdit : lstSchedule) {
            
            // Test 1:  Authorized Profiles Only
            if(csApexDefaults.Profiles_Authorized_to_Manage_Classes__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_2__c.contains(userInfo.getProfileId())
            || csApexDefaults.Profiles_Authorized_to_Manage_Classes_3__c.contains(userInfo.getProfileId())) {
            } else {
                    schEdit.addError('You are not authorized to edit a Schedule.  Please see your manager if you feel this message is being displayed in error.');
            }
            
            // Test 2:  Class / Schedule has already started
            if(schEdit.dummy_schedule__c != true && schEdit.Start_Date__c >= System.Today() 
                && userInfo.getProfileId() != utilIds.systemAdmin && schEdit.Change_Schedule_As_Of__c == null) {
                schEdit.addError('This schedule has already started and cannot be edited.  Please see the system administrator if you feel this message is being displayed in error.');
            }
        }
        
        // Get Ids of all scoped Schedules
        List<Id> lstScheduleIds = new List<Id>();
        for(Schedule__c s : lstSchedule) { lstScheduleIds.add(s.Id); }
        
        // Get Sessions for all scoped Schedules
        List<Session__c> lstSessions = [SELECT Id, Session_Start__c, Schedule__c FROM Session__c WHERE Schedule__c IN :lstScheduleIds];
        List<Session__c> lstSessionsToDelete = new List<Session__c>();
        
        // Delete Sessions after "Change Schedule As Of" Date
        for(Schedule__c s : lstSchedule) {
            
            if(s.Dummy_Schedule__c != true) {
                // Spin through Sessions - look for ones to delete
                for(Session__c se : lstSessions) {
                    if(se.Schedule__c == s.Id && s.Change_Schedule_As_Of__c != null) {
                        if(se.Session_Start__c > s.Change_Schedule_As_Of__c) {
                            lstSessionsToDelete.add(se);
                        }
                    }
                    
                }
            }
        }
        
        if(lstSessionsToDelete.size() > 0) { delete lstSessionsToDelete; }
        
    }
    
    public void createScheduleSessions(List<Schedule__c> lstSchedule) {
        
        Set<Id> lstScheduleIds = new Set<Id>();
        Set<Id> lstClassIds = new Set<Id>();
        List<Date> lstScheduleDates = new List<Date>();
        List<Integer> lstSessionDays = new List<Integer>();
        List<Session__c> lstSessionsNew = new List<Session__c>();
        List<Session__c> lstSessionsUpdateLoop = new List<Session__c>();
        List<Class__c> lstClassesUpdate = new List<Class__c>();
        List<Session__c> lstSessionsExistingDelete = new List<Session__c>();
        Date dteScheduleEffective = System.Today();
        Date dteUpdTemp;
        Date dteSessionExtrapolate;
        Date dteFirstSessionDateRPT;
        Date dteLastSessionDateRPT;
        DateTime dtmFirstSessionDate;
        DateTime dtmLastSessionDate;
        DateTime dtmStartSearchTemp;
        Integer intDayOfWeekSched;
        Integer intDayOfWeekActual;
        Integer intDaysForward;
        Integer intTemp;
        Integer intSessionCount;
        Time tmeStart;
        Time tmeEnd;
        Boolean bolDayFlag = false;

        Map<Date, Id> mapHolidays = new Map<Date, ID>(utilMethods.validateHolidayDate());
                
        // Gather In-Scope Contact Records 
        for(Schedule__c s : lstSchedule) {
            lstScheduleIds.add(s.Id);
            lstClassIds.add(s.Class__c);
        }
        
        System.Debug('\n\n scheduleMethods.createScheduleSessions INFO:  Parsing New Sessions for ClassIds: ' + lstClassIds + '\n\n');
        System.Debug('\n\n scheduleMethods.createScheduleSessions INFO:  Parsing New Sessions for ScheduleIds: ' + lstScheduleIds + '\n\n');
        
        // Gather all Sessions for this Class
        //List<Session__c> lstSessionsExisting = [SELECT Id, Schedule__c, Session_Start__c, Session_End__c FROM Session__c WHERE Schedule__c IN :lstSchedule];
        
        // Gather all Class information for this Schedule
        List<Class__c> lstClasses = [SELECT Id, Room__c, Instructor_1__c, First_Session_On__c, 
            Last_Session_On__c, No_of_Sessions_Scheduled__c FROM Class__c WHERE Id IN :lstClassIds];
        
        // Begin Loop
        for(Schedule__c s : lstSchedule) {
            
            //added 10/31/13 by MB do not process schedules that are listed as dummy, they are just empty containers
            // for sessions added manually or by nightly run (for DTC)
            if(s.Dummy_Schedule__c != true) {
            
                // CASE 1:  Authorized Profiles ONLY
                if(csApexDefaults.Profiles_Authorized_to_Manage_Classes__c.contains(userInfo.getProfileId())
                || csApexDefaults.Profiles_Authorized_to_Manage_Classes_2__c.contains(userInfo.getProfileId())
                || csApexDefaults.Profiles_Authorized_to_Manage_Classes_3__c.contains(userInfo.getProfileId())) {
                        // Empty IF
                } else {
                    s.UI_Start_Date__c.addError(' You are not authorized to create a Schedule.  Please see your manager if you feel this message is being displayed in error.');
                }
                
                // Set Reporting
                intSessionCount = 0;
                
                ///////////////////////////////////////
                // Grab Class Information for Session Fields
                ///////////////////////////////////////
                Class__c classParent;
                for(Class__c c : lstClasses) {
                    if(c.Id == s.Class__c) {
                        classParent = c;
                        break;
                    }
                }
                
                ///////////////////////////////////////
                // Determine Actual Schedule Session Dates
                ///////////////////////////////////////
                
                // Ongoing or Fixed Schedules
                if(s.RecordTypeId == utilIds.scheduleOngoing || s.RecordTypeId == utilIds.scheduleFixed) {
                
                    // Get Selected Weekdays that this schedule covers
                    if(s.Sunday__c) { lstSessionDays.add(0); }
                    if(s.Monday__c) { lstSessionDays.add(1); }
                    if(s.Tuesday__c) { lstSessionDays.add(2); }
                    if(s.Wednesday__c) { lstSessionDays.add(3); }
                    if(s.Thursday__c) { lstSessionDays.add(4); }
                    if(s.Friday__c) {lstSessionDays.add(5); }
                    if(s.Saturday__c) { lstSessionDays.add(6); }
                    
                    // Get Weekday for Scheduled Start
                    intDayOfWeekSched = utilityMethods.getDayOfWeek(s.Start_Date__c.Date());
                    
                    // Does the s.Start_Date__c fall on a weekday selected within the Schedule object (day checkboxes)?
                    for(Integer i : lstSessionDays) {                   
                        if(intDayOfWeekSched == i) {
                            dtmFirstSessionDate = s.Start_Date__c;
                            system.debug('DEBUG STOP 1');
                            bolDayFlag = true;
                            break;
                        }
                    }
                    
                    if(bolDayFlag == false) {
                        System.Debug('The s.Start_Date__c does NOT fall on a selected weekday, find the first REAL Session date');
                        intDaysForward = 0;
                        do {
                            
                            dtmStartSearchTemp = s.Start_Date__c.AddDays(intDaysForward);
                            intTemp = utilityMethods.getDayOfWeek(dtmStartSearchTemp.Date()); 
                            
                            for(Integer i : lstSessionDays) {
                                if(intTemp == i) {
                                    dtmFirstSessionDate = dtmStartSearchTemp;
                                    system.debug('DEBUG STOP 2');
                                    bolDayFlag = true;
                                    break;
                                }
                            }
                            
                            intDaysForward++;
                            
                        } while (bolDayFlag == false || intDaysForward == 8);
                        
                    }
                } else {
                    // Single Class Schedule
                    bolDayFlag = true;
                    dtmFirstSessionDate = s.Start_Date__c;
                }
                
                ////////////////////////////////////
                // Report back error or begin extrapolating dates
                ////////////////////////////////////
                for(Integer i : lstSessionDays) {
                    System.Debug('AAB TEST - ' + i);
                }
                
                System.Debug('scheduleMethods.createScheduleSessions INFO:  Schedule Test First Session Date = ' + dtmFirstSessionDate);
                System.Debug('scheduleMethods.createScheduleSessions INFO:  Schedule Test Day Flag = ' + bolDayFlag);
                 
                if(dtmFirstSessionDate == null || bolDayFlag == false) {
                    s.AddError('ERROR:  scheduleMethods.createScheduleSessions - A valid Session Start Date could not be computed'
                    + ' - possible causes are that a weekday was not selected or a Start Date was not specified.'
                    + ' Please check your data and try again');
                } else {
                    // Correct Start Date found / identified - extrapolate all Session dates for this Schedule
                    
                    // Determine Schedule Change Date
                    if(s.Change_Schedule_As_Of__c == null) {
                        dteScheduleEffective = dtmFirstSessionDate.Date();
                        System.Debug('scheduleMethods.createScheduleSessions INFO:'
                        + '  This appears to be a new schedule, effective date = SCHEDULE START - ' + dteScheduleEffective);
                    } else {
                        dteScheduleEffective = s.Change_Schedule_As_Of__c;                  
                        System.Debug('scheduleMethods.createScheduleSessions INFO:'
                        + '  This appears to be a modified schedule, effective date = ' + dteScheduleEffective);
                    }
                    
                    for(Integer i : lstSessionDays) {
                        Integer intCalcTemp = utilityMethods.getDayOfWeek(dtmFirstSessionDate.Date());
                        
                        // Determine first date in series by Weekday selected
                        if(i < intCalcTemp) { dteSessionExtrapolate = dtmFirstSessionDate.Date().AddDays(-(intCalcTemp - i)); }
                        if(i == intCalcTemp) { dteSessionExtrapolate = dtmFirstSessionDate.Date(); }
                        if(i > intCalcTemp) { dteSessionExtrapolate = dtmFirstSessionDate.Date().AddDays(i - intCalcTemp); }
                        
                        ////////////////////////////////////
                        // Extrapolate recurring dates through s.End_Date__c (Fixed) or Months_Of_Sessions_To_Generate__c (Ongoing)
                        ////////////////////////////////////
                        
                        // Add Dates to List                    
                        if(dteSessionExtrapolate >= dteScheduleEffective && dteSessionExtrapolate <= s.End_Date__c.date()) { 
                            System.Debug('scheduleMethods.createScheduleSessions INFO:  Adding first date = ' 
                            + dteSessionExtrapolate + ' SUCCESS');                        
                            lstScheduleDates.add(dteSessionExtrapolate); 
                        } else {
                            System.Debug('scheduleMethods.createScheduleSessions INFO:  Adding first date = ' 
                            + dteSessionExtrapolate + ' FAIL');
                        }
                        
                        // Ongoing Schedule - limit to value in Months Of Sessions to Generate
                        if(s.RecordTypeId == utilIds.scheduleOngoing) {
                            
                            do {
                                // Add 7 days to the extrapolated date, add to lstSessionDates for processing further in the method
                                dteSessionExtrapolate = dteSessionExtrapolate.AddDays(7);
                                if(dteSessionExtrapolate >= dteScheduleEffective) { 
                                    System.Debug('scheduleMethods.createScheduleSessions INFO:  Adding ' 
                                    + dteSessionExtrapolate + ' to the session list');
                                    lstScheduleDates.add(dteSessionExtrapolate); 
                                } else {
                                    System.Debug('scheduleMethods.createScheduleSessions INFO:  ' 
                                    + dteSessionExtrapolate + ' is OUTSIDE of bounds - loop terminated');
                                }           
                                
                            } while ( dteSessionExtrapolate <= dteScheduleEffective.AddMonths(Integer.ValueOf(s.Months_of_Sessions_to_Generate__c)) );
                            
                        }
                        
                        // Fixed Schedule - limit to value in End_Date__c
                        if(s.RecordTypeId == utilIds.scheduleFixed) {
                            
                            do {
                                // Add 7 days to the extrapolated date, add to lstSessionDates for processing further in the method
                                dteSessionExtrapolate = dteSessionExtrapolate.AddDays(7);
                                if(dteSessionExtrapolate >= s.Start_Date__c && dteSessionExtrapolate <= s.End_Date__c) { lstScheduleDates.add(dteSessionExtrapolate); }                     
                                
                            } while ( dteSessionExtrapolate <= s.End_Date__c );
                            
                        }
                    }
                    
                    for(Date d : lstScheduleDates) {
                        System.Debug('YOYOYO - ' + d);
                    }
                    
                    ///////////////////////////////////////
                    // Begin Processing Business Cases
                    ///////////////////////////////////////
                    
                    // CASE 1:  Single Schedule
                    if(s.RecordTypeId == utilIds.scheduleSingle) {
                        
                        // Only one Session can be created for a Single Schedule
                        Session__c sessionSingle = new Session__c();
                        sessionSingle.Schedule__c = s.Id;
                        sessionSingle.Session_Start__c = s.Start_Date__c;
                        sessionSingle.Session_End__c = s.End_Date__c;
                        sessionSingle.Assigned_To__c = classParent.Instructor_1__c;
                        
                        intSessionCount = intSessionCount + 1;
                        
                        lstSessionsNew.add(sessionSingle);
                        
                        // Reporting
                        dteLastSessionDateRPT = s.End_Date__c.Date();
                        
                    }
                    
                    // CASE 2 & 3:  Fixed or Ongoing Schedule
                    if(s.RecordTypeId == utilIds.scheduleFixed || s.RecordTypeId == utilIds.scheduleOngoing) {
                                    
                        // Loop through lstScheduleDates
                        for(Date d : lstScheduleDates) {
                            
                            System.Debug('scheduleMethods.createScheduleSessions INFO:  Processing ' + d);
                            
                            tmeStart = null;
                            tmeEnd = null;
                            
                            // Get the Session Start / End Time
                            Integer intTimeTest = utilityMethods.getDayOfWeek(Date.newInstance(d.Year(), d.Month(), d.Day()));
                            if(intTimeTest == 0 && s.Sunday_Start_Time__c != null) {
                                tmeStart = s.Sunday_Start_Time__c.Time();
                                tmeEnd = s.Sunday_End_Time__c.Time();
                            }
                            if(intTimeTest == 1 && s.Monday_Start_Time__c != null) {
                                tmeStart = s.Monday_Start_Time__c.Time();
                                tmeEnd = s.Monday_End_Time__c.Time();
                            }
                            if(intTimeTest == 2 && s.Tuesday_Start_Time__c != null) {
                                tmeStart = s.Tuesday_Start_Time__c.Time();
                                tmeEnd = s.Tuesday_End_Time__c.Time();
                            }
                            if(intTimeTest == 3 && s.Wednesday_Start_Time__c != null) {
                                tmeStart = s.Wednesday_Start_Time__c.Time();
                                tmeEnd = s.Wednesday_End_Time__c.Time();
                            }
                            if(intTimeTest == 4 && s.Thursday_Start_Time__c != null) {
                                tmeStart = s.Thursday_Start_Time__c.Time();
                                tmeEnd = s.Thursday_End_Time__c.Time();
                            }
                            if(intTimeTest == 5 && s.Friday_Start_Time__c != null) {
                                tmeStart = s.Friday_Start_Time__c.Time();
                                tmeEnd = s.Friday_End_Time__c.Time();
                            }
                            if(intTimeTest == 6 && s.Saturday_Start_Time__c != null) {
                                tmeStart = s.Saturday_Start_Time__c.Time();
                                tmeEnd = s.Saturday_End_Time__c.Time();
                            }
                            
                            // Time Catch
                            if(tmeStart == null) { tmeStart = s.Start_Date__c.Time(); }
                            if(tmeEnd == null) { tmeEnd = s.End_Date__c.Time(); }
                            
                            // Build the Class Start / End DateTime values
                            DateTime dtStart = datetime.NewInstance(d.Year(), d.Month(), d.Day(), tmeStart.Hour(), tmeStart.Minute(), tmeStart.Second());
                            DateTime dtEnd = datetime.NewInstance(d.Year(), d.Month(), d.Day(), tmeEnd.Hour(), tmeEnd.Minute(), tmeEnd.Second());
                            
                            // Stop Ongoing Class creation at the limiters
                            Boolean bolCreateSession = true;
                            if(s.RecordTypeId == utilIds.scheduleOngoing) {
                                if(s.Change_Schedule_As_Of__c == null && d > s.Start_Date__c.Date().AddMonths(Integer.ValueOf(s.Months_of_Sessions_to_Generate__c))) {
                                    System.Debug('*** scheduleMethods.createScheduleSessions INFO:  Not creating Session for ' 
                                    + d + ' because it is greater than ' 
                                    + s.Start_Date__c.Date().AddMonths(Integer.ValueOf(s.Months_of_Sessions_to_Generate__c)));
                                    bolCreateSession = false;
                                }
                                
                                if(s.Change_Schedule_As_Of__c != null && d > s.End_Date__c) {
                                    System.Debug('*** scheduleMethods.createScheduleSessions INFO:  Not creating Session for ' 
                                    + d + ' because it is greater than ' + s.End_Date__c.Date());
                                    bolCreateSession = false;
                                }                       
                            }
                            
                            // Only Create if after the Schedule Effective Date (see above)
                            if(dtStart.date() >= dteScheduleEffective) {
                                
                                System.Debug('scheduleMethods.createScheduleSessions INFO:  Validating that = ' + d + ' is valid for Session Creation');
                                
                                if(!mapHolidays.containsKey(d) && bolCreateSession == true) {
                                    
                                    System.Debug('scheduleMethods.createScheduleSessions INFO: ' + d + ' is valid - creating Session');
                                    
                                    Session__c sessionRecurring = new Session__c();
                                    sessionRecurring.Schedule__c = s.Id;
                                    sessionRecurring.Session_Start__c = dtStart;
                                    sessionRecurring.Session_End__c = dtEnd;
                                    sessionRecurring.Assigned_To__c = classParent.Instructor_1__c;
                                    
                                    intSessionCount = intSessionCount + 1;
                                    
                                    lstSessionsNew.add(sessionRecurring);
                                    
                                    // Reporting
                                    System.Debug('scheduleMethods.createScheduleSessions INFO:  Compute Last Session On = ' + d);
                                    if(d > dteLastSessionDateRPT || dteLastSessionDateRPT == null) {
                                        dteLastSessionDateRPT = d;
                                    }
                                }
                            } else {
                                System.Debug('scheduleMethods.createScheduleSessions INFO:  Computed Date is BEFORE the effective date of this schedule.');
                            }
                        }
                    }
                    
                    /////////////////////////////////////////
                    // Reporting - Update Parent Class with Start / End Dates
                    /////////////////////////////////////////
                    System.Debug('scheduleMethods.createScheduleSessions INFO:  First Session On = ' + dtmFirstSessionDate.DateGMT());
                    System.Debug('scheduleMethods.createScheduleSessions INFO:  Last Session On = ' + dteLastSessionDateRPT);
                    
                    classParent.First_Session_On__c = dtmFirstSessionDate.DateGMT();
                    
                    if(s.RecordTypeId != utilIds.scheduleOngoing) {
                        classParent.Last_Session_On__c = dteLastSessionDateRPT;
                    }
                    
                    List<Session__c> lstExistingSessionsForCount = [SELECT Id FROM Session__c 
                                                                    WHERE Schedule__c = :s.Id];
                    Integer intSessionFullCount = 0;
                    intSessionFullCount = lstExistingSessionsForCount.size() + intSessionCount;
                    classParent.No_of_Sessions_Scheduled__c = intSessionFullCount;

                    //added 12/3/13 set Abbreviated Schedule on class for display purposes
                    if(s.RecordTypeId == utilIds.scheduleFixed 
                    || s.RecordTypeId == utilIds.scheduleOngoing) {
                        
                        classParent.Abbreviated_Schedule__c = ' /';
                        classParent.Abbreviated_Schedule__c += s.Monday__c?'M':'';
                        classParent.Abbreviated_Schedule__c += s.Tuesday__c?'T':'';
                        classParent.Abbreviated_Schedule__c += s.Wednesday__c?'W':'';
                        classParent.Abbreviated_Schedule__c += s.Thursday__c?'Th':'';
                        classParent.Abbreviated_Schedule__c += s.Friday__c?'F':'';
                        classParent.Abbreviated_Schedule__c += s.Saturday__c?'Sat':'';
                        classParent.Abbreviated_Schedule__c += s.Sunday__c?'Sun':'';
                    }
                    
                    lstClassesUpdate.add(classParent);
                }
            }
        }
        
        ///////////////////////////////////
        // Process Lists
        ///////////////////////////////////
        if(lstSessionsNew.size() > 0) { insert lstSessionsNew; }
        if(lstClassesUpdate.size() > 0) { update lstClassesUpdate; }
        
    }

    // Function Classes

    public Time formatTime(String strSource, String strAMPM) {
        
        // Variables
        Time tmeResult;
        Integer intPos1;
        Integer intPos2;
        
        // Initial Variable Check
        if(strSource == '' || strAMPM == null) {
            return null;
        }
        
        // Split into array (HH:MM)
        List<String> arrParseTime = String.valueOf(strSource).split(':');   
        
        // Check for null array
        if(arrParseTime.size() == 0) {
            return null;
        } else {
            // Pull first position as HH
            intPos1 = Integer.valueOf(arrParseTime[0]);
            
            // Pull second position as MM (default to 0)
            if(arrParseTime.size() < 2) {
                intPos2 = 0;
            } else {
                intPos2 = Integer.valueOf(arrParseTime[1]);
            }
                
        }
        
        // Account for 12 Hour AM/PM Format
        if(strAMPM == 'PM') {
            if(Integer.valueOf(arrParseTime[0]) < 12) {
                intPos1 = intPos1 + 12;
            }           
        } else {
            if(Integer.valueOf(arrParseTime[0]) == 12) {
                intPos1 = 0;
            }
        }
        
        // Account for weird off hours - return
        if(intPos1 > 23) {
            return null;
        }
        
        // Account for weird off minutes - just set to :59
        if(intPos2 > 59) {
            intPos2 = 59;
        }
        
        tmeResult = Time.newInstance(intPos1, intPos2, 0, 0);
        
        ////////////////////////////
        // Return Value
        ////////////////////////////
        return tmeResult;
        
    }

    
}