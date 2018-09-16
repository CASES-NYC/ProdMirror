global class pluginGetCurrentUser implements Process.Plugin {

    global Process.PluginResult invoke(Process.PluginRequest prRequest) {
        
        
        Map<String,Object> mapResult = new Map<String,Object>();        
        mapResult.put('userId', UserInfo.getUserId());  
        return new Process.PluginResult(mapResult);
        
    }
    
    global Process.PluginDescribeResult describe() {
        
        Process.PluginDescribeResult pdrResult = new Process.PluginDescribeResult();
        pdrResult.Name = 'pluginGetCurrentUser';
        pdrResult.Tag = 'APEX Helpers - General';
        pdrResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
        };
        pdrResult.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> { 
            new Process.PluginDescribeResult.OutputParameter('userId', Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return pdrResult;
        
    }

}