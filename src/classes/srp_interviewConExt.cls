public class srp_interviewConExt {

    public Account acc {get;set;}
    public Address_Information__c addressInfo {get;set;}
    private final Contact con;

    public srp_interviewConExt(ApexPages.StandardController stdController) 
    {
        this.con = (Contact)stdController.getRecord();
        acc = new Account();
    
        // get the parent if it exists
        if ( (null!=con.Id) && (null!=con.AccountId) )
        {
            acc=[select Id, Gender__c from Account where id=:con.AccountId];
        }
        else
        {
            // no parent exists - create one
            acc=new Account();
        }
        
        try {
            addressInfo = [select Id, Building_No__c, Street__c, Apt_No__c,
                        Zip_Code__c, City__c, State__c, Address_Type__c, Type_of_Housing__c,
                        Move_In_Date__c, Number_of_Months__c, Home_Phone__c, 
                        Contact_Person__c, Relation_to_Client_Other__c, Currently_living_in_NYC__c 
                       FROM Address_Information__c WHERE Client__c = :con.Id AND Address_Type__c = 'Primary' LIMIT 1];
        }
        catch (System.QueryException e) {
            System.debug('caught ya!');
        }                
    }

    public pageReference saveThis()
    {        
        try
        {
            con.Client_Status__c = 'Awaiting Decision';
            con.Interview_Stage__c = 'Complete';
            con.Screening_Stage__c = 'Pending Intake/Needs';
            update con;
            update acc;
            update addressInfo;
            return (new PageReference('/' + con.id));             
        }
        catch(Exception ex)
        {
            System.debug('\n\nException ='+ex.getMessage()+'\n\n');
        }
        return null;
    }

}