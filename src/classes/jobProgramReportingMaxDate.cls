global class jobProgramReportingMaxDate {
    
    global utilityIds utilIds = new utilityIds();
    
    global void calculate() {
        
        map<Id, Contact> mapClients = new map<Id, Contact>();
        
        //Program Reporting
        list<Contact> lstClientsforPR = [select Id, Program_Reporting_Scheduled_Until__c,
        (select id, ActivityDate from Events where Subject = 'Program Reporting' 
        order by ActivityDate desc limit 1) 
        from Contact where RecordTypeId in (:utilIds.conClient,:utilIds.conCJC, :utilIds.conJS, :utilIds.conQJC)
        and Client_Status__c = 'Active'];
        
        for(Contact c: lstClientsforPR) {
            
            if(c.Events.size() == 0) {
                
                if(c.Program_Reporting_Scheduled_Until__c != null) {
        
                    c.Program_Reporting_Scheduled_Until__c = null;
                    mapClients.put(c.id, c);
                }
            } else if (c.Program_Reporting_Scheduled_Until__c != c.Events[0].ActivityDate) {
                
                c.Program_Reporting_Scheduled_Until__c = c.Events[0].ActivityDate;
                mapClients.put(c.id, c);
            }
        }
        
        //Ongoing classes
        list<Contact> lstClientsforOC = [select Id, First_Language_Arts_Math_Class__c,
        (select id, ActivityDate from Events 
        where (Subject Like 'Language Arts %' or Subject Like 'Math A%' or Subject Like 'Math B%')
        and Verification_Status__c in ('Attended', 'Late')
        order by ActivityDate asc limit 1) 
        from Contact where RecordTypeId in (:utilIds.conClient,:utilIds.conCJC, :utilIds.conJS, :utilIds.conQJC)
        and Client_Status__c = 'Active'];
        
        for(Contact c: lstClientsforOC) {
            
            if(c.Events.size() == 0) {
                
                if(c.First_Language_Arts_Math_Class__c != null) {
    
                    if(mapClients.containsKey(c.id)) {
                        mapClients.get(c.id).First_Language_Arts_Math_Class__c = null;
                    } else {    
                        c.First_Language_Arts_Math_Class__c = null;
                        mapClients.put(c.id, c);
                    }
                }
            } else if (c.First_Language_Arts_Math_Class__c != c.Events[0].ActivityDate) {

                    if(mapClients.containsKey(c.id)) {
                        mapClients.get(c.id).First_Language_Arts_Math_Class__c = c.Events[0].ActivityDate;
                    } else {    
                        c.First_Language_Arts_Math_Class__c = c.Events[0].ActivityDate;
                        mapClients.put(c.id, c);
                    }               
                
            }
        }       
                           
        update mapClients.values();
        
    }

}