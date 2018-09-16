global class pluginQueryAttachedMandates implements Process.Plugin {

    global Process.PluginResult invoke(Process.PluginRequest prRequest) {
        
        //get contact
        String strDocket = (String) prRequest.inputParameters.get('docketId');
        
        String MandateList = '';
        Integer MandateCounter = 0;
        
        List<Case_Information__c> lstCases = [select Name, Original_Mandate__c
                                                from Case_Information__c 
                                                where Master_Intake_Docket__c = :strDocket];        
        
        for(Case_Information__c ci: lstCases) {
            
            MandateList += ci.Name + ', Mandate: ' + ci.Original_Mandate__c + '\n\n';
            MandateCounter += integer.valueOf(ci.Original_Mandate__c);
        }
        
        Map<String,Object> mapResult = new Map<String,Object>();
        
        mapResult.put('MandateList', MandateList);
        mapResult.put('MandateCounter', MandateCounter);
        
        return new Process.PluginResult(mapResult);
        
    }
    
    global Process.PluginDescribeResult describe() {
        
        Process.PluginDescribeResult pdrResult = new Process.PluginDescribeResult();
        pdrResult.Name = 'pluginQueryAttachedMandates';
        pdrResult.Tag = 'APEX Helpers - START';
        pdrResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.inputParameter('docketId',Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        pdrResult.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> { 
            new Process.PluginDescribeResult.OutputParameter('MandateList',Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('MandateCounter',Process.PluginDescribeResult.ParameterType.INTEGER)
        };
        
        return pdrResult;
        
    }

}