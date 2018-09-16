@isTest(SeeAllData=true)
private class chargeMethodsUnitTests 
{
    
    static Contact con = new Contact();
    static Case_Information__c newCaseInfo =  new Case_Information__c();
    static Penal_Code__c pc_10 = new Penal_Code__c();
    static Penal_Code__c pc_20 = new Penal_Code__c();
    static Penal_Code__c pc_30 = new Penal_Code__c();  
    static Id accClient = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    static Id conTRP =Schema.SObjectType.Contact.getRecordTypeInfosByName().get('TRP Client').getRecordTypeId();
    static Id caseInfoSupremeCourt = Schema.SObjectType.Case_Information__c.getRecordTypeInfosByName().get('Supreme Court').getRecordTypeId();  
    static void initCore() 
    {
        // Stage Data
        
        pc_10 = new Penal_Code__c(Violent__c = true, Numeric_Charge_Value__c = 10, 
          Name = 'c_10', Level__c = 'V', Drug_Related__c = true, Description__c = 'test pc', 
          Degree__c = '1', Class__c = 'A');
        
        //TC = 1,910,020.000
        pc_20 = new Penal_Code__c(Violent__c = true, Numeric_Charge_Value__c = 20, 
          Name = 'c_20', Level__c = 'V', Drug_Related__c = true, Description__c = 'test pc', 
          Degree__c = '1', Class__c = 'A');
        
        pc_30 = new Penal_Code__c(Violent__c = true, Numeric_Charge_Value__c = 30, 
          Name = 'c_30', Level__c = 'V', Drug_Related__c = true, Description__c = 'test pc', 
          Degree__c = '1', Class__c = 'A');
        insert new sObject[]{pc_10, pc_20, pc_30};        
        
        //clients- accounts
        Account accClient1 = new Account(Name = 'Test Contact 1', RecordTypeId = accClient);   
        
        //dml
        insert accClient1;           
        
        //clients- contacts
        Contact c1 = new Contact(LastName = 'Test Contact 1', recordtypeid = conTRP, 
        Screening_Stage__c = 'Intake Complete', AccountId = accClient1.id);  
        
        newCaseInfo = new Case_Information__c();
        newCaseInfo.Client_Account__c = accClient1.Id;
        newCaseInfo.Name = '2013TN456011';
        newCaseInfo.Borough__c = 'Bronx';       
        newCaseInfo.RecordTypeId = caseInfoSupremeCourt;
        
        insert newCaseInfo;  
    } 
    
    
  static testMethod void testTopCharge() {
    
    initCore();
 
    Case_Charges__c c_charge = new Case_Charges__c(Docket_No__c = newCaseInfo.Id, Charge__c = pc_10.Id, Type__c = 'Arrest Charges');
    insert c_charge;
    
    System.assertEquals(1, [Select count() from Case_Charges__c WHERE Docket_No__c = :newCaseInfo.Id]);

    
    newCaseInfo = [Select Id, Top_Plea_Charge__c, Top_Indictment_Charge__c, Top_Family_Court_Arraignment_Charge__c, 
      Top_Criminal_Court_Arraignment_Charge__c, Top_Arrest_Charge__c from Case_Information__c 
      where Id = :newCaseInfo.Id];
    System.assertEquals('c_10', newCaseInfo.Top_Arrest_Charge__c);
    
    c_charge = new Case_Charges__c(Docket_No__c = newCaseInfo.Id, Charge__c = pc_20.Id, Type__c = 'Arrest Charges');
    insert c_charge;
    
    newCaseInfo = [Select Id, Top_Plea_Charge__c, Top_Indictment_Charge__c, Top_Family_Court_Arraignment_Charge__c, 
      Top_Criminal_Court_Arraignment_Charge__c, Top_Arrest_Charge__c from Case_Information__c 
      where Id = :newCaseInfo.Id];
    System.assertEquals('c_20', newCaseInfo.Top_Arrest_Charge__c);
    
    //Deleting this second charge should revert to c_10 as Top Arrest Charge
    delete c_charge;
    newCaseInfo = [Select Id, Top_Plea_Charge__c, Top_Indictment_Charge__c, Top_Family_Court_Arraignment_Charge__c, 
      Top_Criminal_Court_Arraignment_Charge__c, Top_Arrest_Charge__c from Case_Information__c 
      where Id = :newCaseInfo.Id];
    System.assertEquals('c_10', newCaseInfo.Top_Arrest_Charge__c);
    
    //Reverse true for undelete
    undelete c_charge;
    newCaseInfo = [Select Id, Top_Plea_Charge__c, Top_Indictment_Charge__c, Top_Family_Court_Arraignment_Charge__c, 
      Top_Criminal_Court_Arraignment_Charge__c, Top_Arrest_Charge__c from Case_Information__c where Id = :newCaseInfo.Id];
    System.assertEquals('c_20', newCaseInfo.Top_Arrest_Charge__c);    
    
  }//end testTopCharge
  
  //Second test for this because TopCharge test is hitting SoQL query limit
  static testMethod void testTopCharge2() {
    
    initCore();
    
    Case_Charges__c c_charge = new Case_Charges__c(Docket_No__c = newCaseInfo.Id, Charge__c = pc_10.Id, Type__c = 'Arrest Charges');
    insert c_charge;
    
    System.assertEquals(1, [Select count() from Case_Charges__c WHERE Docket_No__c = :newCaseInfo.Id]);

    
    newCaseInfo = [Select Id, Top_Plea_Charge__c, Top_Indictment_Charge__c, Top_Family_Court_Arraignment_Charge__c, 
      Top_Criminal_Court_Arraignment_Charge__c, Top_Arrest_Charge__c from Case_Information__c where Id = :newCaseInfo.Id];
    System.assertEquals('c_10', newCaseInfo.Top_Arrest_Charge__c);
    
    c_charge = new Case_Charges__c(Docket_No__c = newCaseInfo.Id, Charge__c = pc_20.Id, Type__c = 'Arrest Charges');
    insert c_charge;
    
    newCaseInfo = [Select Id, Top_Plea_Charge__c, Top_Indictment_Charge__c, Top_Family_Court_Arraignment_Charge__c, 
      Top_Criminal_Court_Arraignment_Charge__c, Top_Arrest_Charge__c from Case_Information__c where Id = :newCaseInfo.Id];
    System.assertEquals('c_20', newCaseInfo.Top_Arrest_Charge__c);
    
    //Change the Top Calc value of p_20
    pc_20.Numeric_Charge_Value__c = 1;
    update pc_20;
    
    //Top charge should recalculate
    newCaseInfo = [Select Id, Top_Plea_Charge__c, Top_Indictment_Charge__c, Top_Family_Court_Arraignment_Charge__c, 
      Top_Criminal_Court_Arraignment_Charge__c, Top_Arrest_Charge__c from Case_Information__c where Id = :newCaseInfo.Id];
    System.assertEquals('c_10', newCaseInfo.Top_Arrest_Charge__c);
    
  }//end TestPenalUpdate
}