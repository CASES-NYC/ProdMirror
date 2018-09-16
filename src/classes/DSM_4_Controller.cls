public with sharing class DSM_4_Controller {
   public String progPlanPassed = System.currentPagereference().getParameters().get('selectedPP');    
   public String clientPassed{get;set;} 
   public ClientInfoController clientInfo { get; set; }
   public String account{get;set;}
   public reportQuery rq = new reportQuery();
   public List<CLSallDiag> lstDiagShow = new List<CLSallDiag>();
	public List<CLSallDiag> lstDiagJail = new List<CLSallDiag>();
	public List<CLSallDiag> lstDiagCurrent = new List<CLSallDiag>();
    public string diagType{get;set;}	
   public string fieldValue{get;set;}
   public string id2delete{get;set;}
	public String CodesList1{get;set;}
	public String CodesList2{get;set;}
	public String CodesList3{get;set;}
	public String CodesList4{get;set;}
	public String CodesList5{get;set;}
	public string selectedValue{get;set;}
	public String pl1{get;set;}
	public String pl2{get;set;}
	public String pl3{get;set;}
	public String pl4{get;set;}
	public String pl5{get;set;}
	public String v1{get;set;}
	public String v2{get;set;}
	public String v3{get;set;}
	public String v4{get;set;} 
	public String v5{get;set;}
    public string ctype {get;set;}  

     public DSM_4_Controller(){ 
    	clientPassed = rq.progInfo(progPlanPassed);
     	buildDiagnosisInfo();}

    public void deleteDiag(){
      Client_Diagnosis__c diag = new Client_Diagnosis__c(id=id2delete);
      if (diag <> null)
         delete diag;
         saveProgramPlan();
         buildDiagnosisInfo();}

   public class CLSallDiag{
   public String diagname{get;set;}
   public String diagType{get;set;}
   public String diagid{get;set;}
   public String clientid{get;set;}      
   public integer itemnumber{get;set;}
   public String account{get;set;}      
   public String programid{get;set;}      
   public String pc_id{get;set;}}
   public string colorType{get;set;}
   public string allDiag{get;set;}
   public void doNothing(){}
   public boolean displayPopup {get; set;}
   public void closePopup() {displayPopup = false;
      inputValue1 = '';lfound1 = false;inputValue2 = '';lfound2 = false;
      inputValue3 = '';lfound3 = false;inputValue4 = '';lfound4 = false;inputValue5 = '';lfound5 = false;}
   public void showPopup() {
    	displayPopup = true;
      inputValue1 = '';lfound1 = false;inputValue2 = '';lfound2 = false;inputValue3 = '';lfound3 = false;
      inputValue4 = '';lfound4 = false;inputValue5 = '';lfound5 = false;}

    String inputValue1;
    public String getInputValue1(){return inputValue1;}
    public void setInputValue1(String inputValue1){this.inputValue1 = inputValue1;}
    String inputValue2;
    public String getInputValue2(){return inputValue2;}
    public void setInputValue2(String inputValue2){this.inputValue2 = inputValue2;}
    String inputValue3;
    public String getInputValue3(){return inputValue3;}
    public void setInputValue3(String inputValue3){this.inputValue3 = inputValue3;}
    String inputValue4;
    public String getInputValue4(){return inputValue4;}
    public void setInputValue4(String inputValue4){this.inputValue4 = inputValue4;}
    String inputValue5;
    public String getInputValue5(){return inputValue5;}
    public void setInputValue5(String inputValue5){this.inputValue5 = inputValue5;}   
 
    public boolean lfound1{get{
      if (CodesItems1.size() <> 0)
             lfound1 = true; 
      else   lfound1 = false;          	
             return lfound1;}
     set{if (CodesItems1.size() <> 0) 
            lfound1 = true;
         else lfound1 = false; }}             
   public boolean lfound2{get{
      if (CodesItems2.size() <> 0)
             lfound2 = true; 
      else   lfound2 = false;          	
             return lfound2;}
     set{if (CodesItems2.size() <> 0) 
            lfound2 = true;
         else lfound2 = false; }}       

  public boolean lfound3{get{
      if (CodesItems3.size() <> 0)
             lfound3 = true; 
      else   lfound3 = false;          	
             return lfound3;}
     set{if (CodesItems3.size() <> 0) 
            lfound3 = true;
         else lfound3 = false; }} 
  public boolean lfound4{get{
      if (CodesItems4.size() <> 0)
             lfound4 = true; 
      else   lfound4 = false;          	
             return lfound4;}
     set{if (CodesItems4.size() <> 0) 
            lfound4 = true;
         else lfound4 = false; }}
  public boolean lfound5{get{
      if (CodesItems1.size() <> 0)
             lfound5 = true; 
      else   lfound5 = false;          	
             return lfound5;}
     set{if (CodesItems1.size() <> 0) 
            lfound5 = true;
         else lfound5 = false; }}           

                
             
                 public List<SelectOption> CodesItems1 {
    get {pl1 = '';
       	CodesList1 = '';
       List<SelectOption> CodesItems = new List<SelectOption>();
       CodesItems.Clear();
       if (inputValue1 <> ''){
          CodesItems.add(new SelectOption('---Select---','---Select---'));
          String strQueryStart = 'select name,id,description__c from DSM4_code__c where ';
         String strCriteria = ' name LIKE \'%' + inputValue1 + '%\' ';
         strCriteria += ' order by description__c';
         String strQuery = strQueryStart + strCriteria;
         List<DSM4_code__c> lstResults = new List<DSM4_code__c>();
         lstResults = Database.Query(strQuery);
         if (lstResults.Size() <> 0){
            for (DSM4_code__c d : lstResults){
               CodesItems.add(new SelectOption(d.id,d.name));}}
         else CodesItems = new List<SelectOption>();}
         return CodesItems;}}
  
     public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Jail','Jail'));
        options.add(new SelectOption('Current','Current'));
        return options;}
    
      public List<SelectOption> CodesItems2 {
      get{List<SelectOption> CodesItems = new List<SelectOption>();
       CodesItems.Clear();
       if (inputValue2 <> ''){
          CodesItems.add(new SelectOption('---Select---','---Select---'));
          String strQueryStart = 'select name,id,description__c from DSM4_code__c where ';
         String strCriteria = ' name LIKE \'%' + inputValue2 + '%\' ';
         strCriteria += ' order by description__c';
         String strQuery = strQueryStart + strCriteria;
         List<DSM4_code__c> lstResults = new List<DSM4_code__c>();
         lstResults = Database.Query(strQuery);
         if (lstResults.Size() <> 0){
            for (DSM4_code__c d : lstResults){
               CodesItems.add(new SelectOption(d.id,d.name));}}
         else CodesItems = new List<SelectOption>();}
          return CodesItems; }}
        public List<SelectOption> CodesItems3 {
    get{List<SelectOption> CodesItems = new List<SelectOption>();
       CodesItems.Clear();
       if (inputValue3 <> ''){
          CodesItems.add(new SelectOption('---Select---','---Select---'));
          String strQueryStart = 'select name,id,description__c from DSM4_code__c where ';
         String strCriteria = ' name LIKE \'%' + inputValue3 + '%\' ';
         strCriteria += ' order by description__c';
         String strQuery = strQueryStart + strCriteria;
         List<DSM4_code__c> lstResults = new List<DSM4_code__c>();
         lstResults = Database.Query(strQuery);
         if (lstResults.Size() <> 0){
            for (DSM4_code__c d : lstResults){
               CodesItems.add(new SelectOption(d.id,d.name));}}
         else CodesItems = new List<SelectOption>();}
        return CodesItems; }}
     public List<SelectOption> CodesItems4 {
    get{List<SelectOption> CodesItems = new List<SelectOption>();
       CodesItems.Clear();
       if (inputValue4 <> ''){
          CodesItems.add(new SelectOption('---Select---','---Select---'));
          String strQueryStart = 'select name,id,description__c from DSM4_code__c where ';
         String strCriteria = ' name LIKE \'%' + inputValue4 + '%\' ';
         strCriteria += ' order by description__c';
         String strQuery = strQueryStart + strCriteria;
         List<DSM4_code__c> lstResults = new List<DSM4_code__c>();
         lstResults = Database.Query(strQuery);
         if (lstResults.Size() <> 0){
            for (DSM4_code__c d : lstResults){
               CodesItems.add(new SelectOption(d.id,d.name));}}
         else CodesItems = new List<SelectOption>(); }
        return CodesItems;}}
     
    public List<SelectOption> CodesItems5 {
    get{List<SelectOption> CodesItems = new List<SelectOption>();
       CodesItems.clear();
       if (inputValue5 <> ''){
          CodesItems.add(new SelectOption('---Select---','---Select---'));
          String strQueryStart = 'select name,id,description__c from DSM4_code__c where ';
         String strCriteria = ' name LIKE \'%' + inputValue5 + '%\' ';
         strCriteria += ' order by description__c';
         String strQuery = strQueryStart + strCriteria;
         List<DSM4_code__c> lstResults = new List<DSM4_code__c>();
         lstResults = Database.Query(strQuery);
         if (lstResults.Size() <> 0){
            for (DSM4_code__c d : lstResults){
               CodesItems.add(new SelectOption(d.id,d.name));}}
         else CodesItems = new List<SelectOption>(); 
         }
        return CodesItems; }}
    string textMessage; 
    public string getMessage(){
    	string textMessage = ''; 
        if (pl1 == '')
           textMessage =  ' Nothing to Save.';      	   
       return textMessage;} 

     public void SaveSelectedDiag(){
         List<Client_Diagnosis__c> lstDiag = new List<Client_Diagnosis__c>();
         Client_Diagnosis__c oneRec = new Client_Diagnosis__c();
    	 Map<Id, Contact> mapContact = rq.contactQuery(clientPassed); 
         system.Debug('\n\n XXX clientPassed: ' + clientPassed);  
         string pcId, contactId,accountId;
         pcId = mapContact.get(clientPassed).P_C_ID__c;
         contactId = clientPassed;
         accountId = mapContact.get(clientPassed).accountId;
         oneRec.Program_Plan__c = progPlanPassed;
        	string newJail = '';
       	string newCurrent = '';
     	string cid = clientPassed ;
     	boolean addDiag;
 	    String selectedDiag = '';
        if (pl1 != '' && pl1.contains('-Select') == false){
           oneRec.description__c = pl1;
           oneRec.Contact__c = contactId;
           oneRec.account__c = accountId;
           oneRec.P_C_ID__c = pcId;
           oneRec.Type__c = diagtype;
           addDiag = checkDiag(oneRec.description__c,oneRec.type__c);
       	  if (addDiag == true){
       	     lstDiag.Add(oneRec);
       	     if (diagtype == 'Jail')
       	        newJail = oneRec.description__c + ';';
       	     else  newCurrent = oneRec.description__c + ';';}}
        if (pl2 != '' && pl2.contains('-Select') == false){
           oneRec = new Client_Diagnosis__c();
           oneRec.description__c = pl2;
           oneRec.Contact__c = contactId;
           oneRec.account__c = accountId;
           oneRec.P_C_ID__c = pcId;
           oneRec.Type__c = diagtype;
           oneRec.description__c = pl2;
           oneRec.Program_Plan__c = progPlanPassed;           
           addDiag = checkDiag(oneRec.description__c,oneRec.type__c);
          	  if (addDiag == true){
       	     lstDiag.Add(oneRec);
       	     if (diagtype == 'Jail')
       	        newJail = oneRec.description__c + ';';
       	     else newCurrent = oneRec.description__c + ';';}}
         if (pl3 != '' && pl3.contains('-Select') == false){
 	         oneRec = new Client_Diagnosis__c();
           oneRec.description__c = pl3;
           oneRec.Contact__c = contactId;
           oneRec.account__c = accountId;
           oneRec.P_C_ID__c = pcId;
           oneRec.Type__c = diagtype; 	         
            oneRec.description__c = pl3;
           oneRec.Program_Plan__c = progPlanPassed;           
            addDiag = checkDiag(oneRec.description__c,oneRec.type__c);
          	  if (addDiag == true){
       	     lstDiag.Add(oneRec);
       	     if (diagtype == 'Jail')
       	        newJail = oneRec.description__c + ';';
       	     else newCurrent = oneRec.description__c + ';';}}
        if (pl4 != '' && pl1.contains('-Select') == false){
	       oneRec = new Client_Diagnosis__c();
       oneRec.description__c = pl4;
           oneRec.Contact__c = contactId;
           oneRec.account__c = accountId;
           oneRec.P_C_ID__c = pcId;
           oneRec.Type__c = diagtype;
           oneRec.Program_Plan__c = progPlanPassed;           
           addDiag = checkDiag(oneRec.description__c,oneRec.type__c);
           	  if (addDiag == true){
       	     lstDiag.Add(oneRec);
       	     if (diagtype == 'Jail')
       	        newJail = oneRec.description__c + ';';
       	     else newCurrent = oneRec.description__c + ';';}}
        if (pl5 != ''&& pl1.contains('-Select') == false){
	       oneRec = new Client_Diagnosis__c();
       oneRec.description__c = pl5;
           oneRec.Contact__c = contactId;
           oneRec.account__c = accountId;
           oneRec.P_C_ID__c = pcId;
           oneRec.Type__c = diagtype;
           oneRec.Program_Plan__c = progPlanPassed;           
           addDiag = checkDiag(oneRec.description__c,oneRec.type__c);
           if (addDiag == true){
       	     lstDiag.Add(oneRec);
       	     if (diagtype == 'Jail')
       	        newJail = oneRec.description__c + ';';
       	     else newCurrent = oneRec.description__c + ';';}}
     	if (lstDiag.Size() != 0){
     	   insert lstDiag;
     	   saveProgramPlan();
    	   buildDiagnosisInfo();}
     	displayPopup = false;}
     	
     public List<CLSallDiag> diagnosis{get;set;}
     public List<CLSallDiag> diagnosisJail{get;set;} 
     public List<CLSallDiag> diagnosisCurrent{get;set;}

     public void buildDiagnosisInfo(){ 
       	lstDiagJail = new List<CLSallDiag>();
       	lstDiagJail.Clear();
       	lstDiagCurrent = new List<CLSallDiag>();
       	lstDiagCurrent.Clear();
     	CLSallDiag oneRec = new CLSallDiag();
     	integer ijail = 1;
     	integer icurr = 1;
       	for (Client_Diagnosis__c d : [select id,name,type__c, contact__c,description__c from Client_Diagnosis__c
         where program_plan__c =: progPlanPassed order by name]){
         	oneRec = new CLSallDiag();
         	oneRec.diagname = d.description__c;
         	oneRec.diagtype = d.type__c;
         	oneRec.clientid = d.contact__c;
         	oneRec.diagid = d.id;
         	if (d.type__c == 'Jail'){
   	          	oneRec.itemnumber = ijail;
         	    lstDiagJail.add(oneRec);
         	    ijail ++;}
         	else{oneRec.itemnumber = icurr;
          	    lstDiagCurrent.add(oneRec);
         	    icurr++;}}
        if (lstDiagJail.Size() <> 0)
           diagnosisJail = lstDiagJail;  
        if (lstDiagCurrent.Size() <> 0)
           diagnosisCurrent = lstDiagCurrent;}
     public boolean checkDiag(string s, string t){
     	boolean ladd = true;
     for (Client_Diagnosis__c d : [select id,description__c,type__c, contact__c from Client_Diagnosis__c
         where Program_Plan__c =: progPlanPassed]){
     	 if (d.description__c == s &&  d.type__c == t){
     			ladd = false;
     			break;}}
     return ladd;}
     
     public void saveProgramPlan(){
  	   Program_Plan__c oneRecPP = new Program_Plan__c(id=progPlanPassed);
  	   string strJail = '';
  	   string strcurrent = '';
       for (Client_Diagnosis__c d : [select id,description__c,type__c, contact__c from Client_Diagnosis__c
         where Program_Plan__c =: progPlanPassed ]){
         	oneRecPP = new Program_Plan__c(id=progPlanPassed);
         if (d.type__c == 'Jail'){
            if (strJail == '')
               strJail = d.description__c;
            else
               strJail += ';' + d.description__c;
         } 
         else{
            if (strcurrent == '')
               strcurrent = d.description__c;
            else
               strcurrent += ';' + d.description__c;}}
         oneRecPP.Jail_Based_Diagnosis_New__c = strJail;
         oneRecPP.Current_Diagnosis_New__c = strcurrent;
         update(oneRecPP);}}