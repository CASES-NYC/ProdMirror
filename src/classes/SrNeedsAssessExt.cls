public class SrNeedsAssessExt
{

    public Address_Information__c addressInfo {get;set;}
    public String contactID {get; set;}
    public String contactName {get; set;}
    public Id assBJMHSRecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('BJMHS').getRecordTypeId();
    public Id assPHQ9RecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('PHQ-9').getRecordTypeId();
    public Id assPHQ9RORecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('PHQ-9 - Read Only').getRecordTypeId();
    public Id assPHQ9TRecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('PHQ-9 Teen').getRecordTypeId();
    public Id assTCURecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('TCU').getRecordTypeId();
    public Id assCRAFFTRecTypeId = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('CRAFFT').getRecordTypeId();
    public Id assSRPNeedsIntake = Schema.SObjectType.Assessment__c.getRecordTypeInfosByName().get('SR Intake Needs Assessment').getRecordTypeId();     
    public Boolean BJMHS_Completed;
    public Boolean CRAFFT_Completed;   
    public Boolean PHQ9_Completed;
    public Boolean PHQ9T_Completed;
    public Boolean TCU_Completed;
    public String isAdult;
    public String newPageString = '/a0U/e?nooverride=1';

    private final SR_Intake_Needs_Assessment__c srNeeds;
    

    public SrNeedsAssessExt(ApexPages.StandardController stdController)
    {
        this.srNeeds = (SR_Intake_Needs_Assessment__c)stdController.getRecord();
        contactName = srNeeds.Participant__r.Name ;
        contactId = srNeeds.Participant__c;
        addressInfo = new Address_Information__c();
    }

    public void initialize()
    {
    }
    
    public List<SelectOption> getTypes()
    {
        Schema.sObjectType sobject_type = SR_Intake_Needs_Assessment__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Level_of_Social_Support__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) 
        {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    public List<SelectOption> getSupportLevel()
    {
        Schema.sObjectType sobject_type = SR_Intake_Needs_Assessment__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Level_of_Social_Support__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) 
        {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    

    public List<SelectOption> getEducationLevel()
    {
        Schema.sObjectType sobject_type = SR_Intake_Needs_Assessment__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Highest_Level_of_Education__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) 
        {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
   
    public boolean getBJMHS_Completed()
    {
        List<Assessment__c> bjmhs = [SELECT Id FROM Assessment__c WHERE RecordTypeId = :assBJMHSRecTypeId 
                    AND Contact__c = :srNeeds.Participant__c];
        if(bjmhs.size()>0)
            bjmhs_completed = false;
        else
            bjmhs_completed = true;
        return BJMHS_Completed;
    }
    
    public void setBJMHS_Completed(boolean bjmhs)
    {
        BJMHS_Completed = bjmhs;
    }

    public boolean getCRAFFT_Completed()
    {
        List<Assessment__c> crafft = [SELECT Id FROM Assessment__c WHERE RecordTypeId = :assCRAFFTRecTypeId 
                    AND Contact__c = :srNeeds.Participant__c];
        if(crafft.size()>0)
            crafft_completed = false;
        else
            crafft_completed = true;
        return CRAFFT_Completed;
    }

    public void setCRAFFT_Completed(boolean crafft)
    {
        crafft_Completed = crafft;
    }

    public boolean getPHQ9_Completed()
    {
        List<Assessment__c> PHQ9 = [SELECT Id FROM Assessment__c WHERE (RecordTypeId = :assPHQ9RecTypeId OR RecordTypeId = :assPHQ9RORecTypeId)
                    AND Contact__c = :srNeeds.Participant__c];
        if(phq9.size()>0)
            phq9_completed = false;
        else
            phq9_completed = true;
        return PHQ9_Completed;
    }

    public void setPHQ9_Completed(boolean phq9)
    {
        phq9_Completed = phq9;
    }

    public boolean getPHQ9T_Completed()
    {
        List<Assessment__c> PHQ9T = [SELECT Id FROM Assessment__c WHERE RecordTypeId = :assPHQ9TRecTypeId
                    AND Contact__c = :srNeeds.Participant__c];
        if(phq9t.size()>0)
            phq9t_completed = false;
        else
            phq9t_completed = true;
        return PHQ9T_Completed;
    }

    public void setPHQ9T_Completed(boolean phq9t)
    {
        phq9t_Completed = phq9t;
    }

    public boolean getTCU_Completed()
    {
        List<Assessment__c> TCU = [SELECT Id FROM Assessment__c WHERE RecordTypeId = :assTCURecTypeId 
                    AND Contact__c = :srNeeds.Participant__c];
        if(tcu.size()>0)
            tcu_completed = false;
        else
            tcu_completed = true;
        return TCU_Completed;
    }

    public void setTCU_Completed(boolean tcu)
    {
        tcu_Completed = tcu;
    }
    
    public String getIsAdult()
    {
        if(srNeeds.Participant__r.Current_Age__c > 18)
            isAdult = 'YES';
        else
            isAdult = 'NO';
        return isAdult;
    }
    
    public void setIsAdult(string adult)
    {
        isAdult = adult;
    }



    // action method to save the account and contact
    public PageReference save()
    {
        if(null!=addressInfo.Street__c)
        {       
            if(null==addressInfo.Zip_Code__c)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Zip Code required.'));
                return null;
            }
            else
            {
                List<Address_Information__c> primaryAddress = [SELECT Id FROM Address_Information__c 
                    WHERE Client__c = :srNeeds.Participant__c AND Address_Type__c = 'Primary'];
                if (primaryAddress.size()>0)        
                {
                    primaryAddress[0].Address_Type__c = 'Former Primary';
                    update primaryAddress[0];
                }        
                addressInfo.Client__c = srNeeds.Participant__c;
                addressInfo.Address_Type__c = 'Primary';
                insert addressInfo;
            }
         }   
         upsert srNeeds;

        
        PageReference pref = new PageReference('/'+ srNeeds.Participant__c);
        pref.setRedirect(true);
        return pref;
    }

    public PageReference cancel()
    {
        PageReference pageRef = new PageReference('/'+ srNeeds.Participant__r.Id);
        pageRef.setRedirect(true);
        return pageRef;    
    }
}