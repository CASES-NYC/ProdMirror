public class ModuleHelper
{
    boolean HasErrors = false;
    public void CheckText(string TextToCheck,string FieldName)
    {       
        if(!ErrorHandler.IsValueValid(TextToCheck))
        {            
           ErrorHandler.showError('Please enter a valid ' + FieldName);
           HasErrors=true;
        }
    }    
    
    private void showError(string MessageToShow, string defaultMsg)
    {
        if(ErrorHandler.IsValueValid(MessageToShow))
        {
            ErrorHandler.showError(MessageToShow);
        }
        ErrorHandler.showError(defaultMsg);
    }
}