trigger eventLogic on Event (before insert, before update, after insert, after update, 
before delete, after delete, after undelete) {

    public eventMethods eventMethods = new eventMethods();
    public utilityMethods utilMethods = new utilityMethods();
    public utilityIds utilIds = new utilityIds();
    public Boolean isOff = TriggerSupport__c.getValues('Event').TriggerOff__c;
    

    if(trigger.isDelete) 
    {
        eventMethods.newEvents = trigger.old;
    } else {
        eventMethods.newEvents = Trigger.New;
        eventMethods.mapOldEvents = Trigger.oldMap;
    }
    eventMethods.bolInsert = trigger.isInsert;
    eventMethods.getWhoIds();
    
    // determine if Skip Triggers is true for any of the events
    // and if so, skip most logic
    system.debug(URL.getCurrentRequestUrl().toExternalForm());

    if((userInfo.getProfileId() ==Utility_ID__c.getValues('System Administrator').RecordType_Id__c
    || URL.getCurrentRequestUrl().toExternalForm().toLowerCase().contains('programreportschedulepage'))
    && utilityIds.bolSkipTriggersAlreadyChecked != true) {
        
        if(trigger.isInsert || Trigger.isUpdate) 
        {
            for(event e: trigger.New) 
            {
                if(e.Skip_Triggers__c == true) 
                {    
                    utilityIds.bolSkipEventTriggers = true;
                    break;          
                }       
            }       
        }
        
        if(trigger.isDelete) 
        {
            for(event e: trigger.Old) 
            {
                if(e.Skip_Triggers__c == true) 
                {
                    utilityIds.bolSkipEventTriggers = true;
                    break;          
                }       
            }
        }
        
        // set this so we don't have to run this again if the code performs another event DML
        utilityIds.bolSkipTriggersAlreadyChecked = true;
    }
    
    // 3/26/13 MB: these must be run even if triggers are being skipped,
    // since this flag is now used in the "schedule program reporting" page
    // to create appointment series (which can only be inserted one at a time)
    if(!trigger.isDelete)
    {
        for (Event e : trigger.new)
        {
        String ownerId = String.ValueOf(e.OwnerId);
        if(ownerid.substring(0,3) <> '023')
        {  
            if(trigger.isInsert || trigger.isUpdate) 
            {
                if(trigger.isBefore) 
                {      
                    eventMethods.setBeforeFields(); 
                    // 11-07-2016 PR disabled mapunit which is used only for blockupdates.
                    //eventMethods.mapUnit();     
                    eventMethods.setVerificationDueDate();  
                }   
            }
        }
     }
     }
   
    if(utilityIds.bolSkipEventTriggers != true) 
    {
        if(trigger.isUpdate || trigger.isInsert) 
        {
            if(trigger.isBefore) 
            {
                if(trigger.isUpdate) 
                {
                    //10-17-2016: PR disabled blockupdates as part of simplifying profile permissions
                    // Only users of the same unit, assigned to , deputy director, or director can upate an event                   
                    // eventMethods.blockUpdates();
                    
                    //per request from Quinn, saving history of verification status changes
                    eventMethods.checkVerificationStatusChange();
               
                }
                    
                // Only certain subjects are acceptable due to their reporting requirements
                eventMethods.processSubjects();         
                
                // Only certain people can verify appts
                eventMethods.processEventVerification();
                
                //added 10/16/13 MB to allow limited native corrections to Course Catalog attendance
                eventMethods.validateClassAttendance(); 
                
                //added back 4/19/15 MB. Was accidentally removed sometime in early 2015.
                //this is necessary to close Career Ex Referral and Mandatory Class tasks correctly
                //since the tasks are edited in the processEventVerification() method which only runs Before
                eventMethods.massDML();
                
                // Turn all the skip restrictions off
                // This must be the last Before method called.    
                eventMethods.resetSkipRestrictions();         
            }
            
            if(trigger.isAfter) 
            {                            
                // Inserts Only 
                if(trigger.isInsert) 
                {    
                    //added 8/12/13 MB
                    // create linked Progress Note for CCM
                    eventMethods.editProgressNote(trigger.NewMap.keySet());
                
                    // Process CC / PS CRS Events
                    eventMethods.validateCourtDates();
                    eventMethods.setNextCourtDate();
                    
                    // Process PS PN Events
                    utilMethods.createPSCRSNoteTask(trigger.new,null);
                    utilMethods.createPSProgressNoteTask(trigger.new, null);
                    //10/21/13 MB added handling for career ex interview appts inserted as attended
                    //eventMethods.checkForCareerExStage();
                    utilMethods.closeEdVisitTaskAll(trigger.New, null, trigger.isInsert);           
            
                } else 
                    if(trigger.isUpdate) 
                    {
                        //added 8/12/13 MB
                        // create linked Progress Note for CCM
                        eventMethods.editProgressNote(trigger.NewMap.keySet());                 
                    
                        // note tasks
                        eventMethods.validateCourtDates();
                        eventMethods.setNextCourtDate();
                        eventMethods.editNoteTask();
                        utilMethods.closeCCCRSNoteTaskAll(trigger.new);
                        utilMethods.closePSCRSNoteTaskAll(trigger.new);
                        utilMethods.closeCCPNNoteTaskAll(trigger.new);
                        utilMethods.closeEdVisitTaskAll(trigger.New, trigger.Old, trigger.isInsert);
                    
                        // Career Ex
                        //eventMethods.checkForCareerExStage();
                    }
                
                // Always process these
                eventMethods.setMandatorySessionsCounter();
                eventMethods.setChoicesComplianceCounter();
                eventMethods.createProgramRelationship();
                if(! isOff) eventMethods.checkForDuplicates();
                eventMethods.checkForIntakes();
                eventMethods.massDML();
                
            }
            
        }
        
        if(trigger.isDelete) 
        {    
            if(trigger.isBefore) 
            {
                for (Event e : Trigger.old)
                {    
                    //Make exception for Sys Admins
                    if(UserInfo.getProfileId() != Utility_ID__c.getValues('System Administrator').RecordType_Id__c) 
                    {
                        if (e.RecordTypeId == Utility_ID__c.getValues('Court Date').RecordType_Id__c)
                        {
                            e.addError('Court dates cannot be deleted.  Set this date to Cancelled instead.' );
                        } else 
                            if (e.RecordTypeId ==Utility_ID__c.getValues('Orientation Appointment').RecordType_Id__c)
                            {
                                e.addError('Orientation appointments cannot be deleted.  Set this date to Cancelled instead.');
                            }
                    }
                }
                    
            } else 
                if(trigger.isAfter) 
                {
                    eventMethods.setNextCourtDate();
                    eventMethods.setMandatorySessionsCounter();
                    eventMethods.setChoicesComplianceCounter();  
                    eventMethods.massDML(); 
                }
        }         
    }
}