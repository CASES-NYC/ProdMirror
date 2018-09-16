@isTest
private class classMethodsUnitTests 
{
    
    static classMethods classMethods= new classMethods();
    static Contact cont;
    static Course__c crsCEX;
    static Course__c crsGeneral;
    static Class__c clCEXStarted;
    static Class__c clCEX;
    static Class__c clGeneral;
    
    private static void establishCoreData() {
        
        Account acct = new Account();
        acct.name = 'Test';
        acct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();  
        insert acct;
        
        cont = new Contact();
        cont.AccountId = acct.Id;
        cont.Court_Rep__c = UserInfo.getUserId();
        cont.Firstname = 'DCS';
        cont.LastName = 'APEX Test';
        cont.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CEP Client').getRecordTypeId();  
        cont.BirthDate = System.Today().addYears(-18);
        cont.Drug_test_frequency__c = 'Bi-Weekly';
        cont.Current_Projected_Exit_Date__c = System.Today().addDays(180);
        cont.Client_Status__c = 'Active';
        cont.Intake_Date__c = System.Today();
        cont.Current_Intake_Date__c = System.Today().addDays(-30);
        cont.Current_Orientation_Date__c = System.Today().addDays(-30);
        cont.Team_Leader__c = UserInfo.getUserId();
        insert cont;
        
        // Create Course
        crsCEX = new Course__c();
        crsCEX.Name = 'Career Ex Test Course';
        crsCEX.Area__c = 'Employment';
        crsCEX.Category__c = 'Career Exploration Training';
        crsCEX.Serves_All_Programs__c = true;        
        insert crsCEX;
        
        crsGeneral = new Course__c();
        crsGeneral.Name = 'General Test Course';
        crsGeneral.Area__c = 'Case Coordination';
        crsGeneral.Category__c = 'Mandatory Class';
        crsGeneral.Serves_All_Programs__c = true;        
        insert crsGeneral;
        
        User u = [SELECT Id FROM User WHERE Profile.Name = 'CEP - ICD Staff' AND IsActive = true LIMIT 1];
        User uEduStaff = [SELECT Id FROM User WHERE Profile.Name = 'CEP - Mental Health Staff' AND IsActive = true LIMIT 1];
        
        // Create Class
        clCEX = new Class__c();
        clCEX.Course__c = crsCEX.Id;
        clCEX.Instructor_1__c = u.Id;
        clCEX.Program_Cycle__c = 1.2;
        clCEX.First_Session_On__c = System.Today();
        clCEX.RecordTypeId = Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Fixed').getRecordTypeId(); 
        insert clCEX;
        
        clCEXStarted = new Class__c();
        clCEXStarted.Course__c = crsCEX.Id;
        clCEXStarted.Instructor_1__c = u.Id;
        clCEXStarted.Program_Cycle__c = 1.2;
        clCEXStarted.First_Session_On__c = System.Today().addDays(-10);
        clCEXStarted.RecordTypeId = Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Fixed').getRecordTypeId();  
        
        // Test Create Permissions - error
        System.runAs(uEduStaff) {
            try { 
                insert clCEXStarted;
            } catch(Exception e) { } 
        }
        
        upsert clCEXStarted; 
        
        clGeneral = new Class__c();
        clGeneral.Course__c = crsGeneral.Id;
        clGeneral.Instructor_1__c = u.Id;
        clGeneral.Program_Cycle__c = 1.2;
        clGeneral.First_Session_On__c = System.Today();
        clGeneral.RecordTypeId = Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Fixed').getRecordTypeId(); 
        insert clGeneral;
        
        // Test Edit Permissions - error
        clGeneral.Class_Description__c = 'Update Test';
        System.runAs(uEduStaff) {
            try {
                update clGeneral;
            } catch(Exception e) { } 
        }

        update clGeneral;
        
    }
    
    static testMethod void testStandardController() {
        
        test.startTest();
        
        establishCoreData();
        
        ApexPages.StandardController con = new ApexPages.StandardController(clCEX);
        classMethods= new classMethods(con);
        
        test.stopTest();
        
    }
    
    static testMethod void testCareerExReferral() {
        
        test.startTest();
        
        establishCoreData();
        
        classMethods.tskRef = new Task();
        classMethods.tskRef.WhoId = cont.Id;
        
        // CareerEx Referral FAIL
        ApexPages.currentPage().getParameters().put('id', clGeneral.Id);
        classMethods.clCurrent = clGeneral;
        classMethods.createCareerExReferral();
        
        classMethods.tskRef = new Task();
        classMethods.tskRef.WhoId = cont.Id;
        
        // CareerEx Referral SUCCEED 1
        ApexPages.currentPage().getParameters().put('id', clCEXStarted.Id);
        classMethods.clCurrent = clCEXStarted;
        classMethods.createCareerExReferral();
        
        classMethods.tskRef = new Task();
        classMethods.tskRef.WhoId = cont.Id;
        
        // CareerEx Referral SUCCEED 2
        ApexPages.currentPage().getParameters().put('id', clCEX.Id);
        classMethods.clCurrent = clCEX;
        classMethods.createCareerExReferral();
        
        
        test.stopTest();
        
    }
    
    static testMethod void testGeneralActions() {
        
        test.startTest();
        
        classMethods.returnToClass();
        
        test.stopTest();
        
    }
    
    static testMethod void testDeleteClass() {
        
        test.startTest();
        
        establishCoreData();
        
        User uEduStaff = [SELECT Id FROM User WHERE Profile.Name = 'CEP - ICD Staff' AND IsActive = true LIMIT 1];
        User uSysAdmin = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        
        // Test Delete Permissions - error
        System.runAs(uEduStaff) {
            try { 
                delete clGeneral;
            } catch(Exception e) { } 
        }
        
        // Test Delete Permissions - error
        System.runAs(uSysAdmin) {
            try { 
                delete clGeneral;
            } catch(Exception e) { } 
        }
        
        test.stopTest();
        
    }

}