global class pluginEditAppointmentTime implements Process.Plugin {

    global Process.PluginResult invoke(Process.PluginRequest prRequest) {
        
        //get date
        DateTime dtimeInputDate = (DateTime) prRequest.inputParameters.get('dteDate');
        Date dteDate = Date.newInstance(dtimeInputDate.year(), dtimeInputDate.month(), dtimeInputDate.day());
        
        //get time text
        String strTime = (String) prRequest.inputParameters.get('strTime');
        datetime dtimeAssembled = datetime.newInstance(dtimeInputDate.year(),dtimeInputDate.month(),dtimeInputDate.day(),
        Integer.valueOf(strTime.mid(0,2)),Integer.valueOf(strTime.mid(2,2)),0);
        
        //get event
        String strId = (String) prRequest.inputParameters.get('strId');
        
        Map<String,Object> mapResult = new Map<String,Object>();
        
        Event e = [select id, ActivityDate, ActivityDateTime from Event where id =:strId];
        
        e.ActivityDate = dteDate;
        e.ActivityDateTime  = dtimeAssembled;
        
        system.debug(e.activityDateTime);
        
        update e;
        
        mapResult.put('strId', strId);
        
        return new Process.PluginResult(mapResult);
        
    }
    
    global Process.PluginDescribeResult describe() {
        
        Process.PluginDescribeResult pdrResult = new Process.PluginDescribeResult();
        pdrResult.Name = 'pluginEditAppointmentTime';
        pdrResult.Tag = 'APEX Helpers - START';
        pdrResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.inputParameter('dteDate',Process.PluginDescribeResult.ParameterType.DATE, true),
            new Process.PluginDescribeResult.inputParameter('strTime',Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.inputParameter('strId',Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        pdrResult.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> { 
            new Process.PluginDescribeResult.OutputParameter('strId', Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return pdrResult;
        
    }

}