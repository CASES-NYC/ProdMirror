@isTest(SeeAllData=true)
private class programCycleTierMethods_UnitTest {


    static testMethod void tierCycleRollupValues() {
        
        utilityIds utilIds = new utilityIds();
        
        //clients- accounts
        Account accClient1 = new Account(Name = 'Test Contact 1', RecordTypeId = utilIds.accClient);   
        
        //dml
        insert new sObject[]{accClient1};      
        
        //docket
        Case_Information__c a1ci1 = new Case_Information__c(Client_Account__c = accClient1.Id, Name = 'D-47596/13');
        insert new sObject[]{a1ci1};      
        
        //clients- contacts
        Contact c1 = new Contact(LastName = 'Test Contact 1', recordtypeid = utilIds.conBXChoices, 
        Screening_Stage__c = 'Intake Complete', AccountId = accClient1.id, Intake_Case__c = a1ci1.Id);      
        
        //dml
        insert new sObject[]{c1};                   
        
        //program cycles
        Program_Cycle__c c1pc1 = new Program_Cycle__c(Client__c = c1.id, Cycle_Type__c = 'Intake', 
        Start_Date__c = system.today().addDays(-30), End_Date__c = system.today().addDays(-15), 
        Exit_Type__c = 'Unsuccessful Exit', RecordTypeId = utilIds.progCycleChoices);
        
        Program_Cycle__c c1pc2 = new Program_Cycle__c(Client__c = c1.id, Cycle_Type__c = 'Reinstatement', 
        Start_Date__c = system.today().addDays(-6), RecordTypeId = utilIds.progCycleChoices);   
        
        //dml
        insert new sObject[]{c1pc1, c1pc2};     
        
        //tiers
        Tier__c c1pc1t1 = new Tier__c(Program_Cycle__c = c1pc1.id, Tier__c = '1', Reason_for_Tier_Change__c = 'Intake Tier',
        Start_Date__c = system.today().addDays(-30), End_Date__c = system.today().addDays(-15));
        
        Tier__c c1pc2t1 = new Tier__c(Program_Cycle__c = c1pc2.id, Tier__c = '1', Reason_for_Tier_Change__c = 'Intake Tier',
        Start_Date__c = system.today().addDays(-6), End_Date__c = system.today().addDays(-4));
        
        Tier__c c1pc2t2 = new Tier__c(Program_Cycle__c = c1pc2.id, Tier__c = '2', Reason_for_Tier_Change__c = 'Program',
        Start_Date__c = system.today().addDays(-3));        
        
        //dml
        insert new sObject[]{c1pc1t1, c1pc2t1, c1pc2t2};
        
        //requery to get new values. query contact because the values will only appear correctly in roll-up fields
        // if most recent tier and most recent program cycle are properly set.
        map<Id, Contact> conResults = new map<Id, Contact>([select id, Current_Tier_Formula__c, 
        Intake_Date__c, Current_Intake_Date__c, Current_Exit_Date__c, 
        Number_of_Days_in_Program__c, Client_Status__c from contact where id = :c1.id]);
        
        //test contact page update
        system.assertEquals(conResults.get(c1.id).Current_Tier_Formula__c, '2');
        system.assertEquals(conResults.get(c1.id).Current_Intake_Date__c, system.today().addDays(-6));
        system.assertEquals(conResults.get(c1.id).Current_Exit_Date__c, null);
        system.assertEquals(conResults.get(c1.id).Client_Status__c, 'Active');

        //update c1pc1t1 values and delete other tiers/cycles
        
        delete new sObject[]{c1pc2};
        
        c1pc1t1.Tier__c = '2';
        update c1pc1t1;
        
        //requery
        map<Id, Contact> conResults2 = new map<Id, Contact>([select id, Current_Tier_Formula__c, 
        Intake_Date__c, Current_Intake_Date__c, Current_Exit_Date__c, 
        Number_of_Days_in_Program__c, Client_Status__c from contact where id = :c1.id]);        
        
        //test contact updates
        system.assertEquals(conResults2.get(c1.id).Current_Tier_Formula__c, '2');
        system.assertEquals(conResults2.get(c1.id).Current_Intake_Date__c, system.today().addDays(-30));
        system.assertEquals(conResults2.get(c1.id).Current_Exit_Date__c, system.today().addDays(-15));
        system.assertEquals(conResults2.get(c1.id).Client_Status__c, 'Exited');
        
        //test that child tiers of c1pc2 were deleted
        list<Tier__c> lstDeletedTiers = [select id from Tier__c where id = :c1pc2t1.id or id = :c1pc2t2.id];
        
        system.assertEquals(lstDeletedTiers.size(), 0);     
        
        
        //delete last program cycle, null out fields on contact
        delete c1pc1;
        
        //requery
        map<Id, Contact> conResults3 = new map<Id, Contact>([select id, Current_Tier_Formula__c, 
        Current_Intake_Date__c, Current_Exit_Date__c, 
        Number_of_Days_in_Program__c, Client_Status__c from contact where id = :c1.id]);        
        
        //test contact updates
        //9/17/13 MB: clearing all cycles (setting status to never enrolled) 
        //is only done via flow, where these fields are set manually
        /*system.assertEquals(conResults3.get(c1.id).Current_Tier_Formula__c, null);
        system.assertEquals(conResults3.get(c1.id).Current_Intake_Date__c, null);
        system.assertEquals(conResults3.get(c1.id).Current_Exit_Date__c, null);*/  
    }

}