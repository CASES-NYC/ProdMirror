public class AssessmentSectionController {
//    private final Contact client;
      public Contact client;
      public class assCreated{
      public string assId{get;set;}
      public string assName{get;set;}
      public string assCode{get;set;}
      public string clientSFid{get;set;}
      public string assDate{get;set;}
      public string assBy{get;set;}
      public string result{get;set;}
      public string status{get;set;}
      public string Program{get;set;} 
 
      public string assId1{get;set;}
      public string assName1{get;set;}
      public string assCode1{get;set;}
      public string clientSFid1{get;set;}
      public string assDate1{get;set;}
      public string assBy1{get;set;}
      public string result1{get;set;}
      public string status1{get;set;}
      public string Program1{get;set;} 

     public string source{get;set;} 
       public boolean completed{get;set;}
      public boolean otherProgram{get;set;}
      }
      public string listOfAssessments{get;set;}     
      public string numberOfAssessments{get;set;}   
      public string contactId{get;set;}
      public boolean manyRecords{get;set;}

     public string PageName{get;set;}    
      public AssessmentSectionController(ApexPages.StandardController stdController){
        client = (Contact)stdController.getRecord();
        selectAssessmentHistory();
       contactId = client.id;
      }
      
        List<AssessmentContainer__c> aCreated;
   public List<assCreated> allShow{get;set;}
   void selectAssessmentHistory(){ 
    SET<string> contactIds = new SET<string>();
    string accId;       
    Contact c = [Select accountId From Contact where id =: client.id limit 1];   
      accId  = c.accountId;
    
    for (Contact lstContacts : [select id,P_C_ID__c,accountId from Contact where accountId =: accId])
       { contactIds.add(lstContacts.Id);}
      Map<Id, Contact>  mapcontact = new Map<Id, Contact>
            ([select id,P_C_ID__c,Client_Status__c,Case_coordinator__r.Name,Court_Rep__r.Name 
              from contact where id in: contactIds]);
     aCreated = new List<AssessmentContainer__c>([select id,Assessment_Completed_by__r.name,source__c,Uploaded__c,
     Assessment_Date__c,Assessment_Completed_on__c,assessmentCode__c,assessmentName__c,completed__c,
    LastModifiedDate, LastModifiedById,CreatedDate,CreatedById,client__c,assmresult__c
     from AssessmentContainer__c where client__c in: contactIds order by Assessment_Completed_on__c,assessmentName__c]);
 
        List<assCreated> assList = new List<assCreated>();
    assCreated oneAsm = new assCreated();
    string program, status;
    numberOfAssessments = '';
    listOfAssessments = '';
    integer i = 0;
    manyRecords = false;
    integer m;
    if (aCreated.Size() != 0){
     for (integer k = 0; k < aCreated.Size(); k++){
        oneAsm = new assCreated();
        Program = '';   
        oneAsm.source = '';
        oneAsm.assName = aCreated[k].assessmentName__c;
        oneAsm.assBy = aCreated[k].Assessment_Completed_by__r.name;
        if (aCreated[k].Assessment_Completed_on__c != null)
           oneAsm.assDate = aCreated[k].Assessment_Completed_on__c.format();
        oneAsm.assId = aCreated[k].id; 
        oneAsm.result = aCreated[k].assmresult__c;
        if (aCreated[k].assessmentName__c == 'LSI R' || aCreated[k].assessmentName__c == 'LS/CMI'
        || aCreated[k].assessmentName__c == 'Y-LS/CMI'){
          if (aCreated[k].Uploaded__c == true)
                   oneAsm.source =  'Uploaded';
          else oneAsm.source =  'Manual';}
         
        oneAsm.clientSFid = aCreated[k].Client__c;
        oneAsm.assCode = aCreated[k].assessmentCode__c;
        oneAsm.Status = mapContact.get(aCreated[k].client__c).Client_Status__c;
       
        oneAsm.assBy = aCreated[k].Assessment_Completed_by__r.name;     
        oneAsm.Program = (mapContact.get(aCreated[k].client__c).p_c_id__c.left(3)); 
                i++;
      for (m = k + 1; m < aCreated.Size(); m++){
        oneAsm.assName1 = aCreated[m].assessmentName__c;
        oneAsm.assBy1 = aCreated[m].Assessment_Completed_by__r.name;
        if (aCreated[m].Assessment_Completed_on__c != null)
        oneAsm.assDate1 = aCreated[m].Assessment_Completed_on__c.format();
        oneAsm.assId1 = aCreated[m].id; 
        oneAsm.result1 = aCreated[m].assmresult__c;
        if (aCreated[m].assessmentName__c == 'LSI R' || aCreated[m].assessmentName__c == 'LS/CMI')
            oneAsm.source =  aCreated[m].source__c; 
        oneAsm.clientSFid1 = aCreated[m].Client__c;
        oneAsm.assCode1 = aCreated[m].assessmentCode__c;
        oneAsm.Status1 = mapContact.get(aCreated[m].client__c).Client_Status__c;
        oneAsm.assBy1 = aCreated[m].Assessment_Completed_by__r.name;    
        oneAsm.Program1 = (mapContact.get(aCreated[m].client__c).p_c_id__c.left(3));    
        i++;
        k++;
        break;
      } 
      
     assList.add(oneAsm);
        if (listOfAssessments == '')
            listOfAssessments = aCreated[k].assessmentName__c.trim();
        else
            listOfAssessments+= ', ' + aCreated[k].assessmentName__c.trim();
            }
        numberOfAssessments = String.ValueOf(i);
        if (i > 4)
           manyRecords = true;
        
        allShow = assList;}
        
    } 
  public void showPage(){
    
  }

}