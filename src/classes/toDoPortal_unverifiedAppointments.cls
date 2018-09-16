global with sharing class toDoPortal_unverifiedAppointments {

    public Portal_Filter__c APPOINTMENT_FILTER {get;set;}
    public User CURRENT_USER {get;set;}
    public utilityIds UTILITY = new utilityIds();
    public List<DisplayedEvent> DISPLAYED_UNVERIFIED_EVENTS {get;set;}
    
    public toDoPortal_unverifiedAppointments(){
        LoadDefaults();
    }
    
    public void LoadDefaults(){
        LoadAppointmentFilter();
        LoadUser();
    }
    
    public Portal_Filter__c LoadAppointmentFilter(){
        APPOINTMENT_FILTER = new Portal_Filter__c();
        for(Portal_Filter__c PORTAL_FILTER : [SELECT
            Unverified_Appointments_Due_date_from__c, Unverified_Appointments_Due_date_to__c,
            Unverified_Appointments_Filter_By__c, Unverified_Appointments_Staff__c,
            Unverified_Appointments_Unit__c, Unverified_Appointments_Caseload__c
            FROM Portal_Filter__c 
            WHERE OwnerId = :UserInfo.getUserId() LIMIT 1]){
            APPOINTMENT_FILTER = PORTAL_FILTER;
        }
        return APPOINTMENT_FILTER;
    }
    
    public User LoadUser(){
        CURRENT_USER = [SELECT Id, Unit__c FROM User WHERE Id = :UserInfo.getUserId()];
        return CURRENT_USER;
    }
    
    public List<SelectOption> getCaseloadOptions(){
        List<User> USERS = [SELECT Id, FirstName, LastName FROM User
            WHERE IsActive = TRUE
            AND ProfileId = :UTILITY.caseCoordinatorStaff];    
                  
        List<SelectOption> CASELOAD = new List<SelectOption>();
        for(User THIS_USER : USERS){
            CASELOAD.add(new SelectOption(THIS_USER.Id,THIS_USER.FirstName + ' ' + THIS_USER.LastName));
        }
        return CASELOAD;
    }
    
    public void SaveFilter(){
        upsert APPOINTMENT_FILTER;
    }
    
    public void UpdateEvents(){
        List<Event> UPDATED_EVENTS = new List<Event>();
        for(DisplayedEvent DISPLAYED_EVENT : DISPLAYED_UNVERIFIED_EVENTS){
            if(DISPLAYED_EVENT.VerificationStatus_Original != DISPLAYED_EVENT.EventObject.Verification_Status__c){
                UPDATED_EVENTS.add(DISPLAYED_EVENT.EventObject);        
            }
        }
        update UPDATED_EVENTS;
    }
    
    public List<DisplayedEvent> getUnverifiedEvents(){
            List<Event> UNVERIFIED_EVENTS = new List<Event>();
            String Query =
                'SELECT ' +
                    'Id, ActivityDate, ActivityDateTime, Open_Date__c, Owner.Id, Owner.Name, RecordTypeId, StartDateTime, ' +
                    'Subject, Unit__c, Who.Id, Who.Name, Verification_Due_Date__c, Verification_Status__c ' +
                'FROM ' +
                    'Event ' +
                'WHERE ' +
                    'IsRecurrence = FALSE ' + 
                'AND ' +
                    '(Verification_Status__c = \'Not Verified\' AND RecordTypeId != \'' + UTILITY.courtDate + '\') '
            ;
            
            if(APPOINTMENT_FILTER.Unverified_Appointments_Filter_By__c == 'Staff' && APPOINTMENT_FILTER.Unverified_Appointments_Staff__c != null) {
                Query += ' AND OwnerId = \'' + APPOINTMENT_FILTER.Unverified_Appointments_Staff__c + '\' '; 
            }
            if(APPOINTMENT_FILTER.Unverified_Appointments_Filter_By__c  == 'Unit') {
                Query += ' AND Unit__c = \'' + APPOINTMENT_FILTER.Unverified_Appointments_Unit__c + '\' '; 
            }
            if(APPOINTMENT_FILTER.Unverified_Appointments_Filter_By__c  == 'Caseload'){
                Integer CONTACT_COUNT = 1;
                List<Contact> LIST_CONTACTS = new List<Contact>();
                LIST_CONTACTS = [
                                                    SELECT
                                                        Id, Case_Coordinator__c, Team_leader__c
                                                    FROM
                                                        Contact
                                                    WHERE
                                                        Case_Coordinator__c = :APPOINTMENT_FILTER.Unverified_Appointments_Caseload__c
                                                            OR
                                                        Team_Leader__c = :APPOINTMENT_FILTER.Unverified_Appointments_Caseload__c
                                                ];                                              
                for(Contact THIS_CONTACT : LIST_CONTACTS){
                    if(CONTACT_COUNT == 1){
                        Query += ' AND (WhoId = \'' + THIS_CONTACT.Id + '\' ';
                        CONTACT_COUNT++;
                    }else if(CONTACT_COUNT < LIST_CONTACTS.size()){
                        Query += ' OR WhoId = \'' + THIS_CONTACT.Id + '\' ';
                        CONTACT_COUNT++;
                    }
                }
                
                if(LIST_CONTACTS.size() > 0){
                    Query += ' )';   
                }  else {
                    Query += ' AND (WhoId = \'01x6xxxxxxxxxxxxxx\') '; //fake Id to return no results
                }           
            }
            
            if(APPOINTMENT_FILTER != null){
                if(APPOINTMENT_FILTER.Unverified_Appointments_Due_date_from__c != null){
                    Query += ' AND Verification_Due_Date__c >= ' + String.valueOf(APPOINTMENT_FILTER.Unverified_Appointments_Due_date_from__c);
                }
                if(APPOINTMENT_FILTER.Unverified_Appointments_Due_date_to__c != null) {
                    Query += ' AND ActivityDate <= ' + String.valueOf(APPOINTMENT_FILTER.Unverified_Appointments_Due_date_to__c);
                } 
            }
            
            Query += ' ORDER BY ActivityDateTime LIMIT 300';
            
            system.debug(LOGGINGLEVEL.ERROR,'Query: ' + Query);         
            UNVERIFIED_EVENTS = database.query(Query);
            
            DISPLAYED_UNVERIFIED_EVENTS = new List<DisplayedEvent>();
            for(Event THIS_EVENT : UNVERIFIED_EVENTS){
                DISPLAYED_UNVERIFIED_EVENTS.add(new DisplayedEvent(THIS_EVENT,CURRENT_USER,UTILITY));
            }

      return DISPLAYED_UNVERIFIED_EVENTS;
        }
        
        public class DisplayedEvent{
            public Event EventObject {get;set;}
            public String Color {get;set;}
            public Boolean Editable {get;set;}
            public String VerificationStatus_Original {get;set;}
            
            public DisplayedEvent(Event THIS_EVENT, User THIS_USER, utilityIds THIS_UTILITY){
                EventObject = THIS_EVENT;
                VerificationStatus_Original = THIS_EVENT.Verification_Status__c;
                if(THIS_EVENT.RecordTypeId == THIS_UTILITY.orientationAppointment || THIS_EVENT.RecordTypeId == THIS_UTILITY.courseCatalogClass || THIS_EVENT.RecordTypeId == THIS_UTILITY.courtDate){
                    Editable = FALSE;
                }else{
                    Editable = TRUE;
                }
                if(THIS_EVENT.Owner.Id != UserInfo.getUserId()){
                    if(UserInfo.getProfileId() != THIS_UTILITY.cepDeputyDirector && UserInfo.getProfileId() != THIS_UTILITY.cepDirector ){
                        if(THIS_USER.Unit__c != THIS_EVENT.Unit__c){
                            Editable = FALSE;
                        }
                    }
                }
                
                if(THIS_EVENT.ActivityDate < System.Today()){               
                    Color = '#FF0000';  // RED
                }else if(THIS_EVENT.ActivityDate >= System.Today() && THIS_EVENT.ActivityDate <= System.Today().addDays(3)){             
                    Color = '#FFFF00';  // YELLOW 
                }else if(THIS_EVENT.ActivityDate > System.Today().addDays(3) && THIS_EVENT.ActivityDate < System.Today().addDays(6)){           
                    Color = '#008000';  // GREEN    
                }else{
                    Color = '#000000';
                }
            }
        }
 
}