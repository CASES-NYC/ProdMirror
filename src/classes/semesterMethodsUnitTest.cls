@isTest
private class semesterMethodsUnitTest {

    static testMethod void createSchoolClassesFromSemesterForm() {
        
        UtilityIds utilIds = new utilityIds();
        
        Account edProvider = new Account();
        edProvider.Name = 'Test School';
        insert edProvider;
        
        Account edProvider2 = new Account();
        edProvider2.Name = 'Test School 2';
        insert edProvider2;
        
        Contact c = [select id from contact where client_status__c = 'Active' order by CreatedDate desc limit 1];
        
        list<Education__c> lstEdforInsert = new list<Education__c>();
        
        Education__c ed1 = new Education__c();
        ed1.Client__c = c.id;
        ed1.School_Institution__c = edProvider.id;
        ed1.Start_Date__c = Date.newInstance(2011,9,1);
        ed1.End_Date__c = Date.newInstance(2012,7,31);
        ed1.Reason_for_Leaving__c = 'Graduated';
        ed1.Institution_Type__c = 'College';
        ed1.RecordtypeId = utilIds.eduCollege;
        lstEdforInsert.add(ed1);
        
        Education__c ed2 = new Education__c();
        ed2.Client__c = c.id;
        ed2.School_Institution__c = edProvider2.id;
        ed2.Start_Date__c = Date.newInstance(2012,9,1);
        ed2.Institution_Type__c = 'College';
        ed2.RecordtypeId = utilIds.eduCollege;
        lstEdforInsert.add(ed2);   
        
        insert lstEdForInsert;
        
        list<Semester__c> lstSemesters = new list<Semester__c>();
        
        Semester__c ed1sem1 = new Semester__c();
        ed1sem1.Education__c = ed1.id;
        ed1sem1.Period__c = 'Fall';
        ed1sem1.Year__c = '2011';     
        ed1sem1.Class_Title_1__c = 'Calculus 1';
        ed1sem1.Credits_Attempted_1__c = 5;
        ed1sem1.Subject_1__c = 'Mathematics';
        ed1sem1.Result_1__c = 'Passed';
        ed1sem1.Grade_1__c = 'B';
        lstSemesters.add(ed1sem1);
        
        
        Semester__c ed1sem2 = new Semester__c();
        ed1sem2.Education__c = ed1.id;
        ed1sem2.Period__c = 'Spring';
        ed1sem2.Year__c = '2012';     
        ed1sem2.Class_Title_2__c = 'French 1';
        ed1sem2.Credits_Attempted_2__c = 3;
        ed1sem2.Subject_2__c = 'Foreign Languages';
        ed1sem2.Result_2__c = 'Pending';  
        ed1sem2.Class_Title_3__c = 'Intro to Creative Writing';
        ed1sem2.Credits_Attempted_3__c = 2;
        ed1sem2.Subject_3__c = 'Writing';
        ed1sem2.Result_3__c = 'Passed';
        ed1sem2.Grade_3__c = 'A';
        lstSemesters.add(ed1sem2);
        
        Semester__c ed2sem1 = new Semester__c();
        ed2sem1.Education__c = ed2.id;
        ed2sem1.Period__c = 'Fall';
        ed2sem1.Year__c = '2012';     
        ed2sem1.Class_Title_4__c = 'Econ 101';
        ed2sem1.Credits_Attempted_4__c = 5;
        ed2sem1.Subject_4__c = 'Social Sciences';
        ed2sem1.Result_4__c = 'Failed';
        ed2sem1.Grade_4__c = 'D-';
        ed2sem1.Class_Title_5__c = 'British Colonialism in the 19th century';
        ed2sem1.Result_5__c = 'Passed';
        ed2sem1.Subject_5__c = 'Social Sciences';
        ed2sem1.Credits_Attempted_5__c = 3;
        ed2sem1.Grade_5__c = '9/10';
        ed2sem1.Major_Credit_5__c = true;        
        lstSemesters.add(ed2sem1);
        
        test.startTest();
        
        insert lstSemesters;
        
        //make changes and check to see that they are copied to the school class records correctly
        ed1sem1.Class_Title_1__c = 'Advanced Calculus';
        
        ed1sem2.Result_2__c = 'Passed';
        ed1sem2.Grade_2__c = 'B-'; 
        ed1sem2.Credits_Attempted_3__c = 3;
        
        //delete a class
        ed2sem1.Class_Title_4__c  = null;
        ed2sem1.Result_4__c = null;
        ed2sem1.Subject_4__c = null;
        ed2sem1.Credits_Attempted_4__c = null;
        
        // so we can check that the id was deleted
        id idDelClass = ed2sem1.Class_Id_4__c;
        
        //insert a new class
        ed2sem1.Class_Title_1__c = 'Econ 101';
        ed2sem1.Result_1__c = 'Passed';
        ed2sem1.Subject_1__c = 'Social Sciences';
        ed2sem1.Credits_Attempted_1__c = 5;
        ed2sem1.Grade_1__c = '84';
        ed2sem1.Major_Credit_1__c = true;
        
        //delete a class
        ed2sem1.Class_Title_5__c = null;
        ed2sem1.Result_5__c = null;
        ed2sem1.Subject_5__c = null;
        ed2sem1.Credits_Attempted_5__c = null;
        ed2sem1.Grade_5__c = null;
        ed2sem1.Major_Credit_5__c = false;
        
        id idDelClass2 = ed2sem1.Class_Id_5__c;
        
        // need to manually reset this so that the update won't be skipped
        // usually this would be set to null each time a user triggers semesterLogic, so it's only an issue in the test
        utilityIds.bolSchoolClassesAlreadyCreated = false;
        
        update lstSemesters;
        
        //requery to get class ids on semester object
        ed2sem1 = [select id, Class_Id_1__c from Semester__c where id = :ed2sem1.id];
        ed1sem2 = [select id, Class_Id_3__c from Semester__c where id = :ed1sem2.id];
        
        list<School_Class__c> scDeleted = [select id from School_Class__c where id = :idDelClass or id = :idDelClass2];
        system.assertEquals(scDeleted.size(), 0);
        
        School_Class__c ed1sem2sc3 = [select id, Class_Title__c, Result__c, Credits_Attempted__c from School_Class__c 
                                      where id = :ed1sem2.Class_Id_3__c limit 1];                             
        system.assertEquals(ed1sem2sc3.Credits_Attempted__c, 3);
        
        School_Class__c ed2sem1sc1 = [select id, Class_Title__c from School_Class__c 
                                      where id = :ed2sem1.Class_Id_1__c limit 1];
        system.assertEquals(ed2sem1sc1.Class_Title__c, 'Econ 101');
        
        //test deletions
        
        //cant delete manually
        try{ delete ed1sem2sc3;}
        catch(exception e) {system.debug(e);}

        // need to manually reset this before each delete, because the test runs as a single piece of code
        // whereas each delete is a single operation when triggered by a user
        utilityIds.bolDeleteSchoolClasses = false;
        delete ed2sem1;
        utilityIds.bolDeleteSchoolClasses = false;
        delete ed1;
        
        list<School_Class__c> scDeletedbyEdRecord = [select id from School_Class__c where id = :ed1sem2sc3.id limit 1];
        system.assertEquals(scDeletedbyEdRecord.size(), 0);
        
        test.stopTest();
    }
}