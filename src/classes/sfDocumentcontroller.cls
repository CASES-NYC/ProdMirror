public with sharing class sfDocumentcontroller {
 //  public String clientPassed   = System.currentPageReference().getParameters().get('selectedClient');    
   public String reportPassed   = System.currentPageReference().getParameters().get('selectedReport');    
   public String doctype = System.currentPagereference().getParameters().get('passDoc');  
   public String notestype = System.currentPagereference().getParameters().get('passNoteType');  
   public String notesPassed = System.currentPagereference().getParameters().get('passNoteId');  
   public String fromMailPassed = System.currentPagereference().getParameters().get('fromMail');  
  

  public sfDocumentcontroller(){
    ID userId = userInfo.getUserId();
    User u = [select Sign_court_Report__c,firstname, lastname from user where id =: userId];
      canSign = u.Sign_court_Report__c;
   userName = u.FirstName.left(1) + u.lastname.left(1);   
   userFullName = u.FirstName + ' ' + u.lastname;   
   Id userProfId = userInfo.getProfileId();
    Profile p = [Select name from Profile where id =: userProfId limit 1];
           if (p.Name == 'System Administrator')
               sfAdmin = true;  
           if (p.name == 'CEP - Court Report Writers 2' || p.name == 'CEP - Court Services Staff'
               || p.name == 'CEP - Court Services Supervisor')    
               CRWuser = true; 
           if (p.name == 'CEP - Court Services Staff' || p.name == 'CEP - Court Services Supervisor' )    
               CRuser = true;
           if (p.name == 'CEP - Case Coordinator Staff')    
              CMuser = true;
    // test
     //  sfAdmin = false;
   //    CRWuser = true;     
              
    generateClientsReports();
  }
  public List<notesList> ClientNotesToShow{get;set;}
   public String getdocType(){
       return docType;}
    public void setdocType(String docType){
        this.docType = docType;}
 
   public reportQuery rq = new reportQuery();
  
   public string userFullName{get;set;}
   public string userName{get;set;}
   public string reportId{get;set;}
   public boolean isedit{get;set;}
   public boolean iseditnotes{get;set;}
   public string contactPassed{get;set;}
   public string courtName{get;set;}
   public utilityIds util = new utilityIds();  
   public string repstage{get;set;}
   public boolean deleted{get;set;}
   public string docketId{get;set;}
   public string docket_ind{get;set;}   
   public date exit_date{get;set;}
   public date prev_rep_date{get;set;}
   public date next_rep_date{get;set;}
   public string gender{get;set;}
   public string approvalStatus{get;set;}


   public string status{get;set;}
   public string prevReports{get;set;}
   public string docDate{get;set;}
   public string caseJudge{get;set;}
   public string Indictment{get;set;}
   public string Docket{get;set;}
   public string clientName{get;set;}
   public string LetterDescr{get;set;}
   public string currentStatus{get;set;}
   public string boro{get;set;}
   public string CourtDate{get;set;}
   public string IntakeDate{get;set;}
   public string intakeboro{get;set;}

   public string dexit{get;set;}
   public string exitProjected{get;set;}
   public string exittype{get;set;}
   public string exitreason{get;set;}

   public string IntakeStatus{get;set;}
   public string Charges{get;set;}
   public string ReportType{get;set;}
   public string RepType{get;set;}
   public string LetterType{get;set;}
   public string ReportColor{get;set;}
   public string aka{get;set;}

   public string CaseCoordinator{get;set;}
   public string TeamLeader{get;set;}
   public string courtRep{get;set;}
   public string pc_id{get;set;} 
   public string signedby{get;set;}   
   public string assigned{get;set;}
   public string assignedId{get;set;}



   public string CaseCoordinatorId{get;set;}
   public string courtRepID{get;set;}
    
   public String getnotesPassed(){
       return notesPassed;}
    public void setnotesPassed(String notesPassed){
        this.notesPassed = notesPassed;}

   public string fromMailPassed(){
       return fromMailPassed;}
    public void setfromMailPassed(String fromMailPassed){
        this.fromMailPassed = fromMailPassed;}


   public String getnotestype(){
       return notestype;}
    public void setnotestype(String notestype){
        this.notestype = notestype;}

   public String commentsPassed{get;set;}
 
   public String getreportPassed(){
       return reportPassed;}
    public void setreportPassed(String reportPassed){
        this.reportPassed = reportPassed;}
   public String cmdCaption{get;set;}

 public String imageBmp{get;set;} 
// public String getimageBmp(){
//        return imageBmp;}
//    public void setimageBmp(String imageBmp){
 //       this.imageBmp = imageBmp;}        

  public String pdfTextNarrative{get;set;}
  String narrative;   
 public String getnarrative(){
        return narrative;}
    public void setnarrative(String narrative){
        this.narrative = narrative;}

// public string reportEditedWhen{get;set;} 

 String reportEditedWhen;   
 public String getreportEditedWhen(){
        return reportEditedWhen;}
    public void setreportEditedWhen(String reportEditedWhen){
        this.reportEditedWhen = reportEditedWhen;}
        
 String notes;   
 public String getnotes(){
        return notes;}
    public void setnotes(String notes){
        this.notes = notes;}

 String Question;   
 public String getQuestion(){
        return Question;}
    public void setQuestion(String Question){
        this.Question = Question;}

 String Answer;   
 public String getAnswer(){
        return Answer;}
    public void setAnswer(String Answer){
        this.Answer = Answer;}

 public boolean canSign{get;set;}    
 public boolean CRWuser{get;set;} 
 public boolean SFadmin{get;set;} 
 public boolean CRuser{get;set;}
 public boolean CMuser{get;set;} 
 boolean showCancel;    
 public boolean getshowCancel(){
        return showCancel;}
    public void setshowCancel(boolean cmdCaption1){
        this.showCancel = showCancel;}

 boolean showCancelBMP;  
 public boolean getshowCancelBMP(){
        return showCancelBMP;}
  
   public class repList{
    public string ctdate{get;set;}
 //   public string ctid{get;set;}
    public string repstage{get;set;}
    public string repid{get;set;}
    public boolean deleted{get;set;}
    public string repcaption{get;set;}
    public string approvalStatus{get;set;}
  }

   public string selectedReportId{get;set;}   
   
   public List<RepList> ClientRepsToShow{get;set;}
   boolean openDate;         

   public string textColor{get;set;}
 
   public void changeCaption(){
          System.Debug('\n\n XXX cmdCaption: ' + cmdCaption);
        if (cmdCaption == 'Edit'){
          isedit = true;
            textColor = 'black';
            cmdCaption = 'Save';
            showCancelBMP = true;}
        else{
            if (cmdCaption == 'Save'){
              cmdCaption = 'Edit';
              imageBmp = '$Resource.Edit_bmp';
              textColor = 'blue';       
              isedit = false;
              SF_CRW__c nar = new SF_CRW__c(id=selectedReportId);
              nar.narrative__c = narrative;
              nar.documentDate__c = date.today();
              nar.report_edited_time__c = datetime.now();
              nar.assignTo__c = userFullName;
              update nar;
              showCancelBMP = false;}  
        }   
     }  
      public void cancelChanges(){
              cmdCaption = 'Edit';              
             isedit = false;              
              textColor = 'blue'; 
              SF_CRW__c nar = [select narrative__c,report_edited_time__c from SF_CRW__c
                where id =: SelectedReportId];
              narrative = nar.narrative__c;
              if (nar.report_edited_time__c != null)
                 reportEditedWhen = nar.report_edited_time__c.format();
            System.Debug('\n\n XXX narrative: ' + narrative);              
              showCancelBMP = false;
     }
   
 //   public String val{get;set;}
   // public string enteredtext{get;set;}
  
    //   Review stage
     public List<SelectOption> getReviewItems(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('Review', 'Review'));
       options.add(new SelectOption('to Approve', 'to Approve'));
       options.add(new SelectOption('Back to Edit', 'Back to Edit'));
       return options;}

    //   Approve stage
     public List<SelectOption> getToApprovedItems(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('to Approve', 'to Approve'));
       options.add(new SelectOption('Review', 'Review'));
       options.add(new SelectOption('Back to Edit', 'Back to Edit'));
       return options;}

    //   Signed stage
    public List<SelectOption> getSignedItems(){
      List<SelectOption> options = new List<SelectOption>(); 
       options.add(new SelectOption('Final', 'Final'));
       options.add(new SelectOption('Back to Edit', 'Back to Edit'));
       options.add(new SelectOption('Review', 'Review'));       
       return options;}
  
    //   Editing stage
    public List<SelectOption> getEditItems(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('Editing', 'Editing'));
       options.add(new SelectOption('Review', 'Review'));
     return options;}

    public string stagePassed{get;set;}
    public void changeStages(){
        string clientId, approvedName,approvedBy; 
        
        SF_CRW__c rep = [Select repStage__c, courtdate__c, contact__c, assignTo__c,CR_Approved_Name__c,  CM_Approved_Name__c,
        approval_Status__c  from SF_CRW__c where id =: reportid limit 1];
           if (stagePassed.contains('approved')){   
              if (stagePassed == 'CR approved'){
                 if (rep.approval_Status__c != 'CM approved')
                    approvedBy = 'CR approved'; 
                 else
                    approvedBy = 'CM-CR approved'; 
                    rep.CR_Approved_Name__c = userFullName;}
              else{
                 if (rep.approval_Status__c != 'CR approved')
                    approvedBy = 'CM approved';              
                 else
                    approvedBy = 'CM-CR approved'; 
                 rep.CM_Approved_Name__c = userFullName;}
             rep.approval_Status__c = approvedBy; 
           }
          else{
           if (stagePassed == 'Signed'){
              rep.signedby__c = userInfo.getFirstName();
              rep.repStage__c = 'Final';} 
           else{
             rep.approval_Status__c = '';
           if (stagePassed == 'Back to Edit')
              rep.repStage__c = 'Editing'; 
           else
              rep.repStage__c = stagePassed;}}
           update rep;
           generateClientsReports();
        }
  
  //     Generate report 
    public void generateClientsReports(){
      string shortboro = '';
       textColor = 'blue';
        string chargetype,ctdate,accountId;
        cmdCaption = 'Edit';
        imageBMP = '$Resource.Edit_bmp';
        Id caseId;
        RepList oneRep = new repList();
        RepList oneRepDel = new repList();
        date repDate;
        Set<Id> RepIds = new Set<Id>();
        List<repList> ClientReports = new List<repList>();
        List<repList> ClientReportsDeleted = new List<repList>();     
        string firstrep;
        SF_CRW__c docs = [Select courtdate__c,contact__c,id,narrative__c,Deleted_in_CRW__c,
          approval_Status__c,assignTo__c, report_edited_time__c,
          documentdate__c from SF_CRW__c where id =: reportPassed];
             string clientid = docs.contact__c;
             repDate = docs.courtDate__c;
             contactPassed = clientId;
             assigned = docs.AssignTo__c;
             if (docs.report_edited_time__c != null)
                 reportEditedWhen = docs.report_edited_time__c.format();  
             else        
                reportEditedWhen = '';
         if (docs.approval_status__c != null)
                approvalStatus = docs.approval_status__c.trim();
     
        Contact c = [select name,Intake_Date__c, Intake_Case__c, Case_Status_at_Intake__c,accountId,
        aka_1__c,aka_2__c, aka_3__c,Age_at_Intake__c, Date_of_Birth__c,HomePhone,P_C_ID__c,
        Apt_No__c, Building_No__c,City__c, State__c, Street__c, Zip__c, Case_Coordinator__c,
        Team_Leader__c,Court_Rep__c,Intake_Court_Formula__c from contact where id =: clientid];
        accountId = c.AccountId;
        caseid = c.Intake_Case__c; 
        chargetype = 'Plea/ Finding Charges';
        Map<Id, Contact> mapContact = rq.contactQueryByStringId(clientid);  
        intakeboro = mapcontact.get(clientid).Borough_of_Intake_Formula__c;
                
        docketId = mapcontact.get(clientid).intake_case__c;
         Map<Id, Case_Information__c> mapCase = rq.caseQuery(docketId);   
     //   string convCharges = '';
     //   if (caseid != null)
           string convCharges =   rq.Charges(caseid, chargetype);    
        courtname =  c.Intake_Court_Formula__c ;
        docket_ind = mapCase.get(docketId).name;
        if (mapCase.get(docketId).indictment__c != null)
           docket_ind = mapCase.get(docketId).name+ '/'  +  mapCase.get(docketId).indictment__c;
         dexit = '__/__/____';
        if (mapcontact.get(clientid).Current_Exit_Date__c <> null){
          dexit = mapcontact.get(clientid).Current_Exit_Date__c.format();
          exit_date = mapcontact.get(clientid).Current_Exit_Date__c;          
       }   
       
       gender = mapcontact.get(clientid).Gender_CC__c;
       
       exitprojected = '__/__/____';
       if (mapcontact.get(clientid).Current_Projected_Exit_Date__c <> null)
          exitprojected = mapcontact.get(clientid).Current_Projected_Exit_Date__c.format();
        exittype = mapcontact.get(clientid).Current_Exit_Type__c;
        exitreason = mapcontact.get(clientid).Exit_Reason__c;

       status = stringStatus(exittype);


       if (convCharges != '')
        charges = convCharges;
       else{    
         chargetype = 'Indictment Charges';
         string indCharges =   rq.Charges(caseid, chargetype);
         if (indCharges != '')    
                    charges = indCharges;
         else{ 
             chargetype = 'Family Court Arraignment Charges';
             string familyArraign =  rq.Charges(caseid, chargetype)  ; 
             chargetype = 'Criminal Court Arraignment Charges';
             string CriminalArraign =  rq.Charges(caseid, chargetype)  ;
             if (CriminalArraign != '')
                charges = CriminalArraign;
             else 
                charges = familyArraign;
         }}  
         prevReports = '';
         List<Case_Information__c> lstCases = [select name, Indictment__c,id,Arrest_Date__c,
             Current_Case_Status__c,Judge__c,Borough__c from Case_Information__c 
             where client_account__c =: accountId];
      for (SF_CRW__c d : [Select courtdate__c,ReportType__c,document__c,Deleted_in_CRW__c,repStage__c,approval_Status__c,
           id,signedby__c,contact__c,narrative__c,clientname__c,report_edited_time__c from SF_CRW__c
            where contact__c =: clientid order by courtdate__c desc ]){
        oneRep = new repList();
        oneRepDel = new repList();

        if (d.id == reportPassed){
           CourtDate = d.CourtDate__c.format();
           ReportType = d.ReportType__c.toUpperCase() + ' ' + d.document__c.toUpperCase();
           Reptype = d.document__c;
           LetterType = d.ReportType__c;
           if (ReportType.substring(0,1) == 'D'){
               ReportColor = 'red';
               LetterDescr = d.clientname__c + '\'s discharge from our program.';}
           else{      
           if (ReportType.substring(0,1) == 'G'){
              LetterDescr = d.clientname__c + '\'s successful completion of our program.';   
              ReportColor = 'green';}
              else{
              if (ReportType.substring(0,1) == 'T'){
                 LetterDescr = d.clientname__c + '\'s transfer from our program.';   
                 ReportColor = 'blue';                      }
              else 
                ReportColor = 'blue';} }
                repstage = d.repStage__c;
                deleted = d.Deleted_in_CRW__c;
                signedby = d.SignedBy__c;
                reportid = d.id;
             }   
      
            oneRep.repcaption = d.document__c.substring(0,1) + ' ' + d.ReportType__c.substring(0,1);
            oneRep.ctdate = d.CourtDate__c.format();
            oneRep.repstage = d.repStage__c;
            oneRep.deleted = d.Deleted_in_CRW__c;
            oneRep.repid = d.id;
            ClientReports.add(oneRep);
           if (d.CourtDate__c < repDate && d.Document__c == 'Report' && d.repstage__c == 'Final'){
               if (prevReports == '')
                  prevReports = d.CourtDate__c.format();
              else 
                 prevReports = prevReports + ', ' + d.CourtDate__c.format();              
           }
           if (docs.Deleted_in_CRW__c == true){
                narrative = 'DELETED';
                deleted = true;
           }
           else   
             narrative = docs.Narrative__c;
           if (docs.Narrative__c != null)  
               pdfTextNarrative = (docs.Narrative__c).replaceAll('\n','<br/>');
           
           if (docs.report_edited_time__c != null)
               reportEditedWhen = docs.report_edited_time__c.format();
           if (docs.documentDate__c != null)
              docDate = docs.documentDate__c.format();
           else 
              docDate = docs.courtdate__c.format();
           selectedReportId = docs.id;
       ClientRepsToShow = ClientReports;
       Id cmid,tleader,cr;
            intakeDate = c.Intake_Date__c.format();
            intakeStatus = c.Case_Status_at_Intake__c;
            clientname = c.name;
            pc_id = c.P_C_ID__c;
             CaseCoordinatorId = c.case_coordinator__c;
             tleader = c.Team_Leader__c;
             CaseCoordinator = rq.userNamesById(CaseCoordinatorId); 
             teamLeader = rq.userNamesById(tleader); 
             courtRepID = c.Court_Rep__c;
             courtrep =  rq.userNamesById(courtRepID);             
            }
         for (Case_Information__c ci : lstCases){    
             if (ci.id == caseid){
                 if (ci.judge__c != null)
                    caseJudge = rq.mapNames(ci.judge__c);
                if (ci.Indictment__c !=null)    
                   indictment = ci.Indictment__c;
                else   
                   indictment = '';
               docket = ci.Name;
               currentStatus = ci.Current_Case_Status__c;
               
               if (ci.Borough__c != null)
                   boro = county(ci.Borough__c);
                break;}
        }
         allCases(lstCases,clientId,repDate); 
          ClientNotesToShow = findcomments(); 
        }
    
       public pageReference pageClose(){
          String baseURL;
          if (fromMailPassed == '1')
             baseURL = URL.getSalesforceBaseUrl().toExternalForm() + 
            '/apex/sfCRWpage';
           else
            baseUrl = 'javascript:window.close()';
         // Pagereference pg = new PageReference('javascript:window.close()');
          Pagereference pg = new PageReference(baseUrl);
          return pg;}
 
       public void openReport(){
          generateClientsReports();}
          
    public void cancelNotesChanges(){
              cmdCaption = 'Edit';              
             isedit = false;              
              textColor = 'blue'; 
              SF_CRW__c nar = [select narrative__c from SF_CRW__c
                where id =: SelectedReportId];
              narrative = nar.narrative__c;
              showCancelBMP = false;}      

    public class otherList{
    public string Docket{get;set;}
    public string ArrestDate{get;set;}
    public string ArrestCharges{get;set;}
    public string convCharges{get;set;}
    public string ArrestStatus{get;set;}
    public string LastCourtDate{get;set;}
    public string NextCourtDate{get;set;}
    public string ArrestCourtPart{get;set;}
    public string NextCourtPart{get;set;}
    public string ArrestCounty{get;set;}
    public string CaseType{get;set;}
    public string Indictment{get;set;}
    public string Status{get;set;}    
    public string Action{get;set;}   
    public string repDate{get;set;}    
  } 
   
   public List<OtherList> LegalInfoToShow{get;set;}
  
   public void allCases(List<Case_Information__c> lstCases, string clientId,date repDate){
      otherList oneLegal = new otherList();
      List<OtherList> LegalInfo = new List<OtherList>(); 
      
      List<Event> lstEvent = [select activityDate,Part__c,Outcome__c,action__c,
            whoid, whatid from event where whoid =: clientid and subject =: 'Court Date' order by activitydate desc];
     string NextCourtPart,ctNext, ctLast;
     NextCourtPart = '';
     ctNext = '';
     ctLast = '';
  

     String[] casesToprint = new List<String>{'Intake Case','In-Program'};      

     List<Case_Relationship__c> lstCasesOthers = [select Id, Docket__r.Indictment__c, 
                             Docket__r.Name, Docket__c, Contact__c, Case_Type__c 
                             From Case_Relationship__c  where contact__c =: clientId and
                             Case_Type__c in: casesToprint order by Case_Type__c];
     string caseid,action,status;  
     action = '';           
        boolean noChecknext, noCheckLast;
        integer a;
        if (lstCasesOthers.Size() == 0 )
           return;    
     for (integer i = 0; i < lstCasesOthers.Size(); i++){
       caseid = lstCasesOthers[i].docket__c;
       for (integer k = 0; k < lstCases.Size(); k++){
         action = ''; 
         status = '';
          if (caseid == lstCases[k].id){
              oneLegal = new otherList();
              oneLegal.repDate = repDate.format();
              oneLegal.CaseType = lstCasesOthers[i].Case_Type__c;
              oneLegal.NextCourtDate = '';
           if (lstCases[k].Borough__c != null)
                  oneLegal.ArrestCounty = county(lstCases[k].Borough__c);
           if (lstCases[k].Arrest_Date__c != null)
                 oneLegal.ArrestDate = lstCases[k].Arrest_Date__c.format();
              else
                 oneLegal.ArrestDate = '  /  /    ';
              if (lstCases[k].Indictment__c !=null)    
                 oneLegal.Indictment = lstCases[k].Indictment__c;
              else   
              oneLegal.indictment = '';
              oneLegal.docket = lstCases[k].Name;
              status =  lstCases[k].Current_Case_Status__c;
              System.Debug('\n\n XXX oneLegal: ' + oneLegal);
              oneLegal.ArrestCharges = rq.Charges(caseid, 'Arrest Charges');                 
              oneLegal.convCharges = rq.Charges(caseid, 'Indictment Charges');    
              for (integer e = 0; e < lstEvent.Size(); e++){
                  if (lstEvent[e].whatid == caseid){
                     if (lstEvent[e].Action__c != null)
                  action = lstEvent[e].Action__c;
                  oneLegal.ArrestCourtPart = lstEvent[e].Part__c;
                   oneLegal.LastCourtDate = lastcourt(lstEvent,caseid,clientId,repdate);
    
               if (lstEvent[e].ActivityDate == repdate){
                oneLegal.NextCourtDate = lstEvent[e].ActivityDate.format(); 
                oneLegal.NextCourtPart = lstEvent[e].Part__c;    
                    noChecknext = true;}
             }}
                if (action.contains('Parole') || action.contains('W') || action.contains('ACD') || 
                  action.contains('Re') || action.contains('No') || action.contains('Case S'))
                    oneLegal.Status = action;
                else
                    oneLegal.Status = status;
                oneLegal.Action = oneLegal.LastCourtDate + ' ' + oneLegal.ArrestCourtPart ;
                 if (oneLegal.NextCourtDate == '')
                    oneLegal.Action += ' Action: ' + action + ' ' + repDate.format();
                   else  
                    oneLegal.Action += ' - Adjourned to ' +  oneLegal.NextCourtDate + ' - Court Part: '  + oneLegal.NextCourtPart;
                 LegalInfo.add(oneLegal);
              break;}
          }}
        LegalInfoToShow = LegalInfo;
     }
       public string county(string boro){ 
            string b;
            if (boro  == 'Brooklyn')
                b = 'Kings County';
                else
                  if (boro.left(1) == 'M')
                     b = 'New York County';
                 else
                    b =  boro + ' County';    
         return b;                   
       }      
      public string lastcourt(List<Event> lstEvents,string caseid,string cid, date repdate){
        string retVal = '';
        for (integer v = 0; v < lstEvents.Size(); v++){
          if (lstEvents[v].whatid == caseid && lstEvents[v].whoid == cid && lstEvents[v].ActivityDate < repdate){
              retVal = lstEvents[v].ActivityDate.format();     
                break;
       }}        
        return retVal;
      }                          

     public string nextcourt(List<Event> lstEvent,string caseid,date repdate){
        string retVal = '';
        for (integer v = 0; v < lstEvent.size(); v++){
          if (lstEvent[v].whatid == caseid && lstEvent[v].ActivityDate < repdate){
              retVal = lstEvent[v - 2].ActivityDate.format();     
                break;
       }}        
        return retVal;
      }                          

     public List<notesList> Comments{get;set;}
  
    public class notesList{
     public string ReportId{get;set;}
     public string NoteId{get;set;}
     public string Question{get;set;}
     public string Respond{get;set;}
     public string sentTo{get;set;}
     public string status{get;set;}
     public string respondColor{get;set;}
     public string commentsUser{get;set;}
   }
  
     public string  inputNotes{get;set;}  

     public List<notesList> findComments(){
     notesList oneRecord = new notesList();
     List<notesList> repnotes  = new List<notesList>();
     
      List<SF_CRW_notes__c> lstnotes = [select Question__c, Respond__c,id,status__c,Status_Set_by__c
           from SF_CRW_notes__c where LUREPORTS__C =: reportPassed  order by sortorder1__c];
       for (integer n = 0; n < lstnotes.Size(); n++){
          oneRecord = new notesList();
           oneRecord.commentsUser = lstnotes[n].Status_Set_by__c;
           oneRecord.Question = lstnotes[n].Question__c;
           oneRecord.status = lstnotes[n].Status__c;
           oneRecord.Respond = lstnotes[n].Respond__c;
           if (lstnotes[n].Respond__c == '' || lstnotes[n].Respond__c == null)
              oneRecord.respondColor = 'red';
           else      
              oneRecord.respondColor = 'black';
            oneRecord.NoteId = lstnotes[n].id;
            repnotes.add(oneRecord);}
      return repnotes;}
 
       public String notestage{get;set;}
     
      public List<SelectOption> getNotesStatus(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('Open', 'Open'));
       options.add(new SelectOption('Response', 'Response'));
       options.add(new SelectOption('Re-Open', 'Re-Open'));
       options.add(new SelectOption('Closed', 'Closed'));
  //     options.add(new SelectOption('Approved', 'Approved'));
       return options;}
     
  /*
      public string respondStage{get;set;}
     
      public List<SelectOption> getRespondItems(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('Response/Edit', 'Response/Edit'));
       options.add(new SelectOption('CM Report Approved', 'CM Report Approved'));
       options.add(new SelectOption('CR Report Approved', 'CR Report Approved'));
       return options;}


      public string respondStage{get;set;}
     
      public string respondStageCM{get;set;}

      public List<SelectOption> getRespondItemsCM(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('Response/Edit', 'Response/Edit'));
       options.add(new SelectOption('CM Report Approved', 'CM Report Approved'));
       options.add(new SelectOption('CR Report Approved', 'CR Report Approved'));
       return options;}

      public string respondStage{get;set;}
     
      public List<SelectOption> getRespondItemsCR(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('Response/Edit', 'Response/Edit'));
       options.add(new SelectOption('CM Report Approved', 'CM Report Approved'));
       options.add(new SelectOption('CR Report Approved', 'CR Report Approved'));
       return options;}

*/


     public boolean displayPopup {get; set;}
  
     public void closePopup() {displayPopup = false;
     iseditnotes = false;
     ClientNotesToShow = findcomments();
     }
     public void showPopup() {
         inputNotes = '';
      displayPopup = true;
      iseditnotes = true;}
        
     public void saveNotes(){
       if (inputNotes != ''){
           string info = userInfo.getFirstName() + ' - ' + datetime.now().format();
        if (notestype == 'N'){
           SF_CRW_notes__c note = new SF_CRW_notes__c();
          note.luReports__c = selectedReportId;
          note.Respond__c = '' ;
          note.Contact__c = contactPassed;
          note.NotesCode__c = notescode('Comments','');
          note.Question__c = note.NotesCode__c + ' ' + info + '\r\n' + inputNotes;
           note.Status_Set_by__c = userName;
          insert note;            
       }else{
         SF_CRW_notes__c  note = [select Question__c, Respond__c,id,NotesCode__c
          from SF_CRW_notes__c  where id =: notesPassed ];
          string ncode;
           ncode = notescode('Respond',note.NotesCode__c);
           if (note.Respond__c != '' && note.Respond__c != null)        
              note.Respond__c =  note.Respond__c + '\r\n' + '---------------' + '\r\n' +  
              ncode +   ' ' + info + '\r\n' + '\r\n'  + inputNotes;
           else   
            note.Respond__c = ncode +  ' ' + info + '\r\n' +  inputNotes; 
            note.NotesCode__c = ncode;  
            note.Status__c = 'Response'; 
            note.Status_Set_by__c = userName;
             update note;
       }}
       closePopUp();
     }

     public string statusPassed{get;set;}  
     public string noteAction{get;set;}
       
     public void executeNoteAction(){
        boolean lupdate;
       SF_CRW_notes__c  note = [select Question__c, Respond__c,id, status__c,Status_Set_by__c
          from SF_CRW_notes__c  where id =: notesPassed];
       if (noteAction == 'respond'){
            if (statusPassed.contains('Approved')){
              note.status__c = 'Approved';
              lupdate = true;}
       }else{
            if (note.status__c != statusPassed){
                 note.status__c = statusPassed;
                  lupdate = true;}}
        if (lupdate = true){
           note.Status_Set_by__c = userName;
           update note;}  
     }
    
    public string notescode(string s,string ncode){
       string repid = reportPassed;  
       System.Debug('\n\n  XXX repid: ' + repid);
      List<SF_CRW_notes__c> lstNotes = [select notescode__c from  SF_CRW_notes__c where 
        lureports__c =: repid order by notescode__c desc limit 1];
      string comm,c1,notecode,resp;
        integer len,c;
        String[] codes;
        if (lstNotes.Size() == 0)
            return 'C1';
       if  (lstNotes[0].notescode__c == null || lstNotes[0].notescode__c == '')
           return 'C1';
       else{   
       if (s == 'Comments'){
          comm = lstNotes[0].notescode__c;
          if (lstNotes[0].notescode__c.contains('-') == true){
            codes = comm.split('-');  
           comm = codes[0];}   
           len = comm.length();
           c1 = comm.substring(1,Len);
         c = integer.valueOf(comm.substring(1,len)) + 1;
            notecode = 'C' + string.valueOf(c);}
     else{
       if (ncode == '' || ncode == null)
                    return ncode + '-R1';
        if (ncode.contains('-') == false)
           return ncode + '-R1';
       else{
           codes = ncode.split('-');
          comm = codes[0];
         resp = codes[1];
            len = resp.length();
            c1 = resp.substring(1,Len);
            c = integer.valueOf(resp.substring(1,len)) + 1;
            resp  = 'R' + string.valueOf(c);
            notecode = comm + '-' + resp;}}}
    return notecode;}
    
    public string del_call{get;set;}
 
    public boolean displayWarning {get; set;} 
    public void showWarning() {
           System.Debug('\n\n XXX in show warning : ');
      displayWarning = true;}    
    public void hideWarning() {
      displayWarning = false;}    
      
    public void delete_recallReport(){
        System.Debug('\n\n XXX selectedReportId: ' + selectedReportId);
      string s = del_call;
        SF_CRW__c nar = new SF_CRW__c(id=selectedReportId);
        if (s == 'delete'){
           nar.Deleted_in_CRW__c = true;
           }
        else{
           nar.Deleted_in_CRW__c = false;
           }
        update nar;
        displayWarning = false;
        generateClientsReports();
        }  
      public pagereference doNothing(){
        return null;}    
        
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
    
        public void createReportNarrative(){
        SF_CRW__c c = [Select repStage__c,id, courtdate__c, Document__c,contact__c,
        narrative__c, actionid__c, assignTo__c,Deleted_in_CRW__c from SF_CRW__c where id =: reportid];
        c.repStage__c = 'Editing';
        c.assignTo__c = userFullName;
        c.report_edited_time__c = datetime.now();
        if (c.document__c == 'Report')
          c.narrative__c = 'Report created';
       else {
       // if (c.document__c == 'Letter'){
           datetime dtime;  
           string exit_type = exittype.substring(0,1);
           //////   Letters          
           string pgrph_1,pgrph_2,pgrph_3,salut,add,s,sdate,sdate1;
           pgrph_2 = '';
           pgrph_3 = '';
           if (gender != null){
           if (gender.substring(0,1) == 'M'){
               salut = 'Mr.' + ClientName;
               add = 'His ';}
           else{
              salut = 'Ms.' + ClientName;
              add = 'Her ';}   
           }  
   
           if (exit_type == 'T'){
              pgrph_1 = 'We have transferred ' +  salut  +  ' from our program to .. on .. ';   
           }
           else{
             if (exit_type == 'S'){
             sdate = dexit;
              pgrph_1 =  salut + ' successfully completed our program on ' + sdate + '.' ;  
              pgrph_2 = '';
              if ((prev_rep_date == null && next_rep_date == null) 
                 || next_rep_date.daysBetween(exit_date) > 8){
                 pgrph_3 = 'You will receive a Graduation Report detailing ' + salut + '\'s ' + 
                  'experience in our program within 8 consecutive days.';}
              else{       
                  if (prev_rep_date <> null && prev_rep_date.daysBetween(exit_date) <= 14 ){
                    sdate = prev_rep_date.format();
                     pgrph_3 = 'A report detailing ' + salut + '\'s ' + 
                     'experience in our program was submitted to the Court on his last court date of ' + sdate + '.';}
                 else{
                    if (next_rep_date.daysBetween(exit_date) <= 8 ){
                       sdate = next_rep_date.format();                    
                      pgrph_3 = 'You will receive a Graduation Report detailing ' + salut + '\'s ' + 
                       'experience in our program on the next Court Date, ' + sdate + '.';
                    }}}             
           }
           else{
               string lastctdate = '';
              string nextctdate = ''; 
               if (prev_rep_date <> null){
                 sdate = prev_rep_date.format();
                  lastctdate = add + 'last court date was ' + sdate + '.';}   
               if (next_rep_date <> null){
             sdate = next_rep_date.format();
                  nextctdate = add + 'next scheduled court appearance is ' + sdate + '.';   
                }
              pgrph_1 = salut + ' has been discharged from our program due to failure to comply with our program requirements.';  
           sdate = dexit;
              pgrph_2 = 'The effective date of '+ salut + 
              ' discharge is ' + sdate + '. ' + 
              lastctdate + ' ' + nextctdate;
              pgrph_3 = '';}}      
           c.narrative__c =  pgrph_1 + '\n' + pgrph_2 + '\n' + pgrph_3 + '\n' + '\n' + 'System Generated';  
        }    
   //     c.AssignTo__c = userFullName;
       update c;
       generateClientsReports();          
       }
    
      public void sendEmail(){
          SF_CRW_notes__c  note = [select Question__c, Respond__c,id,NotesCode__c,Status_Set_by__c,luReports__c
          from SF_CRW_notes__c  where id =: notesPassed];
 
        string s = note.Question__c;
        Integer r = s.indexOf(' AM');
        if (r ==- 1)
            r = s.indexOf(' PM');
        string s1; 
        if (r != -1)  
           s1 = s.substring(0,r) ;
       else 
          s1 = s.substring(0,10) + ' - migrated notes';
       String baseURL = URL.getSalesforceBaseUrl().toExternalForm() + 
       '/apex/sfCRWdocument?selectedReport='+reportPassed+'&fromMail='+'1';
       string instr =  'Please click on link above to review report or add comments.'; 
        string comment = baseURL  +  '<br/>' + '<br/>' + instr + '<br/>' + '<br/>' + s1; 
         List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
         List<String> sendTo = new List<String>();
         sendTo.add('lzykova@cases.org');

        Profile profIs = [Select name,id from Profile where name = 'CEP - Court Report Writers 2'];
        String pIs = profIs.id; 
         List<User> lstCRW = [select email,name from user where profileid =: pIs or name =: assigned];
      for (integer w = 0; w < lstCRW.Size(); w++){
        if (lstCRW[w].name != assigned && lstCRW[w].email.contains('example.com') == false
          && lstCRW[w].email.contains('lzykova@cases.org') == false)
            sendTo.add(lstCRW[w].email);
      }
         List<User> lstMail = [Select email,name from User where id =: CaseCoordinatorId 
         or id =: courtRepID or name =: assigned];
         for (integer i = 0; i < lstMail.Size();i++){
            if (lstMail[i].email.contains('example.com') == false  && lstMail[i].email.contains('lzykova@cases.org') == false)
              sendTo.add(lstMail[i].email);
          }
     string subject = reporttype + ' ' + courtDate +  ' for ' +  pc_id;    
     Messaging.SingleEmailMessage mail = 
     new Messaging.SingleEmailMessage();
     mail.setSubject(subject);
     mail.setHtmlBody(comment);
     mail.setToAddresses(sendTo);
     
 //    System.Debug('\n\n XXX sendTo' + sendTo);
   //  return;
     mails.add(mail);
     Messaging.sendEmail(mails);

        
      }   
            
}