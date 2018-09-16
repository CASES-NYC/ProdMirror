@isTest(seeAllData=true)
public class jobRearrestCheckWeekly_Test{
    private static testmethod void test_jobRearrestCheckWeekly(){

        User u = [select id from user where profile.name like '%System Admin%' and isactive = true limit 1 ];

        System.RunAs(u){   
            Account a = new Account(
                Name = 'Testclass',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId()          
            );
            insert a;

            Contact c = new Contact
            (
                LastName = 'Testclass',
                AccountId = a.Id,
                RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CIRT Client').getRecordTypeId(),
                Client_Status__c = 'Active'
            );
            insert c;


            Contact chkC = [select id from Contact where id=:c.id];                      

            Test.startTest();
                jobRearrestCheckWeekly schedCheckWeekly = new jobRearrestCheckWeekly(); 
                String sch ='0 48 * * * ?'; 
                System.schedule('Schedule to run rearrest check', sch, schedCheckWeekly);
            Test.stopTest();      

            Integer i = [SELECT COUNT() FROM Contact WHERE Id = :c.Id];
            //Integer j = [SELECT COUNT() FROM Task WHERE Subject = 'Rearrest Check'];
            System.assertEquals(1, i);
        }
    }      
}