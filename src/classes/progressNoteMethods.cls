public class progressNoteMethods {
    
    //this class added 5/21/13 by MB to move logic out of progressNotesLogic trigger
    
    public utilityMethods clsUtilMethods = new utilityMethods();
    public utilityIds clsUtilIds = new utilityIds();    
    
    public list<Progress_Note__c> lstNotes = new list<Progress_Note__c>();
    public list<Progress_Note__c> lstOldNotes = new list<Progress_Note__c>();
    public Boolean bolInsert = null;
    
    //This method extracts any Hashtag phrases from the Progress Note and puts them into a separate field which can be reported on.
    public void setHashtags() {
    
        integer i = 0;
        String strPN = '';
        String strHash = '';
        integer intEnd = 0;
        integer intNextSpace = 0;
        integer intNextLineBreak = 0;
        
        // 10/21/14 new method for Samantha Koller. Wrapping in try-catch because it has not been thoroughly tested
        // and we don't want saving a progress note to throw an error just on account of this
        try {
    
            for(Progress_Note__c pn: lstNotes) {
            
                strPN = pn.Progress_Note__c;
                strHash = '';
                
                if(bolInsert || strPN!= lstOldNotes[i].Progress_Note__c) {
                
                    
                    for(Integer currHashPos = strPN.indexOf('#'); currHashPos != -1; currHashPos = strPN.indexOf('#',currHashPos+1)) {
                        
                        intNextSpace = strPN.indexOf(' ', currHashPos+2);
                        intNextLineBreak = strPN.indexOf('\n', currHashPos+2);
                        
                        //if no space or line break ahead then take substring till end of the note
                        if( intNextSpace == -1 && intNextLineBreak == -1) {
                        
                            intEnd = strPN.length();
                        } else if(intNextSpace > -1 && intNextLineBreak > -1) {
                        
                            intEnd = math.Min(intNextSpace, intNextLineBreak);
                        } else {//the only other condition is if one character was found. If so, take the position that's >-1
                            intEnd = math.Max(intNextSpace, intNextLineBreak);
                        }
                            
                        //add current hashtag to list   
                        strHash += strPN.subString(currHashPos, intEnd) + ' ';
                    }
                    
                    strHash = strHash.replaceAll('[!]|[.]|[?]|[,]|[;]', '');
                    strHash = strHash.trim();
                    strHash = strHash.replace('\r','');
                    strHash = strHash.replace('# ','#');
                    pn.Hashtags__c = strHash;
                }
                
                i++;
            }
        } catch (Exception e) {
        
        }
    }
    
    public void setIncidentReportField() {
        
        list<Id> lstPartIds = new list<Id>();       

        //get Ids
        for(Progress_Note__c pn : lstNotes) {   
            
            lstPartIds.add(pn.Incident_Participant__c);
        }   
        
        // query Incident Participation records
        map<Id, Incident_Participation__c> mapPPtoReport = new Map<Id, Incident_Participation__c>(
        [select id, Incident_Report__c from Incident_Participation__c where id in :lstPartIds]);

                 
        for(Progress_Note__c pn : lstNotes) {                
            
        // added 5/21/13 MB for Incident Reporting
        // populate the Incident Report field based on the value in the Incident Participant field  
            if(pn.RecordTypeId == clsUtilIds.progressNoteIncidentReport ) {
                
                pn.Incident_Report__c = mapPPtoReport.get(pn.Incident_Participant__c).Incident_Report__c;   
            }
        }                           
        
    }

    public void blockManualGroupNoteCreation() {

        for(Progress_Note__c pn : lstNotes) {                
            
            // Group Note Validation
            system.debug('\n\n***INFO: Inserting/Updating progress note: ' + pn);
            if(pn.RecordTypeId == clsUtilIds.progressNoteGroup && pn.System_Generated__c == false) {
                pn.AddError('Group Notes can only be created through the Course Registration system!');
            }
        }
    }
    
    public void closeTasks() {
        
        
        //////////////////////////////////////////////
        // Determine which PN actions to take
        //////////////////////////////////////////////
        
        Boolean boolPSPNFlag = false;
        Boolean boolCCPNFlag = false;
        Boolean boolCCCRSFlag = false;
        Boolean boolPSCRSFlag = false; 
        Boolean boolIncidentFlag = false; 
        
        for(Progress_Note__c pn : lstNotes) {
            
            if(pn.RecordTypeId == clsUtilIds.progressNoteCCPN) { boolCCPNFlag = true; }
            else if(pn.RecordTypeId == clsUtilIds.progressNoteCCCRS) { boolCCCRSFlag = true; }
            else if(pn.RecordTypeId == clsUtilIds.progressNotePSPN) { boolPSPNFlag = true; }
            else if(pn.RecordTypeId == clsUtilIds.progressNotePSCRS) { boolPSCRSFlag = true; }
            else if(pn.RecordTypeId == clsUtilIds.progressNoteIncidentReport) { boolIncidentFlag = true; }
            
        }
        
        //////////////////////////////////////////////
        // Process CRS Task Notes (Order is important!)
        //////////////////////////////////////////////
        
        if(boolCCCRSFlag) { clsUtilMethods.closeCCCourtReportNoteTask(lstNotes, null, false); }
        if(boolPSCRSFlag) { clsUtilMethods.closePSCRSNoteTask(lstNotes); }
        
        //////////////////////////////////////////////
        // Process PN Task Notes (Order is important!)
        //////////////////////////////////////////////
        
        if(boolCCPNFlag) { clsUtilMethods.closeCCPNNoteTask(lstNotes); }
        if(boolPSPNFlag) { clsUtilMethods.closePSPNNoteTask(lstNotes); }
        
        //////////////////////////////////////////////
        // Incident Notes
        //////////////////////////////////////////////
        
        if(boolIncidentFlag) { clsUtilMethods.closeIncidentNoteTask(lstNotes); }        
    }
}