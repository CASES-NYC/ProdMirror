trigger schoolClassLogic on School_Class__c (before delete) {

	//prevents manual delete. SemesterMethods sets the Allow_Delete flag, bypassing the following validation
	for(School_Class__c sc: Trigger.Old) {
		
		
		if(UtilityIds.bolDeleteSchoolClasses != true) {
			
			sc.addError('You cannot delete a school class directly.' +
			'Clear the class information in the semester data entry form and click save.');
		}
	}

}