public with sharing class PEAK_Intake_Screen_Con 
{
    public Account acc {get; set;}
    public Contact con {get; set;}
    public Case_Information__c  caseInfo {get; set;}
    public Address_Information__c addressInfo {get;set;}
    public String txtFirstName {get;set;}
    public String txtLastName {get;set;}
    public Id recTypeId;
    public Id accid;
    public Id accountId;

    public PEAK_Intake_Screen_Con() 
    {
        acc = new Account();
        con = new Contact();
        caseInfo = new Case_Information__c();
        addressInfo = new Address_Information__c();
        recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        accid = ApexPages.currentPage().getParameters().get('accid');
        system.debug('RECORD TYPE ID: ' + recTypeId);         
    }

    public PageReference Cancel() 
    {
        return null;
    }


    public PageReference Save() 
    {
        if(accid == NULL)
        {
            system.debug('NAME: ' + txtFirstName + ' ' + txtLastName);
            acc.Name = txtFirstName + ' ' + txtLastName;
            system.debug('NAME: ' + acc.Name);
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
            Insert acc;
            accountId = acc.Id;
        } else
        {
            accountId = accid;
        }
            
        caseInfo.RecordTypeId = Schema.SObjectType.Case_Information__c.getRecordTypeInfosByName().get('Family Court').getRecordTypeId();
        caseInfo.Client_Account__c = accountId;
        caseInfo.No_Docket__c = true;
        if ( recTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BK PEAK Client').getRecordTypeId())
            caseInfo.Borough__c = 'Brooklyn';
           
        else if(recTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BX PEAK Client').getRecordTypeId())
            caseInfo.Borough__c = 'Bronx';
        Insert caseInfo;
        
        con.AccountId = accountId;
        con.LastName = txtLastName;
        con.FirstName = txtFirstName;
        con.RecordTypeId = recTypeId;
        con.Intake_Case__c = caseInfo.Id;
        con.Client_Status__c = 'Incomplete Screening';
        Insert con;
        
        addressInfo.Client__c = con.Id;
        Insert addressInfo;     
     
        PageReference contactPage = new PageReference('/'+ con.Id);
        contactPage.setRedirect(true);
        return contactPage; 
    }

}