global class jobRearrestCheckMonthly Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        rearrestCheckMonthly();
    }
 
    public void rearrestCheckMonthly()
    {// Please add your logic according to requirement
        Id conCEPRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CEP Client').getRecordTypeId();
        Id tskRearrestChkRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Rearrest Check').getRecordTypeId();
        Apex_Defaults__c csApexDefaults = Apex_Defaults__c.getInstance();  
        Date twoYrsAgo = Date.today().addYears(-2);
        Integer yearTwoYrsAgo = twoYrsAgo.Year();
        Integer monthTwoYrsAgo = twoYrsAgo.Month();
        Date oneYrAgo = Date.today().addYears(-1);
        Integer yearOneYrAgo = oneYrAgo.Year();
        Integer monthOneYrAgo = oneYrAgo.Month();

        List<Contact> lstPostExit = new List<Contact>();
        list<Task> lstPostExitRearrestChk = new list<Task>();
        lstPostExit = [SELECT Id, Current_Exit_Date__c FROM Contact
            WHERE RecordType.Name = 'CEP Client'
            AND Prp_Status__c = 'Successful Exit'
            AND CALENDAR_YEAR(Current_Exit_Date__c) = :yearTwoYrsAgo
            AND CALENDAR_MONTH(Current_Exit_Date__c) = :monthTwoYrsAgo];
        for(Contact c: lstPostExit) 
        {       
            Task t = new Task();
            t.whoId = c.Id;
            t.RecordTypeId = tskRearrestChkRecTypeId;
            t.Subject = 'Rearrest Check - Successful Exit';
            t.Open_Date__c = system.Today();
            t.ActivityDate = t.Open_Date__c.AddDays(5);
            t.Automatically_Generated__c = TRUE;
            t.SkipRestrictions__c = TRUE;
            t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CEP__c;
            lstPostExitRearrestChk.add(t);
        }
    
        insert lstPostExitRearrestChk;    
        
        List<Contact> lstPostIntake = new List<Contact>();
        list<Task> lstPostIntakeRearrestChk = new list<Task>();
        lstPostIntake = [SELECT Id, Current_Intake_Date__c FROM Contact    
            WHERE RecordType.Name = 'CEP Client'
            AND Current_Intake_Date__c = :oneYrAgo
            AND CALENDAR_YEAR(Current_Intake_Date__c) = :yearOneYrAgo
            AND CALENDAR_MONTH(Current_Intake_Date__c) = :monthOneYrAgo];
        for(Contact c: lstPostIntake) 
        {       
            Task t = new Task();
            t.whoId = c.Id;
            t.RecordTypeId = tskRearrestChkRecTypeId;
            t.Subject = 'Rearrest Check - 1 Year Post-Intake';
            t.Open_Date__c = system.Today();
            t.ActivityDate = t.Open_Date__c.AddDays(5);
            t.Automatically_Generated__c = TRUE;
            t.SkipRestrictions__c = TRUE;
            t.OwnerId = csApexDefaults.Rearrest_Check_Owner_CEP__c;
            lstPostIntakeRearrestChk.add(t);
        }
    
        insert lstPostIntakeRearrestChk;   

    }
}