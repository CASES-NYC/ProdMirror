public without sharing class DOCreaderController {
   public Blob csvFileBody{get;set;}    
    
   public boolean sfAdmin{get;set;} 
   Id attRecordType = Utility_ID__c.getValues('Attorney/ Law Guardian').RecordType_Id__c;
   // dates for input dates
   public Event proxyObject {get; set;}
   public Case_Information__c proxyObj1{get;set;}
 
   public string dobColor{get;set;} 
   public string addrColor{get;set;}  
   public string arrColor{get;set;} 
   public string nextColor{get;set;} 
   public string cjaColor{get;set;} 
   public string mocColor{get;set;} 
   public string docColor{get;set;} 
   public string bailColor{get;set;}  
   public string docketColor{get;set;} 
   public string nysidColor{get;set;}  
   public string bookcasecolor{get;set;} 
   public boolean notDOCreferral{get;set;}
   public string refValue{get;set;} 
   date emptyDate;
   public string inputcharges{get;set;}
   
   public boolean displayNotDoc{get;set;} 
   public  boolean uploaded{get;set;} 
   public boolean DOCreferral{get;set;}
   
   List<CIRT_download__c> downloadedList = new List<CIRT_download__c>();
   CIRT_download__c docRec = new CIRT_download__c() ;  
   List<uploadedInfo> lstUploaded = new List<uploadedInfo>();
   uploadedInfo oneRow = new uploadedInfo(); 

   public string inputType{get;set;}
   
   public void checkinputType(){        
        if (inputType == 'DOC referral'){
          DOCreferral = true;
          displayNotDoc = false;}
        else{  
          DOCreferral = false;
          displayNotDoc = true;}  
       uploaded = false;    
       clearLists();} 
   
   
   public List<SelectOption> getInputTypeItems(){
   List<SelectOption> option = new List<SelectOption>();
   option.add(new SelectOption('DOC referral','DOC referral'));
   option.add(new SelectOption('non DOC referral','non DOC referral'));
   return option;}
  
   public string csvDOC_file{get;set;}
   String[] csvfilelines{get;set;}
   List<string> fieldList{get;set;} 
   Id caseCriminalRecTypeId = 
      Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
   Id caseSupremeRecTypeId = 
      Utility_ID__c.getValues('Case - Supreme Court').RecordType_Id__c;      
   Id EventRecTypeId = Utility_ID__c.getValues('Court Date').RecordType_Id__c; 
     Id conCRT = Utility_ID__c.getValues('CIRT Client').RecordType_Id__c;
   Id accCIRT = Utility_Id__c.getValues('Client').RecordType_Id__c;
 
   public List<clsDisplayDownLoads> listLoads{get;set;} 
   MAP<string, id> chargesMapNameId = new MAP<string, id>(); 
   MAP<id, Penal_Code__c> mapPenalCodes = new MAP<id, Penal_Code__c>();    
 //  List<Case_Charges__c> lstChargesAll = new List<Case_Charges__c>();
   integer nysidIndex,bookIndex,fnameIndex,mnameIndex,lnameIndex,docketIndex,
          addressIndex,cityIndex,stateIndex,zipIndex,dobIndex,genderIndex,
          charge1Index,charge2Index,charge3Index,charge4Index,charge5Index,boroCourtIndex,
          arraingDateIndex,baleIndex,nextCourtIndex,cjaScoreIndex,docScoreIndex,EligibleIndex;    

    ///////////////////////////  Map<string,string> mapStatus = new  Map<string,string>();

   public List<Penal_Code__c> pcodes = new List<Penal_Code__c>();
   Map<id, Zip_Code_Mapping__c> mapZip = new Map<id, Zip_Code_Mapping__c>();
   List<Account> lstAccounts = new List<Account>();
   Account act1 = new Account();
   List<Contact> lstContacts = new List<Contact>();
   Contact cont1 = new Contact();
   List<Case_Information__c> lstCases = new List<Case_Information__c>();
   Case_Information__c case1 = new Case_Information__c();
   List<Address_Information__c> lstAddress = new List<Address_Information__c>();
   Address_Information__c addr1 = new Address_Information__c();
   List<Event> lstEvents = new List<Event>();

   Event ev1 = new Event();
   List<Case_Charges__c> lstCharges = new List<Case_Charges__c>();
  // List<Case_Charges__c> lstChargesToInsert = new List<Case_Charges__c>();
   Case_Charges__c ch0 = new Case_Charges__c();
   Case_Charges__c ch1 = new Case_Charges__c();
   Case_Charges__c ch2 = new Case_Charges__c();
   Case_Charges__c ch3 = new Case_Charges__c();    
   Case_Charges__c ch4 = new Case_Charges__c();
      
   Set<Date> CourtsInFile = new  Set<Date>(); 
   string userrole;
 ///////////     CONSTRUCTOR       CONSTRUCTOR     CONSTRUCTOR     CONSTRUCTOR     CONSTRUCTOR     CONSTRUCTOR
   public DOCreaderController(){
     inputType = 'DOC referral';
 //      generalInfo(); 
       defaultInputValues();
      csvfilelines = new String[]{};
      defaultInputValues();
      fieldList = New List<string>();
      Event e = new Event();
      Case_Information__c cinfo  = new Case_Information__c();
      e.activitydate = date.today() - (365*16);
      e.closing_date__c = date.today();     
      proxyObject  = e; 
      proxyobj1 = cinfo;
      Id userProfId = userInfo.getProfileId();
      Profile p = [Select name from Profile where id =: userProfId limit 1];
      if (p.Name == 'System Administrator')
          sfAdmin = true;  
      string r = UserInfo.getUserRoleId();
      for (UserRole ur : [select  Name from Userrole where id =: r]){
         userrole = ur.name;
         break;}  
      for (Penal_Code__c pc : [select id, name, Level__c from Penal_Code__c ]){
      chargesMapNameId.put(pc.name.trim(), pc.id);
      mapPenalCodes.put(pc.id, pc);}}
     
      public class clsDisplayDownLoads {
      public Id dAcctId{get;set;}
      public string docketname{get;set;}
      public string Docketid{get;set;}
      public string BookCase{get;set;}
      public string Status{get;set;}
      public string accountname{get;set;}
      public string nysid{get;set;}
      public string notes{get;set;}
      public Id clientId{get;set;}
      public Id accountId{get;set;}
      public boolean newClient{get;set;}
      public string missingInfo{get;set;}
      public boolean wrongNYSID{get;set;}}
  
   //Start reading file 
 public void readcsvFile(){
      clearLists();
      downloadedList = new List<CIRT_download__c>();
      docRec = new CIRT_download__c() ;
      lstUploaded = new List<uploadedInfo>();
      oneRow = new uploadedInfo(); 
       string s_datetime, docket_infile, docket1,docket2,nysid_infile,fullname,nysid1;
     downloadedList.Clear();
      try{
        csvDOC_file = csvFileBody.toString();}
      catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a file'));
         return;}
      csvfilelines = csvDOC_file.split('\n');
      string[] csvHeader = csvfilelines[0].split(',');
        if (checkFileStructure(csvHeader) == false)
         return;
     for(Integer i = 1; i < csvfilelines.size(); i++){
        string[] csvRecordData = csvfilelines[i].split(',');
        if (csvHeader.size() <> csvRecordData.size()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please check a cell with address(comma inside?) in row# : ' + i));
            return;
        } 
        //NYSID
          fullname = csvRecordData[fnameIndex].trim() + ' ' + csvRecordData[lnameIndex].trim();
          nysid_infile = csvRecordData[nysidIndex];
          if (nysid_infile <> '' ){
             if (validateNYSIDformat(nysid_infile) == false){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'NYSID format for client ' + fullname + ' is incorrect. Please contact IS'));
             return;
             }
           }
          nysid_infile = csvRecordData[nysidIndex].trim().toupperCase();    
          docket_infile = csvRecordData[docketIndex].trim().toupperCase();
          if (docket_infile == '')
            docket_infile = 'Docket NA';
          if (docket_infile <> '' && docket_infile != 'Docket NA' ){
           if (validatedocketformat(docket_infile) == false){
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Docket format for client ' + fullname + ' is incorrect. Please contact IS'));
              return;}}} 
  
     string cid1,cid2;
     string caseName;
 
      for(string st:csvfilelines[0].split(',')) {
        try{
           fieldList.add(st); 
        } catch (Exception e) {
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
          'Please select a file'));
           return;}}
      double score;  
      boolean badData,badCourtDate;
      string cdocket,cid,eventid;
      string docketId;
   
      for(Integer i = 1; i < csvfilelines.size(); i++){
      docRec = new CIRT_download__c() ;
         oneRow = new uploadedInfo();
         docRec.status__c = '';
         badData = false;
         badCourtDate = false; 
         act1 = new Account();
         cont1 = new Contact();
         case1 = new Case_Information__c();
         addr1 = new Address_Information__c();
         ev1 = new Event();
         
         ch0 = new Case_Charges__c();
         ch1 = new Case_Charges__c();
         ch2 = new Case_Charges__c();
         ch3 = new Case_Charges__c();
         ch4 = new Case_Charges__c();
         s_datetime = '';
      //   if (DOCreferral == true){
             docRec.referraltype__c = 'DOC';
             
         //begin pulling data from CSV row
         //IDs and Names
            string[] csvRecordData = csvfilelines[i].split(',');   
            docRec.NYSID__c = csvRecordData[nysidIndex].trim().toUpperCase() ;  
            oneRow.NYSID = csvRecordData[nysidIndex].trim().toUpperCase() ;  
            docRec.BOOKCASENUMBER__c  = csvRecordData[bookIndex];
            docRec.firstname__c = convertToProperCase(csvRecordData[fnameIndex].trim());
            try{
               docRec.middlename__c =  convertToProperCase(csvRecordData[mnameIndex].trim());}
            catch (Exception e) {
               docRec.middlename__c = '';} 
            docRec.lastname__c =  convertToProperCase(csvRecordData[lnameIndex].trim());
            docRec.gender__c = csvRecordData[genderIndex]; 
            cDocket = csvRecordData[docketIndex].trim().toUpperCase();
            if (cdocket.right(6) == '000000' || cDocket == '' || cdocket.right(6) == '099999'){
               docRec.docket__c = 'Docket NA';
            } else { 
               docRec.docket__c = cDocket;}
            oneRow.Docket = docRec.docket__c; 
            //Address
            docRec.ADDRESS__c =  csvRecordData[addressIndex];                                                                               
            docRec.CITY__c = csvRecordData[cityIndex];                                                                               
            docRec.STATE__c = csvRecordData[stateIndex];                                                                               
            docRec.ZIP__c = csvRecordData[zipIndex];  
         //Date of Birth
            try  {
               docRec.DOB__c = date.parse(csvRecordData[dobIndex].trim());}
            catch (Exception e){
               badData = true;}
         //Charges                                                                              
            docRec.charge_no__c = csvRecordData[charge1Index];   
            docRec.charge_no1__c = csvRecordData[charge2Index];                                                                              
            docRec.charge_no2__c = csvRecordData[charge3Index];                                                                               
            docRec.charge_no3__c = csvRecordData[charge4Index];                                                                               
            docRec.charge_no4__c = csvRecordData[charge5Index]; 
            try{
               docRec.ARRAIGNMENT_DATE__c  = date.parse(csvRecordData[arraingDateIndex].trim());
            } catch (Exception c){}
            //-------------------- Bail Ammount
            try{
               docRec.bail_amount__c = double.valueof(csvRecordData[baleIndex]);
            } catch(Exception e) {}  
            //-------------------- Court Date
            badData = false;
            try{
               docRec.Next_Court_Date__c = date.parse(csvRecordData[nextCourtIndex].trim());
               s_datetime = csvRecordData[nextCourtIndex].trim() + ' ' + '08:00 AM';
               oneRow.nextcourtdate = date.parse(csvRecordData[nextCourtIndex].trim());               
            } catch (Exception e){
               badData = true;}
            // CJA score
            try{
               score  = double.valueOf(csvRecordData[cjaScoreIndex]);
               if(score <= 99) {
                  docRec.cja_score__c = double.valueof(csvRecordData[cjaScoreIndex]);}
               } catch(Exception e){
                  docRec.Status__c += 'bad cja score';
                  badData = true;}
         //DOC score         
             badData = false;
            try{
               score  = double.valueOf(csvRecordData[docScoreIndex]);
               if (score <= 99 ) {
                docRec.doc_score__c = double.valueof(csvRecordData[docScoreIndex]); 
            }}
            catch(Exception e){
               docRec.Status__c += 'bad doc score';
               badData = true;}
            try{
               docRec.CIRT_Eligible_Option__c = csvRecordData[EligibleIndex].trim();}
            catch(Exception e){
               docRec.CIRT_Eligible_Option__c = '';}  
        act1.nysid_number__c = docRec.NYSID__c; 
        act1.name = docRec.firstname__c.trim() + ' ' + docRec.lastname__c.trim();
        if (docRec.gender__c.trim() == 'M') {
               act1.Gender__c = 'Male';
           } else if (docRec.gender__c.trim() == 'F') 
             act1.Gender__c = 'Female';
           else{act1.Gender__c = findgender(docRec.gender__c.trim());}
        act1.recordtypeId =  accCIRT;
        if (docRec.DOB__c != null)
            act1.DOB__c = docRec.DOB__c;
        docRec.new_account__c = false;
        lstAccounts.add(act1); 
        //populate contact
     ///////////////////////////  docRec.currentstatus__c = mapStatus.get(docRec.nysid__c);
       cont1.firstname = docRec.firstname__c; 
       try{
          cont1.Middle_name__c = docRec.middlename__c;}
       catch(Exception e){}
       cont1.lastname = docRec.lastname__c;
       cont1.referral_source__c = 'Department of Correction';
       docRec.referralsource__c = 'Department of Correction';
       oneRow.accountName = docRec.firstname__c.trim() + ' ' + cont1.lastname.trim();
       cont1.BOOK_CASE__c = docRec.BOOKCASENUMBER__c;
       cont1.recordtypeId = conCRT;
       cont1.CJA_Score__c = docRec.cja_score__c;
       cont1.DOC_Risk_Score__c = docRec.doc_score__c;
       cont1.DOC_Recommendation__c = docRec.cirt_eligible_option__c.trim();
       cont1.MOCJ_RA_SCORE__c = docRec.MOCJ_RA_SCORE__c;  
       cont1.Referral_Date__c = date.today();
          cont1.Screening_Stage__c = 'Pending Attorney Info';
       lstContacts.add(cont1); 
        // add Charges 
        // up to 5 charges for every CaseInfo 
        // do this before the Intake Case so that we can determine the case recordtype from the charge level
    //    if (docReferral == true){
        if (chargesMapNameId.get(docRec.charge_no__c) == null)
            docRec.charge_no__c = fixChargesString(docRec.charge_no__c);
        ch0.charge__c = chargesMapNameId.get(docRec.charge_no__c);
        ch0.type__c = 'Criminal Court Arraignment Charges';
        if (chargesMapNameId.get(docRec.charge_no1__c) == null) 
            docRec.charge_no1__c = fixChargesString(docRec.charge_no1__c);
        ch1.charge__c = chargesMapNameId.get(docRec.charge_no1__c);
        ch1.type__c = 'Criminal Court Arraignment Charges';
        if (chargesMapNameId.get(docRec.charge_no2__c) == null)
            docRec.charge_no2__c = fixChargesString(docRec.charge_no2__c);
        ch2.charge__c = chargesMapNameId.get(docRec.charge_no2__c);
        ch2.type__c = 'Criminal Court Arraignment Charges';
        if (chargesMapNameId.get(docRec.charge_no3__c) == null)
            docRec.charge_no3__c = fixChargesString(docRec.charge_no3__c);
        ch3.charge__c = chargesMapNameId.get(docRec.charge_no3__c);
        ch3.type__c = 'Criminal Court Arraignment Charges';
        if (chargesMapNameId.get(docRec.charge_no4__c) == null)
            docRec.charge_no4__c = fixChargesString(docRec.charge_no4__c);      
        ch4.charge__c = chargesMapNameId.get(docRec.charge_no4__c);
        ch4.type__c = 'Criminal Court Arraignment Charges';                                
        lstCharges.add(ch0);
        lstCharges.add(ch1);
        lstCharges.add(ch2);
        lstCharges.add(ch3);
        lstCharges.add(ch4); 
 
        case1.bail_set_cash__c = docRec.bail_amount__c;
        case1.Criminal_Court_Arraignment_Date__c = docRec.ARRAIGNMENT_DATE__c;
        case1.name = docRec.docket__c;
        if(case1.Name.trim() == 'Docket NA')
           case1.No_Docket__c = true;
        if (userrole == 'CCI Brooklyn')
           case1.Borough__c = 'Brooklyn';
        else
           case1.Borough__c = 'Manhattan';    
        case1.RecordTypeId = findCaseRecordType(ch0.charge__c,ch1.charge__c,ch2.charge__c,ch3.charge__c,ch4.charge__c);
        docRec.New_Docket__c = false;
        lstCases.add(case1);
        addr1.Street__c = docRec.ADDRESS__c;
        addr1.city__c = docRec.CITY__c.trim(); 
        addr1.state__c = docRec.STATE__c.trim();
        addr1.Zip__c = docRec.ZIP__c;
        addr1.Intake_Address__c = true;
        addr1.Address_Type__c = 'Primary';
        lstAddress.add(addr1);
        if (docRec.Next_Court_Date__c != null ){
           s_datetime = docRec.Next_Court_Date__c.format() + ' ' +  + '08:00 AM';
            ev1.ActivityDate = docRec.Next_Court_Date__c;
            ev1.ActivityDateTime = DateTime.parse(s_datetime);
            ev1.Verification_Due_Date__c = docRec.Next_Court_Date__c;
        }
        ev1.durationinminutes = 60;
        ev1.subject = 'Court Date';
        ev1.RecordTypeId = EventRecTypeId;
        lstEvents.add(ev1);
        docRec.new_docket__c = false;         
        downloadedList.add(docRec);
        lstUploaded.add(oneRow);
       }
       if (downloadedList.Size() > 0)
          uploadInfo(downloadedList,lstUploaded);
     }
     /////////  HELPER CLASS FOR STORE AND ANALYZE INPUT AGAINS DATA IN SF---- HELPER CLASS FOR STORE AND ANALYZE INPUT AGAINS DATA IN SF
    public class uploadedInfo {
      public string program {get;set;}      
      public boolean newAccount {get;set;}
      public boolean newDocket {get;set;}
      public boolean newContact {get;set;}
      public boolean ActiveInSF {get;set;}
      public string clientStatus {get;set;}      
      public String Docket {get;set;}
      public String NYSID {get;set;}
      public ID DocketId {get;set;}
      public ID AccountId {get;set;}
      public ID eventId {get;set;}
      public ID ContactId {get;set;}
      public Date nextcourtdate {get;set;}
      public String pcid {get;set;}
      public boolean chargesCreated {get;set;}
      public string anotherAccount {get;set;}
      public boolean notAddAccount {get;set;}
      public boolean notAddDocket {get;set;}
      public string accountName {get;set;}
      public boolean newEvent {get;set;}
      public string address {get;set;}      
      public boolean DockedInOtherAccount {get;set;}}     
    ///////////////////////////////////////////////////////////////
     
  //    UPLOAD into SalesForce---- UPLOAD into SalesForce----  UPLOAD into SalesForce ---- UPLOAD into SalesForce 
   public void uploadInfo(List<CIRT_Download__c> DownList,List<uploadedInfo> UploadList){
   Set<String> setNYSID_in_File = new  Set<String>();
   Set<String> setDocket_in_File = new  Set<String>();
 
  ID accountId; 
  System.Debug('\n\n XXX  DownList: ' + DownList);   
System.Debug('\n\n XXX  UploadList: ' +UploadList);   

  integer u;
       ///////////////////   DEFAULTs VALUES ///////////////////////////
     set<Date> setDatesInUpload = new set<Date>();
     for (u = 0; u < UploadList.Size(); u++){
       setDatesInUpload.add(UploadList[u].nextcourtdate); 
       UploadList[u].notAddDocket = false;    
       UploadList[u].notAddAccount = false;    
       UploadList[u].newEvent = true;
       UploadList[u].newContact = false;
       UploadList[u].newDocket = false;
       UploadList[u].ActiveInSF = false ; 
       UploadList[u].notAddAccount = false; 
       UploadList[u].anotherAccount = '';
       setNYSID_in_File.add(UploadList[u].nysid);
       setDocket_in_File.add(UploadList[u].docket);
    }
 Set<ID> setAccountsinSF = new Set<ID>();
 Set<ID> setCasesInSF = new Set<ID>();

 Set<ID> setAccountsAdded = new Set<ID>();
 Set<ID> setCasesAdded = new Set<ID>();


//    System.Debug('\n\n XXX  UploadList: ' + UploadList.Size() );
 //   return; 
 Set<String> setAccountNotAdd = new Set<String>();
 Set<String> setCaseNotAdd = new Set<String>();
    
    /////////////////////   CHECK ACCOUNS
    for (Account acc : [select nysid_number__c, id from Account where 
        nysid_number__c in: setNYSID_in_File]){
        setAccountsInSF.add(acc.id);  
      for (u = 0; u < UploadList.Size(); u++){
          if (acc.nysid_number__c.trim() == UploadList[u].nysid.trim()){
         setAccountNotAdd.add(UploadList[u].nysid.trim());
         UploadList[u].newAccount = false;
         UploadList[u].accountid = acc.id;
         UploadList[u].notAddAccount = true;
         break;} 
        }
     }
  List<Account>  lstAccountsAdded = new List<Account>();
      Account accToUpdate = new Account();
   for (u = 0; u < UploadList.Size(); u++){
   //     accToUpdate = new Account();
     if (UploadList[u].accountId == null && UploadList[u].notAddAccount == false){
       downList[u].New_Account__c = true;
       UploadList[u].newAccount = true;
       lstAccounts[u].nysid_number__c = UploadList[u].nysid;
       lstAccounts[u].name = UploadList[u].accountName;
       accToUpdate = lstAccounts[u];
       lstAccountsAdded.add(accToUpdate);}}
  
     if (lstAccountsAdded.Size() != 0)
       try{
         upsert lstAccountsAdded;
       } catch (Exception e){

       String errorMsg = 'There was an error inserting Account. Details = ' + e.getMessage();
       System.debug('==========&gt; ' + errorMsg);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
       } 
 //System.Debug('\n\n XXX  Account added' );
       /////////////////////   CHECK CASES
       
     List<Case_Relationship__c> lstAllCases = [Select Program__c, PCID__c, NYSID__c, Docket__c,
     Docket_Name__c, Contact__c, Case_Type__c, Account__c From Case_Relationship__c 
     where nysid__c in: setNYSID_in_File and Docket_Name__c in: setDocket_in_File and program__c = 'CIRT'];       
  
  System.Debug('\n\n lstAllCases: ' + lstAllCases.Size());
       
    //and account__c not in: setAccountNotAdd
    for (Case_Relationship__c cr : lstAllCases){
       for (u = 0; u < UploadList.Size(); u++){
         if (cr.nysid__c.trim() == UploadList[u].nysid.trim()){
          if (cr.Docket_Name__c.trim() == UploadList[u].docket.trim()){
           setCaseNotAdd.add(UploadList[u].docket.trim());
//            UploadList[u].accountid = ci.client_account__c;
         UploadList[u].newdocket = false;
         UploadList[u].newEvent = false;
         UploadList[u].docketid = cr.Docket__c;
        UploadList[u].contactId = cr.Contact__c;
         UploadList[u].notAddDocket = true;
         uploadList[u].program = cr.Program__c.trim();
         setCasesInSF.add(cr.Docket__c);
         break;
          }}  
        else{
          if (cr.Docket_Name__c.trim() != 'Docket NA' && cr.Docket_Name__c.trim() == UploadList[u].docket.trim()){ 
            UploadList[u].DockedInOtherAccount = true;
            setDocket_in_File.remove(UploadList[u].docket);  
            UploadList[u].anotherAccount = cr.NYSID__c.trim() + ': ' + cr.FirstName__c.trim() + cr.LastName__c.trim();
          break;
        }
      }}} 
 
     //  REQUERY ACCOUNT
   List<Account> accUpdated = [select nysid_number__c, id from Account where 
        nysid_number__c in: setNYSID_in_File];
   for (Account a : accUpdated){
      setAccountsinSF.add(a.id);
      for (u = 0; u < UploadList.Size(); u++){
        if (a.nysid_number__c.trim() == UploadList[u].nysid.trim()){
          UploadList[u].accountId = a.id;
          downList[u].AccountID__c = a.id;
        break;}}
        }  
 //   CONTACTs
 //and Client_Status__c !=: 'Never Enrolled'
  List<Contact> lstContactsSF = [select accountid, id, intake_case__r.Name,nysid__c,Client_Status__c,
    Intake_Case__c,p_c_id__c from contact 
    where nysid__c in: setNYSID_in_File and recordtypeId =: conCRT 
    and Client_Status__c !=: 'Exited' and Client_Status__c !=: 'Never Enrolled'];
  //and intake_case__r.Name in: setDocket_in_File
    for (Contact ca : lstContactsSF){  
    for (u = 0; u < UploadList.Size(); u++){
     if (ca.nysid__c.trim() == UploadList[u].nysid.trim()){
         UploadList[u].ActiveInSF = false;
         UploadList[u].contactId = ca.id;
         Uploadlist[u].accountId = ca.accountId;
         if (ca.Client_Status__c == 'Active' || ca.Client_Status__c == 'Incomplete Screening' 
           || ca.Client_Status__c == 'On Program Hold'
           || ca.Client_Status__c == 'Missing Intake Case') {
          UploadList[u].ActiveInSF = true;
          UploadList[u].contactId = ca.id;
          UploadList[u].program = 'CIRT';
          break;
        }
      }}}

   List<Contact> lstContactToInsert = new List<Contact>();
    Contact ContactToInsert = new Contact(); 

    for (u = 0; u < UploadList.Size(); u++){ 
       if (UploadList[u].contactid == null && UploadList[u].ActiveInSF == false){
         lstContacts[u].AccountId = UploadList[u].accountid;
         UploadList[u].newContact = true;
         ContactToInsert =  lstContacts[u];
           lstContactToInsert.add(ContactToInsert);}
     }
   if (lstContactToInsert.Size() != 0)
       try{
         insert lstContactToInsert;
       } catch (Exception e){
       String errorMsg = 'There was an error inserting Contact. Details = ' + e.getMessage();
       System.debug('==========&gt; ' + errorMsg);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
       }
 
 
  List<Case_Information__c> lstCasesInSF = 
       [select name, id, client_account__c,client_account__r.name from Case_Information__c
        where client_account__c in: setAccountsinSF];        
 
   list<Case_Information__c> lstCasesToInsert = new List<Case_Information__c>();
   Case_Information__c caseToInsert = new Case_Information__c();
   if (lstCasesInSF.Size() != 0){
     for (Case_Information__c ci : lstCasesInSF){  
        for (u = 0; u < UploadList.Size(); u++){
          if(ci.name.trim() == UploadList[u].docket){
             UploadList[u].docketId = ci.id;
             break; 
   }}}}
    for (u = 0; u < UploadList.Size(); u++){
     if(UploadList[u].docketid == null && UploadList[u].notAddDocket == false){
       lstCases[u].client_account__c = UploadList[u].accountId;
       lstCases[u].name = UploadList[u].docket;
       caseToInsert = lstCases[u];
       lstCasesToInsert.add(caseToInsert);
        downList[u].New_Docket__c = true;
        UploadList[u].newDocket = true;
     }
  }
 
   if (lstCasesToInsert.Size() != 0){
       try{
         upsert lstCasesToInsert;
       } catch (Exception e){
       
       String errorMsg = 'There was an error inserting Case Information. Details = ' + e.getMessage();
       System.debug('==========&gt; ' + errorMsg);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));}}  
  List<Case_Information__c> lstCasesAfterCaseUpdated = 
       [select name, id, client_account__c from Case_Information__c
        where client_account__c in: setAccountsinSF]; 
 
