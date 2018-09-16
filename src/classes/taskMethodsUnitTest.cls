@isTest (seeAlldata=true)
private class taskMethodsUnitTest {

    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Contact con2 = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();

    static utilityMethods utilMethods = new utilityMethods();
    static utilityIds utilIds = new utilityIds();
    static Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
    
    static void initCore() {
    
        accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert accClient;
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2013TN456011';
        newCaseInfo.Borough__c = 'Bronx';
        insert newCaseInfo;        
        
        con = new Contact();
        con.firstName = 'Unit';
        con.lastName = 'Tester';
        con.Drug_test_frequency__c = 'Bi-Weekly';
        con.Referral_Date__c = system.today().addDays(-5);
        con.Eligible__c = 'Yes';
        con.Interview_Acceptance_Date__c = system.today().addDays(-3);
        con.Interview_Outcome__c = 'CEP Accepts';
        
        User adminUser = 
        [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
        
        con.Intake_Approved_By__c = adminUser.id;
 //       con.Intake_Approved_By__c = userInfo.getUserId();
        con.Intake_Date__c = System.Today();
        con.Intake_Case__c = newCaseInfo.id;
        con.RecordTypeId = utilIds.conClient;
        con.accountId = accClient.id;    
        
        //create a second contact so we can try changing it on a task
        con2 = new Contact();
        con2.lastName = 'Test';
        con2.Client_Status__c = 'Active';
        con2.RecordTypeId = utilIds.conCJC; 
        con2.AccountId = accClient.id;            
        
        insert new Contact[]{con, con2};
        

        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        insert thisEvent;                


    }

    static testMethod void taskMethodsUnitTest() {

        initCore();

        test.startTest();

        //get our different user types
        User userCepAdminSupportStaff = [Select Id, Username, ProfileId,Profile.Name from User 
                                where IsActive = true 
                                AND Id != :UserInfo.getUserId()
                                AND ProfileId = :utilIds.adminSupportSupervisor LIMIT 1];
        
        
        // 1/29/13 MB: This was set to deputy director but there is no one currently in this position,
        // so I am temporarily setting this to the CEP Director
        User userCepDeputyDirector = [Select Id, Username, ProfileId from User 
                                where IsActive = true 
                                AND Id != :UserInfo.getUserId()
                                AND Profile.Name = 'CEP - Deputy Director' LIMIT 1];
        
        List<Task> lstTasks = new List<Task>();
        Integer i = 0;
        
        Task t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.mentalHealthAssessmentTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + 'a: ' + e);
            
        }


