public with sharing class assessmentDispatchExt
{
    public String retURL = ApexPages.currentPage().getParameters().get('retURL');
    private final Assessment__c assessDispatch;
    public PageReference pageRef;


    public assessmentDispatchExt(ApexPages.StandardController stdController) 
    {
        stdController.addFields(new List<String>{'ChildObjectId__c'});        
        this.assessDispatch = (Assessment__c)stdController.getRecord();
        system.debug('ASSESSDISPATCH: ' + assessDispatch);
    }

    public pageReference initialize()
    {
        if(assessDispatch.Id == null)
        {
            String contactId = ApexPages.currentPage().getParameters().get('contactId');
            Id rtype = ApexPages.currentPage().getParameters().get('RecordType');
            String recordTypeName = [Select Name from RecordType where Id=:rtype LIMIT 1][0].Name;
            assessDispatch.Contact__c = contactId;

            assessDispatch.RecordTypeId = rtype;
            insert assessDispatch;
          
            if (recordTypeName == 'SR Intake Needs Assessment')
            {
                SR_Intake_Needs_Assessment__c srNeeds = New SR_Intake_Needs_Assessment__c();
                srNeeds.AssessmentID__c =assessDispatch.Id;
                srNeeds.Participant__c = assessDispatch.Contact__c;
                insert srNeeds;
                assessDispatch.SR_Intake_Needs__c = srNeeds.Id;
                assessDispatch.ChildObjectId__c = srNeeds.Id;
                pageRef= new PageReference('/'+ assessDispatch.SR_Intake_Needs__c + '/e');
                system.debug('pageRefSR: ' + pageRef);
            } else if (recordTypeName == 'Life Events Checklist (LEC)')
                {
                    Life_Events_Checklist__c lec = New Life_Events_Checklist__c();
                    lec.AssessmentID__c =assessDispatch.Id;
                    lec.Participant__c = assessDispatch.Contact__c;
                    insert lec;
                    assessDispatch.ChildObjectId__c = lec.Id;
                    pageRef= new PageReference('/'+ lec.Id + '/e');
                    system.debug('pageRefLEC: ' + pageRef);
                    assessDispatch.ChildObjectId__c = lec.Id;
                } else if (recordTypeName == 'Health and Wellbeing Assessment')
                    {
                        Health_and_Wellbeing_Assessment__c hwb = New Health_and_Wellbeing_Assessment__c();
                        hwb.AssessmentID__c =assessDispatch.Id;
                        hwb.Participant__c = assessDispatch.Contact__c;
                        insert hwb;
                        assessDispatch.ChildObjectId__c = hwb.Id;
                        pageRef= new PageReference('/'+ hwb.Id + '/e');
                        system.debug('pageRefHwb: ' + pageRef);
                        assessDispatch.ChildObjectId__c = hwb.Id;
                    }

            assessDispatch.ChildRecordType__c = recordTypeName;            
            update assessDispatch;
        }
        pageRef= new PageReference('/'+ assessDispatch.ChildObjectId__c + '/e');
        system.debug('pageRef: ' + pageRef);
        pageRef.setRedirect(true);
        return pageRef;
    }

}