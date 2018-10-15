public class AssessmentController{ 
  public String contPassed = System.currentPagereference().getParameters().get('contactPassed'); 
  public string assessmentId = ApexPages.currentPage().getParameters().get('assmFromContact');
  public string newAssessmentCode = ApexPages.currentPage().getParameters().get('newCodePassed');
  assessmentSource asm = new assessmentSource();
  public reportQuery rq = new reportQuery(); 
  public string showBasicInfo{get;set;}
  public boolean noEdit{get;set;}
 string open4edit;
 string strMissed;
// string AccountId;
 public Event proxyObject {get; set;}

 public string address{get;set;}
 public string sIntakeDate{get;set;}
 public string ParentGuard{get;set;}
 public string Building_No{get;set;}
 public string Street{get;set;}
 public string Apt{get;set;}
 public string City{get;set;}
 public string State{get;set;}
 public string zip{get;set;}
 public string phone{get;set;}   
 public string sDob{get;set;}   
 public string rel2client{get;set;}
 public string RelationOther{get;set;}
 public string RelclientCell{get;set;}
 public string liveWith{get;set;} 
 public string moveDate{get;set;}
  public Account proxyAccount{get;set;}
  public boolean isCancel{get;set;}
  public string schoolName{get;set;}
  public boolean newAssessment{get;set;}
  public boolean showHistory{get;set;} 
  public List<SelectOption> getHistoryOption() 
      {List<SelectOption> lstTemp = new List<SelectOption>();
       lstTemp.add(new SelectOption('Hide', 'Hide assessments list'));
       lstTemp.add(new SelectOption('Show', 'Show all assessments'));
       return lstTemp;}    
  public string hideHistory{get;set;}
 // public string resultAll{get;set;}
  public boolean sfAdmin{get;set;}  
  public string courtRepName{get;set;} 
  public boolean isEdit{get;set;} 
  public boolean isNew{get;set;}
  public string pageCode{get;set;}
 
  Map<id,Contact> mapcontact = new Map<id,Contact>();
  map<ID,Contact> mapIDcontact;  
                                          // OBJECT DECLARATION 
  public BJMHS__c BJMHS{get;set;}  
  public CCM_Orientation__c CCM{get;set;}
  public CEP_BPS__c BPS{get;set;} 
  public CEP_Intake__c CEPINT{get;set;}
  public CEP_ICD__c ICD{get;set;}
  public CaseCoordinator__c  CC{get;set;}   
  public CourtRepAssm__c CR{get;set;}
  public CRAFFT__c CRAFFT{get;set;} 
  public EducationAssm__c Educ{get;set;}
  public Employment_Education_Survey__c Survey{get;set;}
  public HW__c HW{get;set;}
  public Health_Screen__c HS{get;set;}
    // Home_Visit__c
  public LifeEventsAssm__c LEC{get;set;}   
  public LSCMI__c LSCMI{get;set;}
  public LSCMI_Y__c LSCMI_Y{get;set;}   
  public LSIR__c LSIR{get;set;}
  public MHSF__c MHSF{get;set;}
  public PHQ_9__c PHQ_9{get;set;}
  public PHQ_9T__c PHQ_9T{get;set;}
  public PCLC__c PCL{get;set;}
  public Psychosocial_MH__c PSYCHO{get;set;} 
  public SRP_IntakeAssessments__c SRP{get;set;}  // use this object
  public SubstanceAbuseAssessment__c SAA{get;set;} 
  public UCLA_PTSD_DSM_V__c DSM_V{get;set;} 
  public UCLAptsd_RI__c UCLA_RI{get;set;}
  public TCUassessment__c TCU{get;set;}
  public TCU_Screen_V__c TCU_V{get;set;}  
  
// public TCU_V__c TCUV{get; set;}
  public WRNA__c WRNA{get;set;} 
  
  public string assessmentName{get;set;}
  public string assessmentDate{get;set;}
  public string createdInfo{get;set;}
  public string lastModifiedInfo{get;set;}
//  public boolean boolEdit{get;set;}
  public string PageName{get;set;}
  public string pagePassed{get;set;}
  public boolean boolNew{get;set;}    
  public boolean boolOpen{get;set;}    
  public string contactId{get;set;}
  public string contactProgram{get;set;}
 
   public string openId{get;set;}
  string userLoginId; //,contactId;
  public string contactName{get;set;}
  public string pcid{get;set;}
  public string aValue{get;set;}
//  public string newButtonValue{get;set;}
  public List<SelectOption> Items{get;set;}
  Map<string,string> mapAssCodePage = new Map<string,string>();    
  Map<string,string> mapAssCodeName = new Map<string,string>();    
    integer i = 0; 
  Map<string,string> mapShowBasic; 
  public AssessmentController()
    {        Event e = new Event();    
            proxyObject = e;
        isCancel = false;
      completed = false;
        isedit = false;
        Id userProfId = userInfo.getProfileId();
        Profile p = [Select name from Profile where id =: userProfId limit 1];
        if (p.Name == 'System Administrator')
            sfAdmin = true; 
        asmSelected = true;
        userLoginId = userInfo.getUserId();
        hideHistory = 'Show';
        contactInfo();
        generatePickListFromLookUp(); 
        selectAssessmentHistory();
        boolOpen = false;
        string formPassed;
        if (assessmentId != null)
        {  AssessmentContainer__c an = [select name, assessmentCode__c from AssessmentContainer__c where id =: assessmentId limit 1];
           pageName  = mapAssCodePage.get(an.assessmentCode__c);   
           boolNew = false;
           showPage(true);
           hideHistory ='Hide';}
        else{          
           if (newAssessmentCode != null){
             //pageName  = mapAssCodePage.get(newAssessmentCode);
             aValue = newAssessmentCode;
             showPageNew();
           }
           else{
           pageName = 'emptyPage'; 
            hideHistory ='Show';
            showEmptyPage();}
       }
     }
     Set<String> setNoEdit = new Set<String>(); 
    void generatePickListFromLookUp(){
        List<SelectOption> option = new List<SelectOption>();
        option.add(new SelectOption('','')); 
        mapAssCodePage.put(null,'emptyPage'); 
        mapShowBasic = new Map<string,string>();    
        for (assessmentList__c lu :[Select assessmentName__c,name,pageName__c,programs__c,showContactBasicInfo__c,isActive__c
               From assessmentList__c order by assessmentName__c]){
            if (lu.showContactBasicInfo__c <> null && lu.pageName__c <> null){
              if (lu.showContactBasicInfo__c == true)
                mapShowBasic.put(lu.pageName__c.trim(),'1');
              else
                mapShowBasic.put(lu.pageName__c.trim(),'0');
            }
            else
              mapShowBasic.put(lu.pageName__c,'0');
            if (lu.pageName__c <> null){  
              if (lu.isActive__c == true) {
               if (lu.programs__c == null || lu.programs__c == '')   
                 option.add(new SelectOption(lu.name,lu.assessmentName__c));
               else
                if (lu.programs__c.contains(contactProgram))
                 option.add(new SelectOption(lu.name,lu.assessmentName__c));   
               mapAssCodePage.put(lu.name,lu.pageName__c);
               mapAssCodeName.put(lu.name,lu.assessmentName__c);
               Items = option;}
            else{
              setNoEdit.add(lu.pageName__c.trim());
                         mapAssCodePage.put(lu.name,lu.pageName__c);
               mapAssCodeName.put(lu.name,lu.assessmentName__c);}}}}
  
    public class asmCreated
    {public string assId{get;set;}
     public string assCode{get;set;}       
     public string assName{get;set;} 
     public string assDate{get;set;}
     public string assBy{get;set;}
     public string source{get;set;}
     public string Program_Status{get;set;}
     public string Program{get;set;}
     public string status{get;set;}
     public boolean otherProgram{get;set;}
     public string result{get;set;}
     public string clientSFid{get;set;}
     public boolean completed{get;set;} 
     public string courtRepName{get;set;}
     public boolean flag{get;set;}
     public string recIdFromOld{get;set;}}
    
    boolean oldCompleted = true;
    List<AssessmentContainer__c> aCreated;
    public List<asmCreated> allShow{get;set;}
    void selectAssessmentHistory()
    {
    	string[] legacyId;
    	string assmNo;
        aCreated = new List<AssessmentContainer__c>([select id,Assessment_Completed_by__r.name,source__c,flag__c,Legacy_Database_Id__c,
         assmResult__c,Assessment_Date__c,Assessment_Completed_on__c,assessmentCode__c,assessmentName__c,completed__c,
        LastModifiedDate, LastModifiedById,CreatedDate,CreatedById,client__c,recIdFromassessment__c,Uploaded__c
            from AssessmentContainer__c where assessmentCode__c !=: null and client__c in: contactIds 
            order by assessmentName__c,Assessment_Date__c]);
        List<asmCreated> asmList = new List<asmCreated>();
        asmCreated oneAsm = new asmCreated();
        string program, status,assmUpload;
        if (aCreated.Size() != 0)
        {  for (AssessmentContainer__c a : aCreated)
            {   oneAsm = new asmCreated();
                Program = '';   
                oneAsm.source = '';
                oneAsm.flag = false;
                oneAsm.otherProgram = false;
                oneAsm.recIdFromOld = a.recIdFromassessment__c;
                oneAsm.assCode = a.assessmentCode__c;           
                oneAsm.assName = a.assessmentName__c;
                oneAsm.flag = a.flag__c;
                oneAsm.result = a.assmResult__c;  
                oneAsm.assBy = a.Assessment_Completed_by__r.name;
                if (a.Assessment_Date__c != null)
                    oneAsm.assDate = a.Assessment_Date__c.format();
                oneAsm.assId = a.id; 
                if (a.assessmentName__c == 'LSI R' || a.assessmentName__c == 'LS/CMI' ||
                  a.assessmentName__c == 'Y-LS/CMI'){
                  if (a.Uploaded__c == true){
                     oneAsm.source =  'Uploaded';
                     if (a.Legacy_Database_Id__c <> null){
                      legacyId = a.Legacy_Database_Id__c.split('_');
                      oneAsm.source =  'Uploaded #:' + legacyId[1];
                   }
                  } 
                   else oneAsm.source =  'Manual';}  
                oneAsm.assCode = a.assessmentCode__c;
                oneAsm.completed = a.Completed__c;
                oneAsm.Status = mapContact.get(a.client__c).Client_Status__c;
                if (mapContact.get(a.client__c).p_c_id__c <> null)
                    oneAsm.Program = (mapContact.get(a.client__c).p_c_id__c.left(3));
                if (oneAsm.Program <> contactProgram)
                    oneAsm.otherProgram = true;  
                oneAsm.clientSFid = a.Client__c;
                oneAsm.courtRepName = mapContact.get(a.client__c).court_rep__r.name;
                asmList.add(oneAsm);
            }
            allShow = asmList; }}  
 
    public boolean showNewButton{get;set;}
    public boolean asmSelected{get;set;} 

    public pageReference  showEmptyPage(){
        aValue = '';
        pageName = 'emptyPage';
        noEdit = false;
        boolnew = false;
        isEdit = false;
         hideHistory ='Show';
        return null;
    }
    public void showPageNew(){
        strMissed = '';
        asmOpen = '';
        if (aValue == '' || aValue == null)
        {   pageName = 'emptyPage';
            asmSelected = false;
                System.Debug('\n\n XXX in return in new pageName:' + pageName + ' aValue');
            return;} 
        else{isedit = true;
        asmSelected = true; 
            boolNew = true;   }
        pageCode = aValue; 
        newAssessment = true;
        boolOpen = false;
        assessmentName = mapAssCodeName.get(pageCode);
        pageName =  mapAssCodePage.get(pageCode);
        assessmentDate = date.today().format();
  //      hideHistory ='Hide';
        proxyobject.Closing_Date__c = date.today();
        BJMHS = new BJMHS__c();
        CC = new  CaseCoordinator__c();
        CCM = new CCM_Orientation__c();
        CEPINT = new CEP_Intake__c();
        Educ = new EducationAssm__c();
        Survey = new Employment_Education_Survey__c();
        HW = new HW__c();
        BPS = new CEP_BPS__c(); 
        CR = new CourtRepAssm__c();
        CRAFFT = new CRAFFT__c(); 
        HS = new Health_Screen__c();
        DSM_V = new UCLA_PTSD_DSM_V__c(); 
        ICD = new CEP_ICD__c(); 
        LEC = new LifeEventsAssm__c(); 
        LSCMI = new LSCMI__c();
        LSCMI_Y = new LSCMI_Y__c(); 
        LSIR = new LSIR__c();
        MHSF = new MHSF__c();  
        PCL = new PCLC__c(); 
        PHQ_9T = new PHQ_9T__c();
        PHQ_9 = new PHQ_9__c();
        PSYCHO = new Psychosocial_MH__c(); 
        SAA = new SubstanceAbuseAssessment__c();
        SRP = new SRP_IntakeAssessments__c();
        TCU = new TCUassessment__c();   //   old
   //     TCUV = new TCU_V__c();
        TCU_V = new TCU_Screen_V__c();     //  new
        UCLA_RI = new UCLAptsd_RI__c();
        WRNA = new WRNA__c();}  
  
    /////////////////////////  SHOW RECORD 
    string asmOpen;
    public void showPage(boolean fromContact)
    {strMissed = '*';
        newAssessment = false;
        boolOpen = false; 
        isedit = false; 
        noEdit = false;
        if (fromContact == true)
        asmOpen = System.currentPagereference().getParameters().get('assmFromContact');
        AssessmentContainer__c an = [select name, assessmentCode__c,Assessment_Date__c,CreatedDate,
            CreatedById,LastModifiedDate,LastModifiedById,recIdFromassessment__c,Assessment_Completed_on__c,
            Assessment_Completed_by__c from AssessmentContainer__c where id=: asmOpen limit 1];
        pageName  = mapAssCodePage.get(an.assessmentCode__c);
        if (SetNoEdit.contains(pageName))
           noEdit = true; 
        if (an.Assessment_Date__c != null){
            assessmentDate = an.Assessment_Date__c.format();
             proxyobject.Closing_Date__c= an.Assessment_Date__c;
        }
        pageCode = an.assessmentCode__c; 
        if (an.recIdFromassessment__c == null || an.Assessment_Completed_by__c == null){
           LastModifiedInfo = findCreatedModifiedNames(an.LastModifiedById) + ' - ' + an.LastModifiedDate.format();
           CreatedInfo =  findCreatedModifiedNames(an.CreatedById) + ' - ' + an.CreatedDate.format();}
        else{
            CreatedInfo = findCreatedModifiedNames(an.Assessment_Completed_by__c) + ' - ' + an.Assessment_Completed_on__c.format();
            LastModifiedInfo = 'migration';        }   
        assessmentName = mapAssCodeName.get(pageCode);
        if (pageName == 'BJMHS_page'){
            BJMHS = asm.createBJMHSsource(asmOpen);  
            asmOpen = BJMHS.AssessmentContainerId__c;} 
        else{
        if (pageName == 'CEPIntake_page'){ 
            CEPINT = asm.createCEPIntakeSource(asmOpen);  
            asmOpen = CEPINT.AssessmentContainerId__c;}
       else{
        if (pageName == 'CCMOrientationPage'){ 
            CCM = asm.createCCMsource(asmOpen);  
            asmOpen = CCM.AssessmentContainerId__c;}   
         else{
      if (pageName == 'EducationPage'){ 
            Educ = asm.createEdsource(asmOpen); 
            asmOpen = educ.AssessmentContainerId__c;} 
       else{            
      if (pageName == 'EmplEdSurveyPage'){ 
            survey = asm.createSurveySource(asmOpen); 
            asmOpen = survey.AssessmentContainerId__c;}     
         else{
      if (pageName == 'HBWpage'){ 
            HW = asm.createHWsource(asmOpen); 
            asmOpen = HW.AssessmentContainerId__c;}     
        else{
        if (pageName == 'TCUpage'){
            completed = completedValue(asmOpen); 
            TCU = asm.createTCUsource(asmOpen);  
            asmOpen = TCU.AssessmentContainerId__c;}
        else{ 
        if (pageName == 'SubstanceAbusepage'){ 
            SAA = asm.createSAAsource(asmOpen); 
            asmOpen = SAA.AssessmentContainerId__c;}  
        else{  
        if (pageName == 'CC_AssessmentPage'){
            CC = new  CaseCoordinator__c();
            CC = asm.createCCsource(asmOpen);  
            asmOpen = CC.AssessmentContainerId__c;}   
        else{
        if (pageName == 'CR_AssessmentPage'){
            CR = asm.createCRsource(asmOpen);  
            asmOpen = CR.AssessmentContainerId__c;}   
        else{
        if (pageName == 'LSCMIpage'){
            System.Debug('n\n XXX in create LSCMI');
            LSCMI = asm.createLSCMIsource(asmOpen);  
            asmOpen = LSCMI.AssessmentContainerId__c;}   
        else{
        if (pageName == 'SRP_Intakepage'){
            SRP = asm.createSRPsource(asmOpen);  
            asmOpen = SRP.AssessmentContainerId__c;}         
        else{
        if (pageName == 'PHQ_9TeenPage'){
            PHQ_9T = asm.createPHQ9teensource(asmOpen);
            asmOpen = PHQ_9T.AssessmentContainerId__c;}
        else{
        if (pageName == 'PHQ9page'){
            PHQ_9 = asm.createPHQ9source(asmOpen);
            asmOpen = PHQ_9.AssessmentContainerId__c;}
        else{
        if (pageName == 'LifeEventsPage'){
            LEC = asm.createLECsource(asmOpen);
            asmOpen = LEC.AssessmentContainerId__c;}
        else{
        if (pageName == 'MHSFpage'){
            MHSF = asm.createMHSFsource(asmOpen);
            asmOpen = MHSF.AssessmentContainerId__c;}
        else{
        if (pageName == 'HealthScreenPage'){
            HS = asm.createHSsource(asmOpen);
            asmOpen = HS.AssessmentContainerId__c;}
        else{
        if (pageName == 'PCLCpage'){
            PCL = asm.createPCLsource(asmOpen);
            asmOpen = PCL.AssessmentContainerId__c;}
        else{
        if (pageName == 'LSIRpage'){
            LSIR = asm.createLSIRsource(asmOpen);
            asmOpen = LSIR.AssessmentContainerId__c;}
        else{
        if (pageName == 'CEP_BPSpage'){
            BPS = asm.createBPSsource(asmOpen);
            asmOpen = BPS.AssessmentContainerId__c;}
        else{
        if (pageName == 'TCU_Screen_Vpage'){
            TCU_V = asm.createTCUVsource(asmOpen);
            asmOpen = TCU_V.AssessmentContainerId__c;}
            else{
        if (pageName == 'CRAFFT_Page'){
            CRAFFT = asm.createCRAFFTsource(asmOpen);
             asmOpen = CRAFFT.AssessmentContainerId__c;}
        else{
              if (pageName == 'UCLA_DSM_Vpage'){
                DSM_V = asm.createDSMsource(asmOpen);
            asmOpen = DSM_V.AssessmentContainerId__c;}
        else{
          if (pageName == 'WRNA_page'){
                WRNA = asm.createWRNAsource(asmOpen);
            asmOpen = WRNA.AssessmentContainerId__c;}
        else{
                 if (pageName == 'UCLA_PTSD_RIpage'){
                   UCLA_RI  = asm.createRIsource(asmOpen);
            asmOpen = UCLA_RI.AssessmentContainerId__c;}
        else{
              if (pageName == 'CEP_ICD_page'){
                ICD  = asm.createICDsource(asmOpen);
                if (ICD.Last_School_Attended__c <> null)
                  schoolName = findSchoolName(ICD.Last_School_Attended__c);
                asmOpen = ICD.AssessmentContainerId__c;}
        else{
               if (pageName == 'LSCMI_Y_page'){
                 LSCMI_Y  = asm.createLSCMI_Ysource(asmOpen);
                 asmOpen = LSCMI_Y.AssessmentContainerId__c;}   
        else{
                   if (pageName == 'PsychosocialPage'){
                    PSYCHO = asm.createPSYCHOsource(asmopen);
                    asmOpen = PSYCHO.AssessmentContainerId__c;}
           }}}}}}}}}}}}}}}}}}}}}}}}}}}
        showBasicInfo =  mapShowBasic.get(pageName); 
        boolNew = false;
        open4edit = asmOpen;
        isedit = false;}

    public pagereference doNothing()
    {return null;}
 
    SET<string> contactIds = new SET<string>();
    string accId;
    
    public void contactInfo()
    {   Contact c = [Select Case_coordinator__r.Name, court_rep__r.name,p_c_id__c,accountId,NYSID__c,Current_Exit_Date__c,Parent_Guardian__c,
        Relation_to_client__c,name,Case_coordinator__r.id,Current_Intake_Date__c,HomePhone,Emergency_Contact_If_Other__c
        From Contact where id =: contPassed];   
        contactName = c.name; 
      //  AccountId = c.accountid;
        contactProgram = c.P_C_ID__c.left(3);
        pcid = c.P_C_ID__c; 
        accId = c.accountId;
        if (c.Current_Intake_Date__c <> null)
        sIntakeDate = c.Current_Intake_Date__c.format();
        rel2client = c.Relation_to_client__c;
        CaseCoordinator = c.Case_coordinator__r.Name; 
        CourtRep = c.court_rep__r.name; 
        for (Contact lstContacts : [select id,P_C_ID__c,accountId from Contact where accountId =: accId])
        { contactIds.add(lstContacts.Id); }
   
       Account ac = [select dob__c from account where id =: accId];
       if (ac.dob__c <> null)
          sDob = ac.dob__c.format();
        mapcontact = new Map<Id, Contact>
            ([select id,P_C_ID__c,Client_Status__c,Case_coordinator__r.Name,Court_Rep__r.Name 
              from contact where id in: contactIds]);
              
     List<Address_Information__c> listAddress = rq.addressQuery(contPassed);
     for (Address_Information__c a : listAddress){
        if (a.Address_Type__c == 'Primary'){
            if (a.Building_No__c != null)
            address = a.Building_No__c;
          if (a.street__c != null)
            address = address + ' ' + a.street__c;
         if  (a.Apt_No__c != null)
             address = address + ' Apt. ' +  a.Apt_No__c;
         if (a.City__c != null) 
            address = address + ' ' + a.City__c;     
         if (a.State__c != null) 
            address = address + ' ' + a.State__c;       
         if (a.zip__c != null) 
            address = address + ', ' + a.zip__c; 
         if (a.Move_In_Date__c != null)   
            moveDate = a.Move_In_Date__c.format();  
            string phone = a.Home_Phone__c;   
         phone = a.Home_Phone__c;   
         liveWith = a.Contact_Person__c;
         RelclientCell = a.cell_phone__c;
         rel2client = a.Relation_to_client__c;     
         if (rel2client == 'Other') 
            rel2client = a.Relation_to_client__c +  '(' + a.Relation_to_Client_Other__c + ')';    
       break;}}} 
   
    public string CaseCoordinator{get;set;}
    public string CourtRep{get;set;}
 
    public boolean completed{get;set;}
  
    //////  SAVE Assessment   
    public void saveAssessment()
    { 
      if (proxyobject.Closing_Date__c > date.today()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Date of Assessment can not be after today.'));
        return;
      }
        strMissed = '';
    
        boolean lnew = false;
        AssessmentContainer__c c = new AssessmentContainer__c();
                 c.Client__c = contPassed;
            c.AccountId__c = accId;
        if (asmOpen == null || asmOpen == '')
        {   if (pageName == 'LifeEventsPage'){
          string strMissed = asm.validateLEC(LEC);
          if (strMissed != ''){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Missed: ' + strMissed));
           return;}} 
        c.AssessmentCode__c = aValue;
        c.Assessment_Completed_on__c = date.today();
        c.assessmentName__c =  mapAssCodeName.get(pageCode);
        c.Assessment_Date__c = proxyobject.Closing_Date__c;    
        c.Assessment_Completed_by__c = userLoginId; 
        assessmentdate = proxyobject.Closing_Date__c.format();
        LastModifiedInfo = findCreatedModifiedNames(userLoginId) + ' - ' + date.today().format();
        
        
    //    c.accountId__c = accountId;
        insert c;
        asmOpen = c.id;
        lnew = true;}
        else{
            c = new AssessmentContainer__c(id=asmOpen); 
            c.Assessment_Date__c = proxyobject.Closing_Date__c;
            assessmentdate = proxyobject.Closing_Date__c.format();
            c.Completed__c = true; //completed; 
            update c; 
            asmOpen = c.id;}    
        assessmentId = asmOpen;
        string cResult = '';
        c = new AssessmentContainer__c(id=asmOpen);
        if (pageName == 'BJMHS_page')
         asm.saveBJMHS(BJMHS,asmOpen);
        else{ 
        if (pageName == 'CEPIntake_page')
          asm.saveCEPIntake(CEPINT,asmOpen); 
        else  
            if (pageName == 'CCMOrientationPage')
          asm.saveCCM(CCM,asmOpen); 
        else{
     
        if (pageName == 'TCUpage'){
             asm.saveTCU(TCU,asmOpen);
             TCUassessment__c t = [select TCU_Total_Score__c from TCUassessment__c where AssessmentContainerId__c =: asmOpen limit 1];
             c.assmResult__c  = 'TCU total score: ' + string.valueOf(t.TCU_Total_Score__c);
             update c;}
        else
            if (pageName == 'EducationPage') 
                asm.saveED(Educ,asmOpen);
      else
            if (pageName == 'EmplEdSurveyPage') 
                asm.saveSurvey(survey,asmOpen);                
        else{
      
        if (pageName == 'SubstanceAbusepage')
            asm.saveSAA(SAA,asmOpen); 
        
        
        if (pageName == 'CC_AssessmentPage')
            asm.saveCC(CC,asmOpen); 
        else
        if (pageName == 'CR_AssessmentPage')
            asm.saveCR(CR,asmOpen); 
        else{
        if (pageName == 'LSCMIpage')
            asm.saveLSCMI(LSCMI,asmOpen);
        else{
        if (pageName == 'SRP_Intakepage') 
            asm.saveSRP(SRP, asmOpen); 
        else{
        if (pageName == 'PHQ_9TeenPage'){
            asm.savePHQ9teen(PHQ_9T, asmOpen);
            PHQ_9T__c p = [select id, Result__c,PHQ_9_Flag__c
                from PHQ_9T__c where AssessmentContainerId__c =: asmOpen limit 1];
            if (p.PHQ_9_Flag__c == true)
               cResult  = 'Flag and ' + p.Result__c;
            else
               cResult  = p.Result__c;
            System.Debug('\n\n XXX cResult: ' + cResult);
            c.assmResult__c  = cResult;
            c.flag__c = p.PHQ_9_Flag__c;
            update c;
            showPage(false);}            
        else{
        if (pageName == 'PHQ9page'){
            asm.savePHQ9(PHQ_9,asmOpen);
            PHQ_9__c p = [select id, Result__c,PHQ_9_Flag__c
                from PHQ_9__c where AssessmentContainerId__c =: asmOpen limit 1];
            if (p.PHQ_9_Flag__c == true)
               cResult  = 'Flag and ' + p.Result__c;
            else
               cResult  = p.Result__c;
            System.Debug('\n\n XXX cResult: ' + cResult);
            c.assmResult__c  = cResult;
            c.flag__c = p.PHQ_9_Flag__c;
            update c;
            showPage(false);}            
        else{
        if (pageName == 'LifeEventsPage')
           asm.saveLEC(LEC, asmOpen);
        else{
        if (pageName == 'MHSFpage')
            asm.saveMHSF(MHSF, asmOpen);
        else{
        if (pageName == 'HealthScreenPage')
            asm.saveHS(HS, asmOpen); 
        else{
        if (pageName == 'PCLCpage')
            asm.savePCL(PCL, asmOpen);
        else{
        if (pageName == 'LSIRpage')
            asm.saveLSIR(LSIR, asmOpen);
        else{
        if (pageName == 'CEP_BPSpage')
            asm.saveBPS(BPS, asmOpen);  
      
        else{
        if (pageName == 'TCU_Screen_Vpage')
            asm.saveTCUV(TCU_V, asmOpen);
        
         else{
        if (pageName == 'CRAFFT_Page'){
            asm.saveCRAFFT(CRAFFT, asmOpen);
            CRAFFT = asm.createCRAFFTsource(asmOpen);}
        else
          if (pageName == 'UCLA_DSM_Vpage') 
             asm.saveDSM(DSM_V, asmOpen); 
          else
          if (pageName == 'WRNA_page'){
          asm.saveWRNA(WRNA, asmOpen);
          WRNA__c t = [select Result__c from WRNA__c where AssessmentContainerId__c =: asmOpen limit 1];
             c.assmResult__c  = 'Risk Factors: ' + t.result__c;
             update c;}
          else{
            if (pageName == 'UCLA_PTSD_RIpage')
                asm.saveRI(UCLA_RI, asmOpen);
            else
            if (pageName == 'CEP_ICD_page'){
               asm.saveICD(ICD, asmOpen);
            if (ICD.Last_School_Attended__c <> null)
                schoolName = findSchoolName(ICD.Last_School_Attended__c);}
            else{
                if (pageName == 'LSCMI_Y_page')
                asm.saveLSCMI_Y(LSCMI_Y, asmOpen);
            
             else{    if (pageName == 'HBWpage') 
                asm.saveHW(HW,asmOpen);
             else{
                if (pageName == 'PsychosocialPage') 
                asm.savePSYCHO(PSYCHO,asmOpen);
             }}}}}}}}}}}}}}}}}}}
        if (lnew)
           selectAssessmentHistory();
        isedit = false;
        }

    public boolean completedValue(string recid)
    { AssessmentContainer__c s = [select  id,completed__c from AssessmentContainer__c where id =: recid];
      return s.completed__c;}
   
    string findCreatedModifiedNames(string cuser){
        User u = [select name from user where id =: cuser];
        return u.name;}

    public void buttonShow(){
       if (boolnew && strMissed <> '')
       return ;
       isedit = !isedit;}
    
    boolean newCancel = false;
    public void cancelEdit(){
      isedit = false;
     isCancel = true;
    if (boolnew == false)
       showPage(false);
    else
       showEmptyPage();}
   
       public void saveLogin(){
            string cuser = UserInfo.getUserName();
      string sDateToday = date.today().format();
      string sDateIntrack;
      integer i; 
      loginTracking__c logchk = new loginTracking__c();
       loginTracking__c lt = new loginTracking__c();
        try{
        logchk = [select pageName__c, loginName__c, loginDateTime__c,createddate 
           from loginTracking__c where loginName__c =: cuser
             and pageName__c =:  'assessment' order by createddate desc limit 1];}
     catch (Exception e) {
          lt = new loginTracking__c();
          lt.loginName__c = cuser;
          lt.loginDateTime__c = datetime.now().format(); 
          lt.pageName__c = 'assessment';
        insert lt;}
     finally {
        if (logchk != null && logchk.loginDateTime__c != null){        
          i = logchk.loginDateTime__c.IndexOf(' ');
          sDateIntrack = logchk.loginDateTime__c.substring(0,i);
        if (sDateIntrack != sDateToday){
           lt = new loginTracking__c();          
           lt = new loginTracking__c();
           lt.loginName__c = cuser;
           lt.loginDateTime__c = datetime.now().format(); 
           lt.pageName__c = 'assessment';
        insert lt;}}
      }  }
       
    public void deleteAssessment()
    { if (isedit == true){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'please finish edit mode'));
        return;}
        newAssessment = false;
        boolOpen = false;
        isedit = false; 
        string idDelete =  ApexPages.currentPage().getParameters().get('openId');
        AssessmentContainer__c aDelete = [select id from AssessmentContainer__c where id =: idDelete limit 1];
        delete aDelete;
        pageName = 'emptyPage';
        selectAssessmentHistory();}
    
    public void showPageFromHistory()
    {asmOpen = ApexPages.currentPage().getParameters().get('openId');
     showPage(false);}
 
    public pageReference pageClose()
    {   Pagereference pg = new PageReference('/' + contPassed);
        return pg;}
 
    public List<SelectOption> getLECItems1()
    {   List<SelectOption> option = new List<SelectOption>();
        option.add(new SelectOption('Happened to me','Happened to me'));
        option.add(new SelectOption('Witnessed it','Witnessed it'));
        option.add(new SelectOption('Learned about it','Learned about it'));
        option.add(new SelectOption('Not sure','Not sure'));
        option.add(new SelectOption('Doesn’t apply','Doesn’t apply'));
        return option;}
  
      public List<SelectOption> getItems0_3()
    {   List<SelectOption> option = new List<SelectOption>();
        option.add(new SelectOption('0','0'));
        option.add(new SelectOption('1','1'));
        option.add(new SelectOption('2','2'));
        option.add(new SelectOption('3','3'));
        return option;} 

    public string plValue{get;set;}
     public List<SelectOption> getYesNoItems()
    {   List<SelectOption> option = new List<SelectOption>();
        option.add(new SelectOption('0','No'));
        option.add(new SelectOption('1','Yes'));
        return option;}         
           
    string findSchoolName(string cid){
      string ret = '';
      Account ac = [select name from Account where id=: cid limit 1];
      if (ac != null)
          ret = ac.name;
      return ret;}
}