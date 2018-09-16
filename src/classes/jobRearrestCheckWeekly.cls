global class jobRearrestCheckWeekly Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        rearrestCheckWeekly();
    }
 
    public void rearrestCheckWeekly()
    {// Please add your logic according to requirement
        Id conCIRTRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CIRT Client').getRecordTypeId();
        Id tskRearrestChkRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Rearrest Check').getRecordTypeId();
        Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();  

        list<Task> lstTasksToCreate = new list<Task>();
        list<Contact> lstContacts = [SELECT Id FROM Contact WHERE RecordTypeId = :conCIRTRecTypeId AND Client_Status__c = 'Active'];
        for(Contact c: lstContacts) 
        {       
            Task t = new Task();
            t.whoId = c.Id;
            t.RecordTypeId = tskRearrestChkRecTypeId;
            t.Subject = 'Rearrest Check';
            t.Open_Date__c = system.Today();
            t.ActivityDate = t.Open_Date__c.AddDays(5);
            t.Automatically_Generated__c = TRUE;
            t.SkipRestrictions__c = TRUE;
            t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CRT__c;
            lstTaskstoCreate.add(t);
        }
    
        insert lstTaskstoCreate;    
        
    }
}