@isTest (seeAlldata = true)
private class reportQueryUnitTest 
{
    static Id accClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;

    static utilityIds utilIds = new utilityIds();
    static Case_Information__c newCaseInfo = new Case_Information__c();
    static Event evt1 = new Event();    
    static Event evt2 = new Event();    
    static Event evt3 = new Event(); 
    static Event eventTest = new Event();
    static Contact con1 = new Contact();
    static Contact newJudge = new Contact();
    static Case_Charges__c chgTest = new Case_Charges__c();
    static Program_Plan__c PPforInsert = new Program_Plan__c();
    static Penal_Code__c ppcode = new Penal_Code__c();
    static Account newAccountForInsert = new Account();
    static Account newAccountForJudge = new Account();
    static Address_Information__c addressTest = new Address_Information__c(); 
    static Id caseRecTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
    static Id EventRecTypeId = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
    static Id conCRT = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c; 
    static Id judge  =  Utility_ID__c.getValues('Judge').RecordType_Id__c; 
    static Id caseid,progid,accountid,casetype,clientid,docket; 
    static string clientString,Supervision,IntakeNeedsAssessment,courtRecType,pcid,username,caseString; 
    static void createTestData()
    {  
    	username = userInfo.getUserId(); userInfo.getUserId(); 
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
        newAccountForInsert = new Account();
        newAccountForInsert.name = 'Dusty Bottoms';
        newAccountForInsert.RecordTypeId = '012600000005Nk2AAE';
        newAccountForInsert.NYSID_Number__c = '90978021U';
        newAccountForInsert.DOB__c = Date.newInstance(1970,1,1);
        insert newAccountForInsert;
        accountid = newAccountForInsert.id; 
            
        newAccountForJudge = new Account();
        newAccountForJudge.name = 'Judge Dredd';
        newAccountForJudge.RecordTypeId = '012600000004yhRAAQ';
        insert newAccountForJudge;
        
        newJudge = new Contact();
        newJudge.AccountId = newAccountForJudge.id;            
        newJudge.FirstName = 'judgeFirst';
        newJudge.lastName = 'JudgeLast';
        newJudge.RecordTypeId = '012600000004zCFAAY'; 
        insert newJudge;            
            
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = newAccountforInsert.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;   
        newCaseInfo.Name = '2011BV144590';
        newCaseInfo.Borough__c = 'Bronx';
        newCaseInfo.judge__c = newjudge.id;
        insert newCaseInfo;  
        caseid = newCaseInfo.id;
    //    docket = newCaseInfo.Name;       
                  
         
     
        con1 = new Contact();
        con1.FirstName = 'Dusty';
        con1.lastName = 'Bottoms';
        con1.Client_Status__c = 'Active';  
        con1.Referral_Date__c = date.today().addDays(-20);
        con1.Current_Intake_Date__c = date.today().addDays(-20);
        con1.Intake_Date__c = date.today().addDays(-20);
        con1.RecordTypeId = utilIds.conClient;
        con1.Reporting_Borough__c = 'Brooklyn';   
        con1.Intake_Approved_By__c = userInfo.getUserId();  
        con1.Interview_Outcome__c = 'CEP Accepts';
        con1.AccountId = newAccountForInsert.id;
        con1.Intake_Case__c = caseString;
        con1.RecordTypeId = accClient; 
        insert con1;
        clientid = con1.id;
        pcid = con1.P_C_ID__c;
        clientString = con1.id;
        ppcode = new Penal_Code__c();
        ppcode.name = '325.25';
        ppcode.Numeric_Charge_Value__c = 325.25;
        ppcode.Level__c = 'F';
        ppcode.Degree__c = '1';
        ppcode.class__c = '1';
        insert ppcode;
        
        PPforInsert = new Program_Plan__c();
        PPforInsert.client_name__c = con1.id; 
        insert PPforInsert;        
        progid = PPforInsert.id;
        
        chgTest = new Case_Charges__c();
        chgTest.Docket_No__c = newCaseInfo.id;
        chgTest.Charge__c = ppcode.id;
        chgTest.Type__c = 'Criminal Court Arraignment Charges';
        insert chgTest;
 
 
        evt1 = new Event();
        evt1.ActivityDateTime = System.Now().addHours(-48);
        evt1.ActivityDate = date.today().addDays(-2);
        evt1.DurationInMinutes = 30;
        evt1.WhoId = clientid;
        evt1.WhatId = caseid;
        evt1.Subject = 'Call';
        evt1.DurationInMinutes = 30;
        evt1.Verification_Status__c = 'Unexused';
        evt1.RecordTypeId = Supervision;        
        evt1.P_C_ID__c = pcid;
        evt1.Verified_By__c = userName; 
        evt1.Verification_Date__c = date.today();
        insert evt1;
 
        evt2 = new Event();
        evt2.ActivityDateTime = System.Now().addHours(48);
        evt2.ActivityDate = date.today().addDays(2);
        evt2.DurationInMinutes = 30;
        evt2.WhoId = clientid;
        evt2.WhatId = caseid;
        evt2.Subject = 'Court Date';
        evt2.DurationInMinutes = 30;
        evt2.Verification_Status__c = 'Unexused';
        evt2.RecordTypeId = courtRecType;        
        evt2.P_C_ID__c = pcid;
        evt2.Verified_By__c = userName; 
        evt2.Verification_Date__c = date.today();
        insert evt2;
    }
   
