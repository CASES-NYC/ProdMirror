@isTest(SeeAllData=true)
private class rearrestCheckMethodsUnitTest {

    static testMethod void testRearrest() {
    
        utilityIds utilIds = new utilityIds();
        
        ID adminUser = Userinfo.getUserId();
        
        //get a user with specific profile
        //User u = [Select u.Profile.Name, u.ProfileId From User u Where u.IsActive = true AND u.ProfileId = :utilIds.cepDirector LIMIT 1];
       User u = [Select Id, Username, ProfileId,Profile.Name from User 
                                where IsActive = true AND Profile.Name = 'CEP - Admin Support Supervisor' LIMIT 1];
                                
     //   User u = [Select u.Profile.Name, u.ProfileId From User u 
     //   Where u.IsActive = true AND u.ProfileId = :utilIds.adminSupportStaff LIMIT 1];
     // CEP - Admin Support Supervisor
        
        //'CEP - Admin Support Supervisor' 
        
        System.runAs(u) {
            
            //create sample contacts
            List<Contact> lstContact = new List<Contact>();
            Contact c;
            for (Integer i=0; i<4; i++) {
                c = new Contact();
                c.FirstName = 'Test';
                c.LastName = 'TestClient' + i;
                c.Client_Status__c = 'Active';
                c.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
                lstContact.add(c);
            }
            insert lstContact;
                
            
            Task t1 = new Task();
            t1.WhoId = lstContact[0].Id;
            t1.OwnerId = u.Id;
            t1.RecordTypeId = utilIds.rearrestCheckTask;
            t1.Subject = 'Rearrest Check - In-Program';
            t1.Status = 'Not Started';
            t1.ActivityDate = System.today();
            t1.Description = 'Rearrest test';
            t1.Automatically_Generated__c = false;
            t1.Re_arrest_Check_Completed_On__c = system.today();
            insert t1;
            
            t1.OwnerId = adminUser;
            t1.ActivityDate = system.today().addDays(-5);
            t1.No_Rearrest__c = true;
            t1.Re_arrest_Check_Completed_On__c = null;
            update t1;
            
            t1.Re_arrest_Check_Completed_On__c = system.today();
            t1.ActivityDate = system.today().addDays(-5);
            update t1;

            t1.ActivityDate = null;
            t1.Description = 'New one of these';
            update t1;
                        
            
            try {
                t1.Subject = 'Something else';
                update t1;
            } catch(Exception e) {
                system.debug(e);
            }
        }        
    }
}