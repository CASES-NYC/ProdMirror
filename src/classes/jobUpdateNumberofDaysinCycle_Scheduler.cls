global class jobUpdateNumberofDaysinCycle_Scheduler  implements Schedulable{
	
	global static string scheduleJob(string runTime) {
		
		jobUpdateNumberofDaysinCycle_Scheduler j = new jobUpdateNumberofDaysinCycle_Scheduler();
		return system.schedule('Update Number of Days in Cycles', runTime ,j);
	}
	
	
	global void execute(SchedulableContext ctx) {
       
		jobUpdateNumberofDaysinCycle job = new jobUpdateNumberofDaysinCycle();
		job.UpdateDayCounts(null, date.Today().addDays(-1), date.Today().addDays(1));
    }
    
	////////////// 
	/// UNIT TEST
	////////////////
	static testmethod void test() {
		Test.startTest();

		System.schedule('Test Update Days in Cycle', '0 30 1 * * ?', new jobUpdateNumberofDaysinCycle_Scheduler());

		Test.stopTest();
	}     

}