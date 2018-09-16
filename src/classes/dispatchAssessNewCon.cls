public class dispatchAssessNewCon 
{
    private ApexPages.StandardController controller;
    public String retURL {get; set;}
    public String rType {get; set;}
    public String ent {get; set;}
    public String contactID {get; set;}
    public String contactName {get; set;}     
    public Id assCepIcdRecType = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP ICD Assessment').getRecordTypeId();
    public Id assCepBpsRecType = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP BPS Assessment').getRecordTypeId();      
    public Id assSRPNeedsIntake = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('SR Intake Needs Assessment').getRecordTypeId();        
    public Id UCLA_PTSD_DSM_V = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('UCLA PTSD DSM V').getRecordTypeId();
    public Id Health_and_Wellbeing= Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Health and Wellbeing Assessment').getRecordTypeId();
    public Id Life_Events_Checklist = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Life Events Checklist (LEC)').getRecordTypeId();  
    public dispatchAssessNewCon(ApexPages.StandardController controller) 
    {
      system.debug('entering constructor');
      this.controller = controller;
      system.debug(controller);
      retURL = ApexPages.currentPage().getParameters().get('retURL');
      rType = ApexPages.currentPage().getParameters().get('RecordType');
      ent = ApexPages.currentPage().getParameters().get('ent');
      contactID = ApexPages.currentPage().getParameters().get('CF00N60000001rJHg_lkid');
      contactName=ApexPages.currentPage().getParameters().get('CF00N60000001rJHg');
    }


    public PageReference redirect()
    {
      PageReference nextPage;
          // Redirect if Record Type corresponds to custom VisualForce page
      IF(rType == assCepIcdRecType) 
          nextPage = new PageReference('/apex/CEP_ICD_Assessment_New');
      ELSE
          IF(rType == assCepBpsRecType)       
              nextPage = new PageReference('/apex/CEP_BPS_Assessment_New');
          ELSE
              IF(rType == UCLA_PTSD_DSM_V)
                  nextPage = new PageReference('/apex/UCLA_PTSD_DSMV_New');
              ELSE
                  IF(rType == assSRPNeedsIntake || rType == Life_Events_Checklist || rType == Health_and_Wellbeing)
                      nextPage = new PageReference('/apex/Assessment_Dispatch_Master'); 
                  ELSE                 
                      nextPage = new PageReference('/a0U/e');
      nextPage.getParameters().put('contactID', contactId);
      nextPage.getParameters().put('retURL', retURL);
      nextPage.getParameters().put('RecordType', rType);
      nextPage.getParameters().put('ent', ent);
      nextPage.getParameters().put('nooverride', '1');
      system.debug('CONTACTID: ' + contactID);          
      IF (contactID != null)
      {
        nextPage.getParameters().put('00Nm0000000tITQ', contactID);
        nextPage.getParameters().put('00N60000001rJHy', contactName); 
        nextPage.getParameters().put('CF00N60000001rJHg_lkid',contactID);
        nextPage.getParameters().put('CF00N60000001rJHg', contactName);            
      }
      nextPage.setRedirect(true);
      return nextPage;
    }
}