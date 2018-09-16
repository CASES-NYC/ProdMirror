@isTest (SeeAllData=true)
private class ProgramReportScheduleUnitTest {
	 
  	static UtilityTimeMethods ut = new UtilityTimeMethods();
    
   // static User userCaseCoordinator;
	
	static utilityIds utilIds = new utilityIds();
	static list<id> selProgramIDs = new list<id>{utilIds.conJS, utilIds.conCJC};
    static String[] programsEmpty = new String[]{};

    static testMethod void testSelectContacts() {
     	

     	Account a = new Account();
     	a.Name = 'Test';
     	a.RecordTypeId = utilIds.accClient;
     	insert a;
            
        Contact conJS = new Contact();
        conJS.lastName = 'Lasttest';
        conJS.firstName = 'firsttest';
        conJS.recordtypeid = utilIds.conJS;
        conJS.Team_Leader__c = userInfo.getUserId();
        conJS.Case_Coordinator__c = userInfo.getUserId();
        conJS.Client_Status__c = 'Active';
        conJS.accountId = a.id;
        insert conJS;       
           
        test.startTest();

        ProgramReportScheduleController pr = new ProgramReportScheduleController();
        pr.proxyobject.school_start_date__c = date.today();
        pr.proxyobject.school_end_date__c = pr.proxyobject.school_start_date__c + 5; 
        pr.programs = selProgramIds;  
        string d1 = pr.convert2dateString(pr.proxyobject.school_start_date__c);  
        string d2 = pr.convert2dateString(pr.proxyobject.school_end_date__c);
        List<SelectOption> mm = pr.getProgramItems() ;
        pr.buildContacts();
        pr.buildTimeItems();
        pr.buildTimeOutItems('10:00 AM');
        
        pr.mask1 = 4;
        pr.in1 = '10:00 AM';
        pr.out1 = '11:00 AM';
           
        pr.mask2 = 3;
        pr.in2 =  '11:00 AM';
        pr.out2 = '12:00 PM';
           
        pr.mask3 = 1;
        pr.in3 =  '11:00 AM';
        pr.out3 = '12:00 PM';
 
        pr.mask4 = 5;
        pr.in4 =  '11:00 AM';
        pr.out4 = '12:00 PM';

        pr.mask5 = 8;
        pr.in5 =  '11:00 AM';
        pr.out5 = '12:00 PM';
           
        pr.scheduleClients();   
      
        pr.timeInValue = '09:00 AM';
        pr.PK_timeInValue1();
        pr.PK_timeInValue2();
        pr.PK_timeInValue3();
        pr.PK_timeInValue4();
        pr.PK_timeInValue5();
       
        string period = pr.cperiod;
        pr.getMessage();
        pr.resetEvents();
        pr.Resetlabel();
        pr.insertSchedule(pr.in5, pr.out5, pr.mask5, date.today(), conJS.id);
       
       
        pr.proxyobject.school_end_date__c = date.today();
        pr.proxyobject.school_start_date__c = pr.proxyobject.school_start_date__c + 20; 
        pr.getMessage(); 
       
        pageReference pref = pr.doNothing();
        String[] str1 = pr.getPrograms();
        test.stopTest();  
	}       
}