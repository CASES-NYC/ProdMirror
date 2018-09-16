public class ErrorHandler
{
 
//Custom Method to check valid value (not null) for Object 
    public static boolean IsValueValid(object TheValue)
    {
        boolean toReturn=false;
        if(TheValue!=null)
        {
            string sval=String.valueOf(TheValue);            
            toReturn=!String.isBlank(sval);
        }
        return toReturn;
    }

    public static void showMsg(ApexPages.Severity sev, String message)
    {
        ApexPages.Message msg = 
            new ApexPages.Message(sev, message);
        ApexPages.addMessage(msg);
    }
    public static void showConfirm(String conf)
    {
         showMsg(ApexPages.Severity.Confirm,conf);
    }
    public static void showInfo(String info)
    {
        showMsg(ApexPages.Severity.Info,info);
    }
    
    public static void showWarning(String warn)
    {
        showMsg(ApexPages.Severity.Warning,warn);
    }
    
    public static void showError(String err)
    {
       showMsg(ApexPages.Severity.Error,err);
    }
}