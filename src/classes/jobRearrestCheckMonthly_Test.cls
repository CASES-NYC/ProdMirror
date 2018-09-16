@isTest(seeAllData=true)
public class jobRearrestCheckMonthly_Test{
    private static testmethod void test_jobRearrestCheckMonthly(){

        User u = [select id from user where profile.name like '%System Admin%' and isactive = true limit 1 ];

        System.RunAs(u){   
            Account a = new Account(
                Name = 'Testclass',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId()          
            );
            insert a;

            Contact postExit = new Contact
            (
                LastName = 'Post-Exit',
                AccountId = a.Id,
                RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CEP Client').getRecordTypeId(),
                Client_Status__c = 'Exited',
                Prp_Status__c = 'Successful Exit',
                Current_Exit_Date__c = Date.today().addYears(-2)
                
            );
            insert postExit;

            Contact postIntake = new Contact
            (
                LastName = 'Post-Intake',
                AccountId = a.Id,
                RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CEP Client').getRecordTypeId(),
                Current_Intake_Date__c = Date.today().addYears(-1)
                
            );
            insert postIntake;

            //Contact chkC = [select id from Contact where id=:c.id];                      

            Test.startTest();
                jobRearrestCheckMonthly schedCheckMonthly = new jobRearrestCheckMonthly(); 
                String sch ='0 48 * * * ?'; 
                System.schedule('Schedule to run rearrest check', sch, schedCheckMonthly);
            Test.stopTest();      

            Integer i = [SELECT COUNT() FROM Contact WHERE AccountId = :a.Id];
            Integer j = [SELECT COUNT() FROM Task WHERE Subject = 'Rearrest Check - 1 Year Post-Intake' AND Who.Name = 'Post-Intake'];
            //System.assertEquals(1, i);
            
            system.debug('count of contact records: ' + i);
            system.debug('count of task records: ' + j);
        }
    }      
}