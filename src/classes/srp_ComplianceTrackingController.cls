public with sharing class srp_ComplianceTrackingController{
   public boolean sfAdmin{get;set;} 
   public reportQuery rq = new reportQuery(); 
   public UtilityTimeMethods ut = new UtilityTimeMethods();   
   public Event proxyObject {get; set;} 
   public string clientid15{get;set;}
   date SRP_activitydate;
List<SelectOption> dItems; 
   string caseType; 
   Map<Id, Case_Information__c> mapCaseInfo;   
    public srp_ComplianceTrackingController(){
         Id userProfId = userInfo.getProfileId();
      Profile p = [Select name from Profile where id =: userProfId limit 1];
      if (p.Name == 'System Administrator')
          sfAdmin = true;  
    Event e = new Event();
    e.activitydate = date.today();
    e.Closing_Date__c = date.today();
    proxyObject = e;
    string outcome = 'Entered in Error'; 
  //   generateDocketsList();
  }
  Set<String> allCases;
   public string selecteddocket{get;set;}
   public string selectedName{get;set;}
   public List<SelectOption> docketItems{get;set;}
  
  
   public string docketValue{get;set;}
 //  public string getdocketValue(){
 //     return docketValue;}
 //  public void setdocketValue(string docketValue){
 //     this.docketValue = docketValue;}

  
  
  //  public string docketValue{get{
  //    return ApexPages.currentPage().getParameters().get('docketValue');}   
  // set{this.docketValue = docketValue;}} 
   
  
   boolean clockValue;
   public boolean getclockValue(){
      return clockValue;}
   public void setclockValue(boolean clockValue){
      this.clockValue = clockValue;}

    public class compLetters{
    public string contactDate{get;set;}
    public string contactType{get;set;}
    public string trackId{get;set;}
    public string respond{get;set;}
    public string notes{get;set;}}
 
 
   public string deliqRecId{get;set;}
   public boolean showTextBox{get;set;}
   public boolean showFailedApps{get;set;}
   public boolean showFTA{get;set;}
   public string userName{get{
        ID userId = userInfo.getUserId();
        User u = [select name,title,signature,phone,email from user where id =: userId];
        string s = u.name + '\n' + u.title + '\n' + 'Email: ' + u.email;
        if (u.phone != null)
           s += '\n' + 'Phone: ' + u.phone; 
        return s;}}  
        
 public string signature{get{
        ID userId = userInfo.getUserId();
        User u = [select name,title,document_signature__c from user where id =: userId];
        return u.document_signature__c;}
        set{this.signature = signature;}}          

   public PageReference deliverAsPDF() {
      PageReference pdf =  Page.srp_ComplianceTrackingPage;
 //     pdf.getParameters().put('p','p');
       Chooserender = 'pdf';
  ///////////     refreshDocket();
    return pdf;
      }
      public String Chooserender{get;set;} 
      
/*
   public String getChooserender() {
   if (ApexPages.currentPage().getParameters().get('p') != null){
     //docketValue = selectedDocket; 
     System.Debug('\n XXX docketValue: ' + docketValue);
  //contactInfo();
     refreshDocket();
      return 'pdf';}
   else
   return null;} 
*/
   public ID actionId{get{
      return ApexPages.currentPage().getParameters().get('actionPassed');}   
   set{this.actionId = actionId;}}      
 
   public String clientId{get{
      return ApexPages.currentPage().getParameters().get('clientPassed');}   
   set{this.clientId = clientId;}}      

   public boolean manyCharges{get;set;}
   public List<compLetters> lstShowContacts{get;set;}
   public string docType{get;set;}
   string AccountId;
   public string LetterDate{get;set;}
   public string phone{get;set;}
   public string cell{get;set;}
   public string attPhone{get;set;}
   public string attName{get;set;}
   public string salutName{get;set;}
   public string salutLast{get;set;}
   public string courtName{get;set;}
   public string courtPart{get;set;}
   public string courtDate{get;set;}
  public string NextcourtDate{get;set;}
   public string PrevcourtDate{get;set;}
   public string betweenDates{get;set;}
   public string clientName{get;set;}
   public string reason{get;set;}
   public string NYSID{get;set;}
   public string caseid{get;set;}
   public string casetitle{get;set;}
   public string Indictment{get;set;}
   public string charges{get;set;}
   public string chargesType{get;set;}
   public string additional{get;set;}      
   public string dintake{get;set;}
   public string caseName{get;set;}
   public string JudgeConditions{get;set;}
   public string notes{get;set;}
   public string arrestCharges{get;set;}
   public string arrestDate{get;set;}
   public boolean lRearrest{get;set;}
   public boolean lRearrestLetter{get;set;}
   public string createdBy{get;set;}
   public string createdWhen{get;set;}
   public string modifiedBy{get;set;}
   public string modifiedWhen{get;set;}
   public string warrant{get;set;}
 //  public string outcome{get;set;}
   public string returned{get;set;}
   public string intakeAssessmentDate{get;set;}
   public string intakeAssessmentAttendance{get;set;}
   public string arrestDocketTitle{get;set;}
   public string intakeDocket{get;set;}
   public string arrestCaseId{get;set;}
   public string arrestDocket{get;set;}
   public string repPeriod{get;set;}
//   date   dactivity{get;set;}
   boolean isCourtPart;
   date prevCourt,intakeDate, nextCourt;
   public void contactInfo(){ 
     if (Chooserender == 'pdf')
        return;
      generateDocketsList();
 
         string outcome = 'Entered in Error';   
    //  System.Debug('\n\n XXX selecteddocket: ' + selecteddocket);
      isCourtPart = false;
      date ctdate, dArrest; 
         date dateNext;
      courtPart = '';
      lRearrestLetter = false;
      string Supervision,IntakeNeedsAssessment,courtRecType, action,status,intakecaseid,CaseRel_Id,pcid;
  //    Case_Information__c ci = new Case_Information__c();
 
      Map<Id, Contact> mapContact = rq.contactQueryByStringId(clientid);
      clientid15 = clientId.left(15);
      intakeDocket= mapContact.get(clientid).intake_case__c; 
      phone = mapContact.get(clientid).HomePhone;
      cell = mapContact.get(clientid).Client_Cell_Phone__c;
      pcid = mapContact.get(clientid).p_c_id__c;
      List<RecordType> lstRecType = [Select id,developername,name from RecordType
         where developername =: 'Court_Ordered_Supervision' or 
         developername =: 'Intake_Needs_Assessment' or developername =: 'CourtDate'];
      for (integer i = 0;i < lstRecType.Size();i++){
         if (lstRecType[i].developername == 'Court_Ordered_Supervision')
            Supervision = lstRecType[i].id;
         if (lstRecType[i].developername == 'Intake_Needs_Assessment')
            IntakeNeedsAssessment = lstRecType[i].id; 
         if (lstRecType[i].developername == 'CourtDate')
            courtRecType = lstRecType[i].id;     
      } 
 
     if (mapContact.get(clientid).Current_Intake_Date__c != null){
         intakeDate = mapContact.get(clientid).Current_Intake_Date__c;
         dintake = mapContact.get(clientid).Current_Intake_Date__c.format();
     //    caseid = mapContact.get(clientid).Intake_Case__c;
         }
        salutName = ClientName;
           string salut;

        if (mapContact.get(clientid).Gender_CC__c == null || mapContact.get(clientid).Gender_CC__c == '')
           salut = 'no Gender in SF-';
        else{
          if (mapContact.get(clientid).Gender_CC__c.substring(0,1) == 'M')
           salut = 'Mr.';
          else
           salut = 'Ms.' ;
        }
           salutName = salut + ' ' + mapContact.get(clientid).Name;
           salutLast = salut + ' ' + mapContact.get(clientid).lastname;
   
      string doc = '';
  docType = 'Letter';
 
  
   List<Event> chkRearrest = [select id from Event where id =: actionId limit 1];
  System.Debug('\n\n XXX actionId: ' + actionId); 
  // for re-arrest actionId - id in CASE Information
//return;
//  List<Case_Information__c> chkRearrest = 
//  [Select id, name,indictment__c,part__c, Defense_Attorney_Law_Guardian__c,
 //       Arrest_Date__c From Case_Information__c where id =: actionId];
    Event evtPassed = new Event();
    List<Event> lst4litters = new List<Event>();
    if (chkRearrest.Size() == 0){
      lRearrestLetter = true;
      arrestCaseId = actionId;
      caseType = 'In-Program';
      arrestCaseListCharges(arrestCaseId);  
      dArrest = mapCaseInfo.get(actionId).Arrest_Date__c;
      arrestdate = dArrest.format();  
      docType = 'Rearrest';
  //    casename = mapCaseInfo.get(actionId).name;
      casename = mapCaseInfo.get(intakeDocket).name;
      indictment = mapCaseInfo.get(intakeDocket).Indictment__c;
      if (indictment != null){
         caseTitle = 'Indictment:';
         casename = indictment;
      }      
      arrestDocketTitle = 'Docket:';           
      caseTitle = 'Docket:';
      indictment = mapCaseInfo.get(actionId).Indictment__c;
      arrestDocket = mapCaseInfo.get(actionId).Name;
      if (indictment != null){
        arrestDocket = indictment;
        arrestDocketTitle = 'Indictment:';
//        caseTitle = 'Indictment:';
 //       casename = indictment;
      }
  //    caseId = arrestCaseId;
        lst4litters = [select activityDate,Part__c,verification_status__c,
           whoid, whatid,subject from Event where subject =: 'Court Date'
            and whoid =: clientid and activitydate >: srp_ActivityDate 
            and Outcome__c !=: outcome 
            order by activitydate limit 1];
        if (lst4litters.size() <> 0) 
            caseid = lst4litters[0].whatid;    
//      charges = mostRecentCharges(arrestCaseId);
     charges = mostRecentCharges(intakeDocket);
//      docketValue = actionId;
     docketValue = intakeDocket;
//    System.Debug('\n XXX in rearrest casename: ' + casename + ' docketValue: ' + docketValue);      
   }
    else{
        evtPassed = [select id,whatid,subject,verification_status__c,part__c,
        activitydate from Event where id =: actionId limit 1];
    
        caseid = evtPassed.whatid;
        docketValue = caseid;
        if (evtPassed.subject == 'Court Date'){
            docType = 'Report';
     //      caseType = 'Intake';
           caseTitle = 'Docket:';            
           casename = mapCaseInfo.get(caseid).name;  
           indictment = mapCaseInfo.get(caseid).Indictment__c;             
           if (indictment != null){
                casename = indictment;
                caseTitle = 'Indictment:';
           }
         //   docType = 'Report';
         
            showFTA = false; 
            courtDate = evtPassed.activitydate.format();
            if (evtPassed.verification_status__c == 'Unexcused')
               showFTA = true;
               courtpart = evtPassed.part__c; 
           srp_ActivityDate = evtPassed.activitydate;
           courtPart = evtPassed.part__c;}  
       else{
         /*
            evtPassed = [select activityDate,Part__c,verification_status__c,
           whoid, whatid,subject from Event where subject =: 'Court Date'
            and whoid =: clientid and activitydate <=: srp_ActivityDate 
            and verification_status__c !=: 'Excused' and verification_status__c !=: 'Cancelled' and 
            verification_status__c !=: 'Not Verified' and Outcome__c !=: outcome 
            order by activitydate desc limit 1];
         */
         lst4litters = [select activityDate,Part__c,verification_status__c,
           whoid, whatid,subject from Event where subject =: 'Court Date'
            and whoid =: clientid and activitydate <=: srp_ActivityDate 
            and verification_status__c !=: 'Excused' and verification_status__c !=: 'Cancelled' and 
            verification_status__c !=: 'Not Verified' and Outcome__c !=: outcome 
            order by activitydate desc limit 1];   
           if (lst4litters.size() <> 0) 
            caseid = lst4litters[0].whatid;
           else
             caseid = intakeDocket; 
            docketValue = caseid;
            docType = 'Letter';
            caseTitle = 'Docket:';            
            casename = mapCaseInfo.get(caseid).name;  
            indictment = mapCaseInfo.get(caseid).Indictment__c;             
            if (indictment != null){
                casename = indictment;
                caseTitle = 'Indictment:';
           }
       }  
          charges = mostRecentCharges(CaseId);  
       }
/*
      if (ci.Indictment__c != null){
         caseTitle = 'Indictment:';
          casename = ci.Indictment__c;}
     else{
          caseTitle = 'Docket:';
          casename = ci.name;              
      }
       selecteddocket = docketValue;
  */
   System.Debug('\n\n XXX docType: ' + docType);  
  //   System.Debug('\n\n XXX showFTA: ' + showFTA + ' docType: ' + docType) ;         
     if (docType != 'Report'){
        ctdate = proxyObject.activitydate;
        courtDate = ctdate.format();
        srp_ActivityDate = proxyObject.activitydate;
     }
     List<Date> lstEventsDates = new List<Date>();
     List<ID> lstEventsCases = new List<ID>();
     Set<Date> lstEventsDateNext = new Set<Date>();
     Set<Date> lstEventsDatesPrev = new Set<Date>();  
     Set<String> courtsIds = new Set<String>();          
     List<Event> lstCourts = new List<Event>();
     List<Event> lstAllEvents = [select whoid,id,recordtypeid,activityDate,part__c,whatid,subject,
       Outcome__c,verification_status__c from Event  
           where whoid =: clientid  and Outcome__c !=: outcome and  
           (recordtypeid =: Supervision or 
          recordtypeid =: IntakeNeedsAssessment or subject =: 'Court Date') order by ActivityDate];
     prevCourt = findPrevDate(caseid);
    repPeriod = prevCourt.format() + '-' + courtDate;
    nextCourt = findNextCourt(caseid);
       if (nextCourt != null)
          nextCourtDate = nextCourt.format();  // nextCourt.format();
       else
         nextCourtDate = '';
          PrevCourtDate = prevCourt.format();  // prevCourt.format();
  System.Debug('\n\n XXX ctdate: ' + ctdate);       

      System.Debug('\n\n XXX caseType: ' + caseType); 

  List<Delinquency_Tracking__c> letter = rq.selectfromDb(actionId);
 
   integer letterIndex = 0; 
   boolean lCreated = false;
   for (integer i = 0; i < letter.Size(); i++){
       if (letter[i].actionId__c == actionId && letter[i].Document_Type__c.Trim() != 'Contact'){
          clockValue = letter[i].Stop_Clock__c;
          letterIndex = i;
          if (letter[i].letter_date__c != null)
                 LetterDate = letter[i].letter_date__c.format();  
             WarrantValue = letter[i].Warrant_issued__c;
             if (WarrantValue == 'Yes')          //|| WarrantValue == '')
                ShowOutcome = true;
             else  
                showOutcome = false;
            if (letter[i].Outcome__c != null){
                OutcomeValue = letter[i].Outcome__c.trim();
                if (OutcomeValue != '')
                   WarrantValue = 'Yes';}
            
             if (letter[i].FTA_reason__c != null)
                FTAValue = letter[i].FTA_reason__c;
                       
             if (letter[i].outcome__c != null)
                outcomeValue = letter[i].outcome__c;

             ReturnedValue = letter[i].Returned_to_Program__c;
             notes = letter[i].Notes__c;
             lCreated = true;
             deliqRecId = letter[i].id;   
          break;}}
     date docDate;
      boolean lnew;

   //  Delinquency_Tracking__c addRec = new Delinquency_Tracking__c();
      if (lcreated == false){
         

        Delinquency_Tracking__c addRec = new Delinquency_Tracking__c();
     /*
         if (docType == 'Rearrest'){
            Case_Relationship__c crRec = [select DelinquencyTrackingLKID__c,Docket__c,
            Supervised_by_SRP__c FROM Case_Relationship__c WHERE Contact__c =: clientId and
            docket__c =: actionId limit 1];
            System.Debug('\n\n XXX crRec: '+ crRec);
           System.Debug('\n\n XXX actionId: '+ actionId);
            string s = crRec.id;
            addRec.Case_Relationship__c = s;
          }
       */ 
          addRec.Document_Type__c = docType;
          addRec.Appointment_Date__c = srp_ActivityDate;
          if (docType == 'Letter'){
             addRec.letter_date__c = proxyObject.activitydate;
       //      addRec.SRP_ActivityDate__c = srp_ActivityDate;
             addRec.Letter_Date__c = date.today();
             clockValue = false;
             docDate = date.today();}
          else{
             addRec.caseId__c = caseid; 
             addRec.SRP_ActivityDate__c = srp_ActivityDate;
             //addRec.caseType__c = caseType;
          }
          addRec.caseType__c = caseType;
          addRec.Notes__c = '';
          addRec.Reasons_Summary__c = '';
          addRec.ActionId__c = actionId;
          addRec.caseId__c = caseid; 
          if (lRearrestLetter){
        //      addRec.caseId__c = caseid; 
        //      docType = 'Rearrest';
              docDate = date.today();}
          addRec.document_type__c = docType; 
        System.Debug('\n\n XXX addRec: '+addRec);  
          addRec.pcid__c = pcid;          
          insert addRec;
          deliqRecId = addRec.id;
          actionId = addRec.ActionId__c;
          createdBy = userInfo.getName();
          createdWhen = datetime.now().format(); 
          if (docType == 'Letter' || docType == 'Report'){ 
          Event ev = new Event(id=actionId);
          ev.Delinquency__c = addRec.id;
          update ev;}
          lnew = true;}
      else{
         User u = [Select name, id,signature from user where id =:letter[letterIndex].LastModifiedById]; 
         modifiedWhen = letter[letterIndex].LastModifiedDate.format();  
         modifiedBy = u.name;        
         u = [Select name, id from user where id =:letter[letterIndex].CreatedById]; 
         createdBy = u.name;
         createdWhen = letter[letterIndex].CreatedDate.format();
      //   if (letter[letterIndex].SRP_ActivityDate__c != null){  
         if (letter[letterIndex].letter_date__c != null)
              LetterDate = letter[letterIndex].letter_date__c.format();
         else
             LetterDate = date.today().format();     
         proxyObject.ActivityDate = letter[letterIndex].letter_Date__c; 
         if (letter[letterIndex].courtPart__c != null && letter[letterIndex].courtPart__c != ''){
            courtpart = letter[letterIndex].courtPart__c;
            isCourtPart = true;}
         if (letter[letterIndex].Additional_Info__c != '')
            additional = letter[letterIndex].Additional_Info__c;
        if (letter[letterIndex].Reasons_Summary__c != null){
           ReportReason = letter[letterIndex].Reasons_Summary__c;
         // if (letter[letterIndex].Warrant_issued__c != null){
           WarrantValue = letter[letterIndex].Warrant_issued__c;
          if (WarrantValue == 'Yes') // || WarrantValue == '')
             ShowOutcome = true;
          else  
             showOutcome = false;
           if (letter[letterIndex].Outcome__c != null){
              OutcomeValue = letter[letterIndex].Outcome__c.trim();
          if (OutcomeValue != '')
             WarrantValue = 'Yes';           
           }           
           ReturnedValue = letter[letterIndex].Returned_to_Program__c;
   
           if (ReportReason.contains('failed to complete additional judicial conditions') ||
              ReportReason.contains('is partially compliant with the program supervision schedule') ||
              ReportReason.contains('has failed to comply with the requirement of the program schedule'))
              showTextBox = true;
              notes = letter[letterIndex].Notes__c;
           if (ReportReason.contains('failed to report for the following supervision appointment'))
           showFailedApps = true;  
           docType = letter[letterIndex].document_type__c;
           docDate = letter[letterIndex].letter_date__c;
        }
       deliqRecId = letter[letterIndex].id;}
          if (isCourtPart == false)
        saveCourtPart();
   
         if (lNew == true) {
             Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
            d.AccountId__c = mapContact.get(clientid).accountId;
            d.SRP_ActivityDate__c = ctdate;
            d.ActionId__c = actionid;
            d.Client__c = clientid;
            update d;}
  
         JudgeConditions = mapContact.get(clientid).Judge_s_Conditions__c; 
         List<Address_Information__c> listAddress = rq.addressQuery(clientId);
    /*     
       for (Address_Information__c a : listAddress){
       //     if (a.Address_Type__c == 'Primary'){
          //     phone = a.Home_Phone__c;
              if (cell == '' || cell == null)
                 cell = a.Cell_Phone__c;
              break;}}
      */
         if (docType == 'Letter' || docType == 'Rearrest')
           caseId = mapcontact.get(clientid).intake_case__c;
           courtName =  mapContact.get(clientid).Intake_Court_Formula__c ;
           clientName = mapContact.get(clientid).Name;
      Map<Id, Account> mapAccount = rq.accountQuery(mapContact.get(clientid).AccountId);
     if (mapAccount.get(mapContact.get(clientid).AccountId).nysid_number__c <> null)
           nysid = mapAccount.get(mapContact.get(clientid).accountId).nysid_number__c; 
       
     
    String[] casesToprint = new List<String>{'Intake Case','In-Program'};     
   // if (docType == 'Report')
   //   ci = [Select id, name,indictment__c,part__c, Defense_Attorney_Law_Guardian__c
   //  From Case_Information__c where id =: caseid];
   // else{
  //    if (selectedDocket != null)  
   //      caseid = selectedDocket;
    //  else
     //    caseid = intakedocket;   
   //   ci = [Select id, name,indictment__c,part__c, Defense_Attorney_Law_Guardian__c
   //    From Case_Information__c where id =: caseid];
//     System.Debug('\n\n XXX intakeCaseId: ' + intakeCaseId);
     string attId = string.valueOf(mapCaseInfo.get(caseId).Defense_Attorney_Law_Guardian__c);
    if (attId != null){
       Map<Id, Contact> mapContactAtt = rq.contactQueryByStringId(attId);  
     if (mapContactAtt.get(attid).firstname <> null && mapContactAtt.get(attid).lastname <> null)
        attName = mapContactAtt.get(attid).firstname + ' ' + mapContactAtt.get(attid).lastname;
    
     attPhone = mapContactAtt.get(attid).phone;
    }
 //   }
 /////////////////////////  charges = mostRecentCharges(caseid);
   if (docType != 'Report' && docDate != null)
    CourtDate  = docDate.format(); 
   
 //  date dArrestDateDate = date.parse(dArrest); 
   
   if (docType == 'Rearrest'){
     for (integer r = 0; r < lstAllEvents.Size();r++){
         if (lstAllEvents[r].activityDate > dArrest && lstAllEvents[r].subject == 'Court Date'
             && lstAllEvents[r].whatid == intakecaseid){
           nextCourtDate = (lstAllEvents[r].activityDate).format();
           break;
        }
   }
   }
   
 countApps(caseid);
    
 //  prevcourt = datePrev;
 
    if (lNew == true && docType == 'Rearrest') {
      List<Case_Relationship__c> caseRelRecord = [select docket__c,id,pcid__c,contact__c
      From Case_Relationship__c where 
        Case_Type__c =: 'In-Program' and program__c =: 'SRP' 
        and docket__c =: actionId and contact__c =: clientId limit 1];
        if (caseRelRecord.Size() != 0)
           CaseRel_Id = caseRelRecord[0].id; 
        Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId); 
//          notes = salutName + ' was arrested on ' + arrestdate + 
 //             ' [ '+ arrestDocketTitle +  arrestDocket + ' ] for the charges listed below.';  
       d.Case_Relationship__c = CaseRel_Id;
       notes = salutName + ' was arrested on ' + arrestdate + ' for the charges listed below.';  
         d.document_type__c = 'Rearrest';
              d.caseid__c = arrestCaseId;
              LetterDate = date.today().format(); 
              d.letter_date__c = date.today(); 
              additional = 'Although, ' + salutName + ' ' + 
               'was arrested, this participant attended ' + F2Fattended +  ' out of ' + F2F_allApps + 
              ' scheduled face-to-face appointments and kept ' + CALLattended + ' out of ' + CALL_allApps + ' call check-ins.';              
             d.Additional_Info__c = additional;
  
            d.notes__c = notes; 
            d.Reasons_Summary__c = 'was arrested'; 
            d.Additional_Info__c = additional;
            reportReason = 'was arrested';
          update d;
          if (CaseRel_Id != null){
          Case_Relationship__c crUpdate = new Case_Relationship__c(id=CaseRel_Id);
            crUpdate.DelinquencyTrackingLKID__c = deliqRecId;
            update crUpdate;  
          }}     
      
    if (lNew == false){
      refreshNotes();
      letter = rq.selectfromDb(actionId);}
      lstShowContacts =  allContacts(letter);
       showProgNotes = selectOutReachNotes();}
   
   public string mostRecentCharges(string caseid){
       string s = '';
       chargesType = rq.mostResentChargesType(caseid); 
       if (chargestype != '')   
          s = rq.ChargesDescription(caseid, chargesType); 
          
       return s;}

   public class arrestListcls{
       public string chargeType{get;set;}
       public string chargeName{get;set;}
       public string chargeDescr{get;set;}}
   public List<arrestListcls> arrlistChargesShow{get;set;}         
   public void arrestCaseListCharges(string caseid){
    List<Case_Charges__c> lstCharges = new List<Case_Charges__c>
    ([select Charge__c, type__c,name from case_charges__c where docket_no__c =: caseId order by type__c limit 20]);
      if (lstCharges.Size() == 0)
         return; 
    List<arrestListcls> allCharges = new List<arrestListcls>();
    arrestListcls OneCharge = new arrestListcls();
    Set<Id> chargesId = new Set<Id>();
    for (Case_Charges__c chg : lstCharges){
        chargesId.add(chg.Charge__c);}
    Map<id,Penal_Code__c> mapCodes = new  Map<id,Penal_Code__c>
       ([select id,name,description__c From Penal_Code__c where id in: chargesId]);
    for (integer h = 0; h < lstCharges.Size(); h++){
         OneCharge = new arrestListcls();
        if (lstCharges[h].charge__c != null){
    //      if (lstCharges[h].type__c == 'Criminal Court Arraignment Charges'){
            OneCharge.chargeType =  lstCharges[h].type__c;
            OneCharge.chargeName =  mapCodes.get(lstCharges[h].charge__c).name;            
          OneCharge.chargeDescr = mapCodes.get(lstCharges[h].charge__c).description__c;
          allCharges.add(OneCharge);
         }
        //}
    if (allCharges.Size() > 2)
       manyCharges = true;
    }
      arrlistChargesShow = allCharges;}
 
   public string F2Fapps{get;set;}
   public string F2Fattended{get;set;} 
   public string F2Ffail{get;set;} 
   public string F2F_allApps{get;set;} 

   public string CALLapps{get;set;}
   public string CALLattended{get;set;} 
   public string CALL_allApps{get;set;}
   public string CALLfail{get;set;} 
   
   public string Assapps{get;set;}
   public string Assattended{get;set;} 
   public string Ass_allApps{get;set;}
   public string Assfail{get;set;} 

   public String ReportReason{get;set;} 
   public String WarrantValue{get;set;} 
   public String ReturnedValue{get;set;} 
   public String FTAValue{get;set;} 

   public String autoText{get;set;} 
   public String ReasonReason{get;set;} 
   public List<SelectOption> ReportReasonItems{get{
       List<SelectOption> optItems = new List<SelectOption>();
       string item1,item2,item3,item4;
 
      if (lRearrestLetter == true){
          optItems.add(new SelectOption('was arrested.','was arrested.'));    
          docType = 'Rearrest';}        
       else{
       if (docType == 'Report'){
          item1 = 'failed to report for the first mandatory intake and needs assessment appointment.';
          item2 = 'is in compliance with the requirements of the program.';
          item3 = 'is partially compliant with the program supervision schedule.';
          item4 = 'has failed to comply with the requirement of the program schedule.';}
       else{
          item1 = 'was arrested';
          item2 = 'failed to report for the first mandatory intake and needs assessment appointment.';
          item3 = 'failed to report for the following supervision appointment(s).';
          item4 = 'failed to complete additional judicial conditions.';}
       optItems.add(new SelectOption('',''));
       optItems.add(new SelectOption(item1,item1));
       optItems.add(new SelectOption(item2,item2));
       optItems.add(new SelectOption(item3,item3));
       optItems.add(new SelectOption(item4,item4));}
       return optItems;}
       set{ReportReasonItems = this.ReportReasonItems;}} 
    
    public void saveReason(){
      showTextBox = false;
      showFailedApps = false; 
      refreshNotes();  
      contactInfo();}
  
    public void savenotes(){
      Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      d.Notes__c = notes;
      update d;}

    public string newContactDate{get;set;}
    public string response{get;set;}
    public string contacttype{get;set;}
    public string messageText{get;set;}
   
    public void saveContact(){
      date dcontact = date.parse(newContactDate);   
      if (dContact > date.today()){
                messageText = 'Contact date can not be after today';
        return;}    
      if (contacttype == null || contacttype == ''){
        messageText = 'Please select contact type';
        return;}

      if ((contacttype == 'Staff call' ||  contacttype == 'Staff visit') && response == null){
        messageText = 'Please select response';
        return;}
       Delinquency_Tracking__c d = new Delinquency_Tracking__c();
   
      d.Document_Type__c = 'Contact';
      d.Outreach_type__c = contacttype;
      if (newContactDate != '')
         d.Date_of_Contact__c = date.parse(newContactDate);
         d.Client__c = clientid;
         d.AccountId__c = accountId; 
         d.ActionId__c = actionId;
         d.Response__c = response;
         d.Notes__c = contactnotes;
        if (response == 'Contact made')
          d.Stop_Clock__c = true;
      else 
          d.Stop_Clock__c = false;         
      insert d;
         Delinquency_Tracking__c dLetter = [select Stop_Clock__c, id,actionid__c from Delinquency_Tracking__c  where
          actionid__c =: actionid and document_type__c =: 'Letter' limit 1];
        Delinquency_Tracking__c d1 = new Delinquency_Tracking__c(id=dLetter.id);
        d1.Stop_Clock__c = d.Stop_Clock__c;
        update d1;
        clockValue = d.Stop_Clock__c ;
  
    // SAVE in PROGRESS NOTES
     Map<Id, Contact> mapContact = rq.contactQueryByStringId(clientid);
     Id ppId = mapContact.get(clientid).Most_Recent_Program_Plan__c;   
     
     Progress_Note__c pn = new Progress_Note__c();
     pn.Program_Plan__c = ppId;
     pn.Area__c = 'Compliance Effort';
     pn.recordtypeId = Utility_ID__c.getValues('Case Note').RecordType_Id__c;
     pn.Activity_Date__c = srp_ActivityDate;
  //   pn.Contact_datetime__c = dtContact;
    // integer t = integer.valueOf(times.substring(0,2));
    // if (i > 12)
    //    t = t + 12;
     // string sDateTime = newContactDate + ' ' + times; 
  //   string sDateTime = newContactDate + ' ' + times; 
  //   string sDateTime = datetime.parse(newContactDate).format() + ' ' + times; 
//     dt = dt+= ' ' + times;
   //   pn.date__c = date.parse(dt); 
//     pn.Contact_datetime__c = datetime.valueOf(sDateTime);
     pn.Progress_Note__c = contacttype + ' '  +  newContactDate + ' at ' + times + '\n' +
     ' Respond: ' + response + '\n' + contactnotes;
       insert pn;
      Progress_Note__c pUpdate = new Progress_Note__c(id=pn.id);
      pUpdate.Activity_Date__c = srp_ActivityDate;
      update pUpdate;

     displayPopup = false;   
      closePopup();
      contactInfo();}
    
    public void saveDate(){
             Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      d.Letter_Date__c = proxyobject.ActivityDate;
     LetterDate = proxyobject.ActivityDate.format();        
      update d;}

    public boolean displayPopup {get; set;}
    public void closePopup() {displayPopup = false;}
    
    public void showPopup() {
      displayPopup = true;
      newContactDate = date.today().format();
      contacttype = '';
      response = '';
      contactNotes = '';
      timeItems = BuildTimeList();}
    
   public List<compLetters> allContacts(List<Delinquency_Tracking__c> lstLetters){
     List<compLetters> lstDeliq = new List<compLetters>();
     compLetters oneRecord = new compLetters();
     for (integer i = 0; i < lstLetters.Size(); i++){
       if (lstLetters[i].Document_Type__c == 'Contact'  ){
          oneRecord = new compLetters();
          oneRecord.respond = lstLetters[i].Response__c;
          oneRecord.contactType = lstLetters[i].Outreach_type__c;
          oneRecord.notes = lstLetters[i].Notes__c;
          if (lstLetters[i].Date_of_Contact__c != null)
             oneRecord.contactDate = lstLetters[i].Date_of_Contact__c.format();
          oneRecord.trackId = lstLetters[i].id;
          lstDeliq.add(oneRecord);
       }}
     return lstDeliq;}   
   //   deleted_by_user__c =: false order by LastmodifiedDate desc limit 1] ;
   public List<SelectOption> TypeItems{get{
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      options.add(new SelectOption('Staff call', 'Staff call'));
      options.add(new SelectOption('Staff visit', 'Staff visit'));
      options.add(new SelectOption('Client called in', 'Client called in'));
      options.add(new SelectOption('Client at office', 'Client at office'));
      options.add(new SelectOption('Others', 'Others'));
      return options;}
     set{TypeItems = this.TypeItems;}}       

   public List<SelectOption> StaffCall{get{
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      options.add(new SelectOption('No contact', 'No contact'));
      options.add(new SelectOption('Left message', 'Left message'));
      options.add(new SelectOption('Contact made', 'Contact made'));
      return options;}
      set{this.StaffCall = StaffCall;}}

   public List<SelectOption> StaffVisit{get{
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      options.add(new SelectOption('No contact', 'No contact'));
      options.add(new SelectOption('Left letter', 'Left letter'));
      options.add(new SelectOption('Contact made', 'Contact made'));
      return options;}
      set{this.StaffVisit = StaffVisit;}}
 
     public string contactNotes{get;set;}
     public boolean contactMade{get{
        boolean lreturn;
        if (contacttype != 'Staff call'&&contacttype != 'Staff visit'&&contacttype != ''&&contacttype != null){
           lreturn = true;
           response = 'Contact made';}
        else
           lreturn =  false;
        return lreturn;      
        }set{this.contactMade = contactMade;}}

     public List<SelectOption> ContactRespondItems{get{
      List<SelectOption> option = new List<SelectOption>();
      if (contacttype == 'Staff call')
          option = StaffCall;
      else{
         if (contacttype == 'Staff visit')
           option = StaffVisit;}
      return option;}   
   set{this.ContactRespondItems = ContactRespondItems;}} 
  
   public pageReference donothing(){
         return null;}
   
   public void savecourtPart(){ 
        Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      d.CourtPart__c = CourtPart;
      update d;}
   public void refreshNotes(){
        Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      d.Reasons_Summary__c = ReportReason;
      d.courtPart__c = courtPart;
      if (ReportReason == '')
        notes = '';
     else{   
      if (ReportReason.contains('is in compliance')){
           notes = salutName + ' ' + 'has had no new arrests since the last court appearance and has been compliant ' +
           'with all other requirements of the program, including attending face-to-face appointments and keeping all scheduled phone calls.';
         }
         else{
             if (ReportReason.contains('is in compliance with the requirements of the program'))
              notes = salutName + ' has had no new arrests since the last court appearance.' + 
               ' and has been compliant with all other requirements of the program, including attending all face-to-face ' +  
               'appointments and keeping all scheduled phone calls';
             else{
               if (ReportReason.contains('was arrested')) 
                  notes = 'Although, ' + salutName + ' ' + 
                     'was arrested, this participant attended ' + F2Fattended +  ' out of ' + F2F_allApps + 
                   ' scheduled face-to-face appointments and kept ' + CALLattended + ' out of ' + CALL_allApps + ' call check-ins.';              
               else{
               if (ReportReason.contains('failed to report for the following supervision appointment'))
                  notes = 'Although, ' + salutName + ' ' + 
                     'is non-compliant due to missing supervision appointment(s), this participant attended ' + F2Fattended +  ' out of ' + F2F_allApps + 
                      ' scheduled face-to-face appointments and kept ' + CALLattended + ' out of ' + CALL_allApps + ' call check-ins.';              
               else     
               if (ReportReason.contains('failed to complete additional judicial conditions'))
                  notes = 'Although, ' + salutName + ' ' + 
                     'is non-compliant due to failure to abide by  additional judicial conditions, this participant attended ' + F2Fattended +  ' out of ' + F2F_allApps + 
                      ' scheduled face-to-face appointments and kept ' + CALLattended + ' out of ' + CALL_allApps + ' call check-ins.';              
               else
               if (ReportReason.contains('failed to report for the first mandatory intake and needs assessment appointment')
                  || ReportReason.contains('has failed to comply with the requirement of the program schedule'))
                  notes = '';            
               else  
                if (ReportReason.contains('is partially compliant with the program supervision schedule'))
                   notes = salutName + ' has had no new arrests since the last court appearance.';
               }}}} 
          d.Notes__c = notes;
      update d;
             showTextBox = true;
       if (ReportReason.contains('failed to report for the following supervision appointment'))
          showFailedApps = true;}
   public void saveWarrant(){
    System.Debug('\n\n XXX in save Warranr recid: ' + deliqRecId + ' warrant: ' + WarrantValue);
      Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      if (WarrantValue == 'Yes')  // || WarrantValue == '')
        showOutcome = true;
      else  
        showOutcome = false;
      d.Warrant_issued__c = WarrantValue;
      update d;
      //return null;
      }          
 public void saveOutcome(){
      Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      d.Outcome__c = OutcomeValue;
      if (OutcomeValue != ''){
         WarrantValue = 'Yes';
         d.Warrant_issued__c = 'Yes'; 
      }
      update d;}
      //return null;}          
 public void saveReturned(){
      Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      d.Returned_to_Program__c = ReturnedValue;
      update d;}
      //return null;}          
  public boolean showOutcome{get;set;}
  public string clockColor{get{
    string color;
    if (clockValue == true)
        color = 'green';
    else
        color = 'red';
    return color;}}
  List<SelectOption> WarrantItems;
  public List<SelectOption> getWarrantItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Warrant_issued__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setWarrantItems(){
        WarrantItems = this.WarrantItems;}
 
    List<SelectOption> ReturnItems;
    public List<SelectOption> getReturnItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Returned_to_Program__c  .getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setReturnItems(){
        ReturnItems = this.ReturnItems;}
 
    List<SelectOption> OutcomeItems;
    public List<SelectOption> getOutcomeItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Outcome__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setOutcomeItems(){
        OutcomeItems = this.OutcomeItems;}
 /*
   public string FTAoutcomeValue{get;set;}
   List<SelectOption> FTAOutcomeItems;
    public List<SelectOption> getFTAOutcomeItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Outcome__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setFTAOutcomeItems(){
        OutcomeItems = this.FTAOutcomeItems;}
 
 */
 public string ReasonValue{get;set;}
 List<SelectOption> ReasonItems;
    public List<SelectOption> getReasonItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.FTA_reason__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));}       
        return options;}
    public void setReasonItems(){
        ReasonItems = this.ReasonItems;}
 
   public void saveFTA(){
     system.Debug('\n\n XXX deliqRecId: ' + deliqRecId);
      Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
     if (docType == 'Report')
        d.FTA_reason__c = FTAValue;
    else
      d.warrant_Issued__c = FTAValue;
      update d;}  

 public void saveOutcomeValue(){
     system.Debug('\n\n XXX deliqRecId: ' + deliqRecId);
      Delinquency_Tracking__c d = new Delinquency_Tracking__c(id=deliqRecId);
      d.outcome__c = outcomeValue;
      update d;}  

