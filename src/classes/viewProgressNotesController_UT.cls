@isTest(SeeAllData=true)
private class viewProgressNotesController_UT {
    static Progress_Note__c pn2 = new Progress_Note__c();
    static Progress_Note__c pn1 = new Progress_Note__c();
    static Program_Plan__c  prgPlan = new Program_Plan__c();
    static Case_Information__c Case1 =  new Case_Information__c();    
    static utilityIds utilIds = new utilityIds();
    static string contId;  
    static ID contRecType = Utility_ID__c.getValues('SRP Client').RecordType_Id__c;
    static Id  ppRecType  = Utility_ID__c.getValues('SRP Program Plan').RecordType_Id__c;
    static Id accRecType  = Utility_ID__c.getValues('Client').RecordType_Id__c;
    static void createEventsTestData() {
        
        Account a1 = new Account();
        a1.name = 'Thelonius Monk';
        a1.RecordTypeId = accRecType;
        a1.NYSID_Number__c = '64989923Q';
        a1.DOB__c = Date.newInstance(1970,1,1); 
        insert a1;  
 
        Contact c1 = new Contact();
        c1.FirstName = 'Thelonius';
        c1.LastName = 'Monk';
        c1.Client_Status__c = 'Active';
        c1.AccountID = a1.id;
        c1.RecordtypeId = contRecType;
        insert c1;
        contId = c1.id;
    
        Case1 = new Case_Information__c();
        case1.Client_Account__c =  a1.id;
        case1.RecordTypeId = utilIds.caseInfoSupremeCourt;
        case1.Name = '2014BG456011';
        case1.Indictment__c = '1235648794';
        case1.Borough__c = 'Bronx';
        insert case1; 
        Id caseid1 = case1.id;  
        
        Event evtCourtDate = new Event();
        evtCourtDate.RecordTypeId = utilIds.courtDate;
        evtCourtDate.WhoId = contId;
        evtCourtDate.StartDateTime = System.Today().addDays(20);
        evtCourtDate.Court_Report_Required__c = false;
        evtCourtDate.WhatId = caseid1;
        evtCourtDate.Area__c = 'Court Date';
        evtCourtDate.Outcome__c = 'Pending';
        evtCourtDate.Subject = 'Court Date';
        evtCourtDate.DurationInMinutes = 60;
        evtCourtDate.ActivityDate = Date.today();
        insert evtCourtDate;
                
   
    //    Program_Plan__c pp1 = [select id from Program_Plan__c where Client_Name__c = :contId];
        prgPlan = new Program_Plan__c();
        prgPlan.Client_Name__c = contId;
        prgPlan.RecordTypeId = ppRecType;
        insert prgPlan;
     
        List<Program_Plan__c> ppTest = [select id from Program_Plan__c where Client_Name__c = :contId ];
        
        ID ppId = ppTest[0].id;
        
        pn1 = new Progress_Note__c();
        pn1.Program_Plan__c = ppid;   
        pn1.Activity_Date__c = system.today() - 1;
        pn1.Date__c = system.today();
        pn1.Progress_Note__c = 'Better get it in your soul';
        pn1.Area__c = 'Case Coordination';
        pn1.RecordTypeId = utilIds.progressNoteCCCRS;
        insert pn1;
      
        pn2 = new Progress_Note__c();
       pn2.Program_Plan__c = ppid;   
        pn2.Date__c = system.today().addDays(-15);
       pn2.Activity_Date__c = system.today().addDays(-17);     
        pn2.Progress_Note__c = 'Five Spot Blues';
        pn2.Area__c = 'Case Coordination';
        pn2.RecordTypeId = utilIds.progressNoteCCPN;
                        
        insert pn2;
     
    }   
      static testMethod void testPage(){
      	createEventsTestData();
        PageReference pageRef = Page.viewProgressNotes;
        string cid = contId.substring(0,15);
        pageRef.getParameters().put('clientId',cid);
        Test.setCurrentPage(pageRef);
        viewProgressNotesController v = new viewProgressNotesController();          
       	test.startTest();
           
       v.noteValue = 'All';
       v.areaValue = 'All';
       v.shownotes();
        test.stopTest();
     /*   
        ApexPages.currentPage().getParameters().put('clientId',string.valueOf(c1.id).substring(0,15)); 
        ctrl = new viewProgressNotesController();
        system.assertEquals(ctrl.lstPN.size(), 2);
        
        ApexPages.currentPage().getParameters().put('clientId',string.valueOf(c2.id).substring(0,15)); 
        ctrl = new viewProgressNotesController();
        system.assertEquals(ctrl.lstPN.size(), 0);              
*/
    }
}