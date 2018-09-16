@isTest (SeeAllData=true)
private class addChargesUnitTest {
    static Id cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
    static Account accCEP = new Account();
    static Account accClient = new Account();
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
  	static Case_Charges__c chgTest = new Case_Charges__c();
   	static ID chargeid;
 	static string  pcodeId;
 //  	static ID docketPassed ;
    static void createTestData() {
    User adminUser = [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];

        utilityIds utilIds = new utilityIds();
        
        // Stage Data
        
        accClient = new Account(Name='Unit Tester', RecordTypeId = utilIds.accClient);
        insert accClient;
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient.Id;
        newCaseInfo.RecordTypeId = utilIds.caseInfoSupremeCourt;
        newCaseInfo.Name = '2013TN456011';
        newCaseInfo.Borough__c = 'Bronx';
        newCaseInfo.supreme_court_period__c = 6;
         newCaseInfo.specialized_court__c = '';
          newCaseInfo.indictment__c = '';
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
  		
		chgTest.Docket_No__c = newCaseInfo.id;
 //    	chgTest.Type__c = 'Criminal Court Arraignment Charges';
  
       	for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit 1 ])
     	{
            pcodeId = lstcodes.id;
     	}
    }
     static testMethod void testArrestCharges()
    {   for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit1 ])
     	{
           chgTest.Charge__c = lstcodes.id;
     	}
     	chgTest.Docket_No__c = newCaseInfo.id;
     	
   	    chgTest.Type__c = 'Arrest Charges';
     	insert chgTest;  
       
        addChargesController chg = new addChargesController(); 
        test.startTest();
        chg.DocketPassed = newCaseInfo.id;
        chg.buildcharges();
 
        test.stopTest();  
       }
     static testMethod void testIndictmentCharges()
       {for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit1 ])
     	{
           chgTest.Charge__c = lstcodes.id;
     	}
     	chgTest.Docket_No__c = newCaseInfo.id;
     	
   	    chgTest.Type__c = 'Indictment Charges';
     	insert chgTest;  
       
        addChargesController chg = new addChargesController(); 
        test.startTest();
        chg.DocketPassed = newCaseInfo.id;
        chg.buildcharges();
        test.stopTest();  
       }
       static testMethod void testArraignmentCharges()
       {for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit1 ])
     	{
           chgTest.Charge__c = lstcodes.id;
     	}
     	chgTest.Docket_No__c = newCaseInfo.id;
     	
   	    chgTest.Type__c = 'Criminal Court Arraignment Charges';
     	insert chgTest;  
       
        addChargesController chg = new addChargesController(); 
        test.startTest();
        chg.DocketPassed = newCaseInfo.id;
        chg.buildcharges();
        test.stopTest();  
       }
       static testMethod void testPleaCharges()
       {for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit1 ])
     	{
           chgTest.Charge__c = lstcodes.id;
     	}
     	chgTest.Docket_No__c = newCaseInfo.id;
     	
   	    chgTest.Type__c = 'Plea/ Finding Charges';
     	insert chgTest;  
       
        addChargesController chg = new addChargesController(); 
        test.startTest();
        chg.DocketPassed = newCaseInfo.id;
        chg.buildcharges();
        test.stopTest();  
       }
       
           static testMethod void testFamilyCharges()
       {for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit1 ])
     	{
           chgTest.Charge__c = lstcodes.id;
     	}
     	chgTest.Docket_No__c = newCaseInfo.id;
     	
   	    chgTest.Type__c = 'Family Court Arraignment Charges';
     	insert chgTest;  
       
        addChargesController chg = new addChargesController(); 
        test.startTest();
        chg.DocketPassed = newCaseInfo.id;
        chg.buildcharges();
        test.stopTest();  
       }
       
        static testMethod void testSave()
        {
        	 addChargesController chg = new addChargesController(); 
            test.startTest();
            chg.DocketPassed = newCaseInfo.id;
            chg.chgType = 'Arrest Charges';
           for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit2 ])
     	   {
     	   	if (lstcodes.id != null)
              chg.chgString = lstcodes.Id;
     	  }


       //     chg.chgString = '110/160/10,105.10';
       //     chg.chgString = pcodeId;
        	//chg.selectedCode = '110/160/10....Test3';
            chg.saveSelectedCharges();
       		//chg.saveCharges();
            test.stopTest();  
        }  
        static testMethod void test1()
        {
       	 addChargesController chg = new addChargesController(); 
         test.startTest();
        for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit 1 ])
     	 {
            pcodeId = lstcodes.id;
     	 }
          List<SelectOption> Items = new List<SelectOption>();
          chg.chargeCode1 = pcodeId;
          Items = chg.CodesItems1;
          chg.CodesItems1 = Items;

          chg.chargeCode2 = pcodeId;
          Items = chg.CodesItems2;
          chg.CodesItems2 = Items;

          chg.chargeCode3 = pcodeId;
          Items = chg.CodesItems3;
          chg.CodesItems3 = Items;

          chg.chargeCode4 = pcodeId;
          Items = chg.CodesItems4;
          chg.CodesItems4 = Items;

          chg.chargeCode5 = pcodeId;
          Items = chg.CodesItems5;
          chg.CodesItems5 = Items;
  
          chg.chargeCode6 = pcodeId;
          Items = chg.CodesItems6;
          chg.CodesItems6 = Items;
        
          chg.chargeCode7 = pcodeId;
          Items = chg.CodesItems7;
          chg.CodesItems7 = Items;

          chg.chargeCode8 = pcodeId;
          Items = chg.CodesItems8;
          chg.CodesItems8 = Items;
          
          chg.chargeCode9 = pcodeId;
          Items = chg.CodesItems9;
          chg.CodesItems9 = Items;
          
          chg.chargeCode10= pcodeId;
          Items = chg.CodesItems10;
          chg.CodesItems10 = Items;
  
  
          chg.resetInfo();
        chg.doNothing();
              chg.closePopup();
        chg.showPopup();
        test.stopTest();
        }
        static testMethod void testDelete()
        {
          for (Penal_Code__c lstcodes : [select id from Penal_Code__c Limit1 ])
       	 {
           chgTest.Charge__c = lstcodes.id;
     	 }
     	   chgTest.Docket_No__c = newCaseInfo.id;
     	insert chgTest;  
        	
         addChargesController chg = new addChargesController(); 
         test.startTest();
            chg.id2delete = chgTest.Id;
         chg.deletecharge();
           test.stopTest();
        }
    
        
               static testMethod void testgeneral()
        {
          addChargesController chg = new addChargesController(); 
          createTestData();
          test.startTest();
       	  chg.docketPassed = newCaseInfo.id;
       	  chg.generalInfo();
         test.stopTest();
        }

    
}