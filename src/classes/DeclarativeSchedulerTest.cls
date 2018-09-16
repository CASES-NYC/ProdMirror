@isTest
private class DeclarativeSchedulerTest {
    
    /**
     * When testing Reports API the test will run with SeeAllData = true, regardless the annotation here.
     * I include the annotation for clarity.
     * https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_analytics_test_reports.htm
     */
    @isTest( seeAllData = true )
    static void test_service() {

        // grab an existing report, otherwise we'd have to dynamically create one in this test and
        // I'm not entirely certain how that would be done. Metadata or Tooling API perhaps?
          String reportId;

     // Get an instance of the report
        Report reportlist = [SELECT Id FROM Report WHERE DeveloperName = 'Scheduler_Account_Example'];
        System.assert( reportlist != null, 'Please create a report and save the report with unique name Scheduler_Account_Example' );
      
        Test.startTest();
        Reports.ReportInstance reportInstance =  Reports.ReportManager.runAsyncReport(reportlist.Id, true);
        Test.stopTest(); 



       // Emulate the platform calling the custom action passing criteria that was met
        DeclarativeScheduler  DeclarativeScheduler = new DeclarativeScheduler ();     
        Reports.NotificationActionContext context  = new Reports.NotificationActionContext(
                reportInstance, 
                new Reports.ThresholdInformation( 
                    new List<Reports.EvaluatedCondition> { }));
      
        DeclarativeScheduler.execute(context);

        
        
        // ok, let's try to validate this thing... coming soon
        //System.assert( );

    }

}