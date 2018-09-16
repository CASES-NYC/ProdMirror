public class reportQuery {

    public Map<Id, Account> accountQuery(ID accountId){
       Map<Id, Account> mapAccount = new Map<Id, Account>
        ([select nysid_number__c, DOB__c, name, fax,contact_person__c, contact_person_email__c,
        cell_phone__c, billingstreet, billingstate, billingcity, billingpostalcode,
        Last_Name__c, First_Name__c from account where id =: accountId]);
        return mapAccount;}
public Map<Id, contact> contactQueryIDstring(string contactid){
       Map<Id, Contact> mapContact = new Map<Id, Contact>
    ([select firstname, lastname, accountid, Date_of_Birth__c,name,Current_Intake_Date__c,Most_Recent_Program_Plan__c,
    P_C_ID__c,Intake_Date__c,Case_coordinator__r.Name,current_exit_date__c,
    Borough_of_Intake_Formula__c
     from Contact where id =: contactid]);
       return mapContact;}
public Map<Id, Contact> contactQueryContCase(ID clientId,ID caseId){ 
    Map<Id, Contact> mapContact = new Map<Id, Contact>
    ([select firstname, lastname, accountid, Date_of_Birth__c,Most_Recent_Program_Plan__c,
      BOOK_CASE__c, Gender_CC__c,aka_1__c, 
      aka_2__c,aka_3__c,Lives_With__c,
       Relation_to_client__c, Referral_date__c,Attorney_Consent__c, 
       Attorney_Consent_Description__c,attorney_formula__c,
       DOC_Risk_Score__c, CJA_Score__c,DOC_Recommendation__c,Judge_formula__c,Next_Court_Date__c,
       Judge_s_Conditions__c,Mandate_Decision_Date__c,Current_Track__c,
       Phone, Email, Cell_Phone__c,Client_Cell_Phone__c,
       Prior_Violent_Conviction_Date__c, Prior_Violent_Conviction_Charge__c,
       Criminal_Justice_Involvement__c,Prior_Violent_Conviction__c,MobilePhone,
       Supervising_Attorney__c, Resource_Coordinator_s_Comments__c,
       Inmate_Location__c,CreatedDate,Detention_Status_at_Intake__c,
       Prior_Misdemeanor_Convictions__c, Prior_Felony_Convictions__c,
       Total_Prior_Convictions__c, intake_case__c,Case_Coordinator__c
       from Contact where id =: clientId and intake_case__c =: caseId]);
       return mapContact;}
  
      public List<Contact> listContactByAccountId(ID accountId){
       List<Contact> lstContactByAccount = new List<Contact>(
       [select accountId, id from contact where accountId =: accountId]);
       return lstContactByAccount;}
       
      public List<Case_Information__c> caseInfoQuery(ID accountId){
          List<Case_Information__c> lstCase = new List<Case_Information__c>(
         [select name, Indictment__c, Arrest_Date__c, 
           Bail_Set_Cash__c, Bail_Set_Bond__c,Arrest_Number__c,
           Top_Arrest_Charge__c,
           Probation_Officer__c, Parole_Officer__c, Affiliation__c,Current_Case_Status__c,
           Judge__c,RecordTypeId,
           Defense_Attorney_Law_Guardian__c from Case_Information__c  
           where client_account__c  =: accountId] );
    return lstCase;}       
    
          public List<Case_Information__c> caseInfoQueryByCaseId(ID accountId, ID intakecase){
          List<Case_Information__c> lstCase = new List<Case_Information__c>(
         [select name, Indictment__c, Arrest_Date__c, 
           Bail_Set_Cash__c, Bail_Set_Bond__c,Arrest_Number__c,part__c,
           Top_Arrest_Charge__c,
           Probation_Officer__c, Parole_Officer__c, Affiliation__c,Current_Case_Status__c,
           Judge__c,RecordTypeId,
           Defense_Attorney_Law_Guardian__c from Case_Information__c  
           where client_account__c  =: accountId and id =: intakecase]);
    return lstCase;}       
    
    
 
   public List<Event> eventQuery(ID caseId){
      List<Event> lstEvent = new List<Event>([select activityDate,Part__c,Outcome__c,
      court_date_type__c, Description,recordtypeid, Judge_If_other_than_Assigned_Judge__c, 
      whoid, whatid,subject
       from Event where whatid =: caseId order by activitydate ]); 
      return lstEvent;}
   
    public string mapNames(Id cid){
        Map<Id, Contact> mapNames = new Map<Id, Contact>([select firstname, lastname 
           from contact where id =: cId]); 
        return mapNames.get(cId).firstname + ' ' + mapNames.get(cId).lastname;}

     public Id attInfo(Id caseId){
       Id attId;
        for (Case_Information__c ci : [Select Defense_Attorney_Law_Guardian__c,indictment__c,
        name From Case_Information__c  where id =: caseId]){
           attId = ci.Defense_Attorney_Law_Guardian__c;
           break;}
       return attId;} 
     
     public string caseName(ID caseid){
         string cname = '';
          for (Case_Information__c ci : [Select name From Case_Information__c  where id =: caseId]){  
            cname = ci.name;}
         return cname;}
    public Map<Id, Case_Information__c> caseQuery(Id caseid){
       Map<Id, Case_Information__c> caseInfo = new Map<Id, Case_Information__c>
      ([Select name,Defense_Attorney_Law_Guardian__c,indictment__c,part__c,
       recordtypeid From Case_Information__c
        where id =: caseId]);
       return caseInfo;
    }
         
   public string Charges(string caseid, string caseType){
       if (caseid == null || caseid == '')
          return null;
      Set<Id> chargesId = new Set<Id>();
      List<Case_Charges__c> lstCharges = new List<Case_Charges__c>
      ([select Charge__c from case_charges__c where docket_no__c =: caseId 
        and type__c =: caseType limit 20]);
      if (lstCharges.Size() == 0)
         return null;  
      for (Case_Charges__c chg : lstCharges){  
            chargesId.add(chg.Charge__c);}
     string Charges = ''; 
     List<Penal_Code__c> lstCodes = new  List<Penal_Code__c>
       ([select id,name From Penal_Code__c where id in: chargesId]);
     for (Penal_Code__c pl : lstCodes){
           if (Charges != '')
            Charges += ', ' + pl.name;
        else 
          Charges = pl.name;}
       return charges;}  
     
    public string mapCodes(Id chargeId){ 
       Map<Id, Penal_Code__c> mapcodes = new Map<Id, Penal_Code__c>([select id,name From Penal_Code__c
           where id =: chargeId]); 
        return mapCodes.get(chargeId).name;}
     
     public List<Address_Information__c> addressQuery(ID clientId){
       List<Address_Information__c> lstAddress = new List<Address_Information__c>([
       Select Home_Phone__c, Contact_Person__c, City__c, Building_No__c,City_Formula__c,
       State_Formula__c,zip_code__c,Apt_No__c, Address__c, state__c, zip__c,street__c, Move_In_Date__c,
           Relation_to_client__c, Relation_to_Client_Other__c,Address_Type__c, 
           Cell_Phone__c From Address_Information__c 
             where client__c =: clientId]);
       return lstAddress;} 
  

    public List<Address_Information__c> addressListQuery(Set<string> clientIds){
       List<Address_Information__c> lstAddress = new List<Address_Information__c>([
       Select client__c,Home_Phone__c, Contact_Person__c, City__c, Building_No__c,City_Formula__c,
       State_Formula__c,zip_code__c,Apt_No__c, Address__c, state__c, zip__c,street__c, Move_In_Date__c,
           Relation_to_client__c, Relation_to_Client_Other__c,Address_Type__c, 
           Cell_Phone__c From Address_Information__c 
             where client__c in: clientIds and Address_Type__c =: 'Primary']);
       return lstAddress;} 



   public Map<Id, Contact> contactQuery(ID clientId){ 
      Map<Id, Contact> mapContact1 = new Map<Id, Contact>
      ([select firstname, lastname, accountid, Date_of_Birth__c,name,nysid__c,Client_Status__c,Screening_Stage__c,
      BOOK_CASE__c, Gender_CC__c,aka_1__c, Case_Coordinator__c,Interview_Stage__c,Most_Recent_Program_Plan__c,
      aka_2__c,aka_3__c,Lives_With__c,Intake_Date__c,HomePhone,
       Relation_to_client__c, Referral_date__c,Attorney_Consent__c, 
       Attorney_Consent_Description__c,attorney_formula__c,Borough_of_Intake_Formula__c,
       DOC_Risk_Score__c, CJA_Score__c,DOC_Recommendation__c,Judge_formula__c,Next_Court_Date__c,
       Judge_s_Conditions__c,Mandate_Decision_Date__c,Current_Track__c,
       Phone, Email, Cell_Phone__c,Client_Cell_Phone__c,Case_Coordinator__r.Name,
       Prior_Violent_Conviction_Date__c, Prior_Violent_Conviction_Charge__c,
       Criminal_Justice_Involvement__c,Prior_Violent_Conviction__c,MobilePhone,
       Supervising_Attorney__c, Resource_Coordinator_s_Comments__c,
       Inmate_Location__c,CreatedDate,Detention_Status_at_Intake__c,
       Prior_Misdemeanor_Convictions__c, Prior_Felony_Convictions__c,
       Total_Prior_Convictions__c, intake_case__c,P_C_ID__c,id, Intake_Court_Formula__c
       from Contact where id =: clientId]);
       return mapContact1;}
       
   public Id progInfo(Id progId){
       Id clientId;
        for (Program_Plan__c p : [Select Client_name__c, id
           From Program_Plan__c  where id =: progId]){
           clientId = p.Client_name__c;
           break;}
       return clientId;}        
       
    public MAP<id,Program_Plan__c>  PP_Query(Id progId){  
        MAP<id,Program_Plan__c>  mapPP = new  MAP<id,Program_Plan__c>
        ([  Select p.Client_Name__r.Name, p.Client_Name__c,p.id,p.name From Program_Plan__c p 
         where current_diagnosis_new__c != null or jail_based_diagnosis_new__c != null]);
        return mapPP;}  
    public string userNames (string cid){
        string cname;
        for (User u : [select id,name from user where id =: cid]){
            cname = u.name;
            break;
        }
        return cname;
    }    
    
     public string userNamesById (Id cid){
        string cname;
        for (User u : [select id,name from user where id =: cid]){
            cname = u.name;
            break;
        }
        return cname;
    }    
    
      public Map<Id, Contact> contactQueryByStringId(string clientId){ 
      Map<Id, Contact> mapContact1 = new Map<Id, Contact>
      ([select firstname, lastname, accountid, Date_of_Birth__c,name,nysid__c,Client_Status__c,Screening_Stage__c,
      BOOK_CASE__c, Gender_CC__c,aka_1__c, Case_Coordinator__c,Team_Leader__c,Interview_Stage__c,Most_Recent_Program_Plan__c,
      aka_2__c,aka_3__c,Lives_With__c,
       Relation_to_client__c, Referral_date__c,Attorney_Consent__c, 
       Attorney_Consent_Description__c,
       DOC_Risk_Score__c, CJA_Score__c,DOC_Recommendation__c,Judge_formula__c,Next_Court_Date__c,
       Judge_s_Conditions__c,Mandate_Decision_Date__c,Current_Track__c,HomePhone,
       Phone, Email, Cell_Phone__c,Client_Cell_Phone__c,Attorney_Formula__c,
       Prior_Violent_Conviction_Date__c, Prior_Violent_Conviction_Charge__c,
       Criminal_Justice_Involvement__c,Prior_Violent_Conviction__c,MobilePhone,
       Supervising_Attorney__c, Resource_Coordinator_s_Comments__c,
       Inmate_Location__c,CreatedDate,Detention_Status_at_Intake__c,
       Prior_Misdemeanor_Convictions__c, Prior_Felony_Convictions__c,
       Total_Prior_Convictions__c, intake_case__c,P_C_ID__c,id,Current_Intake_Date__c,
       Intake_Court_Formula__c,Current_Projected_Exit_Date__c,Exit_Reason__c,Borough_of_Intake_Formula__c ,
       Current_Exit_Type__c,Current_Exit_Date__c,Court_Rep__c  from Contact where id =: clientId]);
       return mapContact1;}
       
     public string nameUtility(ID iid){
          string cname;
          for (Utility_ID__c u :[select id, name, RecordType_Id__c from Utility_ID__c
              where id =: iid]){
          cname = u.name;}
          return cname; 
     }   
     
     public string findUserName(string userid){
       string username;
       for (User lstUsers : [select  Name from User where id =: userid limit 1]){
           username = lstUsers.name;
           break;
       }
        return username;
     }
   public date countDueDate(date d, integer days2add){
        integer k = 1;
        Map<Date, ID> mapHolidays = new Map<Date, ID>();
        List<Holidays__c> lstHolidays = [SELECT Id, Date__c FROM Holidays__c 
          where date__c >=: d];
        for(Holidays__c h: lstHolidays) {
            mapHolidays.put(h.Date__c, h.Id);
        }          
       for (integer i = 0; i < 100; i++){
      //     d = d + 1;
          if (ifWeekEnd(d) == true || mapHolidays.containsKey(d)){
    //         d = d + 1;  
             k--;}
     //      else
     //      d = d + 1;
          if (k  ==  days2add)
           break;
          d = d + 1;
           k++;    
        }
        return d;}
 
      public date countDueDateBefore(date d, integer days2add){
        integer k = days2add;
        date dt = d.addDays(-20);
        Map<Date, ID> mapHolidays = new Map<Date, ID>();
        List<Holidays__c>lstHolidays = [SELECT Id, Date__c FROM Holidays__c 
          where date__c >=: dt];
        for(Holidays__c h: lstHolidays) {
            mapHolidays.put(h.Date__c, h.Id);
        }    
       integer d_substruct = 0;     
       for (integer i = 1; i < 365; i++){
           d = d - 1;
           if (mapHolidays.containsKey(d) || ifWeekEnd(d) == true){ 
               d = d - 1;
               days2add++;}
          if (i  == days2add)
             break; 
       }
  
        return d;}       
        
     public boolean ifWeekEnd(date path_date){
        datetime dt1 =datetime.newInstance(path_date.year(), path_date.month(),path_date.day());
        if (dt1.format('E') == 'Sat' || dt1.format('E') == 'Sun')
           return true; 
        return false;
     }

    public string mostResentChargesType(string caseid){
       if (caseid == null || caseid == '')
          return null;
       string nameReturn = '';   
      string chargesName = '';
      List<Case_Charges__c> lstCharges = new List<Case_Charges__c>
      ([select type__c from case_charges__c where docket_no__c =: caseId limit 20]);
      if (lstCharges.Size() == 0)
         return null;  
      for (Case_Charges__c chg : lstCharges){  
           chargesName += chg.type__c;}
      if (chargesName.contains('Plea/ Finding Charges'))
          nameReturn = 'Plea/ Finding Charges';           
      else{
         if (chargesName.contains('Indictment Charges'))
            nameReturn = 'Indictment Charges';    
            else{
               if (chargesName.contains('Criminal Court Arraignment Charges'))
                  nameReturn = 'Criminal Court Arraignment Charges'; 
               else{
                 if (chargesName.contains('Criminal Court Arraignment Charges'))
                    nameReturn = 'Criminal Court Arraignment Charges';
                 else
                    if (chargesName.contains('Arrest Charges'))
                     nameReturn = 'Arrest Charges';    
          }}} 
       return nameReturn;} 
   public List<Event> appointments(date dstart, date dend, string clientid, string appSubject){
     List<Event> lstEvent = new List<Event>();
     if (appSubject.contains('Assessment')){
     string ass1 = 'Intake/Needs Assessment';
     string ass2 = 'Intake/ Assessment';  
     lstEvent = new List<Event>([select activityDate,Part__c,verification_status__c,
           whoid, whatid,subject from Event where  
            activityDate >=: dstart and activityDate <=: dend and (subject =: ass1 or subject =: ass2)
            and whoid =: clientid and verification_status__c <> 'Excused' and verification_status__c <> 'Cancelled' and 
            verification_status__c <> 'Not Verified' order by activitydate ]);} 
     else     
     lstEvent = new List<Event>([select activityDate,Part__c,verification_status__c,
           whoid, whatid,subject from Event where  
            activityDate >=: dstart and activityDate <=: dend and subject =: appSubject
            and whoid =: clientid and verification_status__c <> 'Excused' and verification_status__c <> 'Cancelled' and 
            verification_status__c <> 'Not Verified' order by activitydate ]); 
   
   
     return lstEvent;} 
    public string ChargesDescription(string caseid, string caseType){
       if (caseid == null || caseid == '')
          return null;
      Set<Id> chargesId = new Set<Id>();
      List<Case_Charges__c> lstCharges = new List<Case_Charges__c>
      ([select Charge__c from case_charges__c where docket_no__c =: caseId 
        and type__c =: caseType limit 20]);
      if (lstCharges.Size() == 0)
         return null;  
      for (Case_Charges__c chg : lstCharges){  
            chargesId.add(chg.Charge__c);}
     string Charges = ''; 
     List<Penal_Code__c> lstCodes = new  List<Penal_Code__c>
       ([select id,name,description__c From Penal_Code__c where id in: chargesId]);
     for (Penal_Code__c pl : lstCodes){
           if (Charges != '')
            Charges += '\r\n' + pl.name + ' - ' + pl.description__c;
        else 
          Charges = pl.name + ' - ' + pl.description__c ;}
       return charges;}   
       
      public boolean stopClock(){
        boolean lStop;
        return lStop;
      } 
      
      public string dayOfWeek(date path_date){
        datetime dt1 =datetime.newInstance(path_date.year(), path_date.month(),path_date.day());
        return dt1.format('E');
      } 
        public Map<Id,string> CourtCode(List<Event> lstEvents,Map<Id, Contact> mapCont, Map<Id,Case_Information__c> mapCases){
        string ctpart, ctname, boro,clientId,caseid,part,ctcode;
        Map<Id,string> mapCourtsCode = new Map<Id,string>();
        for (Event e : lstEvents){
        boro = '';
        ctname = '';
        part = '';  
        clientid = e.whoid;
        if (e.part__c == null)
            part = 'no court part *';
        else
           part = e.part__c;
        if (mapCont.get(clientid).Intake_Court_Formula__c != null)   
            ctname = mapCont.get(clientid).Intake_Court_Formula__c.left(1) + 'C';
        caseid = mapCont.get(clientid).intake_case__c;
        boro = mapCases.get(caseid).borough__c.left(1);
        ctcode = boro + '-' + ctname + '-' + part; 
        mapCourtsCode.put(e.id, ctcode);
        }
        return mapCourtsCode;
      } 
      
  public date countDueDateBefore_1(Map<Date, ID> mapHolidays,date d, integer days2add){
        integer k = days2add;
       for (integer i = 1; i < 365; i++){
           d = d - 1;
           if (mapHolidays.containsKey(d) || ifWeekEnd(d) == true){ 
               d = d - 1;
               days2add++;}
          if (i  == days2add)
             break; 
       }
        return d;}   


public date countDueDate_1(Map<Date, ID> mapHolidays,date d, integer days2add){
      if (days2add == 0)
         return d;
        integer k = 1;
       for (integer i = 0; i < 20000; i++){
           d = d + 1;
          if (ifWeekEnd(d) == true || mapHolidays.containsKey(d)){
        //     d = d + 1;  
             k--;}
           else
          if (k  ==  days2add)
           break;
           k++;    
        }
        return d;} 
     public List<Case_Relationship__c> findClient(string selectBy, 
        string searchParameter, string searchFname, string searchLname){
        List<Case_Relationship__c> retCasesList = new List<Case_Relationship__c>();
        string selectCases = 'SELECT Case_Type__c,Client_Name__c,Docket__c,Name,Program__c,Contact__c, docket_name__c, Indictment__c, ' +
         'Docket_Indictment__c, Boro_Court__c,CaseBoro__c,pcid__c,nysid__c,programId__c, account__c' + 
         ' FROM Case_Relationship__c where ' ;  
        string strWhere,pcid,cep,crt,srp,trp;
        searchParameter = searchParameter.trim();
        System.Debug('\n\n XXX searchParameter: ' + searchParameter);
        if (selectBy == 'Docket')
          strWhere = 'Docket_Name__c =: searchParameter  or indictment__c =: searchParameter';
          else{
          if (selectBy == 'PCID'){
             cep = 'CEP_' + searchParameter;
             crt = 'CRT_' + searchParameter;
             srp = 'SRP_' + searchParameter;
             trp = 'TRP_' + searchParameter;
         //    string id1 = 'CEP_101570';
         //    string id2 = 'CEP_101571';
         //    strWhere = 'PCID__c =: id1 or PCID__c =: id2'; 
             
             strWhere = 'PCID__c =: crt or PCID__c =: cep or PCID__c =: srp or PCID__c =: trp'; 
           }
           else{
              if (selectBy == 'NYSID')
              strWhere = 'nysid__c =: searchParameter';
              else{
          
         //         strWhere = '(FirstName__c LIKE: searchFname and lastName__c like: searchLname) ' +  
          //        ' or (FirstName__c LIKE: searchLname and lastName__c like: searchFname) '; 
             
             strWhere = ' FirstName__c LIKE \'%' + searchFname + '%\' ';
             strWhere += 'and  (LastName__c LIKE \'%' + searchLname 
                    + '%\' OR lastNameSoundex__c = \'' 
                    + Utility_Soundex.toSoundex(searchLname) + '\')'; 
            
              }
              }}
         
          selectCases += strWhere;
         retCasesList =  Database.Query(selectCases);
         return retCasesList;
     }        
     public boolean checkformat(string checkName,string checkValue){
        if (checkValue == '' || checkValue == null){
            return false;}
        if (checkName == 'Docket'){    
            if (checkValue.length() != 12){
            return false;
            }}  
       string dPart1 = checkValue.left(4);
       string dPart2 = checkValue.mid(5,2);
       string dPart3 = checkValue.right(6);
       Pattern isnumbers = Pattern.Compile('^[-]?[0-9]+$');
       Matcher numberMatch1 = isnumbers.matcher(dPart1);
       Matcher numberMatch2 = isnumbers.matcher(dPart2);
       Matcher numberMatch3 = isnumbers.matcher(dPart3);
       if (numberMatch1.Matches() == false || numberMatch3.Matches() == false
        || numberMatch2.Matches() == true){
        return false;}
        
        return true;
     }
     public integer checkDatesRange(date dateEnd, date d){
         Map<Date, ID> mapHolidays = new Map<Date, ID>();
        system.Debug('n\n XXX dateEnd: ' + dateEnd + ' d: '+ d);
        
         List<Holidays__c>lstHolidays = [SELECT Id, Date__c FROM Holidays__c];
        for(Holidays__c h: lstHolidays) {
            mapHolidays.put(h.Date__c, h.Id);}  
    
       integer k = 1;
       for (integer i = 0; i < 100; i++){
           if (ifWeekEnd(d) == true || mapHolidays.containsKey(d)){
             k--;
             d = d + 1;
           }  
           else{
             if (d  >=  dateEnd)
                 break;
             else{ 
                d = d + 1;    
                k++;
                }}
        
       } 
  //     system.Debug('n\n XXX k: ' + k);    
        return k;
         
     } 
  /*
    public  List<SelectOption> lstMonths(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('01','January'));
       options.add(new SelectOption('02','February'));
       options.add(new SelectOption('03','March'));
       options.add(new SelectOption('04','April'));
       options.add(new SelectOption('05','May'));
       options.add(new SelectOption('06','June'));
       options.add(new SelectOption('07','July'));
       options.add(new SelectOption('08','August'));
       options.add(new SelectOption('09','September'));
       options.add(new SelectOption('10','October'));
       options.add(new SelectOption('11','November'));
       options.add(new SelectOption('12','December'));
      return options;   
    }
   */
     public  List<SelectOption> lstMonths(){
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('01','26 Jan - 25 Feb'));
       options.add(new SelectOption('02','26 Feb - 25 Mar'));
       options.add(new SelectOption('03','26 Mar - 25 Apr'));
       options.add(new SelectOption('04','26 Apr - 25 May'));
       options.add(new SelectOption('05','26 May - 25 Jun'));
       options.add(new SelectOption('06','26 Jun - 25 Jul'));
       options.add(new SelectOption('07','26 Jul - 25 Aug'));
       options.add(new SelectOption('08','26 Aug - 25 Sep'));
       options.add(new SelectOption('09','26 Sep - 25 Oct'));
       options.add(new SelectOption('10','26 Oct - 25 Nov'));
       options.add(new SelectOption('11','26 Nov - 25 Dec'));
       options.add(new SelectOption('12','26 Dec - 25 Jan'));
      return options;   
    }
    public  List<SelectOption> lstYears(){
      
      List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('2015','2015'));
       options.add(new SelectOption('2016','2016'));
       options.add(new SelectOption('2017','2017'));
       if (date.today().year() > 2017)
       options.add(new SelectOption('2018','2018'));
      return options;   
    }

    public date calculateDateperiod(){
      date d;
      return d;
    }
    public List<Delinquency_Tracking__c> selectfromDb(string courtId){
     //   string actionId =  ApexPages.currentPage().getParameters().get('actionPassed');
      List<Delinquency_Tracking__c> letter = [Select actionId__c, id,Reasons_Summary__c,
      Letter_Date__c,notes__c,SRP_ActivityDate__c,Appointment_Date__c,
      Response__c, Stop_Clock__c,Date_of_Contact__c,Outreach_type__c,Additional_Info__c,
      CreatedById,createdDate,LastModifiedById,LastmodifiedDate,Document_Type__c,courtPart__c,
      Warrant_issued__c, Returned_to_Program__c,FTA_reason__c,Outcome__c  
     from Delinquency_Tracking__c where actionId__c =: courtId and 
     deleted_by_user__c =: false order by id desc ] ;
      return letter;}  


}