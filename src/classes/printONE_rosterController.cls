public class printONE_rosterController 
{
    Public String strPassed = System.currentPagereference().getParameters().get('passPar');
    public string currentDate{get;set;}
    String oneClient = Utility_ID__c.getValues('ONE Client').RecordType_Id__c;

    public integer numberOfPages{get;set;}
    public integer allRows{get;set;}
    public String dateprinted{get;set;}

    public  printONE_rosterController()
    {
        dateprinted = date.today().format();
        selectRoster();
    }      

    public void selectRoster()
    {
      roster1 oneRec = new roster1();
      integer pagenumb = 1;
      dateprinted = date.today().format();
      List<roster1> lstRoster1 = new List<roster1>();
     List<roster1> lstRoster2 = new List<roster1>();
     List<roster1> lstRoster3 = new List<roster1>();
    List<roster1> lstRosterAdd = new List<roster1>();
      integer allRows = 1;
      boolean page1,page2,page3;
     page1 = false;
     page2 = false;
     page3 = false;
      List<Contact> lstAll = [select P_C_Id__c, Name from Contact where recordtypeId =:  oneClient
       and (Client_Status__c in ('Active', 'Incomplete Screening') 
       or (Client_Status__c='Exited' and Current_Exit_Date__c = TODAY)) 
        Order By Name];
    integer p = 0;    
    integer nClients = 0;
    for (p = 0; p < lstAll.Size(); p++){
          numberOfPages = 1;  
         oneRec = new roster1();
         oneRec.cid = lstAll[p].p_c_id__c;
         oneRec.cname = lstAll[p].Name;
         oneRec.rownumb = string.valueOf(allRows).trim();
         lstRoster1.add(oneRec);
         allRows++;
          if (allRows > 20)
            break;
    }
    lstRosterShow1 = lstRoster1; 

    integer k;
    if (p < lstAll.Size())
    {
       numberOfPages = 2;  
      for (k = p; k < lstAll.Size(); k++){  
         oneRec = new roster1();
         oneRec.cid = lstAll[k].p_c_id__c;
         oneRec.cname = lstAll[k].Name;
         oneRec.rownumb = string.valueOf(allRows).trim();
         lstRoster2.add(oneRec);
         allRows++;
         if (allRows > 40)
            break;
    }
    lstRosterShow2 = lstRoster2;

    integer m;
    if (k < lstAll.Size())
    {
        numberOfPages = 3;  
        for (m = k; m < lstAll.Size(); m++)
        {  
         oneRec = new roster1();
         oneRec.cid = lstAll[m].p_c_id__c;
         oneRec.cname = lstAll[m].Name;
         oneRec.rownumb = string.valueOf(allRows).trim();
         lstRoster3.add(oneRec);
         allRows++;
          if (allRows > 60)
            break;
        }
        lstRosterShow3 = lstRoster3;
    }
    }
    for (integer s = 0;s < 3; s++)
    {
        oneRec = new roster1();
        oneRec.cid = '';
        oneRec.cname = '';
        oneRec.rownumb = string.valueOf(allRows).trim();
        if (numberOfPages == 1)
           lstRosterShow1.add(oneRec);
        else{
          if (numberOfPages == 2)
           lstRosterShow2.add(oneRec);
           else 
           lstRosterShow3.add(oneRec);

        } 
        allRows++;
    }
   }


   
   public List<roster1> lstRosterShow1{get;set;}
   public List<roster1> lstRosterShow2{get;set;}
   public List<roster1> lstRosterShow3{get;set;}
    public class roster1{
     public string cid{get;set;}
    public string rownumb{get;set;}
    public integer irownumb{get;set;}
    public integer pageNumber{get;set;}
    public string cname{get;set;}
    public boolean pagebreak{get;set;}
   }

public PageReference deliverAsPDF() {
      PageReference pdf =  Page.printONE_roster;
      pdf.getParameters().put('p','p');
      return pdf;}

   public String getChooserender() {
   if (ApexPages.currentPage().getParameters().get('p') != null)
      return 'pdf';
   else
   return null;} 
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
             and pageName__c =:  'all courts' order by createddate desc limit 1];
     }
     catch (Exception e) {
          lt = new loginTracking__c();
          lt.loginName__c = cuser;
          lt.loginDateTime__c = datetime.now().format(); 
          lt.pageName__c = 'all courts';
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
           lt.pageName__c = 'ONE roster';
        insert lt;}}
      }  }
}