global class jobEmailMHSAReferrals {
    
    global utilityIDs utilIDs = new utilityIDs();
    
    global void findAppointments(Date dte) {
        
        list<Event> lstEventsForEmail = new list<Event>();
        list<Event> lstAppts = new list<Event>();
        list<Id> lstwhoIds = new list<Id>();
        list<Id> lstEvtIds = new list<Id>();
        map<Id, Contact> mapContacts = new map<Id, Contact>();
        
        if(dte == null) {
            dte = system.today();
        }
        
        //get appointments created today that are the first appointment for that client at that agency
        AggregateResult[] aggAppts = [SELECT whoId, whatId, Max(tDate__c) Date, Max(Id) Id FROM Event
            where P_C_ID__c LIKE 'CEP_%' and Subject in ( 'MH Counseling', 'MH/SA Treatment', 
            'Outpatient Program Treatment', 'Short-Term Inpatient Rehab Participation')
            and whatID != null and Verification_Status__c in ('Attended', 'Late')
            group by whoId, whatId
            having Count(id) = 1 and Max(tDate__c) >= :dte and Max(tDate__c) <= :dte.addDays(1)];

        //get event whoIds and then client map for names to put in email            
        //get appointment records from aggs
        for(AggregateResult ar : aggAppts) {
            
            lstEvtIds.add(string.valueOf(ar.get('Id')));
            lstwhoIds.add(string.valueOf(ar.get('whoId'))); 
        }
        
        lstAppts = [select id, whatId, whoid, ActivityDate from Event where id in :lstEvtIds];
        mapContacts = new map<Id, Contact>([select id, Name from Contact where id in :lstWhoIds]);      
        
        //get referrals. To limit query, they must have been in the last month
        list<Event> lstReferrals = [select id, whoId, whatId from Event
            where P_C_ID__c LIKE 'CEP_%' and
            Subject in ('MH Counseling Referral', 'MH/SA Treatment Referral', 'Outpatient Program Referral', 
            'Short-Term Inpatient Rehab Referral') 
            and whatID != null and Verification_Status__c in ('Attended', 'Late')
            and whoId in :lstwhoIds];
            
        //match appointments to referrals, and add non-matches to email list
        boolean bolMatch = false;
        
        
        for(Event appt: lstAppts) {
            
            bolMatch = false;
            
            for(Event ref: lstReferrals) {
                
                if(appt.whatId == ref.whatId && appt.whoId == ref.whoId) {
                    
                    bolMatch = true;
                    break;
                }
            }
            
            if(bolMatch == true) {
                //if there was a match, do not process
            } else {
                
                lstEventsForEmail.add(appt);
            }
            
        }
        
        //create emails
        
        Messaging.Singleemailmessage tempEmail = new Messaging.Singleemailmessage();
        set<Messaging.Singleemailmessage> lstEmailstoSend = new set<Messaging.Singleemailmessage>();
        
        User usr = [select id from User where ProfileId = :utilIds.mentalHealthSupervisor and isActive = true limit 1];
        //User usr = [select id from User where Name = 'Matt Britton' and isActive = true limit 1];
      
        for(Event e: lstEventsforEmail) {
            
            tempEmail = new Messaging.Singleemailmessage();
            tempEmail.setTargetObjectId(usr.id);
            tempEmail.setSubject('Alert--Outpatient Referral Appointment may be missing for ' 
                + mapContacts.get(e.whoID).Name);
            tempEmail.saveAsActivity = false;
            tempEmail.setPlainTextBody('Client: ' + mapContacts.get(e.whoId).Name + '\n'
            + 'Appointment Date: ' + e.ActivityDate.format() + '\n'
            + 'Link to Appointment in Salesforce: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + e.id);
        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { tempEmail });
        }           
    }

}