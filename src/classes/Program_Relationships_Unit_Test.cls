@isTest(SeeAllData=true)
public class Program_Relationships_Unit_Test {

    static testMethod void testProgRelUpdate() {
        
        utilityIds utilIds = new utilityIds();
        
        //treatment orgs
        Account accReferralOrg1 = new Account(Name = 'Treatment Agency Test 1');
        
        Account accReferralOrg2 = new Account(Name = 'Treatment Agency Test 2');    
        
        //dml
        insert new sObject[]{accReferralOrg1, accReferralOrg2};
        
        //clients- accounts
        Account accClient1 = new Account(Name = 'Test Contact 1',  
        RecordTypeId = utilIds.accClient);
                
        Account accClient2 = new Account(Name = 'Test Contact 2',
        RecordTypeId = utilIds.accClient);   
        
        //dml
        insert new sObject[]{accClient1, accClient2};            
        
        //clients- contacts
        Contact c1 = new Contact(LastName = 'Test Contact 1', recordtypeid = utilIds.conDTC, 
        AccountId = accClient1.id);
        
        Contact c2 = new Contact(LastName = 'Test Contact 2', recordtypeid = utilIds.conCCM, 
        AccountId = accClient2.id);
        
        //dml
        insert new sObject[]{c1, c2};           
        
        //program relationships
        Program_Relationships__c c1pr1 = new Program_Relationships__c(Warrant__c = c1.id, 
        Program__c = accReferralOrg1.id, Referral_Date__c = date.newInstance(2013, 06, 1), 
        recordtypeId = utilIds.progRelReferral);
        
        Program_Relationships__c c1pr2 = new Program_Relationships__c(Warrant__c = c1.id, 
        Program__c = accReferralOrg2.id, Referral_Date__c = date.newInstance(2013, 06, 6), 
        recordtypeId = utilIds.progRelReferral);      
        
        Program_Relationships__c c2pr1 = new Program_Relationships__c(Warrant__c = c2.id, 
        Program__c = accReferralOrg1.id, Referral_Date__c = date.newInstance(2013, 06, 9), 
        recordtypeId = utilIds.progRelReferral);      
        
        //dml
        insert new sObject[]{c1pr1, c1pr2, c2pr1};
        
        // follow ups
        FollowUp__c c1pr1f1 = New FollowUp__c(Program_Relationships__c = c1pr1.id, 
        Date_Of_Follow_Up__c = dateTime.newInstance(2013, 06, 5, 12, 30, 1), Follow_Up_Outcome__c = 'Status Confirmed',
        Program_Status__c = 'Active', RecordTypeId = utilIds.FollowUpReferral );
        
        FollowUp__c c1pr1f2 = New FollowUp__c(Program_Relationships__c = c1pr1.id, 
        Date_Of_Follow_Up__c = dateTime.newInstance(2013, 06, 6, 12, 30, 1), Follow_Up_Outcome__c = 'Status Not Confirmed', 
        RecordTypeId = utilIds.FollowUpReferral);       
        
        FollowUp__c c1pr2f1 = New FollowUp__c(Program_Relationships__c = c1pr2.id, 
        Date_Of_Follow_Up__c = dateTime.newInstance(2013, 06, 8, 12, 30, 1), Follow_Up_Outcome__c = 'Status Confirmed',
        Program_Status__c = 'Active', RecordTypeId = utilIds.FollowUpReferral);     

        FollowUp__c c1pr2f2 = New FollowUp__c(Program_Relationships__c = c1pr2.id, 
        Date_Of_Follow_Up__c = dateTime.newInstance(2013, 06, 10, 12, 30, 1), Follow_Up_Outcome__c = 'Status Confirmed',
        Program_Status__c = 'Successful', Discharge_Date_By_Phone_Visit__c = date.newInstance(2013, 06, 10),
        Discharge_Transfer_Reason__c = 'Completed program', RecordTypeId = utilIds.FollowUpReferral);       
        
        FollowUp__c c2pr1f1 = New FollowUp__c(Program_Relationships__c = c2pr1.id, 
        Date_Of_Follow_Up__c = dateTime.newInstance(2013, 06, 11, 12, 30, 1), Follow_Up_Outcome__c = 'Status Not Confirmed',
        Program_Status__c = 'Never Enrolled', RecordTypeId = utilIds.FollowUpReferral);
        
        //dml
        insert new sObject[]{c1pr1f1, c1pr1f2, c1pr2f1, c1pr2f2, c2pr1f1};
        
        //query current field values to check if insert worked correctly
        map<Id, Program_Relationships__c> results = new map<Id, Program_Relationships__c>(
        [select id, Program_Status_Phone_Visit__c, Last_Verified_Phone_Visit__c, 
        Discharge_Transfer_Reason__c, Discharge_Date_Phone_Visit__c
        from Program_Relationships__c where id = :c1pr1.id or id = :c1pr2.id or id = :c2pr1.id]);           
        
        //check c1pr1
        system.assertEquals(results.get(c1pr1.id).Program_Status_Phone_Visit__c, null);
        system.assertEquals(results.get(c1pr1.id).Last_Verified_Phone_Visit__c, dateTime.newInstance(2013, 06, 5, 12, 30, 1));      
        
        //check c1pr2
        system.assertEquals(results.get(c1pr2.id).Program_Status_Phone_Visit__c, null);     
        system.assertEquals(results.get(c1pr2.id).Last_Verified_Phone_Visit__c, dateTime.newInstance(2013, 06, 10, 12, 30, 1));
        system.assertEquals(results.get(c1pr2.id).Discharge_Transfer_Reason__c, 'Completed program');
        system.assertEquals(results.get(c1pr2.id).Discharge_Date_Phone_Visit__c, date.newInstance(2013, 06, 10));
        
        //check c2pr1
        system.assertEquals(results.get(c2pr1.id).Program_Status_Phone_Visit__c, null);
        
        
        //modify follow ups to check update and delete processing
        c1pr1f2.Follow_Up_Outcome__c = 'Status Confirmed';
        c1pr1f2.Program_Status__c = 'Pending Intake';
        
        update c1pr1f2;
        delete c1pr2f2;
        
        //query current field values to check if insert worked correctly
        map<Id, Program_Relationships__c> results2 = new map<Id, Program_Relationships__c>(
        [select id, Program_Status_Phone_Visit__c, Last_Verified_Phone_Visit__c, 
        Discharge_Transfer_Reason__c, Discharge_Date_Phone_Visit__c
        from Program_Relationships__c where id = :c1pr1.id or id = :c1pr2.id or id = :c2pr1.id]);       
        
        //check c1pr1
        system.assertEquals(results2.get(c1pr1.id).Program_Status_Phone_Visit__c, null);        
        system.assertEquals(results2.get(c1pr1.id).Last_Verified_Phone_Visit__c, dateTime.newInstance(2013, 06, 6, 12, 30, 1));
        
        //check c1pr2               
        system.assertEquals(results2.get(c1pr2.id).Program_Status_Phone_Visit__c, null);        
        system.assertEquals(results2.get(c1pr2.id).Last_Verified_Phone_Visit__c, dateTime.newInstance(2013, 06, 8, 12, 30, 1));     
        system.assertEquals(results2.get(c1pr2.id).Discharge_Transfer_Reason__c, null); 
                                        
    }
}