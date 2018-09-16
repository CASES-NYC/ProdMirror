public with sharing class printCIRTcontroller {
   public String IdPassed = System.currentPagereference().getParameters().get('selectedId');    
   public printCIRTcontroller(){
      if (IdPassed <> null){
        generateReport();}}
  //  Select id, (Select Defense_Attorney_Law_Guardian__c From Case_Information2__r) From Contact c   
   public string clientCell{get;set;}
   public string RelationOther{get;set;}
   public string RelclientCell{get;set;}
   public string dateprinted{get;set;}     
   public reportQuery rq = new reportQuery();
   public string clientName{get;set;}  
   public string nysid{get;set;}  
   public string dob{get;set;}
   public string gender{get;set;}  
   public string aka{get;set;}   
   public string refdate{get;set;}  
   public string attOutcome{get;set;}  
   public string attName{get;set;}  
   public string attCell{get;set;}  
   public string attPhone{get;set;} 
   public string attemail{get;set;}  
   public string attAddress{get;set;}  
   public string attAddress1{get;set;}  
   public string altAttName{get;set;}  
   public string altAttCell{get;set;}  
   public string altAttPhone{get;set;}
   public string altAttemail{get;set;}
   public string clientConsent{get;set;}  
   public string docket{get;set;}  
   public string indictment{get;set;}  
   public string bookcase{get;set;}  
   public Id accountId{get;set;}
   public string address{get;set;}
   public string moveDate{get;set;}
   public string phone{get;set;}
   public string rel2client{get;set;}
   public string attConsent{get;set;}   
   public string liveWith{get;set;} 
   public string ArrestDate{get;set;}
   public string BailCash{get;set;}
   public string BailBond{get;set;}
   public string ArrestNumber{get;set;} 
   public string TopArrestCharge{get;set;} 
   public string DOCscore{get;set;}
   public string CJAscore{get;set;}
   public string docRecomm{get;set;}
   public string caseId{get;set;}
   public string pleaCharges{get;set;}
   public string bailStatus{get;set;}
   public integer TotalPriorConvictions{get;set;}
   public integer PriorMisdConvictions{get;set;}
   public integer PriorFelonyConvictions{get;set;}
   public string Affiliation{get;set;}
   public string nextcourtdate{get;set;}
   public string nextcourtpart{get;set;}
   public string courtpart{get;set;}
   public string judge{get;set;}
   public string JudgeConditions{get;set;}
   public string caseJudge{get;set;}
   public date MandateCourtDate{get;set;}
   public string MandateCourtDateString{get;set;}
   public string CurrentTrack{get;set;}
   public string PriorViolentConvictionDate{get;set;}
   public string PriorViolentConvictionCharge{get;set;}
   public string plcodeViolence{get;set;}   
   public string parole{get;set;}
   public string probation{get;set;}
   public string PriorViolentConviction{get;set;}
   public string alternateContact{get;set;}
   public string firmname{get;set;}
   public string CoordinatorComments{get;set;}
   public string InmateLocation{get;set;}
   public ID intakeCaseId{get;set;}
   
   public List<clsDisplayEvents> lstCourts{get;set;}
   public List<clsDisplayEvents> lstOtherCases{get;set;}
   
   public class clsDisplayEvents{
      public string courtDate{get;set;}
      public string courtPart{get;set;}
      public string outcome{get;set;}
      public string notes{get;set;}
      public string docket{get;set;}
      public string attInfo{get;set;}
      public string arrestchg{get;set;}
      public string casestatus{get;set;}
      public string otherjudge{get;set;}}   
 
  public List<Event> lstEvents = new List<Event>();
  public void generateReport(){
      dateprinted = date.today().format();
      dob = '__/__/____';
      ArrestDate = '__/__/____'; 
      MandateCourtDateString = '__/__/____';
      CurrentTrack = '----------------';
      PriorViolentConvictionDate = '__/__/____';
      CoordinatorComments = 'none';
      lstEvents = new List<Event>();
      Id clientId;
      Map<Id, Contact> mapContact = rq.contactQuery(IdPassed);
       clientname = mapContact.get(IdPassed).firstname + ' ' + mapContact.get(IdPassed).lastname;        
       bookcase = mapContact.get(IdPassed).BOOK_CASE__c;
       gender = mapContact.get(IdPassed).Gender_CC__c;
       aka = '';
      if (mapContact.get(IdPassed).aka_1__c != null)
         aka = mapContact.get(IdPassed).aka_1__c;
      if (mapContact.get(IdPassed).aka_2__c != null)
         if (aka != '' )
            aka = aka + ', ' + mapContact.get(IdPassed).aka_2__c;
         else   
            aka = mapContact.get(IdPassed).aka_2__c;
      if (mapContact.get(IdPassed).aka_3__c != null)
         if (aka != '' )
            aka = aka + ', ' + mapContact.get(IdPassed).aka_3__c;
         else   
            aka = mapContact.get(IdPassed).aka_3__c;
         CoordinatorComments = mapContact.get(IdPassed).Resource_Coordinator_s_Comments__c;     
      clientId = mapContact.get(IdPassed).id;    
      DOCscore = string.valueOf(mapContact.get(IdPassed).DOC_Risk_Score__c);
      CJAscore =  string.valueOf(mapContact.get(IdPassed).CJA_Score__c);    
      accountId = mapContact.get(IdPassed).accountId;
 //     liveWith = mapContact.get(IdPassed).Lives_With__c ; 
      rel2client = mapContact.get(IdPassed).Relation_to_client__c;
       //refdate = mapContact.get(IdPassed).Referred_On__c.format();
       // changed to CreatedDate
       refdate = date.valueof(mapContact.get(IdPassed).CreatedDate).format();
       attOutcome = mapContact.get(IdPassed).Attorney_Consent__c;
       docRecomm = mapContact.get(IdPassed).DOC_Recommendation__c;
      Judge = mapContact.get(IdPassed).Judge_formula__c;
      JudgeConditions = mapContact.get(IdPassed).Judge_s_Conditions__c; 
    //  clientCell = mapContact.get(idPassed).Client_Cell_Phone__c; 
   //   RelclientCell = mapContact.get(idPassed).Client_Cell_Phone__c;
      if (mapContact.get(IdPassed).Attorney_Consent_Description__c != null)
         attConsent = mapContact.get(IdPassed).Attorney_Consent__c + ' ' + 
               mapContact.get(IdPassed).Attorney_Consent_Description__c;
      else   attConsent = mapContact.get(IdPassed).Attorney_Consent__c; 
      MandateCourtDate = mapContact.get(IdPassed).Mandate_Decision_Date__c;
       if (MandateCourtDate != null)     
          MandateCourtDateString = MandateCourtDate.format();    
       if (mapContact.get(IdPassed).Current_Track__c != null)      
          CurrentTrack = mapContact.get(IdPassed).Current_Track__c;
       if (mapContact.get(IdPassed).Prior_Violent_Conviction_Date__c != null)
           PriorViolentConvictionDate = mapContact.get(IdPassed).Prior_Violent_Conviction_Date__c.format();   
       Id ChargeId = mapContact.get(IdPassed).Prior_Violent_Conviction_Charge__c;
       if (chargeId != null)
         PriorViolentConvictionCharge = rq.mapCodes(chargeId);
         
       InmateLocation = mapContact.get(IdPassed).Inmate_Location__c ;  
     //  Id attId = mapContact.get(IdPassed).attorney_formula__c;
       
       attname = mapContact.get(IdPassed).attorney_formula__c;
       intakeCaseId = mapContact.get(IdPassed).intake_case__c;
       
       Id altAttContact = mapContact.get(IdPassed).Supervising_Attorney__c;
       parole = 'No';
       probation = 'No';
       if (mapContact.get(IdPassed).Criminal_Justice_Involvement__c == 'Parole')
          parole = 'Yes';
       if (mapContact.get(IdPassed).Criminal_Justice_Involvement__c == 'Probation')
          probation = 'Yes';
       PriorViolentConviction =  mapContact.get(IdPassed).Prior_Violent_Conviction__c;   
        Map<Id, Account> mapAccount = rq.accountQuery(accountId);
        bailstatus = mapContact.get(IdPassed).Detention_Status_at_Intake__c;
  
        PriorFelonyConvictions = integer.valueOf(mapContact.get(IdPassed).Prior_Felony_Convictions__c);
        TotalPriorConvictions = integer.valueOf(mapContact.get(IdPassed).Total_Prior_Convictions__c);       
        PriorMisdConvictions = integer.valueOf(mapContact.get(IdPassed).Prior_Misdemeanor_Convictions__c);
        if (mapContact.get(idPassed).Date_of_Birth__c !=null)
              dob = mapContact.get(idPassed).Date_of_Birth__c.format();

        if (mapAccount.get(accountId).nysid_number__c <> null)
           nysid = mapAccount.get(accountId).nysid_number__c;
 
      Id attId;
      
    
   //    List<Contact> lstLegalIds = rq.lstLegalId(attname);
   //    for (Contact c : lstLegalIds){
    //      attId = c.id; 
     //  }
    //        System.Debug('\n\n XXX attname: ' + attname + 
     //  ' attId: ' + attId);
        attId = rq.attInfo(intakeCaseId);
        if (attId != null){
         mapContact = rq.contactQuery(attId);
         Id attAccountId = mapContact.get(attId).accountId;
         System.Debug('\n\n XXX attAccountId: ' + attAccountId);
         mapAccount = rq.accountQuery(attAccountId);
         firmname = mapAccount.get(attAccountId).name;
         attAddress = '';
         attAddress1 = '';
         if (mapAccount.get(attAccountId).BillingStreet != null)
            attAddress = mapAccount.get(attAccountId).BillingStreet;
        if (mapAccount.get(attAccountId).billingCity != null)
            attAddress1 =  mapAccount.get(attAccountId).billingCity;
          if (mapAccount.get(attAccountId).billingState != null)
            attAddress1 = attAddress1 + ', ' + mapAccount.get(attAccountId).billingState;
          if (mapAccount.get(attAccountId).BillingPostalCode != null)
            attAddress1 = attAddress1 + ' ' + mapAccount.get(attAccountId).BillingPostalCode;}
  //    List<Case_Information__c> lstCase = rq.caseInfoQuery(IdPassed);
      List<Case_Information__c> lstCase = rq.caseInfoQueryByCaseId(accountId,intakecaseId);
      integer i = 1;
  //return;
      for (Case_Information__c ci : lstCase){  
         docket = ci.name;
         indictment = ci.Indictment__c;
         bailcash = '$' + convertDecimalToCurrency(ci.Bail_Set_Cash__c);
         bailbond = '$' + convertDecimalToCurrency(ci.Bail_Set_Bond__c);
         
         if (ci.Arrest_Date__c != null)
            ArrestDate = ci.Arrest_Date__c.format(); 
         ArrestNumber  = ci.Arrest_Number__c ;
         TopArrestCharge = ci.Top_Arrest_Charge__c;
         Affiliation = ci.Affiliation__c;
     //    PriorFelonyConvictions = integer.valueOf(ci.Prior_Felony_Convictions__c);
     //    TotalPriorConvictions = integer.valueOf(ci.Total_Prior_Convictions__c);
    //     PriorMisdConvictions = integer.valueOf(ci.Prior_Misdemeanor_Convictions__c);
    ///////////
        if (ci.judge__c != null)
            caseJudge = rq.mapNames(ci.judge__c);
      //
         caseId = ci.id;
      break;}
      
     string chargetype = 'Criminal Court Arraignment Charges';
     pleaCharges = rq.Charges(caseid, chargetype)  ;   
     address = '';
     List<Address_Information__c> listAddress = rq.addressQuery(idPassed );
     
     for (Address_Information__c a : listAddress){
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
         phone = a.Home_Phone__c;   
         liveWith = a.Contact_Person__c;
         RelclientCell = a.cell_phone__c;
         rel2client = a.Relation_to_client__c;     
         if (rel2client == 'Other') 
            rel2client = a.Relation_to_client__c +  '(' + a.Relation_to_Client_Other__c + ')';    
              
      break;}
      
  //return;    
      system.debug('\n\n XXX attId: ' + attId);
     Map<Id, Contact> mapJudge = rq.contactQuery(attId);
      if (attId != null){
         attPhone = mapJudge.get(attId).Phone;
         attCell = mapJudge.get(attId).MobilePhone;
         attemail = mapJudge.get(attId).Email;
//         attname = mapJudge.get(attId).firstname + ' '  + mapJudge.get(attId).lastname;
       if (altAttContact != null){   
        mapJudge = rq.contactQuery(altAttContact);
         altAttPhone = mapJudge.get(altAttContact).Phone;
         altAttCell = mapJudge.get(altAttContact).MobilePhone;
         altAttemail = mapJudge.get(altAttContact).Email;
         altAttname = mapJudge.get(altAttContact).firstname + ' '  + mapJudge.get(altAttContact).lastname;} 
        
      }
      
 /////
//     List<Event> listEvents = rq.eventQuery(IdPassed);
/////////////
 
   //  List<Event> listEvents = rq.eventQuery(CaseId);

      List<Event> listEvents = rq.eventQuery(intakeCaseId);
      
      System.Debug('\n\n XXX listEvents: ' + listEvents.size());
      clsDisplayEvents oneRecord = new clsDisplayEvents();
      lstCourts = new List<clsDisplayEvents>();
      Id EventRecTypeId = Utility_ID__c.getValues('Court Date').RecordType_Id__c;
      date nextCourt;
      i = 0;
      for (Event e :listEvents) {
           if (MandateCourtDateString != '__/__/____' && MandateCourtDate == e.activitydate)
                courtpart = e.Part__c; 
           if (e.RecordTypeId == EventRecTypeId && e.activitydate >= date.today()){
        
              oneRecord = new clsDisplayEvents();
              oneRecord.courtPart = e.Part__c;
              oneRecord.courtDate = e.activitydate.format();
              oneRecord.Outcome = e.Outcome__c;
              oneRecord.notes = e.Description;
              for (Case_Information__c ci :lstCase){
///   changes                  if (e.whatid == ci.id && e.whoid == clientid){
                if (e.whatid == ci.id){
                      oneRecord.docket = ci.name;
                      break;}}
              lstCourts.add(oneRecord);
              
              System.DEbug('\n\n XXX MandateCourtDate: ' + MandateCourtDate + 
              '   ' +  'activity date: ' + e.activitydate);
//              if (MandateCourtDateString != '__/__/____' && MandateCourtDate == e.activitydate)
 //            if (i == 0)
  //              courtpart = e.Part__c; 
              if (e.activitydate >  MandateCourtDate && i == 0)  {
                  nextCourtDate = e.activitydate.format();
                  nextcourtpart = e.Part__c;
                 i++;}}
       }  
       chargetype = 'Arrest Charges';
       string ctype = 'Intake Case';
       oneRecord = new clsDisplayEvents();
       lstOtherCases = new List<clsDisplayEvents>();
 //      Id crimRecTypeId = Utility_ID__c.getValues('Intake Case - Criminal Court').RecordType_Id__c;
   //    Id suprRecTypeId = Utility_ID__c.getValues('Intake Case - Supreme Court').RecordType_Id__c;
 
       Id crimRecTypeId = Utility_ID__c.getValues('Case - Criminal Court').RecordType_Id__c;
       Id suprRecTypeId = Utility_ID__c.getValues('Case - Supreme Court').RecordType_Id__c;
       Id otherIudgeId;   
       
       
      listEvents = rq.eventQuery(CaseId);
       for (Case_Information__c ci :lstCase) {
          
           oneRecord = new clsDisplayEvents();
///////////
//          if (ci.case_type__c == 'Open' && ci.RecordTypeId != crimRecTypeId && ci.RecordTypeId != suprRecTypeId){
/////////
     //     if (ci.RecordTypeId != crimRecTypeId && ci.RecordTypeId != suprRecTypeId){
   //       if (ci.RecordTypeId != crimRecTypeId && ci.RecordTypeId != suprRecTypeId){
            oneRecord.docket = ci.name;
            
            IF(ci.id <> intakecaseid){
            if (ci.Indictment__c != null)
               oneRecord.docket = ci.name + ' / ' + ci.Indictment__c;
             oneRecord.casestatus = ci.Current_Case_Status__c;
//             CASES status changed by MB request 03/13/2014    
    //           oneRecord.casestatus = ci.Interview_Notes__c; 
             caseId = ci.id;
             oneRecord.arrestchg = ci.Top_Arrest_Charge__c;
             mapJudge = rq.contactQuery(ci.Defense_Attorney_Law_Guardian__c);
        //     oneRecord.otherJudge = mapJudge.get(ci.Defense_Attorney_Law_Guardian__c);
        if (ci.Defense_Attorney_Law_Guardian__c != null)
             oneRecord.otherJudge = mapJudge.get(ci.Defense_Attorney_Law_Guardian__c).firstname + ' '  + mapJudge.get(ci.Defense_Attorney_Law_Guardian__c).lastname; 
         ///////////
         //    clientId = ci.client__c;
         ////////
            lstOtherCases.add(oneRecord);}}//}  
   }
   
   
     public string convertDecimalToCurrency(decimal input ){
       string s = string.valueof(input);
       if (input == null )
           return '0.00';
       decimal d1 = decimal.valueOf(s).setScale(2);
       String str = d1.format();
       return str;}
}