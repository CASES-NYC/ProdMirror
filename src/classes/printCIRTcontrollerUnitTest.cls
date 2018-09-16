@isTest (SeeAllData=true)
private class printCIRTcontrollerUnitTest {
  static utilityIds utilIds = new utilityIds();
    static Case_Information__c caseTest = new Case_Information__c();
    static Case_Information__c caseTest1 = new Case_Information__c();
    static reportQuery rq = new reportQuery();
    static Event eventTest = new Event();
     static Contact contactTest = new Contact();
    static Case_Charges__c chgTest = new Case_Charges__c();
    static Account accountTest = new Account();
    
    static ID accAgency = Utility_ID__c.getValues('External Entities').RecordType_Id__c;
    
    static Address_Information__c addressTest = new Address_Information__c(); 
    static Id caseRecTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
    static Id suprRecTypeId = Utility_ID__c.getValues('Case - Supreme Court').RecordType_Id__c;
    static Id attRecordType = Utility_ID__c.getValues('Attorney/ Law Guardian').RecordType_Id__c;


    static Id EventRecTypeId = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
   static Id conCRT = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c;  
 //   static Id accCIRT = Utility_Id__c.getValues('CIRT Account').RecordType_Id__c;
    static void createTestData() {
      date ddate =  date.parse('11/11/2013');
     date ddate1 =  date.parse('03/11/2014');
      date manddate = date.parse('11/15/2013');
    User adminUser = [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
    
      Account accountTestAgency = new Account();
      accountTestAgency.nysid_number__c = '04221673Z';  
      accountTestAgency.Name = 'Legal';
      accountTestAgency.recordtypeId =  accAgency;
      accountTestAgency.BillingStreet = 'Broadway';
      accountTestAgency.billingState = 'NY';
      accountTestAgency.BillingPostalCode= '100015';
      insert accountTestAgency;
      
        Contact  contactTestAtt = new Contact();
        contactTestAtt.lastName = 'Lasttest';
        contactTestAtt.firstName = 'firsttest';
        contactTestAtt.firstname = 'attFirst';
        contactTestAtt.lastName = 'attlast';
        contactTestAtt.RecordTypeId = attRecordType;
        contactTestAtt.accountid = accountTestAgency.id; 
        insert contactTestAtt;
 
      accountTest = new Account();
      accountTest.nysid_number__c = '04221673K';  
      accountTest.Name = 'CIRT';
      accounttest.DOB__c = date.parse('11/11/1950');
      accountTest.recordtypeId = utilIds.accClient;
      insert accountTest;
              
      casetest.Client_Account__c = accountTest.Id;
      caseTest.Name = '2013NY023083';
       caseTest.Borough__c = 'Bronx';
       caseTest.Indictment__c = 'indictment';
//       caseTest.Current_Case_Status__c = 'At Plea';
       caseTest.Detention_Status_at_SC_Arraignment__c = 'ROR';
       caseTest.RecordTypeId = suprRecTypeId;
       caseTest.Arrest_Date__c = date.today();
      insert caseTest;
 
        ID Accountid = accountTest.id; 
        contactTest = new Contact();
        contactTest.lastName = 'Lasttest';
        contactTest.firstName = 'firsttest';
        contactTest.recordtypeid = conCRT; 
        contactTest.Client_Status__c = 'Active';
        contactTest.Mandate_Decision_Date__c = manddate;
        contactTest.aka_1__c = 'aka1';
        contactTest.aka_2__c = 'aka2';
        contactTest.aka_3__c = 'aka3';
        contactTest.Resource_Coordinator_s_Comments__c = 'comments';
        contactTest.Criminal_Justice_Involvement__c = 'Parole';
    //    contactTest.attorney__c = contactTest.id;
        contactTest.Supervising_Attorney__c = contactTestAtt.id;
        contactTest.Prior_Violent_Conviction_Date__c = date.today() -100;
         contactTest.AccountId = AccountId;
         contactTest.Intake_Case__c = caseTest.Id;
        insert contactTest;
 
      addressTest.client__c = contactTest.id;
      addressTest.client__c = contactTest.id;
      addressTest.Move_In_Date__c = ddate;
      addressTest.Home_Phone__c = '212 053-6666';
      addressTest.Building_No__c = '200';
      addressTest.street__c = 'E 31 St.';
      addressTest.Apt_No__c = '10C';
      addressTest.City__c = 'Brooklyn';
      addressTest.State__c = 'NY';
      addressTest.zip__c = '11256';
      addressTest.Home_Phone__c = '646 888-4444';
      insert addressTest;
      
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
 
   //     eventTest1 = new Event();
      eventTest.recordTypeId = EventRecTypeId;
      eventTest.whoid = contactTest.id;
      eventTest.whatid = casetest.id;
      datetime dtime1 =  datetime.now();
        eventTest.ActivityDateTime = dtime1;
        eventTest.ActivityDate = date.today();
        eventTest.DurationInMinutes = 30;
        eventTest.verification_status__c = 'Not Verified';
        lstEvents.add(eventTest);
        
  

    chgTest.Docket_No__c = caseTest.id;
       chgTest.Type__c = 'Criminal Court Arraignment Charges';
        ID pcodeId;
         for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit1 ])
       {
            pcodeId = lstcodes.id;
       }
       
       insert chgTest; 
    }
     static testMethod void testReportQuery()
      {
        createTestData();
 
           test.startTest();
           printCIRTcontroller pc = new printCIRTcontroller(); 
           pc.IdPassed = contactTest.id;
           pc.generateReport();
           test.stopTest();
      }
}