@isTest (SeeAllData=true)
private class attorneyInfoUnitTest {  
    static Case_Information__c caseTest = new Case_Information__c();
    static Contact contactTest = new Contact(); 
    static Case_Information__c caseTest1 = new Case_Information__c();
    static Contact contactTest1 = new Contact();     
    static Account accountTest = new Account();
    
    static ID accAgency = Utility_ID__c.getValues('External Entities').RecordType_Id__c;
    
    static Id caseRecTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
    static Id suprRecTypeId = Utility_ID__c.getValues('Case - Supreme Court').RecordType_Id__c;
    static Id attRecordType = Utility_ID__c.getValues('Attorney/ Law Guardian').RecordType_Id__c;

    static Id conCRT = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c;  
    static Id accClient = Utility_Id__c.getValues('Client').RecordType_Id__c;
    
    static void createTestData() {

    User adminUser = [Select Id from User Where isActive = true and Profile.Name = 'System Administrator' Limit 1];
   
      Account accountTestAgency = new Account();
      accountTestAgency.nysid_number__c = '04221673K';  
      accountTestAgency.Name = 'Legal';
      accountTestAgency.recordtypeId =  accAgency;
      accountTestAgency.BillingStreet = 'Broadway';
      accountTestAgency.billingState = 'NY';
      accountTestAgency.BillingPostalCode= '100015';
      insert accountTestAgency;
    
      Contact  contactTestAtt = new Contact(); 
      contactTestAtt.lastName = 'Lasttest';
      contactTestAtt.firstName = 'firsttest';
      contactTestAtt.firstname = 'attFirst';
      contactTestAtt.lastName = 'attlast';
      contactTestAtt.RecordTypeId = attRecordType;
      insert contactTestAtt;

      accountTest = new Account();
      accountTest.nysid_number__c = '04221673M';  
      accountTest.Name = 'CIRT';
      accounttest.DOB__c = date.parse('11/11/1950');
      accountTest.recordtypeId =  accClient;
      insert accountTest;

      ID Accountid = accountTest.id; 
      
        casetest.Client_Account__c = AccountId;
        caseTest.Name = '2012BX023083';
        caseTest.Borough__c = 'Bronx';
        caseTest.Indictment__c = 'indictment';
        caseTest.RecordTypeId = suprRecTypeId;
        caseTest.Arrest_Date__c = date.today();
        casetest.Defense_Attorney_Law_Guardian__c = contactTest.id;

        
        caseTest1.Client_Account__c = AccountID;
        caseTest1.Name = '2013NY023075';
        caseTest1.Borough__c = 'Bronx';
        caseTest1.Indictment__c = 'indictment';
        caseTest1.RecordTypeId = suprRecTypeId;
        caseTest1.Arrest_Date__c = date.today();
        caseTest1.Defense_Attorney_Law_Guardian__c = contactTest.id;
        
        insert new Case_Information__c[]{caseTest, caseTest1};       
      
      contactTest = new Contact();
        contactTest.lastName = 'Lasttest';
        contactTest.firstName = 'firsttest';
        contactTest.recordtypeid = conCRT; 
        contactTest.Client_Status__c = '';
        contactTest.Resource_Coordinator_s_Comments__c = 'comments';
        contactTest.Supervising_Attorney__c = contactTestAtt.id;
        contactTest.Attorney_Consent__c = 'Yes';
        contactTest.Intake_Case__c = caseTest.Id;
        contactTest.CIRT_Final_Outcome__c = 'final Outcome';
        contactTest.CIRT_Final_Outcome_Date__c = date.today();
        contactTest.Final_Outcome_Modified_Date__c = date.today();     
        contactTest.Referral_Date__c = System.Today();  
        contactTest.accountID = accounttest.Id;   
            
        contactTest1 = new Contact();
        contactTest1.lastName = 'Lasttest';
        contactTest1.firstName = 'firsttest';
        contactTest1.recordtypeid = conCRT; 
        contactTest1.Client_Status__c = '';
        contactTest1.Resource_Coordinator_s_Comments__c = 'comments';
        contactTest1.Supervising_Attorney__c = contactTestAtt.id;
        contactTest1.Attorney_Consent__c = 'No';
        contactTest1.Intake_Case__c = caseTest1.id;
        contactTest1.CIRT_Final_Outcome__c = 'final Outcome';
        contactTest1.CIRT_Final_Outcome_Date__c = date.today();
        contactTest1.Final_Outcome_Modified_Date__c = date.today();     
        contactTest1.Referral_Date__c = System.Today();  
        contactTest1.accountID = accounttest.Id;            
        
        insert new Contact[]{contactTest, contactTest1};
        
    }
     static testMethod void test1()
      {
        createTestData();
        attorneyInfoController ai = new attorneyInfoController();  
        test.startTest();

        ai.strCase = casetest.id;
        ai.thisContact = [select id, Attorney_Consent__c, Attorney_Consent_Description__c,
            Attorney_Decision_Date__c, Supervising_Attorney__c, Resource_Coordinator_s_Comments__c,
            FirstName, LastName, P_C_ID__c, Screening_Stage__c, Client_Status__c, Interview_Stage__c,
            CIRT_Final_Outcome__c, CIRT_Final_Outcome_Date__c, Final_Outcome_Modified_date__c
            from Contact where id = :contactTest.id];   
        ai.thisCase = [select id, Defense_Attorney_Law_Guardian__c, Affiliation__c
            from Case_Information__c where id = :casetest.id];  
  
        ai.strOriginalOutcome = 'original';
        ai.updateAttorneyInfo();
        ai.goNewAttorney(); 
        ai.goPortal(); 
        ai.goInterview();
        test.stopTest();

      }
      
      
         static testMethod void test2()
      {
        createTestData();
        attorneyInfoController ai = new attorneyInfoController();  
        ai.strCase = casetest.id;
        ai.thisContact = [select id, Attorney_Consent__c, Attorney_Consent_Description__c,
            Attorney_Decision_Date__c, Supervising_Attorney__c, Resource_Coordinator_s_Comments__c,
            FirstName, LastName, P_C_ID__c, Screening_Stage__c, Client_Status__c, Interview_Stage__c,
            CIRT_Final_Outcome__c, CIRT_Final_Outcome_Date__c, Final_Outcome_Modified_date__c
            from Contact where id = :contactTest1.id];  
            
        ai.thisCase = [select id, Defense_Attorney_Law_Guardian__c, Affiliation__c
            from Case_Information__c where id = :casetest1.id]; 
        test.startTest();
        ai.updateAttorneyInfo();
        test.stoptest();
      }
}