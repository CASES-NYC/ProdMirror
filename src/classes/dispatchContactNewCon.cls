public class dispatchContactNewCon 
{
    private ApexPages.StandardController controller;
    public String retURL {get; set;}
    public String rType {get; set;}
    public String ent {get; set;}
    public String contactID {get; set;}
    public String contactName {get; set;}
    public Id BxPeakClient = 
        Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BX PEAK Client').getRecordTypeId();  
    public Id BkPeakClient = 
        Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BK PEAK Client').getRecordTypeId(); 
    
    public dispatchContactNewCon(ApexPages.StandardController controller) 
    {
      system.debug('entering constructor');
      this.controller = controller;
      system.debug(controller);
      retURL = ApexPages.currentPage().getParameters().get('retURL');
      rType = ApexPages.currentPage().getParameters().get('RecordType');
      ent = ApexPages.currentPage().getParameters().get('ent');
    }


    public PageReference redirect()
    {
      PageReference nextPage;
          // Redirect if Record Type corresponds to custom VisualForce page
      IF(rType == BxPeakClient || rType == BkPeakClient) 
          nextPage = new PageReference('/apex/PEAK_Intake_Screen');
      ELSE                 
                      nextPage = new PageReference('/003/e');
      nextPage.getParameters().put('retURL', retURL);
      nextPage.getParameters().put('RecordType', rType);
      nextPage.getParameters().put('ent', ent);
      nextPage.getParameters().put('nooverride', '1');         
      nextPage.setRedirect(true);
      return nextPage;
    }
}