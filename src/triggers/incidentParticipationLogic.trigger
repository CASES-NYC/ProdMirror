trigger incidentParticipationLogic on Incident_Participation__c (before insert, after insert) {
	
	utilityMethods utilMethods = new utilityMethods();
	incidentMethods incidentMethods = new incidentMethods();
	
	if(trigger.isBefore) {
		
		incidentMethods.setProgramPlanField(Trigger.new);
	}
	
	if(trigger.isAfter) {
		
		utilMethods.createIncidentReportNoteTask(Trigger.New);	
		incidentMethods.sendIncidentReportEmail(Trigger.new);	
	}
	
}