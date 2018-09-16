@isTest (seeAllData=true)
private class srp_ComlianceTracking_UnitTest{ 
   static Case_Relationship__c Rel = new Case_Relationship__c();
    static Case_Charges__c chgTest = new Case_Charges__c();
   static Id accClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
   static utilityIds utilIDs = new utilityIds();
   static UtilityTimeMethods ut = new UtilityTimeMethods();
   static string t_timeBeg;
   static boolean bolStartTimeRequired;
   static Program_Plan__c newProgramPlan = new Program_Plan__c();
   static User userCaseCoordinator;
    static Progress_Note__c pn2 = new Progress_Note__c();
    static Progress_Note__c pn1 = new Progress_Note__c();   
 //  static Id eventId = null;
   static Account acc1 = new Account();
   static Account acc2 = new Account();
   static Contact con1 = new Contact();
 //  static Contact con2 = new Contact();    
 //  static Contact con3 = new Contact();    
   static List<Event> listEvents = new List<Event>();
   static Case_Information__c Case1 =  new Case_Information__c();
   static Case_Information__c Case2 =  new Case_Information__c();
    static Program_Plan__c  prgPlan = new Program_Plan__c();
    static Id  ppRecType  = Utility_ID__c.getValues('SRP Program Plan').RecordType_Id__c;
    
   static Event evt1 = new Event();    
   static Event evt2 = new Event();    

    static  string sfid,clientId,caseid1, delid,rearrCase,charge;
    static id eventCourt,event1,event2,event3,eventMeeting,eventAssessment,idnote;
    static date ctdate,ctdate2; 
     static void createTestData() {
           User userName = [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
       
          string Supervision,IntakeNeedsAssessment,courtRecType; 
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
    date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        datetime dtime = DateTime.parse(s);
 
        acc1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        acc1.NYSID_Number__c = '12548725T';
        insert acc1;

        acc2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        acc2.NYSID_Number__c = '12548725Q';
        insert acc2;
 
        Case1 = new Case_Information__c();
        case1.Client_Account__c = acc1.Id;
        case1.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case1.Name = '2014BG456011';
        case1.Indictment__c = '1235647894';
        case1.Borough__c = 'Bronx';
        case1.Arrest_Date__c = date.today().addDays(-182);        
        insert case1; 
        caseid1 = case1.id;  
  
 
        con1 = new Contact();
        con1.firstName = 'first';
        con1.lastName = 'last';   
        con1.Referral_Date__c = date.today().addDays(-180);
        con1.Current_Intake_Date__c = date.today().addDays(-180);
        con1.RecordTypeId = utilIds.conClient;
        con1.accountId = acc1.id; 
        con1.Client_Status__c = 'Active';
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Case__c = caseid1;
        con1.Intake_Approved_By__c = userInfo.getUserId();  
        con1.Interview_Outcome__c = 'CEP Accepts';
        con1.Intake_Date__c = ddate - 180;    
           
        insert con1;
        sfid = con1.id;
       
    
   
   chgTest = new Case_Charges__c();
       for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit 1 ])
      {
           chgTest.Charge__c = lstcodes.id;
      }
       chgTest.Docket_No__c = caseid1;
   
      chgTest.Type__c = 'Criminal Court Arraignment Charges';
      chgTest.Docket_No__c = caseid1;
       insert chgTest; 
       charge = chgTest.Charge__c;
 
  chgTest = new Case_Charges__c();
       for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit 2 ])
      {
           chgTest.Charge__c = lstcodes.id;
      }
       chgTest.Docket_No__c = caseid1;
   
      chgTest.Type__c = 'Criminal Court Arraignment Charges';
      chgTest.Docket_No__c = caseid1;
       insert chgTest; 
 
        prgPlan = new Program_Plan__c();
        prgPlan.Client_Name__c = sfid;
        prgPlan.RecordTypeId = ppRecType;
        insert prgPlan;
        ID ppId = prgPlan.id;  
      //  List<Program_Plan__c> ppTest = [select id from Program_Plan__c where Client_Name__c = :sfid limit 1];
        
      //  ID ppId = ppTest[0].id;
   
        Case2 = new Case_Information__c();
        case2.Client_Account__c = acc1.Id;
        case2.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case2.Name = '2014BB456011';
        case2.Indictment__c = '1235647894';
        case2.Borough__c = 'Bronx';
        case2.Arrest_Date__c = date.today().addDays(-2);
        insert case2; 
        rearrCase = case2.id;
   
        Event evt = new Event();
        evt.Subject = 'Court Date';
        evt.ActivityDateTime = System.Now().addHours(+24);
        evt.ActivityDate = date.today().addDays(+1);
        evt.DurationInMinutes = 30;
        evt.WhoId = sfid;
        evt.WhatId = caseid1;
        evt.RecordTypeId = courtRecType;
        insert(evt);
        
        eventCourt = evt.Id;
  
        evt = new Event();
        evt.Subject = 'Court Date';
        evt.ActivityDateTime = System.Now().addHours(+48);
        evt.ActivityDate = date.today().addDays(+2);
        evt.DurationInMinutes = 30;
        evt.WhoId = sfid;
        evt.WhatId = caseid1;
        evt.RecordTypeId = courtRecType;
        insert(evt);
        
        event2 = evt.Id;

