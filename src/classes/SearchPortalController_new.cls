public class SearchPortalController_new { 
    public utilityIds utilIds = new utilityIds();
    public hClsSearch clsSearch {get;set;}
    public String strTest {get;set;}
    public String strStatusMessage {get;set;}
    public Boolean bolSearchExecuted {get;set;}
    public Boolean bolQueryExactMatch {get;set;}
    public Id idNewAccount;
    public boolean CEPclient{get;set;}    
    public String strUserType {get;set;}
    public boolean sfAdmin{get;set;}  
    //create this map so we can get the date of the TRP class that's selected by the user
    public Map<Id, Date> mapTRPClasses = new map<Id, Date>();   

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    public SearchPortalController_new() { 
        sfAdmin = false;
        strUserType = 'TEST';
        Id userProfId = userInfo.getProfileId();
        string username = userInfo.getUserName();
        For (Profile p : [Select name from Profile where id =: userProfId limit 1]){
           if (p.name.substring(0,3) == 'Court Staff') {
               sfAdmin = true;
          }

           if (p.name.substring(0,3) == 'CEP') {
               strUserType = 'CEP';
           } else  if (p.name.substring(0,5) == 'START') { 
               strUserType = 'START';
           } else if (p.Name == 'System Administrator' || p.Name == 'Strategic Planning' || p.Name == 'Court Staff' || p.Name == 'Program Staff') {
               sfAdmin = true;
           }
               
        }
        id userid = userInfo.getuserID ();
           User u = [select firstname, lastname from user where id =: userId];

        username = u.FirstName + ' ' + u.lastname;  
        
         if (username == 'Karen Dubin-McKnight') 
              sfAdmin = true;
        System.Debug('\n\n XXX strUserType: ' + strUserType);
        clsSearch = new hClsSearch(); 
        bolSearchExecuted = false;
        bolQueryExactMatch = false;
    }
    
    ///////////////////////////////
    // GET/SET
    ///////////////////////////////
    public List<SelectOption> getlstTRPClasses() {
        
        List<SelectOption> lstTemp = new List<SelectOption>();
        
        List<Class__c> lstClasses = [SELECT Id, Class_Title__c,First_Session_On__c FROM Class__c 
                                        WHERE CategoryRPT__c = 'TRP One Day Session' 
                                        AND First_Session_On__c >= :System.Today().addMonths(-2) 
                                        AND First_Session_On__c <= :System.Today().addMonths(3) 
                                        ORDER BY First_Session_On__c ASC];
        for(Class__c c : lstClasses) {                  
            lstTemp.add(new SelectOption(c.Id, string.valueOf(c.First_Session_On__c)));
            mapTRPClasses.put(c.id, c.First_Session_On__c);
            //set default as the first class on or after toda's date, or if that does not exist, the latest class
            if(clsSearch.strTRPClass == '' || mapTRPClasses.get(clsSearch.strTRPClass) < system.today()) {
                clsSearch.strTRPClass = c.id;
            }}
        return lstTemp;
    }
    
    public List<SelectOption> getUserTypes() {
        List<SelectOption> lstTemp = new List<SelectOption>();
        lstTemp.add(new SelectOption('CEP', 'CEP'));
        lstTemp.add(new SelectOption('START', 'START'));
        return lstTemp;}    
    ////////////////////////////////
    // Action Methods
    ////////////////////////////////
    public void doNothing() {
        showProcess = false;
        lstAllResults = new  List<wholeInfo>();
    }
    
    public boolean showProcess{get;set;}    
    
    public PageReference createBasicDataForStart() {
        Account aNew = new Account();
        aNew.Name = clsSearch.strFirstName + ' ' + clsSearch.strLastName;
        aNew.DOB__c = clsSearch.tskSearch.ActivityDate;
        aNew.NYSID_Number__c = clsSearch.strNYSID.toUpperCase();
        aNew.RecordTypeId = utilIds.accClient;
        try {
            insert aNew;
            idNewAccount = aNew.Id;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client. '
            + 'Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            return null;
        }
        PageReference prInterview = new PageReference('/apex/STARTInterviewPage1?G_AccountId=' + aNew.Id + '&DocketName=' + clsSearch.strDocket + '&AccountName=' + aNew.Name);
        prInterview.setRedirect(true);
        return prInterview;
    }
    
    public PageReference createBasicDataForCEP() {
        try {    
            Account aNew = new Account();
            aNew.Name = clsSearch.strFirstName + ' ' + clsSearch.strLastName;
            aNew.DOB__c = clsSearch.tskSearch.ActivityDate;
            aNew.NYSID_Number__c = clsSearch.strNYSID.toUpperCase();
            aNew.RecordTypeId = utilIds.accClient;
            insert aNew;
            
            Case_Information__c ciNew = new Case_Information__c();
            ciNew.Client_Account__c = aNew.Id;
            ciNew.Name = clsSearch.strDocket.toUpperCase();
            if(clsSearch.strDocket == 'Docket NA') 
                ciNew.No_Docket__c = true;
            ciNew.RecordTypeId = utilIds.caseInfoSupremeCourt;
            insert ciNew;
            
            Contact cNew = new Contact();
            cNew.accountId = aNew.Id;
            cNew.Intake_Case__c = ciNew.Id;
            cNew.RecordTypeId = utilIds.conClient;
            cNew.FirstName = clsSearch.strFirstName;
            cNew.LastName = clsSearch.strLastName;
            insert cNew;

        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  '
            + 'Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
            return null;
        }
        PageReference prInterview = new PageReference('/apex/allCourtsPage?sfdc.tabName=01r600000001pGV');
        prInterview.setRedirect(true);
        return prInterview;
    }    
    
    public PageReference prRef = null;
    public PageReference createTRPContact() {
        showProcess = true;
        Boolean bolIntake = false; //new client
        Boolean bolReinstate = false; //existing contact, unsuccessful cycle
        Boolean bolEnrollClientOnly = false; //existing contact, new enrollment
        Boolean bolCreateContactOnly = false; //existing account and case, new contact
        Boolean bolError = false;
        
        list<Contact> lstCaseMatches = new list<Contact>();
        list<Case_Information__c> lstOtherCaseMatches = new list<Case_Information__c>();
        list<Enrollment__c> lstTRPEnrollments = new list<Enrollment__c>();
        list<Event> lstTRPActivities = new list<Event>();
        
        //Check for existing dockets and display error message or re-enroll client as needed
        lstCaseMatches = [select id, Intake_Case__c, Intake_Case__r.Name, PRP_Status__c, current_exit_type__c, RecordTypeID, AccountId
                            from Contact where Intake_Case__r.Name =:clsSearch.strDocket 
                            order by Current_Intake_Date__c desc Nulls First
                            limit 1]; //if there are multiple contacts with this intake case (unlikely), then find active ones first
                            //and if no active, then the most recent intake. Active cases indicate that an error should be thrown
        lstOtherCaseMatches = [select id, Client_Account__c from Case_Information__c
                                where Name =:clsSearch.strDocket limit 1];
        if(lstCaseMatches.size() > 0) {
            //12/20/14 MB added separate logic for existing contacts with this intake case that are non-TRP
            if(lstCaseMatches[0].RecordTypeId == utilIds.conTRP) {
                
                lstTRPEnrollments = [select id, Class__r.First_Session_On__c 
                                        from Enrollment__c where Class_Name__c Like 'TRP One Day%'
                                        and Client__c = :lstCaseMatches[0].Id 
                                        order by Class__r.First_Session_On__c desc limit 1];
                //added event check because the migrated TRP clients do not have enrollments                        
                lstTRPActivities = [select id, ActivityDate,verification_status__c from Event
                                        where subject Like 'TRP One Day%'
                                        and whoID = :lstCaseMatches[0].Id
                                        order by ActivityDate desc limit 1];    
              if(lstTRPActivities.size() > 0 && lstTRPActivities[0].verification_status__c == 'Not Verified'){
                   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                   'This client already has an unverified TRP enrollment. Please verify the existing TRP enrollment.' ));
          return null;
          }                                
                                        
                                                            
                if(lstTRPEnrollments.size() > 0 || lstTRPActivities.size() > 0) {
                    if(
                    (lstTRPEnrollments.size() > 0 
                    && lstTRPEnrollments[0].Class__r.First_Session_On__c == mapTRPClasses.get(clsSearch.strTRPClass))
                    || (lstTRPActivities.size() > 0 
                    && lstTRPActivities[0].ActivityDate == mapTRPClasses.get(clsSearch.strTRPClass))
                    || lstCaseMatches[0].PRP_Status__c == 'Successful Exit') {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                            'This client has already been entered, see search results below.'));
                        bolError = true;
                    } else if(lstCaseMatches[0].PRP_Status__c == 'Unsuccessful Exit') {
                        bolReinstate = true;                    
                    } else {
                        //if a new class date has been entered for an existing client, delete the enrollment
                        // (which will delete any appointments as well)
                        if(lstTRPActivities.size() > 0) {
                            delete lstTRPActivities;
                        }
                        if(lstTRPEnrollments.size() > 0) {
                            delete lstTRPEnrollments;
                        }
                        bolEnrollClientOnly = true;
                    }               
                }   
            } else {//old contact is non-TRP
            //if the old contact in Active or Successfully Exited, throw an error. Otherwise create new contact only
            if (lstCaseMatches[0].RecordTypeId == utilIds.conTRP &&(lstCaseMatches[0].PRP_Status__c == 'Successful Exit' || lstCaseMatches[0].PRP_Status__c == null)){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                        'This client has already been entered, see search results below.'));
                    bolError = true;                    
                } else {
                    bolCreateContactOnly = true;
                }
            }                           
        } else if(lstOtherCaseMatches.size() > 0) {
            bolCreateContactOnly = true;
        } else {
            bolIntake = true;                                     
        }
    Account a; 
        if(bolCreateContactOnly) {
            a = new Account(id=lstOtherCaseMatches[0].Client_Account__c);
        } else {
            a = new Account();
        }
        Contact c = new Contact();
        Case_Information__c ci;
        if(bolCreateContactOnly) {
            ci = new Case_Information__c(id=lstOtherCaseMatches[0].Id);
        } else {
            ci = new Case_Information__c();   
        }
        if(bolIntake) {     
            //Create Client Account
            a.Name = clsSearch.strFirstName + ' ' + clsSearch.strLastName;
            a.DOB__c = clsSearch.tskSearch.ActivityDate;
            a.NYSID_Number__c = clsSearch.strNYSID.toUpperCase();
            a.RecordTypeID = utilIds.accClient;
          
            System.Debug('\n\n XXX in TRP create dob: ' + a.DOB__c + ' name: ' + a.name);   
            try {
                insert a;
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                'There was an error creating the new client.  Please post a task to the IS Helpdesk Group in Gmail '
                + 'and provide this information:  \r\rError creating Account: ' + a + '\r\r' + string.valueOf(e)));
                showProcess = false;
                return null;
            }            
            // Create Docket
            ci.Name = clsSearch.strDocket.toUpperCase();
            ci.Client_Account__c = a.Id;
            ci.RecordTypeId = utilIds.caseInfoCriminalCourt;
            try {
                insert ci;
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                'There was an error creating the new client.  Please post a task to the IS Helpdesk Group in Gmail '
                + 'and provide this information:  \r\rError creating docket: ' + ci + '\r\r' + string.valueOf(e)));
         showProcess = false;
                return null;
            }
        }
        if(bolCreateContactOnly || bolIntake) {
            // Create Contact       
            c.FirstName = clsSearch.strFirstName;
            c.LastName = clsSearch.strLastName;
            c.RecordTypeId = utilIds.conTRP;
            c.AccountId = a.Id;
            c.Mandate_Type__c = 'TRP';
            c.Intake_Case__c = ci.Id;
            c.Referral_Date__c = system.today();
            try {
                c.Intake_Date__c = mapTRPClasses.get(clsSearch.strTRPClass);            
                insert c;
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                'There was an error creating the new client.  Please post a task to the IS Helpdesk Group in Gmail '
                + 'and provide this information:  \r\rError creating contact: ' + c + '\r\r' + string.valueOf(e)));
                showProcess = false;
                return null;
            }            
        }        
        if(bolIntake || bolReinstate || bolCreateContactOnly) {
            // Create Program Cycle
            Program_Cycle__c p = new Program_Cycle__c();
            if(bolIntake || bolCreateContactOnly) {
                p.Client__c = c.Id;
                p.Cycle_Type__c = 'Intake';
            } else {
                p.Client__c = lstCaseMatches[0].Id;
                p.Cycle_Type__c = 'Reinstatement';
            }
            p.Start_Date__c = mapTRPClasses.get(clsSearch.strTRPClass);
            p.RecordTypeId = utilIds.progCycleTRP;
            try {
                insert p;
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                'There was an error creating the new client.  Please post a task to the IS Helpdesk Group in Gmail '
                + 'and provide this information:  \r\rError creating cycle: ' + p + '\r\r' + string.valueOf(e)));
               showProcess = false;
                return null;
            }
        }
        if(bolIntake || bolReinstate || bolEnrollClientOnly || bolCreateContactOnly) {
            // Integrate into Class Enrollment Module and Enroll Client in Class
            courseEnrollment clsCE = new courseEnrollment();
            clsCE.strClassId = clsSearch.strTRPClass;
            List<CourseEnrollment.clientsForDisplay> lstClients = new List<CourseEnrollment.clientsForDisplay>();
            CourseEnrollment.clientsForDisplay ceCFD = new CourseEnrollment.clientsForDisplay();
            //query all of the values that are used in the enrollClients() method
            ceCFD.con = (bolIntake||bolCreateContactOnly)?c:[select id, Current_Projected_Exit_Date__c, Client_Status__c
                from Contact where id = :lstCaseMatches[0].Id limit 1];
            ceCFD.chk = true;
            lstClients.add(ceCFD);
            clsCE.lstEnrollees = lstClients;
            
            // A lot of code executes here, provide graceful error if error is encountered!
            try {
                clsCE.enrollClients();
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                'There was an error creating the new client.  Please contact your system administrator '
                + 'and provide this information:  \r\rError creating enrollment: ' + string.valueOf(e)));
                showProcess = false;
                return null;
            }
        }
        if(bolIntake || bolCreateContactOnly) {
            c.Screening_Stage__c = 'Intake Complete';
            update c;
        }
        // Return user to Client detail page
        if(bolError) {
            doCriteriaSearch();
            showProcess = false;
 
            return null;
        } else if(bolIntake || bolCreateContactOnly) {
            prRef = new PageReference('/'+c.Id);
            prRef.setRedirect(true);
            showProcess = false;
            return prRef;
        } else {
            prRef = new PageReference('/'+lstCaseMatches[0].Id);
           prRef.setRedirect(true);
            showProcess = false;
            return prRef;
        }
    }
    public List<wholeInfo> lstAllResults{get;set;}
  
    public class wholeInfo{
        public String Docket {get;set;}
        public String NYSID {get;set;}
        public Id DocketId {get;set;}
        public Id ContactId {get;set;}
        public Id AccountId {get;set;}
        public string fullName {get;set;}
        public string dob {get;set;}        
        public string FirstName {get;set;}
        public String LastName {get;set;}
        public Task tskSearch {get;set;}
        public String strProgram {get;set;}
        public String ProgramStatus {get;set;}
        public Task tskTRPSearch {get;set;}
        public Event evtTRPSearch {get;set;}
        public String strTRPClass {get;set;}
        public string intake_dt{get;set;}
        public string exit_dt{get;set;}
        public string DocketDisplay{get;set;}
        public boolean lContinueScreening{get;set;}
        public boolean lExactMatch{get;set;}
        public boolean lReinstate{get;set;}
        public boolean lEnrollVoluntary{get;set;}
        public boolean lOrientation{get;set;}
        public boolean lScreeningOutcome{get;set;} 
        public boolean lScreenForNewProgram{get;set;} 
        public boolean lDoNotBill{get;set;}
        public boolean repeatCase{get;set;}  
        public string color{get;set;}   
        public string backcolor{get;set;}   
        public string nysidcolor{get;set;}   
        public string casecolor{get;set;}   
        public string nysidbackcolor{get;set;}   
        public string casebackcolor{get;set;} 
        public boolean showcontactLink{get;set;}
        public boolean HistoryRow_1{get;set;} 
        public boolean accountParent{get;set;}       
        public boolean caseParent{get;set;} 
        public String strNewDocket {get;set;}
        public String strDaystillNextCourtDate{get;set;}
        public Boolean bolIntakeCase {get;set;}
        public Boolean boolNoCase {get;set;}
        public ID  contRecTypeId{get;set;}
        
        public SearchPortalController_New controller;
        public wholeInfo(SearchPortalController_New passedController) {
            controller = passedController;
            strDaystillNextCourtDate = '';
            bolIntakeCase = false;
        }
        
        public PageReference ScreenClientonNewDocketCEP() {
            try {
                Account aOld = [select id, First_Name__c, Last_Name__c, Name from Account where id = :accountid];
                Case_Information__c ciNew = new Case_Information__c();
                ciNew.Client_Account__c = aOld.Id;
                ciNew.Name = strNewDocket;
                ciNew.RecordTypeId = controller.utilIds.caseInfoSupremeCourt;
                insert ciNew;
                
                Contact cNew = new Contact();
                cNew.accountId = aOld.Id;
                cNew.Intake_Case__c = ciNew.Id;
               // cNew.RecordTypeId = contRecTypeId;
                cNew.RecordTypeId = controller.utilIds.conClient;
                cNew.FirstName = aOld.First_Name__c;
                cNew.LastName = aOld.Last_Name__c;
                insert cNew;
    
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  '
                + 'Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
                return null;
            }
                        PageReference prInterview = new PageReference('/apex/allCourtsPage');
            prInterview.setRedirect(true);
            return prInterview;
        }  
         public PageReference CreateNewIntakeonThisCaseCEP() {
            try {
                Account aOld = [select id, First_Name__c, Last_Name__c, Name from Account where id = :accountid];
                Contact cNew = new Contact();
                cNew.accountId = aOld.Id;
                cNew.Intake_Case__c = DocketId;
                cNew.RecordTypeId = controller.utilIds.conClient;
                cNew.FirstName = aOld.First_Name__c;
                cNew.LastName = aOld.Last_Name__c;
                insert cNew;
    
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was an error creating the new Client.  '
                + 'Please contact your system administrator and provide this information:  \r\r' + string.valueOf(e)));
                return null;
            }
            PageReference prInterview = new PageReference('/apex/allCourtsPage?sfdc.tabName=01r600000001pGV');
            prInterview.setRedirect(true);
            return prInterview;
        }  
         public PageReference ScreenClientonNewDocketSTART() {
           System.Debug('\n\n XXX in ScreenClientonNewDocketSTART');
            Account aOld = [select id, First_Name__c, Last_Name__c, Name from Account where id = :accountid];
            PageReference prInterview = new PageReference('/apex/STARTInterviewPage1?G_AccountId=' + aOld.Id
                + '&AccountName=' + aOld.Name + '&DoNotBill=false' + '&DocketName=' + strNewDocket);
            prInterview.setRedirect(true);
            return prInterview;
        }      
      
         public PageReference CreateNewIntakeonThisCaseSTART() {
            Account aOld = [select id, First_Name__c, Last_Name__c, Name from Account where id = :accountid];         
            PageReference prInterview = new PageReference('/apex/STARTInterviewPage1?G_AccountId=' + aOld.Id
                + '&AccountName=' + aOld.Name + '&DoNotBill=false' + '&DocketName=' + DocketDisplay);
            prInterview.setRedirect(true);
            return prInterview;
        }                          
    }
    public class hClsSearch {
        public String strDocket {get;set;}
        public String strNYSID {get;set;}
        public string strFirstName {get;set;}
        public String strLastName {get;set;}
        public Task tskSearch {get;set;}
        public String strProgram {get;set;}
        public Task tskTRPSearch {get;set;}
        public Event evtTRPSearch {get;set;}
        public String strTRPClass {get;set;}
        //////////////////////////////////////
        // Constructors
        //////////////////////////////////////
        public hClsSearch() {
            clearSearchCriteria();
        }
        //////////////////////////////////////
        // Action Methods
        //////////////////////////////////////
        public void clearSearchCriteria() {
            
            this.strDocket = '';
            this.strNYSID = '';
            this.strFirstName = '';
            this.strLastName = '';
            this.tskSearch = new Task();
            this.strProgram = '';
            this.strTRPClass = '';            
            this.tskTRPSearch = new Task();
            this.evtTRPSearch = new Event();
        }
    }
    
       public List<Account> lstClsAccounts {get;set;}
      
      
       public void doCriteriaSearch() {
               System.Debug('\n\n XXX strUserType: ' + strUserType);
        strStatusMessage = '';
        bolQueryExactMatch = false;
      //  string cepStatus;
        List<Contact> lstInitialResults = new List<Contact>();
  String strQuery = '';
       String strQueryStart = 'SELECT Id, AccountId, Name, FirstName, '
        + 'LastName, NYSID__c, Date_of_Birth__c, P_C_ID__c, Client_Status__c, '+
        'Next_Court_Date__c, Current_Intake_Date__c, Current_Exit_Date__c, PRP_Status__c, Screening_Stage__c, '
        + 'Intake_Case__c, '+
        'Intake_Case__r.Name, current_exit_type__c,recordtypeid, '
        + 'aka_1__c,aka_2__c From Contact Where (';
        
        String strCriteria = '';
        Integer intCriteriaCount = 0;
        Integer intNameCriteriaCount = 0;
        /* Docket (last 6 characters) */
        if(clsSearch.strDocket != '') {
            if(intCriteriaCount > 0) { strCriteria += ' OR '; }
            strCriteria += ' Intake_Case__r.Name LIKE \'%' + clsSearch.strDocket.right(6) + '%\' ' 
            + ' OR Intake_Case__r.Name LIKE \'%' + clsSearch.strDocket.toUpperCase() + '%\' ' ;
            intCriteriaCount += 1;
        }
        /* NYSID */
        if(clsSearch.strNYSID != '') {
            if(intCriteriaCount > 0) { strCriteria += ' OR '; }
               strCriteria += ' NYSID__c LIKE \'%' + clsSearch.strNYSID + '%\' '
               + ' OR NYSID__c LIKE \'%' + clsSearch.strNYSID.toUpperCase() + '%\' '               
               + ' OR NYSID__c LIKE \'%' + clsSearch.strNYSID.mid(0,6) + '%\' '
               + ' OR NYSID__c LIKE \'%' + clsSearch.strNYSID.mid(1,6) + '%\' '
               + ' OR NYSID__c LIKE \'%' + clsSearch.strNYSID.mid(2,6) + '%\' '
               + ' OR NYSID__c LIKE \'%' + clsSearch.strNYSID.mid(3,6) + '%\' ';
               intCriteriaCount += 1;
        }
        /* First Name */
        if(clsSearch.strFirstName != '' || clsSearch.strLastName != '' || clsSearch.tskSearch.ActivityDate != null) {
            if(intCriteriaCount > 0) { strCriteria += ' OR '; }
                if(clsSearch.strFirstName != '') {  
                    strCriteria += ' (FirstName LIKE \'%' + clsSearch.strFirstName + '%\' ';
                    intNameCriteriaCount += 1;
                    intCriteriaCount += 1;
                }
                if(clsSearch.strLastName != '') {
                    if(intNameCriteriaCount > 0) {strCriteria += ' AND '; }
                    else {strCriteria += ' ( ';}
                    strCriteria += ' (LastName LIKE \'%' + clsSearch.strLastName 
                    + '%\' OR Last_Name_Soundex__c = \'' 
                    + Utility_Soundex.toSoundex(clsSearch.strLastName) + '\')'; 
                    intNameCriteriaCount += 1;  
                    intCriteriaCount += 1;          
                }
                if(clsSearch.tskSearch.ActivityDate != null) {
                    if(intNameCriteriaCount > 0) {strCriteria += ' AND '; }
                    else {strCriteria += ' ( ';}
                    // Formatting Date for Dynamic SOQL
                    Datetime dtmTemp = datetime.newInstance(clsSearch.tskSearch.ActivityDate.Year(), 
                    clsSearch.tskSearch.ActivityDate.Month(), 
                    clsSearch.tskSearch.ActivityDate.Day(), 0,0,0);
                    
                    date d1 = (clsSearch.tskSearch.ActivityDate);
                    strCriteria += ' Date_of_Birth__c = ' + dtmTemp.format('yyyy-MM-dd');
                    intNameCriteriaCount += 1;  
                    intCriteriaCount += 1;                  
                }
               strCriteria += ' ) ';
        }
        // Assemble and Execute Query
        strQuery = strQueryStart + strCriteria 
            + ') ORDER BY Accountid ASC, Intake_Case__c, id, CreatedDate desc LIMIT 100';
        if(intCriteriaCount == 0) {
            strStatusMessage = 'Please fill in at least one field before searching!';
            bolSearchExecuted = false;
            return;   
        }
        if(intCriteriaCount == 5) { bolSearchExecuted = true; } 
            else { bolSearchExecuted = false; } 
        system.debug(bolSearchExecuted);
        system.debug(intCriteriaCount); 
        lstInitialResults = Database.Query(strQuery);
         integer i = 0;
        // LZ ------------
        Set<Id> setAcounts = new Set<Id>();
        for(Contact c: lstInitialResults) {
            setAcounts.add(c.accountId);}
       List<Account> lstAccounts = [SELECT id,name, nysid_number__c from Account
          where id in: setAcounts order by id];
      List<Case_Information__c> lstCases = new List<Case_Information__c>();
      if (clsSearch.strDocket == '' && clsSearch.strFirstName == '' && clsSearch.strLastName == '')
         lstCases = [SELECT  Client_Account__c,id, name, Arrest_Date__c, Indictment__c from Case_Information__c
          where client_account__c in: setAcounts order by Client_Account__c,name];
       else
         lstCases = [SELECT Client_Account__c,id,  name, Arrest_Date__c, Indictment__c from Case_Information__c
          where client_account__c in: setAcounts order by client_account__c,id];
     Set<Id> setContactsId = new Set<Id>();
     Case_Information__c noCases = new Case_Information__c();
     
     MAP<id,string> mapCaseId_Docket = new MAP<id,string>();
     Map<string,Id> mapAKAcase = new Map<string,Id>();
     integer t = 0;
     for (Contact c : lstInitialResults){
      setContactsId.Add(c.id);
          if (c.intake_case__c == null){
            noCases = new Case_Information__c();
            noCases.Client_Account__c = c.AccountId;
            c.aka_1__c = prgName(c.recordtypeid);
            lstCases.add(noCases);
            c.client_status__c = 'not in program';
         }
       else
          mapAKAcase.put(string.valueof(t),c.intake_case__c);
          c.aka_2__c = string.valueof(t);
          t++;
     }  

     for (Case_Information__c cs : lstCases)      {
         mapCaseId_Docket.put(cs.id,cs.name);  
     }
      ID accountId, caseId, caseAccountId,intakeId;  
      wholeInfo oneResult = new wholeInfo(this);  
      lstAllResults = new  List<wholeInfo>();
      string arrestDate;
      integer acctnumber, casenumber;
     // Loop by Account
     boolean contactAdded;
     for (integer a = 0; a <lstAccounts.Size();a++){
         accountId = lstAccounts[a].id;
         // Loop by Case   
        acctnumber = 0;
        casenumber = 0;
        for (integer ci = 0; ci < lstCases.Size();ci++){
           caseAccountId = lstCases[ci].client_account__c;
           caseId = lstCases[ci].id; 
           if (caseAccountId == accountId){
              System.Debug('\n\n XXX caseAccountId == accountId');
              for (integer n = 0; n < lstInitialResults.size(); n++){
                System.Debug('\n\n lstInitialResults[n].P_C_ID__c: ' +  lstInitialResults[n].P_C_ID__c);
                  oneResult = new wholeInfo(this);
                 if (lstInitialResults[n].AccountId == accountId){
                    oneResult = new wholeInfo(this);
                    System.Debug('\n\n XXX inside no cases?');
                    if (lstInitialResults[n].intake_case__c == null){
                       oneResult.strProgram = lstInitialResults[n].aka_1__c;
                       oneResult.Docket = '';
                       oneResult.bolIntakeCase = false;
                       oneResult.docketDisplay = '';
                       oneResult.boolNoCase = true;
                       System.Debug('\n\n XXX if (lstInitialResults[n].intake_case__c == null)');
                     }
                     else {
                         intakeId = mapAKAcase.get(lstInitialResults[n].aka_2__c);
                    
                        System.Debug('\n\n XXX CASE not null');
                         oneResult.DocketId = intakeId;
                         oneResult.bolIntakeCase = true;
                         if (lstInitialResults[n].P_C_ID__c != null)
                            oneResult.strProgram = lstInitialResults[n].P_C_ID__c.left(3);
                         else 
                            oneResult.strProgram = prgName(lstInitialResults[n].recordtypeid);
                         if(lstCases[ci].Name == 'Docket NA') {
                            oneResult.docketDisplay = 'N/A';
                            if(lstCases[ci].Indictment__c != null)
                                 oneResult.docketDisplay += ' Indictment #: '
                                     + lstCases[ci].Indictment__c;
                            if(lstCases[ci].arrest_date__c != null) 
                               oneResult.docketDisplay += ' Arrested: ' 
                                  + string.ValueOf(lstCases[ci].arrest_date__c.format());
                         } else {
                             oneResult.docketDisplay = mapCaseId_Docket.get(intakeId);
                         }
                         } 
                         oneResult.accountid = lstAccounts[a].id;
                         if (lstAccounts[a].nysid_number__c <> null)
                            oneResult.nysid = lstAccounts[a].nysid_number__c.trim();
                         else
                            oneResult.nysid = '';   
                         if (lstCases[ci].name <> null)
                            oneResult.docket = lstCases[ci].name.trim();
                         else
                            oneResult.docket = '';  
                         oneResult.fullname = lstInitialResults[n].name;
                         oneResult.firstname = lstInitialResults[n].firstname;
                         oneResult.lastname = lstInitialResults[n].lastname;
                         oneResult.ContactId = lstInitialResults[n].id;
                         if(lstInitialResults[n].Next_COurt_Date__c != null) {
                             oneResult.strDaystillNextCourtDate = String.valueOf(system.today().daysBetween(lstInitialResults[n].Next_Court_Date__c));
                         }
                         if (oneResult.nysid <> ''){
                            oneResult.nysidcolor  = 'white';
                            oneResult.nysidbackcolor  = 'green';    
                         }
                         else{ 
                            oneResult.nysidcolor  = 'black';
                            oneResult.nysidbackcolor  = 'white';
                         }  
                         if (lstInitialResults[n].Date_of_Birth__c <> null)
                            oneResult.dob = string.ValueOf(lstInitialResults[n].Date_of_Birth__c.format());
                         if (lstInitialResults[n].Current_Intake_Date__c <> null)
                            oneResult.intake_dt= string.ValueOf(lstInitialResults[n].Current_Intake_Date__c.format());
                             oneResult.ProgramStatus = lstInitialResults[n].client_status__c;     
                          if (lstInitialResults[n].Current_Exit_Date__c <> null){ 
                             oneResult.exit_dt= string.ValueOf(lstInitialResults[n].Current_Exit_Date__c.format());
                             if (lstInitialResults[n].P_C_Id__c.contains('CEP'))
                                oneResult.ProgramStatus = stringStatus(lstInitialResults[n].current_exit_type__c);
                             else{
                                if (lstInitialResults[n].prp_Status__c <> null)
                                  oneResult.ProgramStatus = lstInitialResults[n].prp_Status__c;
                                else
                                  oneResult.ProgramStatus = 'Active';
                              }
                          }
                         else
                             oneResult.ProgramStatus = lstInitialResults[n].client_status__c;
                         if (acctnumber == 0){
                           oneResult.accountParent = true;
                           oneResult.casecolor  = 'black';
                           oneResult.casebackcolor  = '#4cc1bb';    
                         }  
                         if (lstInitialResults[n].intake_case__c <> null){
                            if(!lstInitialResults[n].P_C_Id__c.contains('TRP') 
                               && lstInitialResults[n].Client_Status__c != 'Incomplete Screening'
                               && lstInitialResults[n].Client_Status__c != 'Screened')
                                   oneResult.lScreenForNewProgram = true;
                         }   
                         if (strUserType == 'START'){
                            if (lstInitialResults[n].Client_Status__c == 'Screened'
                            || lstInitialResults[n].Client_Status__c == 'Incomplete Screening')
                               oneResult.lContinueScreening = true;
                            if (lstInitialResults[n].PRP_Status__c == 'Unsuccessful Exit')
                              oneResult.lReinstate = true;                             
                            if (lstInitialResults[n].PRP_Status__c == 'Successful Exit'
                              && (lstInitialResults[n].P_C_Id__c.contains('DTC') || 
                             lstInitialResults[n].P_C_Id__c.contains('CCM'))) 
                             oneResult.lEnrollVoluntary = true;
                            if (lstInitialResults[n].Screening_Stage__c == 'Screening Complete' 
                             && lstInitialResults[n].Client_Status__c == 'Active' 
                             && lstInitialResults[n].P_C_Id__c.contains('DTC')) 
                             oneResult.lOrientation = true;                               
                            if (lstInitialResults[n].Screening_Stage__c == 'Screening Complete' 
                              && lstInitialResults[n].Client_Status__c == 'Never Enrolled' 
                              && (lstInitialResults[n].P_C_Id__c.contains('DTC') 
                              || lstInitialResults[n].P_C_Id__c.contains('CCM'))) 
                              oneResult.lScreeningOutcome = true;
                            if(lstInitialResults[n].Client_Status__c == 'Active')
                              oneResult.lDoNotBill = true;
                         }  //Start User buttons
                         if (oneResult.NYSID == clsSearch.strNYSID && oneResult.DOCKET == clsSearch.strdocket)
                             oneResult.lExactMatch = true;
                         if (casenumber == 0)
                            oneResult.caseParent = true;
                         casenumber = 1;   
                         acctnumber = 1;    
                         contactAdded = false;
                         for (integer r = 0; r < lstAllResults.Size(); r++){
                            if (lstAllResults[r].contactId == oneResult.contactId 
                            && lstAllResults[r].strProgram == oneResult.strProgram ){
                               contactAdded = true;
                               break;} 
                         }
                        if (contactAdded == false)
                           lstAllResults.add(oneResult);    
                      }
                  }  //  contact loop 
           }     // end Case loop
        }   // end Account loop
     }    
     system.debug('\n\n XXX lstAllResults: ' + lstAllResults.size());   
   }            
    // for START and CIRT prp_status__c
           // CEP current exit type  T 
    public string stringStatus(string s){
        string strStatus = 'Active';
           if (s <> null){
                 if (s.substring(0,1) == 'U')
                     strStatus = 'Unsuccessful Exit';
                 else
                    if (s.substring(0,1) == 'S')
                     strStatus = 'Successful Exit';
                 else 
                    if (s == 'O' || s == 'T')
                     strStatus = 'Other Exit';
                    else
                     strStatus = 'Active'; 
            }
            return strstatus;
    }
    public string prgName(ID recid){
     string rid;
     if (recId == utilIds.conPRP)
        return 'PRP';
     if (recId == utilIds.conJS)
        return 'JSC';
     if (recId == utilIds.conQJC)
        return 'QJC';
     if (recId == utilIds.conBJC)
        return 'BJC';
     if (recId == utilIds.conAPT)
        return 'APT';
     if (recId == utilIds.conFCS)
        return 'FCS';
     if (recId == utilIds.conCJC)
        return 'CJC';
     if (recId == utilIds.conClient)
        return 'CEP';        
     return '';
    }
}