@isTest
private class calendarClientUnitTest {



    static testMethod void testCalendar_Client() {
        utilityIds utilIds = new utilityIds();
        
        //create sample contacts
        List<Contact> lstContact = new List<Contact>();
        Contact c;
        for (Integer i=0; i<4; i++) {
            c = new Contact();
            c.FirstName = 'Test';
            c.LastName = 'TestClient' + i;
            c.Client_Status__c = 'Active';
            c.Case_Coordinator__c = utilIds.defaultTaskAssignedTo;
            lstContact.add(c);
        }
        insert lstContact;
        
        system.debug('\n\nContact List: ' + lstContact);
        
        //create events for each contact
        List<Event> lstEvents = new List<Event>();
        Event evt;
        for (Integer i=0; i<4; i++) {
            for (Integer j=0; j<4; j++) {
                
                evt = new Event();
                evt.WhoId = lstContact[i].Id;
                evt.RecordTypeId = utilIds.miscellaneousEvent;
                evt.DurationInMinutes = 60;
                evt.ActivityDate = Date.today();
                //10/15/13 MB: added this to prevent new checkForDuplicates() method in eventMethods from throwing an error
                evt.ActivityDateTime = System.now().addHours(j);
                evt.Verification_Due_Date__c = evt.ActivityDate.addDays(7);
                evt.Subject = 'Meeting';
                lstEvents.add(evt);
                
            }
        }
        insert lstEvents;
        
        //reference the page and controller
        system.debug('\n\nCreating controller for calendarClient');
        calendarClient controller = new calendarClient();
        
        system.debug('\n\nSetting client to process: ' + lstContact + '\n\n');
        
        PageReference pageRef;            
        pageRef = Page.calendarClient;
        Test.setCurrentPage(pageRef);

        system.debug('\n\nCalling calendar page\n\n');

        ApexPages.currentPage().getParameters().put('clientId', lstContact[0].Id);
        ApexPages.currentPage().getParameters().put('searchType', 'Client');
               
        system.debug('\n\nCalling controller methods and voids \n\n');

        controller.clientID = lstContact[0].Id;
        controller.searchType = 'Client';
        controller.dummyCon = new Contact();
        controller.dummyCon.Client__c = lstContact[0].Id;
        controller.dummyEvt_Start = new Event();        
        controller.dummyEvt_Start.ActivityDate = Date.today();
        controller.dummyEvt_End = new Event();  
        controller.dummyEvt_End.ActivityDate = Date.today().addDays(7);
        controller.verifyFilters();
        controller.findClientEvents();
        controller.getsearchOptions();
        controller.printableView();
        
        controller.coordinatorId = UserInfo.getUserId();
        controller.searchType = 'Coordinator';
        controller.dummyCon = new Contact();
        controller.dummyCon.Case_Coordinator__c = UserInfo.getUserId();
        controller.dummyEvt_Start = new Event();        
        controller.dummyEvt_Start.ActivityDate = Date.today();
        controller.dummyEvt_End = new Event();        
        controller.dummyEvt_End.ActivityDate = Date.today().addDays(7);
        controller.verifyFilters();
        controller.findClientEvents();
        controller.getsearchOptions();
        controller.printableView();
        
      
    }
    
    static testMethod void testCalendar_Coordinator() {
        
    }  
}