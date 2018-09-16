/**
*   {Purpose}  –  test class that loads data for other tests
*
*   {Function}  –  
*                  
*   {Support}   - For assistance with this code, please contact support@demandchainsystems.com              
*                 www.demandchainsystems.com
*                 (952) 345-4533
*/
/**
*   CHANGE  HISTORY
*   =============================================================================
*   Date      Name             Description
*   20141211  EBG DCS          Created
*   =============================================================================*/
@isTest
public class populateTestData_DCS {

    ////////////////////////////////////////////////////////////////////////////////
    //create an account with the given record type
    ////////////////////////////////////////////////////////////////////////////////
    public static List<Account> createAccounts(Id recTypeId, Integer recordsToCreate) {

        List<Account> lstRecords = new List<Account>();
        Integer intNumVal = 0;
        for (Integer i=0; i<recordsToCreate; i++) {
            intNumVal++;
            Account recordNew = new Account();
            recordNew.Name = 'Account - ' + intNumVal;
            recordNew.RecordTypeId = recTypeId;
            recordNew.BillingStreet = intNumVal + ' ' + intNumVal + 'Test Billing Street';
            recordNew.BillingCity = 'TestBillingCity - ' + intNumVal;
            recordNew.BillingState = 'TestBillingState - ' + intNumVal;
            recordNew.BillingCountry = 'TestBillingCountry - ' + intNumVal;
            recordNew.ShippingStreet = intNumVal + ' ' + intNumVal + 'Test Shipping Street';
            recordNew.ShippingCity = 'TestShippingCity - ' + intNumVal;
            recordNew.ShippingState = 'TestShippingState - ' + intNumVal;
            recordNew.ShippingCountry = 'TestShippingCountry - ' + intNumVal;
            recordNew.Phone = '612-808-1234 x.' + intNumVal;
            lstRecords.add(recordNew);
        }
        insert lstRecords;
        return lstRecords;
    }

    ////////////////////////////////////////////////////////////////////////////////
    //create contacts for the given account id
    ////////////////////////////////////////////////////////////////////////////////
    public static List<Contact> createContacts_Client(Id recTypeId, Id acctId, Date intakeDate, Id intakeCaseId, Integer recordsToCreate) {
        
        List<Contact> lstRecords = new List<Contact>();
        Integer intNumVal = 0;
        for (Integer i=0; i<recordsToCreate; i++) {
            intNumVal++;
            Contact recordNew = new Contact();
            recordNew.RecordTypeId = recTypeId;
            recordNew.AccountId = acctId;
            recordNew.FirstName = 'FName' + intNumVal;
            recordNew.LastName = 'LName' + intNumVal;
            recordNew.Phone = '612-808-1234 x.' + intNumVal;
            recordNew.Email = 'test@test.com';
            recordNew.Title = 'Title ' + intNumVal;
            recordNew.Drug_test_frequency__c = 'Bi-Weekly';
            recordNew.Referral_Date__c = intakeDate.addDays(-2);
            recordNew.Attorney_Consent__c = 'Yes';
            recordNew.Eligible__c = 'Yes';
            recordNew.Interview_Acceptance_Date__c = intakeDate;
            recordNew.Interview_Outcome__c = 'CEP Accepts';
            recordNew.Intake_Approved_By__c = userInfo.getUserId();
            recordNew.Intake_Date__c = intakeDate;
            recordNew.Current_Intake_Date__c = intakeDate;        
            recordNew.Intake_Case__c = intakeCaseId;
            lstRecords.add(recordNew);
        }
        insert lstRecords;
        return lstRecords;
    }

    ////////////////////////////////////////////////////////////////////////////////
    //create case information records with the given record type
    ////////////////////////////////////////////////////////////////////////////////
    public static List<Case_Information__c> createCaseInformation(Id recTypeId, Id acctId, Integer recordsToCreate) {

        List<Case_Information__c> lstRecords = new List<Case_Information__c>();
        Integer intNumVal = 0;
        for (Integer i=0; i<recordsToCreate; i++) {
            intNumVal++;
            Case_Information__c recordNew = new Case_Information__c();
            recordNew.Name = '2014RZ1212' + ((intNumVal<10)?'0':'') + intNumVal;
            recordNew.RecordTypeId = recTypeId;
            recordNew.Client_Account__c = acctId;
            recordNew.Arrest_Date__c = Date.today().addMonths(i*-2);
            lstRecords.add(recordNew);
        }
        insert lstRecords;
        return lstRecords;
    }    

