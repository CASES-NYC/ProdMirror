@isTest (SeeAllData=true)
public class legalHistoryController_UnitTest {

    static Case_Information__c caseTest = new Case_Information__c();
    static Case_Information__c caseTest1 = new Case_Information__c();
    static Event eventTest = new Event();
    static Contact contactTest = new Contact();
    static Case_Charges__c chgTest = new Case_Charges__c();
    static Account accountTest = new Account();
    
    static Id suprRecTypeId = Utility_ID__c.getValues('Case - Supreme Court').RecordType_Id__c;
    static Id EventRecTypeId = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
    static Id conCRT = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c;  
    static Id accClient = Utility_Id__c.getValues('Client').RecordType_Id__c;
    
    static void createTestData() {
    
        date ddate =  date.parse('11/11/2013');
        date ddate1 =  date.parse('03/11/2014');
        date manddate = date.parse('04/01/2014');
        User adminUser = [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
    
        accountTest = new Account();
        accountTest.nysid_number__c = '04221673Y';  
        accountTest.Name = 'CIRT';
        accounttest.DOB__c = date.parse('11/11/1950');
        accountTest.recordtypeId =  accClient;
        insert accountTest;

        casetest.Client_Account__c = accountTest.id;
        caseTest.Name = '2014NY023083';
        caseTest.Borough__c = 'Bronx';
        caseTest.Indictment__c = 'indictment';
        caseTest.Detention_Status_at_SC_Arraignment__c = 'ROR';
        caseTest.RecordTypeId = suprRecTypeId;
        caseTest.Arrest_Date__c = date.today();
        caseTest.Arrest_Number__c = '11114444';
        caseTest.Defense_Attorney_Law_Guardian__c = contactTest.id;
        insert caseTest;

        ID Accountid = accountTest.id; 
        contactTest = new Contact();
        contactTest.accountId = accountTest.id;
        contactTest.lastName = 'Lasttest';
        contactTest.firstName = 'firsttest';
        contactTest.recordtypeid = conCRT; 
        contactTest.Client_Status__c = 'Active';
        contactTest.Criminal_Justice_Involvement__c = 'Probation';
        contactTest.Mandate_Decision_Date__c = manddate;
        contactTest.aka_1__c = 'aka1';
        contactTest.aka_2__c = 'aka2';
        contactTest.aka_3__c = 'aka3';
        contactTest.Resource_Coordinator_s_Comments__c = 'comments';
        contactTest.Criminal_Justice_Involvement__c = 'Parole';
        contactTest.Prior_Violent_Conviction_Date__c = date.today() -100;
        contactTest.Prior_Violent_Conviction__c = 'Yes'; 
        contactTest.Inmate_Location__c = 'brooklyn';
        contactTest.Prior_Felony_Convictions__c = 5;
        contactTest.Prior_Misdemeanor_Convictions__c = 2;
        contactTest.Interview_Notes__c = 'int notes';    
        contactTest.Intake_Case__c = caseTest.id;    
        insert contactTest;
    
        casetest1.Client_Account__c = accountTest.id;
        caseTest1.Name = '2010NY023075';
        caseTest1.Borough__c = 'Bronx';
        caseTest1.Indictment__c = 'indictment1';
        caseTest1.Arrest_Date__c = date.today() - 10;
        caseTest1.Arrest_Number__c = '11113666';
        caseTest1.RecordTypeId = suprRecTypeId;
        insert caseTest1;

        List<Event> lstEvents = new List<Event>();
        eventTest = new Event();
        eventTest.recordTypeId = EventRecTypeId;
        eventTest.whoid = contactTest.id;
        eventTest.whatid = casetest.id;
        datetime dtime =  datetime.parse('11/11/2013 12:00 AM');
        eventTest.ActivityDateTime = dtime;
        eventTest.ActivityDate = ddate;
        eventTest.DurationInMinutes = 30;
        eventTest.verification_status__c = 'Not Verified';
        lstEvents.add(eventTest);
 
        eventTest.recordTypeId = EventRecTypeId;
        eventTest.whoid = contactTest.id;
        eventTest.whatid = casetest.id;
        datetime dtime1 =  datetime.parse('05/11/2014 12:00 AM');
        eventTest.ActivityDateTime = dtime1;
        eventTest.ActivityDate = ddate1;
        eventTest.DurationInMinutes = 30;
        eventTest.verification_status__c = 'Not Verified';
        lstEvents.add(eventTest);
 
        chgTest.Docket_No__c = caseTest.id;
        chgTest.Type__c = 'Arrest Charges';
        
        Case_Charges__c chg1 = new Case_Charges__c();
        for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit 1 ]) {

          chgTest.Charge__c = lstcodes.id;
        }
        
        insert chgTest; 
     }
 
    static testMethod void test1(){
    
        createTestData();
        PageReference pageRef = Page.legalHistory;
        Test.setCurrentPage(pageRef);
        legalHistoryController lc = new legalHistoryController();        
        ApexPages.currentPage().getParameters().put('case',caseTest.id);
        ApexPages.currentPage().getParameters().put('contact',contactTest.id);
         
        lc = new legalHistoryController(); 
        
        test.starttest();
        pageReference pg = lc.saveLegalInfo();
        test.stoptest();
    }
    
}