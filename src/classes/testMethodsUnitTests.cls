@isTest
private class testMethodsUnitTests {

    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    
  /*
    static testMethod void testAllExceptDrugs() {
    
        ///////////////////////////////////////////////////////
        //
        // Stage Data 
        //
        ///////////////////////////////////////////////////////
        
        utilityIds utilIds = new utilityIds();
        
        // added 3/2/13 MB: only insert once, to avoid hitting SOQL limits
        list<Task> lstTasksforInsert = new list<Task>();
        list<Test__c> lstTestsforInsert = new list<Test__c>();
        list<Task> lstTasksforInsert2 = new list<Task>();
        list<Test__c> lstTestsforInsert2 = new list<Test__c>();     
        
        System.debug('utilIds.initialDrugTestTask: ' + utilIds.initialDrugTestTask);
        
        Account newAccountForInsert = new Account();
        newAccountForInsert.name = 'CEP Test Account';
        insert newAccountForInsert;
        
        Contact newContactForInsert = new Contact();
        newContactForInsert.lastName = 'Test';
        newContactForInsert.Client_Status__c = 'Active';
        newContactForInsert.Drug_test_frequency__c = 'Bi-Weekly';
        newContactForInsert.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        insert newContactForInsert;
        
        ////////////////////////////////////////////////////////
        //
        // Run tests
        //
        //////////////////////////////////////////////////////////
        
        testMethods TestMethods = new testMethods();
        TestMethods.getWhoIds();     
                    
        //////////////////////////////////////////////////
        // GED
        //////////////////////////////////////////////////
        
        Test__c gedInsert = new Test__c();
        gedInsert.Test_Date__c = System.Today();
        gedInsert.Contact__c = newContactForInsert.Id;
        gedInsert.RecordTypeId = utilIds.gedRecordType;
        gedInsert.Result__c = 'Pass';
        //insert gedInsert;
        lstTestsforInsert.add(gedInsert);
        
        
        //////////////////////////////////////////////////
        // MAYSI Test 
        ////////////////////////////////////////////////// 
        
        Task maysiTestTaskForInsert = new Task();
        maysiTestTaskForInsert.whoId = newContactForInsert.Id;
        maysiTestTaskForInsert.ActivityDate = System.Today().addDays(1);
        maysiTestTaskForInsert.RecordTypeId = utilIds.MAYSIAssessmentTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated
        maysiTestTaskForInsert.Automatically_Generated__c = true;
        //insert maysiTestTaskForInsert;
        lstTasksforInsert.add(maysiTestTaskforInsert);
       
        Test__c maysiTestForInsert = new Test__c();
        maysiTestForInsert.Test_Date__c = System.Today();
        maysiTestForInsert.Contact__c = newContactForInsert.Id;
        maysiTestForInsert.RecordTypeId = utilIds.maysiTestRecordType;
        //insert maysiTestForInsert;
        lstTestsforInsert.add(maysiTestforInsert);
       
        /// DONE LATE
        
        Task maysiTestTaskForInsertTwo = new Task();
        maysiTestTaskForInsertTwo.whoId = newContactForInsert.Id;
        maysiTestTaskForInsertTwo.ActivityDate = System.Today().addDays(-1);
        maysiTestTaskForInsertTwo.RecordTypeId = utilIds.MAYSIAssessmentTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated
        maysiTestTaskForInsertTwo.Automatically_Generated__c = true;
        //insert maysiTestTaskForInsertTwo;
        lstTasksforInsert2.add(maysiTestTaskforInsertTwo);
        
        Test__c maysiTestForInsertTwo = new Test__c();
        maysiTestForInsertTwo.Test_Date__c = System.Today();
        maysiTestForInsertTwo.Contact__c = newContactForInsert.Id;
        maysiTestForInsertTwo.RecordTypeId = utilIds.maysiTestRecordType;
        //insert maysiTestForInsertTwo;
        lstTestsforInsert2.add(maysiTestforInsertTwo);
        
        //////////////////////////////////////////////////
        // STAR Test - Math
        //////////////////////////////////////////////////
        
        Task starMathTestTaskForInsert = new Task();
        starMathTestTaskForInsert.whoId = newContactForInsert.Id;
        starMathTestTaskForInsert.ActivityDate = System.Today().addDays(1);
        starMathTestTaskForInsert.RecordTypeId = utilIds.STARTestMathTask;
        //insert starMathTestTaskForInsert;
        lstTasksforInsert.add(starMathTestTaskForInsert);
        
        Test__c starMathTestForInsert = new Test__c();
        starMathTestForInsert.Test_Date__c = System.Today();
        starMathTestForInsert.Contact__c = newContactForInsert.Id;
        starMathTestForInsert.RecordTypeId = utilIds.starTestRecordType;
        starMathTestForInsert.Test_Type__c = 'Math';
        starMathTestForInsert.Grade_Equivalent__c = 5.0;
        //insert starMathTestForInsert;
        lstTestsforInsert.add(starMathTestforInsert);
        
        //// DONE LATE
        
        Task starMathTestTaskForInsertTwo = new Task();
        starMathTestTaskForInsertTwo.whoId = newContactForInsert.Id;
        starMathTestTaskForInsertTwo.ActivityDate = System.Today().addDays(-1);
        starMathTestTaskForInsertTwo.RecordTypeId = utilIds.STARTestMathTask;
        //insert starMathTestTaskForInsertTwo;
        lstTasksforInsert2.add(starMathTestTaskforInsertTwo);
        
        Test__c starMathTestForInsertTwo = new Test__c();
        starMathTestForInsertTwo.Test_Date__c = System.Today();
        starMathTestForInsertTwo.Contact__c = newContactForInsert.Id;
        starMathTestForInsertTwo.RecordTypeId = utilIds.starTestRecordType;
        starMathTestForInsertTwo.Test_Type__c = 'Math';
        starMathTestForInsertTwo.Grade_Equivalent__c = 5.0;
        //insert starMathTestForInsertTwo;
        lstTestsforInsert2.add(starMathTestforInsertTwo);
        
        
    
        
        
        //////////////////////////////////////////////////
        // STAR Test - Reading
        //////////////////////////////////////////////////
        
        Task starReadingTestTaskForInsert = new Task();
        starReadingTestTaskForInsert.whoId = newContactForInsert.Id;
        starReadingTestTaskForInsert.ActivityDate = System.Today().addDays(1);
        starReadingTestTaskForInsert.RecordTypeId = utilIds.STARTestReadingTask;
        //insert starReadingTestTaskForInsert;
        lstTasksforInsert.add(starREadingTestTaskforInsert);
        
        Test__c starReadingTestForInsert = new Test__c();
        starReadingTestForInsert.Test_Date__c = System.Today();
        starReadingTestForInsert.Contact__c = newContactForInsert.Id;
        starReadingTestForInsert.RecordTypeId = utilIds.starTestRecordType;
        starReadingTestForInsert.Test_Type__c = 'Read';
        starReadingTestForInsert.Grade_Equivalent__c = 5.0;
        //insert starReadingTestForInsert;
        lstTestsforInsert.add(starReadingTestforInsert);

        //// DONE LATE
        
        Task starReadingTestTaskForInsertTwo = new Task();
        starReadingTestTaskForInsertTwo.whoId = newContactForInsert.Id;
        starReadingTestTaskForInsertTwo.ActivityDate = System.Today().addDays(-1);
        starReadingTestTaskForInsertTwo.RecordTypeId = utilIds.STARTestReadingTask;
        //insert starReadingTestTaskForInsertTwo;
        lstTasksforInsert2.add(starReadingTestTaskforInsertTwo);
        
        Test__c starReadingTestForInsertTwo = new Test__c();
        starReadingTestForInsertTwo.Test_Date__c = System.Today();
        starReadingTestForInsertTwo.Contact__c = newContactForInsert.Id;
        starReadingTestForInsertTwo.RecordTypeId = utilIds.starTestRecordType;
        starReadingTestForInsertTwo.Test_Type__c = 'Read';
        starReadingTestForInsertTwo.Grade_Equivalent__c = 5.0;
        //insert starReadingTestForInsertTwo;
        lstTestsforInsert2.add(starReadingTestForInsertTwo);
        
        //////////////////////////////////////////////////
        // Exit Drug Test
        //////////////////////////////////////////////////
            
        Task exitDrugTestTask = new Task();
        exitDrugTestTask.whoId = newContactForInsert.Id;
        exitDrugTestTask.ActivityDate = System.Today().addDays(5);
        exitDrugTestTask.RecordTypeId = utilIds.exitDrugTestTask;
        exitDrugTestTask.Open_Date__c = System.Today();
        //this line added by MB 9/17/12 because this task can no longer be manually generated           
        exitDrugTestTask.Automatically_Generated__c = true;     
        //insert exitDrugTestTask;
        lstTasksforInsert.add(exitDrugTestTask);
        
        
        Test__c exitDrugTest = new Test__c();
        exitDrugTest.Test_Date__c = System.Today();
        exitDrugTest.Contact__c = newContactForInsert.Id;
        exitDrugTest.RecordTypeId = utilIds.drugTestRecordType;
        exitDrugTest.PCP__c = 2;
        //insert exitDrugTest;          
        lstTestsforInsert.add(exitDrugTest);
        
        
        insert lstTasksforInsert;
        insert lstTestsforInsert;
        insert lstTasksforInsert2;
        insert lstTestsforInsert2;
        
    }
    */
    
