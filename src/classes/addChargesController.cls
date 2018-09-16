public with sharing class addChargesController {    
   public String docketPassed = System.currentPagereference().getParameters().get('selectedDocket');    
   public List<CLSallCharges> lstArrestCharges = new List<CLSallCharges>();
   public List<CLSallCharges> lstIindictmentCharges = new List<CLSallCharges>();
   public List<CLSallCharges> lstArraigmentCharges = new List<CLSallCharges>();
   public List<CLSallCharges> lstPleaCharges = new List<CLSallCharges>();
   public List<CLSallCharges> lstFamilyCharges = new List<CLSallCharges>();
   
   public string selectedCode{get;set;} 

   public String CodesList1{get;set;} 
   public String CodesList2{get;set;} 
   public String CodesList3{get;set;} 
   public String CodesList4{get;set;} 
   public String CodesList5{get;set;} 
   public String CodesList6{get;set;} 
   public String CodesList7{get;set;} 
   public String CodesList8{get;set;} 
   public String CodesList9{get;set;} 
   public String CodesList10{get;set;} 
//   public string fieldValue{get;set;}
   public string id2delete{get;set;}
   public string chgType{get;set;}
 
   
   public String chgString{get;set;}    
   
   public addChargesController(){
  // 	docketPassed= 'a0G110000048mq0'; 
  clearCharges();
  /*
   	chargeCode1 = '';
   	chargeCode2 = '';
   	chargeCode3 = '';
   	chargeCode4 = '';
   	chargeCode5 = '';
   	chargeCode6 = '';
   	chargeCode7 = '';
   	chargeCode8 = '';
   	chargeCode9 = '';
   	chargeCode10 = '';
   */
    CodesItems1 = new List<SelectOption>();    	
   if (docketPassed <> null){
        generalInfo();
      buildCharges();}
   }
   
   public void resetInfo(){

     buildCharges();
   } 
           
   public void doNothing(){
     closePopUp();
     buildCharges();
   }
  public boolean fromSelect{get;set;} 
  public void RefreshPickList(){
  //	   findCodes1();
  }
   public void refreshType(){
   	
   }
   public boolean lCriminalArrainchg{get;set;}
   public boolean lFamilyArrainchg{get;set;}

   public boolean lIndictment{get;set;}
   public MAP<string, id> chargesMapNameId = new MAP<string, id>();
   public MAP<id,string> chargesMapNameId1 = new MAP<id,string>();
   public MAP<id,string>  MAPUtility = new MAP<id,string>();
   public class CLSallCharges{
   public String chgCode{get;set;}
   public String chgType{get;set;}
   public String chgDescription{get;set;}
   public String chgLevel{get;set;}
   public String chgDegree{get;set;}
   public String chgClass{get;set;}
   public Id chargeid{get;set;}
   public integer itemnumber{get;set;}} 

   public string court{get;set;}
   public string intakeStatus{get;set;}
   public string currentStatus{get;set;}
   public string specCourt{get;set;}
   public decimal courtPeriod{get;set;}
   public string indictment{get;set;}
   public string boro{get;set;}
   public string fullname{get;set;}
   public string docketname{get;set;}
   public ID clientid{get;set;}
   public date origProjExitDate{get;set;}
   public date currProjExitDate{get;set;}
   public boolean noDocket{get;set;}
   public string caseInfo{get;set;} 
   public ID docketId{get;set;}
   public string caseTypeCourt{get;set;}   

  public void generalInfo() {
  
    for (Utility_ID__c u :[select id, name, RecordType_Id__c from Utility_ID__c]){
            MAPUtility.put(u.RecordType_Id__c, u.name);}
            
    Map<Id, Case_Information__c> mapCaseInfo = new Map<Id, Case_Information__c>
     ([select id,supreme_court_period__c,specialized_court__c, indictment__c,
     name,client_account__c, borough__c,RecordTypeId
     from Case_Information__c where id =: docketPassed limit 1]);
     
     //10/30/12 MB moved this here so that it can be used in the filter for the following query
     clientid = mapCaseInfo.get(docketPassed).client_account__c;     
     
     Map<Id, Account> mapContact = new Map<Id, Account>
     ([select id, name from Account where id = :clientid]);
                  
     if (mapCaseInfo.get(docketPassed).specialized_court__c <> null)
         specCourt = mapCaseInfo.get(docketPassed).specialized_court__c;    
            
    courtPeriod = mapCaseInfo.get(docketPassed).supreme_court_period__c;
    if (mapCaseInfo.get(docketPassed).indictment__c <> null)
          indictment = mapCaseInfo.get(docketPassed).indictment__c;
       if (mapCaseInfo.get(docketPassed).borough__c <> '')
          boro = mapCaseInfo.get(docketPassed).borough__c ;

     fullname =  mapContact.get(clientid).name;
    
    if (mapCaseInfo.get(docketPassed).name <> null)
         docketname = mapCaseInfo.get(docketPassed).name;

    if (mapCaseInfo.get(docketPassed).name == '') {
        noDocket = true;
    }
    docketId = docketPassed;
   caseTypeCourt = MAPUtility.get( mapCaseInfo.get(docketPassed).recordtypeid);
   
   if (caseTypeCourt.contains('Supreme Court')){
       lIndictment = true;
       lCriminalArrainchg = true;
   }
   else{    
      if (caseTypeCourt.contains('Criminal'))       
          lCriminalArrainchg = true;
      else
           lFamilyArrainchg = true;  
   }}
   public List<CLSallCharges> ArrestCharges{get;set;}
   public List<CLSallCharges> IndictmentCharges{get;set;}
   public List<CLSallCharges> ArraignmentCharges{get;set;}
   public List<CLSallCharges> PleaCharges{get;set;}
   public List<CLSallCharges> FamilyCharges{get;set;}
 //  public string s_pass;
      
   public void buildCharges(){
        Set<Id> pIds = new Set<Id>();
       List<Case_Charges__c> lstCharges = [select id,name,type__c,charge_Level__c,Charge__c from case_charges__c 
       where docket_no__c =: docketPassed];
      for (Case_Charges__c chg : lstCharges){
        if (chg.Charge__c != null)
                pIds.add(chg.Charge__c);}
     Map<Id, Penal_Code__c> mapCodes = new Map<Id, Penal_Code__c>([select id,degree__c,level__c,class__c,name,
     description__c From Penal_Code__c where id in: pIds] );
     lstArrestCharges = new List<CLSallCharges>();
     lstIindictmentCharges = new List<CLSallCharges>();
     lstArraigmentCharges = new List<CLSallCharges>();
     lstPleaCharges = new List<CLSallCharges>();
     lstFamilyCharges = new List<CLSallCharges>();       
     integer i1 = 1;
     integer i2 = 1;
     integer i3 = 1;
     integer i4 = 1;
     integer i5 = 1;     
     string cType;
     for (Case_Charges__c c : lstCharges){
         CLSallCharges arrestchg = new CLSallCharges();
         CLSallCharges indictmentchg = new CLSallCharges();
         CLSallCharges arraigmentchg = new CLSallCharges();
         CLSallCharges pleachg = new CLSallCharges();
         CLSallCharges familychg = new CLSallCharges();         
         
         if (c.type__c <> null && c.charge__c <> null)
         {cType = c.type__c.trim();
         if (cType == 'Arrest Charges'){
                arrestchg.chgCode = mapCodes.get(c.Charge__c).Name;
                arrestchg.chgType = cType;
                arrestchg.chgLevel = mapCodes.get(c.Charge__c).level__c;
                arrestchg.chgDescription = mapCodes.get(c.Charge__c).description__c;
                arrestchg.chargeid = c.id;
                if (mapCodes.get(c.Charge__c).degree__c <> null)
                   arrestchg.chgDegree = mapCodes.get(c.Charge__c).degree__c;
                arrestchg.chgClass = mapCodes.get(c.Charge__c).class__c;
                arrestchg.itemnumber = i1;
                lstArrestCharges.add(arrestchg);
                i1++;}
         else{if (cType == 'Indictment Charges'){
                indictmentchg.chgCode = mapCodes.get(c.Charge__c).name;
                indictmentchg.chgType = cType;
                indictmentchg.chgDescription = mapCodes.get(c.Charge__c).description__c;
                indictmentchg.chgLevel = mapCodes.get(c.Charge__c).level__c;
                indictmentchg.chargeid = c.id;
                indictmentchg.chgDegree = mapCodes.get(c.Charge__c).degree__c;
                indictmentchg.chgClass = mapCodes.get(c.Charge__c).class__c;
                indictmentchg.itemnumber = i2;
                lstIindictmentCharges.add(indictmentchg);
                i2++;}
         else{if (cType == 'Criminal Court Arraignment Charges'){
                arraigmentchg.chgCode = mapCodes.get(c.Charge__c).name;
                arraigmentchg.chgType = cType;
                arraigmentchg.chgDescription = mapCodes.get(c.Charge__c).description__c;
                arraigmentchg.chgLevel = mapCodes.get(c.Charge__c).level__c;
                arraigmentchg.chargeid = c.id;
                arraigmentchg.chgDegree = mapCodes.get(c.Charge__c).degree__c;
                arraigmentchg.chgClass = mapCodes.get(c.Charge__c).class__c;
                arraigmentchg.itemnumber = i3;
                lstArraigmentCharges.add(arraigmentchg);
                i3++;}
         else{if (cType == 'Plea/ Finding Charges'){
                pleachg.chgCode = mapCodes.get(c.Charge__c).name;
                pleachg.chgType = cType;
                pleachg.chgDescription = mapCodes.get(c.Charge__c).description__c;
                pleachg.chgLevel = mapCodes.get(c.Charge__c).level__c;
                pleachg.chargeid = c.id;
                pleachg.chgDegree = mapCodes.get(c.Charge__c).degree__c;
                pleachg.chgClass = mapCodes.get(c.Charge__c).class__c;
                pleachg.itemnumber = i4;
                lstPleaCharges.add(pleachg);
                i4++;}
         else{if (cType == 'Family Court Arraignment Charges'){
                familychg.chgCode = mapCodes.get(c.Charge__c).name;
                familychg.chgType = cType;
                familychg.chgDescription = mapCodes.get(c.Charge__c).description__c;
                familychg.chgLevel = mapCodes.get(c.Charge__c).level__c;
                familychg.chargeid = c.id;
                familychg.chgDegree = mapCodes.get(c.Charge__c).degree__c;
                familychg.chgClass = mapCodes.get(c.Charge__c).class__c;
                familychg.itemnumber = i5;
                lstFamilyCharges.add(familychg);
                i5++;}}}}}}                
         ArrestCharges = lstArrestCharges;
         IndictmentCharges = lstIindictmentCharges;
         ArraignmentCharges = lstArraigmentCharges;
         PleaCharges = lstPleaCharges;
         FamilyCharges = lstFamilyCharges;}}         
         
   public void deletecharge(){
      Case_Charges__c chg = new Case_Charges__c(id=id2delete);
      if (chg <> null)
         delete chg;
         buildCharges();}
  public boolean displayPopup {get; set;}
  public void closePopup() {displayPopup = false;
  buildCharges();}
  public void showPopup() {
  	displayPopup = true;
  		chargeCode1 = '';
   	chargeCode2 = '';
   	chargeCode3 = '';
   	chargeCode4 = '';
   	chargeCode5 = '';
    chargeCode6 = '';  
   	chargeCode7 = '';
   	chargeCode8 = '';
   	chargeCode9 = '';
   	chargeCode10 = '';}
 
public string chargeCode1{get;set;}
public string chargeCode2{get;set;}
public string chargeCode3{get;set;}
public string chargeCode4{get;set;}
public string chargeCode5{get;set;}
public string chargeCode6{get;set;}
public string chargeCode7{get;set;}
public string chargeCode8{get;set;}
public string chargeCode9{get;set;}
public string chargeCode10{get;set;}

 public List<SelectOption> CodesItems1{get{
 
   CodesItems1 = new List<SelectOption>(); 
   if (chargeCode1 == '')
      return CodesItems1;
//   string s = '%' + chargeCode1.left(2) + '%';
   string s = chargeCode1.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode1];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   integer i = 0;
   //         CodesItems1.add(new SelectOption('','---'));
   for (Penal_Code__c p1 : p){
   //   if (i == 0)
//      chargesMapNameId.put(p1.name.trim(), p1.id);
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems1.add(new SelectOption(p1.id,plExpression));
      }
 //     i++;
   } 

 return CodesItems1;}
 set{CodesItems1 = this.CodesItems1;}}
 
 public List<SelectOption> CodesItems2{get{
   CodesItems2 = new List<SelectOption>();
   if (chargeCode2 == '')
      return CodesItems2;
   string s = chargeCode2.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode2];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
 //  integer i = 0;
   for (Penal_Code__c p1 : p){
   //   if (i == 0)
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems2.add(new SelectOption(p1.id,plExpression));
      }
  //    i++;
   } 

 return CodesItems2;}
 set{CodesItems2 = this.CodesItems2;}}

 public List<SelectOption> CodesItems3{get{
   CodesItems3 = new List<SelectOption>();
   if (chargeCode3 == '')
      return CodesItems3;
   string s = chargeCode3.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode3];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems3.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems3;}
 set{CodesItems3 = this.CodesItems3;}}
 
 public List<SelectOption> CodesItems4{get{
   CodesItems4 = new List<SelectOption>();
   if (chargeCode4 == '')
      return CodesItems4;
   string s = chargeCode4.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode4];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems4.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems4;}
 set{CodesItems4 = this.CodesItems4;}}
 
