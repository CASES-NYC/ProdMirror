public with sharing class assessmentButtonExt 
{

    private final sObject mysObject;
    public String assessId;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public assessmentButtonExt(ApexPages.StandardController stdController) 
    {
        this.mysObject = (sObject)stdController.getRecord(); 
    }

    public String markComplete() 
    {
        mysObject.put('IsComplete__c',true);
        mysObject.put('Completed_Date__c', Date.today());
        mysObject.put('Completed_by__c', UserInfo.getUserId());
        update mysObject;
        assessId =  String.valueOf( 'mySObject.AssessmentId__c') ; 

        List<Assessment__c> updAssess = new List<Assessment__c>([
              SELECT Id, Assessment_Completed_by__c, Assessment_Completed_on__c 
              FROM Assessment__c WHERE Id = :assessId]);
    
        if(updAssess.size()> 0)
        {
            updAssess[0].Assessment_Completed_by__c  = UserInfo.getUserId();
            updAssess[0].Assessment_Completed_on__c  = Date.today();
            update updAssess[0];
        }
        return null ;
    }
}