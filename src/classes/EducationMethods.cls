public with sharing class EducationMethods {

    //////////////////////////////////////////////////////////
    // This class is for the "Education" object
    //////////////////////////////////////////////////////////

    public utilityMethods util = new utilityMethods();
    public List<Education__c> newEducations = new List<Education__c>();
    date schoolEndDate; 

    ///////////////////////
    // TRIGGER ACTIONS
    ///////////////////////

    public void updateContactEduEmpSection() {
        
        // 11/10/12 MB: This field is being removed from salesforce and replaced by School/ GED Enrollment at Intake
        //String strSchoolDiplomaStatusAtIntake = '';
        
        // 11/8/12 MB: As per dvm.a.BT-0708 these fields are now being updated via utilityMethods.updateDiplomaFieldsOnContact()
        //String strDiplomaType = '';
        //Date dteDiplomaDate = null;
        Date dteDiplomaDateOrig = null;
        // 12/6/12 MB: Code in this class was written incorrectly so that this variable was always set to a blnak value, 
        //clearing the value on the contact page. We've decided (dvm.a.BT-0714) that this value should no longer be updateable via the ed record. 
        //String strDiplomaStatus = '';
        String strEducationStatus = '';
        String strLastSchoolAttended = '';
        Date dteLastSchoolAttended = null;
        Date dteSchoolStartDate = null;
        Date dteSchoolEndDate = null;
        String strReasonForLeavingSchool = '';
        String strReasonForLeavingSchoolOther = '';
        String strSchoolHours = '';
        
        
        Set<Id> clientIds = new Set<Id>();
        
        for(Education__c thisEducation : newEducations) {
        
            clientIds.add(thisEducation.Client__c);
        }
        
        
        List<Contact> lstEffCont = [Select c.Intake_Date__c
                                        , c.School_Start_Date__c
                                        , c.School_Institution_Hours_from_and_to__c
                                        , c.School_End_Date__c
                                        , c.Reason_for_Leaving_School__c
                                        , c.Reason_for_Leaving_School_Other__c
                                        , c.Last_School_Attended__c
                                        , c.Current_School_Enrollment__c
                                        , c.Diploma_Type__c
                                        , c.Diploma_Date__c
                                        , (Select School_Institution_Name__c
                                                , Institution_Type__c
                                                , School_Institution_Hours_From_and_To__c
                                                , Start_Date__c
                                                , End_Date__c
                                                , Reason_for_Leaving__c
                                                , School_Institution__c
                                                , Reason_for_Leaving_Other__c
                                                , Diploma_Type__c 
                                            From Education__r 
                                            Order By Start_Date__c ASC)                                             
                                    From Contact c 
                                    Where c.Id in :clientIds];
        
        // Start Looping and Testing Contact
        for (Contact thisContact : lstEffCont) {
            
            // 11/10/12 MB: This field is being removed from salesforce and replaced by School/ GED Enrollment at Intake
            //strSchoolDiplomaStatusAtIntake = '';
            
            //strDiplomaType = '';
            //dteDiplomaDate = null;
            //strDiplomaStatus = '';
            strEducationStatus = 'Not In School';
            strLastSchoolAttended = '';
            dteLastSchoolAttended = null;
            dteSchoolStartDate = null;
            dteSchoolEndDate = null;
            strReasonForLeavingSchool = '';
            strReasonForLeavingSchoolOther = '';
            strSchoolHours = '';
            
            // BT-286
            dteDiplomaDateOrig = thisContact.Diploma_Date__c;
            
            // 11/10/12 MB: This field is being removed from salesforce and replaced by School/ GED Enrollment at Intake
            /*
            
            ////////////////////////////////////////////////////
            // School / GED Status at Intake
            ////////////////////////////////////////////////////
            strSchoolDiplomaStatusAtIntake = '';
            System.debug('EducationMethods.updateContactEduEmpSection - Finding Education.InstitutionType');
            
            for (Education__c thisEdu : thisContact.Education__r) {
                
                if ((thisEdu.Institution_Type__c == 'High School' 
                        || thisEdu.Institution_Type__c == 'PM School' 
                        || thisEdu.Institution_Type__c == 'GED Program') 
                        && thisEdu.Reason_for_Leaving__c == 'Graduated') {
                    
                    if (thisEdu.End_Date__c != null) {
                        
                        if (thisEdu.End_Date__c < thisContact.Intake_Date__c) {
                            
                            if (thisEdu.Institution_Type__c == 'High School' || thisEdu.Institution_Type__c == 'PM School') {
                                strSchoolDiplomaStatusAtIntake = 'High School Diploma';
                                break;
                            } else {
                                strSchoolDiplomaStatusAtIntake = 'GED Program';
                                break;
                            }
                        }
                    }
                }
            }
            
            System.debug('EducationMethods.updateContactEduEmpSection - Education.InstitutionType = ' + strSchoolDiplomaStatusAtIntake);
            
            */
            
            ////////////////////////////////////////////////////
            // Diploma Type Logic
            ////////////////////////////////////////////////////
            
            // 11/8/12 MB: As per dvm.a.BT-0708 these fields are now being updated via utilityMethods.updateDiplomaFieldsOnContact()
            //strDiplomaType = thisContact.Diploma_Type__c;
            //dteDiplomaDate = thisContact.Diploma_Date__c;
            
            //System.debug('EducationMethods.updateContactEduEmpSection - Finding Education.Diploma Type / Date');
            
            
            // 11/8/12 MB: As per dvm.a.BT-0708 these fields are now being updated via utilityMethods.updateDiplomaFieldsOnContact()
            /*
            for (Education__c thisEdu : thisContact.Education__r) {
            
                System.debug('EducationMethods.updateContactEduEmpSection - Checking on Original Diploma Date = ' + dteDiplomaDateOrig);
                
                // Added 20111214 AAB / QC / PA BT-286
                if(((thisEdu.End_Date__c >= dteDiplomaDateOrig) || dteDiplomaDateOrig == null) && thisEdu.Reason_for_Leaving__c == 'Graduated') {
                    
                    strDiplomaType = thisEdu.Diploma_type__c;
                    dteDiplomaDate = thisEdu.End_Date__c;
                    
                }
                
                // REMOVED 20111214 AAB / QC / PA BT-286
                    if ((thisEdu.Institution_Type__c == 'High School' 
                        || thisEdu.Institution_Type__c == 'PM School' 
                        || thisEdu.Institution_Type__c == 'GED Program') 
                        && thisEdu.Reason_for_Leaving__c == 'Graduated') {
                    
                    if (thisEdu.Institution_Type__c == 'High School' || thisEdu.Institution_Type__c == 'PM School') {
                            // QC Changed. Turns out two types of diplomas. More work needed, what about college? Tech School?
                            // strDiplomaType = 'High School Diploma';
                            strDiplomaType = thisEdu.Diploma_type__c;
                            // QC Change End (commented original line with string, added new line with field value)
                            dteDiplomaDate = thisEdu.End_Date__c;
                        } else {
                            strDiplomaType = 'GED Program';
                            dteDiplomaDate = thisEdu.End_Date__c;
                        }
                }
                
            }
            
            */
            
            //System.debug('EducationMethods.updateContactEduEmpSection - Education.Diploma Type / Date = ' + strDiplomaType + ' / ' + dteDiplomaDate);
            
            ////////////////////////////////////////////////////
            // Education Status (Current School Enrollment)
            ////////////////////////////////////////////////////
            strEducationStatus = 'Not In School';
            System.debug('EducationMethods.updateContactEduEmpSection - Finding Education.Current School Enrollment');
            
            for (Education__c thisEdu : thisContact.Education__r) {
                if (thisEdu.End_Date__c == null) {
                    strEducationStatus = thisEdu.Institution_Type__c;
                    System.Debug('BLARG - ' + strEducationStatus);
                }
            }
            
            System.debug('EducationMethods.updateContactEduEmpSection - Education.Current School Enrollment = ' + strEducationStatus);
            
            ////////////////////////////////////////////////////
            // Last School Attended and Start / End Date - active
            ////////////////////////////////////////////////////
            strLastSchoolAttended = '';
            dteLastSchoolAttended = null;
            System.debug('EducationMethods.updateContactEduEmpSection - Finding Education.Last School Attended');
            
            /////////////////////////////////////////////////////
            //20120726 ebg: BT-10 - modified logic to locate governing Education record and then use data from that record to populate variables
            /////////////////////////////////////////////////////
            Education__c eduGov = new Education__c();
            Date dteLowStartDate = null;
            Date dteHighEndDate = null;

            Integer intEduCount = 0;
            for (Education__c thisEdu : thisContact.Education__r) {
                if (intEduCount == 0) {
                    
                    system.debug('\n\n***Initial governing education record: ' + thisEdu.Start_Date__c + ' - ' + thisEdu.End_Date__c);
                    eduGov = thisEdu;
                    
                } 
                else {
                    
                    //The "governing" ed record is the one with no end date if just one of that type; 
                    //the one with the most recent start date if more than one are current (have no end date); 
                    //and the one with the most recent end date if all ed records have an end date.
                    boolean bolChangeGovRec = false;
                    if (eduGov.End_Date__c != null && thisEdu.End_Date__c == null) {
                        bolChangeGovRec = true;
                    } else if (thisEdu.End_Date__c == null && eduGov.End_Date__c == null && (thisEdu.Start_Date__c > eduGov.Start_Date__c)) {
                        bolChangeGovRec = true;
                    } else if (eduGov.End_Date__c != null && thisEdu.End_Date__c != null && (thisEdu.End_Date__c > eduGov.End_Date__c)) {
                        bolChangeGovRec = true;
                    }
                    
                    if (bolChangeGovRec == true) {
                        eduGov = thisEdu;
                        system.debug('\n\n***Reset governing education record: ' + thisEdu.Start_Date__c + ' - ' + thisEdu.End_Date__c);
                    }

                }
                
                intEduCount++;
            }
            
            dteLastSchoolAttended = eduGov.End_Date__c;
            strLastSchoolAttended = eduGov.School_Institution__c;
            dteSchoolStartDate = eduGov.Start_Date__c;
            dteSchoolEndDate = eduGov.End_Date__c;
            strReasonForLeavingSchool = eduGov.Reason_for_Leaving__c;
            strReasonForLeavingSchoolOther = eduGov.Reason_for_Leaving_Other__c;
            strSchoolHours = eduGov.School_Institution_Hours_From_and_To__c;
            strEducationStatus = eduGov.Institution_Type__c;

            /////////////////////////////////////////////////////
            
            
/*                                    
            for (Education__c thisEdu : thisContact.Education__r) {
                
                if (thisEdu.End_Date__c != null) {
                    dteLastSchoolAttended = thisEdu.End_Date__c;
                    //strLastSchoolAttended = thisEdu.School_Institution_Name__c;
                    strLastSchoolAttended = thisEdu.School_Institution__c;
                    dteSchoolStartDate = thisEdu.Start_Date__c;
                    dteSchoolEndDate = thisEdu.End_Date__c;
                    strReasonForLeavingSchool = thisEdu.Reason_for_Leaving__c;
                    strReasonForLeavingSchoolOther = thisEdu.Reason_for_Leaving_Other__c;
                    strSchoolHours = thisEdu.School_Institution_Hours_From_and_To__c;
                }
            
                // Last School Attended - not active, grab last 
                if (dteLastSchoolAttended == null) {
                    dteLastSchoolAttended = thisEdu.End_Date__c;
                    //strLastSchoolAttended = thisEdu.School_Institution_Name__c;
                    strLastSchoolAttended = thisEdu.School_Institution__c;
                    dteSchoolStartDate = thisEdu.Start_Date__c;
                    dteSchoolEndDate = thisEdu.End_Date__c;
                    strReasonForLeavingSchool = thisEdu.Reason_for_Leaving__c;
                    strReasonForLeavingSchoolOther = thisEdu.Reason_for_Leaving_Other__c;
                    strSchoolHours = thisEdu.School_Institution_Hours_From_and_To__c;
                }
                
                if (strLastSchoolAttended == '' && thisEdu.End_Date__c > dteLastSchoolAttended) {
                    //strLastSchoolAttended = thisEdu.School_Institution_Name__c;
                    strLastSchoolAttended = thisEdu.School_Institution__c;
                }
            }
*/            
            System.debug('EducationMethods.updateContactEduEmpSection - Education.Last School Attended = ' + strLastSchoolAttended);
            
            ////////////////////////////////////////////////////
            // Assign Variables to Contact Record
            ////////////////////////////////////////////////////
            
            // 11/10/12 MB: This field has been removed from salesforce, we are now using School/ GED Enrollment at Intake
            //thisContact.School_GED_Status_at_Intake__c = strSchoolDiplomaStatusAtIntake;
            // 11/8/12 MB: As per dvm.a.BT-0708 these fields are now being updated via utilityMethods.updateDiplomaFieldsOnContact()
            //thisContact.Diploma_Type__c = strDiplomaType;
            //thisContact.Diploma_Date__c = dteDiplomaDate;
            // 12/6/12 MB: see notation above where strDiplomaStatus is initialized
            //thisContact.Diploma_Status_at_Intake__c = strDiplomaStatus;
            //thisContact.Current_School_Enrollment__c = strEducationStatus;
            thisContact.Education_Status__c = strEducationStatus;
            thisContact.Last_School_Attended__c = strLastSchoolAttended;
            thisContact.School_Start_Date__c = dteSchoolStartDate;
            thisContact.School_End_Date__c = dteSchoolEndDate;
            thisContact.Reason_for_Leaving_School__c = strReasonForLeavingSchool;
            thisContact.Reason_for_Leaving_School_Other__c = strReasonForLeavingSchoolOther;
            thisContact.School_Institution_Hours_from_and_to__c = strSchoolHours;
            
            // 11/6/12 MB display "Not in school" if there is no current (i.e. no end date) education record (dvm.a.BT-0705)
            if(dteSchoolEndDate == null) {thisContact.Current_School_Enrollment__c = strEducationStatus;
            }
            else {thisContact.Current_School_Enrollment__c = 'Not in School';}
            
        }
        
        update lstEffCont;
        
    }

}