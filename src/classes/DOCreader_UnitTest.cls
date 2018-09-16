@isTest(SeeAllData=true) 
public with sharing class DOCreader_UnitTest {
    static utilityIds utilIds = new utilityIds(); 
   static UtilityFileMethods uf = new UtilityFileMethods(); 
   static Account attAccount = new Account();
   static Contact attContact = new Contact();
   static void createTestData(){
        attAccount.name = 'Bill Oh';
        attAccount.RecordTypeId = utilIds.accExternalEntities;
        insert attAccount; 
     
       attContact = new Contact();
       attContact.FirstName = 'Bill';
       attContact.lastName = 'Oh';
       attContact.RecordTypeId = utilIds.conAttorney;
       attContact.AccountId = attAccount.id;
       insert attContact;
   }



   static testMethod void test1()
   {
        DOCreaderController csv = new DOCreaderController();
        test.startTest();  
       List<SelectOption> ro = csv.getrefItems();
    //   List<SelectOption> do = csv.getDesigItems();        
 //       csv.csvFileBody = uf.generateCSV();
      csv.notDOCreferral = false;
      csv.csvFileBody = uf.generateCSV_ForNewDOCFormat();
 //     PageReference pg = csv.generateDOCreferral(); 
      csv.generateDOCreferral(); 
  //      csv.readcsvFile();
        test.stopTest();
   }
   static testMethod void test2()
   {
        DOCreaderController csv = new DOCreaderController();
        test.startTest();  
       List<SelectOption> Items = new List<SelectOption>();
       Items = csv.CodesItems;
       csv.CodesItems = Items;
       boolean doc;
       csv.inputType = 'DOCreferreal'; 
       csv.checkinputType();
       csv.inputType = 'non'; 
       csv.checkinputType();
 
       List<SelectOption> Items1 = new List<SelectOption>();
       Items1 = csv.getInputTypeItems();
       
  ///     doc = csv.getDOCreferral();
 //      csv.setDOCreferral(true);
  //      csv.csvFileBody = uf.generateCSV_ForNewDOCFormat();
  //      csv.readcsvFile();
        test.stopTest();
   }   
    static testMethod void test3()
   {
   	createTestData();
        DOCreaderController csv = new DOCreaderController();
        test.startTest();  
        csv.notDOCreferral = true;  
       csv.clsInput.fname = 'Bob';
       csv.clsInput.lname = 'Smith';
       csv.clsInput.mname = 'G';
       csv.clsInput.NYSID = '65487985Y';
       csv.clsInput.Docket = '2014NY356589';
       csv.clsInput.dob = '01/01/1990';
       csv.clsInput.gender = 'Male';
       csv.clsInput.darraign = '';
       csv.clsInput.address = '20 E 30 street';
       csv.clsInput.cjascore = '40';
       csv.clsInput.DOCscore = '60';
       csv.clsInput.cjascore = '50';
       csv.clsInput.DOCscore = '60';
       csv.clsInput.address = 'wwwwww';
       csv.clsInput.dob = '';     
       csv.clsInput.charge1 = '100.05';
       csv.clsInput.charge2 =   '100.05';
    csv.clsInput.charge3  = '100.05';
     csv.clsInput.charge4 = '100.05';
     csv.clsInput.charge5 = '100.05';
  //     csv.clsInput.dob = '01/01/1940';     
       csv.clsInput.bail = '1000';
       csv.clsInput.nextcourtdate = '';
       csv.clsInput.Referral_Source = 'Attorney';
       csv.clsInput.designation = 'No';
       csv.clsInput.MOCJscore = '20';
      string g = 'Transgender Man';
        csv.findgender(g);
  
        csv.clsInput.bookcase = '1245897878';
       g = 'Male';
       csv.findgender(g);        

       g = 'Female';
       csv.findgender(g);
        csv.nonDOCreferral(); 

       string s = '456';
       csv.validateBookCase(s);
       
       
       
//       darraign
       
       string s1 = '1235NY589';
       csv.validateDocketformat(s1);
       
       string s2 = '468797896';
       csv.validateNYSIDformat(s2);
        csv.nonDOCreferral();
    //    csv.dataEnterred();      
       csv.attName = attContact.name; 
       csv.findAttorney(); 
        
        test.stopTest();
   }   
   /*
   static testMethod void test4(){
   	CIRT_Download__c cd = new CIRT_Download__c();
   	      DOCreaderController csv = new DOCreaderController();
   	 csv.clsInput.nysid = '12458784G';  
   	     csv.clsInput.FName = 'Greg';
     csv.clsInput.bookcase = '1245878965';
     csv.clsInput.mName = '';
     csv.clsInput.dob = '01/22/1980';
     csv.clsInput.LName = 'Smith';
     csv.clsInput.address = '';
     csv.clsInput.city = '';
     csv.clsInput.state = 'NY'; 
     csv.clsInput.zip = '10013';
     csv.clsInput.gender = 'Male';
     csv.clsInput.charge1 = '101.1';
     csv.clsInput.charge2 = '105.6';
     csv.clsInput.charge3 = '';
     csv.clsInput.charge4 = ''; 
     csv.clsInput.charge5 = '';
     csv.clsInput.courtboro = '';
     csv.clsInput.darraign = '12/06/2016';
     csv.clsInput.bail = '3000';
     csv.clsInput.nextcourtdate = '';
     csv.clsInput.CJAscore = '40';
     csv.clsInput.DOCscore = '50';
     csv.clsInput.eligible = '';
 //    csv.clsInput.refdate = '';
     csv.clsInput.Referral_Source = 'Attorney';
     csv.clsInput.designation = 'No';
     csv.clsInput.MOCJscore = '20';
        test.startTest(); 
     csv.dataEnterred();     
        
        test.stopTest();
   }
   */
}