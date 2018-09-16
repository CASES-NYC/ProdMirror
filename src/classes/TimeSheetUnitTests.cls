@isTest(SeeAllData=true) 
private class TimeSheetUnitTests {
	
    static UtilityTimeMethods ut = new UtilityTimeMethods();
    
    static boolean bolStartTimeRequired;
    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    static Id conClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;    
    static Id conJS = Utility_ID__c.getValues('Justice Scholars Client').RecordType_Id__c;
    static Id conCJC = Utility_ID__c.getValues('Civic Justice Corps Client').RecordType_Id__c; 
    static Id ExternalEmployment = Utility_ID__c.getValues('Employment - External').RecordType_Id__c;
    static String[] selProgramIds = new String[]{conClient,conJS,conCJC};
    static String[] programsEmpty = new String[]{};
    static string selectedId;
    
    
    static Event dataSetup() {
    	
    	utilityIds utilIds = new utilityIds();
    	
        // Init Core Records    
        accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert accClient;
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2013TN456011';
        newCaseInfo.Borough__c = 'Bronx';
        insert newCaseInfo;        
        
        con = new Contact();
        con.firstName = 'Unit';
        con.lastName = 'Tester';
        con.Drug_test_frequency__c = 'Bi-Weekly';
        con.Referral_Date__c = system.today().addDays(-5);
        con.Eligible__c = 'Yes';
        con.Interview_Acceptance_Date__c = system.today().addDays(-3);
        con.Interview_Outcome__c = 'CEP Accepts';
        con.Intake_Approved_By__c = userInfo.getUserId();
        con.Intake_Date__c = System.Today();
        con.Intake_Case__c = newCaseInfo.id;
        con.RecordTypeId = utilIds.conClient;
        con.accountId = accClient.id;      
        
        insert con;
        

        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        
        Event evt = new Event();
        
       // Event for CEP Client not verified appt
        evt.recordtypeid = ExternalEmployment;
        evt.Subject = 'CE Internship Participation';
        evt.verification_status__c = 'Not Verified';
        evt.ActivityDateTime = datetime.now();
        evt.ActivityDate = date.today();
        evt.time_in__c = '12:00 PM';
        evt.time_out__c = ''; 
        evt.DurationInMinutes = 60;
        evt.WhoId = con.Id;
        evt.isrecurrence = false;
        evt.recurrenceType = null ;
        insert new sObject[]{thisEvent, evt};
        
        return evt;
      }
      
 
       static testMethod void testcheckInput()
       {
            
           TimeSheetController ts = new TimeSheetController();
           test.startTest();         
//           string test_date = string.parse(date.today());

           ts.proxyObject.open_date__c = date.today() - 20;
           ts.proxyObject.closing_date__c = date.today();
           ts.checkDateInput();
            
           ts.proxyObject.open_date__c =  date.today() + 5; 
           ts.proxyObject.closing_date__c = date.today() - 3;
           ts.checkDateInput();

           ts.proxyObject.open_date__c =  date.today();
           ts.proxyObject.closing_date__c = date.today() - 40;
           ts.checkDateInput();
           
           ts.proxyObject.open_date__c =  date.today() + 5;
           ts.proxyObject.closing_date__c = date.today() + 8;
             ts.checkDateInput();
   
         test.stopTest();
       }
       
       static testMethod void testGetMessage()
       {
            TimeSheetController ts = new TimeSheetController();
           test.startTest();
                  
            
           ts.proxyObject.open_date__c = date.today();
           ts.proxyObject.closing_date__c = date.today() + 2;
           ts.getMessage();
            
           ts.proxyObject.open_date__c = date.today();
           ts.proxyObject.closing_date__c = date.today() + 40;
           ts.getMessage();

           ts.proxyObject.open_date__c =  date.today() ;
           ts.proxyObject.closing_date__c = date.today() - 3;
           ts.getMessage();
           ts.setPrograms(selProgramIds);
         test.stopTest();
       }
          static testMethod void testGenerateClientsListInProgram()
       {
         test.startTest();
         TimeSheetController ts = new TimeSheetController();
         string s_date = '10/24/2012';
         date date_end = date.parse(s_date);
         ts.proxyObject.open_date__c = date_end - 3;
         ts.proxyObject.closing_date__c = date_end;
         ts.getContactIdForPeriodandProgram();
         test.stopTest();  
       } 
 
