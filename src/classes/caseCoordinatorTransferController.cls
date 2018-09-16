public class caseCoordinatorTransferController {

    public caseCoordinatorTransferController (ApexPages.StandardController controller) { }
    public utilityMethods util = new utilityMethods();
    public utilityIds utilIDs = new utilityIds();
    public List<taskWrapper> taskResults {get; set;}
    public List<eventWrapper> eventResults {get; set;}
    
    //////////////////////////////
    // Constants, Variables, etc
    //////////////////////////////
    
    string prfCaseCoordinator = utilIDs.caseCoordinatorStaff;
    string contactId = ApexPages.currentPage().getParameters().get('id');
    Contact targetContact = [SELECT c.Case_Coordinator__c, c.Id, c.Team_Leader__c FROM Contact c WHERE c.Id = :contactId];
    public string existingCoordinator;
    private final Task taskGrid;
    
    // [ If this is a new assignment, a Case Coordinator may not be assigned, but Team Leader will always be assigned. ]
    {if (targetContact.Case_Coordinator__c == null) {
        existingCoordinator = targetContact.Team_Leader__c;
    } else {
        existingCoordinator = targetContact.Case_Coordinator__c;
    }}
      
    // [ Get Existing Coordinator Name for Display ]
    public string existingCoordinatorName {get; set;}
        
    // [ Declare variable to store selected new Case Coordinator and Transfer Method from VF ]
    public string newCoordinator {get; set;}
    public string newTransferMethod {get; set;}
    
    // [ Returns a list of Case Coordinator Staff ]
    public List<selectOption> getCaseCoordStaff() {
        List<selectOption> caseCoordStaff = new List<selectOption>();
        
        // [ Create Default Option for no choice / user error ]
        caseCoordStaff.add(new selectOption('', '- Select Case Coordinator -'));
        
        // [ Loop through User List - Add to selectOption List ]
        for (User users : [SELECT Id, Name FROM User WHERE Case_Coordinator_Staff__c = TRUE AND IsActive = true ORDER BY Name ASC]) {
            caseCoordStaff.add(new selectOption(users.Id, users.Name));
        }
        
        // [ Return List to VF Page ]
        return caseCoordStaff;
    }
    
    // [ Returns a list of available transfer options ]
    public List<selectOption> getTransferMethods() {
        List<selectOption> transferMethods = new List<selectOption>();
        
        // [ Add Items to List ]
        transferMethods.add(new selectOption('default','All Records'));
        transferMethods.add(new selectOption('custom','Selected Records Only'));
        
        newTransferMethod = 'custom';
        
        return transferMethods;
    }
    
    // init the Task Results
    {if (taskResults == null) {
        taskResults = new List<taskWrapper>(); // init the list if it is null
    } else {
        taskResults.clear(); // clear out the current results if they exist
    }
        for(Task t : [SELECT t.Subject, t.Id, t.Status, t.ActivityDate, t.Unit__c, t.RecordTypeId from Task t WHERE t.WhoId = :contactId AND t.OwnerId = :existingCoordinator AND t.IsClosed = false]) {
            taskWrapper tw = new taskWrapper(t);
            if(t.RecordTypeId == utilIDs.CBOPlacementTask) {
                tw.checked = false;
            }
            taskResults.add(tw);            
        }
    
    }
    
    // init the Event Results
    {if (eventResults == null) {
        eventResults = new List<eventWrapper>(); // init the list if it is null
    } else {
        eventResults.clear(); // clear out the current results if they exist
    }
        //String qry = '
        for(Event e : [SELECT e.Subject, e.Id, e.Status__c, e.ActivityDate, e.IsRecurrence, e.RecurrenceActivityId from Event e WHERE e.WhoId = :contactId AND e.OwnerId = :existingCoordinator AND e.Verification_Status__c = 'Not Verified']) {
            eventWrapper ew = new eventWrapper(e);
            eventResults.add(ew);           
        }
    
    }
    
    //////////////////////////////
    // Actions
    //////////////////////////////
    
    public PageReference init() {
    
        string userProfileId = UserInfo.getProfileId();
    
        // [ Ensure only authorized profiles can access this VF page ]
        if (userProfileId == utilIDs.cepDirector || userProfileId  == utilIDs.cepDeputyDirector || userProfileId == utilIDs.systemAdmin) {
            return null;
        } else {
           PageReference pageRef = new PageReference('/' + contactId);
           pageRef.setRedirect(true);
           return pageRef; 
        }
    
    }

    public PageReference cancelAction() {
    
        // [ Cancel all actions, just return to the Contact page ]
    
        PageReference pageRef = new PageReference('/' + contactId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference transferRecords() {
        
        // [ Data Validation ]
        if (newCoordinator == '' || newCoordinator == null) {
            return null;
        }
        
        if (newTransferMethod == '') {
            return null;
        }
        
        // [ Step 1:  Update Case Coordinator Field in Contact Record, prepare audit note variables ]
        targetContact.Case_Coordinator__c = newCoordinator;
        update targetContact;

        String nTitle = 'Assignment of Case Coordinator';
        String nBody = 'This Client has been assigned to a new Case Coordinator';
        
        if (existingCoordinator == '') {
                PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
                pageRef.setRedirect(true);
                return pageRef;
        }
        
        // [ Step 2: Update all Task and Event Records if "Default" is chosen ]
        
        List<Event> lstEventsToUpdate = new List<Event>();
        
        if (newTransferMethod == 'default') {
        
            List<Task> targetTasks = [SELECT t.Id, t.WhoId, t.OwnerId, t.Status from Task t WHERE t.WhoId = :contactId AND t.OwnerId = :existingCoordinator AND IsClosed = false];
            List<Event> targetEvents = [SELECT e.Id, e.WhoId, e.OwnerId, e.IsRecurrence, e.RecurrenceActivityId from Event e WHERE e.WhoId = :contactId AND e.OwnerId = :existingCoordinator AND Verification_Status__c = 'Not Verified'];
    
            
            
            for (Task tli : targetTasks) {
                if (tli.Status <> 'Completed') {
                    tli.skipRestrictions__c = true;
                    tli.OwnerId = newCoordinator;                
                }
            }
            update targetTasks;
            
            for (Event eli : targetEvents) {
                eli.skipRestrictions__c = true;
                eli.OwnerId = newCoordinator;
                //ebg BT-218 - for recurring events, we are only allowed to modify the main record not occurences of it
                if(eli.IsRecurrence == true) {
                    update eli; // This is to account for not able to batch update recurring appointments
                } else if (eli.RecurrenceActivityId == null) {
                    lstEventsToUpdate.add(eli);
                }
            }
            update lstEventsToUpdate;
            
            // [ Expand on Audit Note ]
            nBody = nBody + ', all Tasks and Events ownership has been transferred.';
        }
        
        // [ Step 2b: Update selected Task and Event Records if "Custom" is chosen ]
        if (newTransferMethod == 'custom') {
                        
            List<Task> tasksToBeUpdated = new List<Task>();
            List<Event> eventsToBeUpdated = new List<Event>();
            
            for (taskWrapper tw : taskResults) {
                if (tw.checked) {
                    tw.tsk.skipRestrictions__c = true;
                    tw.tsk.OwnerId = newCoordinator;
                    tasksToBeUpdated.add(tw.tsk);
                }
            }
            
            // [ Update Tasks ]
            if(tasksToBeUpdated.size() > 0 ) { update tasksToBeUpdated;}
            
            for (eventWrapper ew : eventResults) {
                if (ew.checked) {
                    ew.evt.skipRestrictions__c = true;
                    ew.evt.OwnerId = newCoordinator;
                    system.debug('\n\n***ew.evt.Subject: ' + ew.evt.Subject + ' - ' + ew.evt.isRecurrence);
                    //ebg BT-218 - for recurring events, we are only allowed to modify the main record not occurences of it
                    if(ew.evt.isRecurrence == true) {
                        update ew.evt;
                    } else if (ew.evt.RecurrenceActivityId == null) {
                        eventsToBeUpdated.add(ew.evt);
                    }
                }
            }
            
            // [ Update Events ]
            if(eventsToBeUpdated.size() > 0) { update eventsToBeUpdated;}
        }
        
        // [ Step 3:  Create Audit Note ]
        insert new Note(parentId = contactId, title = nTitle, body = nBody);
        
        // [ Return User to Client / Contact Record ]
        PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
        pageRef.setRedirect(true);
        return pageRef;
    }

    class taskWrapper {
    
        ///////////////////////////////////////
        // This wrapper class is used with the Case Coordinator Transfer
        // process to provide a list of tasks with checkboxes 
        // to allow the user to select certain tasks to transfer
        ///////////////////////////////////////
        
        public Boolean checked {get; set;}
        public Task tsk {get; set;}
        
        public taskWrapper() {
            
            tsk = new Task();
            checked = true;
            
        }
        
        public taskWrapper(Task t) {
            tsk = t;
            checked = true;
        }
    
    }
    
    class eventWrapper {
    
        ///////////////////////////////////////
        // This wrapper class is used with the Case Coordinator Transfer
        // process to provide a list of events with checkboxes 
        // to allow the user to select certain tasks to transfer
        ///////////////////////////////////////
        
        public Boolean checked {get; set;}
        public Event evt {get; set;}
        
        public eventWrapper() {
            
            evt = new Event();
            checked = true;
            
        }
        
        public eventWrapper(Event e) {
            evt = e;
            checked = true;
        }
    
    }
}