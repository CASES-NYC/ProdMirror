public with sharing class srpOutcomeScreenCon 
{
	public string portalName{get;set;}
    public Event thisCourtDate {get;set;}
    public Case_Information__c thisCase {get;set;}
    public Program_Cycle__c newProgCycle {get;set;}
    public Tier__c newTier {get;set;}
    public Event nextCourtDate {get;set;}   
    public Contact thisContact {get;set;}
    public String contactID = ApexPages.currentPage().getParameters().get('contact');
    public String caseID = ApexPages.currentPage().getParameters().get('caseId');   
    public Id progCycleSRP = Utility_ID__c.getValues('SRP Program Cycle').RecordType_Id__c;
    public Id tierSRP = Utility_ID__c.getValues('SR Tier').RecordType_Id__c;    

    public srpOutcomeScreenCon() 
    {
    	 	portalName = ApexPages.currentPage().getParameters().get('portalName');
        if (contactId != null && contactId != '')
        {
            thisContact = [SELECT Id, Screening_Stage__c, Client_Status__c, FirstName, LastName, P_C_Id__c, Intake_Date__c, Current_Intake_Date__c,
                    Judge_s_Conditions__c, Screening_Outcome_srp__c, Arraignment_Outcome__c, Intake_Case__c, Ineligible_Reason_Other__c, SR_Referral__r.Supervision_Level_Recommendation__c
                    FROM Contact WHERE Id = :contactID];
            if (caseId != null && caseId != '')
            { 
                thisCase = [SELECT Id, Judge__c, Bail_Set_Cash__c, Bail_Set_Bond__c, DA_Offer_SRP__c, DA_No_of_Days_DS__c, Bail_Recommended__c 
                    FROM Case_Information__c WHERE Id = :caseId];
            }
            newProgCycle = new Program_Cycle__c();
            newTier = new Tier__c();
            thisCourtDate =new Event();
            nextCourtDate = new Event();
        }   
    }

    public pageReference saveOutcome()
    {      
        if(thisContact.Screening_Outcome_srp__c != 'Eligible' && thisContact.Screening_Outcome_srp__c !=''&& thisContact.Screening_Outcome_srp__c !=NULL)
                    thisContact.Client_Status__c = 'Never Enrolled';            
        if(thisContact.Arraignment_Outcome__c != 'Released into Supervised Release'&& thisContact.Arraignment_Outcome__c !=''&& thisContact.Arraignment_Outcome__c !=NULL)
                    thisContact.Client_Status__c = 'Never Enrolled';
        else
            if(thisContact.Screening_Outcome_srp__c == 'Eligible' 
                && thisContact.Arraignment_Outcome__c == 'Released into Supervised Release')
            {
                thisContact.Client_Status__c = 'Active';
                thisContact.Current_Intake_Date__c = thisContact.Intake_Date__c;
                newProgCycle.RecordTypeId = progCycleSRP;              
                newProgCycle.Client__c = thisContact.Id;
                newProgCycle.Cycle_Type__c = 'Intake';
                newProgCycle.Start_Date__c = thisContact.Intake_Date__c;
                insert newProgCycle;
                
                Tier__c thisTier = new Tier__c();
                thisTier.RecordTypeId = tierSRP;
                thisTier.Contact__c = thisContact.Id;
                thisTier.Program_Cycle__c = newProgCycle.Id;
                thisTier.Reason_for_Tier_Change__c = 'Intake Tier';
                thisTier.Start_Date__c = thisContact.Intake_Date__c;
                String suplvl = thisContact.SR_Referral__r.Supervision_Level_Recommendation__c;
                system.debug('suplvl: ' + suplvl);
                thisTier.Tier__c = suplvl;
                insert thisTier;
                update thisCase;
            }
        update thisContact;
        updateCourtDate();
        PageReference prRef;
        if (portalName != null)
           prRef = new PageReference('/apex/allCourtsPage');
        else
           prRef = new PageReference('/apex/courtPortal_srp');
        prRef.setRedirect(true);
        return prRef; 
                    
    }

    public void doNothing() { }

    public pageReference goPortal() 
    {
        
          PageReference prRef;
        if (portalName != null)
           prRef = new PageReference('/apex/allCourtsPage');
        else
           prRef = new PageReference('/apex/courtPortal_srp');
        prRef.setRedirect(true);
        return prRef;       
    } 
    
    
    public void updateCourtDate() 
    {
        
        if(nextCourtDate.ActivityDate != null) 
        {
            try 
            { 
                nextCourtDate.whoId = thisContact.Id;
                nextCourtDate.Subject = 'Court Date';
                nextCourtDate.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Court Date').getRecordTypeId();
                nextCourtDate.WhatId = thisContact.Intake_Case__c; 
                nextCourtDate.DurationInMinutes = 60;
                nextCourtDate.Court_Date_Type__c = 'Adjournment';    
                nextCourtDate.ActivityDateTime = 
                    DateTime.newInstance(nextCourtDate.ActivityDate, Time.newInstance(12,0,0,0));
                    
                insert nextCourtDate;                
            }
            catch(Exception e) 
            {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            }
        
        }
    }
}