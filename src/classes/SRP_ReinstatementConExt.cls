public class SRP_ReinstatementConExt {

    public Program_Cycle__c progCycle {get;set;}  
    private final Contact con;
    public String checkParam {get;set;}
    public Decimal mandatedDays {get;set;}
    public Decimal completedDays {get;set;}

    public SRP_ReinstatementConExt(ApexPages.StandardController stdController) 
    {
        if (!Test.isRunningTest())
        {
            stdController.addFields(new List<String>{'Most_Recent_Program_Cycle__c','Most_Recent_Program_Cycle__r.End_Date__c',
                'Most_Recent_Program_Cycle__r.Mandatory_Sessions_Required__c','Most_Recent_Program_Cycle__r.Mandatory_Sessions_Completed__c'});        
        }

        this.con = (Contact)stdController.getRecord();
        checkParam = 'not Ok!';
        progCycle = new Program_Cycle__c();
        
        if ( null==con.Most_Recent_Program_Cycle__c )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Client does not have a previous program cycle.  Cannot reinstate.'));
        }
        else if (null == con.Most_Recent_Program_Cycle__r.End_Date__c)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Previous program cycle was not ended.  Cannot reinstate.')); 
        else{
            mandatedDays = con.Most_Recent_Program_Cycle__r.Mandatory_Sessions_Required__c;
            completedDays = con.Most_Recent_Program_Cycle__r.Mandatory_Sessions_Completed__c;
            
        }
                 
    }
    

    public pageReference cancelThis()
    {
        checkParam = 'Ok!';
        return null;
    }
    public pageReference saveThis()
    {        
        try
        {
            progCycle.Client__c = con.id;
            progCycle.Cycle_Type__c = 'Reinstatement';
            progCycle.Mandatory_Sessions_Required__c = mandatedDays;
            progCycle.Mandatory_Sessions_Completed__c = completedDays;
            if (con.recordtypeID == Utility_Id__c.getValues('DTC Client').Recordtype_Id__c) 
               
                progCycle.RecordTypeId = Utility_Id__c.getValues('DTC Cycle').RecordType_Id__c;
            else if (con.recordtypeID == Utility_Id__c.getValues('CCM Client').Recordtype_Id__c)
                
                progCycle.RecordTypeId = Utility_Id__c.getValues('CCM Cycle').RecordType_Id__c;
            else if (con.recordtypeID == Utility_Id__c.getValues('ONE Client').Recordtype_Id__c) 
                
                progCycle.RecordTypeId = Utility_Id__c.getValues('ONE Cycle').RecordType_Id__c;
            else if (con.recordtypeID == Utility_Id__c.getValues('CEO Client').Recordtype_Id__c) 
                
                progCycle.RecordTypeId = Utility_Id__c.getValues('CEO Cycle').RecordType_Id__c;
            else if (con.recordtypeID == Utility_Id__c.getValues('SRP Client').Recordtype_Id__c) 
                
                progCycle.RecordTypeId = Utility_Id__c.getValues('SRP Program Cycle').RecordType_Id__c;
            else if (con.recordtypeID == Utility_Id__c.getValues('CCI START Client').Recordtype_Id__c)
            
                progCycle.RecordTypeId = Utility_Id__c.getValues('CCI START Cycle').Recordtype_Id__c;
            
                else
                progCycle.RecordTypeId = Utility_Id__c.getValues('SRP Program Cycle').RecordType_Id__c;

            insert progCycle;

        }
        catch (Exception ex)
        {
            System.debug('\n\nException ='+ex.getMessage()+'\n\n');        
        }

        
        try
        {
            con.Client_Status__c = 'Active';
            con.Current_Intake_Date__c = progCycle.Start_Date__c;
            con.Most_Recent_Program_Cycle__c = progCycle.Id;            
            update con;
            //return (new PageReference('/' + con.id));             
        }
        catch(Exception ex)
        {
            System.debug('\n\nException ='+ex.getMessage()+'\n\n');
        }
        checkParam = 'Ok!';
        return null;
    }
}