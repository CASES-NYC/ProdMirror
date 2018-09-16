public class dispatchAssessEditCon 
{
    private final Assessment__c assess;
    private final id recordId;

    public String retURL {get; set;}
    public Id CEP_ICD_Assessment = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP ICD Assessment').getRecordTypeId();
    public Id CEP_BPS_Assessment = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP BPS Assessment').getRecordTypeId();      
    public Id SR_Intake_Needs_Assessment = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('SR Intake Needs Assessment').getRecordTypeId();        
    public Id UCLA_PTSD_DSM_V = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('UCLA PTSD DSM V').getRecordTypeId();
    public Id Health_and_Wellbeing = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Health and Wellbeing Assessment').getRecordTypeId();
    public Id Life_Events_Checklist = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Life Events Checklist (LEC)').getRecordTypeId();    
    
    public dispatchAssessEditCon(ApexPages.StandardController controller) 
    {
        this.assess = (Assessment__c)controller.getRecord();
        this.recordId = this.assess.Id;
        retURL = ApexPages.currentPage().getParameters().get('retURL');
    }


    public PageReference redirect()
    {
        Assessment__c a = [SELECT Id, RecordtypeId, SR_Intake_Needs__c FROM Assessment__c WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        system.debug('RECORDTYPE: ' + a.recordTypeId);
        PageReference nextPage;
          // Redirect if Record Type corresponds to custom VisualForce page
        IF(a.RecordTypeId == CEP_ICD_Assessment) 
               nextPage = new PageReference('/apex/CEP_ICD_Assessment_Edit?id='+this.recordId);
        ELSE
            IF(a.RecordTypeId == CEP_BPS_Assessment)       
                 nextPage = new PageReference('/apex/CEP_BPS_Assessment_Edit?id='+this.recordId);
            ELSE
                IF(a.RecordTypeId == UCLA_PTSD_DSM_V)
                    nextPage = new PageReference('/apex/UCLA_PTSD_DSMV_Edit?id='+this.recordId);
                ELSE
                    IF(a.RecordtypeId == SR_Intake_Needs_Assessment)
                        nextPage = new PageReference('/'+ a.SR_Intake_Needs__c +'/e');
                  ELSE
                      IF(a.RecordtypeId == Health_and_Wellbeing || a.RecordTypeId == Life_Events_Checklist)
                          nextPage = new PageReference('/apex/Assessment_Dispatch_Master?id='+ a.Id);
                      ELSE
                      {  
                        nextPage = new PageReference('/'+ a.Id +'/e');
                        nextPage.getParameters().put('nooverride', '1');
                      }
       nextPage.getParameters().put('retURL',retURL);
       nextPage.setRedirect(true);
       return nextPage;       
    }

}