@isTest (SeeAllData=True)
private class administrativeActionMethodsUnitTests {
    
    static utilityIds utilIds = new utilityIds();
    
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    
    private static void establishCoreData(String strClientStatus) {
        
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
        con.Case_Coordinator__c = UserInfo.getUserId();
        con.accountId = accClient.id;       
        
        insert con;
        

        Event thisEvent = new Event();
        thisEvent.RecordTypeId = utilIds.orientationAppointment;
        thisEvent.whoId = con.Id;
        thisEvent.DurationInMinutes = 60;
        thisEvent.ActivityDate = System.Today();
        thisEvent.ActivityDateTime = System.now();
        thisEvent.Verification_Status__c = 'Attended';
        insert thisEvent;                                  
        
        if(strClientStatus == 'Exited') {
            
            doExitNotification();       
        }
        
    }
    
    private static void doExitNotification() {
            
        Administrative_Actions__c aaExit = new Administrative_Actions__c();
        aaExit.Client__c = con.id;
        aaExit.RecordTypeId = utilIds.aaExitNotification;
        aaExit.Action_Date__c = System.Today();
        aaExit.Exit_Type__c = '(S) Successful Exit/ Graduation';
        aaExit.Exit_Reason__c = 'Successfully completed program, without modification';
        
        insert aaExit;
        
        aaExit.Approved__c = 'Yes';
        aaExit.Approved_By__c = UserInfo.getUserId();
        
        update aaExit;
        
        //delete aaExit;
        
    }
    
    private static void doExitNotificationUnsuccessful() {
            
        Administrative_Actions__c aaExit = new Administrative_Actions__c();
        aaExit.Client__c = con.id;
        aaExit.RecordTypeId = utilIds.aaExitNotification;
        aaExit.Action_Date__c = System.Today();
        aaExit.Exit_Type__c = '(U) Unsuccessful Exit/ Discharge';
        aaExit.Exit_Reason__c = 'Never reported for orientation';
        
        insert aaExit;
        
        aaExit.Approved__c = 'Yes';
        aaExit.Approved_By__c = UserInfo.getUserId();
        
        update aaExit;
        
    }

    private static Task createExitDrugTask() {
        
        Task tsk = new Task();
        tsk.whoId = con.id;
        tsk.ActivityDate = System.Today().addDays(-1);
        tsk.RecordTypeId = utilIds.exitDrugTestTask;
        tsk.SkipRestrictions__c = true;
        tsk.Automatically_Generated__c = true;
        insert tsk;
        
        return tsk;
        
    }

    ///////////////////////////////////
    // Test Methods
    ///////////////////////////////////
    
    static testMethod void testAdministrativeActionUnsuccessfulExit() {
        
        // Setup core data
        establishCoreData('Active');
        
        test.startTest();
        
        // Do Exit Notification
        doExitNotificationUnsuccessful();
        
        test.stopTest();
        
    }




    static testMethod void testAdministrativeActionReintake() {
        
        // Setup core data
        establishCoreData('Exited');
        
        test.startTest();       
        // Do Reinstake Notification
        Administrative_Actions__c aaReintake = new Administrative_Actions__c();
        aaReintake.Client__c = con.id;
        aaReintake.RecordTypeId = utilIds.aaReintake;
        aaReintake.Action_Date__c = System.Today();
        aaReintake.New_Projected_Exit_Date__c = System.Today().addDays(15);
        insert aaReintake;

        
        aaReintake.Approved__c = 'Yes';
        update aaReintake;
  
        Test.stopTest();        
    }


    static testMethod void testAdministrativeActionReinstatement() {
        
        // Setup core data
        establishCoreData('Exited');
        
        test.startTest();
        
        // Do Re-instatement Notification
        Administrative_Actions__c aaExt = new Administrative_Actions__c();
        aaExt.Client__c = con.id;
        aaExt.RecordTypeId = utilIds.aaReinstatement;
        aaExt.Action_Date__c = system.today();
        aaExt.First_Date_Back_in_the_Program__c  = System.Today();
        aaExt.New_Projected_Exit_Date__c = System.Today().addDays(15);
        aaExt.Approved__c = 'No';
        aaExt.Exit_Type__c = '(S) Successful Exit/ Graduation';
        insert aaExt;
  
        aaExt.Approved__c = 'Yes';         
        update aaExt;
  
        Test.stopTest();
        
    }
    
    static testMethod void testAdministrativeActionExtension() {
        
        // Setup core data
        establishCoreData('Active');
        
        //before exit
        Task exitDrugTestTask = new Task();
        exitDrugTestTask.whoId = con.id;
        exitDrugTestTask.ActivityDate = System.Today().addDays(-5);
        exitDrugTestTask.RecordTypeId = utilIds.exitDrugTestTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated 
        exitDrugTestTask.Automatically_Generated__c = true;
        exitDrugTestTask.Status = 'Done on Time';
        exitDrugTestTask.Closing_Date__c = System.Today().addDays(-5);
        
        //after exit
        Task exitDrugTestTask2 = new Task();
        exitDrugTestTask2.whoId = con.id;
        exitDrugTestTask2.ActivityDate = System.Today().addDays(16);
        exitDrugTestTask2.RecordTypeId = utilIds.exitDrugTestTask;
        //this line added by MB 9/17/12 because this task can no longer be manually generated 
        exitDrugTestTask2.Automatically_Generated__c = true;
        exitDrugTestTask2.Status = 'Done on Time';
        exitDrugTestTask2.Closing_Date__c = System.Today().addDays(16);
        insert new Task[] {exitDrugTestTask, exitDrugTestTask2};  
        
        //delete all enrollments to avoid going over sql limits when classEnrollment is run many times
        List<Enrollment__c> lstEnrollments = [select id from enrollment__c where client__c = :con.id];     
        delete lstEnrollments;
        
        Schedule__c sched = [select id, class__c from Schedule__c where recordtypeid != :utilIds.scheduleSingle
                             and Dummy_Schedule__c != true order by end_date__c desc limit 1 ];
                                          
        
        // Create enrollment
        Enrollment__c enr = new Enrollment__c();
        enr.Client__c = con.id;    
        enr.Class__c = sched.class__c;
        enr.Client_Class_Status_Field__c = 'Active';
        insert enr;
                                
        test.startTest();
                
        // Extension
        Administrative_Actions__c aaExt = new Administrative_Actions__c();
        aaExt.Client__c = con.id;
        aaExt.RecordTypeId = utilIds.aaExtension;
        aaExt.Action_Date__c = system.today();
        aaExt.New_Projected_Exit_Date__c = System.Today().addDays(180);
        aaExt.Approved__c = 'No';
        insert aaExt;
  
        aaExt.Approved__c = 'Yes';
        
    //    update aaExt;
        
        test.Stoptest();
        
        Contact c = [select id, Current_Projected_Exit_Date__c from Contact where id = :aaExt.Client__c limit 1];
        
        system.assertEquals(c.Current_Projected_Exit_Date__c, aaExt.New_Projected_Exit_Date__c);
    }
}