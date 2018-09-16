@isTest(seealldata=true)
private class assessmentButtonExt_Test 
{

    static id conSRP = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('SRP Client').getRecordTypeId();
    static id acctClient = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    static id assessUCPT = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('UCLA PTSD DSM V').getRecordTypeId();
    static id assessHWB =  Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Health and Wellbeing Assessment').getRecordTypeId();
 	static assessmentButtonExt ext;
 	static Assessment__c assessmentMaster;
  	static PageReference pref;
  	static User testUser;
    
    static testMethod void assessDispatchUnitTest1() 
    {
        Account account = new Account(Name = 'Fname Lname', RecordTypeId = acctClient);
        insert account;
 
        Contact contact = new Contact();
        contact.RecordTypeId = conSRP;
        contact.FirstName = 'Test Fname';
        contact.LastName = 'Test Lname';
        contact.Screening_Outcome_srp__c = 'Eligible';
        contact.Arraignment_Outcome__c = 'Released into Supervised Release';
        contact.AccountId = account.Id;      
        insert contact;

        Assessment__c aHWB = new Assessment__c(RecordTypeId = assessHWB, Contact__c = contact.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(aHWB);
        insert aHWB;
        
        Health_and_Wellbeing_Assessment__c HWBA = new Health_and_Wellbeing_Assessment__c();
        HWBA.AssessmentId__c = aHWB.Id;
        HWBA.Participant__c = aHWB.Contact__c;
        Insert HWBA;
        
        aHWB.ChildObjectId__c = HWBA.Id;
        update HWBA;
        
        PageReference pageRef2 = Page.HWB_View;
        pageRef2.getParameters().put('Id', HWBA.Id);
        pageRef2.getParameters().put('AssessmentID__c',HWBA.AssessmentId__c);
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController sdv = new ApexPages.StandardController(HWBA);
        assessmentButtonExt viewcon = new assessmentButtonExt(sdv);
        viewcon.markComplete();

/*


  private static void init() 
  {
	Contact ConClient = [SELECT Id, AccountId FROM Contact WHERE Client_Status__c = 'Active' LIMIT 1];
	if (conClient[0].Size() == 0)
		system.debug('********* NO CLIENT RECORD FOUND ************');
	else
		assessmentMaster = new Assessment__c();
    	assessmentMaster.Contact__c = conClient[0].Id;
    	assessmentMaster.RecordTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('Health and Wellbeing Assessment').getRecordTypeId();
    	insert assessmentMaster;

    Health_and_Wellbeing_Assessment__c d1 = new DetailObject__c(
        Name='Detail 1',Status__c='Open',MasterObject__c=masterObject.Id);
    DetailObject__c d2 = new DetailObject__c(
        Name='Detail 2',Status__c='Closed',MasterObject__c=masterObject.Id);
    DetailObject__c d3 = new DetailObject__c(
        Name='Detail 3',Status__c='Declined',MasterObject__c=masterObject.Id);

    List<DetailObject__c> children = new List<DetailObject__c>();
    children.add(d1);
    children.add(d2);
    children.add(d3);
    insert children;

    pref = Page.MoveRecords;
    pref.getParameters().put('id',masterObject.id);
    Test.setCurrentPage(pref);

    ApexPages.StandardController con = new ApexPages.StandardController(masterObject);
    ext = new MyController(con);

  }

  static testMethod void testMoveOpenOnly() 
  {

    init();

    Test.startTest();

    // choose the owner of the new master object
    ext.testUserId = testUser.Id;           
    // indicate that we want to move the closed children
    ext.moveClosed = true;

    // perform some more assertions

    pref = ext.save();
    System.assertEquals(pref.getUrl(),'/'+ext.newMasterObject.Id);

    // ensure the original master object contains 1 child
    System.assertEquals(1, [select count() from DetailObject__c where MasterObject__c = :masterObject.Id]);
    // ensure the new master object contains 2 children
    System.assertEquals(2, [select count() from DetailObject__c where MasterObject__c = :ext.newMasterObject.id]);

    Test.stopTest();

  }

  static testMethod void testDoNotReassignDeclined() 
  {

    init();

    Test.startTest();

    // choose the owner of the newmaster object
    ext.salesRepId = salesRep.Id;         
    // indicate that we do NOT want to move the closed children
    ext.moveClosed = false;

    // perform some more assertions

    pref = ext.save();
    System.assertEquals(pref.getUrl(),'/'+ext.newMasterObject.Id);

    // ensure the original master object contains 2 children
    System.assertEquals(2, [select count() from DetailObject__c where MasterObject__c = :masterObject.Id]);
    // ensure the new master object contains 1 child
    System.assertEquals(1, [select count() from DetailObject__c where MasterObject__c = :ext.newMasterObject.id]);

    Test.stopTest();
*/
  }

}