       static testMethod void testgetProgram()
       {
         test.startTest();
         TimeSheetController ts = new TimeSheetController();

         ts.programs = programsEmpty;
         ts.getPrograms();

         ts.programs = selProgramIds;
         ts.getPrograms();
         
         test.stopTest();           
       }
  
      static testMethod void testcheckProgramItems()
       {
         TimeSheetController ts = new TimeSheetController();
         test.startTest();
         ts.getProgramItems();
         test.stopTest();           
       }
           
       static testMethod void testAttendanceItems()
       {
           test.startTest();
           TimeSheetController ts = new TimeSheetController();
 
           List<SelectOption> lst = ts.AttendanceItems;
           test.stopTest();
       }   
   static testMethod void testBuildTimeList()
      {
           test.startTest();
           TimeSheetController ts = new TimeSheetController();
           ts.BuildTimeList('11:55 AM',  date.today(), 'in');

           bolStartTimeRequired = true;
           ts.BuildTimeList('09:00 AM', date.today() + 1, 'out');
  
           bolStartTimeRequired = true;
           ts.BuildTimeList('05:00 PM', date.today()+ 2, 'in');
           test.stopTest();
     }
     
     
   static testMethod void testBuildTimeList_1_in()
      {
           test.startTest();
           TimeSheetController ts = new TimeSheetController();
           ts.t_Beg = 11; 
           ts.BuildTimeList('11:55 AM', date.today(), 'in');

           ts.t_Beg = 7; 
           ts.BuildTimeList('09:00 AM', date.today() - 1, 'in');
  
           bolStartTimeRequired = true;
           ts.BuildTimeList('05:00 PM', date.today()+ 2, 'in');

           test.stopTest();
     }
     
   static testMethod void testBuildTimeList_1_out()
      {
           test.startTest();
           TimeSheetController ts = new TimeSheetController();
           ts.t_Beg = 11; 
           ts.BuildTimeList('11:55 AM', date.today(), 'out');

           ts.t_Beg = 7; 
           ts.BuildTimeList('09:00 AM',date.today() - 1, 'out');
  
           bolStartTimeRequired = true;
           ts.BuildTimeList('05:00 PM', date.today()+ 2, 'out');

           test.stopTest();
     }

      static testMethod void testBuildTimeList_0_out()
      {
           test.startTest();
           TimeSheetController ts = new TimeSheetController();
           ts.t_Beg = 11; 
           ts.BuildTimeList('11:00 AM',  date.today(), 'out');

           ts.BuildTimeList('09:00 AM', date.today() - 1, 'out');
  
           bolStartTimeRequired = true;
           ts.BuildTimeList('03:00 PM', date.today()+ 2, 'out');

           test.stopTest();
     }
     
  

       static testMethod void testBuildTimeList_2() {
        
        Event evt = dataSetup();
        selectedId = evt.whoId;
        
        TimeSheetController ts = new TimeSheetController();
        test.startTest();
        ts.proxyObject.open_date__c = date.today() - 5;
        ts.proxyObject.closing_date__c = date.today(); 
        ts.attendance = 'Attended';
        ts.t_beg = 9;
        ts.BuildTimeList('09:00 AM',  evt.activitydate, 'in');

        ts.t_beg = 11;
        ts.BuildTimeList('09:00 AM',  evt.activitydate, 'in');

        ts.attendance = 'Late';
        ts.BuildTimeList('09:00 AM',  evt.activitydate, 'in');


        ts.t_beg = 11;
        ts.BuildTimeList(evt.Time_In__c,   evt.activitydate,'out');
 
        ts.BuildTimeList(evt.Time_In__c,   evt.activitydate,'in');
        ts.selectedid = evt.whoId;
      test.stopTest();
     }
      
     static testMethod void testclientName() {
        
       Event evt = dataSetup();
       selectedId = evt.whoId;
        
       TimeSheetController ts = new TimeSheetController();
       test.startTest();
       ts.SelectedId = evt.whoId;
       List<SelectOption> option = new List<SelectOption>();
       option = ts.getContactNames();
       Contact cnt = new contact();
        cnt = ts.ClientName;
       test.stopTest();
     }
  
