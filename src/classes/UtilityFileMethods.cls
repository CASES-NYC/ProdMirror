public with sharing class UtilityFileMethods {
   public Blob csvFileBody{get;set;}
   public ID idForTest{get;set;}
   public Id cepClient = Utility_ID__c.getValues('CEP Client').RecordType_Id__c;  
   public Id ccmClient = Utility_ID__c.getValues('CCM Client').RecordType_Id__c;    
   public string idForTestCCM{get;set;}  
   public UtilityFileMethods(){
     //    for (Contact c : [select id, intake_date__c from Contact
     //    where recordtypeid =: ccmClient order by intake_date__c desc limit 1]){
  //         idForTestCCM = c.id;}
     //   generateCSV_forLSMI();           
   }


   public Blob  generateCSV(){
 	// 12 cols 0-11
    string strHeader1 = 'nysid,bookcase,f_name,m_name, l_name,docket,address,city,state,zip,dob,gender,';
    string value11 = '04221673Z,2411303615,Arden,Peter,JOHNSON,2013NY023083,1600 MCCOMBS RD  55B,Bronx,NY,10452,2/26/1960,M,';   
 //   string value21 = '05467202Z,3491307608,Anthony,Jjon,Harrington,2013NY038423,2828 W 28 ST  7E,Brooklyn,NY,11224,2/19/1969,M,';   
   
   // 5 cols  12-16
   string strHeader2 = 'charge0,charge1, charge2,charge3,charge4,';
   string value12 = '100.05,160.1,160.05,155.3,155.25,';   
 //  string value22 = '100.05,160.1,160.05,155.3,155.25';   
 
   // 7 cols  17-24
   string strHeader3 = 'borocourt,arring_date,bail,next_ct,cjascore,docscore,cirt_option\n';
   string value13 = 'NY,1/21/2014,2, 5/1/2014, 23,5,ATI\n';
//   string value23 = 'NY,2/14/2014,1,3/17/2014,15,19,ATD\n';
   
   String csvFile  = '';
   csvFile += strHeader1 + strHeader2 + strHeader3;
   csvFile += value11 + value12 + value13;  
  // csvFile += value21 + value22; 
   
   //+ value23;  
   System.Debug('\n\n\n XXX YYY csvFile: ' + csvFile);
   csvFileBody = Blob.valueOf(csvFile);
   return csvFileBody;} 
   
   public Blob  generateCSV_ForNewDOCFormat(){
 	// 12 cols 0-11
    string strHeader1 = 'nysid,bookcasenumber,inmate_first_name,inmate_middle_name, inmate_last_name,docket,inmate_address,inmate_city,inmate_state,inmate_zip,inmate_dob,inmate_gender,';
    string value11 = '03221673W,6711303615,Arden,H,Moses,2014NY023083,1600 MCCOMBS RD  55B,Bronx,NY,10452,2/26/1960,M,';   
 //   string value21 = '05467202Z,3491307608,Anthony,Jjon,Harrington,2013NY038423,2828 W 28 ST  7E,Brooklyn,NY,11224,2/19/1969,M,';   
   
   // 5 cols  12-16
   string strHeader2 = 'charge_no_1,charge_no_2, charge_no_3,charge_no_4,charge_no_5,';
   string value12 = '100.05,160.1,160.05,155.3,155.25,';   
 //  string value22 = '100.05,160.1,160.05,155.3,155.25';   
 
   // 7 cols  17-24
   string strHeader3 = 'borough_court,cirt_eligibility_date, date_of_arraignment_,bail_amount,next_court_date,cjascore,docscore,cirt_eligible_option\n';
   string value13 = 'NY,2/8/2014, 1/21/2014,2, 5/1/2014, 23,5,ATI\n';
//   string value23 = 'NY,2/14/2014,1,3/17/2014,15,19,ATD\n';
   
   String csvFile  = '';
   csvFile += strHeader1 + strHeader2 + strHeader3;
   csvFile += value11 + value12 + value13;  
  // csvFile += value21 + value22; 
   
   //+ value23;  
   System.Debug('\n\n\n XXX YYY csvFile: ' + csvFile);
   csvFileBody = Blob.valueOf(csvFile);
   return csvFileBody;}   
   	  

 public Blob  generateCSV_forLSMI(){
 	// 12 cols 0-12
    string strHeader1 = 'sfid,pcid,cid,dassess,iid,strenght,SUBSCALE_1_RISKLEVEL,SUBSCALE_2_RISKLEVEL,SUBSCALE_3_RISKLEVEL,SUBSCALE_4_RISKLEVEL,SUBSCALE_5_RISKLEVEL,';
    string value11 = idForTestCCM + ',CCM_89184,1665_227797,1/30/2013,98184,Alcohol/Drugs; Pro-criminal Attitude,0,2,3,2,0,';   
   
   // 5 cols  13-17
   string strHeader2 = 'SUBSCALE_6_RISKLEVEL,SUBSCALE_7_RISKLEVEL, SUBSCALE_8_RISKLEVEL,ss1,ss2,';
   string value12 = '0,0,1,Very Low,Medium,';   
 
   // 7 cols  18-28
   string strHeader3 = 'ss3,ss4,ss5,ss6,ss7,ss8,SSTT,TOTALRISK_SCORE,RECORDTYPEID,DPROCESSED,cnotes \n';
   string value13 = 'High,Medium,Very Low,Very Low,Very Low,Low,Low,10,012600000005MlWAAU,4/25/2014  3:19:00 PM  5,Ariann reported during orientation that she has a sister whom she has an okay relationship with.\r\n';
   
   String csvFile  = '';
   csvFile += strHeader1 + strHeader2 + strHeader3;
   csvFile += value11 + value12 + value13;  
   System.Debug('\n\n\n XXX YYY csvFile: ' + csvFile);
   csvFileBody = Blob.valueOf(csvFile);
   return csvFileBody;} 		  

   public Blob  generateCSV_forLSIR(){
 	// 12 cols 0-12
    string strHeader1 = 'sfid,lagacyid,dassess,totalscoret,origclass,recordtypeid \n';
    string value11 = idForTestCCM + ',100002_338089,11/29/2014,5,Medium,012600000005MlVAAU\n';  
 //   string value11 = idForTest  + ',100002_338089,11/29/2014,5,Medium,012600000005MlVAAU\n'; 
   
   String csvFile  = '';
   csvFile += strHeader1 + value11;  
   System.Debug('\n\n\n XXX YYY csvFile: ' + csvFile);
   csvFileBody = Blob.valueOf(csvFile);
   return csvFileBody;} 
   
   public Blob  generateCSV_forTABE(){ 
      string strHeader1 = 'sfid,field2,field3,field4,field5,field6,field7,field8,field9,field10,field11,field12,field13\n';
   //   string value0 = '\r\n';  
   System.Debug('\n\n XXX idForTestCCM: ' + idForTestCCM);
      string value1 = idForTestCCM + ',05/01/2014,5.3,3.3,4.3,7.0,4.7,5.1,4.2,5.3,1.1,ADONIS,012600000005MlVAAU\r\n';  
      String csvFile  = '';
      csvFile += strHeader1;  
      csvFile += value1;
      System.Debug('\n\n\n XXX YYY csvFile: ' + csvFile);
      csvFileBody = Blob.valueOf(csvFile);
      return csvFileBody;} 

 
}