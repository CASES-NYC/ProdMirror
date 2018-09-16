@isTest (seeAllData=true) 
private class sfDocumentController_UnitTest{
  static Id accClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
   static utilityIds utilIDs = new utilityIds();
    static UtilityTimeMethods ut = new UtilityTimeMethods();
    static string t_timeBeg;
    static boolean bolStartTimeRequired;
    static User userCaseCoordinator;
    static Account accCep1 = new Account();
    static Account accCep2 = new Account();
    static Contact con1 = new Contact();
    static Contact con2 = new Contact();    
    static Contact con3 = new Contact();    
    static List<Event> listEvents = new List<Event>();
    static List<Case_Information__c> listCases = new List<Case_Information__c>();
     static Case_Information__c newCaseInfo =  new Case_Information__c();
    static Case_Information__c newCaseInfo2 =  new Case_Information__c();
    static Case_Information__c newCaseInfo1 =  new Case_Information__c();
    static SF_CRW__c crwMain = new SF_CRW__c(); 
    static SF_CRW__c crwMain2 = new SF_CRW__c(); 
    static SF_CRW_notes__c crwNotes = new SF_CRW_notes__c();
    
    static  Case_Relationship__c otherCase = new  Case_Relationship__c();
    static  List<Case_Relationship__c> lstRecords = new List<Case_Relationship__c>();   
    static  string sfid,sfid2,cepid2,event1,event2,repid,cname,pcid,pcid2,repid1,repid2,actionid1,
    actionid2,accountid,accountid2,noteid,caseid, caseid1;
    static date ctdate,repdate,repdate2;    
    