    static testMethod void testDrugs() {
    
        ///////////////////////////////////////////////////////
        //
        // Stage Data 
        //
        ///////////////////////////////////////////////////////
        
        utilityIds utilIds = new utilityIds();

        list<Contact> lstContactsforInsert = new list<Contact>();       
        list<Task> lstTasksforInsert = new list<Task>();
        list<Test__c> lstTestsforInsert = new list<Test__c>();              
        
        System.debug('utilIds.initialDrugTestTask: ' + utilIds.initialDrugTestTask);
        
        Account newAccountForInsert = new Account();
        newAccountForInsert.name = 'CEP Test Account';
        insert newAccountForInsert;
        
        Contact newContactForInsert1 = new Contact();
        newContactForInsert1.lastName = 'Test';
        newContactForInsert1.Client_Status__c = 'Active';
        newContactForInsert1.Drug_test_frequency__c = 'Bi-Weekly';
        newContactForInsert1.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        lstContactsforInsert.add(newContactForInsert1);
        
        Contact newContactForInsert2 = new Contact();
        newContactForInsert2.lastName = 'Test';
        newContactForInsert2.Client_Status__c = 'Active';
        newContactForInsert2.Drug_test_frequency__c = 'Weekly';
        newContactForInsert2.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        lstContactsforInsert.add(newContactForInsert2); 
        
        Contact newContactForInsert3 = new Contact();
        newContactForInsert3.lastName = 'Test';
        newContactForInsert3.Client_Status__c = 'Active';
        newContactForInsert3.Drug_test_frequency__c = 'Monthly';
        newContactForInsert3.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        lstContactsforInsert.add(newContactForInsert3); 
        
        Contact newContactForInsert4 = new Contact();
        newContactForInsert4.lastName = 'Test';
        newContactForInsert4.Client_Status__c = 'Active';
        newContactForInsert4.Drug_test_frequency__c = 'Bi-Weekly';
        newContactForInsert4.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        lstContactsforInsert.add(newContactForInsert4);
        
        Contact newContactForInsert5 = new Contact();
        newContactForInsert5.lastName = 'Test';
        newContactForInsert5.Client_Status__c = 'Active';
        newContactForInsert5.Drug_test_frequency__c = 'Bi-Weekly';
        newContactForInsert5.Current_Projected_Exit_Date__c = System.Today().addDays(25);
        lstContactsforInsert.add(newContactForInsert5);     
        
        insert lstContactsforInsert;
        
        ////////////////////////////////////////////////////////
        //
        // Run tests
        //
        //////////////////////////////////////////////////////////
        
        testMethods TestMethods = new testMethods();
        TestMethods.getWhoIds();     
            
        //////////////////////////////////////////////////
        // Drug Test Tests
        //////////////////////////////////////////////////
        
        Task drugTestTaskForInsert = new Task();
        drugTestTaskForInsert.whoId = newContactForInsert1.Id;
        drugTestTaskForInsert.ActivityDate = System.Today().addDays(1);
        drugTestTaskForInsert.RecordTypeId = utilIds.initialDrugTestTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated
        drugTestTaskForInsert.Automatically_Generated__c = true;            
        lstTasksforInsert.add(drugTestTaskForInsert);
            
        Test__c drugTestForInsert = new Test__c();
        drugTestForInsert.Test_Date__c = System.Today();
        drugTestForInsert.Contact__c = newContactForInsert1.Id;
        drugTestForInsert.RecordTypeId = utilIds.drugTestRecordType; 
        drugTestForInsert.PCP__c = 2;
        lstTestsforInsert.add(drugTestForInsert);
        
        Task drugTestTaskForInsertTwo = new Task();
        drugTestTaskForInsertTwo.whoId = newContactForInsert2.Id;
        drugTestTaskForInsertTwo.ActivityDate = System.Today().addDays(1);
        drugTestTaskForInsertTwo.RecordTypeId = utilIds.initialDrugTestTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated           
        drugTestTaskForInsertTwo.Automatically_Generated__c = true;     
        lstTasksforInsert.add(drugTestTaskForInsertTwo);
        
        
        Test__c drugTestForInsertTwo = new Test__c();
        drugTestForInsertTwo.Test_Date__c = System.Today();
        drugTestForInsertTwo.Contact__c = newContactForInsert2.Id;
        drugTestForInsertTwo.RecordTypeId = utilIds.drugTestRecordType;
        drugTestForInsertTwo.PCP__c = 2;
        lstTestsforInsert.add(drugTestForInsertTwo);

        
        Task drugTestTaskForInsertThree = new Task();
        drugTestTaskForInsertThree.whoId = newContactForInsert3.Id;
        drugTestTaskForInsertThree.ActivityDate = System.Today().addDays(1);
        drugTestTaskForInsertThree.RecordTypeId = utilIds.initialDrugTestTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated           
        drugTestTaskForInsertThree.Automatically_Generated__c = true;                   
        lstTasksforInsert.add(drugTestTaskForInsertThree);
        
        
        Test__c drugTestForInsertThree = new Test__c();
        drugTestForInsertThree.Test_Date__c = System.Today();
        drugTestForInsertThree.Contact__c = newContactForInsert3.Id;
        drugTestForInsertThree.RecordTypeId = utilIds.drugTestRecordType;
        drugTestForInsertThree.PCP__c = 2;
        lstTestsforInsert.add(drugTestForInsertThree);
            
            
        /// DONE LATE
        
        Task drugTestTaskForInsertFour = new Task();
        drugTestTaskForInsertFour.whoId = newContactForInsert4.Id;
        drugTestTaskForInsertFour.ActivityDate = System.Today().addDays(-10);
        drugTestTaskForInsertFour.RecordTypeId = utilIds.initialDrugTestTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated           
        drugTestTaskForInsertFour.Automatically_Generated__c = true;        
        lstTasksforInsert.add(drugTestTaskForInsertFour);
        
        
        Test__c drugTestForInsertFour = new Test__c();
        drugTestForInsertFour.Test_Date__c = System.Today();
        drugTestForInsertFour.Contact__c = newContactForInsert4.Id;
        drugTestForInsertFour.RecordTypeId = utilIds.drugTestRecordType;
        drugTestForInsertFour.PCP__c = 2;
        lstTestsforInsert.add(drugTestForInsertFour);
            
        Task drugTestTaskForInsertFive = new Task();
        drugTestTaskForInsertFive.whoId = newContactForInsert5.Id;
        drugTestTaskForInsertFive.ActivityDate = System.Today().addDays(-10);
        drugTestTaskForInsertFive.RecordTypeId = utilIds.nextDrugTestTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated           
        drugTestTaskForInsertFive.Automatically_Generated__c = true;        
        lstTasksforInsert.add(drugTestTaskForInsertFive);
        
        
        Test__c drugTestForInsertFive = new Test__c();
        drugTestForInsertFive.Test_Date__c = System.Today();
        drugTestForInsertFive.Contact__c = newContactForInsert5.Id;
        drugTestForInsertFive.RecordTypeId = utilIds.drugTestRecordType;
        drugTestForInsertFive.PCP__c = 2;
        lstTestsforInsert.add(drugTestForInsertFive);
        
        insert lstTasksforInsert;
        insert lstTestsforInsert;
        
    }   
    