        system.debug ('\n\n***Inserting mentalHealthAssessmentTask: ' + utilIds.mentalHealthAssessmentTask);
        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.mentalHealthAssessmentTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + 'b: ' + e);
            
        }


        system.debug ('\n\n***Inserting educationAssessmentTask: ' + utilIds.educationAssessmentTask);
        i=1;
        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.educationAssessmentTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + 'a: ' + e);
            
        }

        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.educationAssessmentTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + 'b: ' + e);
            
        }

        
        system.debug ('\n\n***Inserting employmentAssessmentTask: ' + utilIds.employmentAssessmentTask);
        i=2;
        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.employmentAssessmentTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + 'a: ' + e);
            
        }

        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.employmentAssessmentTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + 'b: ' + e);
            
        }

        
        system.debug ('\n\n***Inserting rearrestCheckTask: ' + utilIds.rearrestCheckTask);
        i=3;
        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.rearrestCheckTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);

        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + ': ' + e);
            
        }

        
        system.debug ('\n\n***Inserting STARTestMathTask: ' + utilIds.STARTestMathTask);
        i=4;
        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.STARTestMathTask ;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + ': ' + e);
            
        }

        
        system.debug ('\n\n***Inserting STARTestReadingTask: ' + utilIds.STARTestReadingTask);
        i=5;
        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.STARTestReadingTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + ': ' + e);
            
        }

        
        system.debug ('\n\n***Inserting psCRSNoteTask: ' + utilIds.psCRSNoteTask);
        i=6;
        t = new Task();
        t.OwnerId = userCepAdminSupportStaff.Id;
        t.WhoId = con.Id;
        t.ActivityDate = system.today();
        t.RecordTypeId = utilIds.psCRSNoteTask;
        t.Status = 'Not Started';
        t.Status__c = 'Not Started';
        t.Reject_Reason__c = 'First reason';        
        try {
            
            insert t;
            lstTasks.add(t);
            
        } catch (Exception e) {
            
            system.debug ('\n\n***Error inserting task ' + i + ': ' + e);
            
        }

        
        system.debug('\n\n***Inside taskMethodsUnitTest.  Inserted Tasks: ' + lstTasks);
        
        List<Task> lstTaskUpdates = [Select Id, OwnerId, RecordTypeId, Status, Status__c, Reject_Reason__c, ActivityDate, WhoId From Task where WhoId = :con.Id];
        
        
        i=0;
        system.debug('\n\n***Running as user ' + userCepAdminSupportStaff);
        
        for (Task tUpd : lstTaskUpdates) {
            system.runAs(userCepAdminSupportStaff) {
                
                system.debug('\n\n***Processing record ' + i + '.   Record type: ' + tUpd.RecordTypeId);

                //try changing the owner
                system.debug('\n\n***Attempting to change owner from ' + tUpd.OwnerId + ' to ' + UserInfo.getUserId());
                tUpd.OwnerId = UserInfo.getUserId();
                try {
                    update tUpd;
                } catch (Exception e) {
                    system.debug('\n\nError updating task ' + i + ': ' + e);
                }

                //try changing the contact
                system.debug('\n\nAttempting to change contact from ' + tUpd.WhoId + ' to ' + con2.Id);
                tUpd.WhoId = con2.Id;
                try {
                    update tUpd;
                } catch (Exception e) {
                    system.debug('\n\nError updating task ' + i + ': ' + e);
                }

                //try changing the description
                system.debug('\n\n***Attempting to update Description ' + i + ': ' + tUpd);
                tUpd.Description = 'changed value';
                try {
                    update tUpd;
                } catch (Exception e) {
                    system.debug('\n\nError updating task ' + i + ': ' + e);
                }

                //try changing the status
                system.debug('\n\n***Attempting to update Status ' + i + ': ' + tUpd);
                tUpd.Status = 'Rejected';
                tUpd.Reject_Reason__c = 'Second reason';
                try {
                    update tUpd;
                } catch (Exception e) {
                    system.debug('\n\nError updating task ' + i + ': ' + e);
                }
            }  //end of running as CEP user
                

            system.runAs(userCepDeputyDirector) {
                //if working with a STAR test, close it out and then create a new one.  Do all this as the CEP Deputy Director
                if (tUpd.RecordTypeId == utilIds.STARTestMathTask || tUpd.RecordTypeId == utilIds.STARTestReadingTask) {
                    system.debug('\n\n***Attempting to update STARTestMathTask or STARTestReadingTask: ' + tUpd);
                    tUpd.Status = 'Completed';
                    try {
                        update tUpd;
                        system.debug('\n\n***Update succeeded.  Inserting new task');
                        t = new Task();
                        t.OwnerId = userCepDeputyDirector.Id;
                        t.WhoId = con.Id;
                        t.ActivityDate = system.today();
                        t.RecordTypeId = tUpd.RecordTypeId;
                        t.Status = 'Not Started';
                        t.Status__c = 'Not Started';
                        try {
                            
                            insert t;
                            lstTasks.add(t);
                            
                        } catch (Exception e) {
                            
                            system.debug ('\n\n***Error inserting task ' + i + ': ' + e);
                            
                        }
                    } catch (Exception e) {
                        system.debug('\n\nError updating task ' + i + ': ' + e);
                    }
                    
                }
            }  //end RunAs deputy director
                            
            i++;
        }
        
        test.stopTest();
        
    }
  /*  
    static testMethod void testSchoolVisitTask() {
        
        ///////////////////////////////////////////////////////
        // Stage Data 
        ///////////////////////////////////////////////////////
        
        initCore();
        
        test.startTest();
        
        Account newSchool = new Account();
        newSchool.Name = 'School';
        insert newSchool;        
            
        // event/ task data     
        Task schoolVisitTask = new Task();
        schoolVisitTask.RecordTypeId = utilIds.schoolVisitTask;
        schoolVisitTask.Subject = 'Ed Program Visit Request';
        schoolVisitTask.whoId = con.Id;
        schoolVisitTask.OwnerId = csApexDefaults.education_Liaison_Staff__c;
        schoolVisitTask.WhatId = newSchool.Id;
        insert schoolVisitTask;
        
        Event schoolVisitAppt = new Event();
        schoolVisitAppt.RecordTypeId = utilIds.educationExternal;
        schoolVisitAppt.Subject = 'Ed Program Visit';
        schoolVisitAppt.whoId = con.Id;
        schoolVisitAppt.OwnerId = UserInfo.getUserId();
        schoolVisitAppt.WhatId = newSchool.Id;
        schoolVisitAppt.ActivityDate = system.Today();
        schoolVisitAppt.ActivityDateTime = system.Now().addMinutes(-2);
        schoolVisitAppt.DurationInMinutes = 60;     
        schoolVisitAppt.Verification_Status__c = 'Attended';
        insert schoolVisitAppt;
        
        Task verifyTask = [select id, IsClosed from Task where Id = :schoolVisitTask.Id];
        system.assert(verifyTask.isClosed); 
    
    
        test.stopTest();
    }    
    */
    private static void testAreEditsAcceptablebyUser(User runAsUser) {  
        
        //stage data      
        initCore();
        
        list<Event> lstEventsforInsert = new List<Event>();
        
        // create court date to generate progress notes
        Event evtCourtDate = new Event();
        evtCourtDate.whoId = con.Id;
        evtCourtDate.RecordTypeId = utilIds.courtDate;
        evtCourtDate.ActivityDate = System.Today().addDays(15);
        evtCourtDate.ActivityDateTime = System.Now().addDays(15);
        evtCourtDate.whatId = newCaseInfo.Id;
        evtCourtDate.DurationInMinutes = 60;
        lstEventsforInsert.add(evtCourtDate);
        
        //generate progress note
        Event evtForPN = new Event();
        evtForPN.Subject = 'Family Work';
        evtForPN.recordTypeId = utilIds.caseCoordination;
        evtForPN.whoId = con.Id;
        evtForPN.ownerId = runAsUser.Id;
        evtForPN.ActivityDate = System.Today();
        evtForPN.ActivityDateTime = System.now();
        evtForPN.DurationinMinutes = 60;
        evtForPN.Verification_Status__c = 'Attended';
        
        lstEventsforInsert.add(evtForPn);
        
        //generate progress note
        Event evtForPN2 = new Event();
        evtForPN2.Subject = 'Employment Counseling';
        evtForPN2.recordTypeId = utilIds.employmentInternal;
        evtForPN2.whoId = con.Id;
        evtForPN2.ownerId = csApexDefaults.employment_Supervisor__c;
        evtForPN2.ActivityDate = System.Today();
        evtForPN2.ActivityDateTime = System.now();
        evtForPN2.DurationinMinutes = 60;
        evtForPN2.Verification_Status__c = 'Attended';
        
        lstEventsforInsert.add(evtForPn2);  
        
        insert lstEventsforInsert;  
        
        Task schoolVisitTask = new Task();
        schoolVisitTask.RecordTypeId = utilIds.schoolVisitTask;
        schoolVisitTask.Subject = 'Ed Program Visit Request';
        schoolVisitTask.whoId = con.Id;
        schoolVisitTask.OwnerId = csApexDefaults.education_Liaison_Staff__c;
        insert schoolVisitTask;     
        
        //create dummy contact and user to change Task fields to
        User testUser = [select id from User where isActive = true limit 1];
        Contact testContact = [select id from Contact where recordtypeId = :utilIds.conCJC limit 1];
        
        test.startTest();
        
        //run as passed in user
        system.runAs(runAsUser) {
            
            //get a list of all tasks created by intake
            list<Task> lstTaskstoUpdate = [select id, Status, Description, Reject_Reason__c, ActivityDate, ownerId,
                                           whoId, Closing_Date__c from Task where whoId = :con.Id];
            
            //modify all the fields so we set off all the errors in TaskMethods
            for(Task t: lstTaskstoUpdate) {
                
                t.ownerId = testUser.Id;
                t.whoId = testContact.id;
                t.Reject_Reason__c = 'None of them along the line know what any of it is worth';
                t.Status = 'Done on Time';
                t.Description = 'All along the watchtower';
                t.ActivityDate = system.today().addDays(-10);               
            }
            try {
                database.update(lstTaskstoUpdate);
            } catch (Exception e) {
            
                system.debug ('\n\n***Error inserting tasks');      
            }
             
        }
        test.stopTest();   
        
    }
   
    static testMethod void runTasksasCourtStaff() {
        
                
        User runAsUser = [select id from User where profileID = :utilIds.courtStaff and isActive = true limit 1 ];
        
        testAreEditsAcceptablebyUser(runAsUser);
    }   
    
    static testMethod void runTasksasDirector() {
        
                
        User runAsUser = [select id from User where profileID = :utilIds.cepDirector and isActive = true limit 1 ];
        
        testAreEditsAcceptablebyUser(runAsUser);
    }   
    
    static testMethod void runTasksasCaseCoordinator() {
        
                
        User runAsUser = [select id from User where profileID = :utilIds.caseCoordinatorStaff and isActive = true limit 1 ];
        
        testAreEditsAcceptablebyUser(runAsUser);
    }   
    
    /*static testMethod void runTasksasEdInternalSupervisor() {
        
                
        User runAsUser = [select id from User where profileID = :utilIds.educationInternalSupervisor 
                          and isActive = true limit 1 ];
        
        testAreEditsAcceptablebyUser(runAsUser);
    }*/   
    
    static testMethod void runTasksasEmploymentSupervisor() {
        
                
        User runAsUser = [select id from User where profileID = :utilIds.cepIcdSupervisor 
                          and isActive = true limit 1 ];
        
        testAreEditsAcceptablebyUser(runAsUser);
    }   
    
}