public class updateCourtDateController {
    public string portalName{get;set;}
    public utilityIds utilIds = new utilityIds();
    public String strCourtDate = System.currentPagereference().getParameters().get('courtdate'); 
    public String strNextCourtDateScheduled = 
        System.currentPagereference().getParameters().get('bolNextCourtDateScheduled');      
    public Boolean bolShowCourtDate {get;set;}
    public Event thisCourtDate {get;set;}
    public Event nextCourtDate {get;set;}   
    public Contact thisContact {get;set;}
    public Boolean bolSaveSuccessful {get;set;}
    public Boolean bolNewCourtDateCreated {get;set;}
    public Boolean bolCourtStaffAttended {get;set;}

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public updateCourtDateController() { 
       	portalName = ApexPages.currentPage().getParameters().get('portalName');   
        //get passed in data
        if (strCourtDate != null){
        thisCourtDate = [select id, Part__c, OwnerId, Action__c, Outcome__c, Description, ActivityDate, whoId,
            Judge_If_other_than_Assigned_Judge__c, whatId, Court_Staff_Attended__c, Service_Plan_Submitted__c
            from Event where id = :strCourtDate];
            
        thisContact = [select id, FirstName, LastName, P_C_ID__c
            from Contact where id = :thisCourtDate.whoId];} 
            
        //set up new court date
        nextCourtDate = new Event();
        bolNewCourtDateCreated = false;
        
        bolShowCourtDate = true;
        
        if(strNextCourtDateScheduled == 'true') {
            
            bolShowCourtDate = false;
        }

    }

    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() { }
      
    
    public pageReference goPortal() {
        
     	PageReference prRef;
        if (portalName == null)
            prRef = new PageReference('/apex/courtPortal');
        else
            prRef = new PageReference('/apex/allCourtsPage');
   //         PageReference prRef = new PageReference('/apex/courtPortal');
            prRef.setRedirect(true);
            return prRef;       
    }    
    
    public void updateCourtDate() {
        
        try {
            
            thisCourtDate.ActivityDateTime = 
                DateTime.newInstance(thisCourtDate.ActivityDate, Time.newInstance(12,0,0,0));
            
            update thisCourtDate;
            
            if(nextCourtDate.ActivityDate != null) {
                
                nextCourtDate.whoId = thisCourtDate.whoId;
                nextCourtDate.Subject = 'Court Date';
                nextCourtDate.RecordTypeId = utilIds.courtDate;
                nextCourtDate.Part__c = thisCourtDate.Part__c;
                nextCourtDate.Judge_If_other_than_Assigned_Judge__c = thisCourtDate.Judge_If_other_than_Assigned_Judge__c;
                nextCourtDate.WhatId = thisCourtDate.whatId;     
                nextCourtDate.ownerId = thisCourtDate.OwnerId; 
                nextCourtDate.DurationInMinutes = 60;       
                nextCourtDate.ActivityDateTime = 
                    DateTime.newInstance(nextCourtDate.ActivityDate, Time.newInstance(12,0,0,0));
                    
                insert nextCourtDate;   
                bolNewCourtDateCreated = true;              
            }
            
            bolSaveSuccessful = true;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            bolSaveSuccessful = false;
            bolNewCourtDateCreated = false;
        }
        
    }
}