public void refreshDocket(){
//  docketValue = ApexPages.currentPage().getParameters().get('selectedDocket'); 
 System.Debug('\n DDD docketValue: ' + docketValue);
   if (docketValue == null)
       return;
 //    List<Case_Information__c> ci = [select Id, name,Indictment__c from Case_Information__c
 //       where id =: docketValue limit 1];
  //  if (ci.size() <> null){    
    indictment = mapcaseInfo.get(docketValue).Indictment__c;
    if (indictment != '' && indictment != null){
         casename = indictment;
         caseTitle = 'Indictment:';}
    else {
         casename = mapcaseInfo.get(docketValue).name;
         caseTitle = 'Docket:';}
    caseId = docketValue;     
    charges = mostRecentCharges(docketValue);

  //  selecteddocket = docketValue;
    //if (docType == 'Report'){
       prevCourt = findPrevDate(caseid);
       countApps(caseid);
       if (nextCourt != null)
          nextCourtDate = nextCourt.format();       
       repPeriod = prevCourt.format() + '-' + courtDate;
   // }
//    }
}
  
  public void deleteDocument(){
   Delinquency_Tracking__c d = [select id from Delinquency_Tracking__c where
     actionid__c =: actionId limit 1];
  delete d;
    } 
 string pickLabel;
  public string outcomeValue{get;set;}
   List<SelectOption> FTAOutcomeItems;
  public List<SelectOption> getFTAOutcomeItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Outcome__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
         pickLabel = f.getLabel();
         if (pickLabel <> 'Warrant Vacated' && pickLabel <> 'Warrant Stayed')  
            options.add(new SelectOption(pickLabel, f.getValue()));}       
        return options;}
    public void setFTAOutcomeItems(){
        FTAOutcomeItems = this.FTAOutcomeItems;}
 
 
 // public string LetteroutcomeValue{get;set;}
   List<SelectOption> LetterOutcomeItems;
  public List<SelectOption> getLetterOutcomeItems() {
        Schema.DescribeFieldResult fieldResult =
        Delinquency_Tracking__c.Outcome__c.getDescribe();
       List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('',''));
        for( Schema.PicklistEntry f : ple){
          pickLabel = f.getLabel();  
          if (pickLabel == 'Warrant Vacated' || pickLabel == 'Warrant Stayed')
          options.add(new SelectOption(pickLabel, f.getValue()));}       
        return options;}
    public void setLetterOutcomeItems(){
        LetterOutcomeItems = this.LetterOutcomeItems;}
 
  public string times{get;set;}   
   public List<SelectOption> timeItems{get;set;}    
  
  List<SelectOption> BuildTimeList() {
   string t_timeBeg = '08:00 AM';
   string t_timeEnd = '10:00 PM';
   integer t_end,minbreak,t_beginning ;
   string t_begA  = 'AM';
   integer iterations = 15;
   List<SelectOption> optionForSelect = new List<SelectOption>();
   integer hours = 14;
   string nextitem = ut.addItteration(t_timebeg, iterations);
   optionForSelect.add(new SelectOption(t_timeBeg,t_timeBeg));
   for (integer i = 1; i <= hours; i++){   
      for (integer n = 0; n < 60 ; n+=iterations){ 
            nextitem = ut.addItteration(t_timebeg, iterations);
            optionForSelect.add(new SelectOption(nextitem,nextitem));
            t_timebeg = nextitem;}}
   return  optionForSelect;} 

 public class progNotes{
    public string contactDate{get;set;}
    public string progid{get;set;}
     public string notes{get;set;}}
 
   public List<prognotes> showProgNotes{get;set;} 
   List<prognotes> selectOutReachNotes(){
     
//   string id15 = clientid.substring(0,15);
   List<prognotes> lstNotes = new List<prognotes>();
   prognotes onenote = new prognotes();
     for (Progress_Note__c lstHistory : [select date__c, Progress_Note__c,id from 
     Progress_Note__c where Client_Id__c =: clientid15 and Area__c =: 'Compliance Effort'
     order by date__c desc]){ 
     onenote = new prognotes();
     onenote.contactDate = lstHistory.date__c.format();
     onenote.notes = lstHistory.Progress_Note__c;
     onenote.progid = lstHistory.id;
     lstNotes.add(onenote);}
     return lstNotes;}
     
   public ID idProgDelete{get;set;}
   public void deletePrognote(){
   Progress_Note__c pDelete = [select id from Progress_Note__c where id =: idProgDelete limit 1];
     delete pDelete;
   }
 

    void countApps(string casepassed){
    string casePass; 
   // if (docType == 'Report')
      casePass = casepassed;
 //   else
 //     casePass = ''; 
      
      
   System.Debug('\n XXX in count prevCourt :' + prevCourt + ' srp_activityDate: ' + srp_activityDate);            
      //  List<Event> lstEvents = 
//       rq.appointments(prevCourt, srp_activityDate,clientId, 'Meeting',casePass); 
    List<Event> lstEvents = appointments(prevCourt, srp_activityDate,clientId, 'Meeting',casePass); 

   System.Debug('\n XXX in count lstEvents :' + lstEvents);            


    F2Fapps = '';
    integer f2f_all = 0;
    integer f2f_att = 0;
    integer call_all = 0;
    integer call_att = 0;
    integer ass_all = 0;
    integer ass_att = 0;
   
    CALLfail = '';
    Assfail = '';
    F2Ffail = '';        
    for (Event e : lstEvents){
       if (F2Fapps == '')
           F2Fapps += e.ActivityDate.format();
       else 
           F2Fapps += ', ' + e.ActivityDate.format(); 
      if (e.Verification_Status__c == 'Attended' || e.Verification_Status__c == 'Contact Made'
       || e.Verification_Status__c == 'Case Conference')
           f2f_att++;
       else{
            if (F2Ffail == '')
                   F2Ffail += e.ActivityDate.format();
            else        
               F2Ffail +=  ', ' + e.ActivityDate.format();
               F2Fapps +='*';}
       f2f_all++;}
   System.Debug('\n XXX in count F2Fapps :' + F2Fapps + ' attended: ' + F2Fapps);    
   CALLapps = '';
  //lstEvents = rq.appointments(prevCourt,srp_activityDate, clientId, 'Call',casePass); 
  lstEvents = appointments(prevCourt,srp_activityDate, clientId, 'Call',casePass); 
  
   for (Event e : lstEvents){
      if (CALLapps == '')
         CALLapps += e.ActivityDate.format();
      else 
         CALLapps += ', ' + e.ActivityDate.format();  
     if (e.Verification_Status__c == 'Attended' || e.Verification_Status__c == 'Contact Made'
       || e.Verification_Status__c == 'Case Conference')
        call_att++;
        else{
            if (CALLfail == '')
                   CALLfail += e.ActivityDate.format();
            else        
               CALLfail +=  ', ' + e.ActivityDate.format();
            CALLapps += '*'  ;}
        call_all++;}
   
     Assapps = '';
//  lstEvents = rq.appointments(prevCourt,srp_activityDate, clientId, 'Intake/Needs Assessment',casePass); 
  lstEvents = appointments(prevCourt,srp_activityDate, clientId, 'Intake/Needs Assessment',casePass); 
  
   for (Event e : lstEvents){
      if (Assapps == '')
         Assapps += e.ActivityDate.format();
      else 
         Assapps += ', ' + e.ActivityDate.format();  
     if (e.Verification_Status__c == 'Attended')
        ass_att++;
        else{
            if (assfail == '')
                   assfail += e.ActivityDate.format();
            else        
               assfail +=  ', ' + e.ActivityDate.format();
           Assapps += '*'  ;}
        ass_all++;}
      F2Fattended = string.ValueOf(f2f_att);
      F2F_allApps = string.ValueOf(f2f_all);  
      CALLattended = string.ValueOf(call_att);
      CALL_allApps = string.ValueOf(call_all);  
      Assattended = string.ValueOf(ass_att);
      Ass_allApps = string.ValueOf(ass_all);  
   }
   
   date findPrevDate(string casepassed){
    date dt;
 // || docType == 'Rearrest'
    string outcome = 'Entered in Error';
    if (docType == 'Report'){
        for (Event ePrev : [select whoid,id,recordtypeid,activityDate,part__c,whatid,subject,
       verification_status__c from Event 
           where whoid =: clientid and subject =: 'Court Date'   and Outcome__c !=: outcome
           and whatid =: casepassed
           and activityDate <: srp_ActivityDate
           and verification_status__c = 'Attended' order by ActivityDate desc limit 1]){
           dt = ePrev.activitydate;
       }}
     else{
       for (Event ePrev : [select whoid,id,recordtypeid,activityDate,part__c,whatid,subject,
       verification_status__c from Event 
           where whoid =: clientid and subject =: 'Court Date'   and Outcome__c !=: outcome
           and activityDate <: srp_ActivityDate 
           and verification_status__c = 'Attended' order by ActivityDate desc limit 1]){
           dt = ePrev.activitydate;
     }}  
     if (dt == null)
       dt = intakeDate;
    return dt;   
   } 

  List<Event> appointments(date dstart, date dend, string clientid, string appSubject,string appcase){
     string ass1 = 'Intake/Needs Assessment';
     string ass2 = 'Intake/ Assessment';   
     List<Event> lstApps = new List<Event>();
     string outcome = 'Entered in Error';    
       if (appSubject.contains('Assessment')){
        lstApps = [select activityDate,Part__c,verification_status__c,
           whoid, whatid,subject from Event where  
            activityDate >=: dstart and activityDate <=: dend and (subject =: ass1 or subject =: ass2)
            and whoid =: clientid and verification_status__c !=: 'Excused' and verification_status__c !=: 'Cancelled' and 
            verification_status__c !=: 'Not Verified' and Outcome__c !=: outcome order by activitydate ]; 
     }   
     else{ 
          lstApps = [select activityDate,Part__c,verification_status__c,
           whoid, whatid,subject from Event where  
            activityDate >=: dstart and activityDate <=: dend and subject =: appSubject
            and whoid =: clientid and verification_status__c !=: 'Excused' and verification_status__c !=: 'Cancelled' and 
            verification_status__c !=: 'Not Verified' and Outcome__c !=: outcome order by activitydate ];   
     }
  return lstApps;}
  date findNextCourt(string casepassed){
    date dt;
    string outcome = 'Entered in Error';
    for (Event eNext : [select whoid,id,recordtypeid,activityDate,part__c,whatid,subject,
       verification_status__c from Event 
       where whoid =: clientid and subject =: 'Court Date' 
       and whatid =: casepassed  and Outcome__c !=: outcome
       and activityDate >: srp_ActivityDate order by ActivityDate limit 1]){
       dt = eNext.activitydate;
       }
       return dt;     
  }
 void generateDocketsList(){
   dItems = new List<SelectOption>();   
  allCases = new Set<String>();
  /*
  List<Case_Relationship__c> lstCasesAll = [select Id, Docket__r.Indictment__c,docket_indictment__c,
      Docket__r.Name, Docket__c, Contact__c, Case_Type__c,Supervised_by_SRP__c  
      From Case_Relationship__c  where contact__c =: clientId 
     and (Case_Type__c =: 'Intake Case' or Case_Type__c =: 'In-Program') order by Case_Type__c]; 
 */
 List<Case_Relationship__c> lstCasesAll = [select Id, Docket__r.Indictment__c,docket_indictment__c,
      Docket__r.Name, Docket__c, Contact__c, Case_Type__c,Supervised_by_SRP__c  
      From Case_Relationship__c  where contact__c =: clientId 
      order by Case_Type__c]; 

   for (Case_Relationship__c cr : lstCasesAll){
     if (cr.Supervised_by_SRP__c  == true || cr.Case_Type__c == 'Intake Case' )
        dItems.add(new SelectOption(cr.docket__c,cr.docket_indictment__c));
     allCases.add(cr.docket__c);
   }
   docketItems = dItems;
   mapCaseInfo = new Map<Id, Case_Information__c>
     ([select id, indictment__c,name,part__c, Defense_Attorney_Law_Guardian__c,
      Arrest_Date__c from Case_Information__c where id in: allCases]);
  } 
  
  }