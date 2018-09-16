public class assessPreloadCon {

    private final Assessment__c myAssess;
    public String retURL {get; set;}
    public String rType {get; set;}
    public String ent {get; set;}
    public String contactId {get; set;}
    public String contactName {get; set;}
    public Id UCLA_PTSD_DSM_V = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('UCLA PTSD DSM V').getRecordTypeId();
    public Id CEP_BPS_ASSESSMENT = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CEP BPS Assessment').getRecordTypeId(); 
    public Id PHQ_9 = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('PHQ-9').getRecordTypeId();    
    public Id SUBSTANCE_ABUSE_ASSESSMENT = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Substance Abuse Assessment').getRecordTypeId();

    public assessPreloadCon(ApexPages.StandardController controller) 
    {
        this.myAssess = (Assessment__c)controller.getRecord();
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        ent = ApexPages.currentPage().getParameters().get('ent');
        contactID = ApexPages.currentPage().getParameters().get('CF00N60000001rJHg_lkid');
        contactName=ApexPages.currentPage().getParameters().get('CF00N60000001rJHg');
        rType = Apexpages.currentPage().getParameters().get('RecordType');
        Id recordId = controller.getId();
        if(recordId == null)
        {
            myAssess.Client_Name__c = contactName;
            myAssess.Contact__c = contactId;
            myAssess.RecordTypeId = Apexpages.currentPage().getParameters().get('RecordType');            
        }       
    }
    
    public PageReference saveAssessment()
    {
        string username = Userinfo.getUserName();
        string profile = Userinfo.getProfileId();
        string recordType = myAssess.recordtypeid;
        if (myAssess.Id == null)
            insert myAssess;
        else
            update myAssess;
        PageReference viewPage = new PageReference('/'+ myAssess.Id);
        viewPage.setRedirect(true);
        return viewPage;
    }
    
    
    Public PageReference LockRecord()
    {
        boolean complete = true;
        String pageName;    

        if(myAssess.RecordTypeId == UCLA_PTSD_DSM_V)    
        {

        if (String.IsBlank(myAssess.UC_SelfRpt_Q02_disaster__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q02_disaster__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q03_accident__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q03_accident__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q04_war__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q04_war__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q05_Hit_hard__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q05_Hit_hard__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q06_family_member__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q06_family_member__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q07_school__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q07_school__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q08_someone_beaten__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q08_someone_beaten__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q09_dead_body__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q09_dead_body__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q10_touch__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q10_touch__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q11_loved_one__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q11_loved_one__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q12_medical_treatment__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q12_medical_treatment__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q13_Forced_sex__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q13_Forced_sex__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q14_Died__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q14_Died__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_SelfRpt_Q15_Anything_else__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_SelfRpt_Q15_Anything_else__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q01__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q01__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}
    
        if (String.IsBlank(myAssess.UC_Reaction_Q02__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q02__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}
   
        if (String.IsBlank(myAssess.UC_Reaction_Q03__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q03__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}
   
        if (String.IsBlank(myAssess.UC_Reaction_Q04__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q04__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q05__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q05__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q06__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q06__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q07__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q07__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q08__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q08__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q09__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q09__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q10__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q10__c.getDescribe().getLabel()+' ** Question must be answered **'));

        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q11__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q11__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q12__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q12__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q13__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q13__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q14__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q14__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q15__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q15__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q16__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q16__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q17__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q17__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q18__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q18__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q19__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q19__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q20__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q20__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q21__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q21__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q22__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q22__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q23__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q23__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q24__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q24__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q25__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q25__c.getDescribe().getLabel()+' ** Question must be answered **'));

        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q26__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q26__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q27__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q27__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q28__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q28__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q29__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q29__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q30__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q30__c.getDescribe().getLabel()+' ** Question must be answered **'));        
        complete=false;}

        if (String.IsBlank(myAssess.UC_Reaction_Q31__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Reaction_Q31__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Clinical_Developmental_Q1__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Clinical_Developmental_Q1__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Clinical_Home_Q1__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Clinical_Home_Q1__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Clinical_Home_Q2__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Clinical_Home_Q2__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Clinical_Home_Q3__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Clinical_Home_Q3__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Clinical_Peer_Q1__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Clinical_Peer_Q1__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Clinical_School_Q1__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Clinical_School_Q1__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}

        if (String.IsBlank(myAssess.UC_Clinical_School_Q2__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Schema.Assessment__c.fields.UC_Clinical_School_Q2__c.getDescribe().getLabel()+' ** Question must be answered **'));
        complete=false;}         
        }

        if (complete==true)
        {
            if(myAssess.RecordTypeId == UCLA_PTSD_DSM_V) 
                myAssess.UC_PTSD_RI__c = myAssess.UC_Reaction_Category_B_Sum__c + myAssess.UC_Reaction_Category_C_Sum__c +myAssess.UC_Reaction_Category_D_Sum__c + myAssess.UC_Reaction_Category_E_Sum__c;    
            myAssess.Assessment_Completed_by__c = UserInfo.getUserId();
            myAssess.Assessment_Completed_on__c = System.Today();
            myAssess.Locked__c = TRUE;
            update myAssess;
            if (myAssess.RecordTypeId == CEP_BPS_ASSESSMENT ) 
                { pageName = 'apex/CEP_BPS_Assessment_PDF?id=';}
            else
                if (myAssess.RecordTypeId == UCLA_PTSD_DSM_V) 
                    {pageName = 'apex/UCLA_PTSD_DSMV_View?id=';}
                else
                    if (myAssess.RecordTypeId == PHQ_9) 
                        {pageName = NULL;}
                    else
                        if (myAssess.RecordTypeId == SUBSTANCE_ABUSE_ASSESSMENT)
                            {pageName = NULL;}        
            savetoPDF(myAssess.Id, pageName, myAssess.RecordType.Name);
        }
        return null;
    }
    
    @future(callout=true)
    private static void savetoPDF(Id assessId, String pageName, String assessName)
    { 
        Assessment__c myAssess = [SELECT Id, Client_Name__c FROM Assessment__c WHERE Id = :assessId LIMIT 1];
        PageReference pagePdf = new PageReference('/'+pageName+myAssess.Id); 
        Blob pdfPageBlob; pdfPageBlob = pagePdf.getContentAsPDF(); 
        Document d = new Document(); 
        d.Body = pdfPageBlob; 
        d.Name = myAssess.Client_Name__c+'-'+assessName+'.pdf'; 
        d.FolderId = '00l60000001SLoM';
        d.Description = 'Saved Assessment'; 
        d.Type = 'pdf';
        d.ContentType = 'application/pdf';
        insert d; 
    }
}