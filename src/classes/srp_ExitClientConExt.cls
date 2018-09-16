Public class srp_ExitClientConExt 
{

    public PageReference cancel() {
        return null;
    }

    public Program_Cycle__c pcc {get;set;}
    public Case_Information__c caseInfo {get; set;}
    public Case_Relationship__c caseRel {get; set;}
    public Tier__c tier {get; set;}
    public Contact con {get; set;}
    String contactId {get;set;}


    public srp_ExitClientConExt() 
    { 
        contactId = ApexPages.currentPage().getParameters().get('Id');

        if(!String.IsBlank(contactId))
        {
        
            con = new Contact();
            con = [SELECT Id, P_C_ID__c, Intake_Case__c FROM Contact WHERE Id = :contactId];
               
            pcc = new Program_Cycle__c();
            pcc=[SELECT Id, Client__c, Start_Date__c, End_Date__c, Exit_Reason__c, Exit_Reason_Other__c, Exit_Type__c,
             Cycle_Type__c, Most_Recent_Tier__c  
             FROM Program_Cycle__c WHERE Client__c = :con.Id AND Most_Recent_Program_Cycle_Formula__c = TRUE]; 
   
            tier = new Tier__c();
            tier = [SELECT Id, End_Date__c FROM Tier__c WHERE Id = :pcc.Most_Recent_Tier__c];
           
            caseRel = new Case_Relationship__c();
system.debug('INTAKE CASE: ' + con.Intake_Case__c);
if (con.Intake_case__c != NULL)
{ 
            caseRel = [SELECT Id, Docket__c, Case_Status_at_Exit__c, Sentence_Coordinated_with_SRP__c 
                FROM Case_Relationship__c WHERE Contact__c = :con.Id AND Docket__c = :con.Intake_Case__c];
}
            caseInfo = new Case_Information__c();
            caseInfo=[SELECT Id, Name, Case_Status_at_Exit__c, Disposition__c, Client_Account__c, Sentence_Disposition_Date__c, Sentence_Type__c, Sentence__c  
                FROM Case_Information__c WHERE Id= :caseRel.Docket__c];
system.debug('CASEINFO: ' + caseInfo);

        }
    }

    public pageReference saveThis()
    {     
            con.Client_Status__c = 'Exited';
            update con;
            update caseInfo;
            upsert caseRel;
            update pcc;
            
            tier.End_Date__c = pcc.End_Date__c;
            update tier;
            return (new PageReference('/' + con.Id));  
    }
}