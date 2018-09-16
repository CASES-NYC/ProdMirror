@isTest(SeeAllData=true)
private class flowCalc_UnitTest {

    static testMethod void testClosingComplianceDate() {        
        
        // Declare Vars
        flowCalcClosingComplianceDate vwfDate = new flowCalcClosingComplianceDate();
        Map<String, Object> mapInputParams = new Map<String, Object>();
        Map<String, Object> mapOutputParams = new Map<String, Object>();
        
        // Test describe
        Process.PluginDescribeResult pdrResult = vwfDate.describe();        
        
        // Fill Input Map
        mapInputParams.put('dteDate', System.Today());
        mapInputParams.put('intDays', 15);
        mapInputParams.put('intMethod', 2);
        
        // Submit to Process.Plugin
        Process.PluginRequest prRequest = new Process.PluginRequest(mapInputParams);
        Process.PluginResult prResult;
        
        try {
            prResult = vwfDate.invoke(prRequest);
        } catch(Exception e) {
            System.Debug(LoggingLevel.ERROR, 'EXCEPTION - ' + string.valueOf(e));
            System.AssertEquals(1,2);
        }
    }
}