    // 3/25/13 MB: this method created to test functionality in prod.a.BT-0661
    static testmethod void testDrugTestsAtCEPIntake() {
        
        ///////////////////////////////////////////////////////
        // Stage Data 
        //////////////////////  /////////////////////////////////
        
        utilityIds utilIds = new utilityIds();
        
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
        User adminUser = 
        [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
        
        con.Intake_Approved_By__c = adminUser.id;        
        //con.Intake_Approved_By__c = userInfo.getUserId();
        con.Intake_Date__c = System.Today();
        con.Intake_Case__c = newCaseInfo.id;
        con.RecordTypeId = utilIds.conClient;
        con.accountId = accClient.id;
        insert con;  
        
        
        test.startTest();  
        
        //create test
        Test__c drugTestForInsert = new Test__c();
        drugTestForInsert.Test_Date__c = System.Today();
        drugTestForInsert.Contact__c = con.Id;
        drugTestForInsert.RecordTypeId = utilIds.drugTestRecordType; 
        drugTestForInsert.PCP__c = 2;
        insert drugTestForInsert; 
        
        // verify orientation appt, which should intake client, create and close initial drug test task,
        // and then create a next drug test task  
        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        insert thisEvent;           
        
        // 9/28/14 unfortunately this can no longer be tested because this task is created in a future method
        /*
        Task closedTask = [select id, isClosed from Task where whoId = :con.Id
                           and RecordTypeId = :utilIds.initialDrugTestTask];
                           
        Task openTask = [select id, isClosed from Task where whoId = :con.Id
                         and RecordTypeId = :utilIds.nextDrugTestTask ];
                         
        system.assertNotEquals(closedTask, null);
        system.assertNotEquals(openTask, null); */
        
        test.stopTest();                             
            
    }
    
}