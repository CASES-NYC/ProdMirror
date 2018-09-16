@isTest (seeAllData=true)
private class scheduleMandatory_UnitTest{
  static Id accClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;

    static utilityIds utilIDs = new utilityIds();
    static UtilityTimeMethods ut = new UtilityTimeMethods();    
    static reportQuery rq = new reportQuery();

    static Account accCep1 = new Account();
    static Account accCep2 = new Account();
    static Account accCep3 = new Account();
    static Account accCep4 = new Account();
    
    static Contact con1 = new Contact();
    static Contact con2 = new Contact();
    static Contact con3 = new Contact();
    static Contact con4 = new Contact();
     
    static Course__c course1 = new Course__c();     
    static Course__c course2 = new Course__c();     
    static Course__c course3 = new Course__c();     
    static Course__c course4 = new Course__c();     
    static Class__c class1 = new Class__c();
    static Class__c class2 = new Class__c();
    static Schedule__c sched1 = new Schedule__c();
    static Schedule__c sched2 = new Schedule__c();
    static Enrollment__c enroll1 = new Enrollment__c();
    static Session__c sess1 = new Session__c();
    static Session__c sess2 = new Session__c();
    static Event evt1 = new Event();
    static string cepid1,cepid2,cepid3,sessId1,eventid,agencyid,courseId4,instructor; 
//    static Assessment__c ass1 = new Assessment__c();
 //  static Assessment__c ass2 = new Assessment__c();
     
