public with sharing class toDoPortal_Client {
    public List<tasksForDisplay> tskForDisplay = new List<tasksForDisplay>();
    public utilityIds util = new utilityIds();
      public UtilityTimeMethods ut = new UtilityTimeMethods();
    public String[] toDoItems = new String[]{};
    public Portal_Filter__c searchCriteriaFilter = new Portal_Filter__c();
   public string fieldValue{get;set;}
    public Id eventid{get;set;}  
     public toDoPortal_Client () {
       searchCriteriaFilter.Client_Appointments__c = true;
        searchCriteriaFilter.Activity_Status__c = 'Outstanding';}
    public boolean notasks{get;set;}
   public boolean noapps{get;set;}
    public Portal_Filter__c getFilter() {
        return searchCriteriaFilter;}
    
    public void logSearch() {
}   
    
    public void setFilter(Portal_Filter__c searchCriteriaFilter) {
        this.searchCriteriaFilter = searchCriteriaFilter;}
        
    public void settoDoObject(Portal_Filter__c searchCriteriaFilter) {
        this.searchCriteriaFilter = searchCriteriaFilter;}
    // Accessors
      public List<SelectOption> gettoDoItems() {
       return util.toDoTabList;}
        
            
    public String[] gettoDoSelection() {
        return toDoItems;}
          
    public void settoDoSelection(String[] toDoItems) {
       this.toDoItems = toDoItems;}
    
    ////////////////////////////////////////////////////////
    // EVENT LOGIC
    ////////////////////////////////////////////////////////
    
    public List<eventForDisplay> unverifiedEvents = new List<eventForDisplay>();
    public String unverifiedEventsQuery;
    public integer eventCount = 0;
    public Integer getEventCount() {
           return eventCount;}
    
       
    public void doNothing2() {
       List<Event> eventsToUpdate = new List<Event>(); 
       for(eventForDisplay thisE:unverifiedEvents) {
            if(thisE.updateThisOne != thisE.eventForDisplay.verification_status__c) {
                eventsToUpdate.add(thisE.eventForDisplay); }}
       update eventsToUpdate;}
         
        public List<eventForDisplay> getUnverifiedEvents() {
           if(searchCriteriaFilter.client__c != null) {
               /////////////////////////////////////////
                // Build the query
                /////////////////////////////////////////
              unverifiedEventsQuery = 'Select Who.Name,Who.Id, Unit__c, WhoId, Subject, RecordTypeId,Verification_Due_Date__c,Verification_Status__c,Owner.Name, Owner.Id, OwnerId, Open_Date__c, ActivityDate,ActivityDateTime From Event Where IsRecurrence = false AND whoId = \'' + searchCriteriaFilter.client__c  + '\' ';
                 /////////////////////////////////////////
                //
                // Activity Status
                //
                /////////////////////////////////////////
                    if(searchCriteriaFilter.Activity_Status__c == 'Outstanding') {
                        unverifiedEventsQuery += ' AND Verification_Status__c = \'Not Verified\' ';// Added per QC 20111209
                        if(searchCriteriaFilter.Client_Appointments__c == true) {
                            System.Debug('\n\n LOOKING GOOD');
                            unverifiedEventsQuery += ' AND ActivityDate <= ' + String.valueOf(System.Today());} }
                    if(searchCriteriaFilter.Activity_Status__c == 'Completed') {
                        unverifiedEventsQuery += ' AND Verification_Status__c != \'Not Verified\' ';}
             ///////////////////////////////////////////////
                //
                // Client
                ///////////////////////////////////////////////
              unverifiedEventsQuery += ' ORDER BY ActivityDate LIMIT 1000';
                 List<Event> unverifiedEventsFromQuery = Database.query(unverifiedEventsQuery);
                unverifiedEvents.clear();
                if (unverifiedEventsFromQuery.Size() != 0){
              //  unverifiedEvents.clear(); /// CLEAR OUT PREVIOUS
                User userEditingTheseRecords = [Select Id, Unit__c from User Where Id = :UserInfo.getUserId()];
                for(Event thisEvent:unverifiedEventsFromQuery) {
                    eventForDisplay nEvntForDisplay = new eventForDisplay();
                    nEvntForDisplay.eventForDisplay = thisEvent;
                    nEvntForDisplay.updateThisOneControl = '0';
                    // We do not display the picklist for
                    // orientation appointments
                    if( thisEvent.RecordTypeId == util.orientationAppointment ||
                        thisEvent.RecordTypeId == util.courseCatalogClass ||
                        thisEvent.RecordTypeId == util.courtDate  ||
                        thisEvent.RecordTypeId == util.ImmediateNotification  ) {
                        nEvntForDisplay.displayPickList = false;
                        nEvntForDisplay.dontDisplayPickList = true;
                    } else {
                        nEvntForDisplay.displayPickList = true;
                        nEvntForDisplay.dontDisplayPickList = false;}
                    /// Owner can update
                    if(thisEvent.ownerId != UserInfo.getUserId()) { 
                        // Deputy Director and director can update
                        if( UserInfo.getProfileId() != util.cepDeputyDirector &&
                            UserInfo.getProfileId() != util.cepDirector ) {
                            // Person of the same unit can update
                            if(userEditingTheseRecords.unit__c != thisEvent.Unit__c) {
                                nEvntForDisplay.displayPickList = false;
                                nEvntForDisplay.dontDisplayPickList = true;}}}
       if (thisEvent.activitydatetime > datetime.now())
                      nEvntForDisplay.futureApps = true;             
                   nEvntForDisplay.oldValue = thisEvent.Verification_Status__c;
                    if(thisEvent.Verification_Status__c == 'Not Verified') {
                        nEvntForDisplay.color = determineColor(thisEvent.ActivityDate);}
                    nEvntForDisplay.updateThisOne = thisEvent.Verification_Status__c;
                    unverifiedEvents.add(nEvntForDisplay);}}
            eventCount = unverifiedEvents.size();}
            else noapps = true;
            return unverifiedEvents;}
    
    public class eventForDisplay {
        public Event eventForDisplay{get;set;}       
        public String updateThisOne{get;set;}
        public String color{get;set;}
        public String updateThisOneControl {get;set;}
        public Boolean displayPickList {get;set;}
        public Boolean dontDisplayPickList {get;set;}
        public Boolean futureApps {get;set;}
        public string oldValue {get;set;}}

        // Determine color of date 
          public string determineColor(Date taskDate) {
            String color = '#000000';
            // RED
            if(taskDate < System.Today()) {
                color = '#FF0000';}
            // YELLOW
            if(taskDate >= System.Today() && taskDate <= System.Today().addDays(3)) {
                color = '#FFFF00';}
            // GREEN
            if(taskDate > System.Today().addDays(3) && taskDate < System.Today().addDays(6) ) {
                color = '#008000';}
            return color;}
  
    // TASK LOGIC

    public string query;
    public integer taskCount = 0;
    public Integer getTaskCount() {
        return taskCount;}
    public List<tasksForDisplay> getToDoTasksTab() {
            
        /////////////////////////////////////////
        // Build the query
        /////////////////////////////////////////
        if(searchCriteriaFilter.client__c != null) {
            // Activity Status
  
                if(searchCriteriaFilter.Activity_Status__c == 'Outstanding') {
                    query += ' AND IsClosed = false '; }
                if(searchCriteriaFilter.Activity_Status__c == 'Completed') {
                    query += ' AND IsClosed = true ';}
            //////////////////////////
            // Task record Type Logic
            //////////////////////////
           String taskIdCondition = '';
           integer i = 0;
            try{
            for(Id  thisId:toDoItems) {
                if(i == 0) {
                    taskIdCondition += ' AND ( recordTypeId = \'' + thisId + '\' '; } else {
                    taskIdCondition += ' OR recordTypeId = \'' + thisId + '\' ';}
                i++;
                if(i == toDoItems.size()) {
                    taskIdCondition += ' )';}}
          query += taskIdCondition;
            /////////////////////////////////////////////////////
            query += ' LIMIT 1000';
            List<Task> tasksFromQuery = Database.query(query);
            tskForDisplay.clear(); /// CLEAR OUT PREVIOUS
            for(Task thisTask:tasksFromQuery) {
                tasksForDisplay nTskForDisplay = new tasksForDisplay();
                nTskForDisplay.tsk = thisTask;
                if(thisTask.RecordTypeId == util.rearrestCheckTask) {
                    nTskForDisplay.showLink = true;} else {
                    nTskForDisplay.showLink = false;}
                nTskForDisplay.color = determineColor(thisTask.ActivityDate);
                tskForDisplay.add(nTskForDisplay);
            }}
        catch (Exception e){
        //  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'no Tasks were found'));
            notasks = true;
            return tskForDisplay;}
        taskCount = tskForDisplay.size();}
        return tskForDisplay;}
  
    public void doNothing() {}
    // Helper class
    public class tasksForDisplay {
        public Task tsk {get;set;}
        public String color {get;set;}
        public boolean showLink {get;set;}}
 
      public List<SelectOption> getPLValues() {
       List<SelectOption> plValues = new List<SelectOption>();
        plValues.add(new SelectOption('None', 'None'));
        Schema.DescribeFieldResult dfr = Event.Verification_status__c.getDescribe();
        for (Schema.PicklistEntry ple : dfr.getPicklistValues()) {
            // plValues.add(new SelectOption(value, label, isDisabled));
            plValues.add(new SelectOption(ple.getValue(), ple.getValue()));}
        return plValues;} 
    
       public List<SelectOption> getPLValuesFuture() {
       List<SelectOption> plValues = new List<SelectOption>();
//        plValues.add(new SelectOption(ple.getValue(), ple.getLabel(), !ple.isActive()));
        plValues.add(new SelectOption('None', 'None'));
        Schema.DescribeFieldResult dfr = Event.Verification_status__c.getDescribe();
        for (Schema.PicklistEntry ple : dfr.getPicklistValues()) {
            // plValues.add(new SelectOption(value, label, isDisabled));
            if (ple.getValue() == 'Cancelled' ||
            ple.getValue() == 'Not Verified' || ple.getValue() == 'Withdrawn')
               plValues.add(new SelectOption(ple.getValue(), ple.getValue()));}
        return plValues;} 
     public boolean saved {get;set;}
          
          
      public void saveRecord() { 
         Event evt = [select verification_status__c,activitydatetime,DurationInMinutes,time_in__c,time_out__c from event where id =: eventid];
         evt.Skip_Triggers__c = true;
     if (fieldValue <> 'Attended' && fieldValue <> 'Late' ){
            evt.Time_In__c = '';
            evt.Time_Out__c = '';}  
        else
           if (fieldValue == 'Attended'){
              evt.Time_In__c  = ut.defaultAttendanceTimes(evt.activitydatetime, evt.DurationInMinutes, true);
              evt.Time_Out__c  = ut.defaultAttendanceTimes(evt.activitydatetime, evt.DurationInMinutes, false);}
           else{evt.Time_In__c = ut.convertTime(evt.activitydatetime.hour(), true);
                  evt.Time_Out__c  = ut.defaultAttendanceTimes(evt.activitydatetime, evt.DurationInMinutes, false);}
         evt.verification_status__c   = fieldvalue; 
         evt.Verification_Date__c = System.Today();
         evt.Verified_By__c = UserInfo.getName();
         try{      
            update evt;
            saved = true;}          
         catch (Exception e) {
            saved = false; 
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'record NOT Saved'));}}
 }