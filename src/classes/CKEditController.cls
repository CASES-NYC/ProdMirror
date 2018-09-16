public class CKEditController
{
    public String reportPassed   = System.currentPageReference().getParameters().get('selectedReport');    
  
   
	

   public string text{get;set;} 
//   public string text1{get;set;}    
    public String getreportPassed(){
       return reportPassed;}
    public void setreportPassed(String reportPassed){
        this.reportPassed = reportPassed;}
    public CKEditController()
    {
      //  Parameter = ApexPages.currentPage().getParameters().get('p7');
   //   parameter = 'parameter';
        SF_CRW__c nar = [select narrative__c,Narrative_RTF__c from SF_CRW__c
                where id =: reportPassed];
              text = nar.Narrative_RTF__c;
    //    return null;
    	reportDefault =  generateReportDefault();
    }
    
    public void saveReport(){
    	  SF_CRW__c nar = new SF_CRW__c(id=reportPassed);
              nar.Narrative_RTF__c = text;
       //       nar.documentDate__c = date.today();
        //      nar.report_edited_time__c = datetime.now();
         //     nar.assignTo__c = userFullName;
              update nar;
    	 
    }
   
    public String CRWtmp {
    get {
        StaticResource sr = [
                select Body
                from StaticResource
                where Name = 'CRWtemplate' limit 1];
       String body = sr.Body.toString();    
   //     string s = String.ValueOF(b);        
        System.Debug('n\n XXX sr.Body.toString(): ' + sr.Body.toString());  
    //   SF_CRW__c nar = new SF_CRW__c(id=reportPassed);
     //      nar.Narrative__c = b.toString();
       //       nar.documentDate__c = date.today();
        //      nar.report_edited_time__c = datetime.now();
         //     nar.assignTo__c = userFullName;
       //       update nar;     
      return body;
    }
    set{this.CRWtmp = CRWtmp;}}
    
   public string s1{get{return 'Paragraph 1';}}
   public string s2{get{return 'Paragraph 2';}}
  
    public string ReportDefault{get;set;} 
    public String generateReportDefault(){
       string sInsert = '<p><span style="font-size: 16px;"><span style="font-family: arial,helvetica,sans-serif;"><strong>INTRODUCTION</strong></span></span></p> <p><br><span style="font-size: 16px;"><span style="font-family: arial,helvetica,sans-serif;"><strong>SUMMARY OF LAST REPORT</strong></span></span></p> <p> </p> <p><span style="font-size: 16px;"><span style="font-family: arial,helvetica,sans-serif;"><strong>INTELLECTUAL AND CAREER DEVELOPMENT (ICD)</strong></span></span></p> <p> </p> <p><span style="font-size: 16px;"><span style="font-family: arial,helvetica,sans-serif;"><strong>HEALTH AND WELL-BEING (HWB)</strong></span></span></p> <p> </p> <p><span style="font-size: 16px;"><span style="font-family: arial,helvetica,sans-serif;"><strong>JUDICIAL AND CIVIC ACCOUNTABILITY (JCA)</strong></span></span></p> <p> </p> <p><span style="font-size: 16px;"><span style="font-family: arial,helvetica,sans-serif;"><strong>CONCLUSION</strong></span></span></p> <p> </p>';
  //     SF_CRW__c nar = new SF_CRW__c(id=reportPassed);
  //     nar.Narrative__c = sInsert;
   //    update nar;
       return sInsert;
    }
  	
    }