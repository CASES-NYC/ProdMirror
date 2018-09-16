public with sharing class DispoReportController {
/**
*   {Purpose}  �  TODO:  Provide Purpose
*
*   {Contact}   - support@demandchainsystems.com
*                 www.demandchainsystems.com
*                 612-424-0032                  
*/

/**
*   CHANGE  HISTORY
*   =============================================================================
*   Date    	Name             		Description
*   YYYYMMDD  	FN LN DCS				Created
*   =============================================================================
*/
	public String strCourtRep {get;set;}


	///////////////////////////
	// Constructors
	///////////////////////////
	public DispoReportController() {
		
	}
	
	
	///////////////////////////
	// GET / SET
	///////////////////////////
	public List<SelectOption> lstCourtReps {
		get {
			List<SelectOption> lstTemp = new List<SelectOption>();
			lstTemp.add(new SelectOption('all', 'All'));
			for(User usr : [SELECT Id, FirstName, LastName FROM User Where IsActive = True ORDER BY LastName]) {
				lstTemp.add(new SelectOption(usr.Id, usr.LastName + ', ' + usr.FirstName));
			}
			return lstTemp;
		}
		private set { lstCourtReps = value; }
	}
	
	
	///////////////////////////
	// Action Methods
	///////////////////////////
	
	
	///////////////////////////
	// Inner / Helper Classes
	///////////////////////////
}