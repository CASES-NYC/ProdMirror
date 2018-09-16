@isTest (seeAllData=true)
private class srp_Notification_UnitTest{ 
static Id accClient = Utility_ID__c.getValues('SRP Client').RecordType_Id__c;
   static caseRelationshipFutureMethods caserel = new caseRelationshipFutureMethods();
   static utilityIds utilIDs = new utilityIds();
    static UtilityTimeMethods ut = new UtilityTimeMethods();
    static string t_timeBeg;
    static boolean bolStartTimeRequired;
    static Program_Plan__c newProgramPlan = new Program_Plan__c();
    static User userCaseCoordinator;
    static Id eventId = null;
    static Account acc1 = new Account(); 
    static Account acc2 = new Account();
    static Contact con1 = new Contact();
    static Contact con2 = new Contact();    
    static Contact con3 = new Contact();    
    static List<Event> listEvents = new List<Event>();
    static Case_Information__c Case1 =  new Case_Information__c();
    static Case_Information__c Case2 =  new Case_Information__c();

    static Event evt1 = new Event();    
    static Event evt2 = new Event();    
    static Event evt3 = new Event();    
    static List<Id> lstContacts,lstCasesIds;
    
    static List<Contact> lstContactsToInsert = new List<Contact>();
    static List<Case_Information__c> lstCasesToInsert = new List<Case_Information__c>();
    static  string sfid,sfid2,clientId2,event1,event2,repid,cname,pcid,pcid2,repid1,actionid1,actionid2,
    caseid1,caseid2,username,Supervision,IntakeNeedsAssessment,courtRecType;
    static date ctdate,ctdate2; 
    
    static void createBasicData() {
      List<RecordType> lstRecType = [Select id,developername,name from RecordType
         where developername =: 'Court_Ordered_Supervision' or 
         developername =: 'Intake_Needs_Assessment' or developername =: 'CourtDate'];
      for (integer i = 0;i < lstRecType.Size();i++){
         if (lstRecType[i].developername == 'Court_Ordered_Supervision')
            Supervision = lstRecType[i].id;
         if (lstRecType[i].developername == 'Intake_Needs_Assessment')
            IntakeNeedsAssessment = lstRecType[i].id; 
         if (lstRecType[i].developername == 'CourtDate')
            courtRecType = lstRecType[i].id;     
      }
         acc1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        acc1.NYSID_Number__c = '12548725T';
        insert acc1;

        acc2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        acc2.NYSID_Number__c = '12548725Q';
        insert acc2;
 
        Case1 = new Case_Information__c();
        case1.Client_Account__c = acc1.Id;
        case1.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case1.Name = '2014TT456011';
        case1.supreme_court_period__c = 6;        
        case1.Borough__c = 'Bronx';
        insert case1; 
        caseid1 = case1.id;  
   
        con1 = new Contact();
        con1.firstName = 'first';
        con1.lastName = 'last';   
        con1.Client_Status__c = 'Active';  
        con1.Referral_Date__c = date.today().addDays(-20);
        con1.Current_Intake_Date__c = date.today().addDays(-20);
        con1.RecordTypeId = utilIds.conClient;
        con1.accountId = acc1.id;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Approved_By__c = userInfo.getUserId();  
        con1.Interview_Outcome__c = 'CEP Accepts';
        con1.Intake_Case__c = caseid1;
        insert con1;
        sfid = con1.id;
        pcid = con1.P_C_ID__c;

  //      lstContactsToInsert.add(con1);

        case2 = new Case_Information__c();
        case2.Client_Account__c = acc1.Id;
        case2.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case2.Name = '2015TT456011';
        case2.Indictment__c = '1235647899';
   //     case2.Case_Court_Status__c = 'Arraigned (Criminal Court)';      
        case2.Arrest_Date__c = date.today().addDays(-2);        
        case2.Borough__c = 'Bronx';
                                         
        insert case2;  

        Event evt = new Event();
        evt.ActivityDateTime = System.Now().addHours(-48);
        evt.ActivityDate = date.today().addDays(-2);
        evt.DurationInMinutes = 30;
        evt.WhoId = sfid;
        evt.WhatId = caseid1;
        evt.Subject = 'Call';
        evt.DurationInMinutes = 30;
        evt.Verification_Status__c = 'Unexused';
        evt.WhatId = caseid1;
        evt.WhoId = sfid;
        evt.RecordTypeId = Supervision;        
        evt.P_C_ID__c = pcid;
        evt.Verified_By__c = userName; 
        evt.Verification_Date__c = date.today();

        insert evt;
        
  
        evt1 = new Event();
        evt1.ActivityDateTime = System.Now().addHours(-24);
        evt1.ActivityDate = date.today().addDays(-1);
        evt1.DurationInMinutes = 30;
        evt1.Subject = 'Meeting';        
        evt1.Verification_Status__c = 'Unexused';
        evt1.WhatId = caseid1;
        evt1.WhoId = sfid;
        evt1.RecordTypeId = Supervision;          
        evt1.P_C_ID__c = pcid;        
         evt1.Verified_By__c = userName; 
        evt1.Verification_Date__c = date.today();
        insert evt1;
        event2 = evt1.Id;
        ctdate2 = evt1.ActivityDate;
   
        system.assert(evt1 != null);
        
        evt2 = new Event();
        evt2.Subject = 'Intake/Needs Assessment';
        evt2.ActivityDateTime = System.Now().addHours(-5);
        evt2.ActivityDate = date.today();
        evt2.DurationInMinutes = 30;
        evt2.Verification_Status__c = 'Unexused'; 
        evt2.WhatId = caseid1;
        evt2.WhoId = sfid;
        evt2.RecordTypeId = IntakeNeedsAssessment; 
        evt.P_C_ID__c = pcid;
       evt2.Verified_By__c = userName; 
        evt2.Verification_Date__c = date.today();
        insert evt2;
        
        evt3 = new Event();
        evt3.Subject = 'Court Date';
        evt3.ActivityDateTime = System.Now().addHours(+24);
        evt3.ActivityDate = date.today().addDays(+1); 
        evt3.DurationInMinutes = 30;
        evt3.Verification_Status__c = 'Not Verified';        
        evt3.WhoId = sfid;
        evt3.WhatId = caseid1;
        evt3.RecordTypeId = courtRecType;
         evt3.Verified_By__c = userName; 
        evt3.Verification_Date__c = date.today();
        insert(evt3);
   
             
   }  
    static testMethod void Test1(){  
      createBasicData();
        test.startTest();
   //     PageReference pageRef = Page.srp_NotificationPage;
    //    Test.setCurrentPageReference(pageRef);
         srp_NotificationController srp = new srp_NotificationController();
         srp.defaultSelection();
    ////    pageRef = srp.RequeryInfo();
  //      pageRef = srp.showPopup();
    //    pageRef = srp.closePopup();
   //     pageRef = srp.checkDeliqTrack();
  //      srp.lstDeliqToShow  = srp.checkDeliqTrack();
        srp.checkCourt();
        List<SelectOption> returnItems = srp.getReturnItems();
        List<SelectOption> docItems = srp.getDocumentItems();
        List<SelectOption> warrItems = srp.getWarrantItems();
        List<SelectOption> reasItems = srp.getReasonItems();
        List<SelectOption> outItems = srp.getFTAOutcomeItems();
        List<SelectOption> outlettout = srp.getLetterOutcomeItems();
        List<SelectOption> retitems = srp.getReturnItems();
        srp.sfAdmin = false;
        srp.checkDeliqTrack();
        srp.showPopup();
        srp.closePopup();
        test.stoptest();
     }
      
}