global class DeclarativeScheduler  implements Reports.NotificationAction{
    
global Integer recordsProcessed;
global String ObjectType;
global String FieldtoUpdate; 
Global ID ReportID;
Global List<string> recordIds = new List<string>();
Global String soqlQuery;
global string csvList;



  
public void execute(Reports.NotificationActionContext context) {

        //GET ALl report info as CSV
        ReportID  = context.getReportInstance().getReportId();
        system.debug('ReportID '+ReportID );
        
        //Get CSV File of report    
         ApexPages.PageReference report = new ApexPages.PageReference('/'+ReportID +'?export=1&enc=UTF-8&xf=csv');

         if(!Test.isRunningTest() ){ // real
               csvList =  report.getContent().toString();
         }else{ //test            
             csvList = String.valueOf('"FakeHeader","FakeHeader",\n"FakeID","FakeField"');
         }





        // assuming the report is a tabular report type, get the data details from fact map
        // http://salesforce.stackexchange.com/questions/49446/tabular-report-data-via-analytics-api/49449?stw=2#49449
         Reports.ReportResults results = context.getReportInstance().getReportResults();
        Reports.ReportFactWithDetails reportDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
        
        //Get object
        Id firstrecordid = null;
        for ( Reports.ReportDetailRow row : reportDetails.getRows() ) {
            //first result should be the id
            for ( Reports.ReportDataCell cell : row.getDataCells() ) {    

                    Object value = cell.getValue();
                    String valuestring = String.valueOf(value);
                    firstrecordid = Id.valueOf(valuestring);
                    ObjectType = firstrecordid.getSobjectType().getDescribe().getName();
                    break;
           }
        }
        
        //get second column api field name
        Integer loopi = 0;
        for ( string column : results.getReportMetadata().getDetailColumns()) {
            loopi++;
            if(loopi==2){
                FieldtoUpdate = column.replace(ObjectType+'.','');
                break;
            }System.debug( column);
        }
        
        System.debug( ObjectType );
        System.debug( FieldtoUpdate );
     
       
        
//Get DATA - Process CSV
    system.debug('ReportID '+ReportID );

    
     //hit apex regex limits from splitting such a large amount of data so use this safesplit tool
     recordIds= safeSplit(csvList, '\n');
    
    //remove header
     recordIds.remove(0);
    //system.debug('recordIds '+recordIds);
        
        

//Create List 
        soqlQuery = 'Select ID,'+FieldtoUpdate+' from '+ObjectType+' where ID IN :recordIds';
        
        
        System.debug( soqlQuery );
        

        //Send to batch
        DeclarativeSchedulerBatching bat = new DeclarativeSchedulerBatching(recordIds);
        bat.soqlQuery= soqlQuery;
        bat.FieldtoUpdate = FieldtoUpdate;
        bat.ReportID = ReportID;
        
        //batch sizes to custom setting
        Integer BatchSize = 50;
    	try{
        Declarative_Scheduler__c mcs = Declarative_Scheduler__c.getInstance();
        BatchSize = mcs.Batch_Size__c.intValue();
        }catch(exception e){
            
        }
    
        System.debug('BatchSize: '+BatchSize);
        
        if(BatchSize == null || BatchSize < 1){Batchsize = 50 + 0 ;
            System.debug('BatchSize changed to: '+BatchSize);
        }
        
        if(Test.isRunningTest() ){ // test move batch down to 1
            BatchSize=1;
        }

        
        if(recordIds.size()>0  && !Test.isRunningTest()){
        database.executeBatch(bat,Batchsize );  
        System.debug('Batches launched');
        }
        


}
        
           


        
    
    

 
/**
* Split a string of any size, while avoiding the dreaded 'Regex too complicated'
* error, which the String.split(String) method causes on some large inputs.
*
* Note that this method does not avoid other errors, such as those related to 
* excess heap size or CPU time.
*/

List<String> safeSplit(String inStr, String delim){
    Integer regexFindLimit = 4000; // how many records to split at once
    Integer regexFindCount = 0;
    Integer totalprocessed = 0;
    Integer HardLimit = 60000; //how many records to pass back in total
    
    List<String> output = new List<String>();
    
    Matcher m = Pattern.compile(delim).matcher(inStr);
    
    Integer lastEnd = 0;

    while(!m.hitEnd() && totalprocessed < HardLimit)
    {
        while(regexFindCount < regexFindLimit && !m.hitEnd() && totalprocessed < HardLimit)
        {
            totalprocessed ++;
            if(m.find())
            {
                    
                //get the line         
                string line = inStr.substring(lastEnd, m.start());   
                
                //check for blank CSV lines (only commas)
                if (line.replaceAll(',','').trim().length() == 0) break;
                 
                //add the record id to the list
                List<String> fields = line.split(',');  
                recordIds.add(fields[0].replaceAll('"',''));
                    
                
                //output.add(inStr.substring(lastEnd, m.start()));  
                lastEnd = m.end();
            }
            else
            {
                //output.add(inStr.substring(lastEnd));
                lastEnd = inStr.length();
            }
            
            regexFindCount++;
        }

        // Note: Using region() to advance instead of substring() saves 
        // drastically on heap size. Nonetheless, we still must reset the 
        // (unmodified) input sequence to avoid a 'Regex too complicated' 
        // error.
        m.reset(inStr);        
        m.region(lastEnd, m.regionEnd());
        
        regexFindCount = 0;
    }
    
    return recordIds;
}


}