    static testMethod void testReportQuery()
    {
        createTestData();
        reportQuery rq = new reportQuery();
        test.startTest();
        Map<Id, Contact> mapContact = rq.contactQuery(con1.id);
        Map<Id, Contact> mapContact1 = rq.contactQueryByStringId(clientString);
        Map<Id, Contact> mapCaseContact = rq.contactQueryContCase(con1.id,con1.Intake_Case__c);
        Map<Id, Account> mapCasecount = rq.accountQuery(newAccountForInsert.id);
        List<Case_Information__c> lstCase = rq.caseInfoQuery(con1.id);
     //   List<Event> lstEvent = rq.eventQuery(caseid);
       Map<id,Case_Information__c> mapCase = rq.caseQuery(caseid);
        Map<id,Program_Plan__c> mapProg = rq.PP_Query(progId);
        List<Address_Information__c> lstAddress = rq.addressQuery(con1.id);
        List<Contact> lstContactByAct = rq.listContactByAccountId(newAccountForInsert.id);
        string chg = rq.Charges(caseid, 'Criminal Court Arraignment Charges');
        string chgDescr = rq.ChargesDescription(caseid, 'Criminal Court Arraignment Charges');
        string m = rq.mostResentChargesType(caseid);
        string caseJudge = rq.mapNames(newCaseInfo.judge__c);
        string att = rq.attInfo(newCaseInfo.id);
  /*
        date d = date.today();
         Map<Date, ID> mapHolidays = new Map<Date, ID>();
         List<Holidays__c>lstHolidays = [SELECT Id, Date__c FROM Holidays__c];
        for(Holidays__c h: lstHolidays) {
            mapHolidays.put(h.Date__c, h.Id);}
            date dt = rq.countDueDate_1(mapHolidays,d, 10);
            date dt1 = rq.countDueDateBefore_1(mapHolidays,d, 10);
  
            date d2 = rq.countDueDateBefore(d, 10);
            date dt3 = rq.countDueDate(d, 10);

            string appSubject = 'Court Date';
            date dStart = date.today().addDays(-3);
            date dEnd = date.today().addDays(10);
            List<Event> e = rq.appointments(dstart, dend, clientid, appSubject);
            List<Case_Information__c> ci = rq.caseInfoQueryByCaseId(accountId, caseid);  
            string casename = rq.caseName(newCaseInfo.Id);             
  
          ID userId = userInfo.getUserId();
        rq.userNamesById(userId);
        string cId = string.ValueOf(userId);
        rq.userNames(userId);
        rq.findUserName(userId);
        rq.contactQueryByStringId(clientId);    
        */        
        test.stopTest();
     }
     
   static testMethod void testReportQuery_1()
    {
        createTestData();
        reportQuery rq = new reportQuery();
        test.startTest();
        List<Event> lstEvent = rq.eventQuery(caseid);
        ID userId = userInfo.getUserId();
        rq.userNamesById(userId);
        string cId = string.ValueOf(userId);
        rq.userNames(userId);
        rq.findUserName(userId);
        rq.contactQueryByStringId(clientId);   
  date d = date.today();
         Map<Date, ID> mapHolidays = new Map<Date, ID>();
         List<Holidays__c>lstHolidays = [SELECT Id, Date__c FROM Holidays__c];
        for(Holidays__c h: lstHolidays) {
            mapHolidays.put(h.Date__c, h.Id);}
            date dt = rq.countDueDate_1(mapHolidays,d, 10);
            date dt1 = rq.countDueDateBefore_1(mapHolidays,d, 10);
  
            date d2 = rq.countDueDateBefore(d, 10);
            date dt3 = rq.countDueDate(d, 10);

            string appSubject = 'Court Date';
            date dStart = date.today().addDays(-3);
            date dEnd = date.today().addDays(10);
            List<Event> e = rq.appointments(dstart, dend, clientid, appSubject);
            List<Case_Information__c> ci = rq.caseInfoQueryByCaseId(accountId, caseid);  
            string casename = rq.caseName(newCaseInfo.Id);                  
        test.stopTest();
     }

     static testMethod void testCharges()
     {  
         reportQuery rq = new reportQuery();
         test.startTest();
         chgTest.Docket_No__c = newCaseInfo.id; 
         Id pcodeId;
         for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit 1 ])
         {
             pcodeId = lstcodes.id;
         }
         string cname = rq.mapCodes(pcodeId);
         test.stopTest();
     } 

     static testMethod void testProgInfo()
     {
         reportQuery rq = new reportQuery();
         test.startTest();
         progId = rq.progInfo(newCaseInfo.Id);
         string checkName = 'Docket';
         string checkValue = '2011BV144590';
         boolean retcheck = rq.checkformat(checkName,checkValue);
         string dow = rq.dayOfWeek(date.today());
         List<Case_Relationship__c> cr = rq.findClient(checkName,checkValue,'','');
         test.stopTest();
     }
}