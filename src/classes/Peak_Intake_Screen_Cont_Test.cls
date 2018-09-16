@isTest(seeAllData=true)
private class Peak_Intake_Screen_Cont_Test 
{
	
	@isTest static void test_method_one() 
	{
        // Add parameters to page URL
      
		Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BK PEAK Client').getRecordTypeId();
        PageReference pageRef = Page.PEAK_Intake_Screen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('RecordType', recTypeId);
        Peak_Intake_Screen_Con pisc = new Peak_Intake_Screen_Con();
        pisc.txtLastName = 'Last';
        pisc.txtFirstName = 'First';
        pisc.Cancel();
        pisc.Save();
	}
	
	@isTest static void test_method_two() 
	{
		Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('BX PEAK Client').getRecordTypeId();
        PageReference pageRef = Page.PEAK_Intake_Screen;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('RecordType', recTypeId);
        Peak_Intake_Screen_Con pisc = new Peak_Intake_Screen_Con();
        pisc.txtLastName = 'Last';
        pisc.txtFirstName = 'First';
        pisc.Cancel();
        pisc.Save();
	}
	
}