    ////////////////////////////////////////////////////////////////////////////////
    //create case records records for the given case information record id and contact id
    ////////////////////////////////////////////////////////////////////////////////
    public static Case_Relationship__c createCaseRelationship(String caseType, Id contactId, Id docketId) {
        List<Case_Relationship__c> lstRecords = new List<Case_Relationship__c>();
        Case_Relationship__c recordNew = new Case_Relationship__c();
        recordNew.Case_Type__c = caseType;
        recordNew.Contact__c = contactId;
        recordNew.Docket__c = docketId;
        lstRecords.add(recordNew);

        insert lstRecords;
        return lstRecords[0];
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    //create orientation events and link to the provided contact
    ////////////////////////////////////////////////////////////////////////////////
    public static List<Event> createOrientationAppointment(Id recTypeId, Id contactId, Integer recordsToCreate) {
        List<Event> lstRecords = new List<Event>();
        Integer intNumVal = 0;
        for (Integer i=0; i<recordsToCreate; i++) {
            intNumVal++;
            Event recordNew = new Event();
            recordNew.RecordTypeId = recTypeId;
            recordNew.WhoId = contactId;
            recordNew.DurationInMinutes = 60;
            recordNew.ActivityDate = Date.today().addMonths(-2);
            recordNew.ActivityDateTime = DateTime.NewInstance(recordNew.ActivityDate, Time.NewInstance(12,0,0,0));
            recordNew.Verification_Status__c = 'Attended';
            lstRecords.add(recordNew);
        }
        insert lstRecords;
        return lstRecords;        
    }

    ////////////////////////////////////////////////////////////////////////////////
    //populate data to test the intake packet
    ////////////////////////////////////////////////////////////////////////////////
    public static Contact loadTestIntakePacketData() {
        UtilityIds utilIds = new UtilityIds();
        
        List<Account> lstAccts = populateTestData_DCS.createAccounts(utilIds.accClient, 1);
        Date intakeDate = Date.today().addMonths(-2);
        List<Case_Information__c> lstCI = populateTestData_DCS.createCaseInformation(utilIds.caseInfoSupremeCourt, lstAccts[0].Id, 4);
        lstCI[1].Arrest_Date__c = intakeDate.addMonths(-1);
        lstCI[2].Sentence_Disposition_Date__c = intakeDate.addMonths(-1);
        lstCI[3].Indictment_Date__c = intakeDate.addDays(-10);
        List<Contact> lstContacts = populateTestData_DCS.createContacts_Client(utilIds.conClient, lstAccts[0].Id, intakeDate, lstCI[0].Id, 1);
        Administrative_Actions__c aa = new Administrative_Actions__c(Client__c = lstContacts[0].Id, Action_Date__c = intakeDate.addDays(10),
            RecordTypeId = utilIds.aaexitNotification, Exit_Type__c = '(S) Successful Exit');
        insert aa;
        aa.Approved__c = 'Yes';
        update aa;
        /*Case_Relationship__c oCaseRelationship_Intake = populateTestData_DCS.createCaseRelationship('Intake Case', lstContacts[0].Id, lstCI[0].Id);
        Case_Relationship__c oCaseRelationship_OpenAtIntake = populateTestData_DCS.createCaseRelationship('Open at Intake', lstContacts[0].Id, lstCI[0].Id);
        Case_Relationship__c oCaseRelationship_Prior = populateTestData_DCS.createCaseRelationship('Prior', lstContacts[0].Id, lstCI[1].Id);
        Case_Relationship__c oCaseRelationship_PostExit = populateTestData_DCS.createCaseRelationship('Post-Exit', lstContacts[0].Id, lstCI[1].Id);*/
        
        return lstContacts[0];
    }

    ////////////////////////////////////////////////////////////////////////////////
    //Retrieve all data from the given object with the given id
    ////////////////////////////////////////////////////////////////////////////////
    public static List<SObject> retrieveSObjectData(String sObjectName, Id recordId) {

        Map<String, Schema.SObjectField> mapFields = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();

        Set<Id> setIds = new Set<Id>();
        setIds.add(recordId);
        //loop through all the fields and retrieve data for record with the given id
        String soqlStmt = '';
        for (String fieldName: mapFields.keySet()) {   
            if (soqlStmt == '') {
                soqlStmt = 'SELECT ' + fieldName;
            } else {
                soqlStmt += ', ' + fieldName;
            }
        }           
        soqlStmt += ' FROM ' + sObjectName + ' WHERE Id IN :setIds';

        List<SObject> lstRecs = Database.query(soqlStmt);
        return lstRecs;
    }    

/*
    public Address_Information__c oPrimaryAddress {get;set;}
    public Employment__c oLastEmployment {get;set;}
    public Education__c oLastEducation {get;set;}
    public Administrative_Actions__c oLastAdminAction {get;set;}
    public Assessment__c oLastAssessment {get;set;}    
*/   
}