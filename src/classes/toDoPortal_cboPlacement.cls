public with sharing class toDoPortal_cboPlacement {
    
    ////////////////////////////////////
    // This class manages the "CBO Placement" page subtab on the "To Do" tab
    // Demand Chain Systems
    // Modified 20110613 AAB
    // andyb@demandchainsystems.com
    ////////////////////////////////////

    public utilityIds util = new utilityIds();
    public String selectedContact;
    public String exitAdminErrors;
    public Administrative_Actions__c exitNotificationForDisplay = new Administrative_Actions__c();
    public List<Event> eventsForDisplay = new List<Event>();
    public Portal_Filter__c thisPortalFilter {get;set;}
    
    ///////////////////////////////////
    // Class Constructors and GETers
    ///////////////////////////////////
        
    public toDoPortal_cboPlacement() { thisPortalFilter = new Portal_Filter__c(); }
    
    public String getexitAdminErrors() { return exitAdminErrors; }
    
    public String getselectedContact() { return selectedContact; }

    public void setselectedContact(String selectedContact) { this.selectedContact = selectedContact; }

    public Administrative_Actions__c getExitNotifictionDetails() { return exitNotificationForDisplay; }
    
    public List<Event> getClientEvents() { return eventsForDisplay; }
    
    public List<SelectOption> getCaseload() {
        
        // Get a list of all the contacts who have a CBO
        // task that is still open
         
        List<Task> cboTasks = [Select   Id, 
                                        WhoId,
                                        Who.name 
                                        from Task 
                                        Where isClosed = false 
                                        AND recordTypeId = :util.CBOPlacementTask  
                                        Order By Who.Name ASC LIMIT 1000];          
            
        List<SelectOption> caseLoadLists = new List<SelectOption>();
        
        for(Task thisTask:cboTasks) {

            caseLoadLists.add(new SelectOption(thisTask.WhoId,thisTask.Who.Name));
        }
                

        return caseLoadLists;
    }
    
    ///////////////////////////////////
    // Action Methods
    ///////////////////////////////////
    
    public void logSearch() {

    }       
    
    public void doNothing() {
        
        eventsForDisplay.clear();
        Boolean loadTasks = false;
        
        if(selectedContact != null) {
            
            // Added 20110613 AAB per ToDo-TasksScreenDesignSpecs
            Contact curContact = [SELECT Current_Exit_Date__c FROM Contact WHERE Id = :selectedContact];
            
            if(curContact.Current_Exit_Date__c == null) {
                System.Debug('AABTEST - NULL EXIT DATE');
                thisPortalFilter.CBO_Start_Date__c = System.Today();
            } else {
                System.Debug('AABTEST - ' + curContact.Current_Exit_Date__c);
                thisPortalFilter.CBO_Start_Date__c = curContact.Current_Exit_Date__c;   
            }
            
            thisPortalFilter.CBO_Start_Date__c = thisPortalFilter.CBO_Start_Date__c.addDays(-14);
            
            // Header Information
            List<Administrative_Actions__c> exitNotificationForDisplayList = [Select    Id, 
                                                                                        Client__c,
                                                                                        Start_Date__c,
                                                                                        Community_Placement__c,
                                                                                        Action_Date__c,
                                                                                        CBO_Activity__c,
                                                                                        Placement_Status__c,
                                                                                        Activities_Engaged_in_at_Exit__c, 
                                                                                        Client__r.Name 
                                                                                        from Administrative_Actions__c 
                                                                                        Where Client__c = :selectedContact
                                                                                        AND ( recordTypeId = :util.aaExitNotification OR  recordTypeId = :util.aaExitNotificationLocked)];
        
            // Set Info Messages for ZERO Admin Actions
            if(exitNotificationForDisplayList.size() == 0) {
                
                exitNotificationForDisplay.clear();
                exitAdminErrors = '* No Administrative Action for this Client';
            }
            
            // Set Info Messages for ONE Admin Action
            if(exitNotificationForDisplayList.size() == 1) {
            
                exitNotificationForDisplay = exitNotificationForDisplayList[0];
                exitAdminErrors = '';
                loadTasks = true;
            }
            
            // Set Info Messages for MULTIPLE Admin Actions
            if(exitNotificationForDisplayList.size() > 1) {
                
                exitAdminErrors = '* Multiple Administrative Action for this Client';
                exitNotificationForDisplay = exitNotificationForDisplayList[0];
                loadTasks = true;
            }
        
            // Query and return list of applicable Tasks
            if(loadTasks) {
                
                eventsForDisplay = [Select  Subject,
                                            Open_Date__c,
                                            
                                            Verification_Status__c,
                                            OwnerId,
                                            Instructions__c,
                                            What.Name,
                                            RecordTypeId,
                                            RecordType.Name,
                                            Owner.Name 
                                            from Event
                                            Where WhoId = :selectedContact
                                            AND Open_Date__c >= :thisPortalFilter.CBO_Start_Date__c 
                                            AND (
                                                    recordTypeId = :util.educationExternal OR
                                                    recordTypeId = :util.employmentExternal OR
                                                    recordTypeId = :util.substanceAbuseExternal OR
                                                    recordTypeId = :util.mentalHealthExternal
                                                )]; 
            }
        }
    }        
}