    static void createTestData() {
    	
  //     string  profNames1 = 'CEP - Admin Support Supervisor';
   //   string  profNames2 = 'CEP - Deputy Director';
    	
   //   Profile p = [select id from profile where name =: profNames1];
  //  	instructor = p.id;
      Id accExternalEntities = Utility_Id__c.getValues('External Entities').RecordType_Id__c;  
      Account accCases = new Account(Name='CASES', RecordTypeId = accExternalEntities);
      insert accCases;
      agencyId = accCases.id;
      
      User u = [SELECT Id FROM User WHERE IsActive = true AND ProfileId = :utilIds.cepIcdStaff LIMIT 1];
      instructor = u.id;
        string courseId1,courseId2,courseId3;  
        
        string classId1,classId2,classId3,timefrom,timeto;
        string schedId1,schedId2,schedId3;
  
        // Init Core Records    
        accCep1 = new Account(Name='test1', RecordTypeId = utilIds.accClient);
        insert accCep1;
        con1 = new Contact();
        con1.firstName = 'first1';
        con1.lastName = 'last1';
        con1.Current_Intake_Date__c = System.Today();
        con1.RecordTypeId = accClient;
        con1.accountId = accCep1.id;   
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Date__c = System.Today();
        insert con1;
        cepid1 = con1.id;

       accCep2 = new Account(Name='test2', RecordTypeId = utilIds.accClient);
        insert accCep2;
        con2 = new Contact();
        con2.firstName = 'first1';
        con2.lastName = 'last1';
        con2.Current_Intake_Date__c = System.Today();
        con2.Intake_Date__c = System.Today();
        con2.RecordTypeId = accClient;
        con2.accountId = accCep1.id;   
        con2.Reporting_Borough__c = 'Harlem';   
        insert con2;
        cepid2 = con2.id;

        course1 = new Course__c();
        course1.name= 'name1';
        course1.Area__c = 'Case Coordination';
        course1.Category__c = 'Mandatory Class';
        course1.Serves_All_Programs__c = true;
        insert course1;
        courseId1 = course1.id;
 
        course2 = new Course__c();
        course2.name= 'name2';
        course2.Area__c = 'Case Coordination';
        course2.Category__c = 'Mandatory Class';
        course2.Serves_All_Programs__c = true;
        insert course2;
        courseId2 = course2.id;

        course3 = new Course__c();
        course3.name= 'name3';
        course3.Area__c = 'Case Coordination';
        course3.Category__c = 'Mandatory Class';
        course3.Serves_All_Programs__c = true;
        insert course3;
        courseId3 = course3.id;
 
        course4 = new Course__c();
        course4.name= 'name4';
        course4.Area__c = 'Case Coordination';
        course4.Category__c = 'Mandatory Class';
        course4.programs_served__c = 'CEP';
   //     course4.Serves_All_Programs__c = true;
        
        insert course4;
        courseId4 = course4.id;
        
        class1 = new Class__c();
        class1.First_Session_On__c = date.today();
        class1.Suggested_Max_Size__c = 1;
        class1.Subtitle__c = '9';
        class1.Section__c = courseId1; 
        class1.Instructor_1__c = u.id;
        class1.No_of_Sessions_Scheduled__c = 10;
        class1.Course__c = courseId1;
        class1.CategoryRPT__c = 'Mandatory Class'; 
        class1.RecordTypeId = utilIds.classOngoing;
        class1.AreaRPT__c = 'Case Coordination'; 
        class1.Class_Location__c = 'Brooklyn';
        insert class1;
        classId1 = class1.id;
        
        
   //     ass1.Contact__c = cepid1;
    //    ass1.Assessment_Completed_on__c = System.today();
   //     ass1.RecordTypeId = utilIds.ccAssessmentRecordType; 
   //     insert ass1;       
       

     //   ass2.Contact__c = cepid1;
    //    ass2.Assessment_Completed_on__c = System.today();
    //    ass2.RecordTypeId = utilIds.eduAssessmentRecordType;
     //   insert ass2;



        // Create Schedule
      sched1 = new Schedule__c();
      sched1.Class__c = classId1;
      sched1.Start_Date__c = System.Today();
      sched1.End_Date__c = System.Today();
//        sched1.Months_of_Sessions_to_Generate__c = '1';
     sched1.RecordTypeId = utilIds.scheduleSingle;
  //      sched1.End_Date__c = 
    //    sched1.Change_Schedule_As_Of__c.addMonths(Integer.valueOf(sched1.Months_of_Sessions_to_Generate__c));               
      
       insert sched1;
      schedId1 = sched1.id;

      // Create Session
         sess1 = new Session__c();
      sess1.Assigned_To__c = u.id;
      sess1.Schedule__c = schedId1;
      sess1.Session_Start__c = sched1.Start_Date__c;
      sess1.Session_End__c = sched1.End_Date__c;
      insert sess1;
      sessId1 = sess1.id;
//
        evt1 = new Event();
        evt1.whoid =  cepid1;
        evt1.whatid = sessId1;
           evt1.ActivityDateTime = sess1.Session_Start__c;
           evt1.StartDateTime = sess1.Session_Start__c;  
           evt1.ActivityDate = date.valueof( sess1.Session_Start__c);
           timefrom = sess1.Session_Start__c.format('hh:mm a');
           timeto = sess1.Session_End__c.format('hh:mm a');
           evt1.DurationInMinutes = integer.valueOf(ut.counthours(timefrom,timeto));
           evt1.unit__c = 'Case Coordination';            
           evt1.type__c = 'Face to Face';  
           evt1.ClassTypeRPT__c =  Utility_ID__c.getValues('Ongoing').RecordType_Id__c;            
           evt1.Verification_Status__c = 'Not Verified';
           evt1.Class_Category__c = 'Mandatory Class';
           evt1.recordtypeid = '012600000005JTtAAM';

       insert evt1;
       eventid = evt1.id;
  //  
      }
  
 
       static testMethod void test2()
       {
         createTestData();
        scheduleMandatoryController sm = new scheduleMandatoryController();
        sm.contactselected = cepid1;
        sm.selectedClassBoro = 'Brooklyn';
        test.startTest();
        sm.findClientEvents();
        sm.sessionselected = sessId1;
    
        sm.enroll(); 
        List<Course__c> lstcourses = sm.selectCourses();        
        test.stopTest(); 
       }
 static testMethod void allGets() 
       {
         createTestData();
         test.startTest();
     //   ApexPages.CurrentPage().getParameters().put('contactPassed',cepid1);
        scheduleMandatoryController sm = new scheduleMandatoryController();
        List<SelectOption> d =  sm.getduration();
        List<SelectOption> t =  sm.getTimeIn();
        List<SelectOption> a =  sm.getAgency();
       List<SelectOption> sl = sm.getClassBoro();
       List<SelectOption> bc = sm.getBoro4create();
        List<SelectOption> sB = sm.getBoro();         
     //   List<SelectOption> c =  sm.getClassBoro4Create();     
        List<SelectOption> b = sm.getBoro();
        
        sm.showCourses();
        sm.hideCourses();
        
        string tl = sm.getTimeInList();
   //     string clsboro = sm.getClassBoroList();
        string ag = sm.getAgencyList();
        test.stopTest(); 
       }

     static testMethod void test4()
       {
         createTestData();
           test.startTest();
        ApexPages.CurrentPage().getParameters().put('contactPassed',cepid1);
        scheduleMandatoryController sm = new scheduleMandatoryController();
        sm.findBoro();
       // sm.findClassBoro();
        List<SelectOption> br = sm.getBoro();
        sm.findClientEvents1();
        test.stopTest(); 
       }

      static testMethod void test5()
       {
         createTestData();
        scheduleMandatoryController sm = new scheduleMandatoryController();
        sm.contactselected = cepid2;
        test.startTest();
        sm.eventid = eventid;
        sm.attendanceValue = 'Attended';
        sm.saveRecord();
     //   sm.findLstMandatoryAvailableShow();
        test.stopTest(); 
       }
       
          
       static testMethod void testSaveClass(){
        createTestData();
        scheduleMandatoryController sm = new scheduleMandatoryController();
        test.startTest();
        sm.findCoursesNames();
        sm.findInstructors();
        sm.selectedCourse = courseId4;
        sm.selectedTimeIn = '10:00 AM';
        sm.selectedDuration = '60';
        sm.makeTimeOut();
        sm.selectedClassAgency = agencyId;
        sm.selectedClassLocation = 'Brooklyn';
        sm.contactselected = cepid2;
        sm.selectedInstructor = instructor;
        sm.saveClass();
        test.stopTest();         
       }
  
}