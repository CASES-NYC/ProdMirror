global class flowCalcClosingComplianceDate implements Process.Plugin {

    global Process.PluginResult invoke(Process.PluginRequest prRequest) {
        
        utilityMethods utils = new utilityMethods();
        
        DateTime dteTime = (DateTime) prRequest.inputParameters.get('dteDate');
        Date dteDate = Date.newInstance(dteTime.year(), dteTime.month(), dteTime.day());
        Decimal decDays = (Decimal) prRequest.inputParameters.get('intDays');
        Integer intDays = decDays.intValue();
        Decimal decMethod = (Decimal) prRequest.inputParameters.get('intMethod');
        Integer intMethod = decMethod.intValue();
        
        Map<String,Object> mapResult = new Map<String,Object>();
        Date dteResult = date.newInstance(1950,1,1);
        
        // Parse out X days - business days, non-holiday.
        if(intMethod == 1) {//Calendar Days
            dteResult = utils.getNextWorkingDayFromDate(dteDate.addDays(intDays));
        } else {// intMethod == 2, Business Days
            dteResult = utilityMethods.getFutureWorkingDayFromDate(dteDate, intDays);
        }
        
        mapResult.put('Request', dteDate);
        mapResult.put('Days', intDays);
        mapResult.put('Result', dteResult);
        
        return new Process.PluginResult(mapResult);
        
    }
    
    global Process.PluginDescribeResult describe() {
        
        Process.PluginDescribeResult pdrResult = new Process.PluginDescribeResult();
        pdrResult.Name = 'flowCalcClosingComplianceDate';
        pdrResult.Tag = 'APEX Helpers - START';
        pdrResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.inputParameter('dteDate',Process.PluginDescribeResult.ParameterType.DATE, true),
            new Process.PluginDescribeResult.inputParameter('intDays',Process.PluginDescribeResult.ParameterType.INTEGER, true),
            new Process.PluginDescribeResult.inputParameter('intMethod',Process.PluginDescribeResult.ParameterType.INTEGER, true)
        };
        pdrResult.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> { 
            new Process.PluginDescribeResult.OutputParameter('Request', Process.PluginDescribeResult.ParameterType.DATE),
            new Process.PluginDescribeResult.OutputParameter('Days', Process.PluginDescribeResult.ParameterType.INTEGER),
            new Process.PluginDescribeResult.OutputParameter('Result', Process.PluginDescribeResult.ParameterType.DATE)
        };
        
        return pdrResult;
        
    }

}