trigger semesterLogic on Semester__c (before delete, after update, after insert) {
	
	semesterMethods semesterMethods = new semesterMethods();
	list<Id> lstSemesterIds = new list<Id>();
	list<School_Class__c> lstClassestoDelete = new list<School_Class__c>();
	
	if(trigger.isAfter) {
		
		if(trigger.IsUpdate || trigger.isInsert) {
		
			// only run if the classes weren't already saved, otherwise we get an infinite loop
			// because the class insert re-evaluates the roll-up fields on semester
			// This value is set in semesterMethods.generateClasses right before the classes are upserted/deleted
			if(utilityIds.bolSchoolClassesAlreadyCreated != true) {
				
				// create school classes and update their ids on the semester record.
				semesterMethods.generateClasses(trigger.New);
			}
		}
	}
	
	if(trigger.isBefore) {
		
		// delete related classes before deleting semester to avoid error (because relationship on child is required)
		if(trigger.isDelete) {
			
			for(Semester__c s: Trigger.Old) {
				
				lstSemesterIds.add(s.id);
			}
			
			lstClassestoDelete = [select id from School_Class__c where Semester__c in :lstSemesterIds];
			
			if(lstClassestoDelete.size()>0) {
							
				//delete can only occur via Apex, not manually
				utilityIds.bolDeleteSchoolClasses = true;			
				delete lstClassestoDelete;
			}
		}		
		
	}

}