    static void createCRWTestData() {
        date ddate =  date.today();
        string s = ddate.format() + ' 08:00 AM';
        datetime dtime = DateTime.parse(s);
 
        accCep1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        accCEp1.NYSID_Number__c = '12548725Y';
        insert accCep1;
        accountid = accCep1.id;

  
   
        accCep2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        accCEp2.NYSID_Number__c = '12548725W';
        insert accCep2;
        accountid2= accCep2.id;
 
        ddate =  date.today()- 31;
        s = ddate.format() + ' 10:00 AM';
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accCep1.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2014BG456011';
        newCaseInfo.Indictment__c = '1235647894';
        newCaseInfo.Borough__c = 'Bronx';
        newCaseInfo.recordtypeId = '012600000005Nk3';
        newCaseInfo.Arrest_Date__c = date.today() - 30; 
        newCaseInfo.Intake_Date__c = date.today() - 30;
        insert newCaseInfo;   
        caseid = newCaseInfo.id;
        listCases.add(newCaseInfo);
 
        ddate =  date.today() - 30;
        s = ddate.format() + ' 10:00 AM';
        dtime = DateTime.parse(s);     
        newCaseInfo2 = new Case_Information__c();
        newCaseInfo2.Client_Account__c = accountid2;
        newCaseInfo2.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo2.Name = '2014BG456022';
        newCaseInfo2.Indictment__c = '1238647822';
        newCaseInfo2.Borough__c = 'Brooklyn';
        newCaseInfo2.Arrest_Date__c = ddate; 

        insert newCaseInfo2;   
        caseid1 = newCaseInfo2.id;
        listCases.add(newCaseInfo1);
 
        con1 = new Contact();
        con1.firstName = 'first';
        con1.lastName = 'last';   
        con1.Referral_Date__c = system.today()- 30; 
        con1.Current_Intake_Date__c = ddate - 30;
        con1.RecordTypeId = utilIds.conClient;
        con1.accountId = accountid;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Case__c = newCaseInfo.id;
        con1.Intake_Approved_By__c = userInfo.getUserId();  
        con1.Interview_Outcome__c = 'CEP Accepts';
        con1.Intake_Date__c = ddate - 180;    
           
        insert con1;
        sfid = con1.id;
        pcid = con1.P_C_ID__c;
        cname = con1.FirstName + ' ' + con1.LastName;    
   
   
        con2 = new Contact();
        con2.firstName = 'first';
        con2.lastName = 'last';   
        con2.Referral_Date__c = system.today()- 30; 
        con2.Current_Intake_Date__c = ddate - 30;
        con2.RecordTypeId = utilIds.conClient;
        con2.accountId = accountid;   
        con2.Reporting_Borough__c = 'Brooklyn';   
        con2.Intake_Case__c = newCaseInfo.id;
        con2.Intake_Approved_By__c = userInfo.getUserId();  
        con2.Interview_Outcome__c = 'CEP Accepts';
        con2.Intake_Date__c = ddate - 180;    
        con2.Current_Exit_Date__c = date.today() - 3;
                   
        insert con2;
        sfid2 = con2.id;
        pcid2 = con2.P_C_ID__c;
   
        ddate =  date.today() - 5;
        s = ddate.format() + ' 10:00 AM';
        dtime = DateTime.parse(s);     
        newCaseInfo1 = new Case_Information__c();
        newCaseInfo1.Client_Account__c = accCep1.Id;
        newCaseInfo1.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo1.Name = '2014BG456013';
        newCaseInfo1.Indictment__c = '1238647894';
        newCaseInfo1.Borough__c = 'Brooklyn';
        newCaseInfo.Arrest_Date__c = date.today() - 25; 
        newCaseInfo.Intake_Date__c = date.today() - 30;
        insert newCaseInfo1;   
        caseid1 = newCaseInfo1.id;
        listCases.add(newCaseInfo1);
     
        ddate =  date.today();
        s = ddate.format() + ' 10:00 AM';
        dtime = DateTime.parse(s);        
  //      List<Event> lstEvents = new List<Event>();
        Event evt = new Event();
        evt.Subject = 'Court Report';
        evt.ActivityDateTime = dtime;
        evt.ActivityDate = ddate;
        evt.DurationInMinutes = 30;
        evt.WhoId = sfid;
        evt.Whatid = caseid;
        evt.P_C_ID__c = pcid;
        evt.Report_Type__c = 'Progress';
        insert(evt);
        event1 = evt.Id;
       ctdate = evt.ActivityDate;     
       
        listEvents.add(evt);
        
        ddate =  date.today() - 5;
        s = ddate.format() + ' 10:00 AM';
        dtime = DateTime.parse(s);        

        Event evt1 = new Event();
        evt1.Subject = 'Court Report';
        evt1.ActivityDateTime = dtime;
        evt1.ActivityDate = ddate;
        evt1.DurationInMinutes = 30;
        evt1.WhoId = sfid;
        evt1.P_C_ID__c = pcid;
        evt1.Report_Type__c = 'Progress';
        evt1.Whatid = caseid1;
        insert(evt1);
        event1 = evt1.Id;
        listEvents.add(evt1);

//        ctdate = evt.ActivityDate;        
        
        
        crwMain.Account__c = accountid;
        crwMain.Contact__c = sfid;
        crwMain.actionid__c = event1;
        crwMain.Document__c = 'Report';
        crwMain.ReportType__c = 'Progress';
        crwMain.CourtDate__c = evt.ActivityDate;
        crwMain.repStage__c = 'to Do';
        crwMain.ClientName__c = cname;
        crwMain.narrative__c = 'narrative';
        crwMain.repStage__c = 'Signed'; 
        insert crwMain;
        repid = crwMain.id;   
        repdate = crwMain.CourtDate__c;   

      Administrative_Actions__c aaExit = new Administrative_Actions__c();
        aaExit.client__c = con2.id;
        aaExit.RecordTypeId = utilIds.aaExitNotification;
        aaExit.Action_Date__c = System.Today();
        aaExit.Exit_Type__c = '(S) Successful Exit/ Graduation';
        aaExit.Exit_Reason__c = 'Successfully completed program, without modification';
        insert aaExit;
        
        crwMain2.Account__c = accountid2;
        crwMain2.Contact__c = sfid2;
        crwMain.actionid__c = aaExit.id;
        crwMain2.Document__c = 'Letter';
        crwMain2.ReportType__c = 'Graduation';
        crwMain2.CourtDate__c = evt.ActivityDate;
        crwMain2.repStage__c = 'to Do';
        crwMain2.ClientName__c = con2.Client_Name__c;
        crwMain2.narrative__c = 'narrative';
        crwMain2.repStage__c = 'to Do'; 
        insert crwMain2;
        repdate2 = crwMain2.CourtDate__c;
        repid2 = crwMain2.id;   


  

        crwNotes = new SF_CRW_notes__c();
        crwNotes.luReports__c = repid;
        crwnotes.Question__c = 'question 1';
        crwNotes.Respond__c = 'rep 1';
        crwNotes.Status__c = 'Approved';
        crwNotes.NotesCode__c = '';
        insert crwNotes;  
        noteid = crwNotes.id; 
 
        lstRecords = new List<Case_Relationship__c>();
        otherCase = new Case_Relationship__c();
        otherCase.Case_Type__c = 'Intake Case';
        otherCase.contact__c = sfid;
        otherCase.Docket__c = caseId;
        lstRecords.add(otherCase);
        insert lstRecords;
        
    }
   static testMethod void test1(){
        createCRWTestData();
       PageReference pageRef = Page.sfCRWdocument;
        pageRef.getParameters().put('selectedReport',repid);
        pageRef.getParameters().put('passNoteId',noteid);
        Test.setCurrentPageReference(pageRef);        
        sfDocumentcontroller crw = new sfDocumentcontroller();
        test.startTest();
        crw.CRuser = true;
   
        crw.cmdCaption = 'Edit';
        crw.changeCaption();
        crw.cmdCaption = 'Save';
        crw.changeCaption();
        crw.cancelChanges();
   
             
        List<SelectOption> lstRevItems = crw.getReviewItems();
        List<SelectOption> lstSignedItems = crw.getSignedItems();
        List<SelectOption> lstEditItems = crw.getEditItems();
        List<SelectOption> lstappr = crw.getToApprovedItems();

        List<SelectOption> lstnotesStatus = crw.getNotesStatus();      
   //       List<SelectOption> lstRespond = crw.getRespondItems();      
        crw.statusPassed = 'Approved';
        crw.noteAction = 'respond';
        crw.executeNoteAction();
        crw.cancelNotesChanges();
     /*    
        crw.notescode('Comments', 'C1');
        crw.notescode('Respond', 'C1');
        crw.notescode('Respond', 'C1-R1');
 
       crw.del_call = 'delete';
       crw.delete_recallReport();       
       crw.del_call = 'recall';
       crw.delete_recallReport();  
       
       crw.notestype = 'N';  
       crw.saveNotes();   
       crw.notestype = 'R';  
       crw.saveNotes(); 
       crw.showPopup();  
       crw.closePopup();  
       
       string s, s1;
      s = crw.notesCode('Comments','C1');
      s = crw.notesCode('Comments','C1-R1');
      
      s = crw.notesCode('respond',s1);
      s = crw.notesCode('respond','C1-R1');
      s = crw.notesCode('respond','C1');

       crw.stagePassed = 'Back to edit';
       crw.changeStages();      
       crw.stagePassed = 'Signed';
       crw.changeStages();      

       crw.stagePassed = 'CR approved';
       crw.changeStages();      
       crw.stagePassed = 'CM approved';
       crw.changeStages(); 
      repdate = ctdate;
      string last_d = crw.lastcourt(listEvents, caseid,sfid, repdate);
      string next_d = crw.nextcourt(listEvents, caseid,repdate);
  

      crw.allCases(listCases, sfid, repdate);
*/
       test.stopTest(); 
     }  
         static testMethod void test2(){
        createCRWTestData();
       PageReference pageRef = Page.sfCRWdocument;
        pageRef.getParameters().put('selectedReport',repid);
        pageRef.getParameters().put('passNoteId',noteid);
        Test.setCurrentPageReference(pageRef);        
        sfDocumentcontroller crw = new sfDocumentcontroller();
        test.startTest();
        crw.CRuser = true;
            crw.notescode('Comments', 'C1');
        crw.notescode('Respond', 'C1');
        crw.notescode('Respond', 'C1-R1');
 
       crw.del_call = 'delete';
       crw.delete_recallReport();       
       crw.del_call = 'recall';
       crw.delete_recallReport();  
       
       crw.notestype = 'N';  
       crw.saveNotes();   
       crw.notestype = 'R';  
       crw.saveNotes(); 
       crw.showPopup();  
       crw.closePopup();  
       
       string s, s1;
      s = crw.notesCode('Comments','C1');
      s = crw.notesCode('Comments','C1-R1');
      
      s = crw.notesCode('respond',s1);
      s = crw.notesCode('respond','C1-R1');
      s = crw.notesCode('respond','C1');
         test.stopTest(); 
         }
         
