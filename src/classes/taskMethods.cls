////////// CHANGE HISTORY as part of merger of Educ & Empl staff profiles - pr
//
/////////
public without sharing class taskMethods {
    
    public utilityIds util = new utilityIds();
    public utilityMethods utilMeths = new utilityMethods();
    public Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
    public rearrestCheckMethods rearrestMeths = new rearrestCheckMethods();
    public List<Task> lstNewTasks = new List<Task>();
    public List<Task> lstOldTasks = new List<Task>();
    public List<Task> existingStarTests = new List<Task>();
    public Set<Id> existingStarMathTests = new Set<Id>();
    public Set<Id> existingStarReadingTests = new Set<Id>();
    public Set<Id> ownerIDs = new Set<Id>();
    public Set<Id> allOwnerIDs = new Set<Id>();
    public Set<Id> contactIDs = new Set<Id>();
    //added by MB 10/10/12
    public List<Id> schoolVisitIDs = new List<Id>();
    public List<Account> schoolVisitAccounts = new List<Account>();
    
   
   // always reset Skip Restrictions back to false at the end of the before trigger
   // 3/26/13 MB renamed from skipRestrictions, which is confusing
    public void resetSkipRestrictions() {
        for(Task thisTask:lstNewTasks) { 
        
            thisTask.SkipRestrictions__c = false;
        }
        
    }
    
    
    ///////////////////////////////////////////////
    // set closing date and user for manually rejected PS Note tasks
    //////////////////////////////////////////////
    
    public void closeTasksManually() {
        
        integer i = 0;
        
        for(Task thisTask:lstNewTasks) { 
        
            if((thisTask.RecordTypeId == util.psCRSNoteTask || thisTask.RecordTypeId == util.psProgressNoteTask 
                || thisTask.RecordTypeId == util.careerExplorationReferralTask
                || thisTask.RecordTypeId == util.alumniSurveyTask) 
            && thisTask.Status == 'Rejected' 
            && (lstOldTasks[i].Status != 'Rejected' || lstOldTasks[i].Status == null) 
            && thisTask.closed_by_system__c != true){
                
                thisTask.Closing_Date__c = system.today();
                thisTask.Closed_by__c = userinfo.getName();
                
            }            
        
        i++;
        
        }
        
    }
    
    
    ////////////////////////////////////////////////////
    // Map Unit
    ///////////////////////////////////////////////////
    
    public void mapUnit() {
        
        for(Task thisTask:lstNewTasks) { 
        
            allOwnerIDs.add(thisTask.ownerId);
        }
        
        Map<Id,User> allUsers = new Map<Id,User> ([Select profileId from User where Id in :allOwnerIDs]);
        
        for(Task thisTask:lstNewTasks) { 
            
            String profileId = allUsers.get(thisTask.OwnerId).profileId;
            thisTask.unit__c = util.unitMap.get(profileId);
            
        }
    }

    
    // There are some tasks that can be created manually but 
    // we need to tweak some of their data elements
    
    public void manualTaskCreationUpdates() {
        
        // set up variables
        For(Task t:lstNewTasks) {
            schoolVisitIds.add(t.whatId);
        }
        
        // 3/18/13 MB: added to avoid referencing these record types in multiple places
        set<Id> setRecTypesforDupCheck = new set<Id>();
        setRecTypesforDupCheck.add(util.educationAssessmentTask);
        setRecTypesforDupCheck.add(util.employmentAssessmentTask);
        setRecTypesforDupCheck.add(util.mentalHealthAssessmentTask);
        setRecTypesforDupCheck.add(util.alumniSurveyTask);
        
        schoolVisitAccounts = [Select Id, BillingStreet, BillingCity, BillingState, BillingPostalCode 
                           from Account where Id in :schoolVisitIds];
        
        // These Id lists are used to check for duplicate tasks                
        for(Task thisTask:lstNewTasks) { 
            
            if(setRecTypesforDupCheck.contains(thisTask.RecordTypeId)) {
            
                contactIDs.add(thisTask.whoId);
            }
        }                          
        
        // 3/18/13 MB: no longer used                  
        //Map<Id,User> userToProfile = new Map<Id,User>([Select id, ProfileId from User where Id in :ownerIDs]);
        
        List<Task> existingAssessmentTasks = [Select Id, recordTypeId, whoId, subject 
                                              from Task 
                                              Where isClosed = False AND whoId in :contactIDs
                                              AND RecordTypeId in :setRecTypesforDupCheck];
                                              
        system.debug('\n\n***Inside manualTaskCreationUpdates.  contactIDs: ' + contactIDs);                                      
        system.debug('\n\n***Inside manualTaskCreationUpdates.  Tasks found: ' + existingAssessmentTasks);                         
        
        // define field values
        for(Task thisTask:lstNewTasks) { 
                
            if( thisTask.RecordTypeId == util.educationAssessmentTask) {
                
                thisTask.Open_Date__c = System.Today();
                thisTask.ActivityDate = System.Today().addDays(29);
                thisTask.Verification_Due_Date__c = System.Today().addDays(29);
                thisTask.OwnerId = csApexDefaults.education_Liaison_Supervisor__c;
            } 
            
            if( thisTask.RecordTypeId == util.employmentAssessmentTask) {
                
                thisTask.Open_Date__c = System.Today();
                thisTask.ActivityDate = System.Today().addDays(29);
                thisTask.Verification_Due_Date__c = System.Today().addDays(29);
                
                //added null check 1/22/14 MB because Christina wants Melrose to assign these to Jessica
                if(thisTask.ownerId == null) {
                    thisTask.OwnerId = csApexDefaults.employment_Supervisor__c; 
                }                   
            }   
            
            if( thisTask.RecordTypeId == util.mentalHealthAssessmentTask  ) {
                
                thisTask.Open_Date__c = System.Today();
                thisTask.ActivityDate = System.Today().addDays(44);
                thisTask.Verification_Due_Date__c = System.Today().addDays(44);
                //TEMP CHANGE till we have a new MH supervisor
                thisTask.OwnerId = csApexDefaults.cep_Director__c;
            }
            
            //added by MB 10/10/12 to process new school visit task
            if( thisTask.RecordTypeId == util.schoolVisitTask  ) {
                
                thisTask.Open_Date__c = System.Today();
                if(thisTask.ActivityDate == null) {
                    
                    thisTask.ActivityDate = System.Today().addDays(14);
                }
                
                For(Account a:schoolVisitAccounts) {
                    if(thisTask.WhatId == a.Id) {
                    
                    thisTask.School_Address__c = a.BillingStreet + ' ' + a.BillingCity + ', ' 
                    + a.BillingState + ' ' + a.BillingPostalCode;
                    }   
                }               
            
            }                           
           
            // add error if necessary
                       
            for(Task assessTask: existingAssessmentTasks) {
                
                if(thisTask.whoId == assessTask.whoId && thisTask.RecordTypeId == assessTask.RecordTypeId ) {
                    
                    thisTask.addError('You can not have more than one open ' 
                    + thisTask.Subject + ' task for a client');
                }
            }            
           
            //added by MB 10/10/12 to process new school visit task
            if( thisTask.RecordTypeId == util.schoolVisitTask  ) {          
            
                if(thisTask.OwnerId != csApexDefaults.education_Liaison_Supervisor__c               
                    && thisTask.OwnerId != csApexDefaults.education_Liaison_Staff__c) {
                
                    thisTask.addError('This task must be assigned to an Education Liaison staff or supervisor.');   
                }
            }            
            
            ////////////////////////////////////////////////
            // Deal with rearrest tasks 
            ////////////////////////////////////////////////
            
            if(thisTask.RecordTypeId == util.rearrestCheckTask) {
                    
                rearrestMeths.rearrestCheckInsertLogic(thisTask);
                    
            }
            
            ////////////////////////////////////////////////////////
            // Most tasks can't be generated manually
            ////////////////////////////////////////////////////////
            
            //added by MB 8/28/12 to comply with specs          
            if(!thisTask.Automatically_Generated__c &&
            (thisTask.RecordTypeId == util.mandatoryClassesTask || 
            thisTask.RecordTypeId == util.caseCoordinatorAssessmentTask ||
            thisTask.RecordTypeId == util.employmentSurveyTask  || 
            thisTask.RecordTypeId == util.substanceAbuseAssessmenTask ||
            thisTask.RecordTypeId == util.initialDrugTestTask ||
            thisTask.RecordTypeId == util.MAYSIAssessmentTask ||
            thisTask.RecordTypeId == util.PHQ9Task ||
            thisTask.RecordTypeId == util.UCLATask ||
            thisTask.RecordTypeId == util.LSCMITask ||            
            thisTask.RecordTypeId == util.initialProgramPlanTask ||
            thisTask.RecordTypeId == util.careerExplorationReferralTask ||
            thisTask.RecordTypeId == util.exitNotificationTask ||
            thisTask.RecordTypeId == util.exitDrugTestTask ||
            thisTask.RecordTypeId == util.CBOPlacementTask ||
            thisTask.RecordTypeId == util.ccProgressNoteTask ||
            thisTask.RecordTypeId == util.psProgressNoteTask ||
            thisTask.RecordTypeId == util.ccCRSNoteTask ||
            thisTask.RecordTypeId == util.psCRSNoteTask || 
            thisTask.RecordTypeId == util.nextDrugTestTask))
                    
            {
                thisTask.WhoId.addError('You cannot create this task manually');                  
            }        
        }       

    }  //EOF - manualTaskCreationUpdates()
    

    // Parse out existing STAR test types
    
    public void getExistingStarTests() {
        
        Set<Id> whoIds = new Set<Id>();
        
        for(Task thisTask:lstNewTasks) { 
            
            if(thisTask.whoId != null) {
                
                System.debug('whoIds thisTask.whoId: ' + thisTask.whoId);
                whoIds.add(thisTask.whoId);
            } 
        }
        
        existingStarTests = [Select Id, RecordTypeId, WhoId from Task Where WhoId in :whoIds and IsClosed = false and (RecordTypeId =  :util.STARTestMathTask Or RecordTypeId = :util.STARTestReadingTask )];
    
        for(Task thisTask:existingStarTests) {
            
            if(thisTask.RecordTypeId == util.STARTestMathTask) {
        
                existingStarMathTests.add(thisTask.WhoId);          
            }
            
            if(thisTask.RecordTypeId == util.STARTestReadingTask) {
                
                System.debug('STAR READING ADD thisTask.whoId: ' + thisTask.whoId);
                existingStarReadingTests.add(thisTask.WhoId);
            }
        }
    }

    // STAR TEST Validation
    
    public void starTestCreation() {
        
        for(Task thisTask:lstNewTasks) {
            
            //////////////////////////////////////////////
            //
            // Only certain profiles can create STAR Tests and only if
            // there is not an open STAR test task
            //
            ///////////////////////////////////////////////////
            if(!thisTask.SkipRestrictions__c && !thisTask.Automatically_Generated__c) {
            
                
                if(thisTask.RecordTypeId == util.STARTestMathTask || thisTask.RecordTypeId == util.STARTestReadingTask) {
                    
                    // These are the profiles that can create these tasks
                
                    if(UserInfo.getProfileId() == util.educationLiaisonStaff ||
                        UserInfo.getProfileId() == util.educationLiaisonSupervisor ||
                        UserInfo.getProfileId() == util.educationInternalStaff ||
                        UserInfo.getProfileId() == util.educationInternalSupervisor||
                        // added 7/30/15 pr
                        UserInfo.getProfileId() == util.cepIcdStaff ||
                        UserInfo.getProfileId() == util.cepIcdSupervisor ||                        
                        UserInfo.getProfileId() == util.caseCoordinatorStaff ||
                        // Next line added 8/27/12 by MB to comply with specs
                        UserInfo.getProfileId() == util.cepDeputyDirector||
                        UserInfo.getProfileId() == util.cepDirector ||
                        UserInfo.getProfileId() == util.systemAdmin
                    ) {
                           
                        Boolean createTask = true;
                        System.debug('thisTask.RecordTypeId: ' + thisTask.RecordTypeId);
                        System.debug('util.STARTestMathTask: ' + util.STARTestMathTask);
                        System.debug('thisTask.whoId: ' + thisTask.whoId);
                        System.debug('existingStarReadingTests.contains(thisTask.whoId): ' + existingStarReadingTests.contains(thisTask.whoId));
                        
                        if(thisTask.RecordTypeId == util.STARTestReadingTask && existingStarReadingTests.contains(thisTask.whoId)) {
                            
                            thisTask.addError('There is already a STAR Reading test for this client');
                            createTask = false;
                        }
                        
                        if(thisTask.RecordTypeId == util.STARTestMathTask  && existingStarMathTests.contains(thisTask.whoId)) {
                            
                            thisTask.addError('There is already a STAR Math test for this client');
                            createTask = false;
                        }
                        
                        if(createTask) {
                        
                            thisTask.Open_Date__c = System.Today();
                            thisTask.ActivityDate = System.Today().addDays(29);
                            thisTask.Verification_Date__c = System.Today().addDays(29);
                        
                        }
                    } else {
                        
                        //// Attach an error and cancel the save
                        
                        thisTask.addError('You cannot create this kind of task');
                        
                    }   
                }   
            }
        }
    }
    
    ////////////////////////////////////////////////////////
    // Validation on task update
    //////////////////////////////////////////////////////
    
    public void areEditsAcceptable() {
        
        Integer i = 0;
        
        Set <Id> ownerId = new Set<id>();
        
        
        for(Task thisTask:lstNewTasks) {
            
            ownerId.add(thisTask.ownerId);
        }
        
        //Map<Id, User> ownerToManager = new Map<Id,User>([Select Id, Name, managerId from user where Id in :ownerId]);
        Map<Id, User> ownerToManager = new Map<Id,User>([Select Id, Name, managerId from user where IsActive = true]);
        
        System.Debug('\n\n\n MAPOWNERTOMANAGER DUMP = ' + ownerToManager);
        
        for(Task thisTask:lstNewTasks) {
            
            if(userInfo.getProfileId() != util.systemAdmin &&
                thisTask.SkipRestrictions__c == false
                ) { // Let the SYS admin do anything
                
                
                /////////////////////////////////////////////
                // PS Note Logic
                /////////////////////////////////////////////
                
                if( thisTask.RecordTypeId == util.psCRSNoteTask || 
                    thisTask.RecordTypeId == util.psProgressNoteTask) {
                        
                        
                    ////////////////////////////////////////////////////////
                    // Status
                    ////////////////////////////////////////////////////////
                
                    if(thisTask.Status != lstOldTasks[i].Status ) {
                    //&& thisTask.RecordTypeId == util.psCRSNoteTask - Removed from line above by MB 8/27/12 to comply with specs    
                            
                            //if( UserInfo.getUserId()  == ownerToManager.get(UserInfo.getUserId()).managerId  ||
                            //removed 9/6/12 by MB. This line incorrectly evaluates if the current user is the current user's manager. 
                            //It should ask if the current user is the manager of the task owner.
                            
                            // 2/15/13 MB: Manager of manager now included wherever manager is
                            if( UserInfo.getUserId()  == ownerToManager.get(thisTask.OwnerId).managerId  ||  
                                UserInfo.getUserId()  == ownerToManager.get(ownerToManager.get(thisTask.OwnerId).managerId).managerId ||                        
                                userInfo.getProfileId() == util.cepDeputyDirector ||
                                userInfo.getProfileId() == util.cepDirector ) {
                                    
                            } 
                            // 11/21/12 MB: Allow changes if owner of the task is a unit supervisor
                            else if(UserInfo.getUserId() == thisTask.OwnerId 
                            && (UserInfo.getProfileId() == util.substanceAbuseSupervisor  
                            || UserInfo.getProfileId() == util.mentalHealthSupervisor
                            || UserInfo.getProfileId() == util.cepIcdSupervisor
                            || UserInfo.getProfileId() == util.employmentSupervisor
                            || UserInfo.getProfileId() == util.educationInternalSupervisor
                            || UserInfo.getProfileId() == util.educationLiaisonSupervisor)) {
                                
                            }
                            
                            else {
                                
                                thisTask.Status.addError('You cannot change the Status');    
                            }
                
                    }   
                        
                    ////////////////////////////////////////////////////////
                    // Rejected reason
                    ////////////////////////////////////////////////////////
                
                    if(thisTask.Reject_Reason__c != lstOldTasks[i].Reject_Reason__c ) {
                                
                        if( UserInfo.getUserId()  == ownerToManager.get(thisTask.OwnerId).managerId  ||
                            UserInfo.getUserId()  == ownerToManager.get(ownerToManager.get(thisTask.OwnerId).managerId).managerId || 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ) {
                                
                                
                        } else {
                                
                            thisTask.Status.addError('You cannot change the Rejected Reason');
                                
                        }
                                    
                    }       
                        
                        
                    ////////////////////////////////////////////////////////
                    //
                    // Comments
                    //
                    ////////////////////////////////////////////////////////
                
                    if(thisTask.Description != lstOldTasks[i].Description ) {
                                
                        if( thisTask.OwnerId == UserInfo.getUserId() ||
                            UserInfo.getUserId()  == ownerToManager.get(thisTask.OwnerId).managerId  ||
                            UserInfo.getUserId()  == ownerToManager.get(ownerToManager.get(thisTask.OwnerId).managerId).managerId || 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ) {
                                
                                
                        } else {
                            
                            thisTask.Status.addError('You cannot change the comments');
                                
                        }
                                    
                    }           
                        
                        
                    ////////////////////////////////////////////////////////
                    //
                    // Owner Id
                    //
                    ////////////////////////////////////////////////////////
                    
                    system.debug('\n\n\n **** - Checking for Managerial clearance.  \n\n  Task Owner');
                    
                
                    if(thisTask.ownerId != lstOldTasks[i].ownerId ) {

                        if( thisTask.OwnerId == UserInfo.getUserId() ||
                            UserInfo.getUserId()  == ownerToManager.get(thisTask.ownerId).managerId  ||
                            UserInfo.getUserId()  == ownerToManager.get(ownerToManager.get(thisTask.OwnerId).managerId).managerId || 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector                                                      
                            ) {

                                                                
                        } else {
                                
                            thisTask.Status.addError('You cannot change the owner');
                                
                        }
                    }                   
                }
                
                //////////////////////////////
                // End of PS Notes
                //////////////////////////////

                
                ////////////////////////////////////////////////////////
                // Due Date
                ////////////////////////////////////////////////////////
                
                if(thisTask.ActivityDate != lstOldTasks[i].ActivityDate) {
                    
                    if( userInfo.getProfileId() == util.cepDeputyDirector ||
                    userInfo.getProfileId() == util.cepDirector ||
                    userInfo.getProfileId() == util.cjcJsAdmin ||
                    userInfo.getProfileId() == util.qjcAdmin ) {
                        // do nothing        
                    } 
                    
                    else if(thisTask.RecordTypeId == util.rearrestCheckTask ) {
                        //do nothing
                    }
                    
                    else if(thisTask.RecordTypeId == util.mentalHealthAssessmentTask
                    && userInfo.getProfileId() == util.mentalHealthSupervisor ) {
                        //do nothing
                    }                    
                    
                    else {
                        
                        thisTask.ActivityDate.addError('You cannot change the Due Date');
                    }                
                    
                }
                ////////////////////////////////////////////////////////
                // Contact
                ////////////////////////////////////////////////////////
            
                if(thisTask.WhoId != lstOldTasks[i].WhoId) {
                
                    if( thisTask.RecordTypeId == util.careerExplorationReferralTask) {
                        // do nothing
                    }
                        
                    else {
                        
                        thisTask.WhoId.addError('You cannot change the contact');                       
                    }  
                }   
                
                ////////////////////////////////////////////////////////
                // Rejected Reason
                ////////////////////////////////////////////////////////
                
                if(thisTask.Reject_Reason__c != lstOldTasks[i].Reject_Reason__c) {
                    
                    if(thisTask.RecordTypeId == util.ccCRSNoteTask) {
                        
                        if( thisTask.LastModifiedById == thisTask.CEP_Contact_Team_Director_Id__c ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {
                            
                            thisTask.Reject_Reason__c.addError('You cannot change the Reject Reason');
                        }
                    }                       
                    
                    if(thisTask.RecordTypeId == util.educationAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.educationLiaisonSupervisor ||
                            userInfo.getProfileId() == util.educationInternalSupervisor ||
                            UserInfo.getProfileId() == util.cepIcdSupervisor ||                                                   
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ) {
                                
                                
                            } else {
                                
                                thisTask.Status.addError('You cannot change the Rejected Reason');
                            }
                    }
                    
                    if(thisTask.RecordTypeId == util.employmentAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ) {
                                
                                
                            } else {
                                
                                thisTask.Status.addError('You cannot change the Rejected Reason');
                            }
                    }
                    
                    // added 3/17/13 MB
                    if(thisTask.RecordTypeId == util.alumniSurveyTask) {
                        
                        if( userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.educationInternalSupervisor ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                            
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cjcJsAdmin ||
                            userInfo.getProfileId() == util.qjcAdmin) {
                                
                                
                            } else {
                                
                                thisTask.Status.addError('You cannot change the Rejected Reason');
                            }
                    }  
                    
                    // added 5/20/13 MB
                    if(thisTask.RecordTypeId == util.incidentReportNoteTask) {
                        
                        // managers added 8/3/13 MB to allow manual rejection
                        if( UserInfo.getUserId()  != ownerToManager.get(thisTask.ownerId).managerId  &&
                            UserInfo.getUserId()  != ownerToManager.get(ownerToManager.get(thisTask.OwnerId).managerId).managerId && 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cjcJsAdmin ||
                            userInfo.getProfileId() == util.qjcAdmin) {
                                
                                
                            } else {
                                
                                thisTask.Status.addError('You cannot change the Rejected Reason');
                            }
                    }                             
                    
                }
                
                ////////////////////////////////////////////////////////
                // Status
                ////////////////////////////////////////////////////////
                
                if(thisTask.Status != lstOldTasks[i].Status) {
                
                    if( thisTask.RecordTypeId == util.ccProgressNoteTask ||
                        thisTask.RecordTypeId == util.MAYSIAssessmentTask ||
                        thisTask.RecordTypeId == util.PHQ9Task ||
                        thisTask.RecordTypeId == util.UCLATask || 
                        thisTask.RecordTypeId == util.LSCMITask ||                           
                        thisTask.RecordTypeId == util.STARTestMathTask ||
                        thisTask.RecordTypeId == util.CBOPlacementTask ||
                        thisTask.RecordTypeId == util.STARTestReadingTask ||
                        thisTask.RecordTypeId == util.initialDrugTestTask ||
                        thisTask.RecordTypeId == util.substanceAbuseAssessmenTask ||
                        thisTask.RecordTypeId == util.initialProgramPlanTask ||
                        thisTask.RecordTypeId == util.nextDrugTestTask ||
                        thisTask.RecordTypeId == util.exitNotificationTask ||
                        thisTask.RecordTypeId == util.caseCoordinatorAssessmentTask ||
                        thisTask.RecordTypeId == util.employmentSurveyTask
                        
                        ) {
                            
                            // Added 20120202 AAB BT-298 - allow Director / Deputy to do this
                            if(userInfo.getProfileId() != util.cepDeputyDirector &&
                                userInfo.getProfileId() != util.cepDirector) {
                                
                                thisTask.Status.addError('You cannot change the Status');
                                
                            }
                        
                        
                        
                    }   
                    
                    ////////////////////////////////////////////////////
                    // Incident Report Note
                    ////////////////////////////////////////////////////                    
                    if( thisTask.RecordTypeId == util.incidentReportNoteTask) {
                         
                        // managers added 8/3/13 MB to allow manual rejection        
                        if(UserInfo.getUserId()  != ownerToManager.get(thisTask.ownerId).managerId  &&
                           UserInfo.getUserId()  != ownerToManager.get(ownerToManager.get(thisTask.OwnerId).managerId).managerId &&
                           userInfo.getProfileId() != util.cepDeputyDirector &&
                           userInfo.getProfileId() != util.cepDirector &&
                           userInfo.getProfileId() != util.cjcJsAdmin &&
                           userInfo.getProfileId() != util.qjcAdmin) {
                                
                                thisTask.Status.addError('You cannot change the Status');
                                
                        }      
                    }                              
                    
                    ////////////////////////////////////////////////////
                    // Education Assessment
                    ///////////////////////////////////////////////////////
                    
                    if(thisTask.RecordTypeId == util.educationAssessmentTask) {
                            
                            if( userInfo.getProfileId() != util.educationLiaisonSupervisor &&
                            userInfo.getProfileId() != util.educationInternalSupervisor &&
                            userInfo.getProfileId() != util.cepIcdSupervisor &&                                                                                    
                            userInfo.getProfileId() != util.cepDeputyDirector &&
                            userInfo.getProfileId() != util.cepDirector ) {
                              
                                thisTask.Status.addError('You cannot change the Status');
                            
                            } 
                    } 
                
                
                    ////////////////////////////////////////////////////
                    // School Visit
                    ///////////////////////////////////////////////////////
                        
                    if(thisTask.RecordTypeId == util.schoolVisitTask) {
                        
                        if( userInfo.getProfileId() != util.educationLiaisonSupervisor &&
                        userInfo.getProfileId() != util.educationLiaisonStaff &&
                        //added 7/30/15 pr
                        userInfo.getProfileId() != util.cepIcdStaff &&
                        userInfo.getProfileId() != util.cepIcdSupervisor &&                                                                             
                        userInfo.getProfileId() != util.caseCoordinatorStaff &&
                        userInfo.getProfileId() != util.cepDeputyDirector &&
                        userInfo.getProfileId() != util.cepDirector ) { 
    
                            thisTask.Status.addError('You cannot change the Status');
                        
                        } 
                    } 
                    
                    ////////////////////////////////////////////////////
                    //Employment Assessment
                    ///////////////////////////////////////////////////////
                        
                    if(thisTask.RecordTypeId == util.employmentAssessmentTask) {
                            
                            if( userInfo.getProfileId() != util.employmentSupervisor &&
                            userInfo.getProfileId() != util.cepIcdSupervisor &&                                                        
                            userInfo.getProfileId() != util.cepDeputyDirector &&
                            userInfo.getProfileId() != util.cepDirector ) {
                                
                                thisTask.Status.addError('You cannot change the Status');
                            
                            }
                    }
                    
                    ////////////////////////////////////////////////////
                    //MH Assessment
                    ///////////////////////////////////////////////////////
                        
                    if(thisTask.RecordTypeId == util.mentalHealthAssessmentTask) {
                            
                            if( userInfo.getProfileId() != util.mentalHealthSupervisor &&
                            userInfo.getProfileId() != util.cepDeputyDirector &&
                            userInfo.getProfileId() != util.cepDirector ) {
                                
                                thisTask.Status.addError('You cannot change the Status');
                            
                            }
                    }                   
                    
                    ////////////////////////////////////////////////////////
                    // Exit Drug Test
                    /////////////////////////////////////////////////////////
                    
                    if(thisTask.RecordTypeId == util.exitDrugTestTask) {
                            
                            if( userInfo.getProfileId() != util.substanceAbuseStaff &&
                            userInfo.getProfileId() != util.substanceAbuseSupervisor &&
                            userInfo.getProfileId() != util.cepDeputyDirector &&
                            userInfo.getProfileId() != util.cepDirector ) {
                            
                                thisTask.Description.addError('You cannot change the Status');
                            }
                        } 
    
                    ////////////////////////////////////////////////////////
                    // Alumni Survey
                    /////////////////////////////////////////////////////////
                    
                    if(thisTask.RecordTypeId == util.alumniSurveyTask) {
                            
                        if( userInfo.getProfileId() != util.employmentSupervisor &&
                        userInfo.getProfileId() != util.educationInternalSupervisor &&
                        userInfo.getProfileId() != util.cepIcdSupervisor &&                                                    
                        userInfo.getProfileId() != util.cepDeputyDirector &&
                        userInfo.getProfileId() != util.cepDirector &&
                        userInfo.getProfileId() != util.cjcJsAdmin &&
                        userInfo.getProfileId() != util.qjcAdmin ) {                      
                            
                            thisTask.Status.addError('You cannot change the Status');
                        }     
                    }
                    
                    ////////////////////////////////////////////////////////
                    // CC CRS Note Task
                    /////////////////////////////////////////////////////////                
                    
                    if( thisTask.RecordTypeId == util.ccCRSNoteTask) {
      
                        if( UserInfo.getUserId()  != ownerToManager.get(thisTask.OwnerId).managerId  &&
                        UserInfo.getUserId()  != ownerToManager.get(ownerToManager.get(thisTask.OwnerId).managerId).managerId && 
                        userInfo.getProfileId() != util.cepDeputyDirector &&
                        userInfo.getProfileId() != util.cepDirector ) {
                                  
                            thisTask.Status.addError('You cannot change the Status');
                            
                        } 
                    }    
    
                    ////////////////////////////////////////////////////////
                    // Career Ex Referral
                    /////////////////////////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.careerExplorationReferralTask) {
                    
                        if( userInfo.getProfileId() != util.employmentStaff &&
                        //added 7/30/15 pr
                        userInfo.getProfileId() != util.cepIcdStaff &&
                        userInfo.getProfileId() != util.employmentSupervisor &&
                        userInfo.getProfileId() != util.cepIcdSupervisor &&                                                    
                        userInfo.getProfileId() != util.cepDeputyDirector &&
                        userInfo.getProfileId() != util.cepDirector ) {
                            
                            thisTask.Status.addError('You cannot change the Status');                              
                        }            
                    }
                }                           
                
                ////////////////////////////////////////////////////////
                // Owner
                ////////////////////////////////////////////////////////
                
                system.debug('\n\n***Checking Owner Change.  Old Owner: ' + lstOldTasks[i].ownerId 
                + '   New Owner: ' + thisTask.ownerId);
                
                if(thisTask.ownerId != lstOldTasks[i].ownerId) {
                    
                    if( thisTask.RecordTypeId == util.ccProgressNoteTask || 
                    thisTask.RecordTypeId == util.ccCRSNoteTask ||
                    thisTask.RecordTypeId == util.MAYSIAssessmentTask ||
                    thisTask.RecordTypeId == util.PHQ9Task ||
                    thisTask.RecordTypeId == util.UCLATask ||  
                    thisTask.RecordTypeId == util.LSCMITask ||                    
                    thisTask.RecordTypeId == util.CBOPlacementTask ||
                    thisTask.RecordTypeId == util.initialProgramPlanTask ||
                    thisTask.RecordTypeId == util.exitNotificationTask ||
                    thisTask.RecordTypeId == util.caseCoordinatorAssessmentTask) {
                    

                        if( userInfo.getProfileId() == util.caseCoordinatorStaff || 
                        userInfo.getProfileId() == util.cepDeputyDirector ||
                        userInfo.getProfileId() == util.cepDirector) {
                                   
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                    }                                   
                    
                    ///////////////////////////////////////
                    // Substance abuse assessment
                    ///////////////////////////////////////
                    
                    if(thisTask.RecordTypeId == util.substanceAbuseAssessmenTask ) {
                        
                        if( userInfo.getProfileId() == util.substanceAbuseSupervisor || 
                            userInfo.getProfileId() == util.substanceAbuseStaff ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }
                        
                        
                    ///////////////////////////////////////
                    // School visit
                    ///////////////////////////////////////
                    
                    if(thisTask.RecordTypeId == util.schoolVisitTask ) {
                        
                        if( userInfo.getProfileId() == util.educationLiaisonSupervisor || 
                            userInfo.getProfileId() == util.educationLiaisonStaff ||
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                                                     
                            userInfo.getProfileId() == util.caseCoordinatorStaff ||
                            userInfo.getProfileId() == util.caseCoordinatorStaff ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }
                    
                    ///////////////////////////////////////
                    // STAR TESTS
                    ///////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.STARTestMathTask  ||
                        thisTask.RecordTypeId == util.STARTestReadingTask) {
                        
                        if( userInfo.getProfileId() == util.educationLiaisonSupervisor ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                    
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    } 
                        
                    ///////////////////////////////////////
                    // DRUG TESTS
                    ///////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.initialDrugTestTask ||
                        thisTask.RecordTypeId == util.exitDrugTestTask) {
                        
                        if( userInfo.getProfileId() == util.substanceAbuseStaff ||
                            userInfo.getProfileId() == util.substanceAbuseSupervisor||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    } 
                        
                    ///////////////////////////////////////
                    // Next Drug Test
                    ///////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.nextDrugTestTask) {
                        
                        // BT-298 Adding Director / Deputy Director to permission list
                        
                        if( userInfo.getProfileId() == util.substanceAbuseSupervisor ||
                            userInfo.getProfileId() == util.cepDirector || 
                            userInfo.getProfileId() == util.cepDeputyDirector) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    } 
        
                    ///////////////////////////////////////
                    // Education Assessment Task
                    ///////////////////////////////////////
                    
                    if(thisTask.RecordTypeId ==  util.educationAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.educationLiaisonStaff ||
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff || 
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                                                
                            userInfo.getProfileId() == util.educationLiaisonSupervisor ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cepDeputyDirector ) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }
    
                    ///////////////////////////////////////
                    // Employment assessment
                    ///////////////////////////////////////
                     
                    if(thisTask.RecordTypeId == util.employmentAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.employmentStaff ||
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff || 
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                                               
                            userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cepDeputyDirector ) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }
                        
                    ///////////////////////////////////////
                    // Employment Survey
                    ///////////////////////////////////////
                     
                    if(thisTask.RecordTypeId == util.employmentSurveyTask) {
                        
                        if( 
                            //userInfo.getProfileId() == util.adminSupportStaff ||
                            //userInfo.getProfileId() == util.adminSupportSupervisor ||
                            //removed 9/10/12 by MB to comply with specs
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                        
                            userInfo.getProfileId() == util.employmentStaff ||
                            userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cepDeputyDirector ) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }
                    
                    ///////////////////////////////////////
                    // Mental Health
                    ///////////////////////////////////////
                     
                    if(thisTask.RecordTypeId == util.mentalHealthAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.mentalHealthSupervisor ||
                            csApexDefaults.Users_Authorized_to_Reassign_MH_Tasks__c.contains(userInfo.getUserId())) {
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }
                    
                    ///////////////////////////////////////
                    // Mandatory Classes
                    ///////////////////////////////////////
                     
                    if(thisTask.RecordTypeId == util.mandatoryClassesTask) {
                        
                        if( userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.adminSupportStaff ||
                            userInfo.getProfileId() == util.adminSupportSupervisor ||
                            userInfo.getProfileId() == util.caseCoordinatorStaff ) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }
                        
                    ///////////////////////////////////////
                    // Career Ex Referral
                    ///////////////////////////////////////
                     
                    if(thisTask.RecordTypeId == util.careerExplorationReferralTask) {
                        
                        if( userInfo.getProfileId() == util.systemAdmin ) {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }       
                    
                    ///////////////////////////////////////
                    // Re-arrest check
                    ///////////////////////////////////////
                     
                    if(thisTask.RecordTypeId == util.rearrestCheckTask) {
                        
                        if( userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.adminSupportStaff ||
                            userInfo.getProfileId() == util.strategicPlanning ||
                            userInfo.getProfileId() == util.adminSupportSupervisor )  {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }  
    
                    ///////////////////////////////////////
                    // Alumni Survey
                    ///////////////////////////////////////                    
                    if(thisTask.RecordTypeId == util.alumniSurveyTask) {
                        
                        if( userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.educationInternalSupervisor ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                        
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cjcJsAdmin ||
                            userInfo.getProfileId() == util.qjcAdmin)  {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }   
    
                    ///////////////////////////////////////
                    // Incident Report Note
                    ///////////////////////////////////////
                        
                    if(thisTask.RecordTypeId == util.incidentReportNoteTask) {
                        
                        if( userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cjcJsAdmin ||
                            userInfo.getProfileId() == util.qjcAdmin)  {
                            
                            
                        } else {    
                        
                            thisTask.ownerId.addError('You cannot change the Owner');
                        }
                        
                    }                       
                                                                      
                }   
                
                ////////////////////////////////////////////////////////
                // Comments
                ////////////////////////////////////////////////////////
                
                if(thisTask.Description != lstOldTasks[i].Description) {
                    
                    /////////////////////////////////////////////
                    // Employment Assessment
                    /////////////////////////////////////////////
                    
                    if(thisTask.RecordTypeId ==  util.employmentAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.caseCoordinatorStaff ||
                            userInfo.getProfileId() == util.employmentStaff ||
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                        
                            userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                        
                        
                    }
                    
                    /////////////////////////////////////////////
                    //
                    // Employment Survey
                    //
                    /////////////////////////////////////////////
                    
                    if(thisTask.RecordTypeId == util.employmentSurveyTask) {
                        
                        if( userInfo.getProfileId() == util.adminSupportStaff ||
                            userInfo.getProfileId() == util.adminSupportSupervisor ||
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff ||                            
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                        
                            userInfo.getProfileId() == util.employmentStaff ||
                            userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cepDeputyDirector ) {
                            
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                    
                    }
                    /////////////////////////////////////////////
                    //
                    // Education Assessment
                    //
                    /////////////////////////////////////////////
                    
                    if(thisTask.RecordTypeId ==  util.educationAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.caseCoordinatorStaff ||
                            userInfo.getProfileId() == util.educationInternalStaff ||
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff || 
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                                                    
                            userInfo.getProfileId() == util.educationInternalSupervisor ||
                            userInfo.getProfileId() == util.educationLiaisonStaff ||
                            userInfo.getProfileId() == util.educationLiaisonSupervisor ||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                        
                        
                    }
                    
                    /////////////////////////////////////////////
                    //
                    // Substance Abuse Assessment
                    //
                    /////////////////////////////////////////////
                    
                    if(thisTask.RecordTypeId == util.substanceAbuseAssessmenTask ) {
                        
                        if( userInfo.getProfileId() == util.substanceAbuseStaff ||
                            userInfo.getProfileId() == util.substanceAbuseSupervisor||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                    }
                    
                    /////////////////////////////////////////////
                    //
                    // Exit notification task
                    //
                    /////////////////////////////////////////////
                    if(thisTask.RecordTypeId == util.exitNotificationTask) {
                    

                        if( userInfo.getProfileId() == util.adminSupportStaff ||
                            userInfo.getProfileId() == util.adminSupportSupervisor ||
                            userInfo.getProfileId() == util.caseCoordinatorStaff || 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                    }   
                    /////////////////////////////////////////////
                    //
                    // CCpn,CRSpn,InitProgramPlan,MAYSI,CaseCoordinator Assessment
                    //
                    /////////////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.ccProgressNoteTask || 
                        thisTask.RecordTypeId == util.ccCRSNoteTask ||
                        thisTask.RecordTypeId == util.CBOPlacementTask ||
                        thisTask.RecordTypeId == util.initialProgramPlanTask ||
                        thisTask.RecordTypeId == util.MAYSIAssessmentTask ||
                        thisTask.RecordTypeId == util.PHQ9Task ||
                        thisTask.RecordTypeId == util.UCLATask || 
                        thisTask.RecordTypeId == util.LSCMITask ||                         
                        thisTask.RecordTypeId == util.caseCoordinatorAssessmentTask) {
                    

                        if( userInfo.getProfileId() == util.caseCoordinatorStaff || 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                    }   
                    
                    /////////////////////////////////////////////
                    //
                    // Star TESTS
                    //
                    /////////////////////////////////////////////
                    if( thisTask.RecordTypeId == util.STARTestMathTask  ||
                        thisTask.RecordTypeId == util.STARTestReadingTask) {
                        
                        if( userInfo.getProfileId() == util.caseCoordinatorStaff || 
                            userInfo.getProfileId() == util.educationLiaisonSupervisor ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                        
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.educationLiaisonStaff ||
                            //added 7/30/15 pr
                            userInfo.getProfileId() == util.cepIcdStaff ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                                                     
                            userInfo.getProfileId() == util.educationInternalStaff||
                            userInfo.getProfileId() == util.educationInternalSupervisor) {
                            
                            
                        } else {    
                        
                            thisTask.Description.addError('You cannot change the comments');
                        }
                        
                    } 
                    
                    /////////////////////////////////////////////
                    //
                    // Drug Tests
                    //
                    /////////////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.initialDrugTestTask ||
                        thisTask.RecordTypeId == util.exitDrugTestTask) {
                        
                        if( userInfo.getProfileId() == util.substanceAbuseStaff ||
                            userInfo.getProfileId() == util.substanceAbuseSupervisor||
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {    
                        
                            thisTask.Description.addError('You cannot change the comments');
                        }
                    } 
                    
                    /////////////////////////////////////////////
                    //
                    // Next Drug Test
                    //
                    /////////////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.nextDrugTestTask) {
                        
                        if( userInfo.getProfileId() == util.substanceAbuseStaff ||
                            userInfo.getProfileId() == util.substanceAbuseSupervisor||
                            userInfo.getProfileId() == util.caseCoordinatorStaff || 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {    
                        
                            thisTask.Description.addError('You cannot change the comments');
                        }   
                    }
                    
                    /////////////////////////////////////////////
                    // Mental Health Assessment
                    /////////////////////////////////////////////
                    
                    if( thisTask.RecordTypeId == util.mentalHealthAssessmentTask) {
                        
                        if( userInfo.getProfileId() == util.mentalHealthStaff ||
                            userInfo.getProfileId() == util.mentalHealthSupervisor ||
                            userInfo.getProfileId() == util.caseCoordinatorStaff || 
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector) {
                            
                            
                        } else {    
                        
                            thisTask.Description.addError('You cannot change the comments');
                        }   
                    } 
                    
                    /////////////////////////////////////////////
                    // Alumni Survey
                    /////////////////////////////////////////////                    
                    
                    if(thisTask.RecordTypeId ==  util.alumniSurveyTask) {
                        
                        if( userInfo.getProfileId() == util.employmentSupervisor ||
                            userInfo.getProfileId() == util.educationInternalSupervisor ||
                            userInfo.getProfileId() == util.cepIcdSupervisor ||                                                        
                            userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cjcJsAdmin ||
                            userInfo.getProfileId() == util.qjcAdmin) {
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                        
                        
                    }      
                    
                    /////////////////////////////////////////////
                    // Incident Report Note
                    /////////////////////////////////////////////                    
                    
                    if(thisTask.RecordTypeId == util.incidentReportNoteTask) {
                        
                        if( userInfo.getProfileId() == util.cepDeputyDirector ||
                            userInfo.getProfileId() == util.cepDirector ||
                            userInfo.getProfileId() == util.cjcJsAdmin ||
                            userInfo.getProfileId() == util.qjcAdmin) {
                            
                            
                        } else {
                            
                            thisTask.Description.addError('You cannot change the comments');
                        }
                        
                        
                    }                                        
                                                                        
                }
                
            }                             

            // 1/16/14 MB moved this outside the "sys admin only" loop because it 
            // contains code that sets the closing date and closed by user

            ////////////////////////////////////////////////////////
            // Rearrest Task logic
            ////////////////////////////////////////////////////////
            
            if(thisTask.RecordTypeId == util.rearrestCheckTask) { 
                                 
                system.debug('calling rearrestCheckUpdateLogic');
                rearrestMeths.rearrestCheckUpdateLogic(thisTask, lstOldTasks[i]);
            }
                      
            i++;
        }   
    
    }
    
    /////////////////////////////////
    // Career Ex
    /////////////////////////////////
    /*public void checkForCareerExStage() {
        
        programStages clsProgramStages = new programStages();
        List<Task> lstTasksForStage = new List<Task>();
        
        // Create Map of old values
        Map<Id, Task> mapTaskOld = new Map<Id, Task>();
        for(Task t : lstOldTasks) {
            mapTaskOld.put(t.Id, t);
        }
        
        System.Debug('\n\n\n taskMethods.checkForCareerExStage INFO:  Testing START');
        
        // Compare old to new
        for(Task t : lstNewTasks) {
            
            System.Debug('\n\n\n taskMethods.checkForCareerExStage INFO:  Testing ' + t.Id + ' - ' + t.Status + ' = ' + mapTaskOld.get(t.Id).Status);
            
            if(t.Status == 'Incomplete' && mapTaskOld.get(t.Id).Status != 'Incomplete') {
                lstTasksForStage.add(t);
            }
        }
        
        // Submit list to Program Stage method if necessary
        if(lstTasksForStage.size() > 0) { clsProgramStages.createStageRecord(lstTasksForStage, null, null, null); }
        
    }*/
    
    
    public void modifyChoices30DayDetainedTask() {  
        
        list<Id> lstDetainedDateIds = new list<Id>();
        
        //find tasks in scope
        for(Task t: lstNewTasks) {
                
            lstDetainedDateIds.add(t.whatId);
        }
        
    
        Map<id, Detained_Dates__c> mapDetainedtoContact = new map<Id, Detained_Dates__c>([
            select id, Contact_Detained_Dates_Lookup__c, 
            Contact_Detained_Dates_Lookup__r.Case_Coordinator__c
            from Detained_Dates__c where id in :lstDetainedDateids]);
            
            
        for(Task t: lstNewTasks) {
            
            if(t.Subject == 'Choices Temp Exit Notification') {
                            
                t.subject = 'Exit Notification';            
                t.ActivityDate = system.today().addDays(3);
                t.Open_Date__c = system.today();
                t.RecordTypeId = util.exitNotificationTask;
                t.whoID = mapDetainedtoContact.get(t.whatId).Contact_Detained_Dates_Lookup__c;
                t.ownerId = mapDetainedtoContact.get(t.whatId).Contact_Detained_Dates_Lookup__r.Case_Coordinator__c;
                t.Automatically_Generated__c = true;
            }
        }   
        
    }
    
    public void modifyRearrestCheckTask() {     
        
        //for quarterly task- get fiscal year start month
        Integer FiscalYearStartMonthIndex = [select FiscalYearStartMonth
        from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        
        // find end of first quarter of current year
        Date dteQuarterEnd = system.today();
        date dteDue = system.today();   
        
        list<Id> getWhoIDs = new list<Id>();
                
        for(Task t: lstNewTasks) {
            
            getWhoIds.add(t.whoID);
        }
        
        Map<Id, Contact> mapClients = new map<Id, Contact>(
            [select Id, RecordTypeId from Contact where id in :getWhoIDs]);
            
        //list of rearrest check/ date combos for dupe check
        set<String> setDupeChecks = new set<String>();  
                    
        for(Task t: lstNewTasks) {
            
            if(t.Subject == 'Temp Quarterly Rearrest') {
                
                // find end of first quarter of last year
                dteQuarterEnd = Date.newInstance(system.today().addYears(-1).year(), 
                    FiscalYearStartMonthIndex, 1).addMonths(3).addDays(-1);
                
                // if we are past the current quarter, move to the next one.
                while (t.ActivityDate > dteQuarterEnd) {
                    dteQuarterEnd = dteQuarterEnd.addMonths(3);
                }       
                
                dteDue = dteQuarterEnd.addDays(8);              
                            
                t.RecordTypeId = util.rearrestCheckTask;
                t.Subject = 'Rearrest Check - Quarterly';
                //activity date is saved by the workflow as the contact's current exit date
                t.Open_Date__c = t.ActivityDate;
                t.ActivityDate = dteDue;
                setDupeChecks.add(t.whoId+';'+dteDue);
                t.Automatically_Generated__c = true;
                t.SkipRestrictions__c = true;
                if(mapClients.get(t.whoID).RecordTypeId == util.conClient) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CEP__c;
                } else if (mapClients.get(t.whoID).RecordTypeID == util.conCCM) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CCM__c;             
                } else if (mapClients.get(t.whoID).RecordTypeID == util.conACT) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_ACT__c;             
                } else if (mapClients.get(t.whoID).RecordTypeID == util.conDTC) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_DTC__c;             
                } else if (mapClients.get(t.whoID).RecordTypeID == util.conCRT) {
                    
                    t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CRT__c;             
                }
            } else if (t.Subject == 'Temp CCM Voluntary Rearrest') {
                
                t.RecordTypeId = util.rearrestCheckTask;
                t.Subject = 'Rearrest Check - 6 Months Post-Intake';
                //activity date is saved by the workflow as the contact's original intake date +14 days
                t.Open_Date__c = t.ActivityDate.addDays(-14);
                t.Automatically_Generated__c = true;
                t.SkipRestrictions__c = true;                           
            }
        }   
        
        // 10/2/14 MB this query was causing an Internal Salesforce Error when running the Quarterly Rearrest Check job
        // I believe this is because it is querying records which are in the BeforeInsert stage
        // Only run this logic if the subject "Temp Quarterly Rearrest Check" appears, indicating that this was fired from a workflow
        if(setDupeChecks.size() > 0) {  
        
          list<Task> lstTasksToCheck = [select id, whoId, ActivityDate from Task
            where Subject = 'Rearrest Check - Quarterly' and whoId in :getWhoIds];
            
          list<Task> lstTasksToDelete = new list<Task>();  
            
          for(Task t: lstTasksToCheck) {
            
            if(setDupeChecks.contains(t.whoId+';'+t.ActivityDate)) {
              
              lstTaskstoDelete.add(t);
            }
          }
          
          delete lstTasksToDelete;
          }        
    }
    
}