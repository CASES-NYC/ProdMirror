public without sharing class testMethods {

    public utilityIds utilIds = new utilityIds();
    public utilityMethods utilMethods = new utilityMethods();    
    public Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
    
    public List<Test__c> insertedTests = new List<Test__c>();
    public List<Task> affectedTasks = new List<Task>(); 
    public List<Task> newTasks = new List<Task>();
    public Set<Id> whoIds = new Set<Id>();
    public Set<Id> taskRecTypesToQuery = new Set<Id>(); 
    public Map<Id,Contact> contactsAffected = new Map<Id,Contact>();
    public List<Contact> contactsForUpdate = new List<Contact>();
    public Id substanceAbuseSupervisorId = csApexDefaults.substance_Abuse_Supervisor__c;
    
    // Get all related contacts

    
    public void getWhoIds() {
        
        
        // Limit the tasks by rec type      
        //taskRecTypesToQuery.add(utilIds.MAYSIAssessmentTask);
        taskRecTypesToQuery.add(utilIds.STARTestMathTask);
        taskRecTypesToQuery.add(utilIds.STARTestReadingTask);
        taskRecTypesToQuery.add(utilIds.initialDrugTestTask);
        taskRecTypesToQuery.add(utilIds.nextDrugTestTask);
        taskRecTypesToQuery.add(utilIds.exitDrugTestTask);             
        
        for(Test__c thisTest:insertedTests) {
            
            whoIds.add(thisTest.Contact__c); 
        }
        
        contactsAffected = new Map<Id,Contact>([Select  Id, MAYSI_Test_Date__c, Last_Drug_Test_Date__c, Last_Drug_Test_Result__c,
            // 10/24/14 MB
            //deleted these fields. if we ever use the MAYSI again we wouldn't port to the contact first
            //Alcohol_Drug_Use__c, Thought_Disturbance__c, Somatic_Complaints__c, Suicide_Ideation__c,
            //Angry_Irritable__c, Traumatic_Experiences__c, Depressed_Anxious__c,   
            STAR_Math_Date__c, STAR_Math_Score__c, GED_Test_Date__c, GED_Test_Type__c, GED_Score__c, 
            GED_Result__c, STAR_Reading_Date__c, STAR_Reading_Score__c, MAYSI_Assesment_Complete__c,
            Drug_test_frequency__c, STAR_Reading_done_on_time__c, STAR_math_done_on_time__c,
            Client_Status__c, MAYSI_Flag__c, Current_Projected_Exit_Date__c, RecordTypeId,
            (select id, Contact__c, Test_Date__c, Math_Ge_RPT__c, Reading_GE_RPT__c
                from Tests__r where RecordTypeId in (:utilIds.starTestRecordType, :utilIds.tabeTestRecordType) 
                order by Test_Date__c asc),
            (select WhoId, Id, Open_Date__c, Drug_Test_Results__c, activityDate, Closed_By_System__c, 
                isClosed, Closing_Date__c, Closed_By__c, SkipRestrictions__c, recordTypeId, Status 
                from Tasks Where (recordTypeId in :taskRecTypesToQuery AND IsClosed = false) OR 
                (recordTypeId = :utilIds.exitDrugTestTask))
            From Contact Where Id in :whoIds]);
    } 
    

    //get all the possible tasks associated with this Affected contacts and tests     
    // 12/20/13 this method merged with getWhoIds
    /*public void getAllRelatedTasks() {
        
        // Limit the tasks by rec type      
        taskRecTypesToQuery.add(utilIds.MAYSIAssessmentTask);
        taskRecTypesToQuery.add(utilIds.STARTestMathTask);
        taskRecTypesToQuery.add(utilIds.STARTestReadingTask);
        taskRecTypesToQuery.add(utilIds.initialDrugTestTask);
        taskRecTypesToQuery.add(utilIds.nextDrugTestTask);
        taskRecTypesToQuery.add(utilIds.exitDrugTestTask);
    
        // This should be a list of all possible tasks associated with the contact that took the tests
        
        AffectedTasks = [Select Drug_Test_Results__c,
                                Open_Date__c,
                                activityDate,
                                Closed_By_System__c, 
                                isClosed,
                                Closing_Date__c,
                                WhoId, 
                                Id,
                                Closed_By__c,
                                SkipRestrictions__c,
                                recordTypeId,
                                Status from Task 
                                Where WhoId in :whoIds AND 
                                ((recordTypeId in :taskRecTypesToQuery AND IsClosed = false) OR 
                                (recordTypeId = :utilIds.exitDrugTestTask))];
    }*/
    
    public void processGEDinsert() {
        
        for(Test__c thisTest:insertedTests) { // Loop through all tests
        
            if(thisTest.RecordTypeId == utilIds.gedRecordType
            || thisTest.RecordTypeId == utilIDs.tascRecordType) { // Is it a GED?
                // MB 3/12/14 added TASC
                //QC 20120430 BT-335 only update contact if test date on contact < test date
              if(String.valueOf(contactsAffected.get(thisTest.Contact__c).GED_Test_Date__c)<=String.valueOf(thisTest.Test_Date__c)) {
                contactsAffected.get(thisTest.Contact__c).GED_Test_Date__c = thisTest.Test_Date__c; // Update the related COntact
                contactsAffected.get(thisTest.Contact__c).GED_Test_Type__c = thisTest.Test_Type__c; // Update the related COntact
                contactsAffected.get(thisTest.Contact__c).GED_Score__c = thisTest.Total_Score__c; // Update the related COntact
                contactsAffected.get(thisTest.Contact__c).GED_Result__c = thisTest.Result__c; // Update the related COntact
              }  
            }
            
        }
        
    }
    /*
    public void processMAYSIinsert() {
        
        for(Test__c thisTest:insertedTests) { // Loop through all tests
        
            if(thisTest.RecordTypeId == utilIds.maysiTestRecordType) { // Is it a MAYSI?
                
              //QC 20120430 BT-335 only update contact if test date on contact < test date
              if(String.valueOf(contactsAffected.get(thisTest.Contact__c).MAYSI_Test_Date__c)<=String.valueOf(thisTest.Test_Date__c)) {
                
                contactsAffected.get(thisTest.Contact__c).MAYSI_Assesment_Complete__c = true; // Update the related COntact
                contactsAffected.get(thisTest.Contact__c).MAYSI_Test_Date__c = thisTest.Test_Date__c;           
                contactsAffected.get(thisTest.Contact__c).Alcohol_Drug_Use__c = thisTest.Alcohol_Drug_Use_text__c;
                contactsAffected.get(thisTest.Contact__c).Thought_Disturbance__c = thisTest.Thought_Disturbance_Text__c;    
                contactsAffected.get(thisTest.Contact__c).Somatic_Complaints__c = thisTest.Somatic_Complaints_Text__c;  
                contactsAffected.get(thisTest.Contact__c).Suicide_Ideation__c = thisTest.Suicide_Ideation_Text__c;  
                contactsAffected.get(thisTest.Contact__c).Angry_Irritable__c = thisTest.Angry_Irritable_Text__c;    
                contactsAffected.get(thisTest.Contact__c).Traumatic_Experiences__c = thisTest.Traumatic_Experiences_Text__c;    
                contactsAffected.get(thisTest.Contact__c).Depressed_Anxious__c = thisTest.Depressed_Anxious_Text__c;    
              }  
                // Calculate if Maysi Flag on Contact should be True, and update contact page 
                Integer cautionWarningCount = 0;
                Boolean suicide = false;
                
                if(thisTest.Alcohol_Drug_Use_text__c == 'caution' || thisTest.Alcohol_Drug_Use_text__c == 'warning') {
                    
                    cautionWarningCount++;
                }
                
                if(thisTest.Thought_Disturbance_Text__c == 'caution' || thisTest.Thought_Disturbance_Text__c == 'warning') {
                    
                    cautionWarningCount++;
                }
                
                if(thisTest.Somatic_Complaints_Text__c == 'caution' || thisTest.Somatic_Complaints_Text__c == 'warning') {
                    
                    cautionWarningCount++;
                }
                
                if(thisTest.Suicide_Ideation_Text__c == 'caution' || thisTest.Suicide_Ideation_Text__c == 'warning') {
                    suicide = true;
                    
                    cautionWarningCount++;
                }
                
                if(thisTest.Angry_Irritable_Text__c == 'caution' || thisTest.Angry_Irritable_Text__c == 'warning') {
                    
                    cautionWarningCount++;
                }
                
                if(thisTest.Traumatic_Experiences_Text__c == 'caution' || thisTest.Traumatic_Experiences_Text__c == 'warning') {
                    
                    cautionWarningCount++;
                }
                
                if(thisTest.Depressed_Anxious_Text__c == 'caution' || thisTest.Depressed_Anxious_Text__c == 'warning') {
                    
                    cautionWarningCount++;
                }       
                
                Boolean contactMaysiFlagUpdate = false;
                
                if(suicide || cautionWarningCount > 2) {
                    
                    contactMaysiFlagUpdate = true;
                    
                } 
              //QC 20120430 BT-335 only update contact if test date on contact < test date
              if(String.valueOf(contactsAffected.get(thisTest.Contact__c).MAYSI_Test_Date__c) <= 
              String.valueOf(thisTest.Test_Date__c)) {
                
                contactsAffected.get(thisTest.Contact__c).MAYSI_Flag__c = contactMaysiFlagUpdate;   
              }                  
                
                for(Task thisTask: contactsAffected.get(thisTest.Contact__c).Tasks) { /// Loop through a tasks
                    
                    if(thisTask.RecordTypeId == utilIds.MAYSIAssessmentTask) { // Is it a match
                        
                        if(thisTest.Test_Date__c <= thisTask.activityDate) {
                            
                            thisTask.Status = 'Done on Time';
                        
                        } else {
                            
                            thisTask.Status = 'Done Late';
                        }
                        thisTask.Closing_Date__c = thisTest.Test_Date__c;
                        thisTask.Closed_By_System__c  = True;
                        thisTask.SkipRestrictions__c = true;
                    }
                }
            } 
        }
    }*/
    
    // 3/12/14 MB this method sets field values on the before trigger. Test_Summary in particular must be run 
    //this way because it is over the compile size limit and a workflow would cause the trigger to run twice,
    //creating duplicate drug test tasks (DB Helpdesk: 872)
    public void processTestSummary() {
        
        for(Test__c thisTest:insertedTests) { // Loop through all tests 
            
            //Drug Test
            if(thisTest.RecordTypeId == utilIds.drugTestRecordType) {
            
                Decimal positiveScoreValue = 0;
                if(thisTest.Alcohol__c != null) { positiveScoreValue += thisTest.Alcohol__c;}
                if(thisTest.Cocaine__c != null) { positiveScoreValue += thisTest.Cocaine__c;}
                if(thisTest.Marijuana__c != null) { positiveScoreValue += thisTest.Marijuana__c;}
                if(thisTest.Opiates__c != null) { positiveScoreValue += thisTest.Opiates__c;}       
                if(thisTest.Meth__c!= null) { positiveScoreValue += thisTest.Meth__c;}  
                if(thisTest.PCP__c != null) { positiveScoreValue += thisTest.PCP__c;}       
                if(thisTest.Barbiturates__c != null) { positiveScoreValue += thisTest.Barbiturates__c;}
                if(thisTest.Benzodiazepine__c != null) { positiveScoreValue += thisTest.Benzodiazepine__c;}
                if(thisTest.Ecstasy__c  != null) { positiveScoreValue += thisTest.Ecstasy__c;}
                       
                if(positiveScoreValue > 1) { 
                    thisTest.Positive_Score__c  = true;
                    thisTest.Test_Summary__c = 'Positive';
                } else {
                    thisTest.Positive_Score__c  = false; 
                    thisTest.Test_Summary__c = 'Negative';
                }           
            } else if(thisTest.RecordTypeId == utilIds.catRecordType) {
                
                thisTest.Test_Summary__c = 'Read: ' + thisTest.Reading_Pass_Fail__c
                + ', Writing: ' + thisTest.Writing_Pass_Fail__c 
                + ', Math 1: ' + thisTest.Math_I_Pass_Fail__c  + ', Math 2: ' + thisTest.Math_II_Pass_Fail__c; 
            } else if(thisTest.RecordTypeId == utilIds.maysiTestRecordType) {
                
                thisTest.Test_Summary__c = thisTest.TempMaysiSummary__c;
            } else if (thisTest.RecordTypeId == utilIDs.gedRecordType
            || thisTest.RecordTypeID == utilIds.tascRecordType) {
                
                thisTest.Test_Summary__c = thisTest.Result__c;
            } else if (thisTest.RecordTypeId == utilIDs.starTestRecordType) {
                
                thisTest.Test_Summary__c = 'GE ' + thisTest.Grade_Equivalent__c;
            } else if (thisTest.RecordTypeId == utilIDs.tabeTestRecordType) {
                
                thisTest.Test_Summary__c = 'Read GE: '
                + (thisTest.Reading_GE_RPT__c > 0? string.valueOf(thisTest.Reading_GE_RPT__c): 'n/a') 
                + ', Math GE: ' + (thisTest.Math_GE_RPT__c > 0? string.valueOf(thisTest.Math_GE_RPT__c): 'n/a');
            }
        }
    }
    
    public void processDrugTestinsert() {
        
        for(Test__c thisTest:insertedTests) { // Loop through all tests 
      
            if(thisTest.RecordTypeId == utilIds.drugTestRecordType) { // Is it the test being inserted a drug test?
                
                String lastDrugTestResult;
                if(thisTest.Positive_Score__c) { lastDrugTestResult = 'Positive Score';} else { lastDrugTestResult = 'Negative Score';}
                    
                contactsAffected.get(thisTest.Contact__c).Last_Drug_test_result__c = lastDrugTestResult; 
                contactsAffected.get(thisTest.Contact__c).Last_Drug_Test_Date__c = thisTest.Test_Date__c;
                
                
                for(Task thisTask: contactsAffected.get(thisTest.Contact__c).Tasks) { /// Loop through tasks
                    
                    /////////////////////////////////
                    // Exit drug test logic
                    ////////////////////////////////////
                    
                        //////////////////////////////////////
                        // Process open exit drug tests tasks
                        ///////////////////////////////////////////
            
                        if( thisTask.RecordTypeId == utilIds.exitDrugTestTask && 
                            !thisTask.isClosed && thisTest.Test_Date__c  >= thisTask.Open_Date__c) { // Is it a match
                        
                            
                            if(thisTest.Test_Date__c <= thisTask.activityDate) { /// Rules for initial Task
                                    
                                    thisTask.Status = 'Done on Time';
                                
                                } else if(thisTest.Test_Date__c > thisTask.activityDate 
                                && thisTest.Test_Date__c < thisTask.activityDate.addDays(15) ) {
                                    
                                    thisTask.Status = 'Done Late';
                            
                                } else {
                                    
                                    thisTask.Status = 'Incomplete';
                                }
                            if(thisTest.Positive_Score__c ) 
                                {thisTask.Drug_Test_Results__c = 'Positive'; } 
                            else {thisTask.Drug_Test_Results__c = 'Negative';}
                            
                            thisTask.Closing_Date__c = thisTest.Test_Date__c;
                            thisTask.Closed_By__c = UserInfo.getName();
                            thisTask.Closed_By_System__c  = True;
                            thisTask.SkipRestrictions__c = true;
                            affectedTasks.add(thisTask);
                        }
                    
                    
                        //////////////////////////////////////
                        //  Process closed exit drug tests tasks
                        //  Req: ToDo 88
                        ///////////////////////////////////////////
            
                        if( thisTask.RecordTypeId == utilIds.exitDrugTestTask && 
                            thisTask.isClosed && 
                            thisTask.status != 'Cancelled' &&
                            thisTest.Test_Date__c  > thisTask.Closing_Date__c &&
                            thisTest.Test_Date__c <= thisTask.ActivityDate.addDays(14)) { // Is it a match
                        
                            thisTask.Closing_Date__c = thisTest.Test_Date__c ;
                            if(thisTest.Test_Date__c <= thisTask.ActivityDate) { thisTask.status = 'DONE ON TIME';}
                            if(thisTest.Test_Date__c > thisTask.ActivityDate) { thisTask.status = 'DONE LATE';}
                            // 3/14/13 MB: added because task_methods was throwing an error when a new test
                            // caused the status to change from done on time to late
                            thisTask.SkipRestrictions__c = true;
                            affectedTasks.add(thisTask);
                        
                        }
            
                    /////////////////////////////////
                    // Next and inital drug test logic
                    ////////////////////////////////////
                    
                    
                    if(thisTask.RecordTypeId == utilIds.initialDrugTestTask || 
                    thisTask.RecordTypeId == utilIds.nextDrugTestTask) { // Is it a match
                        
                        if(thisTask.RecordTypeId == utilIds.initialDrugTestTask) {
                            
                            if(thisTest.Test_Date__c <= thisTask.activityDate) { /// Rules for initial Task
                                
                                thisTask.Status = 'Done on Time';
                            
                            } else {
                                
                                thisTask.Status = 'Done Late';
                            }
                        }
                        
                        // Next Drug Tests have a 4 day window.
                        if(thisTask.RecordTypeId == utilIds.nextDrugTestTask) { 
                            
                            if(thisTest.Test_Date__c <= thisTask.activityDate.addDays(4)) {
                                
                                thisTask.Status = 'Done on Time';
                            
                            } else {
                                
                                thisTask.Status = 'Done Late';
                            }
                        }
                        thisTask.Closing_Date__c = thisTest.Test_Date__c;
                        thisTask.Closed_By_System__c  = True;
                        thisTask.SkipRestrictions__c = true;
                        affectedTasks.add(thisTask);
                    }
                } 
        
                //////////////////////////////////////////////////////
                /// Now create new drug test task
                /////////////////////////////////////////////////////
                
                System.debug('HERE: ' + contactsAffected.get(thisTest.Contact__c).Client_Status__c );
                
                /// Is Client on hold or active
                if(contactsAffected.get(thisTest.Contact__c).Client_Status__c  == 'Active' 
                || contactsAffected.get(thisTest.Contact__c).Client_Status__c == 'On Program Hold') {
                
                    // Current_Projected_Exit_Date__c 
                    
                    System.debug('HERE2');
                    /////////////////////////////////////////////////////////////
                    // Create next Drug Test Task
                    /////////////////////////////////////////////////////////////
                    
                    Task nextDrugTestT = new Task();
                    nextDrugTestT.OwnerId = substanceAbuseSupervisorId;
                    nextDrugTestT.WhoId = thisTest.Contact__c;
                    nextDrugTestT.RecordTypeId = utilIds.nextDrugTestTask;
                    nextDrugTestT.Subject = 'Next Drug Test';
                    nextDrugTestT.Open_Date__c = thisTest.Test_Date__c.addDays(1);
                    
                    Integer daysToAdd = 14;
                    if(contactsAffected.get(thisTest.Contact__c).Drug_test_frequency__c == 'Bi-Weekly') {
                        
                        daysToAdd = 14;
                    }
                    
                    if(contactsAffected.get(thisTest.Contact__c).Drug_test_frequency__c == 'Weekly') {
                        
                        daysToAdd = 7;  
                    }
                    
                    if(contactsAffected.get(thisTest.Contact__c).Drug_test_frequency__c == 'Monthly') {
                        
                        daysToAdd = 31;
                    }
                    //Bi-Weekly - 14 days
                    //Weekly - 7 days
                    //Monthly - 31 days
                    
                    nextDrugTestT.ActivityDate = thisTest.Test_Date__c.addDays(daysToAdd); 
                    nextDrugTestT.Verification_Due_Date__c = thisTest.Test_Date__c.addDays(daysToAdd); 
                    nextDrugTestT.Automatically_Generated__c = true;
                    System.debug('nextDrugTestT: ' + nextDrugTestT);
                    System.debug('New Test Date: ' + thisTest.Test_Date__c.addDays(daysToAdd));
                    System.debug('Current Projected Exit: ' + contactsAffected.get(thisTest.Contact__c).Current_Projected_Exit_Date__c);
                    
                    // 3/25/13 MB: Changing logic here for prod.a.BT-0661. A new task can now be created
                    // before the current projected exit date is set (in classClientStatus, called from the future
                    // method ClassEvent). So, added logic so that Current Projected Exit Date can be null
                    // if contact record type is CEP. 

                    if(contactsAffected.get(thisTest.Contact__c).RecordTypeId == utilIds.conClient ) {
                    
                        if(contactsAffected.get( thisTest.Contact__c).Current_Projected_Exit_Date__c==Null                  
                        || thisTest.Test_Date__c.addDays(daysToAdd) <= 
                        contactsAffected.get( thisTest.Contact__c).Current_Projected_Exit_Date__c.addDays(-14)) { 
                            
                            newTasks.add(nextDrugTestT);
                        }   
                    }           
                }
            }
        }       
    }// end of method
    
    
    //////////////////////////////////////////////////////
    // Logic to close open tasks when an STAR test is
    // inserted into the system
    //////////////////////////////////////////////////////

    //10/17/13 MB: this method deprecated, replaced by processSTARorTABE
    /*public void processSTARinsert() {
        
        for(Test__c thisTest:insertedTests) { // Loop through all tests
        
            if(thisTest.RecordTypeId == utilIds.starTestRecordType
            // 2/4/13 MB: Added the TABE. Fields on contact are now for STAR/TABE values
            || thisTest.RecordTypeId == utilIds.tabeTestRecordType) { // Is it a STAR
                
                ////////////////////////////////////////////////////////////
                //
                // Update the associated contact
                //
                ////////////////////////////////////////////////////////////
                
                system.debug(thisTest.Math_ge_RPT__c);
                
                if(thisTest.Math_Ge_RPT__c != null) {
                   // QC: 20120430 BT-335 only update contact if Test date new or same        
                  if(String.valueOf(contactsAffected.get(thisTest.Contact__c).STAR_Math_Date__c)<=String.valueOf(thisTest.Test_Date__c)) {      
                    
                    contactsAffected.get(thisTest.Contact__c).STAR_Math_done_on_time__c = true; // Update the related COntact
                    contactsAffected.get(thisTest.Contact__c).STAR_Math_Date__c = thisTest.Test_Date__c;
                    contactsAffected.get(thisTest.Contact__c).STAR_Math_Score__c = thisTest.Math_Ge_RPT__c;
                  }  
                }
                
                if(thisTest.Reading_Ge_RPT__c != null) {
                   // QC: 20120430 BT-335 only update contact if Test date new or same        
                  if(String.valueOf(contactsAffected.get(thisTest.Contact__c).STAR_Reading_Date__c)<=String.valueOf(thisTest.Test_Date__c)) {   
                    
                    contactsAffected.get(thisTest.Contact__c).STAR_Reading_done_on_time__c = true; // Update the related COntact
                    contactsAffected.get(thisTest.Contact__c).STAR_Reading_Date__c = thisTest.Test_Date__c;
                    contactsAffected.get(thisTest.Contact__c).STAR_Reading_Score__c = thisTest.Reading_GE_RPT__c;
                  }
                }
                    
                for(Task thisTask:AffectedTasks) { /// Loop through a tasks
                    
                    if(thisTask.RecordTypeId == utilIds.STARTestMathTask 
                    && thisTask.WhoId == thisTest.Contact__c  
                    && thisTest.Math_Ge_RPT__c != null) { // Is it A MATH TEST
                        
                        if(thisTest.Test_Date__c <= thisTask.activityDate) {
                            
                            thisTask.Status = 'Done on Time';
                            
                        } else {
                            
                            thisTask.Status = 'Done Late';
                        }
                        thisTask.Closing_Date__c = thisTest.Test_Date__c;
                        thisTask.Closed_By_System__c  = True;
                        thisTask.SkipRestrictions__c = true;
                    }
                    
                    if(thisTask.RecordTypeId == utilIds.STARTestReadingTask 
                    && thisTask.WhoId == thisTest.Contact__c  
                    && thisTest.Reading_Ge_RPT__c != null) { // Is it A Reading TEST
                        
                        if(thisTest.Test_Date__c <= thisTask.activityDate) {
                            
                            thisTask.Status = 'Done on Time';
                            
                        } else {
                            
                            thisTask.Status = 'Done Late';
                        }
                        thisTask.Closing_Date__c = thisTest.Test_Date__c;
                        thisTask.Closed_By_System__c  = True;
                        thisTask.SkipRestrictions__c = true;
                    }
                }
            } 
        }
    }*/   

    // Save Tasks once
    
    public void updateAllRelatedTasks() {
        
        if(newTasks.size() > 0)  { insert newTasks; }
        if(contactsAffected.size() >0){ 
            
            List<Contact> contsForUpdate = new List<Contact>();
            contsForUpdate = contactsAffected.values(); 
            update contsForUpdate;
        }
        
        update AffectedTasks;
    }
 
    public void processSTARorTABE() {
        
        for(Contact c: contactsAffected.values()) {   
                    
            c.STAR_Math_Date__c = null;
            c.STAR_Math_Score__c = null;
            c.STAR_Reading_Date__c = null;
            c.STAR_Reading_Score__c = null;
            
            for(Test__c thisTest: c.Tests__r) {
                
                if(thisTest.Math_Ge_RPT__c != null && thisTest.Math_Ge_RPT__c != 0) { 
                    
                    contactsAffected.get(thisTest.Contact__c).STAR_Math_Date__c = thisTest.Test_Date__c;
                    contactsAffected.get(thisTest.Contact__c).STAR_Math_Score__c = thisTest.Math_Ge_RPT__c;
                    
                    for(Task thisTask: c.Tasks) {
                        if(thisTask.RecordTypeId == utilIds.STARTestMathTask
                        && thisTask.Status == 'Not Started'
                        && thisTest.Test_Date__c >= thisTask.Open_Date__c) {

                            if(thisTest.Test_Date__c <= thisTask.activityDate) {
                                
                                thisTask.Status = 'Done on Time';     
                            } else {
                                
                                thisTask.Status = 'Done Late';
                            }
                            thisTask.Closing_Date__c = thisTest.Test_Date__c;
                            thisTask.Closed_By_System__c  = True;
                            thisTask.SkipRestrictions__c = true;
                            affectedTasks.add(thisTask);                                
                        }                   
                    }                
                }
                
                if(thisTest.Reading_Ge_RPT__c != null && thisTest.Reading_Ge_RPT__c != 0) { 
                    
                    contactsAffected.get(thisTest.Contact__c).STAR_Reading_Date__c = thisTest.Test_Date__c;
                    contactsAffected.get(thisTest.Contact__c).STAR_Reading_Score__c = thisTest.Reading_Ge_RPT__c;
                    
                    for(Task thisTask: c.Tasks) {
                        if(thisTask.RecordTypeId == utilIds.STARTestReadingTask
                        && thisTask.Status == 'Not Started'
                        && thisTest.Test_Date__c >= thisTask.Open_Date__c) {

                            if(thisTest.Test_Date__c <= thisTask.activityDate) {
                                
                                thisTask.Status = 'Done on Time';     
                            } else {
                                
                                thisTask.Status = 'Done Late';
                            }
                            thisTask.Closing_Date__c = thisTest.Test_Date__c;
                            thisTask.Closed_By_System__c  = True;
                            thisTask.SkipRestrictions__c = true;
                            affectedTasks.add(thisTask);                                
                        }                   
                    }                
                }                                                   
            } 
        }
    }    
    
}