public List<SelectOption> CodesItems5{get{
   CodesItems5 = new List<SelectOption>();
   if (chargeCode5 == '')
      return CodesItems5;
   string s = chargeCode5.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode5];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems5.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems5;}
 set{CodesItems5 = this.CodesItems5;}} 
 
 public List<SelectOption> CodesItems6{get{
   CodesItems6 = new List<SelectOption>();
   if (chargeCode6 == '')
      return CodesItems6;
   string s = chargeCode6.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode6];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems6.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems6;}
 set{CodesItems6 = this.CodesItems6;}} 
 
public List<SelectOption> CodesItems7{get{
   CodesItems7 = new List<SelectOption>();
   if (chargeCode7 == '')
      return CodesItems7;
   string s = chargeCode7.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode7];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems7.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems7;}
 set{CodesItems7 = this.CodesItems7;}} 

public List<SelectOption> CodesItems8{get{
   CodesItems8 = new List<SelectOption>();
   if (chargeCode8 == '')
      return CodesItems8;
   string s = chargeCode8.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode8];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems8.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems8;}
 set{CodesItems8 = this.CodesItems8;}} 

public List<SelectOption> CodesItems9{get{
   CodesItems9 = new List<SelectOption>();
   if (chargeCode9 == '')
      return CodesItems9;
   string s = chargeCode9.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode9];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems9.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems9;}
 set{CodesItems9 = this.CodesItems9;}} 

