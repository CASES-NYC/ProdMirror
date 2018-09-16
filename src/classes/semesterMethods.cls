public with sharing class semesterMethods {
    
    
    public void generateClasses(list<Semester__c> lstNewSemesters) {
        
        list<School_Class__c> lstClassestoInsert = new list<School_Class__c>(); 
        list<School_Class__c> lstClassestoDelete = new list<School_Class__c>(); 
        list<School_Class__c> lstAllClasses = new list<School_Class__c>();  
        list<Id> lstSemesterIds = new list<Id>();
        Map<Id, School_Class__c> mapExistingClasses = new Map<Id, School_Class__c>();
        
        for(Semester__c s: lstNewSemesters) {
            lstSemesterIds.add(s.id);
        }
        
        list<School_Class__c> lstExistingClasses = [select id, Class_Title__c, Subject__c, Grade__c, Result__c, 
                                                    Credits_Attempted__c, Major_Credit__c, Education__c, Semester__c
                                                    from School_Class__c where Semester__c in :lstSemesterIds];

        for(School_Class__c sc: lstExistingClasses) {
            
            mapExistingClasses.put(sc.Id, sc);
        }
        
        for(Semester__c s: lstNewSemesters) {
        
            //refresh variables each time so we can add all of the new classes
            // to the list and insert all at once
            School_Class__c class1 = new School_Class__c();
            School_Class__c class2 = new School_Class__c();
            School_Class__c class3 = new School_Class__c();
            School_Class__c class4 = new School_Class__c();     
            School_Class__c class5 = new School_Class__c();
            
            //find existing classes if they exist, and then modify them as we would new classes
            if(mapExistingClasses.containsKey(s.Class_Id_1__c)) {       
                class1 = mapExistingClasses.get(s.Class_Id_1__c);
            }   
            
            if(mapExistingClasses.containsKey(s.Class_Id_2__c)) {       
                class2 = mapExistingClasses.get(s.Class_Id_2__c);
            }   
            
            if(mapExistingClasses.containsKey(s.Class_Id_3__c)) {       
                class3 = mapExistingClasses.get(s.Class_Id_3__c);
            }   
            
            if(mapExistingClasses.containsKey(s.Class_Id_4__c)) {       
                class4 = mapExistingClasses.get(s.Class_Id_4__c);
            }   
            
            if(mapExistingClasses.containsKey(s.Class_Id_5__c)) {       
                class5 = mapExistingClasses.get(s.Class_Id_5__c);
            }                                                       
            
            //if at least the first class was added, then create a corresponding school class record
            if(s.Class_Title_1__c != null) {
                            
                //copy fields from data entry section of semester
                class1.Class_Title__c = s.Class_Title_1__c;
                class1.Credits_Attempted__c = s.Credits_Attempted_1__c;
                class1.Grade__c = s.Grade_1__c;
                class1.Result__c = s.Result_1__c;
                class1.Subject__c = s.Subject_1__c;
                class1.Major_Credit__c = s.Major_Credit_1__c;
                
                //set relationship info if insert (can't update master-detail relationship)
                if(class1.Semester__c == null) {
                    class1.Education__c = s.Education__c;
                    class1.Semester__c = s.id;
                }
                
                //add to list for insert dml
                lstClassestoInsert.add(class1);
            } else if(s.Class_Id_1__c != null) {// the class info has been cleared, so the class record should be deleted
                
                lstClassestoDelete.add(class1);
            }
            
            //repeat for other 3 class fields
            if(s.Class_Title_2__c != null) {
                
                //copy fields from data entry section of semester
                class2.Class_Title__c = s.Class_Title_2__c;
                class2.Credits_Attempted__c = s.Credits_Attempted_2__c;
                class2.Grade__c = s.Grade_2__c;
                class2.Result__c = s.Result_2__c;
                class2.Subject__c = s.Subject_2__c;
                class2.Major_Credit__c = s.Major_Credit_2__c;
                
                //set relationship info if insert (can't update master-detail relationship)
                if(class2.Semester__c == null) {
                    class2.Education__c = s.Education__c;
                    class2.Semester__c = s.id;
                }
                
                //add to list for insert dml
                lstClassestoInsert.add(class2);
            } else if(s.Class_Id_2__c != null) {// the class info has been cleared, so the class record should be deleted
                
                lstClassestoDelete.add(class2);
            }
            
            if(s.Class_Title_3__c != null) {
                
                //copy fields from data entry section of semester
                class3.Class_Title__c = s.Class_Title_3__c;
                class3.Credits_Attempted__c = s.Credits_Attempted_3__c;
                class3.Grade__c = s.Grade_3__c;
                class3.Result__c = s.Result_3__c;
                class3.Subject__c = s.Subject_3__c;
                class3.Major_Credit__c = s.Major_Credit_3__c;
                
                //set relationship info if insert (can't update master-detail relationship)
                if(class3.Semester__c == null) {
                    class3.Education__c = s.Education__c;
                    class3.Semester__c = s.id;
                }
                
                //add to list for insert dml
                lstClassestoInsert.add(class3);
            } else if(s.Class_Id_3__c != null) {// the class info has been cleared, so the class record should be deleted
                
                lstClassestoDelete.add(class3);
            }
            
            if(s.Class_Title_4__c != null) {
                
                //copy fields from data entry section of semester
                class4.Class_Title__c = s.Class_Title_4__c;
                class4.Credits_Attempted__c = s.Credits_Attempted_4__c;
                class4.Grade__c = s.Grade_4__c;
                class4.Result__c = s.Result_4__c;
                class4.Subject__c = s.Subject_4__c;
                class4.Major_Credit__c = s.Major_Credit_4__c;
                
                //set relationship info if insert (can't update master-detail relationship)
                if(class4.Semester__c == null) {
                    class4.Education__c = s.Education__c;
                    class4.Semester__c = s.id;
                }
                
                //add to list for insert dml
                lstClassestoInsert.add(class4);
            } else if(s.Class_Id_4__c != null) {// the class info has been cleared, so the class record should be deleted
                
                lstClassestoDelete.add(class4);
            }   
            
            if(s.Class_Title_5__c != null) {
                
                //copy fields from data entry section of semester
                class5.Class_Title__c = s.Class_Title_5__c;
                class5.Credits_Attempted__c = s.Credits_Attempted_5__c;
                class5.Grade__c = s.Grade_5__c;
                class5.Result__c = s.Result_5__c;
                class5.Subject__c = s.Subject_5__c;
                class5.Major_Credit__c = s.Major_Credit_5__c;
                
                //set relationship info if insert (can't update master-detail relationship)
                if(class5.Semester__c == null) {
                    class5.Education__c = s.Education__c;
                    class5.Semester__c = s.id;
                }
                
                //add to list for insert dml
                lstClassestoInsert.add(class5);
            } else if(s.Class_Id_5__c != null) {// the class info has been cleared, so the class record should be deleted
                
                lstClassestoDelete.add(class5);
            }               
            
            //add all classes to list
            lstAllClasses.add(class1);  
            lstAllClasses.add(class2);  
            lstAllClasses.add(class3);  
            lstAllClasses.add(class4);
            lstAllClasses.add(class5);                                          
    
        }   //end of new semesters for loop
        
        //before DML, set this static variable so that the roll-up recalculation doesn't cause this method
        // to get triggered again
        utilityIds.bolSchoolClassesAlreadyCreated = true;       
        
        // set this value so that delete won't throw error (classes can't be deleted via the UI)
        UtilityIds.bolDeleteSchoolClasses = true;
        
        upsert lstClassestoInsert;
        delete lstClassestoDelete;
        
        //now loop through semesters again to set the ID value for each class
        // so they can be edited
        
        
        integer i=0;
        
        // have to requery here otherwise we get a "record is read only" error
        lstNewSemesters = [select id, Class_Title_1__c, Class_Id_1__c, Class_Title_2__c, Class_Id_2__c,
                           Class_Title_3__c, Class_Id_3__c, Class_Title_4__c, Class_Id_4__c, Class_Title_5__c, Class_Id_5__c 
                           from semester__c where id in :lstSemesterIds];
        
        for(Semester__c s: lstNewSemesters) {
            
            //if there is a title, this is either an update of an existing or an insert of a new class,
            // so set the id to the corresponding entry in AllClasses. Otherwise the class is being deleted or is blank
            // so clear the id field
            if(s.Class_Title_1__c != null) {
                
                s.Class_Id_1__c = lstAllClasses[i].Id; 
                
            } else { //title is null
            
                s.Class_Id_1__c = null;
            }
            
            i++;
            
            if(s.Class_Title_2__c != null) {
                
                s.Class_Id_2__c = lstAllClasses[i].Id; 
                
            } else { //title is null
            
                s.Class_Id_2__c = null;
            }
            
            i++;
            
            if(s.Class_Title_3__c != null) {
                
                s.Class_Id_3__c = lstAllClasses[i].Id; 
                
            } else { //title is null
            
                s.Class_Id_3__c = null;
            }
            
            i++;
            
            if(s.Class_Title_4__c != null) {
                
                s.Class_Id_4__c = lstAllClasses[i].Id; 
                
            } else { //title is null
            
                s.Class_Id_4__c = null;
            }
            
            i++;    
            
            if(s.Class_Title_5__c != null) {
                
                s.Class_Id_5__c = lstAllClasses[i].Id; 
                
            } else { //title is null
            
                s.Class_Id_5__c = null;
            }
            
            i++;                                                
        }
        
        // have to re-update because this is the after part of the trigger
        update lstNewSemesters;
        
    }

}