     static testMethod void testgetContactIdForPeriodandProgram() {
        
        Event evt = dataSetup();
        selectedId = evt.whoId;
        
        TimeSheetController ts = new TimeSheetController();
        test.startTest();
        ts.proxyObject.open_date__c = date.today();
        ts.proxyObject.closing_date__c = date.today(); 
        ts.programs = programsEmpty;
        ts.getContactIdForPeriodandProgram();

        ts.programs = selProgramIds;
        ts.proxyObject.open_date__c = date.today() + 2;
        ts.proxyObject.closing_date__c = date.today(); 
        ts.getContactIdForPeriodandProgram();
        ts.getResults();
        test.stopTest();
     }
 
     static testMethod void testgetEventsNotVerified() {

        Event evt = dataSetup();
        selectedId = evt.whoId;

        TimeSheetController ts = new TimeSheetController();
        test.startTest();
        ts.proxyObject.open_date__c = date.today();
        ts.proxyObject.closing_date__c = date.today(); 
        ts.getEvents();
      //  integer ev = ts.events.size();
    //    setTimeOutStart();
        test.stopTest();
     }
     
     static testMethod void testgetResults() {


        Event evt = dataSetup();
        
        test.startTest();
        selectedId = evt.whoId;
            
        TimeSheetController ts = new TimeSheetController();
         ts.proxyObject.open_date__c = system.today();
        ts.proxyObject.closing_date__c = system.today().addDays(1); 
        ts.ResetEvents();
      //  ts.getResults();
       test.stopTest();
    
     }
     
     static testMethod void testSaveAttendanceRecord() {
  
        Event evt = dataSetup();
        selectedId = evt.whoId;
  
        test.startTest();
        
        TimeSheetController ts = new TimeSheetController();
        ts.EventId = evt.id;
        ts.fielddatetime = datetime.now() ;
        ts.fieldname = 'Attendance';
        ts.FieldValue = 'Attended';
        ts.fieldDuration = 60;
        ts.saveRecord();
        
        ts.FieldValue = 'Late';
        ts.saveRecord();
  
        ts.FieldValue = 'Excused';
        ts.saveRecord();
      
        test.stopTest();  
     }
     
       static testMethod void testSaveTimesRecord() {
        
        Event evt = dataSetup();
        
        test.startTest();
        
        TimeSheetController ts = new TimeSheetController();
        selectedId = evt.whoId;
        
        ts.EventId = evt.id;
        ts.fieldName = 'Time In';
        ts.fieldValue = '10:00 AM';
        ts.saveRecord();

        ts.fieldName = 'Time Out'; 
        ts.fieldValue = '11:00 AM';
        ts.saveRecord();
        
        test.stopTest();  
     }
     static testMethod void testSetTimeOutStart() {
        
        Event evt = dataSetup();
        
        test.startTest();
        
        selectedId = evt.whoId;
        TimeSheetController ts = new TimeSheetController();        
        ts.proxyObject.open_date__c = date.today();
        ts.proxyObject.closing_date__c = date.today();  
        ts.programs = selProgramIds;
        ts.selectedId = selectedId;
        List<TimeSheetController.CLSeventForDisplay> lstTsEvents = 
        new List<TimeSheetController.CLSeventForDisplay>();
        lstTsEvents = ts.getEvents();
       // ts.SetTimeOutStart();
        test.stopTest();
     }
     
     static testMethod void testDayOfWeek() {
     	
        Event evt = dataSetup();
             	
        test.startTest();

        TimeSheetController ts = new TimeSheetController();
        ts.programs = selProgramIds;
        selectedId = evt.whoId;
        
        List<TimeSheetController.CLSeventForDisplay> lstTsEvents = 
        new List<TimeSheetController.CLSeventForDisplay>();
        lstTsEvents = ts.getEvents();
        test.stopTest();
     }
     
     static testMethod void testSelectedId() {
        
        Event evt = dataSetup();
        selectedId = evt.whoId;
        
        TimeSheetController ts = new TimeSheetController();
        test.startTest();
        ts.programs = selProgramIds;
        ts.fieldValue = evt.WhoId;
        ts.setselectedId();
        ts.SelectedId = ts.fieldValue;
        test.stopTest();
     }
     
     static testMethod void testColor() {
     	
        TimeSheetController ts = new TimeSheetController();
        test.startTest();
        ts.setColor(8,5);
        ts.setColor(5,8);
        test.stopTest();
     }     
 }