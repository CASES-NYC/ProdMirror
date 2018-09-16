public with sharing class courseMethods {

	public utilityIds utilId = new utilityIds();
	public List<Course__c> lstCourses = new List<Course__c>();

    public courseMethods() {  }
    
    public void updateClassAttributes() {
        
        List<Id> lstCourseIds = new List<Id>();
        for(Course__c c : lstCourses) {
            lstCourseIds.add(c.Id);
        }
        
        List<Class__c> lstClasses = [SELECT Id, Course__c, AreaRPT__c, CategoryRPT__c FROM Class__c WHERE Course__c IN :lstCourses];
        
        for(Course__c coLoop : lstCourses) {
            for(Class__c c : lstClasses) {
                if(c.Course__c == coLoop.Id) {
                    c.AreaRPT__c = coLoop.Area__c;
                    c.CategoryRPT__c = coLoop.Category__c;
                }
            }
        }
        
        if(lstClasses.size() > 0) { update lstClasses; }
        
    }
    
	//for START groups, create a dummy class and schedule to be used for DTC Groups
	public void createDummyClass() {
		
		list<Class__c> lstClassestoCreate = new list<Class__c>();
		list<Schedule__c> lstSchedulestoCreate = new list<Schedule__c>();
		Class__c tempCL = new Class__c();
		Schedule__c tempSch = new Schedule__c();
		
		for(Course__c c: lstCourses) {
			
			if(c.Category__c == 'START Group') {
				
				tempCL = new Class__c(RecordtypeId = utilId.classFixed, Course__c = c.id);
				lstClassestoCreate.add(tempCL);
			}
		}
		
		insert lstClassestoCreate;
		
		for(Class__c c: lstClassestoCreate) {

				tempSch = new Schedule__c(RecordtypeId = utilId.scheduleFixed, Class__c = c.id, Dummy_Schedule__c = true);
				lstSchedulestoCreate.add(tempSch);			
		}
		
		insert lstSchedulestoCreate;
		
	}    
}