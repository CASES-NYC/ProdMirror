public with sharing class SearchOnMobileController {
    public SearchOnMobileController(){
      
    } 
 public string searchValue{get;set;}
  public List<SelectOption> SearchItems;
   public List<SelectOption> getSearchItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Docket','Docket/Indictment'));
        options.add(new SelectOption('NYSID','NYSID'));
        options.add(new SelectOption('Name','Name'));
        return options;
   }
   public void setSearchItems(){
    SearchItems = this.SearchItems;
   } 
  string searchParameter{get;set;} 
 public string fnameValue{get;set;}   
 public string lnameValue{get;set;}   
 public string docketValue{get;set;}   
 public string nysidValue{get;set;}   


 public class clients{
    public string  cname{get;set;}
    public string  strIntakeDate{get;set;}
    public string  strExitDate{get;set;}
    public string  status{get;set;}
    public string  docket{get;set;}
    public string  nysid{get;set;}
    public string  docname{get;set;}
    public string  pcid{get;set;}
 } 
   Id accClient = Utility_Id__c.getValues('Client').RecordType_Id__c;
 
   List<clients> lstclients = new List<clients>();
   public List<clients> lstclientsShow{get;set;}
   
   clients oneclient = new clients();
   
   public void selectClient(){
   	if (lstclients != null)
   	    lstclients.clear();
   	string strWhere = '';
    string selectCases = 'SELECT Case_Type__c,Client_Name__c,Docket__c,Name,Program__c,Contact__c, ' + 
    'docket_name__c, Indictment__c, Docket_Indictment__c, Boro_Court__c,CaseBoro__c,pcid__c,nysid__c, '+ 
    'programId__c,firstname__c, lastname__c FROM Case_Relationship__c where ' ;  
       
    if (searchValue == 'Docket'){
       searchParameter = docketValue.trim().toUpperCase();
       strWhere += ' docket_name__c =:  searchParameter or Docket_Indictment__c =: searchParameter'; 
 
 //      strWhere += ' docket_name__c LIKE \'%' + searchParameter.right(6) + '%\' ' 
   //         + 'or Docket_Indictment__c =: searchParameter'; 
     }
     else{
        if (searchValue == 'Name'){
        	searchParameter = fnameValue + lnameValue;
         strWhere =  ' FirstName__c LIKE \'%' + fnameValue + '%\' ' + 
          'and  (LastName__c LIKE \'%' + lnameValue  + '%\' OR lastNameSoundex__c = \'' 
                    + Utility_Soundex.toSoundex(lnameValue) + '\')';  
        }
         
      else{
         if (searchValue == 'NYSID'){ 
            searchParameter = nysidValue.toUpperCase();
            strWhere = ' NYSID__c  =:  searchParameter'; 
  /*
            strWhere = ' NYSID__c LIKE \'%' + searchParameter + '%\' '
               + ' OR NYSID__c LIKE \'%' + searchParameter + '%\' '               
               + ' OR NYSID__c LIKE \'%' + searchParameter.mid(0,6) + '%\' '
               + ' OR NYSID__c LIKE \'%' + searchParameter.mid(1,6) + '%\' '
               + ' OR NYSID__c LIKE \'%' + searchParameter.mid(2,6) + '%\' '
               + ' OR NYSID__c LIKE \'%' + searchParameter.mid(3,6) + '%\' ';            
     */
              } }}
        Map<string,string> mapDocName = new Map<string,string>();
        Map<string,string> mapDoc = new Map<string,string>();
              Set<String> iDs = new Set<String>(); 
        if ( strWhere == '' || searchParameter == ''){
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Please enter a search criteria'));
              return;}
        else{
        	selectCases += strWhere;
        	List<Case_Relationship__c> lstSelected = Database.Query(selectCases);
        	if (lstSelected.Size() != 0){
         
               for (Case_Relationship__c cr: lstSelected){
                   iDs.add(cr.Contact__c);	
                   if (cr.Indictment__c != '' && cr.Indictment__c != null) 
                      mapDocName.put(cr.Contact__c,'Indictment');
                   else
                      mapDocName.put(cr.Contact__c,'Docket');
                   mapDoc.put(cr.Contact__c,cr.Docket_Indictment__c);
               }}
           else{
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'No Clients found'));
              return;
            }     
            
              
            for (Contact c : [Select name,Client_Status__c, Next_Court_Date__c,p_c_id__c,
           Current_Intake_Date__c, current_exit_date__c,Current_Exit_Type__c,NYSID__c
           from Contact where id in: iDs and Client_Status__c != : 'Never Enrolled'   
              order by name]){
              oneclient = new clients();
              oneclient.cname = c.name;
              if (c.Current_Intake_Date__c != null)
                 oneclient.strIntakeDate = c.Current_Intake_Date__c.format();
              if (c.Current_Exit_Date__c != null)
                 oneclient.strExitDate = c.Current_Exit_Date__c.format();
              oneclient.pcid = c.P_C_ID__c;
              oneclient.docket = mapdoc.get(c.id);
         
              oneclient.docname = mapdocName.get(c.id);
              oneClient.nysid = c.NYSID__c;              
              lstclients.add(oneclient);
           }
          lstclientsShow = lstclients;
          }
          }
    //    }
     public PageReference returnToHomePage(){
     	PageReference pageRef = new PageReference('/home/home.jsp');
        pageRef.setRedirect(true);
         return pageRef;
     	
     	
     }   
   }