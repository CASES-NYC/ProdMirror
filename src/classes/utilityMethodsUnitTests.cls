@isTest(seeAllData=true)
private class utilityMethodsUnitTests {
     
    static utilityMethods utilMethods = new utilityMethods();
    static utilityIds utilIds = new utilityIds();
    
    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    
    private static void init() {
        
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
        insert thisEvent; 
    }   
    
    static testMethod void testUtilities() {
               
        Date dteNextWorkingDay = utilMethods.getNextWorkingDayfromDate(system.Today());
        utilMethods.clientCalendarStartDate(System.Today());
        utilMethods.clientCalendarEndDate(System.Today());
        utilMethods.blankToNull('');
        utilMethods.blankToNull(null);   
        
    }
    

    static testMethod void testCCCRSNotes() {   
        
        init();  
        
        test.startTest();
        
        //////////////////////////////////////////
        // Case Coordinator Court Report Summary
        //////////////////////////////////////////
        
        // Create CC CRS Note Task - Inactive Client, no court date (FAIL)
        utilMethods.createCCCourtReportNoteTask(con, null);
        
        utilMethods.createCCCourtReportNoteTask(con, null);
        
        // Create CC CRS Note Task - Active Client, with court date, no report needed (FAIL)
        Event evtCourtDate = new Event();
        evtCourtDate.RecordTypeId = utilIds.courtDate;
        evtCourtDate.WhoId = con.Id;
        evtCourtDate.StartDateTime = System.Today().addDays(20);
        evtCourtDate.Court_Report_Required__c = false;
        evtCourtDate.WhatId = newCaseInfo.Id;
        evtCourtDate.Area__c = 'Court Date';
        evtCourtDate.Outcome__c = 'Pending';
        evtCourtDate.Subject = 'Court Date';
        evtCourtDate.DurationInMinutes = 60;
        evtCourtDate.ActivityDate = Date.today();
        insert evtCourtDate;
        
        utilMethods.createCCCourtReportNoteTask(con, null);
        utilMethods.createCCCourtReportNoteTask(con, evtCourtDate);
        
        // Create CC CRS Note Task - Active Client, with court date, report required (PASS)
        evtCourtDate.Court_Report_Required__c = true;
        evtCourtDate.Report_Type__c = 'Progress';
        update evtCourtDate;
        
        evtCourtDate.Outcome__c = 'Entered In Error';
        update evtCourtDate;
        
        
        test.stopTest();
        
        
    }

static testMethod void testCCProgressNotes() {  
        
        init();
        
        Program_Plan__c ppTest = [select id from Program_Plan__c where Client_Name__c = :con.id];
        
        //////////////////////////////////////////
        // Begin Test Coverage
        //////////////////////////////////////////
        test.startTest();
        
        //////////////////////////////////////////
        // Case Coordinator - Progress Note
        //////////////////////////////////////////
        
        // Create CCPN - cannot have a CCPN too close to a Court Date
        Event evtCourtDate2 = new Event();
        evtCourtDate2.RecordTypeId = utilIds.courtDate;
        evtCourtDate2.WhoId = con.Id;
        evtCourtDate2.StartDateTime = System.Today().addDays(7);
        evtCourtDate2.Court_Report_Required__c = false;
        evtCourtDate2.WhatId = newCaseInfo.Id;
        evtCourtDate2.Area__c = 'Court Date';
        evtCourtDate2.Outcome__c = 'Pending';
        evtCourtDate2.Subject = 'Court Date';
        evtCourtDate2.DurationInMinutes = 60;
        evtCourtDate2.ActivityDate = Date.today();
        insert evtCourtDate2;
        
        for(Task t : [SELECT Id, RecordTypeId, ActivityDate FROM Task WHERE WhoId = :con.Id AND RecordTypeId = :utilIds.ccCRSNoteTask]) {
            utilMethods.createCCProgressNoteTask(con, t, System.Today());
        }
        
        // Create CCPN - clean insert
        //delete evtCourtDate2;
        
        Progress_Note__c pnCCCRS1 = new Progress_Note__c();
        pnCCCRS1.RecordTypeId = utilIds.progressNoteCCCRS;
        pnCCCRS1.Area__c = 'Case Coordination';
        pnCCCRS1.Date__c = System.Today().addDays(-2);
        pnCCCRS1.Program_Plan__c = ppTest.Id;
        pnCCCRS1.Progress_Note__c = 'This is a test Progress Note.  The testing gods are happy, we can all go to sleep now.';
        system.debug(LoggingLevel.ERROR, 'about to insert pnCCCRS1: RECORD INFO: ' + pnCCCRS1);
        insert pnCCCRS1;
        
        Progress_Note__c pnCCPN1 = new Progress_Note__c();
        pnCCPN1.RecordTypeId = utilIds.progressNoteCCPN;
        pnCCPN1.Area__c = 'Case Coordination';
        pnCCPN1.Date__c = System.Today();
        pnCCPN1.Program_Plan__c = ppTest.Id;
        pnCCPN1.Progress_Note__c = 'This is a test Progress Note.  The testing gods are happy, we can all go to sleep now.';
        insert pnCCPN1;
        
        Progress_Note__c pnPSPN = new Progress_Note__c();
        pnPSPN.RecordTypeId = utilIds.progressNotePSPN;
        pnPSPN.Area__c = 'Case Coordination';
        pnPSPN.Date__c = System.Today();
        pnPSPN.Program_Plan__c = ppTest.Id;
        pnPSPN.Progress_Note__c = 'This is a test Progress Note.  The testing gods are happy, we can all go to sleep now.';
        system.debug('\n\n******INFO: creating PSPN: \n' + pnPSPN + '\n');
        insert pnPSPN;
        
        
        Task tskCCPNInitial = utilMethods.createCCProgressNoteTask(con, null, System.Today());
        
        System.Debug('\n\n\n tskCCPNInitial = ' + tskCCPNInitial + '\n\n\n');
        
        //insert tskCCPNInitial;
        
        // Create CCPN - cannot have more than one CCPN within 
        utilMethods.createCCProgressNoteTask(con, null, System.Today());
        
        
        test.stopTest();
        
        
    }   
    
}