public List<SelectOption> CodesItems10{get{
   CodesItems10 = new List<SelectOption>();
   if (chargeCode10 == '')
      return CodesItems10;
   string s = chargeCode10.left(3) + '%';
   string plExpression = '';
   List<Penal_Code__c> p = new List<Penal_Code__c>();
   p = [select name,description__c from Penal_Code__c 
      where name = : chargeCode10];
   if (p == null || p.Size() == 0){
      p = [select name,description__c from Penal_Code__c 
         where name LIKE : s order by name ];}
   for (Penal_Code__c p1 : p){
      chargesMapNameId.put(p1.name.trim(), p1.id);
      if (p1.name <> '0'){plExpression = addPadd(p1.name.trim(), p1.description__c.trim());
          CodesItems10.add(new SelectOption(p1.id,plExpression));
      }
   } 
 return CodesItems10;}
 set{CodesItems10 = this.CodesItems10;}} 
  public string addPadd(string s, string descr){
      integer i =  s.length();
      integer m = 14 - i;
      if (i == 3)m = 14;
        else if (i == 5) m = 12; 
          else 
            if (i == 6)
               m = 10;     
      string s1 = '';
      string s2 = '.';
      for (integer k = 0; k <= m; k++)
       {s1 = s1 + s2;}
      return s +  s1 +  descr;}
    
  public String showNotAdd{get;set;}
  public boolean bshowNotAdd{get;set;}
  public void saveSelectedCharges(){
  	   //   displayPopup = false;
  	    if (chgString == '')
  	       return;
        String[] charges = chgString.split(',');
  //     List<Case_Charges__c> lstCharges = [select id,name,type__c,charge_Level__c,Charge__c from case_charges__c 
  //     where docket_no__c =: docketPassed and type__c =: chgType and Charge__c in: charges];

   //    Map<string,string> mapCodes = new Map<string,string>();
    //   for (Penal_Code__c pc : [Select id,name from Penal_Code__c where id in: charges]){
   //    	  mapCodes.put(pc.id,pc.name);
     //  }
       
     //  System.Debug('\n\n XXX mapCodes: ' + mapCodes + 'charges: ' + charges);
 //      return;
  //     for (Case_Charges__c ch : lstCharges){
  //     	  mapChg.put(ch.id,ch.Charge__c);
  //     }
        List<Case_Charges__c> chgList = new List<Case_Charges__c>();
        Case_Charges__c oneRecord = new Case_Charges__c();
    // boolean notAdd;
   //  bshowNotAdd = false;

        string strNotAdd = '';
        for (integer i = 0; i < charges.size(); i++){
//          notAdd = false;
          oneRecord = new Case_Charges__c();
          oneRecord.docket_no__c = docketPassed;
          oneRecord.type__c = chgType;
          oneRecord.Charge__c = charges[i];
       //   for (Case_Charges__c ch : lstCharges){
        //  	if (ch.type__c.trim() == chgType.trim() && ch.Charge__c == charges[i]){
        //  	   notAdd = true;
        //  	   if (strNotAdd == '')
        //  	      strNotAdd += mapCodes.get(ch.Charge__c).trim();
        //  	   else
        //  	      strNotAdd += ', ' + mapCodes.get(ch.Charge__c).trim();   
        //  	   break;	
         // 	}
        // }
   //     if (notAdd == false)  
           chgList.add(oneRecord);
        }  
        try{
           insert chgList;}
       catch (exception e){}
       // if (strNotAdd != ''){
      //  	showNotAdd = strNotAdd; 
      //     bshowNotAdd = true;
       // }
         buildCharges();
        }   
       public void clearCharges(){
       	 	chargeCode1 = '';
   	chargeCode2 = '';
   	chargeCode3 = '';
   	chargeCode4 = '';
   	chargeCode5 = '';
   	chargeCode6 = '';
   	chargeCode7 = '';
   	chargeCode8 = '';
   	chargeCode9 = '';
   	chargeCode10 = '';}
    }