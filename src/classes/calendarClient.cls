public with sharing class calendarClient {
    ///////////////////////////////////////////
    // This method manages the Client Calendar VF Page
    // Author:  EBG / DCS
    // Created:  20110421 
    ///////////////////////////////////////////

    public utilityMethods utilMeths = new utilityMethods();
    public List<displayContact> contactsForDisplay {get;set;}
    
    public ID clientId {get;set;}
    public Contact conClient {get;set;}
    public ID coordinatorId {get;set;}
    public User usrCoordinator {get;set;}
    public List<Contact> lstCoordClients {get;set;}
    public Contact dummyCon {get;set;}
    public Event dummyEvt_Start {get;set;}
    public Event dummyEvt_End {get;set;}
    public Boolean bVerifyData {get;set;}
    public Set<ID> conIDs {get;set;}
    
    public Integer eventCount {get;set;}
    public String searchType {get;set;}
    public String renderPageAs {get;set;}
    public String strResult {get;set;}
    public Set<String> statusSet {get;set;}
    public String filterName {get;set;}
    public String filterDisplay {get;set;}
    

    ////////////////////////////////////////////
    // Helper Classes
    ////////////////////////////////////////////
    public class displayEvent {
        
        public String ClientName {get;set;}
        public String ActivityDay {get;set;}
        public String ActivityDate {get;set;}
        public String StartTime {get;set;}
        public String EndTime {get;set;}
        public Event evt {get;set;}
                
    }

    public class displayContact {
        public Contact client {get;set;}
        public List<displayEvent> eventsForDisplay {get;set;}
        public Boolean lastClient {get;set;}
    }
    
    ////////////////////////////////////////////
    // Constructor Methods
    ////////////////////////////////////////////
    public calendarClient(ApexPages.StandardController controller) {}

    public calendarClient() {
        this.conIDs = new Set<ID>();

        //retrieve the parameters passed to the page
        this.clientId = ApexPages.currentPage().getParameters().get('clientId');
        this.coordinatorId = ApexPages.currentPage().getParameters().get('coordinatorId');
        this.searchType = ApexPages.currentPage().getParameters().get('searchType');
        this.renderPageAs =  ApexPages.currentPage().getParameters().get('renderAs');
        this.eventCount = 0;
        
        system.debug('\n\nInside calendarClient.\n\nclientId: ' + this.clientId + '\n\ncoordinatorId: ' + this.coordinatorId + '\n\n');
        
        if (this.clientId != null) {
            conIDs.add(this.clientId);
        }

        this.statusSet = getClientStatusSet();
        system.debug('\n\nInside calendarClient.  statusSet: ' + statusSet + '\n\n');
        
        
        //using the contact object's Client__c field allows us to make the contact field on the page a lookup
        //using the contact object's Case_Coordinator__c field allows us to make the user field on the page a lookup        
        this.dummyCon = new Contact();
        this.dummyCon.Client__c = this.clientId;
        this.dummyCon.Case_Coordinator__c = this.coordinatorId;
        
        this.strResult = null;      

        //use dummy objects to help us fill the search criteria fields on the search page
        this.dummyEvt_Start = new Event();
        this.dummyEvt_End = new Event();    
        this.eventCount = 0;
        

        // set the default date range by using the provided parameters or by calling a method in the utilityMethods class
        String sStartDate = ApexPages.currentPage().getParameters().get('startDate');
        if (sStartDate != null) {
            this.dummyEvt_Start.ActivityDate = date.valueOf(sStartDate);
        } else {
            this.dummyEvt_Start.ActivityDate = utilMeths.clientCalendarStartDate(date.today());
        }
        
        String sEndDate = ApexPages.currentPage().getParameters().get('endDate');
        if (sEndDate != null) {
            this.dummyEvt_End.ActivityDate = date.valueOf(sEndDate);
        } else {            
            this.dummyEvt_End.ActivityDate = utilMeths.clientCalendarEndDate(this.dummyEvt_Start.ActivityDate);
        }

        this.lstCoordClients = new List<Contact>();
        
        //retrieve the calendar
        findClientEvents();     
    }
    
    
    ////////////////////////////////////////////
    // Action Methods 
    ////////////////////////////////////////////
    public void doNothing() { }
    
    public PageReference printableView() {
        //build date string to include in url
        //Start Date
        String sStartDate = utilMeths.dateToString(this.dummyEvt_Start.ActivityDate);
        
        //End Date      
        String sEndDate = utilMeths.dateToString(this.dummyEvt_End.ActivityDate);
        
        //Build url based on provided client or coordinator
        String sURL = '/apex/calendarPrintout?startDate=' + sStartDate + '&endDate=' + sEndDate + '&renderAs=pdf';
        if (this.dummyCon.Client__c != null) {
            sURL += '&clientId=' + this.dummyCon.Client__c + '&searchType=Client';
        } else {
            sURL += '&coordinatorId=' + this.dummyCon.Case_Coordinator__c + '&searchType=Coordinator';
        }

        system.debug('\n\nInside printableView.  New url:' + sURL);


        PageReference pgCal = new PageReference(sURL);
        pgCal.setRedirect(true);
        
        return pgCal;
    }
            
    //*************************************************************************************
    // locate events for the given client contact
    //*************************************************************************************
    public void findClientEvents() {
        //compare the start and end dates to ensure the start date is not after the end date
        this.strResult = null;
        this.strResult = verifyFilters();
        this.filterDisplay = '';
        this.eventCount = 0;
        
        this.filterName = '';
        
        system.debug('\n\nInside findClientEvents for search type ' + this.searchType + '. \n\n');

        if (this.strResult == null) { 
            //call the routine buildClientSearchList() to create a list of clients (contacts) and a set of their IDs;
            //if no records are found, this.strResult will have a value assigned to it.
            system.debug('\n\nCalling buildClientSearchList');
            buildClientSearchList();            
            system.debug('\n\nAfter buildClientSearchList.   Search Result string: ' + this.strResult);
        }

        if (this.strResult == null && this.lstCoordClients.size() > 0) {
            
            //build the filter display string
            this.filterDisplay = this.searchType + ' = \'' + this.filterName + '\'  AND  Start Date >= ' + this.dummyEvt_Start.ActivityDate.format() + '  AND  End Date <= ' + this.dummyEvt_End.ActivityDate.format();
            
            this.contactsForDisplay = new List<displayContact>();
            displayContact dpc = new displayContact();
            
            //get the first client stored in the list and hold it for comparison to the first event found in the loop below. 
            Integer contactPosition = 0;
            
            system.debug('\n\nlstCoordClients:  ' + this.lstCoordClients);
            
            dpc.client = this.lstCoordClients.get(contactPosition);
            dpc.eventsForDisplay = new List<displayEvent>();

            //variable for holding details about the event
            displayEvent dpe;
            
            Integer i = 0;
            Integer contactEvents = 0;
            
            //Retrieve events for the selected client(s) and date range.  As we loop through them we compare them to the list of contacts we
            //found above.  We then build our final list of contacts with events with the VF page will use for display.  Do not pull the recurrence
            //events because they contain the same info as the first instance of the recurring event.
            // QC** 20120202 BT-309. Added verification_status__c to field list and where clause 
            //      to exclude events with status of cancelled or withdrawn.
            for (Event e : [Select e.Id
                                    , e.IsRecurrence
                                    , e.WhoId
                                    , e.Who.Name
                                    , e.Who.FirstName
                                    , e.Who.LastName
                                    , e.Subject
                                    , e.StartDateTime
                                    , e.Instructions__c
                                    , e.EndDateTime
                                    , e.ActivityDateTime
                                    , e.ActivityDate
                                    , e.OwnerId
                                    , e.Owner.Name
                                    , e.verification_status__c
                            From Event e 
                            Where e.WhoId in :conIDs
                                And e.IsRecurrence = false
                                And e.ActivityDate >= :this.dummyEvt_Start.ActivityDate
                                And e.ActivityDate <= :this.dummyEvt_End.ActivityDate
                                And e.verification_status__c != 'Cancelled'
                                And e.verification_status__c != 'Withdrawn'
                            Order By e.Who.LastName, e.Who.FirstName, e.WhoId, e.ActivityDate, e.StartDateTime]) {

                system.debug('\n\nInside findClientEvents.  Event position:  ' + i + '.  \n' + e + '\n\n');
                
                //if our current event is for a different client, we need to put the previous client record in our return list and then
                //find the client we are working on next
                if (dpc.client.Id != e.WhoId) {
                    
                    if (dpc.eventsForDisplay.isEmpty() == false) {
                        system.debug('\n\nAdding dpc to this.contactsForDisplay: ' + dpc);
                        this.contactsForDisplay.add(dpc);
                    }
                    
                    //find the corresponding contact for the event we are processing
                    while ( contactPosition < this.lstCoordClients.size() ) {
                        
                        system.debug('\n\nInside while loop; contactPosition: ' + contactPosition);
                        
                        if ( this.lstCoordClients.get(contactPosition).Id == e.WhoId ) {
                            //if we found a match, capture the next contact and get out of the loop to load the events
                            dpc = new displayContact();                         
                            dpc.eventsForDisplay = new List<displayEvent>();
                            dpc.client = this.lstCoordClients.get(contactPosition);
                            contactEvents = 0;
                            break;
                        } else {
                            contactPosition++;
                        }
                    }
                }  //END - dpc.client.Id != e.WhoId
                 
                system.debug('\n\nOutside while loop; contactPosition: ' + contactPosition);

                //create the new holding area for client events.
                dpe = new displayEvent();
                
                //For display purposes, we only populate the client name on the first instance of that client
                if ( (contactEvents==0) || (dpc.eventsForDisplay[contactEvents-1].evt.who.Name != e.who.Name)) {
                    dpe.ClientName = e.who.Name;
                }
                
                //format the day, start time, and end time
                dpe.ActivityDay = e.ActivityDateTime.format('EEEE');
                dpe.ActivityDate = e.ActivityDate.format();
                dpe.StartTime = e.StartDateTime.format('h:mm a');
                dpe.EndTime = e.EndDateTime.format('h:mm a');

                //add the event to our holding class
                dpe.evt = e;
                
                //add the event holding class to our contact's event list
                dpc.eventsForDisplay.add(dpe);
                contactEvents++;
                i++;
            } //END - for loop of events
            
            this.eventCount = i;
            
            if (this.eventCount == 0) {
                this.strResult = 'No records found matching selected criteria';
            } else {
                //handle the last record and put into our display list
                dpc.lastClient = true;
                this.contactsForDisplay.add(dpc);
            }
            
        } else {
            
            this.contactsForDisplay = new List<displayContact>();
                
        }  //END - if (this.strResult == null)
                
    }
    
    //*************************************************************************************
    // Return a set of valid client status entries based on the semi-colon separated string
    // found in the custom setting "Client Calendar"
    //*************************************************************************************
    public Set<String> getClientStatusSet() {
        system.debug('\n\nInside getClientStatusSet\n\n');
        
        //9/5/13 MB remove client calendar custom setting, hasn't been altered in two years
        //String statusList = Calendar_Settings__c.getValues('Client Calendar').Include_Client_Status__c;
        String statusList = 'Active;On Program Hold;Intaked - Not Yet Active';
        
        Set<String> statusSet = new Set<String>();
        for (String s : statusList.split(';')) {
            statusSet.add(s.trim());
        }
        
        return statusSet;
        
    }
    
    //*************************************************************************************
    // Ensure our dates are entered and the start date is less than or equal to the end date
    //*************************************************************************************
    public String verifyFilters() {
        String sVerifyNote = null;
        
        system.debug('\n\nInside verifyFilters.  Start Date: ' + this.dummyEvt_Start.ActivityDate + '\n\n');
        system.debug('\n\nInside verifyFilters.  End Date: ' + this.dummyEvt_End.ActivityDate + '\n\n');
        system.debug('\n\nInside verifyFilters.  Client__c: ' + this.dummyCon.Client__c + '\n\n');
        system.debug('\n\nInside verifyFilters.  Case_Coordinator__c: ' + this.dummyCon.Case_Coordinator__c + '\n\n');
        
        if (this.dummyEvt_Start.ActivityDate == null) {
            sVerifyNote = 'Calendar search requires a Start Date';
        } else if (this.dummyEvt_End.ActivityDate == null) {
            sVerifyNote = 'Calendar search requires an End Date';
        } else if (this.dummyEvt_Start.ActivityDate > this.dummyEvt_End.ActivityDate) {
            sVerifyNote = 'Start date must be less than or equal to the End Date';
        }
        
        if ((this.searchType == 'Client') && (this.dummyCon.Client__c == null)) { 
            sVerifyNote = 'Select a Client before searching for a calendar';            
        }
        
        if ((this.SearchType == 'Coordinator') && (this.dummyCon.Case_Coordinator__c == null)) {
            sVerifyNote = 'Select a Case Coordinator before searching for a calendar';          
        }
        
        system.debug('\n\nInside verifyFilters.  Note: ' + sVerifyNote + '\n\n');
        
        return sVerifyNote;
    }


    //************************************************************
    //build the list of coordinator clients and contacts to search
    //************************************************************
    void buildClientSearchList() {
        this.lstCoordClients = new List<Contact>();
        this.conIDs = new Set<ID>();
            

        //get coordinator details and all clients (contacts) associated to the coordinator
        system.debug('\n\nSearch Type: ' + this.searchType + '\nthis.dummyCon: ' + this.dummyCon + ' \n\n');
            
        if ((this.searchType == 'Coordinator') && (this.dummyCon.Case_Coordinator__c != null)) {
                
            //get the coordinator name so we can display it with the filter list
            this.usrCoordinator = [Select Id, Name From User where Id = :this.dummyCon.Case_Coordinator__c LIMIT 1];
            this.conClient = new Contact();
            this.filterName = usrCoordinator.Name; 
            for (Contact c : [Select Id, FirstName, LastName, Calendar_Display_Name__c, Case_Coordinator__r.LastName, Case_Coordinator__r.FirstName 
                                From Contact 
                                Where Case_Coordinator__c = :this.dummyCon.Case_Coordinator__c
                                And Client_Status__c in :this.statusSet
                                Order By LastName, FirstName, Id]) {
                                        
                this.lstCoordClients.add(c);
                this.conIDs.add(c.Id);

            }               

            if (this.lstCoordClients.size() == 0) {
                this.strResult = 'No clients found for this coordinator with a status in ' + this.statusSet;
            }   
                    
        } else if ((this.searchType == 'Client') && (this.dummyCon.Client__c != null)) {

            //get the client name so we can display it with the filter list
            this.conClient = [Select Id, Name From Contact where Id = :this.dummyCon.Client__c LIMIT 1];
            this.usrCoordinator = new User();
            this.filterName = conClient.Name; 

            for (Contact c : [Select Id, FirstName, LastName, Calendar_Display_Name__c, Case_Coordinator__r.LastName, Case_Coordinator__r.FirstName 
                                From Contact 
                                Where Id = :this.dummyCon.Client__c
                                //And Client_Status__c in :this.statusSet
                                Order By LastName, FirstName, Id]) {
                                        
                system.debug('\n\nAdding contact to lstCoordClients: ' + c + ' \n\n');
                this.lstCoordClients.add(c);
                system.debug('\n\nAdding c.Id to conIDs: ' + c.Id + ' \n\n');                   
                this.conIDs.add(c.Id);
            }

            if (this.lstCoordClients.size() == 0) {
                this.strResult = 'Unable to find client details for ID ' + this.dummyCon.Client__c;
            }   

        } else {
            
            //this.strResult = 'Search Type not specified';
            doNothing();
        }
        
    }

    

    //************************************************************
    //build the valid options for the radio button
    //************************************************************
    public List<SelectOption> getsearchOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Client','Client')); 
        options.add(new SelectOption('Coordinator','Coordinator')); 
        return options; 
    }

        
}