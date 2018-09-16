/*
 * Block comments with details of changes
 */
public class srpSupervisionLevelExt
{
    public String contactID {get; set;}
    public String contactName {get; set;}
    private final Contact srpCon;
    
    public srpSupervisionLevelExt(ApexPages.StandardController stdController  )
    {
        this.srpCon = (Contact)stdController.getRecord();
        contactName = srpCon.Name ;
        contactId = srpCon.Id;        
    }
    
    public PageReference save()
    {   
        List<Program_Cycle__c> progCycleList = new List<Program_Cycle__c>();
        progCycleList = [SELECT Id, Most_Recent_Tier__c FROM Program_Cycle__c 
                         WHERE Client__c = :srpCon.Id AND Most_Recent_Program_Cycle_Formula__c = TRUE LIMIT 1];
        if (progCycleList.size() > 0) 
        {
            Tier__c tier = null;
            try
            {
                tier = [SELECT Id, Tier__c FROM Tier__c WHERE Id = :progCycleList[0].Most_Recent_Tier__c];
            } catch (System.QueryException qe)
                {
                    system.debug (' *** No tier record found! *** ');
                }
            if (tier != null)
            {
                tier.Tier__c = srpCon.Supervision_Level__c;
                update Tier;
            }
        } else { system.debug (' *** No program cycle record found! *** ');}
        
        upsert srpCon;

        
        PageReference pref = new PageReference('/'+ srpCon.Id);
        pref.setRedirect(true);
        return pref;
    }

    public PageReference cancel()
    {
        PageReference pageRef = new PageReference('/'+ srpCon.Id);
        pageRef.setRedirect(true);
        return pageRef;    
    }
}