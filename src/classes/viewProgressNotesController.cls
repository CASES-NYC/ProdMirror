public with sharing class viewProgressNotesController {
    public String strClientId = System.currentPagereference().getParameters().get('clientId');  
//    public Contact c {get;set;}
    public string cName {get;set;} 
    public string program{get;set;}
    public string clientId{get;set;}
    string clientId15;
    string contactProgram;
 // public Contact c {get;set;}
  //  public list<Progress_Note__c> lstPN {get;set;}
    string recTypeId;
    public string noteValue{get;set;}
  public class clsNotes{
    public string notesDate{get;set;}
    public string notesArea{get;set;}
    public string notesName{get;set;}
    public string notes{get;set;}
    public string pcid{get;set;}
    public string clientid{get;set;}
    public string status{get;set;}    
    public string notesby{get;set;}
    public string backcolor{get;set;}
    public string tiptext{get;set;}
    public boolean otherProgram{get;set;}    
    public string notesID{get;set;}
  }
  SET<string> setContactIds15 = new SET<string>();
  SET<string> setContactIds = new SET<string>();
  List<clsNotes> allNotes;
  public List<clsNotes> lstShowNotes{get;set;}
 List<clsNotes> notes;
  public List<SelectOption> noteItems{get;set;}
  Map<id,string> mapStatus;
  void createnoteItems(){
     List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('All', 'All'));
      for (RecordType rt : [select id,name from RecordType
       where id in: allNotesRecordId order by name]){
    //    if (rt.name.contains('Note'))
           options.add(new SelectOption(rt.name, rt.name));
 //          options.add(new SelectOption(rt.id, rt.name));
      }
      noteItems = options;}
 string clientAccount;     
 public string areaValue{get;set;}
 public List<SelectOption> areaItems{get;set;}

    ////////////////////////////////
    // Constructor
    ////////////////////////////////
    Set<string> allNotesRecordId = new  Set<string>();
    public viewProgressNotesController() { 
        noteValue = 'All';
        areaValue = 'All';
        system.debug(strClientId);
        for(Progress_Note__c p : [select recordTypeId from Progress_Note__c 
        where Client_id__c = :strClientId or Client_id__c =: clientId15 order by area__c]){
        allNotesRecordId.add(p.recordTypeId);} 
        createnoteItems();
        Contact c = [select id, Name, P_C_ID__c,accountId from Contact where id = :strClientId limit 1];
        clientAccount = c.AccountId;
        cname = c.Name;
        integer k = (c.P_C_ID__c.trim()).length();
        integer m = k - 4;
        program = (c.P_C_ID__c).substring(0,3);
        contactProgram = c.P_C_ID__c.left(3);
        clientId = (c.P_C_ID__c).mid(5,k);
        defaultSelection();   
        createAreaItems();
  
    }
    public pageReference  doNothing(){return null;}

    public void shownotes(){
     notes = new List<clsNotes>();
    clsNotes oneNote = new clsNotes();
    boolean addProgNote;
    string cid = strClientId;
    List<Progress_Note__c> lstNotes = new List<Progress_Note__c>();
    string strQuery = 'select id, Progress_Note__c, Area__c, Written_by__c, Client_id__c,' + 
       ' RecordType.Name, Date__c, Activity_Date__c, CreatedBy.Name,recordTypeId from Progress_Note__c ' +
       ' where (Client_id__c = : setContactIds15 or Client_id__c =:setContactIds) ';
    string cWhere = '';
    if (noteValue != 'All')
      cWhere = ' and RecordType.Name =: noteValue';
    if (areaValue != 'All')
         cWhere += ' and area__c =: areaValue ';
    if (cWhere != '')
       strQuery += cWhere;
    strQuery += ' order by Activity_Date__c desc'  ; 
    lstNotes = Database.Query(strQuery);
     for (Progress_Note__c n : lstNotes) {           
         oneNote = new clsNotes();
         onenote.notesDate = n.Activity_Date__c.format();
         onenote.notes = n.Progress_Note__c;
         onenote.notesName = n.RecordType.Name;  
         onenote.notesArea = n.area__c;
         onenote.notesby = n.Written_by__c;
         onenote.notesID = n.id;
         onenote.pcid = mapPCID.get(n.Client_id__c);
         onenote.clientid = n.Client_id__c;
         notes.add(oneNote);
         }
         lstShowNotes = notes;
    }
     Map<string,string> mapPCID;
    public void defaultselection(){
      allNotes = new List<clsNotes>();
    clsNotes oneNote = new clsNotes();
    string id15;
    integer k;
    integer m ;
    string cid;
    Map<id,string> mapStatus = new Map<id,string>();
    mapPCID = new Map<string,string>();
    for (Contact lstContacts : [select id,P_C_ID__c,accountId,Client_Status__c from Contact where accountId =: clientAccount]){ 
    cid = lstContacts.id;
       id15 = cid.substring(0,15);
       setContactIds15.add(id15);
       setContactIds.add(cid);
       mapPCID.put(id15,lstContacts.P_C_ID__c);
       mapStatus.put(id15,lstContacts.Client_Status__c);
   }    
   
   System.Debug('\n XXX setContactIds15: ' + setContactIds15+ ' clientAccount: ' + clientAccount);
/*    
    for(Progress_Note__c lstNotes : [select id, Progress_Note__c, Area__c, Written_by__c, 
       RecordType.Name, Date__c, Activity_Date__c, CreatedBy.Name
           from Progress_Note__c where Client_id__c = :strClientId order by Activity_Date__c desc]){
 */ 
    string program,status;
    for(Progress_Note__c lstNotes : [select id, Progress_Note__c, Area__c, Written_by__c, Client_id__c,
       RecordType.Name, Date__c, Activity_Date__c, CreatedBy.Name
           from Progress_Note__c where Client_id__c in: setContactIds15
           or Client_id__c in: setContactIds order by Activity_Date__c desc]){
         oneNote = new clsNotes();
         onenote.notesDate = '';
         oneNote.backcolor = 'white';
         onenote.otherProgram = false;
         oneNote.tiptext = '';
         if (lstNotes.Activity_Date__c != null)
            onenote.notesDate = lstNotes.Activity_Date__c.format();
         onenote.notes = lstNotes.Progress_Note__c;
         onenote.notesName = lstnotes.RecordType.Name;  
         onenote.notesArea = lstNotes.area__c;
         onenote.notesby = lstNotes.Written_by__c;
         onenote.pcid = mapPCID.get(lstNotes.Client_id__c);
         program = onenote.pcid.left(3);
         oneNote.tiptext = program;
         if (program <> contactProgram)
            onenote.otherProgram = true; 
         onenote.notesID = lstNotes.id;
         status = mapStatus.get(lstNotes.Client_id__c);
         if (status != 'Active')
            oneNote.backcolor = '#FFFF99';
            onenote.status = mapStatus.get(lstNotes.Client_id__c);
         onenote.clientid = lstNotes.Client_id__c;
         allNotes.add(oneNote);}
         lstShowNotes = allNotes;}
  
    public void createAreaItems(){
      Set<String> setAreaadded = new Set<String>();
      List<SelectOption> areaItems1 = new List<SelectOption>();
      areaItems1.add(new SelectOption('All', 'All'));
      for (integer i = 0; i < allNotes.Size(); i++){
        if (allNotes[i].notesArea <> null){
        if (setAreaadded.contains(allNotes[i].notesArea) == false && 
           (noteValue.trim() == 'All' || allNotes[i].notesName.trim() == noteValue)){
           areaItems1.add(new SelectOption(allNotes[i].notesArea,allNotes[i].notesArea));
           setAreaadded.add(allNotes[i].notesArea);}}
      }
       areaItems = areaItems1;
        }
   }