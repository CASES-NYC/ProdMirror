public class dispatchAssessViewCon {
    private final Assessment__c assess;
    private final id recordId;
    private ApexPages.StandardController controller; 
    public String retURL {get; set;}
    public Id CEP_ICD_Assessment = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP ICD Assessment').getRecordTypeId();
    public Id CEP_BPS_Assessment = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP BPS Assessment').getRecordTypeId();      
    public Id SRP_Intake_Needs_Assessment = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('SR Intake Needs Assessment').getRecordTypeId();        
    public Id UCLA_PTSD_DSM_V = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('UCLA PTSD DSM V').getRecordTypeId();    
    public Id Health_and_Wellbeing = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Health and Wellbeing Assessment').getRecordTypeId();
    public Id Life_Events_Checklist = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Life Events Checklist (LEC)').getRecordTypeId();
   
    public dispatchAssessViewCon(ApexPages.StandardController controller) 
    {
        this.assess = (Assessment__c)controller.getRecord();
        this.recordId = this.assess.Id;
    }


    public PageReference redirect()
    {
         Assessment__c a = [SELECT Id, RecordTypeId, SR_Intake_Needs__c, ChildObjectId__c, Contact__c 
            FROM Assessment__c WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];           
        PageReference nextPage;
          // Redirect if Record Type corresponds to custom VisualForce page
        IF(a.RecordTypeId == CEP_ICD_Assessment) 
               nextPage = new PageReference('/apex/CEP_ICD_Assessment_View?id='+this.recordId);
        ELSE
            IF(a.RecordTypeId == CEP_BPS_Assessment)       
                 nextPage = new PageReference('/apex/CEP_BPS_Assessment_View?id='+this.recordId);
            ELSE
                IF(a.RecordTypeId == UCLA_PTSD_DSM_V)
                    nextPage = new PageReference('/apex/UCLA_PTSD_DSMV_View?id='+this.recordId);
                ELSE
                    IF(a.RecordtypeId == SRP_Intake_Needs_Assessment)
                        nextPage = new PageReference('/'+ a.SR_Intake_Needs__c +'/e');                  
                    ELSE
                        IF(a.RecordtypeId == Health_and_Wellbeing || a.RecordtypeId == Life_Events_Checklist)
                            nextPage = new PageReference('/'+ a.ChildObjectId__c );                   
                        ELSE
                        {
                            nextPage = new PageReference('/'+ a.Id);
                            nextPage.getParameters().put('nooverride', '1');
                        }
system.debug('RecordType: ' + a.recordTypeId);
system.debug('PageRef: ' + nextPage);
        retURL = a.Contact__c;
        nextPage.getParameters().put('assessId', a.Id);
        nextPage.getParameters().put('retURL', retURL);        
        nextPage.setRedirect(true);
        return nextPage;
    }
}