global class jobUpdateNumberofDaysinProgram_Scheduler  implements Schedulable{
	
	global static string scheduleJob(string runTime) {
		
		jobUpdateNumberofDaysinProgram_Scheduler j = new jobUpdateNumberofDaysinProgram_Scheduler();
		return system.schedule('Update Day Count Fields', runTime ,j);
	}
	
	
	global void execute(SchedulableContext ctx) {
       
		jobUpdateNumberofDaysinProgram job = new jobUpdateNumberofDaysinProgram();
		job.UpdateDayCountFields(null, date.Today().addDays(-1), date.Today().addDays(1));
    }
    
	////////////// 
	/// UNIT TEST
	////////////////
	static testmethod void test() {
		Test.startTest();

		System.schedule('Test Update Days in Program', '0 30 1 * * ?', new jobUpdateNumberofDaysinProgram_Scheduler());

		Test.stopTest();
	}     

}