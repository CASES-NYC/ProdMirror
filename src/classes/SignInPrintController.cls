public with sharing class SignInPrintController {
 //  Public String strPassed = System.currentPagereference().getParameters().get('passPar');  
   Public String boroPassed = System.currentPagereference().getParameters().get('passBoro');  
 
   Public String strFrom = System.currentPagereference().getParameters().get('passedFrom');  
   Public String strTo = System.currentPagereference().getParameters().get('passedTo');  
 //  Public String printPassed = System.currentPagereference().getParameters().get('passedPrint');  
 
     
 
   public Id conClient =  Utility_ID__c.getValues('CEP Client').RecordType_Id__c;
   public Id eventRecordType = Utility_ID__c.getValues('Case Coordination').RecordType_Id__c;
 //  public ApexPages.StandardSetController setController { get; set; }   
   public string currentDate{get;set;}
   public string From_To{get;set;}
   public UtilityTimeMethods ut = new UtilityTimeMethods();   
   public string selectedBoro{get;set;}
   public Event proxyObject {get; set;}
   public string boro{get;set;}
   public date getTodayDate(){
      date d = date.today();
      return d;
   }
   
   public string getDayofWeek(){
      dateTime dt = Datetime.newInstance(proxyObject.ActivityDate, Time.newInstance(0,0,0,0));
      return dt.format('EEEE');
   }
   public SignInPrintController(){
       currentDate = date.today().format(); 
       if ( strFrom == strTo)
          from_to = strFrom;    
       else
          from_to = '  ' + strFrom + ' - ' + strTo;    
         system.debug('\n\n XXX ***Constructor***');
        Event e = new Event();
        e.Open_Date__c = date.parse(strFrom);
        e.Closing_Date__c = date.parse(strTo);
        proxyObject = e;   
//          lstEventsReportShow = ReportData();
        ReportData();
   }  
  
   public class clientsEvents{
      public string schedtimestr{get;set;}     
      public string VerifiedBy{get;set;}   
      public string VerifiedOn{get;set;}        
      public Id contactId {get;set;}
      public string whatid {get;set;}     
      public string cname {get;set;}     
      public String namecolor{get;set;} 
      public String color{get;set;}              
      public String backcolor{get;set;}
      public string rowNumber{get;set;}     
      public string rowNumber_B{get;set;}     
      public string rowNumber_H{get;set;}     
      public string RepBoro{get;set;}  
      public string Boro{get;set;}  
      public string verstatus{get;set;}         
      public string timein{get;set;}         
      public string timeout{get;set;}         
      public boolean signIn{get;set;}        
      public boolean repeatName{get;set;}        
      public boolean scheduled{get;set;}}


   //  public boolean BrooklynData{get;set;} 
     
     boolean BrooklynData{get;set;}
     public boolean getBrooklynData(){
        return BrooklynData;} 
     public void setBrooklynData(boolean BrooklynData){
        this.BrooklynData = BrooklynData;}            
       
     public boolean HarlemData{get;set;}   
//  date selectedDate{get;set;}  
  String[] intakeStatus = new List<String>{'Active','On Program Hold','Intaked - Not Yet Active'};     


      
   //  public List<clientsEvents> lstEventsReportShow{get;set;}
     public List<clientsEvents> lstReportBrooklyn{get;set;}  
     public List<clientsEvents> lstReportHarlem{get;set;}     
   
   public void ReportData() {
 //   string boro = selectedboro;
    system.debug('\n\n XXX in print'); 

      Set<String> contIds = new  Set<String>();  
      Set<String> contId_inEvent = new  Set<String>();  
      List<clientsEvents> lstEventsReportBrooklyn = new List<clientsEvents>();  
      List<clientsEvents> lstEventsReportHarlem = new List<clientsEvents>();
  
     List<clientsEvents> lstEvents = new List<clientsEvents>();    
     clientsEvents oneRecord = new clientsEvents();
     date dintake;
     integer nRow = 1;
     integer nRow_B = 1;
     integer nRow_H = 1;
     string status;
  
     List<Contact> lstContacts = new  List<Contact>();
      List<Contact> lstContacts1 = [select id,Reporting_Borough__c,Current_Intake_Date__c,name,
         Client_Status__c from contact where recordtypeid =: conClient 
         and Client_Status__c in: intakeStatus and
         Current_Intake_Date__c <= : proxyObject.Closing_Date__c order by name,Reporting_Borough__c]; 
   
     boro = boroPassed;
     for (Contact cont :  lstContacts1){
             lstContacts.add(cont);
            contIds.add(cont.id);
     }
     
     system.Debug('\n\n XXX lstContacts: ' + lstContacts);
      List<Event> lstEventsRep = [select id, who.name, subject, activitydatetime, activitydate,whatid,  
         DurationInMinutes, verification_status__c, whoid, Time_In__c, Time_Out__c,Verified_By__c, 
         Verification_Date__c from event where whoid in: contIds and activitydate >=: proxyObject.Open_Date__c 
         and activitydate <=: proxyObject.Closing_Date__c and subject =: 'Program Reporting'
         and recordtypeid =: eventRecordType AND (recurrenceType =: null or isrecurrence = false) 
         order by who.name,activitydate];   
      
     System.Debug('\n\n YYY lstEventsRep: ' + lstEventsRep.Size() + ' boroPassed: ' + boroPassed);
     string contId,cname;
     integer poz;
     boolean repeat; 
     for (integer c = 0; c < lstContacts.size(); c++ ){
         contId = lstContacts[c].Id;
         cname = lstContacts[c].name;
         repeat = true;
         if (lstContacts[c].Reporting_Borough__c == 'Brooklyn')
             brooklynData = true;
          else
             HarlemData = true;
         for (integer e = 0; e < lstEventsRep.Size(); e++){
            oneRecord = new clientsEvents();
            if (lstEventsRep[e].whoid == contId){ 
//            oneRecord = new clientsEvents();
              if (repeat == true)
                 oneRecord.repeatName = true;
                 oneRecord.cname = lstContacts[c].name;
                 oneRecord.schedtimestr = string.valueof(lstEventsRep[e].activitydatetime.format());
                 if (lstEventsRep[e].Verified_By__c != null){
                    poz = (lstEventsRep[e].Verified_By__c).indexOf(' ', 1);
                    oneRecord.VerifiedBy =  (lstEventsRep[e].Verified_By__c).substring(0,poz);}
                 if (lstEventsRep[e].Verification_Date__c != null)
                    oneRecord.VerifiedOn = lstEventsRep[e].Verification_Date__c.format();
                    if (lstContacts[c].Reporting_Borough__c == 'Queens'){
                       oneRecord.RepBoro = 'Harlem' ;
                       oneRecord.boro = 'Q';
                    }  
                    else{     
                       oneRecord.RepBoro = lstContacts[c].Reporting_Borough__c ;
                       oneRecord.boro = lstContacts[c].Reporting_Borough__c.substring(0,1);
                    }
                    oneRecord.verStatus = lstEventsRep[e].Verification_Status__c; 
                    oneRecord.timein = lstEventsRep[e].Time_In__c;             
                    oneRecord.timeout = lstEventsRep[e].Time_out__c; 
//             oneRecord.rowNumber = string.valueOf(nRow).trim();
                    if (oneRecord.RepBoro == 'Brooklyn'){
                       oneRecord.rowNumber = string.valueOf(nRow_B).trim();
                       lstEventsReportBrooklyn.add(oneRecord);
                       nRow_B++;
                    }
                    else{
                       oneRecord.rowNumber = string.valueOf(nRow_H).trim();
                       lstEventsReportHarlem.add(oneRecord);
                       nRow_H++;
                    }
             System.Debug('\n\n YYY oneRecord.RepBoro: '+oneRecord.RepBoro);
             repeat = false;
             }
            }
     }
     lstReportBrooklyn = lstEventsReportBrooklyn;
     lstReportHarlem = lstEventsReportHarlem;
     System.Debug('\n\n YYY lstEventsReportHarlem: '+lstEventsReportHarlem.Size());
//     return lstEvents;  
   }


}