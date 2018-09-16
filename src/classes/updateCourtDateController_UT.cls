@isTest(SeeAllData=true)
private class updateCourtDateController_UT {

    static utilityIds utilIds = new utilityIds();
    
    static testMethod void testController() {
        
        Account a = new Account();
        a.name = 'Thelonius Monk';
        a.RecordTypeId = utilIds.accClient;
        a.NYSID_Number__c = '04989929O';
        a.DOB__c = Date.newInstance(1970,1,1);     
        
        insert a;   
        
        Case_Information__c ci = new Case_Information__c();
        ci.Client_Account__c = a.id;
        ci.Name = '2014BH122036';
        ci.RecordTypeId = utilIds.caseInfoCriminalCourt;
        
        insert ci;                    

        Contact c = new Contact();
        c.FirstName = 'Thelonius';
        c.LastName = 'Monk';
        c.Client_Status__c = 'Incomplete Screening';
        c.AccountID = a.id;
        c.RecordtypeId = utilIds.conCRT;
        c.Intake_Case__c = ci.Id;
        
        insert c;
        
        Event cd = new Event();
        cd.whoId = c.id;
        cd.Subject = 'Court Date';
        cd.RecordTypeId = utilIds.courtDate;
        cd.WhatId = ci.id;  
        cd.DurationInMinutes = 60; 
        cd.ActivityDate = system.today().addDays(-1);       
        cd.ActivityDateTime = 
            DateTime.newInstance(cd.ActivityDate, Time.newInstance(12,0,0,0));
            
        insert cd;  
        
        PageReference pageRef = Page.updateCourtDate;
        Test.setCurrentPage(pageRef);
        updateCourtDateController ctrl = new updateCourtDateController();
        ctrl.doNothing();
        ctrl.goPortal();                   
        
        ApexPages.currentPage().getParameters().put('courtdate',cd.id);
        ctrl = new updateCourtDateController();
        ctrl.nextCourtDate.ActivityDate = system.today().addDays(5);
        ctrl.updateCourtDate();

    }
}