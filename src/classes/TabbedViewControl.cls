public with sharing class TabbedViewControl
{
    public boolean input { get; set; }
    public String selecttab1 { get; set; }
    public boolean output { get; set; }
    public Referral__c r { get; set; }

    public TabbedViewControl()
    {
        selecttab1 ='per';
        r= new Referral__c();
        output=false;
        input=true;
    }
     
    public PageReference next1() 
    {
        selecttab1 ='add12';
        return null;
    }

    public PageReference save() 
    {
        insert r;
        output=true;
        input=false;
        return null;
    }
}