public with sharing class srpNeedsMasterExt 
{
    //public SR_Intake_Needs_Assessment__c srNeeds {get; set;}
    public String retURL = ApexPages.currentPage().getParameters().get('retURL');
    private final Assessment__c srpMaster;

    public srpNeedsMasterExt(ApexPages.StandardController stdController) 
    {
        this.srpMaster = (Assessment__c)stdController.getRecord();
    }

    public pageReference initialize()
    {
        if(srpMaster.Id == null)
        {
            String contactId = ApexPages.currentPage().getParameters().get('contactId');
            srpMaster.Contact__c = contactId;
            srpMaster.RecordTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('SR Intake Needs Assessment').getRecordTypeId();
            insert srpMaster;
            SR_Intake_Needs_Assessment__c srNeeds = New SR_Intake_Needs_Assessment__c();
            srNeeds.AssessmentID__c = srpMaster.Id;
            srNeeds.Participant__c = srpMaster.Contact__c;
            insert srNeeds;
            srpMaster.SR_Intake_Needs__c = srNeeds.Id;
            update srpMaster;
        }

        PageReference pageRef= new PageReference('/'+ srpMaster.SR_Intake_Needs__c + '/e');
        pageRef.setRedirect(true);
        return pageRef;
    }

}