      static testMethod void test3(){
        createCRWTestData();
       PageReference pageRef = Page.sfCRWdocument;
        pageRef.getParameters().put('selectedReport',repid);
        pageRef.getParameters().put('passNoteId',noteid);
        Test.setCurrentPageReference(pageRef);        
        sfDocumentcontroller crw = new sfDocumentcontroller();
        test.startTest();
        crw.CRuser = true;
         crw.stagePassed = 'Back to edit';
       crw.changeStages();      
       crw.stagePassed = 'Signed';
       crw.changeStages();      

       crw.stagePassed = 'CR approved';
       crw.changeStages();      
       crw.stagePassed = 'CM approved';
       crw.changeStages(); 
      repdate = ctdate;
      string last_d = crw.lastcourt(listEvents, caseid,sfid, repdate);
      string next_d = crw.nextcourt(listEvents, caseid,repdate);
  

    //  crw.allCases(listCases, sfid, repdate);
         test.stopTest(); 
         }  
   static testMethod void test4(){
        createCRWTestData();
     PageReference pageRef = Page.sfCRWdocument;
        pageRef.getParameters().put('selectedReport',repid2);
        Test.setCurrentPageReference(pageRef);        
        sfDocumentcontroller crw = new sfDocumentcontroller();
        test.startTest();
        crw.CRWuser = true;
        crw.pageClose();
        crw.openReport();
        crw.showPopup();
        crw.hideWarning();
        string s = crw.stringStatus('U');
        s = crw.stringStatus('S');
        s = crw.stringStatus('T');
        crw.exit_date = date.today();
        crw.exittype = 'S';
        crw.gender = 'Male';
        crw.clientName = 'nobody';
        crw.prev_rep_date = date.today() - 10;
        crw.next_rep_date = date.today() + 5;
        
        crw.createReportNarrative();
         test.stopTest(); 
         }                    
}