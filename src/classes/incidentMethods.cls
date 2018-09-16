public class incidentMethods {

    // this class added 5/21/13 MB. It includes methods for Incident Participants
    utilityIds utilIds = new utilityIds();
    
    public void setProgramPlanField(list<Incident_Participation__c> lstIPs) {
        
        list<Id> lstClientIds = new list<Id>();
        list<Program_Plan__c> lstPPs = new list<Program_Plan__c>();
        map<id, id> mapPPs = new map<id, id>();
        
        //get client ids
        for(Incident_Participation__c ip: lstIPs) {
            
            lstClientIds.add(ip.Client__c);     
        }
        
        //find all program plans
        lstPPs = [select id, client_name__c from Program_Plan__c where client_name__c in :lstClientIds 
                  and Most_Recent_Program_Plan__c = true];
                 
        //create a map
        for(Program_Plan__c pp: lstPPs) {   
            
            mapPPs.put(pp.Client_Name__c, pp.Id);
        }            
        
        //loop and set program_plan field on Incident Participation
        for(Incident_Participation__c ip: lstIps) {
                    
            //set field value
            ip.Program_Plan__c = mapPPs.get(ip.Client__c);      
        }           
        
    }
    
    
    public void sendIncidentReportEmail(list<Incident_Participation__c> lstParticipants) {
        
        //get Incident Reports
        list<Id> lstPartIds = new list<Id>();
        list<Id> lstReportIds = new list<Id>();
        
        for(Incident_Participation__c ip: lstParticipants) {
            
            lstPartIds.add(ip.id);
            lstReportIds.add(ip.Incident_Report__c);
        }
        
        list<Incident_Participation__c> lstReportInfo = [select id, Incident_Report__c,
                                                         Incident_Report__r.Name, 
                                                         Incident_Date__c, 
                                                         Incident_Report__r.Incident_Time__c,
                                                         Incident_Report__r.Degree_of_Harm_Caused__c, 
                                                         Incident_Report__r.Incident_Category__c, 
                                                         Incident_Report__r.Participants_Involved__c, 
                                                         Incident_Report__r.Incident_Description__c,
                                                         Client__r.RecordTypeId
                                                         from Incident_Participation__c where id in :lstPartIds];
        
        //build user list for each program
        
        map<String, List<String>> mapClientTypetoEmails = new map<String, List<String>>();      
        
        //all
        mapClientTypetoEmails.put('all', new list<String>());
        mapClientTypetoEmails.get('all').add(utilIds.cepDirector);
        mapClientTypetoEmails.get('all').add(utilIds.cepDeputyDirector);
        
        //CEP
        mapClientTypetoEmails.put(utilIds.conClient, new list<String>());   
        mapClientTypetoEmails.get(utilIds.conClient).add(utilIds.courtServicesSupervisor);
        
        //CJC/JS
        mapClientTypetoEmails.put(utilIds.conCJC, new list<String>());
        mapClientTypetoEmails.put(utilIds.conJS, new list<String>());
        mapClientTypetoEmails.get(utilIds.conCJC).add(utilIds.cjcJSAdmin);
        mapClientTypetoEmails.get(utilIds.conJS).add(utilIds.cjcJSAdmin);
        
        //QJC
        mapClientTypetoEmails.put(utilIds.conQJC, new list<String>());
        mapClientTypetoEmails.get(utilIds.conQJC).add(utilIds.qjcAdmin);
        
        //get emails
        
        list <User> lstTempUser = new list<User>();
        
        for(String clientType: mapClientTypetoEmails.keySet()) {
            
            lstTempUser = [select id, email from User 
                           where Profile.Id in :mapClientTypetoEmails.get(clientType) and isActive = true];
            mapClientTypetoEmails.put(clientType, new list<String>());
            
            for(User u: lstTempUser) {
                
                mapClientTypetoEmails.get(clientType).add(u.Email);
            }
        }
        
        // get all Incident Participant records for these reports, so we don't send duplicate emails
        list<Incident_Participation__c> lstAllParticipants = [select id, Client__c, Client__r.RecordTypeId, Incident_Report__c 
                                                                from Incident_Participation__c 
                                                                where Incident_Report__c in :lstReportIds];
                                                                                                                
        boolean bolEmailProgram = true;
        boolean bolEmailAll = true;                                                     
        list<String> lstTempToAddresses = new list<String>();   
        boolean bolDisplayTime = true;                                                  
        
        //send out a notification email for each incident report
        for(Incident_Participation__c ip: lstReportInfo) {
            
            //reset variables for each inserted participant record
            lstTempToAddresses = new list<String>();
            bolEmailProgram = true;
            bolEmailAll = true;
            bolDisplayTime = true;
            
            //don't send emails to program-specific staff if a client of the same record type was already added
            // to the report. don't send an email to the "all" staff if any participant was already added to the report
            for(Incident_Participation__c allIP:lstAllParticipants ) {
                
                if(ip.Incident_Report__c == allIP.Incident_Report__c && ip.Id != allIP.id) {
                    
                    //don't email the All folks
                    bolEmailAll = false;
                    
                    if(ip.Client__r.RecordTypeId == allIP.client__r.RecordTypeId
                    || !mapClientTypetoEmails.containsKey(ip.Client__r.RecordTypeId)) {
                        //don't email the program-specific folks
                        bolEmailProgram = false;
                        break;
                    }
                }
            }
            
            if(bolEmailProgram) {
                
                //add emails to TO: list
                if(mapClientTypetoEmails.containsKey(ip.Client__r.RecordTypeId)) {
                    lstTempToAddresses.addAll(mapClientTypetoEmails.get(ip.Client__r.RecordTypeId));
                }
            }
            
            if(bolEmailAll) {
                
                //add emails to TO: list
                lstTempToAddresses.addAll(mapClientTypetoEmails.get('all'));
                lstTempToAddresses.add('dmcclary@cases.org');
            }
            
            if(lstTempToAddresses.size() > 0) {
                
                if(ip.Incident_Report__r.Incident_Time__c == null) {
                    bolDisplayTime = false;
                }
            
                //set email text
                string mailText = 'Incident Date: ' + ip.Incident_Date__c.format();
                if(bolDisplayTime) {
                    mailText = mailText + ' at ' + ip.Incident_Report__r.Incident_Time__c;
                } 

                mailText = mailText + '\nDegree of Harm Caused: ' + ip.Incident_Report__r.Degree_of_Harm_Caused__c
                + '\nIncident Type: ' + ip.Incident_Report__r.Incident_Category__c
                + '\nParticipants Involved: ' + ip.Incident_Report__r.Participants_Involved__c
                + '\nLink to Incident Report in Salesforce: ' 
                +  URL.getSalesforceBaseUrl().toExternalForm() + '/' + ip.Incident_Report__c
                +'\n\nIncident Description: ' + ip.Incident_Report__r.Incident_Description__c;
                
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                mail.setToAddresses(lstTempToAddresses);
                mail.setSubject('New Incident Report: ' + ip.Incident_Report__r.Name);
                mail.setPlainTextBody(mailText);
                mail.saveAsActivity = false;    
                
                //send message
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
            }
        }
    }

}