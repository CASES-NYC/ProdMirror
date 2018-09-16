public with sharing class ClientInfoController {
   public String clientPassed = System.currentPagereference().getParameters().get('selectedId');    
   public Id progPlanPassed = System.currentPagereference().getParameters().get('selectedPP');    

   public reportQuery rq = new reportQuery();
   public String clientName{get;set;}  
   public String pcID{get;set;}  
   public String clientID{get;set;}  
   public string caseId{get;set;} 
   public string accountId{get;set;}  
   public string intakeCaseId{get;set;} 
   public string docket{get;set;} 
   public string prgId{get;set;} 
   public string prgName{get;set;} 
   
   public ClientInfoController(){
   if (clientPassed <> null)
   	    selectInfobyclientID(clientPassed);
    else{
    	if (progPlanPassed <> null)
     		selectInfobyProgramID(progPlanPassed);
    }}
  
   public void selectInfobyclientID(string clientPassed){
   	  Map<Id, Contact> mapContact = rq.contactQuery(clientPassed); 
         rq.caseInfoQuery(accountId);         
         clientName = mapContact.get(clientPassed).firstname + ' ' + mapContact.get(clientPassed).lastname;   
         pcID = mapContact.get(clientPassed).P_C_ID__c;
         clientID = clientPassed;
         accountId = mapContact.get(clientPassed).accountId;
         intakeCaseId = mapContact.get(clientPassed).intake_case__c;
         docket = rq.caseName(intakeCaseId);}

   public void selectInfobyProgramID(Id progPlanPassed){
   //   	 clientPassed = rq.progInfo(progPlanPassed);    
         for (Program_Plan__c p : [Select Client_name__c, id
           From Program_Plan__c  where id =: progPlanPassed]){
           clientPassed  = p.Client_name__c;}
           
  	 Map<Id, Contact> mapContact = rq.contactQuery(clientPassed); 
         rq.caseInfoQuery(accountId);         
         clientName = mapContact.get(clientPassed).firstname + ' ' + mapContact.get(clientPassed).lastname;   
         pcID = mapContact.get(clientPassed).P_C_ID__c;
         clientID = clientPassed;
         accountId = mapContact.get(clientPassed).accountId;
         intakeCaseId = mapContact.get(clientPassed).intake_case__c;
         docket = rq.caseName(intakeCaseId);	
         for (Program_Plan__c pp : [Select p.Client_Name__r.Name, p.Client_Name__c,p.id,
               p.name From Program_Plan__c p where id =: progPlanPassed]){
               prgName = pp.name;}
            }
}