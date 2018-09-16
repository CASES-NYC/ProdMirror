public without sharing class assessmentMethods {
    
    public String recordId = ApexPages.currentPage().getParameters().get('id');
    public utilityIds util = new utilityIds();

    
    /////////////////////////////////////////////
    // Method called to lock the record
    // and redirect to the record
    /////////////////////////////////////////////
    
    public PageReference lockRecord() {

        if(recordId != null) {
             
            /// Flip the record type to the locked one
            Assessment__c thisAssessment = [Select  Id, 
                                                    Locked__c, 
                                                    Assessment_Completed_by__c,
                                                    Assessment_Completed_on__c, 
                                                    Gang_Involvement__c,
                                                    Incarcerated_Family_Members__c,
                                                    Expecting_a_Child__c,
                                                    Update_No_of_High_School_Credits__c,
                                                    How_many_children__c,
                                                    Update_Last_Grade_Completed__c,
                                                    Update_Current_Grade__c,
                                                    Update_Diploma_Status_at_Intake__c,
                                                    Update_School_GED_Enrollment_at_Intake__c,
                                                    Update_Employed_at_Intake__c,
                                                    Update_Indication_of_Phys_Health_Problem__c,
                                                    Update_Other_Phys_Health_Problem__c,
                                                    Update_Has_Insurance__c,
                                                    Update_Insurance_Provider__c,
                                                    Update_Insurance_Number__c, 
                                                    RecordTypeId,
                                                    Drugs_Used__c,
                                                    Drugs_Used_Other__c,
                                                    Current_Substance_Abuse_problems__c,
                                                    Drug_test_frequency__c,
                                                    Contact__c,
                                                    What_is_the_last_grade_you_completed__c,
                                                    What_grade_are_you_currently_in__c,
                                                    Education_Information_Confirmed__c,
                                                    Employment_Information_Confirmed__c,
                                                    Client_Contact_Method__c,
                                                    Update_Other_Contact_Information__c,
                                                    Update_Client_Cell_Phone__c,
                                                    Update_Client_Email__c,
                                                    CRAFFT_A1_Drink_any_alcohol__c,
                                                    CRAFFT_A2_Smoke_any_marijuana_or_hashish__c,
                                                    CRAFFT_A3_Use_anything_else_to_get_high__c,
                                                    CRAFFT_Assessment_Recommended__c,
                                                    CRAFFT_B1_In_CAR_driven_by_someone_high__c,
                                                    CRAFFT_B2_Use_drugs_or_alcohol_to_RELAX__c,
                                                    CRAFFT_B3_Use_drugs_or_alcohol_ALONE__c,
                                                    CRAFFT_B4_Ever_FORGET_what_you_did__c,
                                                    CRAFFT_B5_FAMILY_FRIENDS_say_to_cut_down__c,
                                                    CRAFFT_B6_In_TROUBLE_while_using_drugs__c,
                                                    CRAFFT_Yes_in_Part_A__c,
                                                    Update_Mental_Health_Issues_at_Interview__c
                                                    from Assessment__c where Id = :recordId];
                                                    
            // First step: Check Alumni fields

            Boolean cont = true;
            
            if(thisAssessment.RecordTypeId == util.alumniSurveyRecordType){
                
                
                if(thisAssessment.Client_Contact_Method__c == '' || thisAssessment.Client_Contact_Method__c == null) {
                    
                    thisAssessment.addError('You must fill in the Contact Method field before you can mark this assessment complete.');
                    cont= false;
                }                       
                
                if(thisAssessment.Client_Contact_Method__c == 'Career Ex Grad Survey') {
                    

                    if(thisAssessment.Education_Information_Confirmed__c != 'Yes' || thisAssessment.Employment_Information_Confirmed__c != 'Yes' ) {
                        
                        thisAssessment.addError('You must confirm the client\'s Education and Employment Information before you can mark this assessment complete.');
                        cont= false;
                    }
                }               

                
                if(thisAssessment.Client_Contact_Method__c == 'Third Party Contact/ Info Confirmed'
                || thisAssessment.Client_Contact_Method__c == 'Phone'
                || thisAssessment.Client_Contact_Method__c == 'Email'
                || thisAssessment.Client_Contact_Method__c == 'In Person') {
                
                    if((thisAssessment.Education_Information_Confirmed__c != 'Yes' 
                    && thisAssessment.Employment_Information_Confirmed__c != 'Yes')
                    || thisAssessment.Education_Information_Confirmed__c == null
                    || thisAssessment.Employment_Information_Confirmed__c == null) {
                    
                        thisAssessment.addError('You must confirm the client\'s Education or Employment Information before you can mark this assessment complete.');
                        cont= false;
                    }                       
                }                       
                
            }            
            //added 12/9/13 for CRAFFT additions to substance abuse recordtype
                    
            else if(thisAssessment.RecordTypeId == util.subAbuseAssessmentRecordType)
            {
                                    
                if(thisAssessment.CRAFFT_A1_Drink_any_alcohol__c == null 
                || thisAssessment.CRAFFT_A2_Smoke_any_marijuana_or_hashish__c == null
                || thisAssessment.CRAFFT_A3_Use_anything_else_to_get_high__c == null) {
                                    
                    thisAssessment.addError('You must fill in the CRAFFT fields before you can mark this assessment complete.');
                    cont= false;
                } else if(thisAssessment.CRAFFT_Yes_in_Part_A__c 
                    && (thisAssessment.CRAFFT_B1_In_CAR_driven_by_someone_high__c == null
                    || thisAssessment.CRAFFT_B2_Use_drugs_or_alcohol_to_RELAX__c == null
                    || thisAssessment.CRAFFT_B3_Use_drugs_or_alcohol_ALONE__c == null
                    || thisAssessment.CRAFFT_B4_Ever_FORGET_what_you_did__c == null
                    || thisAssessment.CRAFFT_B5_FAMILY_FRIENDS_say_to_cut_down__c == null
                    || thisAssessment.CRAFFT_B6_In_TROUBLE_while_using_drugs__c == null)) {
                    
                    thisAssessment.addError('If the client responded Yes to any question in CRAFFT Part A, you must complete Part B of the CRAFFT assessment.');
                    cont= false;                    
                }
                
            } else if(thisAssessment.RecordTypeId == util.assUCLA) 
            {}       
                        
            if(cont) {
            
                if(thisAssessment.RecordTypeId == util.alumniSurveyRecordType){
                
                    thisAssessment.RecordTypeId = util.alumniSurveyLockedRecordType;                
                } else if(thisAssessment.RecordTypeId == util.ccAssessmentRecordType){
                
                    thisAssessment.RecordTypeId = util.ccAssessmentLockedRecordType;
                } else if(thisAssessment.RecordTypeId == util.eduAssessmentRecordType){
                
                    thisAssessment.RecordTypeId = util.eduAssessmentLockedRecordType;
                } else if(thisAssessment.RecordTypeId == util.homeVisitRecordType){
                
                    thisAssessment.RecordTypeId = util.homeVisitLockedRecordType;
                } else if(thisAssessment.RecordTypeId == util.psyAssessmentRecordType){
                
                    thisAssessment.RecordTypeId = util.psyAssessmentLockedRecordType;
                } else if(thisAssessment.RecordTypeId == util.subAbuseAssessmentRecordType){
                
                    thisAssessment.RecordTypeId = util.subAbuseAssessmentLockedRecordType;
                } else if(thisAssessment.RecordTypeId == util.assUCLA){
                    
                    thisAssessment.RecordTypeId = util.assUCLALocked;
                } else if(thisAssessment.RecordTypeId == util.assPHQ9){
                    
                    thisAssessment.RecordTypeId = util.assPHQ9Locked;
                } else if(thisAssessment.RecordTypeId == util.assCourtRep){
                
                    thisAssessment.RecordTypeId = util.assCourtRepLocked;
                }
    
    
                thisAssessment.Locked__c = true;
                thisAssessment.Assessment_Completed_by__c = UserInfo.getUserId();
                thisAssessment.Assessment_Completed_on__c = System.Today();
                
                
                system.debug('thisAssessment.Assessment_Completed_on__c: ' + thisAssessment.Assessment_Completed_on__c );
                system.debug('thisAssessment.Assessment_Completed_by__c: ' + thisAssessment.Assessment_Completed_by__c );
                update thisAssessment;       
            
                
                //only update contact for certain recordtypes
                if(thisAssessment.RecordTypeId == util.alumniSurveyLockedRecordType || thisAssessment.RecordTypeId == util.subAbuseAssessmentLockedRecordType
                || thisAssessment.RecordTypeId == util.psyAssessmentLockedRecordType || thisAssessment.RecordTypeId == util.eduAssessmentLockedRecordType
                || thisAssessment.RecordTypeId == util.ccAssessmentLockedRecordType || thisAssessment.RecordTypeId == util.assCourtRepLocked) {

                    // Now we need to update the contact associated with the assessment
                    Contact contactEffected = [Select 
                                                    Id,
                                                    Number_of_children__c,
                                                    Gang_Involvement__c,
                                                    Incarcerated_Family_Members__c,
                                                    Expecting_a_Child__c,
                                                    Diploma_Type__c,
                                                    Diploma_Date__c,
                                                    What_grade_are_you_currently_in__c,
                                                    Diploma_Status_at_Intake__c,
                                                    School_GED_Enrollment_at_Intake__c,
                                                    Employed_at_Intake__c,
                                                    Indication_of_Physical_Health_Problems__c,
                                                    Other_Physical_Health__c ,
                                                    Do_you_have_Insurance__c ,
                                                    Insurance_Provider__c,
                                                    Insurance_Number__c,
                                                    How_many_credits_have_you_earned__c,
                                                    What_is_the_last_grade_you_completed__c, 
                                                    Required_Documents__c,
                                                    Drugs_Used__c,
                                                    Drugs_Used_Other__c,
                                                    Current_Substance_Abuse_problems__c,
                                                    Drug_test_frequency__c,
                                                    Other_Contact_Information__c,
                                                    Client_Cell_Phone__c,
                                                    Email,
                                                    Substance_Abuse_at_Intake__c,
                                                    Mental_Health_Issues_at_Intake__c                                                
                                                    From Contact Where Id = :thisAssessment.Contact__c];
            
                    // Alumni Survey Assessment
                   
                    if(thisAssessment.RecordTypeId == util.alumniSurveyLockedRecordType) {
                        if(thisAssessment.Update_Other_Contact_Information__c != thisAssessment.Other_Contact_Information__c) 
                            { contactEffected.Other_Contact_Information__c = thisAssessment.Update_Other_Contact_Information__c;}           
                        if(thisAssessment.Update_Client_Cell_Phone__c != null) 
                            { contactEffected.Client_Cell_Phone__c = thisAssessment.Update_Client_Cell_Phone__c;}                   
                        if(thisAssessment.Update_Client_Email__c != null) 
                            { contactEffected.Email = thisAssessment.Update_Client_Email__c;}   
                    
                    } else if(thisAssessment.RecordTypeId == util.subAbuseAssessmentLockedRecordType) {// Substance abuse  Assessment
                        
                        if(thisAssessment.Drug_test_frequency__c != null) { contactEffected.Drug_test_frequency__c = thisAssessment.Drug_test_frequency__c;}
                        if(thisAssessment.Current_Substance_Abuse_problems__c != null) { contactEffected.Current_Substance_Abuse_problems__c = thisAssessment.Current_Substance_Abuse_problems__c;}
                        if(thisAssessment.Drugs_Used__c != null) { contactEffected.Drugs_Used__c = thisAssessment.Drugs_Used__c;}
                        if(thisAssessment.Drugs_Used_Other__c != null) { contactEffected.Drugs_Used_Other__c = thisAssessment.Drugs_Used_Other__c;}
                        if(thisAssessment.Update_Has_Insurance__c != null) { contactEffected.Do_you_have_Insurance__c = thisAssessment.Update_Has_Insurance__c;}
                        if(thisAssessment.Update_Insurance_Provider__c != null) { contactEffected.Insurance_Provider__c = thisAssessment.Update_Insurance_Provider__c;}
                        if(thisAssessment.Update_Insurance_Number__c != null) { contactEffected.Insurance_Number__c = thisAssessment.Update_Insurance_Number__c;}
                        if(thisAssessment.Update_Indication_of_Phys_Health_Problem__c != null) { contactEffected.Indication_of_Physical_Health_Problems__c = thisAssessment.Update_Indication_of_Phys_Health_Problem__c;}
                        if(thisAssessment.Update_Other_Phys_Health_Problem__c != null) { contactEffected.Other_Physical_Health__c = thisAssessment.Update_Other_Phys_Health_Problem__c;}
    
                    } else if(thisAssessment.RecordTypeId == util.psyAssessmentLockedRecordType) {// Psyc Assessment
                        
                        if(thisAssessment.Update_Has_Insurance__c != null) { contactEffected.Do_you_have_Insurance__c = thisAssessment.Update_Has_Insurance__c;}
                        if(thisAssessment.Update_Insurance_Provider__c != null) { contactEffected.Insurance_Provider__c = thisAssessment.Update_Insurance_Provider__c;}
                        if(thisAssessment.Update_Insurance_Number__c != null) { contactEffected.Insurance_Number__c = thisAssessment.Update_Insurance_Number__c;}
                        
                    } else if(thisAssessment.RecordTypeId == util.eduAssessmentLockedRecordType) { // Education Assessment
                        if(thisAssessment.Update_School_GED_Enrollment_at_Intake__c != null) { contactEffected.School_GED_Enrollment_at_Intake__c = thisAssessment.Update_School_GED_Enrollment_at_Intake__c;}
                        if(thisAssessment.Update_Diploma_Status_at_Intake__c!= null) { contactEffected.Diploma_Status_at_Intake__c = thisAssessment.Update_Diploma_Status_at_Intake__c;}
                        if(thisAssessment.Update_Current_Grade__c!= null) { contactEffected.What_grade_are_you_currently_in__c = thisAssessment.Update_Current_Grade__c;}
                        if(thisAssessment.Update_No_of_High_School_Credits__c != null) { contactEffected.How_many_credits_have_you_earned__c = thisAssessment.Update_No_of_High_School_Credits__c;}
                        if(thisAssessment.Update_Last_Grade_Completed__c != null) { contactEffected.What_is_the_last_grade_you_completed__c = thisAssessment.Update_Last_Grade_Completed__c;}
                
                
                    } else if(thisAssessment.RecordTypeId == util.ccAssessmentLockedRecordType) { //CC Assessment
                        
                        if(thisAssessment.Update_No_of_High_School_Credits__c != null) { contactEffected.How_many_credits_have_you_earned__c = thisAssessment.Update_No_of_High_School_Credits__c;}
                        if(thisAssessment.Update_Last_Grade_Completed__c != null) { contactEffected.What_is_the_last_grade_you_completed__c = thisAssessment.Update_Last_Grade_Completed__c;}
                        if(thisAssessment.Gang_Involvement__c != null) { contactEffected.Gang_Involvement__c = thisAssessment.Gang_Involvement__c;}
                        if(thisAssessment.Incarcerated_Family_Members__c != null) { contactEffected.Incarcerated_Family_Members__c = thisAssessment.Incarcerated_Family_Members__c;}
                        if(thisAssessment.Expecting_a_Child__c != null) { contactEffected.Expecting_a_Child__c = thisAssessment.Expecting_a_Child__c;}
                        if(thisAssessment.How_many_children__c != null) { contactEffected.Number_of_children__c = thisAssessment.How_many_children__c;}
                        if(thisAssessment.Update_Current_Grade__c!= null) { contactEffected.What_grade_are_you_currently_in__c = thisAssessment.Update_Current_Grade__c;}
                        if(thisAssessment.Update_Diploma_Status_at_Intake__c!= null) { contactEffected.Diploma_Status_at_Intake__c = thisAssessment.Update_Diploma_Status_at_Intake__c;}
                        if(thisAssessment.Update_School_GED_Enrollment_at_Intake__c != null) { contactEffected.School_GED_Enrollment_at_Intake__c = thisAssessment.Update_School_GED_Enrollment_at_Intake__c;}
                        if(thisAssessment.Update_Employed_at_Intake__c  != null) { contactEffected.Employed_at_Intake__c = thisAssessment.Update_Employed_at_Intake__c;}
                        if(thisAssessment.Update_Indication_of_Phys_Health_Problem__c != null) { contactEffected.Indication_of_Physical_Health_Problems__c = thisAssessment.Update_Indication_of_Phys_Health_Problem__c;}
                        if(thisAssessment.Update_Other_Phys_Health_Problem__c != null) { contactEffected.Other_Physical_Health__c = thisAssessment.Update_Other_Phys_Health_Problem__c;}
                        if(thisAssessment.Update_Has_Insurance__c != null) { contactEffected.Do_you_have_Insurance__c = thisAssessment.Update_Has_Insurance__c;}
                        if(thisAssessment.Update_Insurance_Provider__c != null) { contactEffected.Insurance_Provider__c = thisAssessment.Update_Insurance_Provider__c;}
                        if(thisAssessment.Update_Insurance_Number__c != null) { contactEffected.Insurance_Number__c = thisAssessment.Update_Insurance_Number__c;}
  
                                     
                    } else if(thisAssessment.RecordTypeId == util.assCourtRepLocked) { //Court Rep Assessment
    
                        if(thisAssessment.Update_Diploma_Status_at_Intake__c!= null) { contactEffected.Diploma_Status_at_Intake__c= thisAssessment.Update_Diploma_Status_at_Intake__c;}
                        if(thisAssessment.Update_School_GED_Enrollment_at_Intake__c!= null) { contactEffected.School_GED_Enrollment_at_Intake__c= thisAssessment.Update_School_GED_Enrollment_at_Intake__c;}
                        if(thisAssessment.Update_Employed_at_Intake__c!= null) { contactEffected.Employed_at_Intake__c= thisAssessment.Update_Employed_at_Intake__c;}    
                        if(thisAssessment.Current_Substance_Abuse_Problems__c!= null) { contactEffected.Substance_Abuse_at_Intake__c= thisAssessment.Current_Substance_Abuse_Problems__c;}
                        if(thisAssessment.Update_Mental_Health_Issues_at_Interview__c!= null) { contactEffected.Mental_Health_Issues_at_Intake__c= thisAssessment.Update_Mental_Health_Issues_at_Interview__c;}                                                                        
                   }
                    
                    update contactEffected;
                    
                }
                
                //// reload the page
                PageReference newPage = new PageReference('/' + recordId);
                newPage.setRedirect(true);
                return newPage;
            
            } else {
                
                return null;
            }
            
        } else {
            
            return null;
        }
        
    }   

}