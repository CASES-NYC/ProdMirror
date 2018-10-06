public class utilityIds {

    
    /////////////////////////////////////////////////////////////
    /// Contact
    /////////////////////////////////////////////////////////////
     
        public Id conMNChoices = Utility_ID__c.getValues('Manhattan Choices Client').RecordType_Id__c;  
        public Id conChoices = Utility_ID__c.getValues('Manhattan Choices Client').RecordType_Id__c;  
        public Id conBXChoices = Utility_ID__c.getValues('Bronx Choices Client').RecordType_Id__c;  
        public Id conClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;    
        public Id conNonCEPClient = Utility_ID__c.getValues('Non CEP Client').RecordType_Id__c;
        public Id conCJC = Utility_ID__c.getValues('Civic Justice Corps Client').RecordType_Id__c;
        public Id conJS = Utility_ID__c.getValues('Justice Scholars Client').RecordType_Id__c;
        public Id conQJC = Utility_ID__c.getValues('Queens Justice Corps Client').RecordType_Id__c;
        public Id conDTC = Utility_ID__c.getValues('DTC Client').RecordType_Id__c;
        public Id conCCM = Utility_ID__c.getValues('CCM Client').RecordType_Id__c;
        public Id conTRP = Utility_ID__c.getValues('TRP Client').RecordType_Id__c;     
        public Id conJudge = Utility_ID__c.getValues('Judge').RecordType_Id__c;
        public Id conAttorney = Utility_ID__c.getValues('Attorney/ Law Guardian').RecordType_Id__c;
        public Id conACT = Utility_ID__c.getValues('Nathaniel ACT Client').RecordType_Id__c;
        public Id conCRT = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c;
        public Id conPRP = Utility_ID__c.getValues('PRP Cycle').RecordType_Id__c;
        public Id conAPT = Utility_ID__c.getValues('APT Client').RecordType_Id__c; 
        public Id conFCS = Utility_ID__c.getValues('FCS Client').RecordType_Id__c;
        public Id conBJC = Utility_ID__c.getValues('BJC Client').RecordType_Id__c;
        public Id conJAG = Utility_ID__c.getValues('JAG Client').RecordType_Id__c;
        public Id conCITE = Utility_ID__c.getValues('CITE Client').RecordType_Id__c;
        public set<Id> lstClientRecordTypes = new set<Id>{conMNChoices, conBXChoices, conClient, conNonCEPClient, conCJC, 
            conJS, conQJC, conDTC, conCCM, conTRP, conACT, conCRT, conPRP, conAPT, conFCS, conBJC};
            
          
    /////////////////////////////////////////////////////////////
    /// Account
    /////////////////////////////////////////////////////////////  
    
        public Id accExternalEntities = Utility_Id__c.getValues('External Entities').RecordType_Id__c;
        public Id accCASESPrograms = Utility_Id__c.getValues('CASES Programs').RecordType_Id__c;
        public Id accClient = Utility_Id__c.getValues('Client').RecordType_Id__c;
        
    /////////////////////////////////////////////////////////////
    /// Program Cycle
    /////////////////////////////////////////////////////////////  
    
        public Id progCycleChoices = Utility_ID__c.getValues('Choices Cycle').RecordType_Id__c;   
        public ID progCycleCCMVoluntary = Utility_ID__c.getValues('CCM Voluntary Cycle').RecordType_Id__c; 
        public Id progCycleDTC = Utility_ID__c.getValues('DTC Cycle').RecordType_Id__c;   
        public Id progCycleCCM = Utility_ID__c.getValues('CCM Cycle').RecordType_Id__c;   
        public Id progCycleTRP = Utility_ID__c.getValues('TRP Cycle').RecordType_Id__c;                             
        public Id progCycleCRT = Utility_ID__c.getValues('CRT Cycle').RecordType_Id__c;                
        
    /////////////////////////////////////////////////////////////
    /// Case Information
    /////////////////////////////////////////////////////////////
    
        public Id caseInfoFamilyCourt = Utility_ID__c.getValues('Case - Family Court').RecordType_Id__c;
        public Id caseInfoSupremeCourt = Utility_ID__c.getValues('Case - Supreme Court').RecordType_Id__c;
        //added 7/16/13 MB
        public Id caseInfoCriminalCourt = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
        
     
    /////////////////////////////////////////////////////////////
    /// Program Plan
    /////////////////////////////////////////////////////////////
     
        public Id programPlanRecordType = Utility_ID__c.getValues('Program Plan').RecordType_Id__c;
        public Id programPlanLockedRecordType = Utility_ID__c.getValues('Program Plan - Locked').RecordType_Id__c;
        public Id programPlanYouth = Utility_ID__c.getValues('Other Youth Program Plan').RecordType_Id__c;
        public Id programPlanSTART = Utility_ID__c.getValues('START Program Plan').RecordType_Id__c;
        public Id programPlanCIRT = Utility_ID__c.getValues('CIRT Program Plan').RecordType_Id__c;

    /////////////////////////////////////////////////////////////
    /// Objectives
    /////////////////////////////////////////////////////////////
     
        public Id objectiveYouth = Utility_ID__c.getValues('Youth Objective').RecordType_Id__c;
        public Id objectiveSTART = Utility_ID__c.getValues('START Objective').RecordType_Id__c;
        public Id objectiveCIRT = Utility_ID__c.getValues('CIRT Objective').RecordType_Id__c;        
   
        
    /////////////////////////////////////////////////////////////
    /// Progress Notes
    /////////////////////////////////////////////////////////////
    
        public Id progressNoteCCPN = Utility_ID__c.getValues('CC Progress Note').RecordType_Id__c;
        public Id progressNoteCCCRS = Utility_ID__c.getValues('CC CRS Note').RecordType_Id__c;
        public Id progressNotePSPN = Utility_ID__c.getValues('PS Progress Note').RecordType_Id__c;
        public Id progressNotePSCRS = Utility_ID__c.getValues('PS CRS Note').RecordType_Id__c;
        public Id progressNoteGroup = Utility_ID__c.getValues('Group Note').RecordType_Id__c;
        public Id progressNoteCase = Utility_ID__c.getValues('Case Note').RecordType_Id__c;
        public Id progressNoteCCM = Utility_ID__c.getValues('Progress Note (CCM)').RecordType_Id__c;
        public Id progressNoteIncidentReport = Utility_ID__c.getValues('Incident Report Note').RecordType_Id__c; 
        public Id progressNoteCourt = Utility_ID__c.getValues('Court Rep Note').RecordType_Id__c; 
        public Id progressNoteCIRT = Utility_ID__c.getValues('Progress Note (CIRT)').RecordType_Id__c;         
    
    /////////////////////////////////////////////////////////////
    /// Tests
    /////////////////////////////////////////////////////////////

        public Id maysiTestRecordType = Utility_ID__c.getValues('MAYSI').RecordType_Id__c;
        public Id starTestRecordType = Utility_ID__c.getValues('STAR').RecordType_Id__c;
        public Id tabeTestRecordType = Utility_ID__c.getValues('TABE').RecordType_Id__c;
        public Id drugTestRecordType = Utility_ID__c.getValues('Drug Test').RecordType_Id__c;
        public Id gedRecordType = Utility_ID__c.getValues('GED').RecordType_Id__c;
        public Id catRecordType = Utility_ID__c.getValues('CAT').RecordType_Id__c;
        public Id TASCRecordType = Utility_ID__c.getValues('TASC').RecordType_Id__c;        
        
    /////////////////////////////////////////////////////////////
    // Event
    /////////////////////////////////////////////////////////////
    
        public ID educationExternal = Utility_ID__c.getValues('Education - External').RecordType_Id__c;
        public ID educationInternal = Utility_ID__c.getValues('Education - Internal').RecordType_Id__c;
        public ID employmentExternal = Utility_ID__c.getValues('Employment - External').RecordType_Id__c;
        public ID employmentInternal = Utility_ID__c.getValues('Employment - Internal').RecordType_Id__c;
        public ID mentalHealthExternal = Utility_ID__c.getValues('Mental Health - External').RecordType_Id__c;
        public ID mentalHealthInternal = Utility_ID__c.getValues('Mental Health - Internal').RecordType_Id__c;
        public ID substanceAbuseExternal = Utility_ID__c.getValues('Substance Abuse - External').RecordType_Id__c;
        public ID substanceAbuseInternal = Utility_ID__c.getValues('Substance Abuse - Internal').RecordType_Id__c;
        public ID caseCoordination = Utility_ID__c.getValues('Case Coordination').RecordType_Id__c;
        public ID courseCatalogClass = Utility_ID__c.getValues('Course Catalog Class').RecordType_Id__c;
        public ID courtDate = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
        public ID immediateNotification= Utility_ID__c.getValues('Immediate Notification').RecordType_Id__c;
        public ID orientationAppointment = Utility_ID__c.getValues('Orientation Appointment').RecordType_Id__c;
        public ID miscellaneousEvent = Utility_ID__c.getValues('Miscellaneous Event').RecordType_Id__c;
        public ID careerExplorationAppointment = Utility_ID__c.getValues('Career Exploration').RecordType_Id__c;
        // 1/29/13 MB: added case coordination external
        public ID caseCoordinationExternal= Utility_Id__c.getValues('Case Coordination External').RecordType_id__c;
        // 9/14.13 MB: added CC (CCM) for START
        public ID caseCoordinationCCM= Utility_Id__c.getValues('Case Coordination (CCM)').RecordType_id__c;
        // 3/6/14 MB CIRT
        public ID caseCoordinationCIRT = Utility_Id__c.getValues('Case Coordination (CIRT)').RecordType_id__c;
        public ID apptNurse = Utility_Id__c.getValues('Nurse\'s Appointment').RecordType_id__c;
        public ID apptPsych = Utility_Id__c.getValues('Psychiatrist\'s Appointment').RecordType_id__c;
        // 8/12/14 MB QJC External
        public ID apptCaseCoordinationExternalJC 
        = Utility_Id__c.getValues('Case Coordination External (JC)').RecordType_id__c;
        public ID apptCIRTExternal
        = Utility_Id__c.getValues('CIRT External').RecordType_id__c;
        // 9/4/14 new CCM types
        public ID apptCollateralContact
        = Utility_Id__c.getValues('Collateral Contact').RecordType_id__c;  
        
    /////////////////////////////////////////////////////////////
    // Task
    /////////////////////////////////////////////////////////////

        public ID mandatoryClassesTask = Utility_ID__c.getValues('Mandatory Classes Task').RecordType_Id__c;
        public ID caseCoordinatorAssessmentTask = Utility_ID__c.getValues('Case Coordinator Assessment Task').RecordType_Id__c;
        public ID employmentSurveyTask = Utility_ID__c.getValues('Employment Survey Task').RecordType_Id__c;
        public ID substanceAbuseAssessmenTask = Utility_ID__c.getValues('Substance Abuse Assessment Task').RecordType_Id__c; 
        public ID initialDrugTestTask = Utility_ID__c.getValues('Initial Drug Test Task').RecordType_Id__c; 
        public ID MAYSIAssessmentTask = Utility_ID__c.getValues('MAYSI Assessment Task').RecordType_Id__c; 
        public ID STARTestReadingTask = Utility_ID__c.getValues('STAR Test - Reading Task').RecordType_Id__c; 
        public ID STARTestMathTask = Utility_ID__c.getValues('STAR Test - Math Task').RecordType_Id__c; 
        public ID initialProgramPlanTask = Utility_ID__c.getValues('Initial Program Plan Task').RecordType_Id__c; 
        public ID educationAssessmentTask = Utility_ID__c.getValues('Education Assessment Task').RecordType_Id__c; 
        public ID mentalHealthAssessmentTask = Utility_ID__c.getValues('Mental Health Assessment Task').RecordType_Id__c; 
        public ID employmentAssessmentTask = Utility_ID__c.getValues('Employment Assessment Task').RecordType_Id__c; 
        public ID careerExplorationReferralTask = Utility_ID__c.getValues('Career Exploration Referral Task').RecordType_Id__c; 
        public ID exitNotificationTask = Utility_ID__c.getValues('Exit Notification Task').RecordType_Id__c; 
        public ID exitDrugTestTask = Utility_ID__c.getValues('Exit Drug Test Task').RecordType_Id__c; 
        public ID CBOPlacementTask = Utility_ID__c.getValues('CBO Placement Task').RecordType_Id__c; 
        public ID ccProgressNoteTask = Utility_ID__c.getValues('CC Progress Note Task').RecordType_Id__c; 
        public ID psProgressNoteTask = Utility_ID__c.getValues('PS Progress Note Task').RecordType_Id__c; 
        public ID ccCRSNoteTask = Utility_ID__c.getValues('CC CRS Note Task').RecordType_Id__c;
        public Id psCRSNoteTask = Utility_ID__c.getValues('PS CRS Note Task').RecordType_Id__c;
        public ID nextDrugTestTask = Utility_ID__c.getValues('Next Drug Test Task').RecordType_Id__c; 
        public ID rearrestCheckTask = Utility_ID__c.getValues('Rearrest Check Task').RecordType_Id__c; 
        public ID outReachNeeded = Utility_ID__c.getValues('CASES Outreach Needed').RecordType_Id__c;
        public Id schoolVisitTask  = Utility_ID__c.getValues('School Visit Task').RecordType_Id__c; 
        public Id alumniSurveyTask  = Utility_ID__c.getValues('Alumni Survey Task').RecordType_Id__c; 
        
        // 5/20/13 MB
        public Id incidentReportNoteTask  = Utility_ID__c.getValues('Incident Report Note Task').RecordType_Id__c;        
        
        // 2/6/14 MB
        public Id PHQ9Task  = Utility_ID__c.getValues('PHQ-9 Task').RecordType_Id__c; 
        public Id UCLATask  = Utility_ID__c.getValues('UCLA PTSD RI Task').RecordType_Id__c; 
        
        // 3/11/14 MB
        public Id LSCMITask  = Utility_ID__c.getValues('LS/CMI Task').RecordType_Id__c;    
                
    /////////////////////////////////////////////////////////////
    /// Profiles -
    /////////////////////////////////////////////////////////////
        
        public Id cepDirector = Utility_ID__c.getValues('CEP - Director').RecordType_Id__c;
        public Id cepDeputyDirector = Utility_ID__c.getValues('CEP - Deputy Director').RecordType_Id__c;
        public Id adminSupportSupervisor = Utility_ID__c.getValues('CEP - Admin Support Super').RecordType_Id__c;
        public Id adminSupportStaff = Utility_ID__c.getValues('CEP - Admin Support Staff').RecordType_Id__c;
        public Id substanceAbuseSupervisor = Utility_ID__c.getValues('CEP - Substance Abuse Super').RecordType_Id__c;
        public Id substanceAbuseStaff = Utility_ID__c.getValues('CEP - Substance Abuse Staff').RecordType_Id__c;
        public Id caseCoordinatorStaff = Utility_ID__c.getValues('CEP - Case Coordinator Staff').RecordType_Id__c;
        public Id caseCoordinatorSupervisor = Utility_ID__c.getValues('CEP - Case Coordinator Supervisor').RecordType_Id__c;
        public Id employmentSupervisor = Utility_ID__c.getValues('CEP - Employment Super').RecordType_Id__c;
        public Id employmentStaff = Utility_ID__c.getValues('CEP - Employment Staff').RecordType_Id__c;
        public Id educationLiaisonSupervisor = Utility_ID__c.getValues('CEP - Education Liaison Super').RecordType_Id__c;
        public Id educationLiaisonStaff = Utility_ID__c.getValues('CEP - Education Liaison Staff').RecordType_Id__c;
        public Id educationInternalSupervisor = Utility_ID__c.getValues('CEP - Education Internal Super').RecordType_Id__c;
        public Id educationInternalStaff = Utility_ID__c.getValues('CEP - Education Internal Staff').RecordType_Id__c;
        //added 7/29/15 by PR
        //education and employment staff will be combined to icd
        public Id cepIcdStaff = Utility_ID__c.getValues('CEP - ICD Staff').RecordType_Id__c;
        public Id cepIcdSupervisor = Utility_ID__c.getValues('CEP - ICD Supervisor').RecordType_Id__c;                
        public Id mentalHealthSupervisor = Utility_ID__c.getValues('CEP - Mental Health Super').RecordType_Id__c;
        public Id mentalHealthStaff = Utility_ID__c.getValues('CEP - Mental Health Staff').RecordType_Id__c;        
        public Id systemAdmin = Utility_ID__c.getValues('System Administrator').RecordType_Id__c;
        // Removed 20110518 AAB per QC
        // public Id teamLeader;
        public Id courtServicesSupervisor = Utility_ID__c.getValues('CEP - Court Services Super').RecordType_Id__c;
        public Id courtServicesStaff = Utility_ID__c.getValues('CEP - Court Services Staff').RecordType_Id__c;
        public Id cepHallMonitor = Utility_ID__c.getValues('CEP - Hall Monitor').RecordType_Id__c;
        //added 10/17/12 by MB
        public Id cjcJsAdmin = Utility_ID__c.getValues('CJC/JS Administration').RecordType_Id__c;
        // added 3/13/13 MB
        public Id qjcUser = Utility_ID__c.getValues('QJC - Standard User').RecordType_Id__c;
        public Id qjcAdmin = Utility_ID__c.getValues('QJC - Admin').RecordType_Id__c;
        //added 8/12/13 MB
        public Id choicesStandardUser = Utility_ID__c.getValues('Choices Standard User').RecordType_Id__c;
        public Id choicesAdmin = Utility_ID__c.getValues('Choices Administration').RecordType_Id__c;
        //added 9/16/13 MB
        public Id startUser = Utility_ID__c.getValues('START User').RecordType_Id__c;
        public Id startAdmin = Utility_ID__c.getValues('START Admin').RecordType_Id__c;  
        public Id strategicPlanning = Utility_ID__c.getValues('Strategic Planning').RecordType_Id__c;    
        public Id cirtUser = Utility_ID__c.getValues('CIRT User').RecordType_Id__c;
        public Id cirtNurse = Utility_ID__c.getValues('CIRT Nurse').RecordType_Id__c;   
        public Id cirtPsychiatrist = Utility_ID__c.getValues('CIRT Psychiatrist').RecordType_Id__c;
        //added 8/11/16 by MM
        public ID courtStaff = Utility_ID__c.getValues('Court Staff').Recordtype_Id__c;
        //added 8/22/16 by MM
        public ID programStaff = Utility_ID__c.getValues('Program Staff').Recordtype_Id__c;          
    
        /////////////////////////////////////////////////////////////
        // User
        /////////////////////////////////////////////////////////////
            
        public Id defaultTaskAssignedTo = Utility_ID__c.getValues('Default Task Assignee').RecordType_Id__c;
        public Id cepTeamLeader = Utility_ID__c.getValues('CEP Team Leader').RecordType_Id__c;
        
         /////////////////////////////////////////////////////////////
        /// Assessments
        /////////////////////////////////////////////////////////////
        
        public Id alumniSurveyRecordType = Utility_ID__c.getValues('Alumni Survey').RecordType_Id__c;
        public id alumniSurveyLockedRecordType = Utility_ID__c.getValues('Alumni Survey - RO').RecordType_Id__c;
        public id ccAssessmentRecordType = Utility_ID__c.getValues('Case Coordinator Assessment').RecordType_Id__c;
        public id ccAssessmentLockedRecordType = Utility_ID__c.getValues('Case Coordinator Assessment - RO').RecordType_Id__c;
        public id eduAssessmentRecordType = Utility_ID__c.getValues('Education Assessment').RecordType_Id__c;
        public id eduAssessmentLockedRecordType = Utility_ID__c.getValues('Education Assessment - RO').RecordType_Id__c;
        public id homeVisitRecordType = Utility_ID__c.getValues('Home Visit').RecordType_Id__c;
        public id homeVisitLockedRecordType = Utility_ID__c.getValues('Home Visit - RO').RecordType_Id__c;
        public id psyAssessmentRecordType = Utility_ID__c.getValues('Psychosocial Assesment (MHA)').RecordType_Id__c;
        public id psyAssessmentLockedRecordType = Utility_ID__c.getValues('Psychosocial Assesment (MHA) - RO').RecordType_Id__c;
        public id subAbuseAssessmentRecordType = Utility_ID__c.getValues('Substance Abuse Assessment').RecordType_Id__c;
        public id subAbuseAssessmentLockedRecordType = Utility_ID__c.getValues('Substance Abuse Assessment - RO').RecordType_Id__c;
        public Id bjmhsRecordType = Utility_ID__c.getValues('BJMHS').RecordType_Id__c;
        public Id lsirsvAss = Utility_ID__c.getValues('LSIRSV').RecordType_Id__c;
        public Id lscmiAss = Utility_ID__c.getValues('LSCMI').RecordType_Id__c;
        public Id wrnaAss = Utility_ID__c.getValues('WRNA').RecordType_Id__c;    
        public Id pclcAss = Utility_ID__c.getValues('PCL-C').RecordType_Id__c;  
        public Id coloradoAss = Utility_ID__c.getValues('Colorado Symptom Index').RecordType_Id__c;  
        public Id dcAss = Utility_ID__c.getValues('DC Trauma Collaboration Study').RecordType_Id__c;     
        public Id ccmOrientationAss = Utility_ID__c.getValues('CCM Orientation').RecordType_Id__c;
        public Id assUCLA = Utility_ID__c.getValues('UCLA PTSD RI').RecordType_Id__c;
        public Id assUCLALocked = Utility_ID__c.getValues('UCLA PTSD RI - RO').RecordType_Id__c; 
        public Id assPHQ9 = Utility_ID__c.getValues('PHQ-9').RecordType_Id__c;
        public Id assPHQ9Locked = Utility_ID__c.getValues('PHQ-9 Read Only').RecordType_Id__c; 
        public Id assCRAFFT = Utility_ID__c.getValues('CRAFFT').RecordType_Id__c;   
        public Id assCourtRep = Utility_ID__c.getValues('Court Rep Assessment').RecordType_Id__c; 
        public Id assCourtRepLocked = Utility_ID__c.getValues('Court Rep Assessment Read Only').RecordType_Id__c; 
        
         /////////////////////////////////////////////////////////////
        // Administrative Actions
        /////////////////////////////////////////////////////////////
        
        public Id aaExitNotification = Utility_ID__c.getValues('Exit Notification').RecordType_Id__c;
        public Id aaExitNotificationLocked = Utility_ID__c.getValues('Exit Notification - Locked').RecordType_Id__c;
        public Id aaExtension = Utility_ID__c.getValues('Extension').RecordType_Id__c;
        public Id aaExtensionLocked = Utility_ID__c.getValues('Extension - Locked').RecordType_Id__c;
        public Id aaReinstatement = Utility_ID__c.getValues('Re-Instatement').RecordType_Id__c;
        public Id aaReinstatementLocked = Utility_ID__c.getValues('Re-Instatement - locked').RecordType_Id__c;
        public Id aaReintake = Utility_ID__c.getValues('Re-Intake').RecordType_Id__c;
        public Id aaReintakeLocked = Utility_ID__c.getValues('Re-Intake - Locked').RecordType_Id__c;
 
         /////////////////////////////////////////////////////////////
        // Education
        /////////////////////////////////////////////////////////////
        
        public Id eduCollege = Utility_ID__c.getValues('Education - College').RecordType_Id__c;        
        public Id eduStandard = Utility_ID__c.getValues('Education - Standard').RecordType_Id__c;  
      
        //////////////////////////////////////////
        /// To Do Tab Selection types
        //////////////////////////////////////////
            
        public List<SelectOption> toDoTabList = new List<SelectOption>();
            
        //////////////////////////////////////////
        /// Classes
        //////////////////////////////////////////
        public Id classFixed = Utility_ID__c.getValues('Fixed').RecordType_Id__c;
        public Id classOngoing = Utility_ID__c.getValues('Ongoing').RecordType_Id__c;
        public Id classSingle = Utility_ID__c.getValues('Single').RecordType_Id__c;
        
        //////////////////////////////////////////
        /// Schedules
        //////////////////////////////////////////
        public Id scheduleFixed = Utility_ID__c.getValues('Fixed Schedule').RecordType_Id__c;
        public Id scheduleOngoing = Utility_ID__c.getValues('Ongoing Schedule').RecordType_Id__c;
        public Id scheduleSingle = Utility_ID__c.getValues('Single Schedule').RecordType_Id__c;
        
        //////////////////////////////////////////
        /// Program Relationships
        //////////////////////////////////////////
        public Id progRelPRP = Utility_ID__c.getValues('PRP Program Relationship').RecordType_Id__c;        
        public Id progRelReferral = Utility_ID__c.getValues('Referral Program Relationship').RecordType_Id__c;      
        public Id progRelInsurance = Utility_ID__c.getValues('Insurance').RecordType_Id__c;
        public Id progRelProgramHistory = Utility_ID__c.getValues('Program History Program Relationship').RecordType_Id__c;      
        public Id progRelReferralCIRT = Utility_ID__c.getValues('Referral (CIRT)').RecordType_Id__c;
        public Id progRelProgramHistoryCIRT = Utility_ID__c.getValues('Program History (CIRT)').RecordType_Id__c;               
        
        //////////////////////////////////////////
        /// Follow Ups
        //////////////////////////////////////////
        public Id FollowUpMSR = Utility_ID__c.getValues('MSR Follow Up').RecordType_Id__c;       
        public Id FollowUpParole = Utility_ID__c.getValues('Parole Officer Follow Up').RecordType_Id__c;    
        public Id FollowUpTreatment = Utility_ID__c.getValues('Treatment Agency Follow Up').RecordType_Id__c;    
        public Id FollowUpReferral = Utility_ID__c.getValues('Referral Follow Up').RecordType_Id__c;                                  
        
        //////////////////////////////////////////
        /// Client and Coordinator Calendar Settings
        //////////////////////////////////////////
        public Integer clientStartDateOffset;
        public Integer clientEndDateOffset;
        public Integer coordinatorStartDateOffset;
        public Integer coordinatorEndDateOffset;
        
        //////////////////////////////////////////
        //Rearrest Subject lists - 
        // list varies depending on if task was generated manually or automatically
        //////////////////////////////////////////
        public Set<String> rearrestManualSubjects = new Set<String>{
            'Rearrest Check - In-Program',
            'Rearrest Check - Post-Program',
            'Rearrest Check - Quarterly',
            'Rearrest Check - 1 Year Post-Intake',
            'Rearrest Check - 6 Months Post-Intake'
        };
        public Set<String> rearrestAutoSubjects = new Set<String>{
            'Rearrest Check - Successful Exit',
            'Rearrest Check - 3-month Post-Grad',
            'Rearrest Check - Quarterly',
            'Rearrest Check - 1 Year Post-Intake',
            'Rearrest Check - 6 Months Post-Intake'
        };
        
        public Map<Boolean, Set<String>> rearrestSubjects = new Map<Boolean, Set<String>>{
            false => rearrestManualSubjects,
            true => rearrestAutoSubjects
        };
        
        // 4/27/13 MB: Determines whether semesterLogic has been run already, since child records
        // created in the trigger fire update of parent record again
        public static boolean bolSchoolClassesAlreadyCreated;
        
        // 4/28/13 MB: Set to true if a school class is being deleted via the semester data entry form, or due to the deletion
        // of the parent/grandparent semester/ education records. Otherwise, direct deletion of the school class via the UI
        // is not allowed
        public static boolean bolDeleteSchoolClasses;
        
        // 11/27/12 MB: Determines whether alumni surveys have already updated the most recent flag 
        // so as to avoid infinite loop
        public static boolean bolAlumniSurveysAlreadyUpdated;
        
        // 3/27/13 MB: added to prevent the skip triggers code in eventLogic and taskLogic from being checked each time,
        // which is unnecessary and causes an error, because apexPages.currentpage() cannot be accessed on triggered 
        // inserts/ updates, only the original record insert/update
        public static boolean bolSkipTriggersAlreadyChecked;
        public static boolean bolSkipTaskTriggers;
        public static boolean bolSkipEventTriggers;
            

        // 4/8/13 MB: used to pass list of emails to be sent from the before to after triggers in bugTrackingLogic
        public static map<Messaging.Singleemailmessage, String> mapMailText = new map<Messaging.Singleemailmessage,String>();
        public static map<Messaging.Singleemailmessage, Change_Control_and_Bug_Tracking__c> mapMailBT 
        = new map<Messaging.Singleemailmessage,Change_Control_and_Bug_Tracking__c>();
                    
        //////////////////////////////////////////
        // Hard codes a unit to each profile
        //////////////////////////////////////////           
        public Map<String, String> unitMap = new Map<String,String>();                        
                    
            
     public utilityIds() {
           
            //////////////////////////////////////////
            // Unit Map
            /////////////////////////////////////////////////////
  
             unitMap.put(String.valueOf(cepDirector) , 'Case Coordination');
             unitMap.put(String.valueOf(cepDeputyDirector) , 'Case Coordination');
             unitMap.put(String.valueOf(adminSupportSupervisor) , 'CEP Admin Services');
             unitMap.put(String.valueOf(adminSupportStaff) , 'CEP Admin Services');
             unitMap.put(String.valueOf(substanceAbuseSupervisor) , 'Substance Abuse');
             unitMap.put(String.valueOf(substanceAbuseStaff) , 'Substance Abuse');
             unitMap.put(String.valueOf(caseCoordinatorStaff) , 'Case Coordination');
             unitMap.put(String.valueOf(employmentSupervisor) , 'Employment');
             unitMap.put(String.valueOf(employmentStaff) , 'Employment');
             //added 7/29/15 by PR
             unitMap.put(String.valueOf(cepIcdStaff) , 'Employment');
             unitMap.put(String.valueOf(cepIcdSupervisor) , 'Employment');                          
             unitMap.put(String.valueOf(educationLiaisonSupervisor) , 'Education');
             unitMap.put(String.valueOf(educationLiaisonStaff) , 'Education');
             unitMap.put(String.valueOf(educationInternalSupervisor) , 'Education');
             unitMap.put(String.valueOf(educationInternalStaff) , 'Education');
             //added 7/29/15 by PR
             unitMap.put(String.valueOf(cepIcdStaff) , 'Education');
             unitMap.put(String.valueOf(cepIcdSupervisor) , 'Education');                           
             unitMap.put(String.valueOf(mentalHealthSupervisor) , 'Mental Health');
             unitMap.put(String.valueOf(mentalHealthStaff) , 'Mental Health');
             unitMap.put(String.valueOf(systemAdmin) , 'System Admin');
             unitMap.put(String.valueOf(courtServicesSupervisor) , 'Case Coordination');
             unitMap.put(String.valueOf(courtServicesStaff) , 'Case Coordination');
             unitMap.put(String.valueOf(courtStaff) , 'Court Staff');
             unitMap.put(String.valueOf(courtStaff) , 'Program Staff');
            
            //////////////////////////////////////////
            /// To Do Tab Selection types
            //////////////////////////////////////////
            
        //4/6/13 MB: added categories
        
        //Case coordination
        toDoTabList.add(new SelectOption(caseCoordinatorAssessmentTask + ';' + CBOPlacementTask + ';' + initialProgramPlanTask 
        + ';' + initialProgramPlanTask + ';' + exitNotificationTask + ';' + mandatoryClassesTask + ';'
        + rearrestCheckTask,'Case Coordination (All)'));
        //toDoTabList.add(new SelectOption(caseCoordinatorAssessmentTask,' >Case Coordinator Assessment'));
        toDoTabList.add(new SelectOption(CBOPlacementTask,' >CBO Placement'));
        toDoTabList.add(new SelectOption(initialProgramPlanTask,' >Initial Program Plan'));  
        toDoTabList.add(new SelectOption(exitNotificationTask,' >Exit Notification'));
        toDoTabList.add(new SelectOption(mandatoryClassesTask,' >Mandatory Classes')); 
        toDoTabList.add(new SelectOption(rearrestCheckTask,' >Rearrest Check'));  
        toDoTabList.add(new SelectOption(outReachNeeded,' >CASES Outreach Needed'));     
  
        // Education
        toDoTabList.add(new SelectOption(schoolVisitTask + ';' //+ educationAssessmentTask + ';' 
        + STARTestMathTask + ';' + STARTestReadingTask,'Education (All)')); 
        toDoTabList.add(new SelectOption(schoolVisitTask,' >Ed Program Visit Request'));  
        //toDoTabList.add(new SelectOption(educationAssessmentTask,' >Education Assessment')); 
        toDoTabList.add(new SelectOption(STARTestMathTask,' >STAR Test - Math'));
        toDoTabList.add(new SelectOption(STARTestReadingTask,' >STAR Test - Reading'));       
        
        /*
        //Employment
        toDoTabList.add(new SelectOption(alumniSurveyTask + ';' + careerExplorationReferralTask
        + ';' + employmentAssessmentTask,'Employment (All)'));  
        toDoTabList.add(new SelectOption(alumniSurveyTask,' >Alumni Survey'));      
        toDoTabList.add(new SelectOption(careerExplorationReferralTask,' >Career Exploration Referral'));                  
        toDoTabList.add(new SelectOption(employmentAssessmentTask,' >Employment Assessment'));         

        //Mental Health
        toDoTabList.add(new SelectOption(MAYSIAssessmentTask + ';' + mentalHealthAssessmentTask
        + ';' + PHQ9Task + ';' + UCLATask + ';' + LSCMITask,'Mental Health (All)'));
        toDoTabList.add(new SelectOption(LSCMITask,' >LSCMI Assessment'));
        toDoTabList.add(new SelectOption(MAYSIAssessmentTask,' >MAYSI Assessment'));
        toDoTabList.add(new SelectOption(mentalHealthAssessmentTask,' >Mental Health Assessment'));  
        toDoTabList.add(new SelectOption(PHQ9Task,' >PHQ-9 Assessment')); 
        toDoTabList.add(new SelectOption(UCLATask,' >UCLA PTSD RI Assessment'));            
        */
        //Progress Notes 
        toDoTabList.add(new SelectOption(ccCRSNoteTask + ';' + ccProgressNoteTask + ';' + PSCRSNoteTask + ';' 
        + psProgressNoteTask + ';' + incidentReportNoteTask,'Progress Notes (All)'));                
        toDoTabList.add(new SelectOption(ccCRSNoteTask,' >CC CRS Note'));
        toDoTabList.add(new SelectOption(ccProgressNoteTask,' >CC Progress Note')); 
        toDoTabList.add(new SelectOption(incidentReportNoteTask,' >Incident Report Note'));                
        toDoTabList.add(new SelectOption(psCRSNoteTask,' >PS CRS Note'));         
        toDoTabList.add(new SelectOption(psProgressNoteTask,' >PS Progress Note'));
        
        //Substance Abuse
        toDoTabList.add(new SelectOption(exitDrugTestTask + ';' + initialDrugTestTask + ';' + nextDrugTestTask
        + ';' + substanceAbuseAssessmenTask,'Substance Abuse (All)'));  
        toDoTabList.add(new SelectOption(exitDrugTestTask,' >Exit Drug Test'));     
        toDoTabList.add(new SelectOption(initialDrugTestTask,' >Initial Drug Test'));
        toDoTabList.add(new SelectOption(nextDrugTestTask,' >Next Drug Test'));     
        //toDoTabList.add(new SelectOption(substanceAbuseAssessmenTask,' >Substance Abuse Assessment')); 
                  
     }  //EOF - utilityIds()
}