set<String> setdocketsInserted = new set<String>();  

  for (Case_Information__c ci : lstCasesAfterCaseUpdated){
     setCasesInSF.add(ci.id);
     for (u = 0; u < UploadList.Size(); u++){
       if (UploadList[u].accountId == ci.client_account__c && 
          UploadList[u].docket.trim() == ci.name.trim()){
           UploadList[u].docketid = ci.id;
          break;}}}
  
 Set<string> setContacts = new Set<String>();
// REQUERY CONTACTs
//and Client_Status__c !=: 'Never Enrolled'
 List<Contact> lstContactsUpdates = new List<Contact>();
     lstContactsUpdates = [select accountid, id, nysid__c,Intake_Case__c,Client_Status__c,
     P_C_Id__c,intake_case__r.Name from contact  
     where nysid__c in: setNYSID_in_File and recordtypeId =: conCRT 
     and Client_Status__c !=: 'Exited' and Client_Status__c !=: 'Never Enrolled'];
  for (integer s = 0; s < lstContactsUpdates.Size(); s++)
    for (u = 0; u < UploadList.Size(); u++){ 
       if (lstContactsUpdates[s].accountId == UploadList[u].accountId && UploadList[u].ActiveInSF == false){
         lstContactsUpdates[s].Intake_Case__c = UploadList[u].docketId;
         UploadList[u].pcid = lstContactsUpdates[s].P_C_Id__c;
         UploadList[u].contactId = lstContactsUpdates[s].id;  
         setContacts.add(lstContactsUpdates[s].id);         
         break;}  
     }
     
 if (lstContactsUpdates.Size() != 0){
       try{
         update lstContactsUpdates;
       } catch (Exception e){
       
       String errorMsg = 'There was an error updating Contact Information. Details = ' + e.getMessage();
       System.debug('==========&gt; ' + errorMsg);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));}
    }       

  for (Event lstEventsInSF : [Select id, whoid,whatid,ActivityDate from Event 
      where whoid in: setContacts and whatid in: setCasesInSF 
      and activitydate in: setDatesInUpload and subject =: 'Court Date']){
     for (u = 0; u < UploadList.Size(); u++){
       if (lstEventsInSF.whoid == UploadList[u].contactid &&
       lstEventsInSF.whatid == UploadList[u].docketId && 
       lstEventsInSF.ActivityDate == UploadList[u].nextcourtdate && UploadList[u].notAddAccount == false)
       UploadList[u].eventid = lstEventsInSF.id; 
       UploadList[u].newEvent = false;
       break;}}

  Event EventToInsert = new Event();   
    List<Event> lstEventsToInsert = new List<Event>();  
  for (u = 0; u < UploadList.Size(); u++){ 
     if (UploadList[u].eventid == null && UploadList[u].newEvent == true 
       && UploadList[u].nextcourtdate != null  && UploadList[u].notAddAccount == false){
       lstEvents[u].whoid = UploadList[u].contactid;
       lstEvents[u].whatid = UploadList[u].docketId;
       lstEvents[u].ActivityDate = UploadList[u].nextcourtdate;
       lstEvents[u].p_c_id__c =  UploadList[u].pcid;
       lstEvents[u].Verification_Status__c = 'Not Verified';
       lstEvents[u].durationinminutes = 60;
       lstEvents[u].subject = 'Court Date';
       UploadList[u].newEvent = true;
       downList[u].Court_Date_Id__c = UploadList[u].nextcourtdate.format();
       EventToInsert = lstEvents[u];
       lstEventsToInsert.add(EventToInsert);
     }}
  
  if (lstEventsToInsert.size() != 0){
      try{
         insert lstEventsToInsert;
       } catch (Exception e){
       
       String errorMsg = 'There was an error updating Event. Details = ' + e.getMessage();
       System.debug('==========&gt; ' + errorMsg);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
       }
  }

  // REQUERY EVENS 
  for (Event lstEventsInUpdates : [Select id, whoid,whatid,ActivityDate from Event 
      where whoid in: setContacts and whatid in: setCasesInSF 
      and activitydate in: setDatesInUpload and subject =: 'Court Date']){
      for (u = 0; u < UploadList.Size(); u++){
        if (lstEventsInUpdates.whoid == UploadList[u].contactid &&
       lstEventsInUpdates.whatid == UploadList[u].docketId && 
       lstEventsInUpdates.ActivityDate == UploadList[u].nextcourtdate){
       UploadList[u].eventid = lstEventsInUpdates.id;
       UploadList[u].newEvent = true;
       break;}}}

   Set<string> setContactInAddress = new Set<String>();
   for (Address_Information__c adr : [select client__c from Address_Information__c 
      where client__c in: setContacts]){
        setContactInAddress.add(adr.client__c);
        for (u = 0; u < UploadList.Size(); u++){
          if (adr.client__c == uploadList[u].contactId){
             uploadList[u].address = 'entered'; 
             break;
          }}}
   Address_Information__c addressToInsert = new Address_Information__c();   
   List<Address_Information__c> lstAddressToInsert = new List<Address_Information__c>(); 
   for (u = 0; u < UploadList.Size(); u++){ 
     if (setContactInAddress.contains(UploadList[u].ContactID) == false
      && UploadList[u].newContact == true && UploadList[u].contactId != null 
       && UploadList[u].notAddAccount == false){
        if (lstAddress[u].street__c.trim() <> '' ||                                                                                 
            lstAddress[u].CITY__c.trim() <> '' ||                                                                              
            lstAddress[u].STATE__c.trim() <> ''  ||                                                                               
            lstAddress[u].Zip__c <> '')
            lstAddress[u].client__c = UploadList[u].contactId;
            downList[u].Address__c = lstAddress[u].CITY__c.trim() + ' ' + lstAddress[u].STATE__c.trim() +
             ' ' +lstAddress[u].Zip__c;   
            uploadList[u].address = 'entered';                
            addressToInsert = lstAddress[u];                   
            lstAddressToInsert.add(lstAddress[u]);}}

 if (lstAddressToInsert.size() != 0){
       try{
         upsert lstAddressToInsert;
       } catch (Exception e){
       
       String errorMsg = 'There was an error inserting Address. Details = ' + e.getMessage();
       System.debug('==========&gt; ' + errorMsg);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
       }
 }    
       //insert lstAddressToInsert;
   
  string strDocketCharge;     
  Set<String> setdocketCharges_inCharges = new Set<String>();
  for (Case_Charges__c ch : [select Docket_No__c,charge__c from Case_Charges__c
      where Docket_No__c in : setCasesInSF]){
      strDocketCharge = ch.Docket_No__c;
      strDocketCharge += '-' + ch.Charge__c;
      setdocketCharges_inCharges.add(strDocketCharge);}  

   for (integer d = 0; d < UploadList.Size(); d++){
     for(integer c = d*5; c < 5*(d+1); c++) { 
       if (UploadList[d].notAddDocket == false){  
          lstCharges[c].Docket_No__c = UploadList[d].docketId;
          downList[d].Case_Charge_s_Created__c = true;
       }}} 

     string docketCharge = '';
     List<Case_Charges__c> lstChargesToInsert = new List<Case_Charges__c>();
     Case_Charges__c ChargeToInsert = new Case_Charges__c();
  
    for (integer c = 0; c < lstCharges.Size(); c ++){
       if (lstCharges[c].charge__c != null){
         docketCharge = lstCharges[c].Docket_No__c;
         docketCharge += '-' + lstCharges[c].Charge__c;
         if (setdocketCharges_inCharges.contains(docketCharge) == false){
           ChargeToInsert = lstCharges[c];
           lstChargesToInsert.add(ChargeToInsert);}}}
     
    if (lstChargesToInsert.Size() != 0)
       try{
         upsert lstChargesToInsert;
       } catch (Exception e){
       String errorMsg = 'There was an error inserting Charges. Details = ' + e.getMessage();
       System.debug('==========&gt; ' + errorMsg);
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
       } 
        //insert lstChargesToInsert;
 // REQUERY CHARGES
     displayRecords(downList,uploadList);}
 
 // Display Info 
   public void displayRecords(List<CIRT_download__c> lstCirt, List<uploadedInfo> lstUpLoad)  {
     System.Debug('\n\n XXX lstUpLoad: ' + lstUpLoad); 
      listLoads = new List<clsDisplayDownLoads>();
     clsDisplayDownLoads oneRecord = new clsDisplayDownLoads(); 
    for (integer a = 0; a < lstCirt.Size(); a++) {
      string status = '';
      oneRecord = new clsDisplayDownLoads();
      oneRecord.nysid = lstCirt[a].NYSID__c;
      oneRecord.accountname = lstCirt[a].Firstname__c + ' ' + lstCirt[a].Lastname__c;
      oneRecord.docketname = lstCirt[a].DOCKET__c; 
      oneRecord.bookcase = lstCirt[a].BOOKCASENUMBER__c;
      oneRecord.missingInfo = '';
      oneRecord.dAcctId = lstUpLoad[a].AccountId ;
      oneRecord.docketId = lstUpLoad[a].Docketid;
      oneRecord.newClient = lstCirt[a].New_Account__c;
     
     if (lstUpLoad[a].anotherAccount != ''){
       oneRecord.notes = 'CIRT client created. Entered docket exists for another account: '  +  lstUpLoad[a].anotherAccount + 'Docket assigned as Docket NA'; 
      oneRecord.wrongNYSID = true;
     }
     else{ 
      if (lstUpLoad[a].NewAccount  == false && lstUpLoad[a].NewDocket  == false && lstUpLoad[a].Newcontact  == true 
          && lstUpLoad[a].program != 'CIRT')
      oneRecord.notes = 'Existing CASES client. CIRT contact record created.';  
     else{ 
      if ((lstUpLoad[a].clientStatus == 'Active' || lstUpLoad[a].clientStatus == 'On Program Hold'
       || lstUpLoad[a].clientStatus == 'Incomplete Screening') && lstUpLoad[a].NewDocket == true)
            oneRecord.notes = 'This client is already in CIRT with status ' + lstUpLoad[a].clientStatus.trim() + '. New Case added.';
      else{
        if (lstUpLoad[a].NewAccount == true && lstUpLoad[a].NewDocket == true){ // 1. Client with unique NYSID, unique Docket #
          oneRecord.notes = 'New client created.';
          oneRecord.newClient = true;}
        else{
          if (lstUpLoad[a].NewAccount  == false && lstUpLoad[a].NewDocket  == false && lstUpLoad[a].Newcontact  == false
             && lstUpLoad[a].program == 'CIRT')  // 2. Client with existing NYSID, unique Docket #
            oneRecord.notes = 'This client has already been intaked into CIRT on this docket.';
          else{
            if (lstUpLoad[a].NewAccount  == false && lstUpLoad[a].NewDocket == true ){
              if (lstUpLoad[a].NewContact == false || lstUpLoad[a].NewContact == null) // 
                    oneRecord.notes = 'Existing CASES client. New DOCKET (case) record created.';
                else
                    oneRecord.notes = 'Existing CASES client. New CIRT contact record created.';}}}}}}  
         if (lstUpLoad[a].nextcourtDate == null)
                 oneRecord.missinginfo += '-Missing court date';  
         if (lstUpLoad[a].newContact == true){
           if (lstUpLoad[a].Address == null || lstUpLoad[a].Address == '')
                 oneRecord.missinginfo += '-no Address';   
           if ((lstCirt[a].Status__c).contains('bad cja score')) 
                 oneRecord.missinginfo += '-bad/no CJA Score';
           if ((lstCirt[a].Status__c).contains('bad doc score')) 
                 oneRecord.missinginfo += '-bad/no DOC Score';
         }
          if (lstCirt[a].Case_Charge_s_Created__c != true) 
                 oneRecord.missinginfo += '-no Charges';
         status = oneRecord.notes + lstCirt[a].status__c;
        lstCirt[a].status__c =  status;  
        listLoads.add(oneRecord);               
      }   
      System.Debug('\n\n XXX oneRecord: ' + oneRecord); 
       try{
         insert lstCirt;
       } catch (Exception e){
       }
   //   insert lstCirt;
      uploaded = true;
    //  defaultInputValues();
      }
 
     public integer setColumnIndex(string s, string[] csvHeader){
       string s1 = s.toUpperCase();
       string s2;
       integer indexReturn = -1;
       for (integer i = 0; i < csvHeader.Size(); i++){
         s2 = csvHeader[i].toUpperCase();
         if (s2.contains(s)){
                indexReturn = i;
                break;}}
        return indexReturn;}
      
    public integer setDOBIndex(string[] csvHeader){
        string s2;
        integer indexReturn = -1;
       for (integer i = 0; i < csvHeader.Size(); i++){
         s2 = csvHeader[i].toUpperCase();
         if (s2.contains('DOB') || csvHeader[i].contains('BIRTH')){
           indexReturn = i;
                break;}}
        return indexReturn;
      }
  public string convertToProperCase(string s){
  //   if (s.contains('-'))
  //      return s;
     string sRet;
     try{
       sRet =  s.substring(0,1).toUpperCase() + s.substring(1, s.length()).toLowerCase();}
   catch (Exception e){
       sRet = s;
   }
     return sRet;
   }
  
   public string fixChargesString(string charge){
     if (charge.length() == 10)
        return '';
      List<String> p = new List<String>();
      string s;
      if (charge.contains('.')){
          p  = charge.split('\\.');
      if (p.Size() == 2){
         s = p[1];
         if (s.length() == 1)
            charge = charge + '0';}
        else
            charge = charge + '.00';
      }
      return charge;}     
 
    public void nonDOCreferral(){
        if (clsInput.NYSID.trim()  == '' || clsInput.FName.trim()  == '' 
        ||  clsInput.LName.trim()  == '' || clsInput.Referral_Source.trim() == '' ){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Required fileds are not entered'));
           return;}
       DOCreferral = false;
       double checkNumeric;
       date CheckDate;
       dobColor = 'black';
       addrColor = 'black';
       arrColor = 'black';
       nextColor = 'black'; 
       mocColor = 'black'; 
       cjaColor = 'black'; 
       docColor = 'black';   
       bailColor = 'black';   
       docketColor = 'black';
       nysidColor = 'black';
       bookcasecolor = 'black';
       string errorString = '';    
       if (clsInput.docket != '' && clsInput.docket != null){
       if (validateDocketformat(clsInput.docket.trim()) == false && clsInput.docket != 'Docket NA' ){
           docketcolor = 'red';
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'DOCKET format must be "9999XX999999". Please correct'));
          return;}}
          
     if (clsInput.nysid <> ''){
       if (validateNYSIDformat(clsInput.nysid.trim()) == false){
           NYSIDcolor = 'red';
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'NYSID format must be "99999999X". Please correct'));
          return;}}
       if (clsInput.bookcase <> ''){    
           if (validateBookCase(clsInput.bookcase) == false){
                      bookcasecolor = 'red';
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'BookCase format must be 10 digits. Please correct'));
          return;}}
       if (clsInput.bail <> ''){
           try{checkNumeric = double.valueof(clsInput.bail);}
           catch (Exception e){
              bailColor = 'red';
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Bail ammount is incorrect. Please correct'));              
              return;}}
       if (clsInput.cjascore <> ''){
          try {checkNumeric = double.valueOf(clsInput.cjascore);
              if(checkNumeric <= 99) 
                 checkNumeric = double.valueof(clsInput.cjascore);
              else {
                 cjaColor = 'red';
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CJA score is incorrect.'));
                 return;}}
         catch(Exception e){
            cjaColor = 'red';
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CJA score is incorrect.'));
            return;}}
       if (clsInput.MOCJscore <> '' ){
          try {checkNumeric = double.valueOf(clsInput.MOCJscore);
              if(checkNumeric <= 99) 
                 checkNumeric = double.valueof(clsInput.MOCJscore);
              else {
                 mocColor = 'red';
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'MOCJ RA score is incorrect.'));
                 return;}}
         catch(Exception e){
            mocColor = 'red';
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'MOCJ RA score is incorrect.'));
             return;}}
       if (clsInput.docscore <> ''){
          try {checkNumeric = double.valueOf(clsInput.docscore);
              if(checkNumeric <= 99) 
                 checkNumeric = double.valueof(clsInput.docscore);
              else {
                 docColor = 'red';
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'DOC score is incorrect.'));
                 return;}}
         catch(Exception e){
            docColor = 'red';
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'DOC score is incorrect.'));
                 return;}}
        if (clsInput.address.contains(',')){
            addrColor = 'red';
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Address - no "Comma" allowed'));
            return;}    
       if (clsInput.dob.trim()!= '' && clsInput.dob != null){
           try{CheckDate = date.parse(clsInput.dob.trim());
             if (CheckDate > date.today() - (365*14) || CheckDate < date.today() - (365*70)){
                dobColor = 'red';
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Date of Birth is incorrect'));
               return;}}
           catch (Exception e){
              dobColor = 'red';
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Date of Birth is incorrect'));
               return;}}
        if (clsInput.darraign != null && clsInput.darraign.trim() != ''){
           try{CheckDate = date.parse(clsInput.darraign.trim());
             if (CheckDate > date.today() + 365){
               arrColor = 'red';
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Arraign. date is incorrect'));
               return;}}
           catch (Exception e){
               arrColor = 'red';
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Arraign. date is incorrect'));
               return;}}
        if (clsInput.nextcourtdate != null && clsInput.nextcourtdate.trim() != ''){
           try{CheckDate = date.parse(clsInput.nextcourtdate.trim());
             if (CheckDate > date.today() + 365 || CheckDate < date.today() - 365){
                nextColor = 'red';
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Next Court date is incorrect'));
               return;}}
           catch (Exception e){
               nextColor = 'red';
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Next Court date is incorrect'));
               return;}}
        clsInput.State = 'NY'; 
        DOCreferral = false;
        notDOCreferral = true;        
        dataEntered();
    }
    
    public void generateDOCreferral(){ 
    //  PageReference pr = donothing();
        DOCreferral = true;
        notDOCreferral = false;
        readcsvFile();
        //return null;
        } 
   public void doNothing(){
     System.Debug('\n\n XXX in doNothing');
     uploaded = false;
        }
  
  public List<SelectOption> CodesItems{get{
      List<SelectOption> CodesItems = new List<SelectOption>();
      CodesItems.add(new SelectOption('',''));
      for (Penal_Code__c p : [select name from Penal_Code__c order by name]){
            CodesItems.add(new SelectOption(p.name.trim(),p.name.trim()));}
       return CodesItems;}
       set{CodesItems = this.CodesItems;}} 

     public void defaultInputValues(){
      uploaded = false;
      clsInput = new enteredInfo();
      proxyobj1 = new Case_Information__c();
        clsInput.NYSID = '';
     clsInput.FName = '';
     clsInput.bookcase = '';
     clsInput.mName = '';
     clsInput.dob = '';
     clsInput.LName = '';
     clsInput.address = '';
     clsInput.city = '';
     clsInput.state = 'NY'; 
     clsInput.zip = '';
     clsInput.gender = '';
     clsInput.charge1 = '';
     clsInput.charge2 = '';
     clsInput.charge3 = '';
     clsInput.charge4 = ''; 
     clsInput.charge5 = '';
     clsInput.courtboro = '';
     clsInput.darraign = '';
     clsInput.bail = '';
     clsInput.nextcourtdate = '';
     clsInput.CJAscore = '';
     clsInput.DOCscore = '';
     clsInput.eligible = '';
 //    clsInput.refdate = '';
     clsInput.Referral_Source = '';
     clsInput.designation = '';
     clsInput.MOCJscore = '';
     }
          
     public string findgender(string s){
      string strReturn = '';    
      if (s.substring(0,1) == 'M') 
         strReturn = 'Male';
      else{
        if (s.substring(0,1) == 'F')
         strReturn = 'Female';
        else
         strReturn = s.trim();}   
      return strReturn;}

   public boolean validateDocketformat(string s){
         string sDocket = s.trim();
        if (sDocket.length() != 12)    
           return false;    
        string s1 = sDocket.left(4);
        string s2 = sDocket.mid(4,2);
        string s3 = sDocket.right(6);
        boolean b1 = false;
        boolean b2 = false;
        boolean b3 = false;
        if ( s1.isNumeric() == false)
           return false;
        if ( s2.isAlpha() == false)
           return false;
        if ( s3.isNumeric() == false)
           return false;
        return true;}

        public boolean validateNYSIDformat(string s){
            string sNYSID = s.trim();
        if (sNYSID.length() != 9)    
           return false;
        string s1 = sNYSID.left(8);
        string s2 = sNYSID.right(1);
        boolean b1 = false;
        boolean b2 = false;
        if ( s1.isNumeric() == false) 
           return false;
        if ( s2.isAlpha() == false)
           return false;
        return true;
      }
      public boolean validateBookCase(string s){
        if (s.length() != 10)    
           return false;
        return true;}
      public void dataEntered(){
      //  clearLists(); 
       System.Debug('\n\n XXX clsInput: ' + clsInput);
        downloadedList = new List<CIRT_download__c>();
        docRec = new CIRT_download__c() ;  
        lstUploaded = new List<uploadedInfo>();
        oneRow = new uploadedInfo();          
      //  return;
        string s_datetime, docket_infile, docket1,docket2,nysid_infile,fullname,nysid1;
        act1 = new Account();
        cont1 = new Contact();
        case1 = new Case_Information__c();
        addr1 = new Address_Information__c();
        ev1 = new Event();
        ch0 = new Case_Charges__c();
        ch1 = new Case_Charges__c();
        ch2 = new Case_Charges__c();
        ch3 = new Case_Charges__c();
        ch4 = new Case_Charges__c();
        s_datetime = '';
        boolean badData,badCourtDate;
        if (clsInput.CJAscore != '' && clsInput.CJAscore != null)
            docRec.cja_score__c  = double.valueOf(clsInput.CJAscore);
        if (clsInput.DOCscore != ''  && clsInput.DOCscore != null)
            docRec.doc_score__c  = double.valueOf(clsInput.DOCscore);
        if (clsInput.MOCJscore != ''  && clsInput.MOCJscore != null)
           docRec.MOCJ_RA_SCORE__c  = double.valueOf(clsInput.MOCJscore);
        docRec.ReferralSource__c = clsInput.Referral_Source;
        docRec.M_Designation__c = clsInput.designation; 
        docRec.Referral_Date__c = proxyObject.Closing_Date__c;          
        docRec.status__c = '';
        badData = false;
        docRec.NYSID__c = clsInput.NYSID.trim().toUpperCase();
    //    setNYSID_in_File.add(docRec.NYSID__c);    
        oneRow.NYSID = docRec.NYSID__c;  
        if (clsInput.Docket == null || clsInput.Docket == '')
            docRec.docket__c = 'Docket NA';
        else{    
           string cDocket = clsInput.Docket.trim().toUpperCase();
           if (cdocket.right(6) == '000000'  || cdocket.right(6) == '099999') 
             docRec.docket__c = 'Docket NA';
           else
             docRec.docket__c = cDocket;}  
        
         oneRow.Docket = docRec.docket__c; 
         docRec.BOOKCASENUMBER__c  = clsInput.bookcase;
         System.Debug('\n\n XXX clsInput.fname: ' + clsInput.fname);
         docRec.firstname__c = convertToProperCase(clsInput.fname.trim());
         if (clsInput.mname != ''){
         try{docRec.middlename__c =  convertToProperCase(clsInput.mname.trim());}
         catch (Exception e) {docRec.middlename__c = '';}}
         docRec.lastname__c =  clsInput.lname.trim();
         docRec.gender__c = clsInput.gender; 
         oneRow.accountName = docRec.firstname__c.trim() + ' ' + docRec.lastname__c.trim();
         docRec.ADDRESS__c =  clsInput.address;                                                                               
         docRec.CITY__c = clsInput.city;                                                                             
         docRec.STATE__c = clsInput.state;                                                                               
         docRec.ZIP__c = clsInput.zip;  
         docRec.referraltype__c = 'input';
         //Date of Birth
         if (clsInput.dob != null && clsInput.dob != '')
             docRec.DOB__c = date.parse(clsInput.dob.trim());
         else
             docRec.DOB__c = emptyDate;
         act1.nysid_number__c = docRec.NYSID__c; 
         act1.name = docRec.firstname__c.trim() + ' ' + docRec.lastname__c.trim();
         act1.Gender__c = docRec.gender__c;
         act1.recordtypeId =  accCIRT;
         if (docRec.DOB__c != null)
            act1.DOB__c = docRec.DOB__c;
         docRec.new_account__c = false;
         lstAccounts.add(act1); 

       if (clsInput.darraign != null && clsInput.darraign != '')
           docRec.ARRAIGNMENT_DATE__c  = date.parse(clsInput.darraign.trim());
       else
           docRec.ARRAIGNMENT_DATE__c  = emptyDate;
      if (clsInput.bail != null && clsInput.bail != '')
         docRec.bail_amount__c = double.valueof(clsInput.bail);
      else 
         docRec.bail_amount__c = 0;
      case1.bail_set_cash__c = docRec.bail_amount__c;
      case1.Criminal_Court_Arraignment_Date__c = docRec.ARRAIGNMENT_DATE__c;
      case1.name = docRec.docket__c;
      if (case1.Name.trim() == 'Docket NA')
         case1.No_Docket__c = true;
        if (userrole == 'CCI Brooklyn')
           case1.Borough__c = 'Brooklyn';
        else
           case1.Borough__c = 'Manhattan';
     docRec.charge_no__c = clsInput.charge1;
     docRec.charge_no1__c = clsInput.charge2;
     docRec.charge_no2__c = clsInput.charge3;
     docRec.charge_no3__c = clsInput.charge4;
     docRec.charge_no4__c = clsInput.charge5;
     if (clsInput.charge1 != null){
       ch0.type__c = 'Criminal Court Arraignment Charges';
       ch0.charge__c = chargesMapNameId.get(docRec.charge_no__c);}
    if (clsInput.charge2 != null){
       ch1.type__c = 'Criminal Court Arraignment Charges';
       ch1.charge__c = chargesMapNameId.get(docRec.charge_no1__c);}
    if (clsInput.charge3 != null){
       ch2.type__c = 'Criminal Court Arraignment Charges';
       ch2.charge__c = chargesMapNameId.get(docRec.charge_no2__c);}
    if (clsInput.charge4 != null){
       ch3.type__c = 'Criminal Court Arraignment Charges';
       ch3.charge__c = chargesMapNameId.get(docRec.charge_no3__c);}
    if (clsInput.charge5 != null){
       ch4.type__c = 'Criminal Court Arraignment Charges';
       ch4.charge__c = chargesMapNameId.get(docRec.charge_no4__c);}
       case1.Defense_Attorney_Law_Guardian__c  = attId;
       case1.RecordTypeId = 
       findCaseRecordType(ch0.charge__c,ch1.charge__c,ch2.charge__c,ch3.charge__c,ch4.charge__c);
       docRec.New_Docket__c = false;
       lstCases.add(case1);
     
         //Charges  
       lstCharges.add(ch0);
       lstCharges.add(ch1);
       lstCharges.add(ch2);
       lstCharges.add(ch3);
       lstCharges.add(ch4);
    
        cont1.firstname = docRec.firstname__c; 
        try{cont1.Middle_name__c = docRec.middlename__c;}
        catch(Exception e){}
        
        cont1.lastname = docRec.lastname__c;
        oneRow.accountName = cont1.firstname.trim() + ' ' + cont1.lastname.trim();
        cont1.BOOK_CASE__c = docRec.BOOKCASENUMBER__c;
        cont1.referral_source__c = docRec.Referralsource__c;
        cont1.recordtypeId = conCRT;
        cont1.CJA_Score__c = docRec.cja_score__c;
        cont1.DOC_Risk_Score__c = docRec.doc_score__c;
        cont1.MOCJ_RA_SCORE__c = docRec.MOCJ_RA_SCORE__c;  
        cont1.Referral_Date__c = date.today();
        cont1.Screening_Stage__c = 'Pending Attorney Info';
        lstContacts.add(cont1); 
  
       addr1.Street__c = docRec.ADDRESS__c;
       addr1.city__c = docRec.CITY__c.trim();
       addr1.state__c = docRec.STATE__c.trim();
       addr1.Zip__c = docRec.ZIP__c;
       addr1.Intake_Address__c = true;
       addr1.Address_Type__c = 'Primary';
       lstAddress.add(addr1);

       //-------------------- Court Date
        if (clsInput.nextCourtdate != null && clsInput.nextCourtdate != ''){
           docRec.Next_Court_Date__c = date.parse(clsInput.nextCourtdate.trim());
           s_datetime = docRec.Next_Court_Date__c.format() + ' ' +  '08:00 AM';
           ev1.ActivityDate = docRec.Next_Court_Date__c;
           ev1.ActivityDateTime = DateTime.parse(s_datetime);
           ev1.Verification_Due_Date__c = docRec.Next_Court_Date__c;  
           ev1.durationinminutes = 60;
           ev1.subject = 'Court Date';
           ev1.RecordTypeId = EventRecTypeId;
           oneRow.nextcourtdate = docRec.Next_Court_Date__c;}  
        else
           docRec.Next_Court_Date__c = emptyDate;
        lstEvents.add(ev1); 
        downloadedList.add(docRec);
        lstUploaded.add(oneRow);
        uploadInfo(downloadedList,lstUploaded);
     } 

     List<SelectOption> refItems;
    public List<SelectOption> getRefItems() {
        Schema.DescribeFieldResult fieldResult =
        Contact.Referral_Source__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setrefItems(){
        refItems = this.refItems;}  
     
    public List<SelectOption> getDesigItems() {
       Schema.DescribeFieldResult fieldResult =
            CIRT_Download__c.M_Designation__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       options.add(new SelectOption('',''));
       for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}

    public string attName{get;set;}
    string attId; 
    public void findAttorney(){
      if (attName != null){
        Contact cnt = [Select id, name from Contact where recordtypeId =: attRecordType and
           name =: attName limit 1];
        attId = cnt.id;}}


   public enteredInfo clsInput {get;set;}
   public class enteredInfo {
    public String Docket {get;set;}
    public String NYSID {get;set;}
    public string FName {get;set;}
    public String bookcase {get;set;}
    public String mName {get;set;}
    public String dob{get;set;}
    public String LName {get;set;}
    public String address {get;set;}
    public String city {get;set;}
    public String state {get;set;} 
    public String zip {get;set;}
    public String gender {get;set;}
    public String charge1 {get;set;}
    public String charge2 {get;set;}
    public String charge3 {get;set;}
    public String charge4 {get;set;}
    public String charge5 {get;set;}
    public String courtboro {get;set;}
    public String darraign {get;set;}
    public String bail {get;set;}
    public String nextcourtdate {get;set;}
    public String CJAscore {get;set;}
    public String DOCscore {get;set;}
    public String eligible {get;set;}
    public date eligdate {get;set;}
    public String refdate {get;set;}
    public String Referral_Source{get;set;}
    public String designation{get;set;}
    public String MOCJscore{get;set;}
    public String attorney{get;set;}}

     //  CHECK CSV. file structure
     boolean checkFileStructure(string[] csvHeader){
     nysidIndex = setColumnIndex('NYSID', csvHeader);
     if (nysidIndex == -1){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'NYSID column not found. Please contact IS'));
      return false;}
      bookIndex = setColumnIndex('BOOKCASENUMBER', csvHeader);
      if (bookIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'BOOKCASENUMBER column not found. Please contact IS'));
          return false;}
     fnameIndex = setColumnIndex('FIRST', csvHeader); 
     if (fnameIndex == -1){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_FIRST_NAME column not found. Please contact IS'));
         return false;}
      mnameIndex = setColumnIndex('MIDDLE', csvHeader);
     if (mnameIndex == -1){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_MIDDLE_NAME column not found. Please contact IS'));
        return false;}
     lnameIndex = setColumnIndex('LAST', csvHeader);
     if (lnameIndex == -1){
       ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_LAST_NAME column not found. Please contact IS'));
       return false;}
      docketIndex = setColumnIndex('DOCKET', csvHeader);
      if (docketIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'DOCKET column not found. Please contact IS'));
          return false;}
          addressIndex = setColumnIndex('INMATE_ADDRESS', csvHeader);
      if (addressIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_ADDRESS column not found. Please contact IS'));
      return false;}
          cityIndex = setColumnIndex('INMATE_CITY', csvHeader);
      if (cityIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_CITY column not found. Please contact IS'));
      return false;}
          stateIndex = setColumnIndex('INMATE_STATE', csvHeader);
      if (stateIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_STATE column not found. Please contact IS'));
      return false;}
          zipIndex = setColumnIndex('INMATE_ZIP', csvHeader);
      if (zipIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_ZIP column not found. Please contact IS'));
      return false;}
          dobIndex = setDOBIndex(csvHeader);
      if (dobIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_DOB column not found. Please contact IS'));
      return false;}
         genderIndex = setColumnIndex('GENDER', csvHeader);
      if (genderIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'INMATE_GENDER column not found. Please contact IS'));
      return false;}
         charge1Index = setColumnIndex('NO_1', csvHeader);
      if (charge1Index == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CHARGE_NO_1 column not found. Please contact IS'));
      return false;}
         charge2Index = setColumnIndex('NO_2', csvHeader);
      if (charge2Index == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CHARGE_NO_2 column not found. Please contact IS'));
      return false;}
         charge3Index = setColumnIndex('NO_3', csvHeader);
      if (charge3Index == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CHARGE_NO_3 column not found. Please contact IS'));
      return false;}
          charge4Index = setColumnIndex('NO_4', csvHeader);
      if (charge4Index == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CHARGE_NO_4 column not found. Please contact IS'));
      return false;}
         charge5Index = setColumnIndex('NO_5', csvHeader);
      if (charge5Index == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CHARGE_NO_5 column not found. Please contact IS'));
      return false;}
          boroCourtIndex = setColumnIndex('BOROUGH_COURT', csvHeader);
      if (boroCourtIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'BOROUGH_COURT column not found. Please contact IS'));
      return false;}
         arraingDateIndex = setColumnIndex('ARRAIGNMENT', csvHeader);
      if (arraingDateIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'DATE_OF_ARRAIGNMENT column not found. Please contact IS'));
      return false;}
         baleIndex = setColumnIndex('BAIL', csvHeader);
      if (baleIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'BAIL_AMOUNT column not found. Please contact IS'));
      return false;}
         nextCourtIndex = setColumnIndex('NEXT_COURT_DATE', csvHeader);
      if (nextCourtIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'NEXT_COURT_DATE column not found. Please contact IS'));
      return false;}
         cjaScoreIndex = setColumnIndex('CJASCORE', csvHeader);
      if (cjaScoreIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CJASCORE column not found. Please contact IS'));
      return false;}
         docScoreIndex = setColumnIndex('DOCSCORE', csvHeader);
      if (docScoreIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'DOCSCORE column not found. Please contact IS'));
      return false;}
         EligibleIndex = setColumnIndex('CIRT_ELIGIBLE_OPTION', csvHeader);
      if (EligibleIndex == -1){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'CIRT_ELIGIBLE_OPTION column not found. Please contact IS'));
      return false;} 
     return true;}
    
    // CASE RECORD TYPE
    string findCaseRecordType(string chg0,string chg1,string chg2,string chg3,string chg4){
      string s;
      if((mapPenalCodes.containsKey(chg0) && mapPenalCodes.get(chg0).Level__c == 'F')
           || (mapPenalCodes.containsKey(chg1) && mapPenalCodes.get(chg1).Level__c == 'F')
           || (mapPenalCodes.containsKey(chg2) && mapPenalCodes.get(chg2).Level__c == 'F')
           || (mapPenalCodes.containsKey(chg3) && mapPenalCodes.get(chg3).Level__c == 'F')
           || (mapPenalCodes.containsKey(chg4) && mapPenalCodes.get(chg4).Level__c == 'F')) {
              return caseSupremeRecTypeId;           
           } else {
   return caseCriminalRecTypeId;}}
   
   public PageReference refreshPage(){
     PageReference tempPage = ApexPages.currentPage();            
    tempPage.setRedirect(true);
    return tempPage ;
     
   }
   public void clearLists(){
            if (listLoads != null)
         listLoads.Clear(); 
       if (lstAccounts != null)
          lstAccounts.Clear();          
       if (lstCases != null)
          lstCases.Clear();         
       if (lstContacts != null)
          lstContacts.Clear();         
       if (lstEvents != null)
          lstEvents.Clear(); 
        if (lstAddress != null)
           lstAddress.clear();
        if (lstCharges != null)
           lstCharges.clear();
        if (downloadedList != null)
            downloadedList.Clear();
        if (lstUploaded != null)
            lstUploaded.Clear();
        if (docRec != null)
            docRec.clear();    
       if (oneRow != null)
           uploadedInfo oneRow = new uploadedInfo(); 
           defaultInputValues();          
   }
}