public with sharing class scheduleNewInstance {

///////////////////////////////////////////
// This method manages New Schedule instances - invoked from the 
// "New Schedule" button from the Class Page Layout
// Author:  AAB / DCS
// Created:  20110324 
///////////////////////////////////////////
    public utilityIds utilIds = new utilityIds();
    
    public Schedule__c schNew {get;set;}
    public Class__c clsParent {get;set;}
    public String idClass {get;set;}
    public String strClassName {get;set;}
    public String strClassType {get;set;}
    
    public String strTimeStart {get;set;}
    public String strTimeEnd {get;set;}
    public String strStartAMPM {get;set;}
    public String strEndAMPM {get;set;}
    public List<SelectOption> soStartAMPM {get;set;}
    public List<SelectOption> soEndAMPM {get;set;}
    public DateTime dteStart {get;set;}
    public DateTime dteEnd {get;set;}
    
    public List<Schedule__c> lstNewSchedule {get;set;}
    public Boolean bolValid {get;set;}
    
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

/////////////////////////////////////////
// Class Constructor & Helper Classes
/////////////////////////////////////////
    public scheduleNewInstance(ApexPages.StandardController controller) {}
    
    public scheduleNewInstance() {
        
        // Get parent Class__c info
        idClass = ApexPages.currentPage().getParameters().get('id');
        
        //////////////////////////////////////////
        // Test for Active Schedule
        //////////////////////////////////////////
        List<Schedule__c> lstExistingSchedules = [SELECT Id FROM Schedule__c WHERE Class__c = :idClass];
        if(lstExistingSchedules.size() > 0) {
            bolValid = false;
        } else {
            bolValid = true;
        }
        
        //////////////////////////////////////////
        // Get Class Information
        //////////////////////////////////////////
        clsParent = [SELECT Id, Name, RecordTypeId, RecordType.Name, Months_of_Sessions_to_Generate__c FROM Class__c WHERE Id = :idClass];
        
        //////////////////////////////////////////
        // Set Display Variables
        //////////////////////////////////////////
        strClassName = clsParent.Name;
        strClassType = clsParent.RecordType.Name;
        soStartAMPM = new List<SelectOption>();
        soStartAMPM.add(new SelectOption('AM', 'AM'));
        soStartAMPM.add(new SelectOption('PM', 'PM'));
        soEndAMPM = new List<SelectOption>();
        soEndAMPM.add(new SelectOption('AM', 'AM'));
        soEndAMPM.add(new SelectOption('PM', 'PM'));
        lstNewSchedule = new List<Schedule__c>();
        schNew = new Schedule__c();
        
        //////////////////////////////////////////
        // Set new Schedule__c fields
        //////////////////////////////////////////
        if(clsParent.RecordTypeId == utilIds.classSingle) {
            schNew.RecordTypeId = utilIds.scheduleSingle;
        }
        if(clsParent.RecordTypeId == utilIds.classFixed) {
            schNew.RecordTypeId = utilIds.scheduleFixed;
        }
        if(clsParent.RecordTypeId == utilIds.classOngoing) {
            schNew.RecordTypeId = utilIds.scheduleOngoing;
        }
        
        // Set Initial Schedule Object Fields
        schNew.Class__c = clsParent.Id;
        schNew.Start_Date__c = System.Now();
        schNew.UI_Start_Date__c = System.Today();

    }
    
/////////////////////////////////////////
// Action Classes
/////////////////////////////////////////
    public PageReference createNewSchedule() {
        
        //////////////////////////////////
        // Field Verification
        //////////////////////////////////
        if((schNew.UI_Start_Date__c == null || strTimeStart == null || strTimeEnd == null) && clsParent.RecordTypeId == utilIds.classSingle) {
            schNew.UI_Start_Date__c.addError('You must enter a valid date and times!');
            return null;
        }
        
        //////////////////////////////////
        // Process Time
        //////////////////////////////////      
        Time tmeSingleStart = formatTime(strTimeStart, strStartAMPM);
        Time tmeSingleEnd = formatTime(strTimeEnd, strEndAMPM);
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
        
        
        ////////////////////////////////////
        // Date and Time Validation
        ////////////////////////////////////
        if(clsParent.RecordTypeId == utilIds.classSingle) {
            if(tmeSingleStart > tmeSingleEnd) {
                schNew.UI_Start_Date__c.addError('The End Time cannot come before the Start Time!');
                return null;
            }
        }
        
        if(clsParent.RecordTypeId == utilIds.classFixed || clsParent.RecordTypeId == utilIds.classOngoing) {
            if(!schNew.Monday__c && !schNew.Tuesday__c 
                    && !schNew.Wednesday__c && !schNew.Thursday__c
                    && !schNew.Friday__c && !schNew.Saturday__c
                    && !schNew.Sunday__c) {
                schNew.Monday__c.addError('You must select at least one day to create a schedule!');
                return null;
            }
            
            if(schNew.Monday__c) { 
                if(tmeRecurMondayStart > tmeRecurMondayEnd) {
                    schNew.Monday__c.addError('The End Time cannot come before the Start Time!');
                    return null;
                }
                if(tmeRecurMondayStart == null || tmeRecurMondayEnd == null) {
                    schNew.Monday__c.addError('You must enter a valid Start and End Time!');
                    return null;
                }
            }
            if(schNew.Tuesday__c) { 
                if(tmeRecurTuesdayStart > tmeRecurTuesdayEnd) {
                    schNew.Tuesday__c.addError('The End Time cannot come before the Start Time!');
                    return null;
                }
                if(tmeRecurTuesdayStart == null || tmeRecurTuesdayEnd == null) {
                    schNew.Tuesday__c.addError('You must enter a valid Start and End Time!');
                    return null;
                }
            }
            if(schNew.Wednesday__c) { 
                if(tmeRecurWednesdayStart > tmeRecurWednesdayEnd) {
                    schNew.Wednesday__c.addError('The End Time cannot come before the Start Time!');
                    return null;
                }
                if(tmeRecurWednesdayStart == null || tmeRecurWednesdayEnd == null) {
                    schNew.Wednesday__c.addError('You must enter a valid Start and End Time!');
                    return null;
                }
            }
            if(schNew.Thursday__c) { 
                if(tmeRecurThursdayStart > tmeRecurThursdayEnd) {
                    schNew.Thursday__c.addError('The End Time cannot come before the Start Time!');
                    return null;
                }
                if(tmeRecurThursdayStart == null || tmeRecurThursdayEnd == null) {
                    schNew.Thursday__c.addError('You must enter a valid Start and End Time!');
                    return null;
                }
            }
            if(schNew.Friday__c) { 
                if(tmeRecurFridayStart > tmeRecurFridayEnd) {
                    schNew.Friday__c.addError('The End Time cannot come before the Start Time!');
                    return null;
                }
                if(tmeRecurFridayStart == null || tmeRecurFridayEnd == null) {
                    schNew.Friday__c.addError('You must enter a valid Start and End Time!');
                    return null;
                }
            }
            if(schNew.Saturday__c) { 
                if(tmeRecurSaturdayStart > tmeRecurSaturdayEnd) {
                    schNew.Saturday__c.addError('The End Time cannot come before the Start Time!');
                    return null;
                }
                if(tmeRecurSaturdayStart == null || tmeRecurSaturdayEnd == null) {
                    schNew.Saturday__c.addError('You must enter a valid Start and End Time!');
                    return null;
                }
            }
            if(schNew.Sunday__c) { 
                if(tmeRecurSundayStart > tmeRecurSundayEnd) {
                    schNew.Sunday__c.addError('The End Time cannot come before the Start Time!');
                    return null;
                }
                if(tmeRecurSundayStart == null || tmeRecurSundayEnd == null) {
                    schNew.Sunday__c.addError('You must enter a valid Start and End Time!');
                    return null;
                }
            }
        }
        
        ////////////////////////////////////
        // Compute Single Class Variables
        ////////////////////////////////////
        if(clsParent.RecordTypeId == utilIds.classSingle) {
            dteStart = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeSingleStart.Hour(), tmeSingleStart.Minute(), 0);
            dteEnd = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeSingleEnd.Hour(), tmeSingleEnd.Minute(), 0);
            
            schNew.Start_Date__c = dteStart;
            schNew.End_Date__c = dteEnd;
            
            //lstNewSchedule.add(schNew);
            insert schNew;
        }
        
        ////////////////////////////////////
        // Compute Fixed and Ongoing Class Variables
        ////////////////////////////////////
        if(clsParent.RecordTypeId == utilIds.classFixed || clsParent.RecordTypeId == utilIds.classOngoing) {
            
            // Set Common Fields
            schNew.Start_Date__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), 0, 0, 0);
            
            if(clsParent.RecordTypeId == utilIds.classFixed) {
                schNew.End_Date__c = DateTime.newInstance(schNew.UI_End_Date__c.Year(), schNew.UI_End_Date__c.Month(), schNew.UI_End_Date__c.Day(), 0, 0, 0);
            }
            
            if(clsParent.RecordTypeId == utilIds.classOngoing) {
                schNew.End_Date__c = schNew.Start_Date__c.addMonths(Integer.valueOf(clsParent.Months_of_Sessions_to_Generate__c));
                System.Debug('****scheduleMethods.saveSchedule INFO:  Setting End Date of Ongoing Schedule to ' + schNew.End_Date__c);
            }
            
            if(schNew.Monday__c) {
                System.Debug('Saving Monday__c');
                schNew.Monday_Start_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurMondayStart.Hour(), tmeRecurMondayStart.Minute(), 0);
                schNew.Monday_End_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurMondayEnd.Hour(), tmeRecurMondayEnd.Minute(), 0);
            }
            if(schNew.Tuesday__c) {
                System.Debug('Saving Tuesday__c');
                schNew.Tuesday_Start_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurTuesdayStart.Hour(), tmeRecurTuesdayStart.Minute(), 0);
                schNew.Tuesday_End_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurTuesdayEnd.Hour(), tmeRecurTuesdayEnd.Minute(), 0);
            }
            if(schNew.Wednesday__c) {
                System.Debug('Saving Wednesday__c');
                schNew.Wednesday_Start_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurWednesdayStart.Hour(), tmeRecurWednesdayStart.Minute(), 0);
                schNew.Wednesday_End_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurWednesdayEnd.Hour(), tmeRecurWednesdayEnd.Minute(), 0);         
            }
            if(schNew.Thursday__c) {
                System.Debug('Saving Thursday__c');
                schNew.Thursday_Start_Time__c =DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurThursdayStart.Hour(), tmeRecurThursdayStart.Minute(), 0);
                schNew.Thursday_End_Time__c =DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurThursdayEnd.Hour(), tmeRecurThursdayEnd.Minute(), 0);         
            }
            if(schNew.Friday__c) {
                System.Debug('Saving Friday__c');
                schNew.Friday_Start_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurFridayStart.Hour(), tmeRecurFridayStart.Minute(), 0);
                schNew.Friday_End_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurFridayEnd.Hour(), tmeRecurFridayEnd.Minute(), 0);
            }
            if(schNew.Saturday__c) {
                System.Debug('Saving Saturday__c');
                schNew.Saturday_Start_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurSaturdayStart.Hour(), tmeRecurSaturdayStart.Minute(), 0);
                schNew.Saturday_End_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurSaturdayEnd.Hour(), tmeRecurSaturdayEnd.Minute(), 0);            
            }
            if(schNew.Sunday__c) {
                System.Debug('Saving Sunday__c');
                schNew.Sunday_Start_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurSundayStart.Hour(), tmeRecurSundayStart.Minute(), 0);
                schNew.Sunday_End_Time__c = DateTime.newInstance(schNew.UI_Start_Date__c.Year(), schNew.UI_Start_Date__c.Month(), schNew.UI_Start_Date__c.Day(), tmeRecurSundayEnd.Hour(), tmeRecurSundayEnd.Minute(), 0);
            }
            
            insert schNew;
        }
        
        
        ////////////////////////////////////
        // Insert New Schedules and return to Class Page
        ////////////////////////////////////
        //if(lstNewSchedule.size() > 0) { insert lstNewSchedule; }
        
        PageReference pfSuccess = new PageReference('/' + idClass);
        pfSuccess.setRedirect(true);
        return pfSuccess;
        
    }
    
    public PageReference cancelSchedule() {
        
        PageReference pfCancel = new PageReference('/' + idClass);
        pfCancel.setRedirect(true);
        return pfCancel;
        
    }
    
/////////////////////////////////////////
// Function Classes
/////////////////////////////////////////

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