@isTest (SeeAllData=true)

private class jobUpdateNumberofDaysinCycle_UnitTest {

    // test manual method (scheduled method tested in scheduler)
    static testmethod void test() {
        
       utilityIds utilIds = new utilityIds();
        
        //clients- accounts
        Account accClient1 = new Account(Name = 'Test Contact 1',
            RecordTypeId = utilIds.accClient);   

        Account accClient2 = new Account(Name = 'Test Contact 2',
            RecordTypeId = utilIds.accClient);             
        
        //dml
        insert new sObject[]{accClient1, accClient2};            
        
        //clients- contacts
        Contact c1 = new Contact(LastName = 'Test Contact 1', recordtypeid = utilIds.conChoices, 
            AccountId = accClient1.id, Screening_Stage__c = 'Screening Complete'); 
            
        Contact c2 = new Contact(LastName = 'Test Contact 2', recordtypeid = utilIds.conChoices, 
            AccountId = accClient2.id, Screening_Stage__c = 'Screening Complete');                
        
        //dml
        insert new sObject[]{c1, c2};                   
        
        //program cycles
        Program_Cycle__c c1pc1 = new Program_Cycle__c(Client__c = c1.id, Cycle_Type__c = 'Intake', 
            Start_Date__c = system.today().addDays(-135), RecordTypeId = utilIds.progCycleChoices);
                    
        Program_Cycle__c c2pc1 = new Program_Cycle__c(Client__c = c2.id, Cycle_Type__c = 'Intake', 
            Start_Date__c = system.today().addDays(-130), End_Date__c = system.today().addDays(-7), 
            Exit_Reason__c = 'Mandate Successfuly Completed', RecordTypeId = utilIds.progCycleChoices);  
            
        Program_Cycle__c c2pc2 = new Program_Cycle__c(Client__c = c2.id, Cycle_Type__c = 'Reinstatement', 
            Start_Date__c = system.today().addDays(-6), RecordTypeId = utilIds.progCycleChoices);                   
        
        //dml
        insert new sObject[]{c1pc1, c2pc1, c2pc2};    
        
        //tiers
        Tier__c c1pc1t1 = new Tier__c(Program_Cycle__c = c1pc1.id, 
            Reason_for_Tier_Change__c = 'Intake Tier', Tier__c = '1', 
            Start_Date__c = system.today().addDays(-135), End_Date__c = system.today().addDays(-133));
            
        Tier__c c1pc1t2 = new Tier__c(Program_Cycle__c = c1pc1.id, 
            Reason_for_Tier_Change__c = 'Judge', Tier__c = '1', 
            Start_Date__c = system.today().addDays(-132));              
            
        Tier__c c2pc1t1 = new Tier__c(Program_Cycle__c = c2pc1.id, 
            Reason_for_Tier_Change__c = 'Intake Tier', Tier__c = '2', 
            Start_Date__c = system.today().addDays(-130));  
            
        Tier__c c2pc2t1 = new Tier__c(Program_Cycle__c = c2pc2.id, 
            Reason_for_Tier_Change__c = 'Intake Tier', Tier__c = '2', 
            Start_Date__c = system.today().addDays(-6));                                
            
        //dml
        insert new sObject[]{c1pc1t1, c1pc1t2, c2pc1t1, c2pc2t1};            
        
        //detained dates
        Detained_Dates__c c1pc1d1 = new Detained_Dates__c(Contact_Detained_Dates_Lookup__c = c1.id,
            Detained_Date__c = system.today().addDays(-98), Date_Released__c = system.today().addDays(-95));        
        
        Detained_Dates__c c1pc1d2 = new Detained_Dates__c(Contact_Detained_Dates_Lookup__c = c1.id,
            Detained_Date__c = system.today().addDays(-1), Date_Released__c = system.today());                          
            
        Detained_Dates__c c2pc1d1 = new Detained_Dates__c(Contact_Detained_Dates_Lookup__c = c2.id,
            Detained_Date__c = system.today().addDays(-90), Date_Released__c = system.today().addDays(-70));                
        
        Detained_Dates__c c2pc2d1 = new Detained_Dates__c(Contact_Detained_Dates_Lookup__c = c2.id,
            Detained_Date__c = system.today().addDays(-2));     
            
        //dml
        insert new sObject[]{c1pc1d1, c1pc1d2, c2pc1d1, c2pc2d1};           
        
        Test.startTest();

        jobUpdateNumberofDaysinCycle j = new jobUpdateNumberofDaysinCycle();
        j.UpdateDayCounts(50, null, null);
        j.UpdateDayCounts(null, System.Today().addDays(-1), System.Today().addDays(1));
    
        //get updated day count
        Program_Cycle__c c1pc1result = [select id, Number_Of_Days_in_Program_Cycle__c from Program_Cycle__c
            where id = :c1pc1.id]; 
            
        Program_Cycle__c c2pc1result = [select id, Number_Of_Days_in_Program_Cycle__c from Program_Cycle__c
            where id = :c2pc1.id];  
            
        Program_Cycle__c c2pc2result = [select id, Number_Of_Days_in_Program_Cycle__c from Program_Cycle__c
            where id = :c2pc2.id];          
            
        //get updated tiers
        Tier__c c1pc1t2result = [select id, End_Date__c from Tier__c where id = :c1pc1t2.id];       
        
        Tier__c c2pc1t1result = [select id, End_Date__c from Tier__c where id = :c2pc1t1.id];   
        
        Tier__c c2pc2t1result = [select id, End_Date__c from Tier__c where id = :c2pc2t1.id];                               
        
        //check days in cycle values    
        //system.assertEquals(c1pc1result.Number_of_Days_in_Program_Cycle__c,  130);
        system.debug('c1pc1result.Number_of_Days_in_Program_Cycle__c' +  c1pc1result.Number_of_Days_in_Program_Cycle__c );  
        //system.assertEquals(c2pc1result.Number_of_Days_in_Program_Cycle__c,  103);  
        system.debug('c2pc1result.Number_of_Days_in_Program_Cycle__c' +  c2pc1result.Number_of_Days_in_Program_Cycle__c );          
        //system.assertEquals(c2pc2result.Number_of_Days_in_Program_Cycle__c,  4);    
         system.debug('c2pc2result.Number_of_Days_in_Program_Cycle__c' +  c1pc1result.Number_of_Days_in_Program_Cycle__c );                 
        
        //check that tiers closed correctly (if the cycle was past 120 days)    
        //system.assertEquals(c1pc1t2result.End_Date__c,  system.today().addDays(-12)); 
        system.debug('c1pc1t2result.End_Date__c: '+ c1pc1t2result.End_Date__c + '   '+system.today().addDays(-12));   
        //system.assertEquals(c2pc1t1result.End_Date__c,  null); 
        system.debug('c2pc1t1result.End_Date__c: '+ c2pc1t1result.End_Date__c );        
        //system.assertEquals(c2pc2t1result.End_Date__c,  null);
        system.debug('c2pc2t1result.End_Date__c: '+ c2pc2t1result.End_Date__c );   
        Test.stopTest();
    }
}