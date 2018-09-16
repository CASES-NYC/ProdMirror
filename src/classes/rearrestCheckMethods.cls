public without sharing class rearrestCheckMethods 
{   
    public void rearrestCheckInsertLogic(Task thisTask) 
    {
        //if a Rearrest Check task is manually created, enforce rules
        if (thisTask.Automatically_Generated__c == false) 
        {                                
             //enforce rules for the Completed On field
             checkRearrestCompletedOn(thisTask, null);
                            
             //enforce rules for the Open Date field
             checkRearrestOpenDate(thisTask, null);
                            
             //enforce rules for the Verification Due Date field
             checkRearrestVerificationDueDate(thisTask, null);
        }
        
    }
    
    public void rearrestCheckUpdateLogic(Task thisTask, Task oldTask) 
    {       
        //enforce rules for the Completed On field
        checkRearrestCompletedOn(thisTask, oldTask);
                    
        //enforce rules for the Open Date field
        checkRearrestOpenDate(thisTask, oldTask);
                    
        //enforce rules for the Verification Due Date field
        checkRearrestVerificationDueDate(thisTask, oldTask);
    }
                    
                
    ////////////////////////////////////////////////
    //
    // Rearrest Check Completed On field 
    //
    ////////////////////////////////////////////////
    public void checkRearrestCompletedOn(Task thisTask, Task oldTask) 
    {    
        //if inserting a record with a value in Rearrest Check Complete On OR updating the field, enforce rule
        if((oldTask == null && thisTask.Re_arrest_Check_Completed_On__c != null) 
            || (oldTask != null && thisTask.Re_arrest_Check_Completed_On__c != oldTask.Re_arrest_Check_Completed_On__c)) 
        { 
            if (thisTask.Re_arrest_Check_Completed_On__c == null) 
            {
                thisTask.Status = 'Not Started';
                thisTask.Status__c = '';
                thisTask.Closing_Date__c = null;
                thisTask.Closed_By__c = null;
            } else {
                //set the Closing date
                thisTask.Closing_Date__c = System.today();
                thisTask.Closed_By__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
                  
                if (thisTask.Re_arrest_Check_Completed_On__c > thisTask.ActivityDate) 
                {
                    thisTask.Status = 'Done Late';
                    thisTask.Status__c = 'DONE LATE';
                } else {
                    thisTask.Status = 'Done on Time';
                    thisTask.Status__c = 'DONE ON TIME';
                }
            }

        }
        
    }
                    
    ////////////////////////////////////////////////
    //
    // Open Date field 
    //
    ////////////////////////////////////////////////
    public void checkRearrestOpenDate(Task thisTask, Task oldTask) 
    {
        //If no Open Date specified, set it to today
        if (thisTask.Open_Date__c == null) 
        {
            thisTask.Open_Date__c = System.today();
        }       
    }
                    
    ////////////////////////////////////////////////
    //
    // Verification Due Date field 
    //
    ////////////////////////////////////////////////
    public void checkRearrestVerificationDueDate(Task thisTask, Task oldTask) 
    {
        if (oldTask == null || (thisTask.ActivityDate != oldTask.ActivityDate)) 
        {
            //verification due date always matches the due date for reporting reasons
            thisTask.Verification_Due_Date__c = thisTask.ActivityDate;
        }
    }
}