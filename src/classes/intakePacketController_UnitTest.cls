/**
*   {Purpose}  �  TODO:  Provide Purpose
*
*	{Code Covered}	- Note the triggers/classes that this test covers
*
*   {Contact}   - support@demandchainsystems.com
*                 www.demandchainsystems.com
*                 612-424-0032                  
*/

/**
*   CHANGE  HISTORY
*   =============================================================================
*   Date    	Name             		Description
*   20141211  	Eric Gronholz DCS		Created
*   =============================================================================
*/
@isTest (SeeAllData=true)
private class intakePacketController_UnitTest {
	
	static testMethod void intakePacketController_Test()  {
		Contact oContact = populateTestData_DCS.loadTestIntakePacketData();
		Set<Id> setIds = new Set<Id>();
		setIds.add(oContact.Id);
		Test.startTest();

        ApexPages.StandardController sc = new ApexPages.StandardController(oContact);
        intakePacketController cntlr = new intakePacketController(sc);
        
		PageReference pageRef = Page.intakePacket;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oContact.Id);
        cntlr.findPacketData();

		Test.stopTest();
	}
	
}