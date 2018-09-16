public class utilityMethods {
    
    /////////////////////////////////////////////////////////////
    /// Global Record Type IDs
    /////////////////////////////////////////////////////////////
            
    // Added 20110307 AAB to aid in migrating Ids from this file
    public utilityIds utilIds = new utilityIds();
    public Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
    //public programPlanMethods ppMethods = new programPlanMethods();
    public List<Education__c> lstUpdatedEdu = new List<education__c>();
    public List<Test__c> lstUpdatedTest = new List<Test__c>();
     
    //////////////////////////////////////////
    //Acceptable subjects for rearrest tasks
    //List varies depending on if task was generated manually or automatically
    //////////////////////////////////////////
    
    public Set<String> rearrestManualSubjects = new Set<String>{
        'Rearrest Check - In-Program',
        'Rearrest Check - Post-Program'
    };

    public Set<String> rearrestAutoSubjects = new Set<String>{
        'Rearrest Check - Successful Exit',
        'Rearrest Check - 3-month Post-Grad',
        'Rearrest Check - Quarterly',
        'Rearrest Check - 1 Year Post-Intake',
        'Rearrest Check - 6 Months Post-Intake'
    };


    //////////////////////////////////////////
    /// Acceptable Subjects for events
    //////////////////////////////////////////

    //////////////////////////////////////////
    //Education Internal
    //////////////////////////////////////////
            
    public Set<String> educationInternalSubjects = new Set<String>{
        'Education Assessment',
        'Education Counseling',
        'Education Tutoring',
        'Family Work',
        'STAR Test',
        'TABE Test',
        'TASC Readiness Test',
        'GED Predictor Test',
        'HSE Program Participation',
        'TASC Test'       
  
    };
            
    //////////////////////////////////////////
    //Education External
    //////////////////////////////////////////
    
    public Set<String> educationExternalSubjects = new Set<String>{
        'College Participation',
        'Public School Participation',
        'GED Program Participation',
        'HSE Program Participation',
        'Literacy/ESL Program Participation', 
        'Ed Program Visit',
        'GED Predictor Test', 
        'GED Test',
        'TASC Test',
        'Education - General' 
    };
            
    //////////////////////////////////////////
    //Mental Health - Internal
    //////////////////////////////////////////
    
    public Set<String> mentalHealthInternalSubjects = new Set<String>{          
        'Art Therapy Counseling',
        'Social Worker Counseling', 
        'MH Consultation',
        'Crisis Intervention',
        'MH Internal Assessment',
        'Family Work',
        'Substance Abuse Counseling',
        'APT - Individual Session',
        'APT - Caregiver Session',
        'APT - Family Session'         
    };
            
    //////////////////////////////////////////
    //Mental Health - External 
    //////////////////////////////////////////
    
    public Set<String> mentalHealthExternalSubjects = new Set<String>{              
        'MH External Assessment',
        'MH Counseling',
        'Other Referral',
        'MH Counseling Referral', 
        'MH/SA Treatment Referral',
        'MH/SA Treatment',
        'Outpatient Program Referral',
        'Outpatient Program Treatment', 
        'Residential Program Referral', 
        'Short-Term Inpatient Rehab Participation', 
        'Short-Term Inpatient Rehab Referral'
       
    };
            
    //////////////////////////////////////////
    // Substance Abuse - Internal
    //////////////////////////////////////////
    
    public Set<String> substanceAbuseInternalSubjects = new Set<String>{            
        'Substance Abuse Assessment',
        'Substance Abuse Counseling',
        'Family Work',
        'Prevention Appointment'
    };
            
    //////////////////////////////////////////
    // Substance Abuse - External
    //////////////////////////////////////////
    
    public Set<String> substanceAbuseExternalSubjects = new Set<String>{            
        'Outpatient Program Referral',
        'Outpatient Program Treatment',
        'MH/SA Treatment Referral', 
        'MH/SA Treatment',
        'Short-Term Inpatient Rehab Referral',
        'Short-Term Inpatient Rehab Participation',
        'Residential Program Referral'
    };
            
    //////////////////////////////////////////
    // Case Coordination
    //////////////////////////////////////////
    
    public Set<String> caseCoordinationSubjects = new Set<String>{          
        'Home Visit',
        'Case Coordinator Counseling', 
        'Program Reporting', 
        'Family Conference', 
        'Family Work',
        'Participant Conference', 
        'Case Conference',
        'Return-to-Borough',
        'Attorney Contact',
        'Probation Supervision',
        'PSI Interview',
        'Curfew',
        'PEAK Intake',
        'PEAK Reinstatement',
        'JAG Pre-Intake',
        'Phone/Check-in'
    };
            
    //////////////////////////////////////////
    // Case Coordination - External
    //////////////////////////////////////////
    
    public Set<String> caseCoordinationExternalSubjects = new Set<String>{          
        'Other Youth Development Programming',
        'Program Reporting'
    };            
    
    //////////////////////////////////////////
    // Employment - Internal
    //////////////////////////////////////////
    
    public Set<String> employmentInternalSubjects = new Set<String>{                
        'Benefits Counseling', 
        'Employment Counseling',
        'Employment Assessment',
        'Career Exploration Interview',
        'Family Work',
        'DRIVE Makeup Session'
    };
            
    //////////////////////////////////////////
    // Employment ? External 
    //////////////////////////////////////////
    
    public Set<String> employmentExternalSubjects = new Set<String>{                
        'Benefits Advocacy',    
        'Job Referral',
        'Job Participation',
        'SYEP Participation', 
        'Job Readiness Referral',
        'Job Readiness', 
        'General Internship',
        'Community Service',
        'CE Internship Interview',
        'CE Internship Participation'
    };
    
    //////////////////////////////////////////
    // Case Coordination (JC) ? External 
    //////////////////////////////////////////
    
    public Set<String> caseCoordinationExternalJCSubjects = new Set<String>{   
        'Benefits Advocacy',
        'Court Date',       
        'Education - Offsite',      
        'Employment Training',
        'Housing Referral',     
        'Job Readiness',
        'Job Readiness Referral',
        'Job Participation',
        'Job Referral', 
        'Legal Consultation',           
        'Literacy/ESL Program Participation',       
        'MH Counseling',
        'MH Counseling Referral',
        'MH/SA Treatment',
        'MH/SA Treatment Referral',
        'Other Youth Development Programming',      
        'Outpatient Program Treatment',
        'Outpatient Program Referral',
        'Parole Supervision',
        'Probation Supervision'
    };  
    
    public Set<String> caseCoordinationCCMSubjects = new Set<String>{          
        'Education',
        'Employment', 
        'Empowerment and Self Help',
        'Entitlements',
        'Family Life and Social Relationships',
        'Health Homes',
        'Health Insurance',
        'Housing',
        'Legal/Recidivism Risk',
        'Medical',
        'Mental Health',
        'Money Management',
        'OWDS',
        'Prosocial Activity',
        'Seeking Safety',
        'Service Planning and Coordination',
        'Substance Use'
    };
    
    public Set<String> caseCoordinationCIRTSubjects = new Set<String>{
        'Case Conference/Review',          
        'Case Management',
        'Community Escort', 
        'Community Monitoring', 
        'Crisis Intervention',
        'Discharge Planning Review', 
        'Education',
        'Employment', 
        'Healthcare Coordination',
        'Healthcare Linkage',
        'Income Support Facilitation',
        'Legal Services',
        'Linkage to Services (Other)',
        'Medical ER Referral',
        'Mental Health Treatment Linkage',
        'Peer Support',
        'Psychiatric ER Referral',
        'Referral to Services',
        'Substance Abuse Treatment Linkage',
        'Supportive Counseling',
        'Vocation'
    };
    
    public Set<String> NurseSubjects = new Set<String>{          
        'Case Management',
        'Community Escort', 
        'Community Monitoring', 
        'Crisis Intervention', 
        'Education',
        'Employment', 
        'Healthcare Coordination',
        'Healthcare Linkage',
        'Income Support Facilitation',
        'Legal Services',
        'Linkage to Services (Other)',
        'Medical ER Referral',
        'Medication Management',
        'Mental Health Treatment Linkage',
        'Peer Support',
        'Psychiatric ER Referral',
        'Referral to Services',
        'Substance Abuse Treatment Linkage',
        'Supportive Counseling',
        'Vocation'
    };
    
    public Set<String> PsychSubjects = new Set<String>{          
        'Community Escort', 
        'Crisis Intervention', 
        'Medical ER Referral',
        'Medication Management',
        'Mental Health Treatment Linkage',
        'Psychiatric ER Referral',
        'Psychiatric Evaluation',
        'Psychiatric Initiation of Medication',
        'Supportive Counseling'
    };            
    
    public Set<String> CollateralContactSubjects = new Set<String>{
        null,
        'APT - Therapy Session',     
        'Education',
        'Employment', 
        'Empowerment and Self Help',
        'Entitlements',
        'Family Life and Social Relationships',
        'Health Homes',
        'Health Insurance',
        'Housing',
        'Legal/Recidivism Risk',
        'Medical',
        'Mental Health',
        'Money Management',
        'OWDS',
        'Prosocial Activity',
        'Reestablishing Contact',
        'Seeking Safety',
        'Service Planning and Coordination',
        'Substance Use',
        'PEAK Intake Scheduling'
    };           
            
    public Map<ID, Set<String>> acceptableEventSubjects = new Map<ID, Set<String>> {
    
        utilIds.educationExternal => educationExternalSubjects,
        utilIds.educationInternal => educationInternalSubjects,
        utilIds.mentalHealthInternal => mentalHealthInternalSubjects,
        utilIds.mentalHealthExternal => mentalHealthExternalSubjects,
        utilIds.substanceAbuseInternal => substanceAbuseInternalSubjects,
        utilIds.substanceAbuseExternal => substanceAbuseExternalSubjects,
        utilIds.caseCoordination => caseCoordinationSubjects,
        utilIds.caseCoordinationExternal => caseCoordinationExternalSubjects,                
        utilIds.employmentInternal => employmentInternalSubjects,
        utilIds.employmentExternal => employmentExternalSubjects,
        utilIds.apptCaseCoordinationExternalJC => caseCoordinationExternalJCSubjects,
        utilIds.caseCoordinationCCM => caseCoordinationCCMSubjects,
        utilIds.caseCoordinationCIRT => caseCoordinationCIRTSubjects,
        utilIds.apptNurse => NurseSubjects,
        utilIds.apptPsych => PsychSubjects,
        utilIds.apptCollateralContact => CollateralContactSubjects
    };

    /////////////////////////////////////////////////////////////
    // Global Methods Start
    /////////////////////////////////////////////////////////////
   
    /////////////////////////////////////////////////////////////
    // Create Program Plan
    /////////////////////////////////////////////////////////////

    public Program_Plan__c createProgramPlan(Id clientID) {
    
        Program_Plan__c newProgramPlan = new Program_Plan__c();
        newProgramPlan.Client_Name__c = clientID;
        return newProgramPlan;
        
    }
    
    public void lockProgramPlanAll(List<Id> lstContactIds) {
        
        list<Program_Plan__c> lstPlanstoLock =  [Select Id, Client_name__c, Program_Plan_locked__c, 
                                                Program_Plan_Completed_by__c, Program_Plan_Completed_On__c, 
                                                recordTypeId 
                                                from Program_Plan__c 
                                                where Client_Name__c in :lstContactIds
                                                and Program_Plan_Locked__c != true];
        
        //ppMethods.lockProgramPlan(lstPlanstoLock);
                
    }
    
    // 7/8/13 MB: generic method to replace getSubstanceAbuseSupervisors, getEducationAbuseSupervisors, etc
    // 9/28/14 set up as statiuc variable in constructor

    

    /////////////////////////////////////////////////////////////
    // Create Intake 
    /////////////////////////////////////////////////////////////
    @future
    public static void createIntakeForCEP(List<Id> contactIds, Date attendedOrientationDate, Boolean bolIsReIntake) {
        
        utilityIDs utilIds = new utilityIds();
        utilityMethods utilMethods = new utilityMethods();
        Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();
        
        system.debug('\n\n***Inside utilityMethod - createIntakeForCEP***');
        /////////////////////////////////////////////////////////////
        // Create Program Plan
        ////////////////////////////////////////////////////////////
        
        //Set<Id> contactIds = new Set<Id>();
        // 3/21/13 MB: added for prod.a.BT-0661
        Map<Id,Date> mapOrientDates = new Map<Id,Date>();        
        

        
        list<Contact> lstContactsForIntake = [select id, Case_Coordinator__c, Team_Leader__c, Client_Status__c,
                                                (SELECT  WhoId, ActivityDate, ClassTypeRPT__c, Class_Category__c  
                                                FROM Events 
                                                WHERE RecordTypeId = :utilIds.orientationAppointment
                                                AND (Verification_Status__c = 'Attended' 
                                                OR Verification_Status__c = 'Late'
                                                OR Verification_Status__c = 'Tardy')
                                                ORDER BY ActivityDate DESC)
                                                from Contact where id in :contactIds];
        

                                        
        /////////////////////////////////////////////////////////////
        // This method will create the tasks for intakes each task has its own rules 
        // will create each and then insert
        /////////////////////////////////////////////////////////////
        
        List<Task> intakeTasksForInsert = new List<Task>();
        //List<Program_Plan__c> programPlansToCreate = new List<Program_Plan__c>();
        
        //20110616 ebg - change from 180 to 179
        //Date projectedExitDate = System.Today().addDays(180);
        Date projectedExitDate = System.Today().addDays(179);
        system.debug('***Setting projectedExitDate: ' + projectedExitDate);
        
        for(contact c:lstContactsForIntake) {
            
            //// Going to slip in a contact status update here since we are looping through
            //c.Client_Status__c = 'Active';
            
            /////////////////////////////////////////////////////////////
            // Find correct Dates from Event  AAB 20110303
            /////////////////////////////////////////////////////////////
            attendedOrientationDate = System.Today();
            
            for(Event evtDate : c.Events) {
                attendedOrientationDate = evtDate.ActivityDate;
                mapOrientDates.put(evtDate.whoId, evtDate.ActivityDate);
                break;
            }
            
            //20110616 ebg - should add 179 days instead of 180
            //projectedExitDate = attendedOrientationDate.addDays(180);
            projectedExitDate = attendedOrientationDate.addDays(179);
            projectedExitDate = FindPreviousWorkDate(projectedExitDate);
            
            system.debug('\n\nprojectExitDate: ' + projectedExitDate + '\n');
            
            
            /////////////////////////////////////////////////////////////
            // Create Mandatory Classes Task
            /////////////////////////////////////////////////////////////
            
            Task mandClassT = new Task();
            mandClassT.WhoId = c.Id;
            mandClassT.OwnerId = csApexDefaults.Admin_Support_Supervisor__c;
            mandClassT.RecordTypeId = utilIds.mandatoryClassesTask;
            mandClassT.Subject = 'Mandatory Classes';
            mandClassT.ActivityDate = attendedOrientationDate.addDays(29);
            mandClassT.Open_Date__c = attendedOrientationDate;
            mandClassT.Verification_Due_Date__c = attendedOrientationDate.addDays(29);
            mandClassT.Automatically_Generated__c = true;
            mandClassT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(mandClassT);
                
            /////////////////////////////////////////////////////////////
            // Create Case Coordinator Assessment Task
            /////////////////////////////////////////////////////////////
            
            Task caseCoordT = new Task();
            caseCoordT.WhoId = c.Id;
            caseCoordT.RecordTypeId = utilIds.caseCoordinatorAssessmentTask;
            caseCoordT.Subject = 'Case Coordinator Assessment';
            caseCoordT.Open_Date__c = attendedOrientationDate;
            caseCoordT.ActivityDate = attendedOrientationDate.addDays(29);
            caseCoordT.Verification_Due_Date__c = attendedOrientationDate.addDays(29);
            caseCoordT.Automatically_Generated__c = true;
            if(bolIsReintake) {
                caseCoordT.ownerId = c.Case_Coordinator__c;
            }
            else {
                caseCoordT.ownerId = UserInfo.getUserId();
            }
            caseCoordT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(caseCoordT);
              
            /////////////////////////////////////////////////////////////
            // Create Substance Abuse Assessment Task
            /////////////////////////////////////////////////////////////
            
            Task substanceAbuseAssessmentT = new Task();
            substanceAbuseAssessmentT.WhoId = c.Id;
            substanceAbuseAssessmentT.OwnerId = csApexDefaults.substance_Abuse_Supervisor__c;
            substanceAbuseAssessmentT.RecordTypeId = utilIds.substanceAbuseAssessmenTask;
            substanceAbuseAssessmentT.Subject = 'Substance Abuse Assessment';
            substanceAbuseAssessmentT.Open_Date__c = attendedOrientationDate;
            substanceAbuseAssessmentT.ActivityDate = attendedOrientationDate.addDays(9);
            substanceAbuseAssessmentT.Verification_Due_Date__c = attendedOrientationDate.addDays(9);
            substanceAbuseAssessmentT.Automatically_Generated__c = true;  
            substanceAbuseAssessmentT.SkipRestrictions__c = true;  
            intakeTasksForInsert.add(substanceAbuseAssessmentT);
            
            /////////////////////////////////////////////////////////////
            // Create Inital Drug Test Task
            /////////////////////////////////////////////////////////////
            
            Task initialDrugTestT = new Task();
            initialDrugTestT.WhoId = c.Id;
            initialDrugTestT.OwnerId = csApexDefaults.substance_Abuse_Supervisor__c;
            initialDrugTestT.RecordTypeId = utilIds.initialDrugTestTask;
            initialDrugTestT.Subject = 'Initial Drug Test';
            initialDrugTestT.Open_Date__c = attendedOrientationDate;
            if(bolIsReIntake) {
                initialDrugTestT.ActivityDate = attendedOrientationDate.addDays(13);
            }
            else {
                initialDrugTestT.ActivityDate = attendedOrientationDate.addDays(29);
            }
            initialDrugTestT.Verification_Due_Date__c = attendedOrientationDate.addDays(29);
            initialDrugTestT.Automatically_Generated__c = true;
            initialDrugTestT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(initialDrugTestT);
            
            /////////////////////////////////////////////////////////////
            // Create MAYSI Assessment Task
            /////////////////////////////////////////////////////////////
            //disabled 12/12/13 as MAYSI is no longer used


            // 2/6/14 UCLA PTSD RI and PHQ9 replace MAYSI
            
            /////////////////////////////////////////////////////////////
            // Create PHQ9 Assessment Task
            /////////////////////////////////////////////////////////////
            
            Task PHQ9assessmentT = new Task();
            PHQ9assessmentT.WhoId = c.Id;
            PHQ9assessmentT.RecordTypeId = utilIds.PHQ9Task;
            PHQ9assessmentT.Subject = 'PHQ-9 Assessment';
            PHQ9assessmentT.Open_Date__c = attendedOrientationDate;
            PHQ9assessmentT.ActivityDate = attendedOrientationDate.addDays(9);
            PHQ9assessmentT.Verification_Due_Date__c = attendedOrientationDate.addDays(9);
            PHQ9assessmentT.Automatically_Generated__c = true;
            if(bolIsReintake) {
                PHQ9assessmentT.ownerId = c.Case_Coordinator__c;
            }
            else {
                PHQ9assessmentT.ownerId = UserInfo.getUserId();
            }
            PHQ9assessmentT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(PHQ9assessmentT);
            
            /////////////////////////////////////////////////////////////
            // Create UCLA Assessment Task
            /////////////////////////////////////////////////////////////
            
            Task uclaAssessmentT = new Task();
            uclaAssessmentT.WhoId = c.Id;
            uclaAssessmentT.RecordTypeId = utilIds.UCLATask;
            uclaAssessmentT.Subject = 'UCLA PTSD RI Assessment';
            uclaAssessmentT.Open_Date__c = attendedOrientationDate;
            uclaAssessmentT.ActivityDate = attendedOrientationDate.addDays(9);
            uclaAssessmentT.Verification_Due_Date__c = attendedOrientationDate.addDays(9);
            uclaAssessmentT.Automatically_Generated__c = true;
            if(bolIsReintake) {
                uclaAssessmentT.ownerId = c.Case_Coordinator__c;
            }
            else {
                uclaAssessmentT.ownerId = UserInfo.getUserId();
            }
            uclaAssessmentT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(uclaAssessmentT);       
            
            /////////////////////////////////////////////////////////////
            // Create LSCMI Assessment Task
            /////////////////////////////////////////////////////////////
            
            Task lscmiAssessmentT = new Task();
            lscmiAssessmentT.WhoId = c.Id;
            lscmiAssessmentT.RecordTypeId = utilIds.LSCMITask;
            lscmiAssessmentT.Subject = 'LS/CMI Assessment';
            lscmiAssessmentT.Open_Date__c = attendedOrientationDate;
            lscmiAssessmentT.ActivityDate = attendedOrientationDate.addDays(29);
            lscmiAssessmentT.Verification_Due_Date__c = attendedOrientationDate.addDays(29);
            lscmiAssessmentT.Automatically_Generated__c = true;
            if(bolIsReintake) {
                lscmiAssessmentT.ownerId = c.Case_Coordinator__c;
            }
            else {
                lscmiAssessmentT.ownerId = UserInfo.getUserId();
            }
            lscmiAssessmentT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(lscmiAssessmentT);             
    
            /////////////////////////////////////////////////////////////
            // Create STAR Reading Test Task
            /////////////////////////////////////////////////////////////
            
            Task startReadingTestT = new Task();
            startReadingTestT.WhoId = c.Id;
            startReadingTestT.RecordTypeId = utilIds.STARTestReadingTask;
            startReadingTestT.Subject = 'STAR Reading Test';
            startReadingTestT.Open_Date__c = attendedOrientationDate;
            startReadingTestT.ActivityDate = attendedOrientationDate.addDays(29);
            startReadingTestT.Verification_Due_Date__c = attendedOrientationDate.addDays(29);
            startReadingTestT.Automatically_Generated__c = true;    
            startReadingTestT.ownerId = csApexDefaults.education_Liaison_Supervisor__c;
            startReadingTestT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(startReadingTestT);
            
            /////////////////////////////////////////////////////////////
            // Create STAR Math Test Task
            /////////////////////////////////////////////////////////////
            
            Task startMathTestT = new Task();
            startMathTestT.WhoId = c.Id;
            startMathTestT.RecordTypeId = utilIds.STARTestMathTask;
            startMathTestT.Subject = 'STAR Math Test';
            startMathTestT.Open_Date__c = attendedOrientationDate;
            startMathTestT.ActivityDate = attendedOrientationDate.addDays(29);
            startMathTestT.Verification_Due_Date__c = attendedOrientationDate.addDays(29);
            startMathTestT.Automatically_Generated__c = true;   
            startMathTestT.ownerId = csApexDefaults.education_Liaison_Supervisor__c;
            startMathTestT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(startMathTestT);
        
            /////////////////////////////////////////////////////////////
            // Initial Program Plan Task
            /////////////////////////////////////////////////////////////
            
            Task initialProgramPlanT = new Task();
            initialProgramPlanT.WhoId = c.Id;
            initialProgramPlanT.RecordTypeId = utilIds.initialProgramPlanTask;
            initialProgramPlanT.Subject = 'Initial Program Plan';
            initialProgramPlanT.Open_Date__c = attendedOrientationDate;
            initialProgramPlanT.ActivityDate = attendedOrientationDate.addDays(29);
            initialProgramPlanT.Verification_Due_Date__c = attendedOrientationDate.addDays(29);
            initialProgramPlanT.Automatically_Generated__c = true;  
            if(bolIsReintake) {
                initialProgramPlanT.ownerId = c.Case_Coordinator__c;
            }
            else {
                initialProgramPlanT.ownerId = UserInfo.getUserId();
            }
            initialProgramPlanT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(initialProgramPlanT);
    
            /////////////////////////////////////////////////////////////
            // Exit Notification Task
            /////////////////////////////////////////////////////////////
            
            Task exitNotificationT = new Task();
            exitNotificationT.WhoId = c.Id;
            exitNotificationT.RecordTypeId = utilIds.exitNotificationTask;
            exitNotificationT.Subject = 'Exit Notification';
            exitNotificationT.Open_Date__c = projectedExitDate;

            system.debug('Creating Exit task.  Open Date: ' + exitNotificationT.Open_Date__c + '   Due Date: ' + exitNotificationT.ActivityDate);
            
            //20110615 ebg - add a working day instead of just a day
            exitNotificationT.ActivityDate = utilMethods.getNextWorkingDayFromDate(projectedExitDate);
            exitNotificationT.Verification_Due_Date__c = utilMethods.getNextWorkingDayFromDate(projectedExitDate);
            
            exitNotificationT.Automatically_Generated__c = true;
            if(bolIsReintake) {
                exitNotificationT.ownerId = c.Case_Coordinator__c;
            }
            else {
                exitNotificationT.ownerId = UserInfo.getUserId();
            }
            exitNotificationT.SkipRestrictions__c = true;    
            intakeTasksForInsert.add(exitNotificationT);
            
            /////////////////////////////////////////////////////////////
            // Exit Drug Test Task
            /////////////////////////////////////////////////////////////
            
            Task exitDrugTestT = new Task();
            exitDrugTestT.WhoId = c.Id;
            exitDrugTestT.OwnerId = csApexDefaults.substance_Abuse_Supervisor__c;
            exitDrugTestT.RecordTypeId = utilIds.exitDrugTestTask;
            exitDrugTestT.Subject = 'Exit Drug Test';
            exitDrugTestT.Open_Date__c = projectedExitDate.addDays(-14);
            // BT-101 per PA, the Due Date should be the projected Exit Date - not +1.
            exitDrugTestT.ActivityDate = projectedExitDate;
            exitDrugTestT.Verification_Due_Date__c = projectedExitDate.addDays(1);
            exitDrugTestT.Automatically_Generated__c = true;   
            exitDrugTestT.SkipRestrictions__c = true; 
            intakeTasksForInsert.add(exitDrugTestT);
            
            /////////////////////////////////////////////////////////////
            // CBO Placement Task
            /////////////////////////////////////////////////////////////
            
            Task cboPlacementT = new Task();
            cboPlacementT.WhoId = c.Id;
            cboPlacementT.RecordTypeId = utilIds.CBOPlacementTask;
            cboPlacementT.Subject = 'CBO Placement';
            // BT-102 per PA, Open_Date__c should be -29 days, not -30.
            cboPlacementT.Open_Date__c = projectedExitDate.addDays(-29);
            cboPlacementT.ActivityDate = projectedExitDate;
            cboPlacementT.Verification_Due_Date__c = projectedExitDate;
            cboPlacementT.Automatically_Generated__c = true;    
            if(bolIsReintake) {
                cboPlacementT.ownerId = c.Case_Coordinator__c;
            }
            else {
                cboPlacementT.ownerId = UserInfo.getUserId();
            }
            cboPlacementT.SkipRestrictions__c = true;
            intakeTasksForInsert.add(cboPlacementT);
            
            /////////////////////////////////////////////////////////////
            // 1 Year Post-Intake Rearrest Check
            // added 7/8/13 MB
            /////////////////////////////////////////////////////////////
            if(bolIsReintake == false) {
            
                Task rearrestT = new Task();
                rearrestT.WhoId = c.Id;
                rearrestT.OwnerId = csApexDefaults.Rearrest_Check_Owner_CEP__c;
                rearrestT.RecordTypeId = utilIds.rearrestCheckTask;
                rearrestT.Subject = 'Rearrest Check - 1 Year Post-Intake';
                rearrestT.Open_Date__c = attendedOrientationDate.addDays(365);
                rearrestT.ActivityDate = attendedOrientationDate.addDays(372);
                rearrestT.Verification_Due_Date__c = attendedOrientationDate.addDays(372);
                rearrestT.Automatically_Generated__c = true;   
                rearrestT.SkipRestrictions__c = true; 
                intakeTasksForInsert.add(rearrestT);
            }                        
            
            /////////////////////////////////////////////////////////////
            // CC CRS Note Task
            //////////////////////////////////////////////////////////// 
            
            Task thisCRSTask;
            thisCRSTask = utilMethods.createCCCourtReportNoteTask(c, null);
            
            if(thisCRSTask != null) {
                intakeTasksForInsert.add(thisCRSTask);
            }
            
            /////////////////////////////////////////////////////////////
            // CC Progress Note Task
            //////////////////////////////////////////////////////////// 
            
            Task thisPNTask;
            thisPNTask = utilMethods.createCCProgressNoteTask(c,thisCRSTask, attendedOrientationDate);
            
            if(thisPNTask != null) {
                intakeTasksForInsert.add(thisPNTask);
            }
            
        }
        
        // 3/21/13 MB: as per prod.a.BT-0661, close the initial drug test task if a test was done
        // after orientation, but before the orientation was verified
        
        list<Test__c> existingDrugTests = [select id, Test_Date__c, Contact__c from Test__c 
                                           where RecordTypeId = :utilIds.drugTestRecordType
                                           and Contact__c in :contactIds];
                                           
        list<Test__c> lstTeststoUpdate = new list<Test__c>();
        
        for(Test__c t: existingDrugTests) {
            
            if(t.Test_Date__c >= mapOrientDates.get(t.Contact__c)) {
                
                lstTeststoUpdate.add(t);
            }
        }                                  
         
        //update lstContactsForIntake;    
        //insert programPlansToCreate;
        insert intakeTasksForInsert;
        //this will close the initial drug test task if a test was already done
        update lstTeststoUpdate;
        
    }
    
    public Task createCCCourtReportNoteTask(Contact c, Event evtSource) {
        
        Date dtCourtDate;
        
        // Assume TRUE unless condition warrants FALSE
        Boolean createTaskFlag = true;
        
        /////////////////////////////////////
        // TEST 1:  Client Status Test
        /////////////////////////////////////
        if(c.Client_status__c == 'Active' || c.Client_status__c == 'On Program Hold' 
        || c.Client_status__c == ('Intaked - Not Yet Active')) {
            
            /////////////////////////////////////
            // TEST 2:  Determine if court case has been opened
            /////////////////////////////////////
            if(evtSource == null) {
                
                // Targeted Event was not passed, find first court date event for further processing
                //List<Event> lstEvents = [SELECT Id, RecordTypeId, Court_Report_Required__c, StartDateTime FROM Event WHERE WhoId = :c.Id AND RecordTypeId = :courtDate AND StartDateTime > :System.Today() AND Court_Report_Required__c = true AND Outcome__c = 'Pending' ORDER BY StartDateTime ASC];
                List<Event> lstEvents = [SELECT Id, ClassTypeRPT__c, Class_Category__c, RecordTypeId, Court_Report_Required__c, StartDateTime, Report_Type__c FROM Event WHERE WhoId = :c.Id AND RecordTypeId = :utilIds.courtDate AND Court_Report_Required__c = true AND Outcome__c = 'Pending' ORDER BY StartDateTime ASC];
                
                for(Event e : lstEvents) {
                    // pull first event (if a specific case wasn't passed, assume next available), exit loop.
                    evtSource = e;
                    break;
                }
            }
            
            /////////////////////////////////////
            // TEST 3:  Determine if valid event is a court case that requires a CC CRS Note Task
            /////////////////////////////////////
            if(evtSource != null) {
                
                // TEST 3A:  Make sure recordTypeID = courtDate and that a Court Report is actually needed
                if(evtSource.RecordTypeId != utilIds.courtDate || evtSource.Court_Report_Required__c == false) {
                    // TEST 3A FAIL - Note not needed
                    System.Debug('utilityMethods.createCourtReportNoteTask TEST 3A FAIL - Either the event found is not a valid "Court Date" RecordType, or the "Court Report Required" checkbox is FALSE');
                    createTaskFlag = false;
                }
                
                dtCourtDate = Date.newInstance(evtSource.StartDateTime.Year(),evtSource.StartDateTime.Month(),evtSource.StartDateTime.Day());
                
                // TEST 3B:  Only one CC CRS can be open at one time per Court Case.
                List<Task> lstTasks = [SELECT Id, ActivityDate FROM Task WHERE WhoId = :c.Id AND RecordTypeId = :utilIds.ccCRSNoteTask AND IsClosed = false];
                for(Task t : lstTasks) {
                    if(t.ActivityDate.daysBetween(dtCourtDate) < 7 || dtCourtDate.daysBetween(t.ActivityDate) < 7) {
                        // TEST 3B FAIL - Already a note task in the system
                        System.Debug('utilityMethods.createCourtReportNoteTask TEST 3B FAIL - There already is a CC CRS Note Task in the date vicinity of the supplied court case');
                        createTaskFlag = false;
                    }
                }
                
                /////////////////////////////////////
                // TEST 3C: Interrogate Event for Course Reg - Single Session OR Mandatory Class will NOT create PSPN  (BT-265)
                /////////////////////////////////////
                if(evtSource.ClassTypeRPT__c == utilIds.classSingle || evtSource.Class_Category__c == 'Mandatory Class') {
                    System.Debug('utilityMethods.createPSProgressNoteTask TEST 3C FAIL:  The event being processed is either a single-session or categorized as a Mandatory Class.');
                    createTaskFlag = false;
                }
                
            } else {
                // TEST 2 FAIL:  No valid Court Date has been found for this client
                System.Debug('utilityMethods.createCourtReportNoteTask TEST 2 FAIL - No Court Date exists for this client');
                createTaskFlag = false;
            }

        } else {
            // TEST 1 FAIL:  Client Status is not Active or on Hold
            System.Debug('utilityMethods.createCourtReportNoteTask TEST 1 FAIL:  Client Status is not Active or on Hold');
            createTaskFlag = false;
        }
        
        // Final Processing of CC CRS Task
        if(createTaskFlag == true) {
        
            System.debug('utilityMethods.createCourtReportNoteTask SUCCESS - Building Note Task Object');
        
            Task thisTask = new Task();
            thisTask.WhoId = c.Id;
            thisTask.recordTypeId = utilIds.ccCRSNoteTask;
            thisTask.ActivityDate = dtCourtDate.addDays(-6);    
            thisTask.Open_Date__c = dtCourtDate.addDays(-8);
            //thisTask.Verification_Date__c  = System.Today().addDays(14);      
            thisTask.Automatically_Generated__c = true;
            // 5/6/13 MB: Case managers need to differentiate between oral and written report requests
            thisTask.Subject = 'CC CRS Note - ' + (evtSource.Report_Type__c == 'Oral' ? 'Oral' : 'Written');
            thisTask.Task_source__c = evtSource.Id;
            thisTask.CEP_Contact_Team_Director_Id__c = UserInfo.getUserId();
            thisTask.SkipRestrictions__c = true;
            if(c.Case_Coordinator__c == null) {
                thisTask.ownerId = UserInfo.getUserId();
            } else {
                thisTask.ownerId = c.Case_Coordinator__c;
            }
            
            return thisTask;
        } else {
            return null;
        }
        
    }
    
    public Task createCCProgressNoteTask(Contact c, Task precedingTask, Date baseDate) {
        
        // Variables
        Set<Id> setRecordTypes = new Set<Id>();
        setRecordTypes.add(utilIds.ccProgressNoteTask);
        setRecordTypes.add(utilIds.ccCRSNoteTask);
        Date dteComputation;
        
        // Assume TRUE unless condition warrants FALSE
        Boolean createTaskFlag = true;
        
        // Optional check - baseDate to replace System.Today() in case of orientation appointment not verified for a length of time
        if(baseDate == null) {
            dteComputation = System.Today();
        } else {
            dteComputation = baseDate;
        }
        
        /////////////////////////////////////
        // TEST 1:  Client Status Test
        /////////////////////////////////////
        if(c.Client_status__c == 'Active' || c.Client_status__c == 'On Program Hold'
        || c.Client_status__c == ('Intaked - Not Yet Active')) {
            
            /////////////////////////////////////
            // TEST 2:  Check for existing task conditions
            /////////////////////////////////////
            
            /////////////////////////////////////
            // TEST 2A:  Pending CRS Note Task - Client cannot have an open CRS task that is <= 7 days of 
            // proposed PN Note Task Due Date of TODAY+14Days
            /////////////////////////////////////
            if(precedingTask != null) {
                if((precedingTask.RecordTypeId == utilIds.ccCRSNoteTask) && (precedingTask.ActivityDate.addDays(-7) <= dteComputation.addDays(14)) ) {
                        // TEST 2A FAIL:
                        System.Debug('utilityMethods.createProgressNoteTask TEST 2A FAIL:  (Pending CRS Note Task) Client cannot have an open CRS task that is <= 7 days of proposed PN Note Task Due Date of TODAY+14Days');
                        createTaskFlag = false;
                    }
            }
            
            List<Task> lstTasks = [SELECT Id, RecordTypeId, ActivityDate FROM Task WHERE WhoId = :c.Id AND IsClosed = false AND RecordTypeId IN :setRecordTypes];
            for(Task t : lstTasks) {
                
                /////////////////////////////////////
                // TEST 2B:  Existing PN Note Task - Client cannot have more than one PN Note Task open at a time
                /////////////////////////////////////
                if(t.RecordTypeId == utilIds.ccProgressNoteTask) {
                    // TEST 2B FAIL
                    System.Debug('utilityMethods.createProgressNoteTask TEST 2B FAIL:  (Existing PN Note Task) Client cannot have more than one PN Note Task open at a time');
                    createTaskFlag = false;
                    break;
                }
                
                /////////////////////////////////////
                // TEST 2C:  Existing CRS Note Task - Client cannot have an open CRS task that is <= 7 days of 
                // proposed PN Note Task Due Date of TODAY+14Days
                /////////////////////////////////////
                if(t.RecordTypeId == utilIds.ccCRSNoteTask) {
                    if(t.ActivityDate.addDays(-7) <= dteComputation.addDays(14)) {
                        // TEST 2C FAIL:
                        System.Debug('utilityMethods.createProgressNoteTask TEST 2C FAIL:  (Existing CRS Note Task) Client cannot have an open CRS task that is <= 7 days of    proposed PN Note Task Due Date of TODAY+14Days');
                        createTaskFlag = false;
                        break;
                    }
                }
            }
            
        } else {
            // TEST 1 FAIL
            System.Debug('utilityMethods.createProgressNoteTask TEST 1 FAIL:  Client Status is not Active or on Hold');
            createTaskFlag = false;
        }
        
        
        // Final Processing of CC PN Task
        if(createTaskFlag == true) {
        
            System.debug('utilityMethods.createProgressNote SUCCESS - Building Note Task Object');
            
            Date dteBaseDate = dteComputation;
        
            Task thisTask = new Task();
            thisTask.WhoId = c.Id;
            thisTask.recordTypeId = utilIds.ccProgressNoteTask;
            thisTask.ActivityDate = dteBaseDate.addDays(14); 
            thisTask.Open_Date__c = dteBaseDate;
            //thisTask.Verification_Date__c  = dteBaseDate.addDays(14);    
            thisTask.Automatically_Generated__c = true;
            thisTask.Subject = 'CC Progress Note';
            thisTask.CEP_Contact_Team_Director_Id__c = UserInfo.getUserId();
            if( c.Case_Coordinator__c == null) {
                thisTask.ownerId = UserInfo.getUserId();
            } else {
                thisTask.ownerId = c.Case_Coordinator__c;
            }
            if( precedingTask != null) {
                thisTask.Task_Source__c = precedingTask.Id;
            }
            
            thisTask.SkipRestrictions__c = true;
            
            return thisTask;
        } else {
            return null;
        }
        
    }
    
    public void closeCCPNNoteTask(List<Progress_Note__c> lstPN) {
        
        //////////////////////////////////////////////////////
        // Close Logic based on Progress_Note__c trigger
        //////////////////////////////////////////////////////
        
        System.Debug('utilityMethods.closeCCPNNoteTask INFO:  Starting Method');
        
        Set<Id> clientIds = new Set<Id>();
        
        if(lstPN != null) {
            
            // Create Set of related Contact Ids and pull full list of Tasks within scope
            for(Progress_Note__c p : lstPN) {
                clientIds.add(p.Client_Id__c);  
            }
            List<Task> lstPNTasks = [SELECT Id, Status, WhoId, ActivityDate, Closed_by_system__c, Closing_Date__c, SkipRestrictions__c
            FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND RecordTypeId = :utilIds.ccProgressNoteTask];
            System.Debug('utilityMethods.closeCCPNNoteTask INFO:  Task List Size = ' + lstPNTasks.size());
            
            for(Progress_Note__c p : lstPN) {
                
                System.Debug('utilityMethods.closeCCPNNoteTask INFO:  Does RecordTypeId ' + p.RecordTypeId + ' = ' + utilIds.progressNoteCCPN + '?');
                
                if(p.RecordTypeId == utilIds.progressNoteCCPN) {
                    
                    for(Task t : lstPNTasks) {
                        
                        if(t.WhoId == p.Client_Id__c) {
                            
                            if(System.Today() <= t.ActivityDate) {
                                t.Status = 'DONE ON TIME';
                                t.Status__c = 'DONE ON TIME';
                                t.SkipRestrictions__c = true;
                                System.Debug('utilityMethods.closeCCPNNoteTask INFO:  Note was created ON TIME');
                            }
                            
                            if(System.Today() > t.ActivityDate) {
                                t.Status = 'DONE LATE';
                                t.Status__c = 'DONE LATE';
                                t.SkipRestrictions__c = true;
                                System.Debug('utilityMethods.closeCCPNNoteTask INFO:  Note was created LATE');
                            }
                            
                            t.Closing_Date__c = System.Today();
                            t.Closed_by_system__c = true;
                        }
                    }
                }   
            }
            
            update lstPNTasks;
            System.Debug('utilityMethods.closeCCPNNoteTask INFO:  Updating List');
            
            // Create new PN Task if possible
            List<Contact> lstContact = [SELECT Id, Client_Status__c, Team_Leader__c, Case_Coordinator__c FROM Contact WHERE Id IN :clientIds];
            List<Task> lstNewTasks = new List<Task>();
            
            for(Contact c : lstContact) {
                System.Debug('utilityMethods.closeCCPNNoteTask INFO:  Creating new CCPN');
                Task t = createCCProgressNoteTask(c,null, null);
                if(t != null) { lstNewTasks.add(t); }
                    
            }
            
            insert lstNewTasks;
            
        }
    }
    
    public void closeCCCRSNoteTaskAll(List<Event> lstEvt) {
        
        //////////////////////////////////////////////////////
        // Global "Close All" CC CRS logic on Court Date Event
        // Created 20110303 AAB - DCS
        //////////////////////////////////////////////////////
        Set<Id> clientIds = new Set<Id>();
        
        // Create Set of related Contact Ids and pull full list of Tasks within scope
        for(Event e : lstEvt) {
            clientIds.add(e.WhoId); 
        } 
        
        // Get list of all tasks within contact scope       
        List<Task> lstCCCRSTasks = [SELECT Id, WhoId, Status, Status__c, Closing_Date__c, Closed_by_system__c, 
        SkipRestrictions__c, Outcome__c, ActivityDate 
        FROM Task WHERE WhoId IN :clientIds AND RecordTypeId = :utilIds.ccCRSNoteTask AND IsClosed = false];
        
        for(Event evtSource : lstEvt) {
            
            if(evtSource.RecordTypeId == utilIds.courtDate && evtSource.Outcome__c != 'Pending' && evtSource.Court_Report_Required__c == true) {
                
                for(Task ccCRSTask: lstCCCRSTasks) {
                    
                    if(ccCRSTask.WhoId == evtSource.WhoId) {
                        // 20120119 - BT-297 Corrected to reflect the Task Status of "Not Started" and the Actual Court Date
                        if(ccCRSTask.Status == 'Not Started' && ccCRSTask.ActivityDate < evtSource.StartDateTime.Date()) {
                            ccCRSTask.Status = 'Incomplete';
                            //ccCRSTask.Status__c = 'CANCELLED';
                            system.debug('\n\n***Setting SkipRestrictions__c to true for task ID ' + ccCRSTask.Id + '\n');
                            ccCRSTask.SkipRestrictions__c = true;
                            //added by MB 10/9/12 to disable validation rule which only allows tasks to be closed (manually) if they are open (past the open date)
                            ccCRSTask.Closed_by_system__c = true;
                            ccCRSTask.Closing_Date__c = System.Today();
                        }
                    }
                }
                
                update lstCCCRSTasks;
                
                // DO NOT CREATE NEW CC CRS NOTE
                
            }
        }
    }
    
    public void closeCCPNNoteTaskAll(List<Event> lstEvt) {
        
        //////////////////////////////////////////////////////
        // Global "Close All" CC PN logic on Court Date Event
        // Created 20110303 AAB - DCS
        //////////////////////////////////////////////////////
        Set<Id> clientIds = new Set<Id>();
        
        // Create Set of related Contact Ids and pull full list of Tasks within scope
        for(Event e : lstEvt) {
            clientIds.add(e.WhoId); 
        } 
        
        // Get list of all tasks within contact scope       
        List<Task> lstCCPNTasks = [SELECT Id, WhoId, Status, Status__c, Closing_Date__c, Closed_by_system__c, 
        SkipRestrictions__c FROM Task WHERE WhoId IN :clientIds AND RecordTypeId = :utilIds.ccProgressNoteTask AND IsClosed = false];
        
        for(Event evtSource : lstEvt) {
            
            if(evtSource.RecordTypeId == utilIds.courtDate && evtSource.Outcome__c != 'Pending' && evtSource.Court_Report_Required__c == true) {
                
                for(Task ccPNTask: lstCCPNTasks) {
                    
                    if(ccPNTask.WhoId == evtSource.WhoId) {
                        // next line changed from "Cancelled" 9/23/12 by MB, to match behavior of CC CRS note tasks
                        ccPNTask.Status = 'Incomplete';
                        //ccPNTask.Status__c = 'CANCELLED';
                        ccPNTask.Closing_Date__c = System.Today();
                        //added by MB 10/9/12 to disable validation rule which only allows tasks to be closed (manually) if they are open (past the open date)
                        ccPNTask.Closed_by_system__c = true;
                        ccPNTask.SkipRestrictions__c = true;
                    }
                }
                
                update lstCCPNTasks;
                
                // Create New Progress Note
                if(evtSource.Outcome__c != 'No Longer Tracking') {
                    // Conditionality added 20111220 AAB / EG BT-292 to block the creation of additional PN notes after Admin Action Exit 
                    Contact c = [SELECT Id, Team_Leader__c, Case_Coordinator__c, Client_Status__c FROM Contact WHERE Id = :evtSource.WhoId];
                    Task t = createCCProgressNoteTask(c,null, null);
                    if(t != null) { insert t; }
                }
            }
        }
    }
    
    public void closeCCCourtReportNoteTask(List<Progress_Note__c> lstPN, List<Event> lstEvt, Boolean updateFlag) {
                
        //////////////////////////////////////////////////////
        // Close Logic based on Progress_Note__c trigger
        //////////////////////////////////////////////////////
        if(updateFlag == null) {
            updateFlag = false;
        }
        
        Set<Id> clientIds = new Set<Id>();
        
        if(lstPN != null) {
            
            // Create Set of related Contact Ids and pull full list of Tasks within scope
            for(Progress_Note__c p : lstPN) {
                clientIds.add(p.Client_Id__c);  
            }
            List<Task> lstCRSTasks = [SELECT Id, Status, WhoId, ActivityDate, Status__c, Closing_Date__c,
            Closed_by_system__c, SkipRestrictions__c FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND RecordTypeId = :utilIds.ccCRSNoteTask];
            
            // Loop through the Progress Notes in scope and close out CRS Note Tasks
            for(Progress_Note__c p : lstPN) {
                
                if(p.RecordTypeId == utilIds.progressNoteCCCRS) {

                    for(Task t : lstCRSTasks) {
                    
                        if(t.WhoId == p.Client_Id__c) {
                            
                            if(updateFlag == false) { // TRIGGER INSERT
                                
                                if(System.Today() >= t.ActivityDate.addDays(-2)) {  // DO NOT CLOSE IF NOTE IS DONE EARLY!
                                    if(System.Today() <= t.ActivityDate) {
                                        t.Status = 'DONE ON TIME';
                                        t.Status__c = 'DONE ON TIME';
                                        t.SkipRestrictions__c = true;
                                    }
                                    
                                    if(System.Today() > t.ActivityDate) {
                                        t.Status = 'DONE LATE';
                                        t.Status__c = 'DONE LATE';
                                        t.SkipRestrictions__c = true;
                                    }
                                   
                                    t.Closed_by_system__c = true;
                                    t.Closing_Date__c = System.Today();
                                }
                                
                            } else { // TRIGGER UPDATE
                                if(System.Today() <= t.ActivityDate) {
                                    t.Status = 'DONE ON TIME';
                                    t.Status__c = 'DONE ON TIME';
                                    t.SkipRestrictions__c = true;
                                }
                                
                                if(System.Today() > t.ActivityDate) {
                                    t.Status = 'DONE LATE';
                                    t.Status__c = 'DONE LATE';
                                    t.SkipRestrictions__c = true;
                                }
                                
                                t.Closed_by_system__c = true;                                
                                t.Closing_Date__c = System.Today();
                            }
                        }
                    }
                }
            }
            
            update lstCRSTasks;
            
        }
        
        //////////////////////////////////////////////////////
        // Close Logic based on Event trigger
        //////////////////////////////////////////////////////
        
        //if(lstEvt != null) {
            
            
            
        //}
        
    }
    
    public void createPSProgressNoteTask(List<Event> lstEvt, List<Progress_Note__c> lstPn) {
        
        //////////////////////////////////////////////////////
        // Creating a PS Progress Note Task - based on Triggers from Event and Progress_Note__c
        //////////////////////////////////////////////////////
        
        // Assume TRUE unless condition warrants FALSE
        Boolean createTaskFlag = true;
        Boolean bolLoopTerm = false;
        
        Set<Id> clientIds = new Set<Id>();
        List<Task> lstNewTasks = new List<Task>();
        String strTaskArea = '';
        String strEvtSubject = '';
        Id lastWhoId = null;
        
        /////////////////////////////////////
        // TEST 1:  TEST THAT CURRENT USER IS NOT A CASE COORDINATOR
        /////////////////////////////////////
        if(userInfo.getProfileId() == utilIds.caseCoordinatorStaff) {
            // TEST 1 FAIL - User is a Case Coordinator
            System.Debug('utilityMethods.createPSProgressNoteTask TEST 1 FAIL:  Current User is a Case Coordinator');
            createTaskFlag = false;
        }
        
        /////////////////////////////////////
        // USE CASE 1:  Invocation of Method via Event Trigger
        /////////////////////////////////////
        if(lstEvt != null && createTaskFlag == true) {
            
            System.Debug('utilityMethods.createPSProgressNoteTask INVOKE:  Event Trigger');
            
            Set<Id> setOwnerIds = new Set<Id>();
            
            // Gather In-Scope Contact Records 
            for(Event e : lstEvt) {
                clientIds.add(e.WhoId);
                setOwnerIds.add(e.OwnerId);
            }
            
            //20120208 ebg - retrieve record type with other client info
            List<Contact> lstContacts = [SELECT Id, Client_Status__c, Team_Leader__c, Case_Coordinator__c, RecordTypeId FROM Contact WHERE Id IN :clientIds];
            
            // BT-282 - NEED TO FLIP :UserInfo.getUserId() to be owner of task
            //List<Task> lstTsk = [SELECT Id, WhoId, RecordTypeId, ActivityDate FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND OwnerId = :UserInfo.getUserId() ORDER BY WhoId ASC, ActivityDate ASC];
            List<Task> lstTsk = [SELECT Id, WhoId, RecordTypeId, ActivityDate, OwnerId FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND OwnerId IN :setOwnerIds ORDER BY WhoId ASC, ActivityDate ASC];
            
            // Begin Loop through Triggered Events
            for(Event evt : lstEvt) {
                
                // Loop through Contact List and specify record for Event scope
                Contact c;
                for(Contact cFind: lstContacts) {
                    if(evt.WhoId == cFind.Id) {
                        c = cFind;
                    } 
                }
                
                /////////////////////////////////////
                // TEST 1-1:  Task Already Created in this invocation for this client
                /////////////////////////////////////
                if(lastWhoId == evt.WhoId && bolLoopTerm == true) {
                    // TEST 1-1 FAIL - A PS PN was created for this Client within this session invocation, 
                    System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-1 FAIL:  A PS PN was created for this client within this session invocation.  EventId = ' + evt.Id);
                } else {
                    bolLoopTerm = false;
                }
                
                /////////////////////////////////////
                // TEST 1-1A: Interrogate Event for Course Reg - Single Session OR Mandatory Class will NOT create PSPN  (BT-265)
                // GED Tests and Predictor Tests no longer generate PS notes either (dvm.a.BT-0698)
                /////////////////////////////////////
                if(evt.ClassTypeRPT__c == utilIds.classSingle 
                || evt.Class_Category__c == 'Mandatory Class' 
                || evt.Class_Category__c == 'GED Test' || evt.Class_Category__c == 'GED Predictor Test'
                || evt.Class_Category__c == 'TASC Test' || evt.Class_Category__c == 'TASC Readiness Test') {
                    System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-1A FAIL:  The event being processed is either a single-session or categorized as a Mandatory Class/ GED Test.  EventId = ' + evt.Id);
                    createTaskFlag = false;
                }
                
                /////////////////////////////////////
                // TEST 1-2:  Client Status Test
                /////////////////////////////////////
                if(c.Client_Status__c == 'Active' || c.Client_Status__c == 'On Program Hold' 
                || c.Client_Status__c == ('Intaked - Not Yet Active')) {
                    
                    /////////////////////////////////////
                    // TEST 1-3:  TEST FOR ANY OPEN PS PN TASKS FOR CURRENT USER
                    // TEST 1-4:  CONFLICT WITH PS CRS ON PROPOSED TASK CREATION DATE
                    /////////////////////////////////////
                    for(Task tsk : lstTsk) {
                        
                        // BT-282 Specify Owner Id also
                        if(tsk.WhoId == c.Id && tsk.OwnerId == evt.OwnerId) {
                            
                            if(tsk.RecordTypeId == utilIds.psProgressNoteTask) {
                                // TEST 1-3 FAIL - There is an open PS PN already for this user
                                System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-3 FAIL:  Current User already has a PS PN Task Open!');
                                createTaskFlag = false;
                            }
                            
                            if(tsk.RecordTypeId == utilIds.psCRSNoteTask) {
                                if(tsk.ActivityDate.addDays(-7) <= evt.ActivityDate.addDays(14)) {
                                    // TEST 1-4 FAIL - There is an open PS CRS for this user that in conflict with the PS PN proposed date
                                    System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-4 FAIL:  Current User already has an open PS CRS in conflict with the PS PN proposed date');
                                    createTaskFlag = false;
                                }
                            }
                        }
                    }
                    
                    //////////////////////////////////////
                    // TEST 1-5:  Only specified Event RecordTypeIds can create a PS PN Task
                    //////////////////////////////////////
                    
                    // Modified BT-299 AAB - Remove Education and Substance Abuse (verify subject as well) per QC
                    
                    //20120208 ebg - per BT-312, do not create progress note tasks for Non-CEP clients
                    // 4/22/13 MB: Per Christina D's request, progress note tasks are now created for
                    // CJC/JS clients in career ex clases
                    
                    // 5/30/13 MB: Per Christina D's and Sophia M's request, QJC staff will get progress note
                    // reminders for QJC clients that they work with                    
                    
                    strEvtSubject = evt.Subject;
                    
                    if(((c.RecordTypeId == utilIds.conClient || c.RecordTypeId == utilIds.conQJC)&&
                            (evt.RecordTypeId == utilIds.educationExternal 
                            || evt.RecordTypeId == utilIds.educationInternal
                            || evt.RecordTypeId == utilIds.substanceAbuseExternal
                            || evt.RecordTypeId == utilIds.substanceAbuseInternal 
                            || evt.RecordTypeId == utilIds.employmentExternal
                            || evt.RecordTypeId == utilIds.employmentInternal
                            || evt.RecordTypeId == utilIds.mentalHealthExternal
                            || evt.RecordTypeId == utilIds.mentalHealthInternal
                            || (evt.RecordTypeId == utilIds.courseCatalogClass && evt.ClassTypeRPT__c != utilIds.classSingle)))
                        ||((c.RecordTypeId == utilIds.conJS || c.RecordTypeId == utilIds.conCJC) &&
                            (evt.RecordTypeId == utilIds.courseCatalogClass 
                            && strEvtSubject.contains('Career Exploration') && strEvtSubject != 'Career Exploration Interview' ))) {
                        

                        // Removed BT-299 AAB
                        if(evt.RecordTypeId == utilIds.educationExternal || evt.RecordTypeId == utilIds.educationInternal) {
                            strTaskArea = ' - Education';
                        }
                        
                        if(evt.RecordTypeId == utilIds.employmentExternal || evt.RecordTypeId == utilIds.employmentInternal) {
                            strTaskArea = ' - Employment';
                        }
                        
                        if(evt.RecordTypeId == utilIds.mentalHealthExternal || evt.RecordTypeId == utilIds.mentalHealthInternal) {
                            strTaskArea = ' - Mental Health';
                        }
                        
                        // Removed BT-299 AAB
                        if(evt.RecordTypeId == utilIds.substanceAbuseExternal || evt.RecordTypeId == utilIds.substanceAbuseInternal) {
                            strTaskArea = ' - Substance Abuse';
                        }
                        
                        if(evt.RecordTypeId == utilIds.courseCatalogClass) {
                            strTaskArea = ' - ' + evt.Area__c;
                        }
                        
                    } else {
                        // TEST 1-5 FAIL - This event cannot create a PS PN Task (Non-Matching RecordTypeId)
                        System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-5 FAIL:  This Event is not within the list of allowed RecordTypeIds '
                        + 'to create a PS PN Note Task, or note tasks are not allowed for this client record type.');
                        createTaskFlag = false;
                    }
                    
                } else {
                    // TEST 1-2 FAIL
                    System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-2 FAIL:  Client Status is not Active or on Hold');
                    createTaskFlag = false;
                }
                
                //////////////////////////////////////
                // TEST 1-6:  Check Administrative Override
                //////////////////////////////////////
                if(evt.Subject == 'Education Assessment' || evt.Subject == 'Substance Abuse Assessment') {
                    // TEST 1-6 FAIL
                    System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-6 FAIL:  An administrative flag has been thrown for this Event, no task created');
                    createTaskFlag = false;
                }
                
                // Final Processing of PS PN Task
                if(createTaskFlag == true && bolLoopTerm == false) {
                
                    System.debug('utilityMethods.createPSProgressNoteTask CASE 1 (Event-Triggered) SUCCESS - Building Note Task Object.  EventId = ' + evt.Id);
                
                    Task thisTask = new Task();
                    thisTask.WhoId = c.Id;
                    thisTask.recordTypeId = utilIds.psProgressNoteTask;
                    // AAB 20110504 Modified per QC BT-071
                    // thisTask.ActivityDate = System.Today().addDays(14);
                    thisTask.ActivityDate = evt.ActivityDate.addDays(14); 
                    thisTask.Open_Date__c = evt.ActivityDate;
                    //thisTask.Verification_Date__c  = System.Today().addDays(14);    
                    thisTask.Automatically_Generated__c = true;
                    thisTask.Subject = 'PS Progress Note' + strTaskArea;
                    thisTask.Task_source__c = evt.Id;
                    thisTask.CEP_Contact_Team_Director_Id__c = csApexDefaults.CEP_Director__c;
                    thisTask.SkipRestrictions__c = true;
                    //thisTask.OwnerId = UserInfo.getUserId();
                    thisTask.OwnerId = evt.OwnerId;
                    
                    //lstNewTasks.add(thisTask);
                    insert thisTask;
                    
                    // Track Current WhoId for test tagging in the event of a PN-invoked action
                    lastWhoId = c.Id;
                    bolLoopTerm = true;
                }
            }       
            
        }
        
        /////////////////////////////////////
        // USE CASE 2:  Invocation of Method via Progress Note Trigger
        /////////////////////////////////////
        if(lstPn != null && createTaskFlag == true) {
            
            System.Debug('utilityMethods.createPSProgressNoteTask INVOKE:  Progress Note Trigger');
            
            // Gather In-Scope Contact Records 
            for(Progress_Note__c p : lstPn) {
                clientIds.add(p.Client_Id__c);  
            }
            
            List<Contact> lstContacts = [SELECT Id, Client_Status__c, Team_Leader__c, Case_Coordinator__c FROM Contact WHERE Id IN :clientIds];
            //List<Task> lstTsk = [SELECT Id, WhoId, RecordTypeId, ActivityDate FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND OwnerId = :UserInfo.getUserId()];
            
            // Parse through Event List for Clients and re-fire back into the Event-side of this method
            List<Event> lstEvents = [SELECT Subject, Id, WhoId, RecordTypeId, ActivityDate, OwnerId, ClassTypeRPT__c, Class_Category__c, Area__c  FROM Event WHERE WhoId IN :clientIds AND OwnerId = :UserInfo.getUserId() AND ActivityDate > :System.Today() ORDER BY WhoId ASC, ActivityDate ASC];
            System.Debug('utilityMethods.createPSProgressNoteTask EVENT RECALL START: ' + lstEvents.size() + ' Events');
            this.createPSProgressNoteTask(lstEvents, null);
                    
        }

    }
    
    public void createPSCRSNoteTask(List<Event> lstEvt, List<Progress_Note__c> lstPn) {
        
        Date dtCourtDate;
        Event evtSource;
        
        // Assume TRUE unless condition warrants FALSE
        Boolean createTaskFlag = true;
        Boolean bolLoopTerm = false;
        
        Set<Id> clientIds = new Set<Id>();
        List<Task> lstNewTasks = new List<Task>();
        String strTaskArea = '';
        Id lastWhoId = null;
        
        // Batchable Issue 1 - Current User is not applicable, get Event OwnerId
        Set<Id> setOwnerIds = new Set<Id>();
        if (lstEvt != null) {
            for(Event e : lstEvt) { setOwnerIds.add(e.OwnerId); }
        }
        if (lstPn != null) {
            for(Progress_Note__c pn : lstPn) { setOwnerIds.add(pn.CreatedById); }
        }
        
        // Create Map of Owner / Create Ids and Profiles
        Map<Id, User> mapUserProfiles = new Map<Id, User>(
            [SELECT Id, ProfileId FROM User WHERE Id IN :setOwnerIds]);
        
        /////////////////////////////////////
        // USE CASE 1:  Invocation of Method via Event Trigger
        /////////////////////////////////////
        if(lstEvt != null && createTaskFlag == true) {
            
            System.Debug('utilityMethods.createPSCRSNoteTask INVOKE:  Event Trigger');
            
            // Gather In-Scope Contact Records 
            for(Event e : lstEvt) {
                clientIds.add(e.WhoId); 
            }
            
            system.debug('\n\n***ERICANDY - clientIDs set: ' + clientIds + '\n');
            
            //20120208 ebg - include recordtype id when retrieving client info
            List<Contact> lstContacts = [SELECT Id, Client_Status__c, Team_Leader__c, Case_Coordinator__c, RecordTypeId FROM Contact WHERE Id IN :clientIds];
            List<Task> lstTsk = [SELECT Id, WhoId, OwnerId, RecordTypeId FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND OwnerId IN :setOwnerIds];
            List<Event> lstEvtTest = [SELECT Id, WhoId, Court_Report_Required__c, ActivityDate, Report_Type__c, ClassTypeRPT__c, Class_Category__c, OwnerId   FROM Event WHERE WhoId IN :clientIds AND ActivityDate > :System.Today() AND RecordTypeId = :utilIds.courtDate AND IsRecurrence = false ORDER BY ActivityDate ASC];
            
            // Begin Loop through Triggered Events
            for(Event evt : lstEvt) {
                
                /////////////////////////////////////
                // TEST 1(Event):  TEST THAT CURRENT USER IS NOT A CASE COORDINATOR
                /////////////////////////////////////

                // Loop through Contact List and specify record for Event scope
                Contact c;
                for(Contact cFind: lstContacts) {
                    if(evt.WhoId == cFind.Id) {
                        c = cFind;
                    } 
                }
                
                /////////////////////////////////////
                // TEST 1-1:  Task Already Created in this invocation for this client
                /////////////////////////////////////
                if(lastWhoId == evt.WhoId && bolLoopTerm == true) {
                    // TEST 1-1 FAIL - A PS PN was created for this Client within this session invocation, 
                    System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-1 FAIL:  A PS CRS was created for this client within this session invocation.  EventId = ' + evt.Id);
                } else {
                    bolLoopTerm = false;
                }
                
                /////////////////////////////////////
                // TEST 1-1A: Interrogate Event for Course Reg - Single Session OR Mandatory Class will NOT create PSPN (BT-265)
                // GED Tests and Predictor Tests no longer generate PS notes either (dvm.a.BT-0698)
                /////////////////////////////////////
                if(evt.ClassTypeRPT__c == utilIds.classSingle 
                || evt.Class_Category__c == 'Mandatory Class' 
                || evt.Class_Category__c == 'GED Test' || evt.Class_Category__c == 'GED Predictor Test'
                || evt.Class_Category__c == 'TASC Test' || evt.Class_Category__c == 'TASC Readiness Test') {
                    System.Debug('utilityMethods.createPSProgressNoteTask TEST 1-1A FAIL:  The event being processed is either a single-session or categorized as a Mandatory Class/ GED Test.  EventId = ' + evt.Id);
                    createTaskFlag = false;
                }
                
                /////////////////////////////////////
                // TEST 1-2:  Client Status Test
                /////////////////////////////////////
                System.Debug('ERICANDY - ClientId = ' + c.Id);
                if(c.Client_Status__c == 'Active' || c.Client_Status__c == 'On Program Hold' 
                || c.Client_Status__c == 'Intaked - Not Yet Active') {                
                    /////////////////////////////////////
                    // TEST 1-3:  TEST FOR ANY OPEN PS CRS TASKS FOR CURRENT USER
                    /////////////////////////////////////

                    for(Task tsk : lstTsk) {
                        
                        if(tsk.WhoId == c.Id && tsk.OwnerId == evt.OwnerId) {
                        
                            if(tsk.RecordTypeId == utilIds.psCRSNoteTask) {
                                // TEST 1-3 FAIL - There is an open PS CRS for this user that in conflict with the PS PN proposed date
                                System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-3 FAIL:  Current User already has an open PS CRS in conflict with the PS PN proposed date');
                                createTaskFlag = false;
                                break;
                            }
                        }
                        
                    }
                    
                    //////////////////////////////////////
                    // TEST 1-4:  TEST FOR OPEN COURT DATE
                    // TEST 1-5:  TEST FOR OPEN COURT DATE METRICS
                    //////////////////////////////////////
//                  List<Event> lstEvtTest = [SELECT Id, Court_Report_Required__c, ActivityDate, Report_Type__c FROM Event WHERE WhoId = :c.Id AND ActivityDate > :System.Today() AND RecordTypeId = :utilIds.courtDate ORDER BY ActivityDate ASC];

                    Integer intEvtTest = 0;
                    
                    for(Event evtTest : lstEvtTest) {
                        // Get first (next in future) event for processing
                        if(evtTest.WhoId == c.Id) {
                            intEvtTest = intEvtTest + 1;
                            evtSource = evtTest;                            
                            break;
                        }
                    }
                    
                    if(evtSource != null) {
                        if(evtSource.Report_Type__c != 'Oral' && evtSource.Court_Report_Required__c == true) {
                            
                            dtCourtDate = evtSource.ActivityDate;
                            
                            //////////////////////////////////////
                            // TEST 1-5A:  BT-109 - Check to make sure that the court date is > 8 days from the ActivityDate of the generating appointment
                            //////////////////////////////////////
                            if(dtCourtDate < evt.ActivityDate.addDays(8)) {
                                // TEST 1-5A FAIL - Court date is within 8 days of the event's activity date.
                                System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-5A FAIL:  (BT-109) The court date is within 8 days of the triggering event\'s Activity Date.');
                                createTaskFlag = false;
                            }
                            
                        } else {
                            // TEST 1-5 FAIL - Court Date Report Type is 'ORAL' OR a CRS is NOT required (Court Report Required = false)
                            System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-5 FAIL:  Court Date Report Type is ORAL OR a CRS is NOT required (Court Report Required = false)');
                            createTaskFlag = false;
                        }
                        
                    }           
                        
                    if(intEvtTest == 0) {
                        // TEST 1-4 FAIL - There is not a future court date!
                        System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-4 FAIL:  There is not a future court date assigned for this client!');
                        createTaskFlag = false;
                    }
                    
                    
                    
                    //////////////////////////////////////
                    // TEST 1-6:  Only specified Event RecordTypeIds can create a PS PN Task
                    //////////////////////////////////////
                    
                    // Modified BT-299 AAB - Remove Education and Substance Abuse per QC
                    
                    //20120208 ebg - per BT-312, do not create progress note tasks for Non-CEP clients
                    if(c.RecordTypeId == utilIds.conClient &&
                            (evt.RecordTypeId == utilIds.educationExternal
                            || evt.RecordTypeId == utilIds.educationInternal
                            || evt.RecordTypeId == utilIds.substanceAbuseExternal
                            || evt.RecordTypeId == utilIds.substanceAbuseInternal 
                            || evt.RecordTypeId == utilIds.employmentExternal 
                            || evt.RecordTypeId == utilIds.employmentInternal 
                            || evt.RecordTypeId == utilIds.mentalHealthExternal 
                            || evt.RecordTypeId == utilIds.mentalHealthInternal 
                            || (evt.RecordTypeId == utilIds.courseCatalogClass && evt.ClassTypeRPT__c != utilIds.classSingle))) {
                        
                        // Removed BT-299 AAB
                        if(evt.RecordTypeId == utilIds.educationExternal || evt.RecordTypeId == utilIds.educationInternal) {
                            strTaskArea = ' - Education';
                        }
                        
                        if(evt.RecordTypeId == utilIds.employmentExternal || evt.RecordTypeId == utilIds.employmentInternal) {
                            //20120208 ebg - per BT-312, do not create employment progress notes for Non-CEP clients
                            //strTaskArea = ' - Employment';
                            //20120627 ebg - apply to all non-cep clients, not just the one record type "Non CEP Client"
                            //if (c.RecordTypeId == utilIds.conNonCEPClient) {
                            //if (utilIds.setNonCEPClientIds.contains(c.RecordTypeId)) {
                            if (c.RecordTypeId != utilIds.conClient) {
                                System.Debug('utilityMethods.createPSCRSNoteTask TEST FAIL (Employment 2):  Non-CEP clients should not have Employment progress notes created');
                                createTaskFlag = false;
                            } else {
                                strTaskArea = ' - Employment';
                            }
                        }
                        
                        if(evt.RecordTypeId == utilIds.mentalHealthExternal || evt.RecordTypeId == utilIds.mentalHealthInternal) {
                            strTaskArea = ' - Mental Health';
                        }
                        
                        // Removed BT-299 AAB
                        if(evt.RecordTypeId == utilIds.substanceAbuseExternal || evt.RecordTypeId == utilIds.substanceAbuseInternal) {
                            strTaskArea = ' - Substance Abuse';
                        }
                        
                        // Added from the PSPN Task per Patrick 20120309
                        if(evt.RecordTypeId == utilIds.courseCatalogClass) {
                            strTaskArea = ' - ' + evt.Area__c;
                        }
                        
                    } else {
                        // TEST 1-6 FAIL - This event cannot create a PS PN Task (Non-Matching RecordTypeId)
                        System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-6 FAIL:  This Event is not within the list of allowed RecordTypeIds to create a PS CRS Note Task');
                        createTaskFlag = false;
                    }
                    
                } else {
                    // TEST 1-2 FAIL
                    System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-2 FAIL:  Client Status is not Active or on Hold');
                    createTaskFlag = false;
                }
                
                //////////////////////////////////////
                // TEST 1-6:  Check Administrative Override
                //////////////////////////////////////
                if(evt.Subject == 'Education Assessment' || evt.Subject == 'Substance Abuse Assessment') {
                    // TEST 1-6 FAIL
                    System.Debug('utilityMethods.createPSCRSNoteTask TEST 1-6 FAIL:  An administrative flag has been thrown for this Event, no task created');
                    createTaskFlag = false;
                }
                
                // Final Processing of PS PN Task
                if(createTaskFlag == true && bolLoopTerm == false) {
                
                    System.debug('utilityMethods.createPSCRSNoteTask CASE 1 (Event-Triggered) SUCCESS - Building PSCRS Note Task Object');
                
                    Task thisTask = new Task();
                    thisTask.WhoId = c.Id;
                    thisTask.recordTypeId = utilIds.psCRSNoteTask;
                    thisTask.ActivityDate = dtCourtDate.addDays(-8); 
                    // changed 4/22/13 MB from system.today(). This prevents notes from being open
                    // when they cannot be closed, which was originally intended to give PS staff the ability to create
                    // notes and re-save them later. 
                    thisTask.Open_Date__c = dtCourtDate.addDays(-13);
                    //thisTask.Verification_Date__c = dtCourtDate.addDays(-8);     
                    thisTask.Automatically_Generated__c = true;
                    thisTask.Subject = 'PS CRS Note' + strTaskArea;
                    thisTask.Task_source__c = evtSource.Id;
                    thisTask.SkipRestrictions__c = true;
                    thisTask.OwnerId = evt.OwnerId;
                    
                    //lstNewTasks.add(thisTask);
                    insert thisTask;
                    
                    // Track Current WhoId for test tagging in the event of a PN-invoked action
                    lastWhoId = c.Id;
                    bolLoopTerm = true;
                }
            }
        }
        
        /////////////////////////////////////
        // USE CASE 2:  Invocation of Method via Progress Note Trigger
        /////////////////////////////////////
        if(lstPn != null && createTaskFlag == true) {
            
            System.Debug('utilityMethods.createPSCRSNoteTask INVOKE:  Progress Note Trigger');
            
            // Gather In-Scope Contact Records 
            for(Progress_Note__c pn : lstPn) {
                clientIds.add(pn.Client_Id__c); 
            }
            
            List<Contact> lstContacts = [SELECT Id, Client_Status__c, Team_Leader__c, Case_Coordinator__c FROM Contact WHERE Id IN :clientIds];
            List<Task> lstTsk = [SELECT Id, WhoId, RecordTypeId FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND OwnerId IN :setOwnerIds];
            List<Event> lstEvtTest = [SELECT Id, WhoId, Court_Report_Required__c, ActivityDate, Report_Type__c, ClassTypeRPT__c, Class_Category__c   FROM Event WHERE WhoId IN :clientIds AND ActivityDate > :System.Today() AND RecordTypeId = :utilIds.courtDate ORDER BY ActivityDate ASC];
            
            // Begin Loop through Triggered Events
            for(Progress_Note__c pn : lstPn) {
                
                /////////////////////////////////////
                // TEST 1(PN):  TEST THAT CURRENT USER IS NOT A CASE COORDINATOR
                /////////////////////////////////////
                if(mapUserProfiles.get(pn.CreatedById).ProfileId == utilIds.caseCoordinatorStaff) {
                    // TEST 1(PN) FAIL - User is a Case Coordinator
                    System.Debug('utilityMethods.createPSCRSNoteTask TEST 1(PN) FAIL:  Current User is a Case Coordinator');
                    createTaskFlag = false;
                }
                
                // Loop through Contact List and specify record for Event scope
                Contact c;
                for(Contact cFind: lstContacts) {
                    if(pn.Client_Id__c == cFind.Id) {
                        c = cFind;
                    } 
                }
                
                /////////////////////////////////////
                // TEST 2-1:  TEST FOR ANY OPEN PS CRS TASKS FOR CURRENT USER
                /////////////////////////////////////
                for(Task tsk : lstTsk) {
                    
                    if(tsk.RecordTypeId == utilIds.psCRSNoteTask && tsk.WhoId == c.Id && tsk.OwnerId == pn.CreatedById) {
                        // TEST 2-1 FAIL - There is an open PS CRS for this user that in conflict with the PS PN proposed date
                        System.Debug('utilityMethods.createPSCRSNoteTask TEST 2-1 FAIL:  Current User already has an open PS CRS open');
                        createTaskFlag = false;
                        break;
                    }
                
                }
                
                //////////////////////////////////////
                // TEST 2-2:  TEST FOR OPEN COURT DATE
                // TEST 2-3:  TEST FOR OPEN COURT DATE METRICS
                //////////////////////////////////////
//              List<Event> lstEvtTest = [SELECT Id, Court_Report_Required__c, ActivityDate, Report_Type__c FROM Event WHERE WhoId = :c.Id AND ActivityDate > :System.Today() AND RecordTypeId = :utilIds.courtDate ORDER BY ActivityDate ASC];
                
                Integer intEvtTest = 0;
                
                for(Event evtTest : lstEvtTest) {
                    // Get first (next in future) event for processing
                    if(evtTest.WhoId == c.Id) {
                        evtSource = evtTest;
                        intEvtTest = intEvtTest + 1;                            
                        break;
                    }
                }
                if(evtSource != null) {
                
                    if(evtSource.Report_Type__c != 'Oral' && evtSource.Court_Report_Required__c == true) {
                        
                        dtCourtDate = evtSource.ActivityDate;
                        
                    } else {
                        // TEST 2-3 FAIL - Court Date Report Type is 'ORAL' OR a CRS is NOT required (Court Report Required = false)
                        System.Debug('utilityMethods.createPSCRSNoteTask TEST 2-3 FAIL:  Court Date Report Type is ORAL OR a CRS is NOT required (Court Report Required = false)');
                        createTaskFlag = false;
                    }
                }
                    
                if(intEvtTest == 0) {
                
                    // TEST 2-2 FAIL - There is not a future court date!
                    System.Debug('utilityMethods.createPSCRSNoteTask TEST 2-2 FAIL:  There is not a future court date assigned for this client!');
                    createTaskFlag = false;
                    
                }
                
                // Final Processing of PS CRS Task
                if(createTaskFlag == true) {
                
                    System.debug('utilityMethods.createPSCRSNoteTask CASE 2 (Progress Note-Triggered) SUCCESS - Building PSCRS Note Task Object');
                
                    Task thisTask = new Task();
                    thisTask.WhoId = c.Id;
                    thisTask.recordTypeId = utilIds.psCRSNoteTask;
                    thisTask.ActivityDate = dtCourtDate.addDays(-8); 
                    // changed 4/22/13 MB from system.today(). This prevents notes from being open
                    // when they cannot be closed, which was originally intended to give PS staff the ability to create
                    // notes and re-save them later. 
                    thisTask.Open_Date__c = dtCourtDate.addDays(-13);
                    //thisTask.Verification_Date__c = dtCourtDate.addDays(-8);     
                    thisTask.Automatically_Generated__c = true;
                    thisTask.Subject = 'PS CRS Note - (Class Area Not Developed Yet)';
                    thisTask.SkipRestrictions__c = true;
                    thisTask.OwnerId = pn.CreatedById;
                    
                    lstNewTasks.add(thisTask);
                }
                
            }
            
        }
        
        // Insert Tasks
        if(lstNewTasks.size() > 0) { insert lstNewtasks; }
        
    }
    
    public void closePSPNNoteTask(List<Progress_Note__c> lstPN) {
        
        //////////////////////////////////////////////////////
        // Close Logic based on Progress_Note__c trigger
        //////////////////////////////////////////////////////
        
        Set<Id> clientIds = new Set<Id>();
        
        if(lstPN != null) {
            
            // Create Set of related Contact Ids and pull full list of Tasks within scope
            for(Progress_Note__c p : lstPN) {
                clientIds.add(p.Client_Id__c);  
            }
            List<Task> lstPNTasks = [SELECT Id, WhoId, ActivityDate, Status, Status__c, Closing_Date__c, 
            Closed_by_system__c, SkipRestrictions__c,ClassTypeRPT__c 
            FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND RecordTypeId = :utilIds.psProgressNoteTask AND OwnerId = :UserInfo.getUserId()];
            
            // Begin Loop through List<Progress_Note__c>
            for(Progress_Note__c p : lstPN) {
                
                // Only perform these actions if the Progress Note is a PS Progress Note Record Type
                if(p.RecordTypeId == utilIds.progressNotePSPN) {
                    
                    for(Task t : lstPNTasks) {
                        
                        // Only perform these actions if the Task belongs to the same client as the Progress Note (safety check)
                        if(t.WhoId == p.Client_Id__c) {
                            
                            // Check to see if the user completed the PN on time
                            if(System.Today() <= t.ActivityDate) {
                                t.Status = 'DONE ON TIME';
                                t.Status__c = 'DONE ON TIME';
                                t.SkipRestrictions__c = true;
                            }
                            
                            // Check to see if the user completed the PN LATE.
                            if(System.Today() > t.ActivityDate) {
                                t.Status = 'DONE LATE';
                                t.Status__c = 'DONE LATE';
                                t.SkipRestrictions__c = true;
                            }
                            
                            t.Closed_by_system__c = true;  
                            t.Closing_Date__c = System.Today();
                        }
                    }
                }
            }
            
            // Update List<Task>
            update lstPNTasks;
            
            // Find next events that the running user has with the client, create new PSPNs if necessary
            //List<Event> lstEvents = [SELECT Id, WhoId, WhatId, ActivityDate, RecordTypeId, OwnerId FROM Event WHERE WhoId IN :clientIds AND OwnerId = :UserInfo.getUserId() AND ActivityDate > :System.Today()];
            createPSProgressNoteTask(null,lstPn);
            
        }
    }
    
    public void closePSCRSNoteTask(List<Progress_Note__c> lstPn) {
        
        Set<Id> clientIds = new Set<Id>();
        Boolean boolCreatePSPNNoteTask = false;
            
        // Create Set of related Contact Ids and pull full list of Tasks within scope
        for(Progress_Note__c p : lstPN) {
            clientIds.add(p.Client_Id__c);  
        }
        
        // Pull a list of all Tasks in Client, Open, RecordType = psCRSNoteTask, and OwnerId = running user
        List<Task> lstCRSTasks = [SELECT Id, Status, WhoId, ActivityDate, Status__c, Closing_Date__c, Closed_by_system__c, 
        SkipRestrictions__c FROM Task WHERE WhoId IN :clientIds AND IsClosed = false AND RecordTypeId = :utilIds.psCRSNoteTask AND OwnerId = :UserInfo.getUserId()];
            
        // Loop through the records in scope and close out CRS Note Tasks
        for(Progress_Note__c p : lstPN) {
            
            if(p.RecordTypeId == utilIds.progressNotePSCRS) {

                for(Task t : lstCRSTasks) {
                
                    if(t.WhoId == p.Client_Id__c) {
                        
                        if(System.Today() >= t.ActivityDate.addDays(-5)) {
                        
                            if(System.Today() <= t.ActivityDate) {
                                t.Status = 'DONE ON TIME';
                                t.Status__c = 'DONE ON TIME';
                                t.SkipRestrictions__c = true;
                            }
                                        
                            if(System.Today() > t.ActivityDate) {
                                t.Status = 'DONE LATE';
                                t.Status__c = 'DONE LATE';
                                t.SkipRestrictions__c = true;
                            }
                            
                            t.Closed_by_system__c = true;  
                            t.Closing_Date__c = System.Today();
                            boolCreatePSPNNoteTask = true;
                        }
                    }
                }
            }
        }
            
        if(lstCRSTasks.size() > 0) { update lstCRSTasks; }
        
        /////////////////////////////////
        // Create new PS PN Note
        /////////////////////////////////
        if(boolCreatePSPNNoteTask == true) {
            createPSProgressNoteTask(null, lstPn);  
        }
        
    }
    
    public void closePSCRSNoteTaskAll(List<Event> lstEvt) {
        
        //////////////////////////////////////////////////////
        // Global "Close All" PS CRS logic on Court Date Event
        // Created 20110309 AAB - DCS
        //////////////////////////////////////////////////////
        Set<Id> clientIds = new Set<Id>();
        
        for(Event e : lstEvt) {
            clientIds.add(e.WhoId); 
        }
        
        List<Task> lstPSCRSTasks = [SELECT Id, WhoId, Status, Status__c, Closing_Date__c, Closed_by_system__c, 
        SkipRestrictions__c, Outcome__c, ActivityDate FROM Task WHERE WhoId IN :clientIds AND RecordTypeId = :utilIds.psCRSNoteTask AND IsClosed = false];      
        
        for(Event evtSource : lstEvt) {
            
            if(evtSource.RecordTypeId == utilIds.courtDate && evtSource.Outcome__c != 'Pending' && evtSource.Court_Report_Required__c == true) {
                
                // Get list of PS PN Tasks for this Contact to close                
                for(Task psCRSTask: lstPSCRSTasks) {
                    
                    if(psCRSTask.WhoId == evtSource.WhoId) {
                        
                        // 20120119 - BT-297 Corrected to reflect the Task Status of "Not Started" and the Actual Court Date
                        if(psCRSTask.Status == 'Not Started' && psCRSTask.ActivityDate < evtSource.StartDateTime.Date()) {
                            psCRSTask.Status = 'Incomplete';
                            //psCRSTask.Status__c = 'CANCELLED';
                            psCRSTask.Closed_by_system__c = true;  
                            psCRSTask.Closing_Date__c = System.Today();
                            psCRSTask.SkipRestrictions__c = true;
                        }
                    }
                }
                
                update lstPSCRSTasks;
                
            }
        }
    }

    public void createIncidentReportNoteTask(List<Incident_Participation__c> lstParticipants) {
        
        
        List<Task> lstNewTasks = new List<Task>();

        for(Incident_Participation__c part: lstParticipants) {
            
            Task thisTask = new Task();
            thisTask.WhoId = part.Client__c;
            thisTask.recordTypeId = utilIds.incidentReportNoteTask;
            thisTask.ActivityDate = getNextWorkingDayfromDate(system.today().addDays(1));
            thisTask.Open_Date__c = system.Today();  
            thisTask.Automatically_Generated__c = true;
            thisTask.Subject = 'Incident Report Note';
            thisTask.Task_source__c = part.Id;
            thisTask.SkipRestrictions__c = true;
            thisTask.OwnerId = part.Incident_Owner__c;
            
            lstNewTasks.add(thisTask);         
        }
        
        insert lstNewTasks;

    }    
    
    public void closeIncidentNoteTask(List<Progress_Note__c> lstPN) {
        

        Set<Id> clientIds = new Set<Id>();
        
        if(lstPN != null) {
            
            // Get client Ids
            for(Progress_Note__c p : lstPN) {
                clientIds.add(p.Client_Id__c);  
            }
            
            //get related tasks
            List<Task> lstPNTasks = [SELECT Id, Status, WhoId, ActivityDate, Closed_by_system__c, 
                                     Closing_Date__c, SkipRestrictions__c
                                     FROM Task WHERE WhoId IN :clientIds AND IsClosed = false 
                                     AND RecordTypeId = :utilIds.incidentReportNoteTask];
            
            for(Progress_Note__c p : lstPN) {
          
                if(p.RecordTypeId == utilIds.progressNoteIncidentReport ) {
                    
                    for(Task t : lstPNTasks) {
                        
                        if(t.WhoId == p.Client_Id__c) {
                            
                            if(System.Today() <= t.ActivityDate) {
                                t.Status = 'DONE ON TIME';
                                t.Status__c = 'DONE ON TIME';
                                t.SkipRestrictions__c = true;
                            }
                            
                            if(System.Today() > t.ActivityDate) {
                                t.Status = 'DONE LATE';
                                t.Status__c = 'DONE LATE';
                                t.SkipRestrictions__c = true;
                            }
                            
                            t.Closing_Date__c = System.Today();
                            t.Closed_by_system__c = true;
                        }
                    }
                }   
            }
            
            //dml
            update lstPNTasks;
        }  
    }  


    public static Date FindPreviousWorkDate(Date dteInput){
        
        List<Holidays__c> holidayList = [Select Date__c from Holidays__c 
            where Date__c <= :dteInput and Date__c >= :dteInput.addDays(-14)
            // 3/25/13 MB: as per prod.a.BT-1009, classes are now scheduled on holidays
            // of the type "Court Closed" (Veterans Day, Election Day) when CASES and other offices
            // are most likely open. Staff have been instructed to manually cancel sessions if need be. 
            and Type__c != 'Court Closed'
            order by Date__c DESC];   
        
        //Loop through holidays in this date range
        for (Holidays__c h : holidayList){
            System.debug('Holiday1');
            //if the input date falls on a holiday, set it back one day
            //since this is sorted descending, this should set this back up to 14 times
            //if there are back to back holidays (which should do it)
            if (dteInput == h.Date__c){
                dteInput = dteInput.addDays(-1);
                System.debug('Holiday2');
            }
        }
        Date dteWeekStart = dteInput.toStartOfWeek();
        System.debug('Finding previous...' +dteInput.daysBetween(dteWeekStart));
        //If this is a Sunday...
        if (dteInput.daysBetween(dteWeekStart) == 0){
            dteInput = dteInput.addDays(-2);
        }
        //If this is a Saturday...
        if (dteInput.daysBetween(dteWeekStart) == 6 || dteInput.daysBetween(dteWeekStart) == -6){
            dteInput = dteInput.addDays(-1);
        }
        
        //Just in case the new date is now on a holiday...
        for (Holidays__c h : holidayList){
            //if so, back to the beginning
            if (dteInput == h.Date__c){
                dteInput = FindPreviousWorkDate(dteInput);
            }
        }
        
        return dteInput;
    }

    public static Integer getDayOfWeek(Date dteTargetDate) {

        ///////////////////////////////////////////
        // This method returns an Integer value of 0-6 for the corresponding day of the week (0-based)
        // Author:  AAB / DCS
        // Created:  20110325
        ///////////////////////////////////////////
        
        Integer intDayOfWeek;
        DateTime dtmTargetDate = dteTargetDate;
        
        if(dtmTargetDate.formatGmt('EEEE') == 'Sunday') {
            intDayOfWeek = 0;
        }
        if(dtmTargetDate.formatGmt('EEEE') == 'Monday') {
            intDayOfWeek = 1;
        }
        if(dtmTargetDate.formatGmt('EEEE') == 'Tuesday') {
            intDayOfWeek = 2;
        }
        if(dtmTargetDate.formatGmt('EEEE') == 'Wednesday') {
            intDayOfWeek = 3;
        }
        if(dtmTargetDate.formatGmt('EEEE') == 'Thursday') {
            intDayOfWeek = 4;
        }
        if(dtmTargetDate.formatGmt('EEEE') == 'Friday') {
            intDayOfWeek = 5;
        }
        if(dtmTargetDate.formatGmt('EEEE') == 'Saturday') {
            intDayOfWeek = 6;
        }
        
        //Date dteStartOfWeek = dteTargetDate.toStartOfWeek();
            
        //Integer intDayOfWeek = dteStartOfWeek.Day() - dteTargetDate.Day();
        
        System.Debug('TESTING - Target Date = ' + dtmTargetDate + ' Day of Week = ' + intDayOfWeek);
        
        return intDayOfWeek; 
        
    }

    public Map<Date, Id> validateHolidayDate() {
        
        Map<Date, ID> mapResult = new Map<Date, ID>();
        
        List<Holidays__c> lstHolidays = [SELECT Id, Date__c FROM Holidays__c];
        
        for(Holidays__c h: lstHolidays) {
            
            mapResult.put(h.Date__c, h.Id);
        }
        
        return mapResult;
    }


    public Date getNextWorkingDayFromDate(Date dte) {

        Date nextDay = dte.addDays(1);
        Integer iDOW = getDayOfWeek(nextDay);
        Map<Date, Id> mapHolidays = new Map<Date, ID>(validateHolidayDate());

        //make sure the next day isn't Sunday (0) or Saturday (6)
        while (iDOW == 0 || iDOW == 6) {

            nextDay = nextDay.addDays(1);
            iDOW = getDayOfWeek(nextDay);
            system.debug('\n\nInside iDOW while loop.  nextDay: ' + nextDay + '   DOW: ' + iDOW);

        }
        
        //make sure the next day isn't a holiday
        Boolean bIsWorkingDay = !mapHolidays.containsKey(nextDay);

        while (bIsWorkingDay == false) {
            
            nextDay = nextDay.addDays(1);
            bIsWorkingDay = !mapHolidays.containsKey(nextDay);
            
        }
        
        return nextDay;
        
    }
    
    public static Date getFutureWorkingDayFromDate(Date dteStart, Integer intDaysOut) {
        
        Date dteWorking;
        Set<Date> setHolidays = new Set<Date>();
        
        for(Holidays__c h : [SELECT Name, Date__c FROM Holidays__c]) { setHolidays.add(h.Date__c); }
        
        Integer iDays = 1;
        do {
            dteWorking = dteStart.addDays(iDays);
            
            // Check to see if the date is a holiday, Saturday, or Sunday - if so, increment intDaysOut
            if(setHolidays.contains(dteWorking) || getDayOfWeek(dteWorking) == 0 || getDayOfWeek(dteWorking) == 6) {
                intDaysOut += 1;
            }
            
            iDays += 1;
            
        } while(iDays <= intDaysOut);
        
        return dteWorking;
        
    }


    public date clientCalendarStartDate(Date dteBegin) {

        ///////////////////////////////////////////
        // This method returns a date value - the first Monday (or day in the custom settings "Calendar Settings") closest to the given date
        // Author:  EBG / DCS
        // Created:  20110428
        ///////////////////////////////////////////
        String dayOfWeek;
        //10/29/13 MB: add 12 hours to date time to account for rare situation where daylight savings time causes 
        //midnight-based calculations to use the wrong day
        Datetime dummyDateTime = Datetime.newInstance(dteBegin.year(), dteBegin.month(), dteBegin.day(), 12, 1, 1);
        Date startDate;
        dayOfWeek = 'Monday';
        //9/5/13 MB remove client calendar custom setting, hasn't been altered in two years
        
        //starting with provided date, loop through the next 7 days until you find Monday/start of week
        for (Integer i=0; i<7; i++) {           
            
            if (dummyDateTime.addDays(i).format('EEEE') == dayOfWeek) {
                startDate = dummyDateTime.addDays(i).date();
                break;
            }
        }
        
        return startDate;
    }
    

    public date clientCalendarEndDate(Date dteBegin) {

        ///////////////////////////////////////////
        // This method returns a date value - the first Sunday (or day in the custom settings "Calendar Settings") closest to the given date
        // Author:  EBG / DCS
        // Created:  20110428
        ///////////////////////////////////////////
        Datetime dummyDateTime = Datetime.newInstance(dteBegin.year(), dteBegin.month(), dteBegin.day());
        String dayOfWeek;
        Integer iWeeks;
        Integer iOffset;
        Date endDate;
        dayOfWeek = 'Sunday';
        iWeeks = 1;
        //get custom setting for last day of the week
        //9/5/13 MB remove client calendar custom setting, hasn't been altered in two years

        
        //set the number of days to offset the end date so we are showing the proper range
        //If we want to show 1 week, our offset is 0 because we are already showing 1 week
        //If we want to show more than a week, the offset is days in a week (7) * number of weeks to display minus 
        //      the first week which we've already accounted for
        iOffset = 7 * (iWeeks - 1);
        
        //starting with the provided date, loop through the next 7 days until you find Sunday/end of week
        //then move out the number of weeks set in the custom seting
        for (Integer i=0; i<7; i++) {
            if (dummyDateTime.addDays(i).format('EEEE') == dayOfWeek) {
                endDate = dummyDateTime.addDays(i).date();
                break;
            }
        }
        
        endDate = endDate.addDays(iOffset);
        
        return endDate;
    }
    
    //given a date, return it in the format "yyyy-MM-dd"
    public String dateToString(Date dtDate) {
        String sYear = dtDate.year().format();
        //get rid of the comma for the thousands separator
        sYear = sYear.replace(',', '');
        String sMonth = dtDate.month().format();
        if (dtDate.month() < 10) {
            sMonth = '0' + sMonth;
        }
        String sDay = dtDate.day().format();
        if (dtDate.day() < 10) {
            sDay = '0' + sDay;
        }
        String sReturnDate = sYear + '-' + sMonth + '-' + sDay;
        
        return sReturnDate;     
    }
    
    public Date dateTimetoDate(DateTime dt) {
        
        Date returnDate = date.newInstance(dt.year(), dt.month(), dt.day());
        return returnDate;
    }
    
    
    ///////////////////////////////////////////
    // This method returns blank string as a null
    // Author:  EBG / DCS
    // Created:  20110517
    ///////////////////////////////////////////
    public String blankToNull(String sValue) {
        if (sValue == '') {
            return null;
        } else {
            return sValue;
        }
    }
    
    ///////////////////////////////////////////
    // This method returns null string as a blank
    // Author:  EBG / DCS
    // Created:  20110517
    ///////////////////////////////////////////
    public String nullToBlank (String sValue) {
        if (sValue == null) {
            return '';
        } else {
            return sValue;
        }
    }
    
    public void updateDiplomaFieldsOnContact() {
        
        List<education__c> lstAllEdu = new List<education__c>();
        List<test__c> lstAllTest = new List<test__c>();
        List<Id> lstContactIds = new List<Id>();
        List<contact> lstContactsToCheck = new List<contact>();
        List<contact> lstContactsToUpdate = new List<contact>();    
        
        
        For(Education__c e: lstUpdatedEdu) {
        
            lstContactIds.add(e.Client__c);     
        }
        
            
        For(Test__c t: lstUpdatedTest) {
            
            lstContactIds.add(t.Contact__c);            
        }           
        
        
        lstAllEdu = [Select Id, Client__c, End_Date__c, Diploma_Type__c from Education__c 
        where End_Date__c != null and Diploma_Type__c != null and Client__c in :lstContactIds];
        
        lstAllTest = [Select Id, Contact__c, Test_Date__c, Test_Type__c, Result__c from Test__c 
        where Test_Type__c in ('GED', 'TASC Test') and Result__c = 'Pass' and Contact__c in :lstContactIds];
        
        lstContactsToCheck = [Select Id, Diploma_Type__c, Diploma_Date__c from Contact 
        where Id in :lstContactIds];
        
        for(Contact c: lstContactsToCheck) {
            
            string strDiplomaType = null;
            date dteDiplomaDate = null;
                
            for(Education__c e: lstAllEdu) {
            
                if ((dteDiplomaDate == null || e.End_Date__c> dteDiplomaDate) && c.Id == e.Client__c) {
                    
                    dteDiplomaDate = e.End_Date__c;
                    strDiplomaType = e.Diploma_Type__c;     
                }       
            }
        
            for(Test__c t: lstAllTest) {
                
                if ((dteDiplomaDate == null || t.Test_Date__c> dteDiplomaDate) && c.Id == t.Contact__c) {
                    
                    dteDiplomaDate = t.Test_Date__c;
                    strDiplomaType = 'HSE Diploma';     
                }       
            }           
                    
            if(strDiplomaType != c.Diploma_Type__c || dteDiplomaDate != c.Diploma_Date__c) {
                
                c.Diploma_Type__c = strDiplomaType;
                c.Diploma_Date__c = dteDiplomaDate;
                lstContactsToUpdate.add(c);
                
            }   
        }
    
        if (lstContactsToUpdate.size()> 0) {    
        
            update lstContactsToUpdate;     
        }
        
    }
    
        public void closeEdVisitTaskAll(List<Event> lstEvt, List<Event> lstOldEvents, Boolean isInsert) {
        
        //////////////////////////////////////////////////////
        // Close All Ed Visit Tasks for client when Ed Visit Event is completed
        // Created 12/5/12 MB
        //////////////////////////////////////////////////////
        
        List<Task> lstTaskstoUpdate = new List<Task>();
        Set<Id> clientIds = new Set<Id>();
        
        // Create Set of related Contact Ids and pull full list of Tasks within scope
        for(Event e : lstEvt) {
            clientIds.add(e.WhoId); 
        } 
        
        // Get list of all tasks within contact scope       
        List<Task> lstEdVisitTasks = [SELECT Id, WhoId, WhatId, Status, Status__c, Closing_Date__c, Open_Date__c,
                                      Closed_by_system__c, SkipRestrictions__c, Outcome__c, ActivityDate 
                                      FROM Task WHERE WhoId IN :clientIds 
                                      AND RecordTypeId = :utilIds.schoolVisitTask AND IsClosed = false];
        
        for(Event evtSource : lstEvt) {
            
            integer i = 0;
                        
            // 3/13/13 MB: added isInsert because ed visits created as "attended" 
            // were not triggering the task closures
            if(evtSource.RecordTypeId == utilIds.educationExternal && evtSource.Subject == 'Ed Program Visit'
            && evtSource.Verification_Status__c == 'Attended' 
            && (isInsert || lstOldEvents[i].Verification_Status__c != 'Attended'
                // 4/9/13 MB: added for cases when wrong school is selected (given that there are many dupes)
                || evtSource.whatId != lstOldEvents[i].whatId )) {
                
                for(Task t: lstEdVisitTasks) {
                    
                    if(t.WhoId == evtSource.WhoId && t.whatId == evtSource.WhatId 
                    && evtSource.ActivityDate >= t.Open_Date__c) {
                    // Check to see if the user completed visit before the task was due
                            if(evtSource.ActivityDate <= t.ActivityDate) {
                                t.Status = 'DONE ON TIME';
                                t.Status__c = 'DONE ON TIME';
                                t.SkipRestrictions__c = true;
                            }
                            
                            // Check to see if the user completed visit after the task was due
                            else if(evtSource.ActivityDate > t.ActivityDate) {
                                t.Status = 'DONE LATE';
                                t.Status__c = 'DONE LATE';
                                t.SkipRestrictions__c = true;
                            }
                            
                            t.Closed_by_system__c = true;  
                            t.Closing_Date__c = System.Today();
                            lstTaskstoUpdate.add(t);
                    }
                }
            }
            
            i++;
        }
        
        if(lstTaskstoUpdate.size() > 0) {
            update lstTaskstoUpdate;
        }
    }
        
}