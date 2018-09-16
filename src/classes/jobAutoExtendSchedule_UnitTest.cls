public class jobAutoExtendSchedule_UnitTest {
    
    public static testMethod void testBatch() {


        utilityIds clsUtilIds = new utilityIds();    

        Test.StartTest();

        jobAutoExtendSchedule job = new jobAutoExtendSchedule();

        String strQuery = 'SELECT ';
                    strQuery += 'UI_Start_Date__c, UI_End_Date__c, Record_Type_RPT__c, RecordTypeId, ';
                    strQuery += 'SystemModstamp, Start_Date__c, Original_Start_Date__c, Original_End_Date__c, ';
                    strQuery += 'Name, Months_of_Sessions_to_Generate__c, LastModifiedDate, LastModifiedById, LastActivityDate, ';
                    strQuery += 'IsDeleted, Id, Extension_Days_to_Generate__c, End_Date__c, CreatedDate, CreatedById, Class__c, ';
                    strQuery += 'Change_Schedule_As_Of__c, AutoExtendFlag__c, ';
                    strQuery += 'Monday__c, Monday_Start_Time__c, Monday_End_Time__c, ';
                    strQuery += 'Tuesday__c, Tuesday_Start_Time__c, Tuesday_End_Time__c, ';
                    strQuery += 'Wednesday__c, Wednesday_Start_Time__c, Wednesday_End_Time__c, ';
                    strQuery += 'Thursday__c, Thursday_Start_Time__c, Thursday_End_Time__c, ';
                    strQuery += 'Friday__c, Friday_Start_Time__c, Friday_End_Time__c, ';
                    strQuery += 'Saturday__c, Saturday_Start_Time__c, Saturday_End_Time__c, ';
                    strQuery += 'Sunday__c, Sunday_Start_Time__c, Sunday_End_Time__c ';
                    strQuery += 'FROM Schedule__c s ';
                    strQuery += 'WHERE s.RecordTypeId = \'' + clsUtilIds.scheduleOngoing + '\' '; 
                    strQuery += 'AND s.End_Date__c > ' + system.now().format('yyyy-MM-dd') + 'T00:00:00Z LIMIT 1';  

                                            
        job.query = strQuery;
        ID batchprocessid = Database.executeBatch(job);

        

        Test.StopTest();
    
    }

}