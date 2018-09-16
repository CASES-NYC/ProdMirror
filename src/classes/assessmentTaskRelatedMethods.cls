public with sharing class assessmentTaskRelatedMethods {

    
    public utilityIds util = new utilityIds();
    public List<Assessment__c> insertedAssessments = new List<Assessment__c>();
    public Map<Id,Contact> mapClients = new Map<Id,Contact>();
    public Set<Id> whoIds = new Set<Id>();
    public Map<Id, Id> mapAsstoTask = new Map<Id, Id>();
    public List<Task> affectedTasks = new List<Task>();
    public List<Task> lstTaskstoUpdate = new list<Task>();    
    public List<Task> newTasks = new List<Task>();


    // Get all related contacts
    
    public void getWhoIds() {   
        
        for(Assessment__c thisAsses:insertedAssessments) {
            
            whoIds.add(thisAsses.Contact__c);
        
        }
        
        /// Add all asssessment mapping fields here
        mapClients=new Map<Id,Contact>([Select Id, Client_Status__c, Current_Projected_Exit_Date__c,
            Relation_to_client__c, Parent_Guardian__c, LastName, FirstName, Case_Coordinator__c, Email,
            Substance_Abuse_at_Intake__c, School_GED_Enrollment_at_Intake__c, Last_School_Attended__c,
            Diploma_Type__c, Diploma_Date__c, Diploma_Status_at_Intake__c, What_is_the_last_grade_you_completed__c,
            Mental_health_Issues_at_Intake__c, How_many_credits_have_you_earned__c, Current_Employment__c,
            Client_Cell_Phone__c, Other_Physical_Health__c, Insurance_Number__c, What_grade_are_you_currently_in__c,
            Do_you_have_Insurance__c, Insurance_Provider__c, Intake_Date__c, HomePhone,
            Birthdate, Emergency_Contact_If_Other__c, Indication_of_Physical_Health_Problems__c, Required_Documents__c,
            Drugs_Used__c, Drugs_Used_Other__c,
            Building_No__c, Street__c, Apt_No__c, City__c, State__c, Zip__c, Neighborhood__c, School_Start_Date__c,
            School_Institution_Hours_from_and_to__c, School_End_Date__c, Reason_for_Leaving_School__c,
            Reason_for_Leaving_School_Other__c, Current_School_Enrollment__c, Work_Hours_from_and_to__c,
            Start_Date__c, Job_Title__c, Hourly_Pay__c, Employer__c, Employed_at_Intake__c, 
            // 10/24/14 MB
            //no longer using MAYSI. rebuild this better if we ever use it again
            //Traumatic_Experiences__c, Thought_Disturbance__c, Suicide_Ideation__c, Somatic_Complaints__c, Depressed_Anxious__c,
            //Angry_Irritable__c, Alcohol_Drug_Use__c, 
            STAR_Reading_Score__c, STAR_Reading_Date__c, STAR_Math_Score__c,
            STAR_Math_Date__c, GED_Test_Type__c, GED_Test_Date__c, GED_Result__c, Other_Contact_Information__c,
            Calendar_Display_Name__c, UCLA_PTSD_RI_Flag__c, PHQ_9_Flag__c, CRAFFT_Total_Score__c, 
            LS_CMI_Risk_Category_at_Intake__c, RecordTypeId, Current_Age__c,
            
            (select id, PHQ_9_Flag__c, UCLA_PTSD_RI_Flag__c, CRAFFT_Total_Score__c, Overall_Risk_Category__c,
            RecordTypeId from Assessments__r
            where Assessment_Completed_On__c != null 
            and RecordTypeId in (:util.assPHQ9, :util.assPHQ9Locked, :util.assUCLA, :util.assUCLALocked,
            :util.subAbuseAssessmentRecordType, :util.subAbuseAssessmentLockedRecordType, :util.lscmiAss)
            order by Assessment_Completed_On__c asc),
            
            (select id from Tasks where RecordTypeId = :util.mentalHealthAssessmentTask)
            
            From Contact Where Id in :whoIds]);
    }
     
    public void getAllRelatedTasks() {
        
        // Limit the tasks by rec type      
        mapAssToTask.put(util.subAbuseAssessmentRecordType , util.substanceAbuseAssessmenTask);
        mapAssToTask.put(util.subAbuseAssessmentLockedRecordType , util.substanceAbuseAssessmenTask);
        mapAssToTask.put(util.ccAssessmentRecordType , util.caseCoordinatorAssessmentTask);
        mapAssToTask.put(util.ccAssessmentLockedRecordType , util.caseCoordinatorAssessmentTask);
        mapAssToTask.put(util.eduAssessmentRecordType , util.educationAssessmentTask);
        mapAssToTask.put(util.eduAssessmentLockedRecordType , util.educationAssessmentTask);
        mapAssToTask.put(util.psyAssessmentRecordType , util.mentalHealthAssessmentTask);
        mapAssToTask.put(util.psyAssessmentLockedRecordType , util.mentalHealthAssessmentTask);
        mapAssToTask.put(util.alumniSurveyRecordType , util.alumniSurveyTask);
        mapAssToTask.put(util.alumniSurveyLockedRecordType , util.alumniSurveyTask);
        mapAssToTask.put(util.assPHQ9 , util.PHQ9Task);
        mapAssToTask.put(util.assPHQ9Locked , util.PHQ9Task);
        mapAssToTask.put(util.assUCLA , util.UCLATask);
        mapAssToTask.put(util.assUCLALocked , util.UCLATask);  
        mapAssToTask.put(util.lscmiAss , util.LSCMITask);   
        
        // This should be a list of all possible tasks associated with the contact that took the assessments
    
        affectedTasks = [Select Id, Open_Date__c, activityDate, Closed_By_System__c, isClosed, Closing_Date__c, WhoId,
        recordTypeId, Status from Task 
        Where WhoId in :whoIds AND recordTypeId in :mapAsstoTask.values() AND IsClosed = false];
    }
    
    public void updateAllRelatedTasks() {
        
        
        update lstTaskstoUpdate;
        insert newTasks;

    }
    
    public void updateMHFlags() {
        
        Task mhTask = new Task();
        
        //get all UCLA and PHQ9 Assessments, then find latest

        for(Contact c: mapClients.values()) {
            
            mhTask = new Task();
            
            c.UCLA_PTSD_RI_Flag__c = false;
            c.PHQ_9_Flag__c = false;
            c.LS_CMI_Risk_Category_at_Intake__c = null;
            c.CRAFFT_Total_Score__c = null;
            
            for(Assessment__c a: c.Assessments__r) {
                
                if(a.RecordTypeId == util.assPHQ9 || a.RecordTypeId == util.assPHQ9Locked) {
                    
                    c.PHQ_9_Flag__c = a.PHQ_9_Flag__c;
                } else if(a.RecordTypeId == util.assUCLA || a.RecordTypeId == util.assUCLALocked){
                    c.UCLA_PTSD_RI_Flag__c = a.UCLA_PTSD_RI_Flag__c;
                } else if(a.RecordTypeId == util.subAbuseAssessmentRecordType 
                || a.RecordTypeId == util.subAbuseAssessmentLockedRecordType) {
                    c.CRAFFT_Total_Score__c = a.CRAFFT_Total_Score__c;
                } else if(a.RecordTypeId == util.lscmiAss 
                && c.LS_CMI_Risk_Category_at_Intake__c == null) {
                    //take the first value for LSCMI, not the latest
                    c.LS_CMI_Risk_Category_at_Intake__c = a.Overall_Risk_Category__c;
                }
            }
            
            //create Mental Health Assessment task if client is flagged and no task has been created yet
            if((c.UCLA_PTSD_RI_Flag__c || c.PHQ_9_Flag__c)
            && c.Tasks.size() == 0 && c.RecordTypeId == util.conClient) {
                
                //the rest of the fields are set by taskMethods.manualTaskCreationUpdates
                mhTask.whoId = c.id;
                mhTask.Subject = 'Mental Health Assessment';
                mhTask.RecordTypeId = util.mentalHealthAssessmentTask;
                mhTask.Automatically_Generated__c = true;
                newTasks.add(mhTask);       
            }
        }
        
        update mapClients.values();
    }
    
    public void refreshfromContact() {
        
        for(Assessment__c a:insertedAssessments) { // Loop through all assessments
        
            if( a.RecordTypeId == util.ccAssessmentRecordType || 
                a.RecordTypeId == util.eduAssessmentRecordType ||
                a.RecordTypeId == util.psyAssessmentRecordType ||
                a.RecordTypeId == util.subAbuseAssessmentRecordType 
                
                ) {
            
                    a.Client_Name__c = mapClients.get(a.Contact__c).FirstName + ' ' + mapClients.get(a.Contact__c).LastName;
                    a.Case_Coordinator__c = mapClients.get(a.Contact__c).Case_Coordinator__c; 
            }
            //////////////////////////////////////////////////////////////////////////////////////
            //
            // Home Visit
            //
            //////////////////////////////////////////////////////////////////////////////////////
            
            if(a.RecordTypeId == util.homeVisitRecordType ) {
            
                    a.Client_Name__c = mapClients.get(a.Contact__c).FirstName + ' ' + mapClients.get(a.Contact__c).LastName;
                    a.Case_Coordinator__c = mapClients.get(a.Contact__c).Case_Coordinator__c; 
            }
            
            //////////////////////////////////////////////////////////////////////////////////////
            //
            // Address fields updated on a bunch
            //
            //////////////////////////////////////////////////////////////////////////////////////
            
            if( a.RecordTypeId == util.ccAssessmentRecordType || 
                a.RecordTypeId == util.eduAssessmentRecordType ||
                a.RecordTypeId == util.psyAssessmentRecordType ||
                a.RecordTypeId == util.alumniSurveyRecordType 
                
                ) {
                
                    a.Building_No__c  = mapClients.get(a.Contact__c).Building_No__c;
                    a.Street__c  = mapClients.get(a.Contact__c).Street__c;
                    a.Apt_No__c  = mapClients.get(a.Contact__c).Apt_No__c;
                    a.City__c  = mapClients.get(a.Contact__c).City__c;
                    a.State__c  = mapClients.get(a.Contact__c).State__c;
                    a.Zip_Code__c  = mapClients.get(a.Contact__c).Zip__c;
                    a.Neighborhood__c  = mapClients.get(a.Contact__c).Neighborhood__c;
                }
            //////////////////////////////////////////////////////////////////////////////////////
            //
            // Fields that are only updated for Alumni Assessment
            //
            //////////////////////////////////////////////////////////////////////////////////////
            
            if(a.RecordTypeId == util.alumniSurveyRecordType) {
                
                a.Client_Name__c = mapClients.get(a.Contact__c).FirstName + ' ' + mapClients.get(a.Contact__c).LastName;
                a.Client_s_True_Name__c = mapClients.get(a.Contact__c).Calendar_Display_Name__c;
                a.Current_School_Enrollment__c = mapClients.get(a.Contact__c).Current_School_Enrollment__c;
                a.Last_School_Attended__c = mapClients.get(a.Contact__c).Last_School_Attended__c;
                a.Diploma_Type__c = mapClients.get(a.Contact__c).Diploma_Type__c;
                a.Diploma_Date__c = mapClients.get(a.Contact__c).Diploma_Date__c;
                a.School_Start_Date__c = mapClients.get(a.Contact__c).School_Start_Date__c;
                a.School_End_Date__c = mapClients.get(a.Contact__c).School_End_Date__c;
                a.Reason_for_Leaving_School__c = mapClients.get(a.Contact__c).Reason_for_Leaving_School__c;
                a.Reason_for_Leaving_School_Other__c = mapClients.get(a.Contact__c).Reason_for_Leaving_School_Other__c;
                // 3/8/13 MB: according to prod.a.BT-1118, display "unemployed" when blank
                if(mapClients.get(a.Contact__c).Current_Employment__c == null) {
                    a.Current_Employment__c = 'Unemployed';
                }
                
                else {
                    a.Current_Employment__c = mapClients.get(a.Contact__c).Current_Employment__c;
                }
                a.Employer__c = mapClients.get(a.Contact__c).Employer__c;
                a.Job_Title__c = mapClients.get(a.Contact__c).Job_Title__c;
                a.Start_Date__c = mapClients.get(a.Contact__c).Start_Date__c;
                a.Hourly_Pay__c = mapClients.get(a.Contact__c).Hourly_Pay__c;
                a.Home_Phone__c= mapClients.get(a.Contact__c).HomePhone;
                a.Client_Cell_Phone__c = mapClients.get(a.Contact__c).Client_Cell_Phone__c;
                a.Client_Email__c = mapClients.get(a.Contact__c).Email;
                
                //only update this value (in the Update section) if it has been modified from the value that was passed into the assessment from contact
                if(a.Other_Contact_Information__c == a.Update_Other_Contact_Information__c) {
                    a.Update_Other_Contact_Information__c = mapClients.get(a.Contact__c).Other_Contact_Information__c;
                }
                
                a.Other_Contact_Information__c = mapClients.get(a.Contact__c).Other_Contact_Information__c;
                
                // 3/13/13 MB: as per prod.a.BT-0637, set Emp and Ed confirmed fields to No when Contact Method is unsuccessful
                if(a.Client_Contact_Method__c == 'Contact Attempt/No Message Left'
                || a.Client_Contact_Method__c == 'Message Left') {
                    
                    a.Education_Information_Confirmed__c = 'No';
                    a.Employment_Information_Confirmed__c = 'No';
                }
            }
            //////////////////////////////////////////////////////////////////////////////////////
            //
            // Fields that are only updated for Substance abuse
            //
            //////////////////////////////////////////////////////////////////////////////////////
            
            if(a.RecordTypeId == util.subAbuseAssessmentRecordType ) {
                a.Substance_Abuse_at_Interview__c = mapClients.get(a.Contact__c).Substance_Abuse_at_Intake__c;
                a.Intake_Date__c = mapClients.get(a.Contact__c).Intake_Date__c;
                a.DOB__c = mapClients.get(a.Contact__c).Birthdate;
                a.Current_Age__c = mapClients.get(a.Contact__c).Current_Age__c;
                a.Parent_Guardian__c = mapClients.get(a.Contact__c).Parent_Guardian__c;
                a.Emergency_Contact_If_Other__c = mapClients.get(a.Contact__c).Emergency_Contact_If_Other__c;
                a.Insurance_Provider__c= mapClients.get(a.Contact__c).Insurance_Provider__c; 
                a.Insurance_Number__c = mapClients.get(a.Contact__c).Insurance_Number__c;
                a.Do_you_have_Insurance__c = mapClients.get(a.Contact__c).Do_you_have_Insurance__c;
                a.Indication_of_Phys_Health_Problem__c= mapClients.get(a.Contact__c).Indication_of_Physical_Health_Problems__c; 
                a.Other_Phys_Health_Problem__c =  mapClients.get(a.Contact__c).Other_Physical_Health__c;
                // 12/17/12 MB: Added on request from Chris Feeny
                a.Client_Email__c = mapClients.get(a.Contact__c).Email;
                a.Required_Documents__c = mapClients.get(a.Contact__c).Required_Documents__c;
            }
            //////////////////////////////////////////////////////////////////////////////////////
            //
            // Fields that are only updated for Psychosocial Assessment
            //
            //////////////////////////////////////////////////////////////////////////////////////
            
            if(a.RecordTypeId == util.psyAssessmentRecordType ) {
                a.Other_Phys_Health_Problem__c =  mapClients.get(a.Contact__c).Other_Physical_Health__c;    
                a.Drugs_Used__c  = mapClients.get(a.Contact__c).Drugs_Used__c;
                a.Drugs_Used_Other__c  = mapClients.get(a.Contact__c).Drugs_Used_Other__c;
                a.Mental_Health_Issues_at_Interview__c  = mapClients.get(a.Contact__c).Mental_health_Issues_at_Intake__c;
                a.Indication_of_Phys_Health_Problem__c= mapClients.get(a.Contact__c).Indication_of_Physical_Health_Problems__c; 
                a.Insurance_Provider__c= mapClients.get(a.Contact__c).Insurance_Provider__c; 
                a.Insurance_Number__c = mapClients.get(a.Contact__c).Insurance_Number__c;
                a.Do_you_have_Insurance__c = mapClients.get(a.Contact__c).Do_you_have_Insurance__c;
                a.Emergency_Contact_If_Other__c = mapClients.get(a.Contact__c).Emergency_Contact_If_Other__c;
                a.Intake_Date__c = mapClients.get(a.Contact__c).Intake_Date__c;
                a.DOB__c = mapClients.get(a.Contact__c).Birthdate;
                a.Current_Age__c = mapClients.get(a.Contact__c).Current_Age__c;
                                                       
            }
            
            //////////////////////////////////////////////////////////////////////////////////////
            //
            // Fields that are only updated for Case Cordinator assessments
            //
            //////////////////////////////////////////////////////////////////////////////////////
            
            if(a.RecordTypeId == util.ccAssessmentRecordType ) {
            
                a.Relation_To_Client__c = mapClients.get(a.Contact__c).Relation_to_client__c;
                a.Parent_Guardian__c = mapClients.get(a.Contact__c).Parent_Guardian__c;
                a.School_GED_Enrollment_at_Intake__c = mapClients.get(a.Contact__c).School_GED_Enrollment_at_Intake__c;
                a.Diploma_Status_at_Intake__c = mapClients.get(a.Contact__c).Diploma_Status_at_Intake__c;
                a.Current_School_Enrollment__c = mapClients.get(a.Contact__c).Current_School_Enrollment__c;
                a.Last_School_Attended__c = mapClients.get(a.Contact__c).Last_School_Attended__c;
                a.School_Institution_Hours_from_and_to__c = mapClients.get(a.Contact__c).School_Institution_Hours_from_and_to__c;
                a.How_many_credits_have_you_earned__c = mapClients.get(a.Contact__c).How_many_credits_have_you_earned__c;
                a.Diploma_Type__c = mapClients.get(a.Contact__c).Diploma_Type__c;
                a.Diploma_Date__c = mapClients.get(a.Contact__c).Diploma_Date__c;
                a.What_grade_are_you_currently_in__c = mapClients.get(a.Contact__c).What_grade_are_you_currently_in__c;
                a.What_is_the_last_grade_you_completed__c = mapClients.get(a.Contact__c).What_is_the_last_grade_you_completed__c;
                a.School_Start_Date__c = mapClients.get(a.Contact__c).School_Start_Date__c;
                a.School_End_Date__c = mapClients.get(a.Contact__c).School_End_Date__c;
                a.Reason_for_Leaving_School__c = mapClients.get(a.Contact__c).Reason_for_Leaving_School__c;
                a.Reason_for_Leaving_School_Other__c = mapClients.get(a.Contact__c).Reason_for_Leaving_School_Other__c;
                a.Employed_at_Intake__c = mapClients.get(a.Contact__c).Employed_at_Intake__c;
                a.Current_Employment__c = mapClients.get(a.Contact__c).Current_Employment__c;
                a.Employer__c = mapClients.get(a.Contact__c).Employer__c;
                a.Job_Title__c = mapClients.get(a.Contact__c).Job_Title__c;
                a.Start_Date__c = mapClients.get(a.Contact__c).Start_Date__c;
                a.Hourly_Pay__c = mapClients.get(a.Contact__c).Hourly_Pay__c;
                a.Work_Hours_from_and_to__c = mapClients.get(a.Contact__c).Work_Hours_from_and_to__c;
                a.Mental_Health_Issues_at_Interview__c  = mapClients.get(a.Contact__c).Mental_health_Issues_at_Intake__c;
                a.Substance_Abuse_at_Interview__c = mapClients.get(a.Contact__c).Substance_Abuse_at_Intake__c;          
                a.Other_Phys_Health_Problem__c =  mapClients.get(a.Contact__c).Other_Physical_Health__c;    
                a.Indication_of_Phys_Health_Problem__c = mapClients.get(a.Contact__c).Indication_of_Physical_Health_Problems__c;    
                a.Do_you_have_Insurance__c = mapClients.get(a.Contact__c).Do_you_have_Insurance__c;
                a.Insurance_Provider__c = mapClients.get(a.Contact__c).Insurance_Provider__c;
                a.Insurance_Number__c = mapClients.get(a.Contact__c).Insurance_Number__c;
                
            }
            
            //////////////////////////////////////////////////////////////////////////////////////
            //
            // Fields that are only updated for Education  assessments
            //
            //////////////////////////////////////////////////////////////////////////////////////
            
            if(a.RecordTypeId == util.eduAssessmentRecordType ) {
                
                a.Relation_To_Client__c = mapClients.get(a.Contact__c).Relation_to_client__c;
                a.Parent_Guardian__c = mapClients.get(a.Contact__c).Parent_Guardian__c;
                a.School_GED_Enrollment_at_Intake__c = mapClients.get(a.Contact__c).School_GED_Enrollment_at_Intake__c;
                a.Diploma_Status_at_Intake__c = mapClients.get(a.Contact__c).Diploma_Status_at_Intake__c;
                a.Intake_Date__c = mapClients.get(a.Contact__c).Intake_Date__c;
                a.Home_Phone__c = mapClients.get(a.Contact__c).HomePhone;
                a.DOB__c = mapClients.get(a.Contact__c).Birthdate;
                a.Current_Age__c = mapClients.get(a.Contact__c).Current_Age__c;
                a.Diploma_Type__c = mapClients.get(a.Contact__c).Diploma_Type__c;
                a.Diploma_Date__c = mapClients.get(a.Contact__c).Diploma_Date__c;
                a.Last_School_Attended__c = mapClients.get(a.Contact__c).Last_School_Attended__c;
                a.School_Institution_Hours_from_and_to__c = mapClients.get(a.Contact__c).School_Institution_Hours_from_and_to__c;
                a.How_many_credits_have_you_earned__c = mapClients.get(a.Contact__c).How_many_credits_have_you_earned__c;
                a.School_Start_Date__c = mapClients.get(a.Contact__c).School_Start_Date__c;
                a.School_End_Date__c = mapClients.get(a.Contact__c).School_End_Date__c;
                a.Reason_for_Leaving_School__c = mapClients.get(a.Contact__c).Reason_for_Leaving_School__c;
                a.Reason_for_Leaving_School_Other__c = mapClients.get(a.Contact__c).Reason_for_Leaving_School_Other__c;
                a.Current_School_Enrollment__c = mapClients.get(a.Contact__c).Current_School_Enrollment__c;
                a.Required_Documents__c = mapClients.get(a.Contact__c).Required_Documents__c;
                
                //20120802 ebg - BT-018
                a.What_grade_are_you_currently_in__c = mapClients.get(a.Contact__c).What_grade_are_you_currently_in__c;
                a.What_is_the_last_grade_you_completed__c = mapClients.get(a.Contact__c).What_is_the_last_grade_you_completed__c;
                                                        
            }
            
            
            //CODE MOVED FROM ABOVE TO ELIMINATE DUPLICATION
            //BT-276 ebg 20111116 -  updates of the Education_Section_1__c field
            if(a.RecordTypeId == util.eduAssessmentRecordType || a.RecordTypeId == util.psyAssessmentRecordType) {
                //BT-275 ebg 20111116 - check for nulls
                String educationSectionOne = '';
                //GED Test Section
                if (mapClients.get(a.Contact__c).GED_Test_Type__c != null) {educationSectionOne += 'GED Test Type: ' + mapClients.get(a.Contact__c).GED_Test_Type__c + ', ';} 
                if (mapClients.get(a.Contact__c).GED_Test_Date__c != null) {educationSectionOne += 'GED Test Date: ' + mapClients.get(a.Contact__c).GED_Test_Date__c.format() + ', ';}
                if (mapClients.get(a.Contact__c).GED_Result__c != null) {educationSectionOne += 'GED Test Result: ' + mapClients.get(a.Contact__c).GED_Result__c + ', ';}
                //if the last character in the educationSectionOne is a comma, replace it with a hard return (\n)
                educationSectionOne = educationSectionOne.trim();
                if (educationSectionOne.lastIndexOf(',')+1 == educationSectionOne.length()) {
                    educationSectionOne = educationSectionOne.substring(0, educationSectionOne.length()) + '\n';
                }   

                //Star Reading Test Section
                if (mapClients.get(a.Contact__c).STAR_Reading_Date__c != null) {educationSectionOne += 'STAR Reading Test Date: ' + mapClients.get(a.Contact__c).STAR_Reading_Date__c.format() + ', ';} 
                if (mapClients.get(a.Contact__c).STAR_Reading_Score__c != null) {educationSectionOne += 'STAR Reading Test Score: ' + mapClients.get(a.Contact__c).STAR_Reading_Score__c + ', ';}     
                //if the last character in the educationSectionOne is a comma, replace it with a hard return (\n)
                educationSectionOne = educationSectionOne.trim();
                if (educationSectionOne.lastIndexOf(',')+1 == educationSectionOne.length()) {
                    educationSectionOne = educationSectionOne.substring(0, educationSectionOne.length()) + '\n';
                }   

                //STAR Math Test Section
                if (mapClients.get(a.Contact__c).STAR_Math_Date__c != null) {educationSectionOne += 'STAR Math Test Date: ' + mapClients.get(a.Contact__c).STAR_Math_Date__c.format() + ', ';} 
                if (mapClients.get(a.Contact__c).STAR_Math_Score__c != null) {educationSectionOne += 'STAR Math Test Score: ' + mapClients.get(a.Contact__c).STAR_Math_Score__c + ', ';}
                //if the last character in the educationSectionOne is a comma, replace it with a hard return (\n)
                educationSectionOne = educationSectionOne.trim();
                if (educationSectionOne.lastIndexOf(',')+1 == educationSectionOne.length()) {
                    educationSectionOne = educationSectionOne.substring(0, educationSectionOne.length()) + '\n';
                }   

                a.Education_Section_1__c = educationSectionOne;
            }
            
            
            //CODE MOVED FROM ABOVE TO ELIMINATE DUPLICATION
            //BT-276 ebg 20111116 - updates of the MAYSI_2__c field
            if(a.RecordTypeId == util.ccAssessmentRecordType || a.RecordTypeId == util.psyAssessmentRecordType) {
                //BT-275 ebg 20111116 - check for nulls
                String maysi2Field = '';

                //remove the last comma in the string
                maysi2Field = maysi2Field.trim();
                if (maysi2Field.lastIndexOf(',')+1 == maysi2Field.length()) {
                    maysi2Field = maysi2Field.substring(0, maysi2Field.length());
                }   

                a.MAYSI_2__c = maysi2Field;
            }   
            
            //don't think we need to save any of these values to the contact, but keeping this code here in case we do         
                    
        }
    }
    
    public void closeTasks() {
        
        for(Assessment__c a:insertedAssessments) {
            
            if(a.Assessment_Completed_on__c != null
            && ((a.RecordTypeId != util.alumniSurveyRecordType
            && a.RecordTypeId != util.alumniSurveyLockedRecordType)
            || (a.client_contact_method__c == 'Career Ex Graduation Survey'
            || a.Most_Recent_Alumni_Survey__c == 'Last Successful Contact'))) {
                    
                for(Task thisTask:affectedTasks) { /// Loop through a tasks
                    
                    if(mapAsstoTask.containsKey(a.RecordTypeId)
                    && thisTask.RecordTypeId == mapAsstoTask.get(a.RecordTypeId) 
                    && thisTask.WhoId == a.Contact__c) {                 
                        
                        System.debug('Found a matching task');
                        
                        if(a.Assessment_Completed_on__c <= thisTask.activityDate) {
                            
                            thisTask.Status = 'Done on Time';
                            
                        } else {
                            
                            thisTask.Status = 'Done Late';
                        }
                        thisTask.Closing_Date__c = a.Assessment_Completed_on__c;
                        thisTask.Closed_By_System__c  = True;
                        thisTask.SkipRestrictions__c = true;
                        lstTaskstoUpdate.add(thisTask);
                    
                        if (a.RecordTypeId == util.alumniSurveyRecordType
                        || a.RecordTypeId == util.alumniSurveyLockedRecordType) {
                                
                                Task newTask = new Task();
                                newTask.WhoId = a.Contact__c;
                                newTask.recordTypeId = util.alumniSurveyTask;
                                newTask.ActivityDate = System.Today().addDays(90); 
                                newTask.Open_Date__c = System.Today();   
                                newTask.Automatically_Generated__c = true;
                                newTask.Subject = 'Alumni Survey';
                                newTask.ownerId = a.Survey_Completed_by__c;            
                                newTask.SkipRestrictions__c = true;
                                
                                newTasks.add(newTask);                
                        }                               
                    }
                }
            } 
        }
    }   
    
    public void setMostRecentAlumniSurvey() {
        
        list<Assessment__c> allAlumniSurveys = new list<Assessment__c>();
        
        allAlumniSurveys = [select Id, Contact__c, Contact_Made__c, Survey_Date__c, Most_Recent_Alumni_Survey__c 
                            from assessment__c where contact__c in :whoIds 
                            and (recordtypeId = :util.alumniSurveyRecordType 
                            or recordtypeId = :util.alumniSurveyLockedRecordType)
                            order by Contact__c asc, Survey_Date__c asc];
        
        for(Id c: whoIds) {
            
            Assessment__c lastSuccessfulContact = new Assessment__c();
            Assessment__c lastContactAttempt = new Assessment__c();
            lastSuccessfulContact.Survey_Date__c = Date.NewInstance(1950,1,1);
            lastContactAttempt.Survey_Date__c = Date.NewInstance(1950,1,1);
            
            for(assessment__c a: allAlumniSurveys) {
                
                if(c == a.Contact__c) {
                    
                    if(a.Survey_Date__c>lastSuccessfulContact.Survey_Date__c && a.Contact_Made__c == 'Successful Contact') {
                        
                        lastSuccessfulContact.Most_Recent_Alumni_Survey__c = null;
                        lastSuccessfulContact = a;
                        lastSuccessfulContact.Most_Recent_Alumni_Survey__c = 'Last successful contact'; 
                    }
                    
                    else if(a.Survey_Date__c>lastContactAttempt.Survey_Date__c && a.Contact_Made__c == 'Contact Attempt') {
                        
                        lastContactAttempt.Most_Recent_Alumni_Survey__c = null;
                        lastContactAttempt = a;
                        lastContactAttempt.Most_Recent_Alumni_Survey__c = 'Last contact attempt';   
                    }
                    
                    else {
                        a.Most_Recent_Alumni_Survey__c = null;
                    }   
                }
            }
                
        }
            
        UtilityIds.bolAlumniSurveysAlreadyUpdated = true;
        update allAlumniSurveys;    
    }
    
    
    public void setLSCMIandWRNALookups() {
        
        
        list<Program_Plan__c> lstPlans = new list<Program_Plan__c>();
        map<Id, Program_Plan__c> mapPlans = new map<Id, Program_Plan__c>();
        
        //get list of plans with date of most recent LSCMI
        lstPlans = [select id, Client_Name__c, LSCMI_Lookup_Admin__r.Assessment_Completed_On__c, 
                        LSCMI_Lookup_Admin__c, WRNA_Lookup_Admin__c,  WRNA_Lookup_Admin__r.Assessment_Completed_On__c
                        from Program_Plan__c where Client_Name__c in :whoIds and Most_Recent_Program_Plan__c = true
                        and Client_Name__r.RecordTypeId in (:util.conCCM, :util.conCRT, :util.conClient)];
                        
        for(Program_Plan__c p: lstPlans) {
            
            mapPlans.put(p.Client_Name__c, p);
        }               
                        
        for(Assessment__c a: insertedAssessments) {
            
            if(a.RecordTypeId == util.lscmiAss) {
                
                if(mapPlans.containsKey(a.Contact__c) 
                    && (a.Assessment_Completed_on__c > mapPlans.get(a.Contact__c).LSCMI_Lookup_Admin__r.Assessment_Completed_On__c
                    || mapPlans.get(a.Contact__c).LSCMI_Lookup_Admin__r.Assessment_Completed_On__c == null)) {
                    
                    mapPlans.get(a.Contact__c).LSCMI_Lookup_Admin__c = a.id;
                }
            } else if(a.RecordTypeId == util.wrnaAss) {
            
                if(mapPlans.containsKey(a.Contact__c) 
                    && (a.Assessment_Completed_on__c > mapPlans.get(a.Contact__c).WRNA_Lookup_Admin__r.Assessment_Completed_On__c
                    || mapPlans.get(a.Contact__c).WRNA_Lookup_Admin__r.Assessment_Completed_On__c == null)) {
                    
                    mapPlans.get(a.Contact__c).WRNA_Lookup_Admin__c = a.id;
                }            
            
            }
        }               
        
        if(lstPlans.size() > 0) {
            update lstPlans;
        }
    }
    
}