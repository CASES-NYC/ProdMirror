global class pluginFaultHandling implements Process.Plugin {

    global Process.PluginResult invoke(Process.PluginRequest prRequest) {
        
        //get time text
        String strFault = (String) prRequest.inputParameters.get('strFault');
        String strDML = (String) prRequest.inputParameters.get('strDML');
        String strFlow = (String) prRequest.inputParameters.get('strFlow');
        String strContact = (String) prRequest.inputParameters.get('strContact');
        
        String strEmailText = strFlow + 'Flow error! \nTime ' + system.now().format() + '\nUser: '
        + UserInfo.getName() + '\nDML process: ' + strDML + '\nContact: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' 
        + strContact + '\n\nError message: ' + strFault + '\n\nHappy hunting!';
        
        list<String> lstEmails = new list<String>();
        lstEmails.add('probinson@cases.org');
        lstEmails.add('mmillan@cases.org');
        
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        mail.setToAddresses(lstEmails);
        mail.setSubject('Flow Error');
        mail.saveAsActivity = false;
        mail.setPlainTextBody(strEmailText);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
            
        Map<String,Object> mapResult = new Map<String,Object>();
        
        mapResult.put('strFault', strFault);
        
        return new Process.PluginResult(mapResult);
        
    }
    
    global Process.PluginDescribeResult describe() {
        
        Process.PluginDescribeResult pdrResult = new Process.PluginDescribeResult();
        pdrResult.Name = 'pluginFaultHandling';
        pdrResult.Tag = 'APEX Helpers - START';
        pdrResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.inputParameter('strFault',Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.inputParameter('strDML',Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.inputParameter('strFlow',Process.PluginDescribeResult.ParameterType.STRING, true),                     
            new Process.PluginDescribeResult.inputParameter('strContact',Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        pdrResult.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> { 
            new Process.PluginDescribeResult.OutputParameter('strFault', Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return pdrResult;
        
    }

}