public with sharing class objectList {
 //Public String strPassed = System.currentPagereference().getParameters().get('passPar');
// public boolean print{get;set;}
 public String val{get;set;}
 public List<String>  allObjects{get;set;}
 public String objValue{get;set;}
 public String SelectedObj{get;set;}
 public List<String> AllLabels{get;set;}
 public string env{get;set;}
 public boolean sb{get;set;}
 public List<SelectOption> objNames {get;set;}
 PageReference pageRef = ApexPages.currentPage();
 
   public class objDescription{
   public string fldName{get;set;}
   public string fldLabel{get;set;}
   public string fldType{get;set;}
   public string fieldlenght{get;set;}
   public string pklist{get;set;}
   public string fldForm{get;set;}
   public List<String> listPL{get;set;}
   public String fldDescr{get;set;}
   public integer fldNumber{get;set;}
   public String rowColor{get;set;}   
   }
public objectList(){
    objNames = 	objNames1();
   string loginname = UserInfo.getUserName();
   string s1 = loginname.substringAfterLast('.');
   if (s1 != 'org'){
   	  sb = true;
   	  env = s1;
   }	  
   else
     env= 'Production';
}
 
  public List<SelectOption> objNames1()
    {
    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();    
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption(' Select object',' Select object'));
    options.add(new SelectOption('Contact','Contact'));
    options.add(new SelectOption('Account','Account'));
    options.add(new SelectOption('Case_Information__c','Case Information'));
    options.add(new SelectOption('Event','Event'));
    options.add(new SelectOption('Program_Cycle__c','Program Cycle'));
    options.add(new SelectOption('Administrative_Actions__c', 'Administrative Actions'));
    options.add(new SelectOption('SF_CRW__c', 'SF_CRW__c'));
    options.add(new SelectOption('SF_CRW_notes__c', 'SF_CRW_notes__c'));
    options.add(new SelectOption('Assessment__c', 'SF_CRW_notes__c'));
    options.add(new SelectOption('Program_Relationships__c', 'Program_Relationships__c'));
    options.add(new SelectOption('Progress_Note__c', 'Progress_Note__c'));
    options.add(new SelectOption('Course__c', 'Course__c'));
    options.add(new SelectOption('Class__c', 'Class__c'));
    options.add(new SelectOption('Session__c', 'Session__c'));
    options.add(new SelectOption('Enrollment__c', 'Enrollment__c'));

    options.sort();
    return options;
   }
   integer index = 0;
 //  public String pklist{get;set;}
   public  List<objDescription> lstDescr{get;set;} 
 
   public PageReference buildDescription(){
   	system.debug('\n\n\n XXX selectDockets: ' + objValue);
   	return null; 
   }
 
    public pageReference doNothing(){
   //   if (print == false)    	
   	     this.selectedObj = val;
   	//  else 
   	//     this.selectedObj = strPassed;
   	  lstDescr = buildAllLabels1();
      return null;}
      
      
   public List<objDescription> buildAllLabels1(){ 
   	  if (val == ' Select object')
   	      return null;
    	System.Debug('\n\n XXX objPassed: ' + val);
       lstDescr = new List<objDescription>();    
       objDescription Descr = new objDescription(); 	
   	List<String> AllLabels1 = new List<String>();
   	List<String> AllLabels2 = new List<String>();
   	string label, str1, str2,str3; 
    string Field;
    List<String> ListPL = new List<String>();
    string fieldtname, fieldtype,fieldlenght, type1, pklist, fldDescr, fieldLabel,fldForm;
    PicklistEntry[] picklistValues;
   	String type = selectedObj  ;  // 'Account';
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType leadSchema = schemaMap.get(type);
    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
    String HelpText;
    Boolean hasHelpText;
    integer inumber = 1;
    for (String fieldName: fieldMap.keySet()) {
    	  Schema.DisplayType myType;
          Descr = new objDescription();    	
          List<Schema.Picklistentry> fld = new List<Schema.Picklistentry>();
          Descr.listPL = new List<String>();
 
          fieldname = fieldMap.get(fieldName).getDescribe().getName();
          fieldlabel = fieldMap.get(fieldName).getDescribe().getLabel();
          fieldlenght = String.ValueOf(fieldMap.get(fieldName).getDescribe().getLength());
          hasHelpText = fieldMap.get(fieldName).getDescribe().getInlineHelpText() != null;
          myType = fieldMap.get(fieldName).getDescribe().getType();
          type1 = String.ValueOf(myType).Trim();
          pklist = '';
          fldForm = '';
          ListPL = new List<String>();
          if(myType == Schema.DisplayType.Picklist){
             fld =fieldmap.get(fieldname).getDescribe().getpicklistValues();
             for(integer i = 0;i < fld.Size();i++){
                if (pklist != null){
                   if (i == fld.Size() - 1)
                      pklist = pklist + fld[i].getvalue(); 
                   else
                      pklist = pklist + fld[i].getvalue()+ ',\n';
                }
                else 
                     pklist = fld[i].getvalue() + '\n';
       //        ListPL.add(fld[i].getvalue()) ;     
             }
          }
    //   if(myType == Schema.DisplayType.TextArea)
          fldForm = fieldmap.get(fieldname).getDescribe().getCalculatedFormula();
System.Debug('\n\n XXX fieldname fldForm :' + fieldname + ' '  + fldForm);
        if (pklist <> '')
            str1 = fieldlabel + '---' + fieldname  + '---' + mytype + '---' + fieldlenght + '---' + pklist;
        else{ 
        if (fldForm <> '' && fldForm <> null){
        	str1 = fieldlabel + '---' + fieldname  + '---' + mytype + '---' + fieldlenght + '---' + fldForm;
        }
        else
            str1 = fieldlabel + '---' + fieldname  + '---' + mytype + '---' + fieldlenght;
        }         
        if (hasHelpText == true){
             HelpText = fieldMap.get(fieldName).getDescribe().getInlineHelpText().trim();
             str2 = str1 + '---' + HelpText;
        }
        else 
             str2 = str1;
     AllLabels1.add(str2);
     }

     AllLabels1.Sort();
     string fldname; 
     System.Debug('\n\n\n XXX AllLabels1: ' + AllLabels1.Size());
   String[] splitData;
   inumber = 1;
   for (integer k = 0; k < AllLabels1.size(); k++ ){
      Descr = new objDescription(); 
      splitData = AllLabels1[k].split('---');
      Descr.fldlabel = splitData[0];
      Descr.fldname = splitData[1];
  	  Descr.fldtype = splitData[2];
  	  Descr.fieldlenght = splitData[3];
  	  if (splitData.Size() > 4)
    	  Descr.pklist = splitData[4];
  	  if (splitData.Size() > 5)
    	  Descr.fldDescr = splitData[5];
      Descr.fldNumber = inumber;    	  
    	  
      if (math.MOD(inumber,2) ==1 )
	     Descr.rowColor = '#fffffe';
      else 
    	 Descr.rowColor = '#e0dfde';
     lstDescr.add(Descr);
     inumber++;
   }
     return lstDescr;
   } 
}