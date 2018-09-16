@isTest (SeeAllData=true)
public class cirtMandateScreenUnitTest {

    static utilityIds utilIds = new utilityIds();
    static Program_Cycle__c pc = new Program_Cycle__c();
    static Case_Information__c caseTest = new Case_Information__c();
    static Contact contactTest = new Contact(); 
    static Event eventTest = new Event();
    
    static void createTestData() {
    
        Account a = new Account();
        a.name = 'Thelonius Monk';
        a.RecordTypeId = utilIds.accClient;
        a.NYSID_Number__c = '04989929O';
        a.DOB__c = Date.newInstance(1970,1,1);     
        
        insert a;         
        
        date ddate =  date.parse('11/11/2013');
        date ddate1 =  date.parse('03/11/2014');
        date manddate = date.parse('11/15/2013');

        casetest.Client_Account__c = a.id;
        caseTest.Name = '2011BX023083';
        caseTest.Borough__c = 'Bronx';
        caseTest.Indictment__c = 'indictment';
        caseTest.RecordTypeId = utilIds.caseInfoSupremeCourt;
        caseTest.Arrest_Date__c = date.today();
        caseTest.Defense_Attorney_Law_Guardian__c = contactTest.Id;
        insert caseTest;
        
        contactTest.lastName = 'Lasttest';
        contactTest.firstName = 'firsttest';
        contactTest.recordtypeid = utilIds.conCRT; 
        contactTest.accountId = a.id;
        contactTest.Intake_Case__c = caseTest.id;
        contactTest.Client_Status__c = 'Incomplete Screening';
        contactTest.Resource_Coordinator_s_Comments__c = 'comments';
        contactTest.Attorney_Consent__c = 'Yes';
        contactTest.Screening_Stage__c = 'Pending Mandate';
        contactTest.CIRT_Final_Outcome__c = 'final Outcome';
        contactTest.CIRT_Final_Outcome_Date__c = date.today();
        contactTest.Final_Outcome_Modified_Date__c = date.today();  
        contactTest.Detention_Status_at_Intake__c = 'Not Entered';      
        insert contactTest;
    

        
    //  List<Event> lstEvents = new List<Event>();
        eventTest = new Event();
        eventTest.recordTypeId = utilIds.courtDate;
        eventTest.whoid = contactTest.id;
        eventTest.whatid = casetest.id;
        datetime dtime =  datetime.parse('11/11/2013 12:00 AM');
        eventTest.ActivityDateTime = dtime;
        eventTest.ActivityDate = ddate;
        eventTest.DurationInMinutes = 30;
        eventTest.verification_status__c = 'Not Verified';
        eventTest.Judge_If_other_than_Assigned_Judge__c = '';
        
        eventTest.Part__c = 'AP';
        insert eventTest;
 
   
        Event eventTest1 = new Event();
        eventTest1.recordTypeId = utilIds.courtDate;
        eventTest1.whoid = contactTest.id;
        eventTest1.whatid = casetest.id;
        datetime dtime1 =  datetime.parse('05/11/2014 12:00 AM');
        eventTest1.ActivityDateTime = dtime1;
        eventTest1.ActivityDate = ddate1;
        eventTest1.DurationInMinutes = 30;
        eventTest1.verification_status__c = 'Not Verified';
        eventTest1.Part__c = 'AP1';
        
        insert eventTest1;
        
        
        pc.Client__c = contactTest.id;
        pc.RecordTypeId = utilIds.progCycleCRT; 
        pc.Cycle_Type__c = 'Intake';
        pc.Start_Date__c = eventTest.activityDate;
        pc.track__c = 'Felony ATD';
        insert pc;
        
        
    }

     static testMethod void test1(){
            createTestData();
        cirtMandateScreenController cm1 = new cirtMandateScreenController();  
        cm1.strCourtDate = eventTest.id;
  
  cirtMandateScreenController cm = cm1;
        cm.thisCourtDate = [select id, whoId, ActivityDate, whatID, Part__c, 
        Judge_If_other_than_Assigned_Judge__c from Event where id = :cm.strCourtDate];
        
        cm.thisCase = [select id, Judge__c
            from Case_Information__c where id = :casetest.id];  
       
        cm.thisContact = [select id, Screening_Stage__c, Client_Status__c, FirstName, LastName, P_C_Id__c,
            District_Attorney_s_Consent__c, Judge_s_Conditions__c,  CIRT_Final_Outcome__c, CIRT_Final_Outcome_Date__c,
            Final_Outcome_Modified_Date__c, Mandate_Decision_Date__c, Detention_Status_at_Intake__c
            from Contact where id = :contactTest.id];   
        test.startTest();
        
        cm.strRejectReason = '';
   //     cm.thisCourtDate = thisCourtDate;
        cm.strCourtDate = eventTest.id;
        List<SelectOption> tt = cm.getLstRejectReason();
        List<SelectOption> t1 = cm.getLstDetentionStatus();
        cm.goPortal();
        cm.strDetentionStatus = 'Not Entered';
        cm.newPC = pc;
     //   cm.thisCourtDate.WhatId = eventTest.WhatId;
     //   cm.thisCourtDate.WhatId = eventTest.Whoid;
     //  PageReference pr = cm.saveMandate(); 
        test.stoptest();    
     } 
     
        static testMethod void test2(){
        createTestData();
        PageReference pageRef = Page.cirtMandateScreen;
        Test.setCurrentPage(pageRef);
        cirtMandateScreenController lc = new cirtMandateScreenController();        
        ApexPages.currentPage().getParameters().put('courtDate',eventTest.id);
         
        lc = new cirtMandateScreenController(); 
        test.starttest();
        test.stoptest();
    }
     
     
}