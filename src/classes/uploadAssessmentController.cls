public class uploadAssessmentController {
   public Blob csvFileBody{get;set;}
   public string csvFile{get;set;}
   public String[] csvfilelines{get;set;}
   public List<clsDisplayDownLoads> lstLoads{get;set;}
  // public Id tabeTestRecordType = Utility_ID__c.getValues('TABE').RecordType_Id__c;
 //  AssessmentContainer__c aCreated = new AssessmentContainer__c();  
   public boolean lscmi{get;set;}    
   public boolean lsir{get;set;}    
   public boolean ltabe{get;set;} 
   public boolean lYlscmi {get;set;} 
   public LSCMI__c tt {get;set;}  
   /////////////   Constractor
   string userLoginId;
   Map<string,string>  mapNameCode = new Map<string,string>();
   Map<string,string>  mapContactAccount = new Map<string,string>();
   public uploadAssessmentController(){
       for (assessmentList__c lu :[Select assessmentName__c,name,pageName__c,programs__c
         From assessmentList__c where isActive__c =: true order by assessmentName__c]){
        mapNameCode.put(lu.assessmentName__c.trim(),lu.name);}
      csvfilelines = new String[]{};
      userLoginId = userInfo.getUserId();}
   
     /////////////////////////   LSCMI file
   public void readcsvLSCMI(){
     tt = new LSCMI__c();
       if (csvFile == null || csvFile == ''){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a file'));
          return;}
    
      if (csvFile.toUpperCase().contains('LSCMI') == false){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You have selected an LSI-R:SV file and clicked the "Upload LS/CMI file" button. Please retry and select the correct button, or change the file.'));
         return;}
     lsir = false;
     lscmi = true;  
     ltabe = false; 
     lYlscmi = false;
    System.Debug('\n\n XXX csvFile: ' + csvFile);
    if (csvFile.toUpperCase().contains('ABH'))
       readcsvFile('LSCMI');
    else
       readcsvFile('Y_LSCMI');}
    
   /////////////////////////   LSIR file
   public void readcsvLSIR(){
      if (csvFile == null || csvFile == ''){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a file'));
         return;}

      if (csvFile.toUpperCase().contains('LSIR') == false){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You have selected an LS/CMI file and clicked the "Upload LSI-R:SV file" button. Please retry and select the correct button, or change the file.'));
        return;}
      lsir = true;
      lscmi = false;   
      ltabe = false;
      lYlscmi = false;
      readcsvFile('LSIR');}

   public class clsDisplayDownLoads {
   public string contactId{get;set;}
   public string assName{get;set;}
   public string legacyId{get;set;}
   public string dAssess{get;set;}
   public string overallRisk{get;set;} 
   public string notes{get;set;}
   public string fullname{get;set;}
   public string PCID{get;set;}
   public string uploadresult{get;set;}
   public string surveydate{get;set;}
   public ID assId{get;set;}
   public string tabeNotes{get;set;}
   public string origassessm{get;set;}}
 //  List<AssessmentContainer__c> lstContainerAdd;
   
    AssessmentContainer__c assm = new AssessmentContainer__c();
     List<AssessmentContainer__c> lstContainerAll = new List<AssessmentContainer__c>();        
    List<AssessmentContainer__c> lstContainerAdd = new List<AssessmentContainer__c>();  
     List<LSCMI__c> lstLCMI = new list<LSCMI__c>();
     LSCMI__c oneLSCMI = new LSCMI__c();
     
     List<LSCMI_Y__c> lstY = new List<LSCMI_Y__c>();
     LSCMI_Y__c oneY = new LSCMI_Y__c();

     List<LSIR__c> lstLSIR = new list<LSIR__c>();
     LSIR__c oneLSIR = new LSIR__c();
     clsDisplayDownLoads down = new clsDisplayDownLoads();
 
     //     Read CSV file
    MAP<id,string>  mapIdName;
    MAP<id,string>  mapIdPcId;
  
   public void readcsvFile(string MHtype){
     System.Debug('\n\n\n XXX in read tyle: ' + MHtype);
    MAP<id,string>  mapIdName = new MAP<id,string>();
    MAP<id,string>  mapIdPcId = new MAP<id,string>();
    string AssIdDate_in_SF,AssIdDate_in_File,cname,fixednotes, fixedstring;
    boolean badDate = false; 
    Set<Id> setID_in_File  = new Set<Id>();
    Set<Id> setContactID_in_SF  = new Set<Id>();
    Set<String> SetLegacyId_inFile = new Set<String>(); 
    Set<String> SetLegacyId_inSF = new Set<String>();
    String[] csvRecordData, csvRecordData1;
 
    csvFile = csvFileBody.toString();
    csvfilelines = csvFile.split('\n');  
    if (csvfilelines.size() == 1)
      csvfilelines = csvFile.split('\n\r'); 
      System.Debug('\n\n\n XXX csvfilelines: ' + csvfilelines);
      
        
   for (Integer i = 1; i < csvfilelines.size(); i++){
      csvRecordData = csvfilelines[i].split(',');
  
      if (csvRecordData[0] == null || csvRecordData[0] == ''){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please check CSV file. Some records may have an empty ID.'));
        return;}
      setID_in_File.add(csvRecordData[0]);
      if (MHtype == 'LSIR')
        SetLegacyId_inFile.add(csvRecordData[1]);
      else 
        SetLegacyId_inFile.add(csvRecordData[2]);
   }
  
      System.Debug('\n\n\n XXX SetLegacyId_inFile: ' + SetLegacyId_inFile);
  
      for (Contact c :  [select id, accountId from contact 
          where id in: setID_in_File]){
          mapContactAccount.put(c.id,c.accountId);} 
  
      string strcontact, strLegacy;
      List<AssessmentContainer__c> lstAss_inSF = [select accountId__c,client__c,  Assessment_Completed_on__c, Legacy_Database_Id__c
       from AssessmentContainer__c where Legacy_Database_Id__c in: SetLegacyId_inFile];
      for (AssessmentContainer__c a : lstAss_inSF){ 
       SetLegacyId_inSF.add(a.Legacy_Database_Id__c);}
     
      List<String> uploadedClients = new List<String>();
 //     List<String> uploadedLegacy = new List<String>();
      Set<String> uploadedLegacy = new Set<String>();
  
      string legId;
   
     System.Debug('\n\n\n XXX csvfilelines.size(): ' +csvfilelines.size());
      integer m = 0;
      for (integer k = 1; k < csvfilelines.size(); k++){
     
        assm = new AssessmentContainer__c();
        csvRecordData = csvfilelines[k].split(',');     
     
        assm.client__c = csvRecordData[0].trim(); 
        assm.accountid__c = mapContactAccount.get(assm.client__c);
        csvfilelines[k] = fixString(csvfilelines[k]);
        assm.Legacy_Database_Id__c = csvRecordData[2].trim(); 
        if (MHtype == 'LSCMI'){
            assm.assessmentCode__c = mapNameCode.get('LS/CMI');
            assm.assessmentName__c = 'LS/CMI';
            assm.Legacy_Database_Id__c = csvRecordData[2].trim();
           assm.Assessment_Date__c = date.parse(csvRecordData[3].trim());
          assm.assmresult__c = 'Risk Category: '+ csvRecordData[22].trim();
          try{assm.Assessment_Completed_on__c = date.parse(csvRecordData[3].trim());}
          catch (Exception e){badDate = true;}
            } 
       else {if (MHtype == 'Y_LSCMI'){
            assm.assessmentCode__c = mapNameCode.get('Y-LS/CMI');
            assm.assessmentName__c = 'Y-LS/CMI';
            assm.Legacy_Database_Id__c = csvRecordData[2].trim();
          assm.Assessment_Date__c = date.parse(csvRecordData[3].trim());
          assm.assmresult__c = 'Risk Category: '+ csvRecordData[22].trim();
          try{assm.Assessment_Completed_on__c = date.parse(csvRecordData[3].trim());}
          catch (Exception e){badDate = true;}            }
        else{
            assm.assessmentCode__c = mapNameCode.get('LSI R');
            assm.assessmentName__c = 'LSI R';
            assm.Legacy_Database_Id__c = csvRecordData[1].trim();
         assm.Assessment_Date__c = date.parse(csvRecordData[2].trim());
       //   assm.assmresult__c = 'Risk Category: '+ csvRecordData[21].trim();
          try{assm.Assessment_Completed_on__c = date.parse(csvRecordData[2].trim());}
          catch (Exception e){badDate = true;}
            
            
            }  
       }
       
          assm.Uploaded__c = true;
          //assm.Source__c = 'Upload';
          assm.Completed__c = true;
          assm.Assessment_Completed_by__c = userLoginId;
//          assm.Assessment_Date__c = date.parse(csvRecordData[3].trim());
 //         assm.assmresult__c = 'Risk Category: '+ csvRecordData[22].trim();
  //        try{assm.Assessment_Completed_on__c = date.parse(csvRecordData[3].trim());}
   //       catch (Exception e){badDate = true;}
          
       lstContainerAll.add(assm);
          uploadedClients.add(assm.client__c); 
 //         uploadedLegacy.add(assm.Legacy_Database_Id__c) ;
         if (SetLegacyId_inSF != null){   
            if (SetLegacyId_inSF.contains(assm.Legacy_Database_Id__c) == false){
              lstContainerAdd.add(assm);
             uploadedLegacy.add(assm.Legacy_Database_Id__c) ;
            }}
        //   else 
         //    lstContainerAdd.add(assm);
           
   //       lstContainerAdd.add(assm);
    //       uploadedClients.add(assm.client__c); 
      //    uploadedLegacy.add(assm.Legacy_Database_Id__c) ;
       
          m++;
       
         System.Debug('\n\n XXX lstContainerAdd: ' +lstContainerAdd);
  
        if (MHtype == 'LSCMI'){
                System.Debug('\n\n\n XXX in LSCMI: ');
            oneLSCMI= new LSCMI__c();
            oneLSCMI.LSCMI_Strengths__c = csvRecordData[5]; 
            oneLSCMI.LSCMI_Subscale_1_Risk_Level__c = decimal.ValueOf(csvRecordData[6].trim()); 
            oneLSCMI.LSCMI_Subscale_2_Risk_Level__c = decimal.ValueOf(csvRecordData[7].trim()); 
            oneLSCMI.LSCMI_Subscale_3_Risk_Level__c = decimal.ValueOf(csvRecordData[8].trim());   
            oneLSCMI.LSCMI_Subscale_4_Risk_Level__c = decimal.ValueOf(csvRecordData[9].trim());  
            oneLSCMI.LSCMI_Subscale_5_Risk_Level__c = decimal.ValueOf(csvRecordData[10].trim());  
            oneLSCMI.LSCMI_Subscale_6_Risk_Level__c = decimal.ValueOf(csvRecordData[11].trim());  
            oneLSCMI.LSCMI_Subscale_7_Risk_Level__c = decimal.ValueOf(csvRecordData[12].trim());  
            oneLSCMI.LSCMI_Subscale_8_Risk_Level__c = decimal.ValueOf(csvRecordData[13].trim());  
            oneLSCMI.LSCMI_Subscale_1_Criminal_History__c = csvRecordData[14].trim(); 
            oneLSCMI.LSCMI_Subscale_2_Education_Employment__c = csvRecordData[15].trim();  
            oneLSCMI.LSCMI_Subscale_3_Family_Marital__c = csvRecordData[16].trim();  
            oneLSCMI.LSCMI_Subscale_4_Leisure_Recreation__c = csvRecordData[17].trim();  
            oneLSCMI.LSCMI_Subscale_5_Companions__c = csvRecordData[18].trim();  
            oneLSCMI.LSCMI_Subscale_6_Alcohol_Drug_Problem__c = csvRecordData[19].trim();  
            oneLSCMI.LSCMI_Subscale_7_Pro_criminal_Attitude__c = csvRecordData[20].trim();  
            oneLSCMI.LSCMI_Subscale_8_Anti_social_Pattern__c = csvRecordData[21].trim();   
            oneLSCMI.Overall_Risk_Category__c = csvRecordData[22].trim();  
            oneLSCMI.LSCMI_Result__c = decimal.ValueOf(csvRecordData[23].trim());  
            try{oneLSCMI.Survey_Date__c = date.parse(csvRecordData[25].trim());} 
            catch (Exception e){badDate = true;}
            try{fixednotes = csvRecordData[26].replaceall('__',',');
            oneLSCMI.Survey_Notes__c = fixednotes.replaceall('XZXZ', '\r\n');}
            catch (Exception e) {badDate = true;}
            oneLSCMI.Weight__c = '2';
            if (SetLegacyId_inSF.contains(assm.Legacy_Database_Id__c) == false)
               lstLCMI.add(oneLSCMI);
          }
          else {if (MHtype == 'Y_LSCMI'){
                 oneY = new LSCMI_Y__c();
                        oneLSCMI.LSCMI_Strengths__c = csvRecordData[5]; 
            oneY.LSCMI_Subscale_1_Risk_Level__c = decimal.ValueOf(csvRecordData[6].trim()); 
            oneY.LSCMI_Subscale_2_Risk_Level__c = decimal.ValueOf(csvRecordData[7].trim()); 
            oneY.LSCMI_Subscale_3_Risk_Level__c = decimal.ValueOf(csvRecordData[8].trim());   
            oneY.LSCMI_Subscale_4_Risk_Level__c = decimal.ValueOf(csvRecordData[9].trim());  
            oneY.LSCMI_Subscale_5_Risk_Level__c = decimal.ValueOf(csvRecordData[10].trim());  
            oneY.LSCMI_Subscale_6_Risk_Level__c = decimal.ValueOf(csvRecordData[11].trim());  
            oneY.LSCMI_Subscale_7_Risk_Level__c = decimal.ValueOf(csvRecordData[12].trim());  
            oneY.LSCMI_Subscale_8_Risk_Level__c = decimal.ValueOf(csvRecordData[13].trim());  
            oneY.LSCMI_Subscale_1_Criminal_History__c = csvRecordData[14].trim(); 
            oneY.LSCMI_Subscale_2_Education_Employment__c = csvRecordData[15].trim();  
            oneY.LSCMI_Subscale_3_Family_Marital__c = csvRecordData[16].trim();  
            oneY.LSCMI_Subscale_4_Leisure_Recreation__c = csvRecordData[17].trim();  
            oneY.LSCMI_Subscale_5_Companions__c = csvRecordData[18].trim();  
            oneY.LSCMI_Subscale_6_Alcohol_Drug_Problem__c = csvRecordData[19].trim();  
            oneY.LSCMI_Subscale_7_Pro_criminal_Attitude__c = csvRecordData[20].trim();  
            oneY.LSCMI_Subscale_8_Anti_social_Pattern__c = csvRecordData[21].trim();   
            oneY.Overall_Risk_Category__c = csvRecordData[22].trim();  
            oneY.LSCMI_Result__c = decimal.ValueOf(csvRecordData[23].trim());  
            try{oneY.Survey_Date__c = date.parse(csvRecordData[25].trim());} 
            catch (Exception e){badDate = true;}
            try{fixednotes = csvRecordData[26].replaceall('__',',');
            oneY.Survey_Notes__c = fixednotes.replaceall('XZXZ', '\r\n');}
            catch (Exception e) {badDate = true;}
            oneY.Weight__c = '2';
/*                 
            oneY.LSCMI_Strengths__c = csvRecordData[5]; 
            oneY.LSCMI_Subscale_1_Risk_Level__c = decimal.ValueOf(csvRecordData[5].trim()); 
            oneY.LSCMI_Subscale_2_Risk_Level__c = decimal.ValueOf(csvRecordData[6].trim()); 
            oneY.LSCMI_Subscale_3_Risk_Level__c = decimal.ValueOf(csvRecordData[7].trim());   
            oneY.LSCMI_Subscale_4_Risk_Level__c = decimal.ValueOf(csvRecordData[8].trim());  
            oneY.LSCMI_Subscale_5_Risk_Level__c = decimal.ValueOf(csvRecordData[9].trim());  
            oneY.LSCMI_Subscale_6_Risk_Level__c = decimal.ValueOf(csvRecordData[10].trim());  
            oneY.LSCMI_Subscale_7_Risk_Level__c = decimal.ValueOf(csvRecordData[11].trim());  
            oneY.LSCMI_Subscale_8_Risk_Level__c = decimal.ValueOf(csvRecordData[12].trim());  
         //   oneY.LSCMI_Subscale_1_Criminal_History__c = csvRecordData[14].trim(); 
          //  oneY.LSCMI_Subscale_2_Education_Employment__c = csvRecordData[15].trim();  
          //  oneY.LSCMI_Subscale_3_Family_Marital__c = csvRecordData[16].trim();  
          //  oneY.LSCMI_Subscale_4_Leisure_Recreation__c = csvRecordData[17].trim();  
           // oneY.LSCMI_Subscale_5_Companions__c = csvRecordData[18].trim();  
          //  oneY.LSCMI_Subscale_6_Alcohol_Drug_Problem__c = csvRecordData[19].trim();  
          //  oneY.LSCMI_Subscale_7_Pro_criminal_Attitude__c = csvRecordData[20].trim();  
          //  oneY.LSCMI_Subscale_8_Anti_social_Pattern__c = csvRecordData[21].trim();   
          //  oneY.Overall_Risk_Category__c = csvRecordData[22].trim();  
         //   oneY.LSCMI_Result__c = decimal.ValueOf(csvRecordData[23].trim());  
         //   try{oneY.Survey_Date__c = date.parse(csvRecordData[25].trim());} 
         //   catch (Exception e){badDate = true;}
         //   try{fixednotes = csvRecordData[26].replaceall('__',',');
         //   oneY.Survey_Notes__c = fixednotes.replaceall('XZXZ', '\r\n');}
     //       catch (Exception e) {badDate = true;}
         //   oneY.Weight__c = '2';
  */
           if (SetLegacyId_inSF.contains(assm.Legacy_Database_Id__c) == false)
            lstY.add(oneY);
          }
          
          else{
            oneLSIR= new LSIR__c();
            oneLSIR.LSIRSV_Original_Assessment__c = csvRecordData[4].trim(); 
            oneLSIR.LSI_R_SV_Score__c = decimal.ValueOf(csvRecordData[3].trim()); 
            try{oneLSIR.Survey_Date__c = date.parse(csvRecordData[2].trim());} 
            catch (Exception e){badDate = true;}
           if (SetLegacyId_inSF.contains(assm.Legacy_Database_Id__c) == false)
            lstLSIR.add(oneLSIR);
          }} 
       lstContainerAll.add(assm); 
       }
 
 if (lstContainerAdd.Size() != 0)
   upsert lstContainerAdd;
   string containerId;
  List<AssessmentContainer__c> contAdded = [select id, Legacy_Database_Id__c,assmresult__c from AssessmentContainer__c 
      where Legacy_Database_Id__c in: uploadedLegacy];
 for (Integer a = 0; a < contAdded.Size(); a++){
      containerId = contAdded[a].id;      
      if (MHtype == 'LSCMI'){
            lstLCMI[a].AssessmentContainerId__c = containerId;  
     //    contAdded[a].assmResult__c = 'Overall Risk Category: ' + lstLCMI[a].Overall_Risk_Category__c;
      }
      else{
         if (MHtype == 'Y_LSCMI'){
          lstY[a].AssessmentContainerId__c = containerId; 
    //      contAdded[a].assmResult__c = 'Overall Risk Category: ' + lstY[a].Overall_Risk_Category__c;
         }
         else
           lstLSIR[a].AssessmentContainerId__c = containerId; 
         
    }}
       if (MHtype == 'LSCMI'){
          upsert lstLCMI; 
    //      update contAdded;
       }
      else
         if (MHtype == 'Y_LSCMI')
         upsert lstY;
     else
         upsert lstLSIR; 
    
  System.Debug('\n\n XXX lstLCMI: ' + lstLCMI); 
// lstContainerAll,
  displayRecords(SetLegacyId_inFile, SetLegacyId_inSF, MHtype);}    
      
  
       //    display generated info for LSCMI
  public void displayRecords(Set<String> SetLegacyId_inFile, Set<String> SetLegacyId_inSF, string MHtype){
    
     List<AssessmentContainer__c> lstCont = new List<AssessmentContainer__c>(); 
     string selRecords = 'select id, client__c,  Assessment_Completed_on__c,assmresult__c, assessmentName__c, ' + 
       'legacy_database_id__c, client__r.name, client__r.id,client__r.p_c_id__c ' + 
       'from AssessmentContainer__c where legacy_database_id__c in: SetLegacyId_inFile';
     lstCont = Database.Query(selRecords);
     System.Debug('\n\n\n YYY lstCont: ' +  lstCont);
     lstLoads = new List<clsDisplayDownLoads>();
     for (AssessmentContainer__c a : lstCont){
       down = new clsDisplayDownLoads();
       down.uploadresult = 'Assment added.';
       down.assName = a.assessmentName__c;
       down.fullname = a.client__r.name;
       down.contactId = a.client__r.id;
       down.dAssess = string.ValueOf(a.Assessment_Completed_on__c); 
       down.legacyId = a.legacy_database_id__c;
       down.assId = a.id;
       down.overallRisk = a.assmresult__c; 
       if (SetLegacyId_inSF != null){
           if (SetLegacyId_inSF.contains(down.legacyId))
              down.uploadresult = 'This assessment was already uploaded.';
       } 
       down.PCID = a.client__r.p_c_id__c;
       lstLoads.add(down);} 
       csvFile = '';  
     }            
/*     
  //////////             TABE upload                   //////////////
   public void readcsvTABE(){
     
   //    System.Debug('\n\n\n YYY recordtype: ' +  tabeTestRecordType);
      
       if (csvFile == null || csvFile == ''){
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a file'));
         return;}
      if (csvFile.toUpperCase().contains('TABE') == false){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You have selected not a TABE file and clicked the "Upload LSI-R:SV or Upload LS/CMI file" button. Please retry and select the correct button, or change the file.'));
        return;}
      lsir = false;
      lscmi = false;    
      ltabe = true;
      MAP<id,string>  mapIdName = new MAP<id,string>();
      MAP<id,string>  mapIdPcId = new MAP<id,string>();        
      Set<Id> setID_in_File  = new Set<Id>();
      Set<Id> setContactID_in_SF  = new Set<Id>();        
      Set<String> setMemo_inFile = new Set<String>();  
      Set<String> setMemo_inSF = new Set<String>();      
      String[] csvRecordData;
      List<Test__c> lstTest = new List<Test__c>();
      List<Test__c> lstTestAll = new List<Test__c>();     
      Test__c test = new Test__c();
      csvFile = csvFileBody.toString();
      csvfilelines = csvFile.split('\n');  
      if (csvfilelines.size() == 1)
          csvfilelines = csvFile.split('\n\r'); 
      for (Integer i = 1; i < csvfilelines.size(); i++){
         csvRecordData = csvfilelines[i].split(',');
         if (csvRecordData[0] == null || csvRecordData[0] == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please check TABE file. Some records may have an empty ID.'));
             return;}
         setID_in_File.add(csvRecordData[0]);
         setMemo_inFile.add(csvRecordData[11].trim());}
         
    List<Test__c> lstTest_inSF = [select contact__c, Migration_Note__c from Test__c
         where Migration_Note__c in: setMemo_inFile];
      for (integer i = 0; i < lstTest_inSF.Size(); i++){
          setContactID_in_SF.add(lstTest_inSF[i].contact__c);
          SetMemo_inSF.add(lstTest_inSF[i].Migration_Note__c);} 
     string cname;     
     for (Contact c :  [select id, firstname, lastname, P_C_ID__c  from contact 
          where id in: setID_in_File]){
          cname = c.firstname.trim() + ' ' + c.lastname.trim();
          mapIdName.put(c.id, cname);
          mapIdPcId.put(c.id, c.P_C_ID__c);}     
     boolean badDate;     
     for (Integer i = 1; i < csvfilelines.size(); i++){
         test = new Test__c();
         csvRecordData = csvfilelines[i].split(',');     
         test.contact__c = csvRecordData[0].trim();  
         test.test_type__c = 'Complete Battery'; 
         test.Migration_Note__c = csvRecordData[11].trim(); 
         try{test.Test_Date__c = date.parse(csvRecordData[1].trim());}
         catch (Exception e){badDate = true;}
         test.applied_math_ge__c = decimal.valueOf(csvRecordData[2].trim()); 
         test.Language_ge__c = decimal.ValueOf(csvRecordData[3].trim()); 
         test.Math_Computation_GE__c = decimal.ValueOf(csvRecordData[4].trim()); 
         test.Reading_GE__c = decimal.ValueOf(csvRecordData[5].trim()); 
         test.Total_Math_GE__c = decimal.ValueOf(csvRecordData[6].trim()); 
         test.Total_Score__c = decimal.ValueOf(csvRecordData[7].trim()); 
         test.Language_Mechanics_GE__c = decimal.ValueOf(csvRecordData[8].trim()); 
         test.Spelling_GE__c = decimal.ValueOf(csvRecordData[9].trim()); 
         test.Vocabulary_GE__c  = decimal.ValueOf(csvRecordData[10].trim());         
         test.recordtypeId = tabeTestRecordType;
         //csvRecordData[9].trim();
    //     System.Debug('\n\n\n XXX lstTest contact id: ' + ' i = ' + i+ ' ' +  test.contact__c);
         lstTestAll.add(test); 
         if (SetMemo_inSF != null){   
            if (SetMemo_inSF.contains(test.Migration_Note__c) == false)
               lstTest.add(test);} 
            else 
              lstTest.add(test);}
    //   System.Debug('\n\n\n XXX test.contact__c: '+ test.contact__c)    ;   
       insert lstTest;    
    displayTABERecords(lstTestAll, mapIdName,mapIdPcId, lstTest_inSF, 
          setMemo_inFile, setMemo_inSF);    
     }  
       public void displayTABERecords(List<Test__c> lstTestAll, Map<id,string> mapIdName,Map<id, string> mapIdPcId,
       List<Test__c > lstTest_inSF, Set<String> setMemo_inFile, Set<String> setMemo_inSF){
     Map<string, Id> mapTestNotes_ContactId = new Map<string, Id>();
     for (Test__c a : [select id, contact__c,  Test_Date__c, Migration_Note__c from Test__c
         where Migration_Note__c in: setMemo_inFile]){
           mapTestNotes_ContactId.put(a.Migration_Note__c.trim(), a.id);} 
     clsDisplayDownLoads down = new clsDisplayDownLoads();
     lstLoads = new List<clsDisplayDownLoads>(); 
     for (integer i = 0; i < lstTestAll.Size(); i++){
         down = new clsDisplayDownLoads();
         down.uploadresult = 'TABE Adaptive test added.'; 
         down.fullname = '';
         down.contactId = lstTestAll[i].contact__c;
         down.dAssess = string.ValueOf(lstTestAll[i].Test_Date__c); 
         down.assId = mapTestNotes_ContactId.get(lstTestAll[i].Migration_Note__c.trim());
         down.legacyId = lstTestAll[i].Migration_Note__c;
         if (setMemo_inSF != null){
           if (setMemo_inSF.contains(down.legacyId))
              down.uploadresult = 'This test was already uploaded.';}
              down.fullname = mapIdName.get(down.contactId);
              down.PCID = mapIdPcId.get(down.contactId);
          lstLoads.add(down);}
          csvFile = '';}  
  */        
 public string fixString(string str2fix){
     string s_return = '';
     string str1;
    String[] part = str2fix.split('"');
    if (part.Size() > 1){
      s_return = part[0];  
     for (integer i = 1; i < part.Size(); i++){
        str1 = part[i].replaceall(',','__'); 
        s_return += str1;}
        }
     else
       s_return = str2fix;
   //  System.Debug('\n\n\n XXX part.Size() : ' + part.Size() + ' s_return: ' + s_return);
    return s_return;}  
  
  /*  
    List<AssessmentContainer__c> createContainer(){
       MAP<id,string>  mapIdName = new MAP<id,string>();
       MAP<id,string>  mapIdPcId = new MAP<id,string>();
       List<AssessmentContainer__c> retList = new List<AssessmentContainer__c>();
       AssessmentContainer__c oneRecord = new AssessmentContainer__c();
      
    }
    */          
}