/*

        evt = new Event();
        evt.Subject = 'Meeting';
        evt.ActivityDateTime = System.Now().addHours(-72);
        evt.ActivityDate = date.today().addDays(-3);
        evt.DurationInMinutes = 30;
        evt.Verification_Status__c = 'Unexused';
        evt.WhatId = caseid1;
        evt.WhoId = sfid;
        evt.RecordTypeId = Supervision;        
        insert evt;
        eventM = evt.Id;
  */       
        evt = new Event();
        evt.Subject = 'Intake/Needs Assessment';
        evt.ActivityDateTime = System.Now().addHours(-30);
        evt.ActivityDate = date.today().addDays(-2);
        evt.DurationInMinutes = 30;
        evt.Verification_Status__c = 'Unexused';
        evt.WhatId = caseid1;
        evt.WhoId = sfid;
        evt.RecordTypeId = IntakeNeedsAssessment;        
        insert evt;
        eventAssessment = evt.Id;
        

       evt = new Event();
        evt.Subject = 'Meeting';
        evt.ActivityDateTime = System.Now().addHours(-48);
        evt.ActivityDate = date.today().addDays(-2);
        evt.DurationInMinutes = 30;
        evt.Verification_Status__c = 'Attended';
        evt.WhatId = caseid1;
        evt.WhoId = sfid;
        evt.RecordTypeId = Supervision; 
               
        insert evt;
        eventMeeting = evt.Id;

 /*
    Rel = new Case_Relationship__c();
        Rel.Case_Type__c  = 'In-Program';
        Rel.Contact__c = sfid;
        Rel.Docket__c = rearrCase;
        rel.Supervised_by_SRP__c = true;
        insert Rel; 
        system.assert(rel != null); 
 */
  //   Rel lstRecords = new Case_Relationship__c();
      List<Case_Relationship__c> lstRecords = new List<Case_Relationship__c>();
        Case_Relationship__c recordNew = new Case_Relationship__c();
        recordNew.Case_Type__c = 'In-Program';
        recordNew.Contact__c = sfid;
        recordNew.Docket__c = rearrcase;
        recordNew.Supervised_by_SRP__c = true;
        lstRecords.add(recordNew);
        
        recordNew = new Case_Relationship__c();
        recordNew.Case_Type__c = 'Intake Case';
        recordNew.Contact__c = sfid;
        recordNew.Docket__c = caseid1;
        lstRecords.add(recordNew);
   
           insert lstRecords;

       Delinquency_Tracking__c d = new Delinquency_Tracking__c();     
        d.Client__c = sfid;
        d.ActionId__c = eventMeeting;
        d.Stop_Clock__c = false;
        d.Document_Type__c = 'Letter';
        d.Letter_Date__c = date.today().addDays(-2);
        insert d;        
        delid = d.id;
        
        d = new Delinquency_Tracking__c();     
        d.Client__c = sfid;
        d.ActionId__c = eventMeeting;
        d.Stop_Clock__c = false;
        d.Document_Type__c = 'Contact';
        d.Notes__c = 'Staff call';
        d.Response__c = 'Contact made';
        d.Date_of_Contact__c = date.today();
        insert d;        
        
       
        pn1 = new Progress_Note__c();
        pn1.Program_Plan__c = ppid;   
        pn1.Activity_Date__c = system.today() - 1;
        pn1.Date__c = system.today();
        pn1.Progress_Note__c = 'Better get it in your soul';
        pn1.RecordTypeId = utilIds.progressNoteCase;
        pn1.Area__c = 'Compliance Effort';
        insert pn1;
        idnote = pn1.id;
  /*   
        pn2 = new Progress_Note__c();
       pn2.Program_Plan__c = ppid;   
        pn2.Date__c = system.today().addDays(-15);
       pn2.Activity_Date__c = system.today().addDays(-17);     
        pn2.Progress_Note__c = 'Five Spot Blues';
        pn2.RecordTypeId = utilIds.progressNoteCase;
          pn2.Area__c = 'Case Coordination';
                        
        insert pn2;        
 //       delid = d.id;
   */ 
    

       } 

        static testMethod void test1_Report()
      {         
        createTestData();
            PageReference pageRef = Page.srp_ComplianceTrackingPage;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('actionPassed', eventCourt);
        pageRef.getParameters().put('clientPassed',sfId);
        test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
        
        test.stopTest(); 
      }

    static testMethod void test1_Letter()
      {         
        createTestData();
        PageReference pageRef = Page.srp_ComplianceTrackingPage;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('actionPassed',eventCourt);
        pageRef.getParameters().put('clientPassed',sfId);           
        test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
        srp.deliqRecId = delid;        
        srp.ReportReason = 'failed to report for the following supervision appointment';
        srp.saveReason(); 
        srp.ReportReason = 'was arrested';
        srp.saveReason(); 
        srp.ReportReason = 'is partially compliant with the program supervision';
        srp.saveReason(); 
        srp.ReportReason = 'is in compliance with the requirements of the program';
        srp.saveReason();           
        srp.proxyObject.ActivityDate = date.today();
        srp.saveDate();
        srp.closePopup();
        srp.actionId = eventMeeting;
        srp.deleteDocument();
        srp.warrant = '';
     //   srp.outcome = '';
        srp.returned = '';
        srp.arrestDocketTitle = '';
        srp.intakeDocket = '';
        srp.arrestCaseId = '';
        srp.arrestDocket = '';
        srp.betweenDates = '20';
        srp.Indictment = '';
        srp.arrestCharges = charge;
        srp.arrestDate = case1.Arrest_Date__c.format();
        srp.ReasonValue = '';
        srp.donothing();
        test.stopTest(); 
      }     
   
     
      static testMethod void test7_Reason()
      {         
        createTestData();
        PageReference pageRef = Page.srp_ComplianceTrackingPage;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('actionPassed',eventMeeting);
        pageRef.getParameters().put('clientPassed',sfId);           
        test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
        srp.deliqRecId = delid;         
       srp.ReportReason = 'failed to report for the first mandatory intake';
        srp.saveReason();         
        srp.ReportReason = '';
        srp.saveReason(); 
       srp.ReportReason = 'is partially compliant with the program supervision schedule';
        srp.saveReason();     
        srp.ReportReason = 'failed to report for the first mandatory intake and needs assessment appointment';
        srp.saveReason();             
        test.stopTest(); 
      }       
   
     
     static testMethod void test2_Letter()
      {         
        createTestData();
        PageReference pageRef = Page.srp_ComplianceTrackingPage;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('actionPassed',eventMeeting);
        pageRef.getParameters().put('clientPassed',sfId);           
        test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
               List<SelectOption> FTAOutcomeItems = srp.getFTAOutcomeItems();
        List<SelectOption> OutcomeItems = srp.getOutcomeItems();
        List<SelectOption> returnItems = srp.getReturnItems();
        List<SelectOption> reasonItems = srp.getReasonItems(); 
        List<SelectOption> warrantItems = srp.getWarrantItems();  
         List<SelectOption> lettOutcome = srp.getLetterOutcomeItems();     
         List<SelectOption> ftaOutcome = srp.getFTAOutcomeItems();   
        srp.docType = 'Letter';
        List<SelectOption> staff = srp.StaffCall;
        staff = srp.StaffVisit;
        srp.StaffVisit = staff;
        srp.ReportReason = 'failed to complete additional judicial conditions';
        srp.deliqRecId = delid;
        srp.saveReason();
        srp.ReportReason = 'is in compliance';
         srp.saveReason();
        srp.ReportReason = 'is partially compliant';
         srp.saveReason();
        srp.FTAValue = 'Family Crisis';
        srp.docType = 'Report';
        srp.saveFTA();
        srp.outcomeValue = 'Warrant - Picked Up';
        srp.saveOutcomeValue();
        srp.WarrantValue = 'Yes';
        srp.saveWarrant();
        srp.manyCharges = false;
        srp.cell = '347-259-1450';
        srp.attPhone = '9170157-4589';
        srp.attName = 'Philip';
        srp.courtDate = date.today().format();
        test.stopTest(); 
      }       

    static testMethod void test3_Letter()
      {         
        createTestData();
       test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
      
         srp.clientId = sfid;
         srp.actionId = eventCourt; 
        srp.docType = 'Report';
        List<SelectOption> ReasonItems = srp.ReportReasonItems;
         srp.actionId = eventMeeting; 

        srp.docType = 'Letter';
        ReasonItems = srp.ReportReasonItems;
        List<SelectOption> staff = srp.StaffCall;
         srp.contacttype = 'Staff call';
        staff = srp.ContactRespondItems;
        srp.ContactRespondItems = staff;
        boolean cmade = srp.contactMade;
        srp.contactMade = cmade;
        srp.contacttype = 'Other';
        cmade = srp.contactMade;
        srp.contacttype = 'Staff visit';
        staff = srp.ContactRespondItems;

        srp.contacttype = 'Staff call';
        srp.newContactDate = date.today().format();
        srp.response = 'Contact made';
        srp.notes = 'notes';
  
        srp.showPopup();         
        test.stopTest(); 
      }  
   
   
    static testMethod void test4_Deliq()
      {         
        createTestData();
        PageReference pageRef = Page.srp_ComplianceTrackingPage;
        Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('actionPassed',eventMeeting);
        pageRef.getParameters().put('clientPassed',sfId);           
   
         test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
        srp.contacttype = 'Staff visit';
        srp.response = 'Contact made';        
        srp.deliqRecId = delid;
        srp.docType = 'Letter';
        srp.newContactDate = date.today().format();
        srp.response = 'Contact made';
        srp.notes = 'notes';
        srp.times = '08:00 AM';
        srp.clientId = sfid;
        srp.actionId = event3;
        srp.saveContact();
        srp.deliqRecId = delid;
        srp.notes = 'notes';
        
       List<SelectOption> TypeItems = srp.TypeItems; 
       string t = srp.signature;
       string u = srp.userName;
               PageReference p1 = srp.deliverAsPDF();
  
        test.stopTest(); 
      }  

   static testMethod void test5_Misc(){
      createTestData();
        PageReference pageRef = Page.srp_ComplianceTrackingPage;
   
        pageRef.getParameters().put('actionPassed',event2);
        pageRef.getParameters().put('clientPassed',sfId);           
       Test.setCurrentPageReference(pageRef); 
         test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
        srp.deliqRecId = delid;
        srp.notes = 'notes';
        
       List<SelectOption> TypeItems = srp.TypeItems; 
 //      string t = srp.signature;
  //     string u = srp.userName;
 //       srp.contactInfo(); 
               PageReference p1 = srp.deliverAsPDF();
                        
               test.stopTest(); 
        
   }
   /*
   static testMethod void test5_Misc_1(){
      createTestData();
        PageReference pageRef = Page.srp_ComplianceTrackingPage;
   
        pageRef.getParameters().put('actionPassed',rearrCase);
        pageRef.getParameters().put('clientPassed',sfId);           
       Test.setCurrentPageReference(pageRef); 
         test.startTest();
        srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
               test.stopTest(); 
        
   }
   */
   
  
   static testMethod void test6_Rearrest_delete(){
     createTestData();
     PageReference pageRef = Page.srp_ComplianceTrackingPage;
      pageRef.getParameters().put('actionPassed',rearrCase);
     pageRef.getParameters().put('clientPassed',sfId);
     Test.setCurrentPageReference(pageRef);
       srp_ComplianceTrackingcontroller srp = new srp_ComplianceTrackingcontroller();
     srp.actionId = rearrCase;
     srp.clientId = sfid;
     test.startTest();
      srp.docketValue = rearrCase;
     srp.contactInfo(); 
        srp.refreshDocket();
        srp.arrestCaseListCharges(caseid1);
  //      srp.outcomeValue = 'Warrant Stayed';
    srp.deliqRecId = delid; 
  //  srp.saveOutcome();
    srp.notes = 'notes';
    srp.savenotes();
    srp.ReturnedValue = 'Yes';
    srp.saveReturned();
    srp.setclockValue(true);
    boolean cValue = srp.getclockValue();
    srp.idProgDelete = idnote;
    srp.deletePrognote();
     test.stopTest(); 
   }
            
}