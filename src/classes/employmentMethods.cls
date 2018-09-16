public class employmentMethods {

    public List<Employment__c> newEmployments = new List<Employment__c>();

    ///////////////////////
    // TRIGGER ACTIONS
    ///////////////////////
    
    public void updateContactEmploymentSection() {
        
        String strCurEmployment = '';
        String strEmployer = '';
        String strJobTitle = '';
        String strWorkHours = '';
        Date dteStartDate = null;
        Double dblHourlyPay = null;
        
        String strRecentEmployer = '';
        String strRecentEmployerType = '';
        Date dtRecentStartDate = null;
        Date dtRecentEndDate = null;
        
        Date dtHoldEndDate = null;
        
        // Get Client Set for Update
        Set<Id> clientIds = new Set<Id>();
        for(Employment__c thisEmp : newEmployments) {
        
            clientIds.add(thisEmp.Client__c);
        }
        
        // Get Client and Employment records (sub-query)
        List<Contact> lstEffCont = [SELECT c.Job_Title__c, c.Employer__c, c.Current_Employment__c, (SELECT Hourly_Pay__c, Employment_Type__c, Job_Title__c, Start_Date__c, End_Date__c, Employer_Name__c, Work_Hours_from_and_to__c FROM Client__r ORDER BY Start_Date__c ASC) FROM Contact c Where Id in :clientIds];
        
        // Start Looping and Testing Contact
        for (Contact thisContact : lstEffCont) {
            
            // Clear out variables
            strCurEmployment = 'Unemployed';
            strEmployer = '';
            strJobTitle = '';
            strWorkHours = '';
            dteStartDate = null;
            dblHourlyPay = null;
            //random start date of 1/1/1950
            dtHoldEndDate = date.newInstance(1950, 1, 1);
            
            // Enter Employment__c sub-loop
            for (Employment__c thisEmp : thisContact.Client__r) {
                
                // Check for single record vs. multiple records
                if (thisContact.Client__r.size() == 1) {
                    
                    if (thisEmp.End_Date__c == null) {
                        strCurEmployment = thisEmp.Employment_Type__c;
                        strEmployer = thisEmp.Employer_Name__c;
                        strJobTitle = thisEmp.Job_Title__c;
                        strWorkHours = thisEmp.Work_Hours_from_and_to__c;
                        dteStartDate = thisEmp.Start_Date__c;
                        dblHourlyPay = thisEmp.Hourly_Pay__c;
                    }
                        //20120913 ebg - BT-030
                        strRecentEmployer = thisEmp.Employer_Name__c;
                        strRecentEmployerType = thisEmp.Employment_Type__c;
                        dtRecentStartDate = thisEmp.Start_Date__c;
                        dtRecentEndDate = thisEmp.End_Date__c;

                    
                } else {
                    // The subquery is sorted by start date, subsequent looping will bring forward the correct values on the last run
                    
                    if (thisEmp.End_Date__c == null) {
                        strCurEmployment = thisEmp.Employment_Type__c;
                        strEmployer = thisEmp.Employer_Name__c;
                        strJobTitle = thisEmp.Job_Title__c;
                        strWorkHours = thisEmp.Work_Hours_from_and_to__c;
                        dteStartDate = thisEmp.Start_Date__c;
                        dblHourlyPay = thisEmp.Hourly_Pay__c;
                        
                        //20120913 ebg - BT-030
                        strRecentEmployer = thisEmp.Employer_Name__c;
                        strRecentEmployerType = thisEmp.Employment_Type__c;
                        dtRecentStartDate = thisEmp.Start_Date__c;
                        dtRecentEndDate = thisEmp.End_Date__c;
                        
                        
                    } else {
                        if (thisEmp.End_Date__c > dtHoldEndDate) {
                            strRecentEmployer = thisEmp.Employer_Name__c;
                            strRecentEmployerType = thisEmp.Employment_Type__c;
                            dtRecentStartDate = thisEmp.Start_Date__c;
                            dtRecentEndDate = thisEmp.End_Date__c;
                        }
                    }
                    dtHoldEndDate = thisEmp.End_Date__c;
                    
                }
                
                                
            }
            
            /////////////////////////
            // Update Contact Fields
            /////////////////////////
            
            thisContact.Current_Employment__c = strCurEmployment;
            thisContact.Employer__c = strEmployer;
            thisContact.Job_Title__c = strJobTitle;
            thisContact.Work_Hours_from_and_to__c = strWorkHours;
            thisContact.Start_Date__c = dteStartDate;
            thisContact.Hourly_Pay__c = dblHourlyPay;   
            
            //20120913 ebg - BT-030
            thisContact.Most_Recent_Employer__c = strRecentEmployer;
            thisContact.Most_Recent_Employment_Type__c = strRecentEmployerType;
            thisContact.Most_Recent_Employment_Start_Date__c = dtRecentStartDate;
            thisContact.Most_Recent_Employment_End_Date__c = dtRecentEndDate;
                    
        }
        
        // Commit Updates
        update lstEffCont;
    }
}