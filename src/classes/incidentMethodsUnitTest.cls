@isTest (SeeAllData=true)
private class incidentMethodsUnitTest {
	
    static utilityIds utilIds = new utilityIds();
    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();	

    static testMethod void testReportandParticipantCreate() {
        
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
        
        test.startTest();
        
        Program_Plan__c pp = [select id, Client_Name__r.Id, Client_Name__r.Name from Program_Plan__c 
        					  where Client_Name__c = :con.id];
        
        Incident_Report__c ir = new Incident_Report__c();
        ir.Name = 'Test Report';
        ir.Incident_Date__c = system.Today();
        ir.Degree_of_Harm_Caused__c = 'No Harm';
        ir.Risk_of_Future_Harm__c = 'Moderate';
        ir.Incident_Category__c = 'Harassment';
        ir.Participants_Involved__c = pp.Client_Name__r.Name;
        ir.Incident_Description__c = 'Testing';
        
        insert ir;
        
        Incident_Participation__c ip = new Incident_Participation__c();
        ip.Incident_Report__c = ir.Id;
        ip.Client__c = pp.Client_Name__r.Id;
        ip.Parent_Called__c = true;
        ip.Statement__c = 'Testing';
        
        insert ip;
        
        list<Task> lstTasks = [select id, isClosed from Task where whoId = :pp.Client_Name__r.Id
        					   and RecordTypeId = :utilIds.incidentReportNoteTask and Task_Source__c = :ip.Id];
        
        //was the task created
        system.assert(lstTasks.size() == 1);
        
        Progress_Note__c pn = new Progress_Note__c();
        pn.Program_Plan__c = pp.Id;
        pn.Incident_Participant__c = ip.id;
        pn.RecordTypeId = utilIds.progressNoteIncidentReport;
        pn.Progress_Note__c = 'Test';
        
        insert pn;
        
        lstTasks = [select id from Task where whoId = :pp.Client_Name__r.id 
        					   and RecordTypeId = :utilIds.incidentReportNoteTask 
        					   and Task_Source__c = :ip.Id and isClosed = true];
        					   
        //check that task was closed
        system.assert(lstTasks.size() == 1);
        
        test.stopTest();					   
    }
}