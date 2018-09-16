public class courseCatalog {

    ///////////////////////////////////////////
    // This class manages the Course Catalog VF Page 
    // Author:  AAB / DCS
    // Created:  20110324 
    ///////////////////////////////////////////

    public String fromTRPlink = System.currentPagereference().getParameters().get('fromTRPlink');
    public ID idUser = System.currentPagereference().getParameters().get('user');
    
    public List<SelectOption> soArea {get;set;}
    public List<SelectOption> soCategory {get;set;}
    public List<classesForDisplay> clsForDisplay = new List<classesForDisplay>();
    public Date dteStartDate {get;set;}
    public Date dteEndDate {get;set;}
    public Task tskDummy {get;set;}
    public String strQuery {get;set;}
    public Integer intClassType {get;set;}
    public String strResult {get;set;}
    public String strEnrollmentClassId {get;set;}
    public Course__c coSearch {get;set;}
    public Boolean bolShowEnrollment {get;set;}    
    
   // public Boolean showEnrollment {get;set;}    
    
    ////////////////////////////////////////////
    // Helper Classes
    ////////////////////////////////////////////
        
    public class classesForDisplay {
        
        public Class__c cls {get;set;}
        public String color {get;set;}
        public Boolean bolShowEnrollment {get;set;}
    }
    
    ////////////////////////////////////////////
    // Constructor and Getter Methods 
    ////////////////////////////////////////////
    
    public courseCatalog(ApexPages.StandardController controller) {     
    
    }
    
    public courseCatalog() {
        
        // Get regular Variables
        strResult = ApexPages.currentPage().getParameters().get('result');
        coSearch = new Course__c();
        
        // Format Text for Results
        if(strResult != null) {
            if(strResult == 'referralsuccess') {
                strResult = 'A Career Exploration Referral was successfully created!';          
            }
        }
        
        // Populate soArea
        Schema.DescribeFieldResult frArea = Course__c.Area__c.getDescribe();
        List<Schema.PicklistEntry> pleArea = frArea.getPicklistValues();
        
        soArea = new List<SelectOption>();
        soArea.add(new SelectOption('', '- All -'));
        
        for(Schema.PicklistEntry f : pleArea) {
            soArea.add(new SelectOption(f.getLabel(), f.getLabel()));
        }
        
        // Populate Category
        Schema.DescribeFieldResult frCategory = Course__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> pleCategory = frCategory.getPicklistValues();
        
        soCategory = new List<SelectOption>();
        soCategory.add(new SelectOption('', '- All '));
        
        for(Schema.PicklistEntry f : pleCategory) {
            soCategory.add(new SelectOption(f.getLabel(), f.getLabel()));
        }       

        // Create instance of "dummy task" for field formatting and set defaults based on custom setting values
        this.tskDummy = new Task();
        System_Limits__c csSystemDefaults = System_Limits__c.getInstance();

        if (csSystemDefaults.Course_Catalog_Start_Date_Offset__c != null) {
            this.tskDummy.ActivityDate = System.Today().addDays(Integer.valueOf(csSystemDefaults.Course_Catalog_Start_Date_Offset__c));
        }   
            
        if (csSystemDefaults.Course_Catalog_End_Date_Offset__c != null) {
            this.tskDummy.Catalog_End_Date__c = System.Today().addDays(Integer.valueOf(csSystemDefaults.Course_Catalog_End_Date_Offset__c));
        }
               
        bolShowEnrollment = true;
        
        //TRP Filter
        if (fromTRPlink <> null){
            coSearch.area__c = 'Substance Abuse';
            coSearch.Category__c = 'TRP One Day Session';
            bolShowEnrollment = false;            
        }
        
        if(idUser != null) {
            
            User u = [select id, Unit__c, Department__c, userRole.Name from User where id = :idUser limit 1];
            
            if(u.Unit__c == 'Education' || u.Unit__c == 'Employment' 
            || u.Unit__c == 'Mental Health' || u.Unit__c == 'Substance Abuse') {
                
                coSearch.area__c = u.Unit__c;
            }               
            
            if(u.userRole.Name != 'Executive' && u.userRole.Name != 'IS Admin')
                
                coSearch.Programs_Served__c = u.Department__c;
        }  
    }
    
    public List<classesForDisplay> getClasses() {
       // added by LZ 6/01/2016 
       // not show classes CategoryRPT__c == 'Mandatory Class' and Record_Type_RPT__c == 'Ongoing'
       boolean showEnrollment;
       ID userLogin = userInfo.getUserId();
    //   User u = [Select Department__c from user where id =: userLogin limit 1];
   //    if (u.Department__c <> null && u.Department__c <> ''){
   //       if (u.Department__c == 'PEAK')
   //          showEnrollment = true; }
       
       Id userProfId = userInfo.getProfileId();
       Profile p = [Select name from Profile where id =: userProfId limit 1];
       if (p.Name == 'System Administrator'|| p.name == 'Strategic Planning')
          showEnrollment = true;
       // end LZ changes 
       
     //  showEnrollment = false;  
        clsForDisplay.clear(); /// CLEAR OUT PREVIOUS
        
        strQuery = 'SELECT Id, Course__r.Name, Class_Title__c, Record_Type_RPT__c, AreaRPT__c, ' 
        +'CategoryRPT__c, First_Session_On__c, Last_Session_On__c, Programs_Served__c, ' 
        +'Serves_All_Programs__c,Hidden_On_Course_Catalog__c FROM Class__c ';
        
        String strCriteria = 'WHERE';
        
        if(coSearch.Area__c != null) {
            strCriteria += ' AreaRPT__c = \'' + coSearch.Area__c + '\'';
        }
        
        if(coSearch.Category__c != null) {
            if(strCriteria.length() > 5) {
                strCriteria += ' AND CategoryRPT__c = \'' + coSearch.Category__c + '\'';
            } else {
                strCriteria += ' CategoryRPT__c = \'' + coSearch.Category__c + '\'';
            }
        }
 
  // QC 20120615 - Ongoing classes weren't showing up in course catalog search because no end date
          if(this.tskDummy.ActivityDate != null) {
            if(strCriteria.length() > 5) {
                //strCriteria += ' AND First_Session_On__c >= ' + String.valueOf(tskDummy.ActivityDate);
                strCriteria += ' AND (Last_Session_On__c >= ' + String.valueOf(this.tskDummy.ActivityDate);
                strCriteria += ' OR Last_Session_On__c = null)';
            } else {
                //strCriteria += ' First_Session_On__c >= ' + String.valueOf(tskDummy.ActivityDate);
                strCriteria += ' (Last_Session_On__c >= ' + String.valueOf(this.tskDummy.ActivityDate);
                strCriteria += ' OR Last_Session_On__c = null)';
 
            }
        }

 
        if(this.tskDummy.Catalog_End_Date__c != null) {
            if(strCriteria.length() > 5) {
                //strCriteria += ' AND Last_Session_On__c <= ' + String.valueOf(tskDummy.Catalog_End_Date__c);
                strCriteria += ' AND (First_Session_On__c <= ' + String.valueOf(this.tskDummy.Catalog_End_Date__c);
                strCriteria += ' OR First_Session_On__c = null)';
            } else {
                //strCriteria += ' Last_Session_On__c <= ' + String.valueOf(tskDummy.Catalog_End_Date__c);
                strCriteria += ' (First_Session_On__c <= ' + String.valueOf(this.tskDummy.Catalog_End_Date__c);
                strCriteria += ' OR First_Session_On__c = null)';
            }
        }
        
        
        //20120626 ebg - search for programs serving the class; since Program(s) served is a multi-pick list, we need
        //               to loop through all selected values and build the where clause with a bunch of OR statements
        if(coSearch.Programs_Served__c != null) {
            List<String> lstProgramsServed = coSearch.Programs_Served__c.split(';');
            if(strCriteria.length() > 5) {
                strCriteria += ' AND (Programs_Served__c includes (';
            } else {
                strCriteria += ' Programs_Served__c includes (';
            }
            
            Integer intCounter = 0;
            for (String strProgram : lstProgramsServed) {
                strCriteria += '\'' + strProgram + '\',';
            }
            //remove the last comma
            strCriteria = strCriteria.substring(0, strCriteria.length()-1);
            
            
            strCriteria += ' ) or Serves_All_Programs__c = TRUE) ';
        
        }
        
        
        if(strCriteria.length() > 5) {
            strQuery += strCriteria;
        }
        
        strQuery += ' ORDER BY Course__r.Name ASC, First_Session_On__c DESC';
        
        if(test.isRunningTest()) {
            strQuery += ' LIMIT 5';
        }

        
        List<Class__c> classesFromQuery = Database.query(strQuery);
        Set<Id> setHiddenclasses = new Set<Id>();
        // Pull Ids from Class List
        List<Id> lstClassIds = new List<Id>();
        for(Class__c thisClass:classesFromQuery) {
            lstClassIds.add(thisClass.Id);
            if (thisClass.Hidden_On_Course_Catalog__c == true)
               setHiddenclasses.add(thisClass.id);
        }
        
        
       System.Debug('\n\n XXX setHiddenclasses: ' + setHiddenclasses);
        List<Schedule__c> lstSchedules = [SELECT Id, Class__c, Dummy_Schedule__C 
                                            FROM Schedule__c WHERE Class__c IN :lstClassIds];
                                            
        Map<Id, Boolean> mapSchedules = new map<Id, Boolean>();
        
        for(Schedule__c s: lstSchedules) {
            mapSchedules.put(s.Class__c, s.Dummy_Schedule__c);

        }       
        // Assemble Display Class List
       for(Class__c thisClass:classesFromQuery) {
          
            // Initial Object
            classesForDisplay nClsForDisplay = new classesForDisplay();
            nClsForDisplay.cls = thisClass;
            
            // Determine if a schedule exists to show "New Enrollment" button
            // if schedule is a dummy then don't display the class
            nClsForDisplay.bolShowEnrollment = false;
            
            if(mapSchedules.containsKey(thisClass.Id)) {
               if(mapSchedules.get(thisClass.ID) != true){//not a dummy schedule
               	if (showEnrollment == true || thisClass.Hidden_On_Course_Catalog__c == false) {
                nClsForDisplay.bolShowEnrollment = true;
                        clsForDisplay.add(nClsForDisplay);}}}   	
               	
          /*     	
                 if (thisClass.CategoryRPT__c == 'Mandatory Class' 
                    && thisClass.Record_Type_RPT__c == 'Ongoing'){
                    if (showEnrollment == true || setHiddenclasses.contains(thisclass.id) == false){
                        nClsForDisplay.bolShowEnrollment = true;
                        clsForDisplay.add(nClsForDisplay);}
                 }
                  else{
                      nClsForDisplay.bolShowEnrollment = true;
                      clsForDisplay.add(nClsForDisplay);}
              }                 
                                
            }
            
             else {
                if (thisClass.CategoryRPT__c == 'Mandatory Class' 
                    && thisClass.Record_Type_RPT__c == 'Ongoing'){
                    if (showEnrollment == true || setHiddenclasses.contains(thisclass.id) == false)
                       clsForDisplay.add(nClsForDisplay);}
             else 
                   clsForDisplay.add(nClsForDisplay);            
             }
       */
        }                          
        
        
        return clsForDisplay;
        
    }
    
    ////////////////////////////////////////////
    // Action Methods 
    ////////////////////////////////////////////
    
    public void doNothing() { }
    
    public void clearSearch() {
        
        this.tskDummy.ActivityDate = null;
        this.tskDummy.Closing_Date__c = null;
        
    }
    
    
    public PageReference createNewClass() {
        
        String idRecordType = '';
        System.Debug('courseCatalog.createNewClass INFO:  intClassType = ' + intClassType);
        if(intClassType == 0) { idRecordType = Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Single').getRecordTypeId();}
        if(intClassType == 1) { idRecordType = Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Fixed').getRecordTypeId();}
        if(intClassType == 2) { idRecordType = Schema.SObjectType.Class__c.getRecordTypeInfosByName().get('Ongoing').getRecordTypeId();}
        
        PageReference prCreate = new PageReference('/a0c/e?RecordType=' + idRecordType + '&retURL=/apex/courseCatalog');
        prCreate.setRedirect(true);
        return prCreate;
        
    }
    
    public PageReference createNewCourse() {
        
        System.Debug('courseCatalog.createNewCourse INFO:  Redirecting user');
        
        PageReference prCreate = new PageReference('/a0b/e?retURL=/apex/courseCatalog');
        prCreate.setRedirect(true);
        return prCreate;
        
    }

}