public class chargeMethods {
   
  public list<Case_Charges__c> lstNew = new list<Case_Charges__c>(); 
   
  public void TopCharges(){
    
    Double dbTopArrest;
    Double dbTopFamily;
    Double dbTopCriminal;
    Double dbTopIndictment;
    Double dbTopPlea;
    
    String strArrestLevel;
    String strArraignmentLevel;
    String strIndictmentLevel;
    String strPleaLevel;  
    
    String strArrestChargeList;
    String strArraignmentChargeList;
    String strIndictmentChargeList;
    String strPleaChargeList;
    
    //Create a set of all case Ids
    Set<Id> caseIds = new Set<Id>();
    for (Case_Charges__c c: lstNew){
      caseIds.add(c.Docket_No__c);
    }
    
    //Get object list from Ids
    List<Case_Information__c> cases = [Select Id, Abbreviated_Record_Type__c, Top_Arrest_Charge__c,
        Top_Family_Court_Arraignment_Charge__c, Top_Criminal_Court_Arraignment_Charge__c, Top_Plea_Charge__c,
        Top_Indictment_Charge__c, Arrest_Date__c, Criminal_Court_Arraignment_Date__c, Indictment_Date__c, 
        Plea_Finding_Date__c, Charge_List_Admin__c, 
            (select Id, Docket_No__c, Charge__c, Type__c, Charge_Level__c, Charge__r.Name,
            Charge__r.Top_Charge_Calculation__c, Charge__r.Description__c
            From Case_Charges__r
            order by Docket_No__c asc, Type__c asc, Charge__r.Top_Charge_Calculation__c desc)
        from Case_Information__c where Id IN :caseIds];    

    
    for (Case_Information__c c:cases){
      //strRT = c.RecordTypeId;
      //Reset values
      dbTopArrest = 0;
      dbTopFamily = 0;
      dbTopCriminal = 0;
      dbTopIndictment = 0;
      dbTopPlea = 0;
      
      strArrestLevel = null;
      strArraignmentLevel = null;
      strIndictmentLevel = null;
      strPleaLevel = null;   
      
      strArrestChargeList = 'Arrest Charges: ' + (c.Arrest_Date__c == null ? '' : c.Arrest_Date__c.format());
      strArraignmentChargeList = 'Arraignment Charges: ' 
        + (c.Criminal_Court_Arraignment_Date__c == null ? '' : c.Criminal_Court_Arraignment_Date__c.format());
      strIndictmentChargeList = 'Indictment Charges: ' 
        + (c.Indictment_Date__c == null ? '' : c.Indictment_Date__c.format());
      strPleaChargeList = 'Plea/Finding Charges: ' 
        + (c.Plea_Finding_Date__c == null ? '' : c.Plea_Finding_Date__c.format());  
      
      
      for (Case_Charges__c charge: c.Case_Charges__r){
        
        if (charge.Charge_Level__c == 'F'){
          c.Includes_Felony_Charge__c = true;
        }
        
          
          if (charge.Type__c == 'Arrest Charges'){
            if (dbTopArrest == 0){
              dbTopArrest = charge.Charge__r.Top_Charge_Calculation__c;
              c.Top_Arrest_Charge__c = charge.Charge__r.Name;
              strArrestLevel = charge.Charge_Level__c;
            }
            strArrestChargeList = strArrestChargeList + '\n' +charge.charge__r.Name 
            + ' ' + charge.charge__r.Description__c;
            
          } else if (charge.Type__c == 'Criminal Court Arraignment Charges'){
            if (dbTopCriminal == 0 && 
            (c.Abbreviated_Record_Type__c == 'Criminal Court'|| c.Abbreviated_Record_Type__c == 'Supreme Court')){
              dbTopCriminal = charge.Charge__r.Top_Charge_Calculation__c;
              c.Top_Criminal_Court_Arraignment_Charge__c = charge.Charge__r.Name;
              strArraignmentLevel = charge.Charge_Level__c;
            }
            strArraignmentChargeList = strArraignmentChargeList + '\n' +charge.charge__r.Name 
            + ' ' + charge.charge__r.Description__c;
                        
          } else if (charge.Type__c == 'Indictment Charges'){
            if (dbTopIndictment == 0 && c.Abbreviated_Record_Type__c == 'Supreme Court'){
              dbTopIndictment = charge.Charge__r.Top_Charge_Calculation__c;
              c.Top_Indictment_Charge__c = charge.Charge__r.Name;
              strIndictmentLevel = charge.Charge_Level__c;
            }
            strIndictmentChargeList = strIndictmentChargeList + '\n' +charge.charge__r.Name 
            + ' ' + charge.charge__r.Description__c;            
            
          } else if (charge.Type__c == 'Family Court Arraignment Charges'){
            if (dbTopFamily == 0 && c.Abbreviated_Record_Type__c == 'Family Court'){
              dbTopFamily = charge.Charge__r.Top_Charge_Calculation__c;
              c.Top_Family_Court_Arraignment_Charge__c = charge.Charge__r.Name;
              strArraignmentLevel = charge.Charge_Level__c;
            }
          }
          else if (charge.Type__c == 'Plea/ Finding Charges'){
            if (dbTopPlea == 0 && 
            (c.Abbreviated_Record_Type__c == 'Criminal Court'|| c.Abbreviated_Record_Type__c == 'Supreme Court')){
              dbTopPlea = charge.Charge__r.Top_Charge_Calculation__c;
              c.Top_Plea_Charge__c = charge.Charge__r.Name;
              strPleaLevel = charge.Charge_Level__c;
            }
            strPleaChargeList = strPleaChargeList + '\n ' +charge.charge__r.Name 
            + ' ' + charge.charge__r.Description__c;              
          }          
        } //end of charges loop
        
        c.Top_Arrest_Charge_Level__c = strArrestLevel;
        c.Top_Arraignment_Charge_Level__c = strArraignmentLevel;
        c.Top_Indictment_Charge_Level__c = strIndictmentLevel;
        c.Top_Plea_Charge_Level__c = strPleaLevel;
      
        c.Charge_List_Admin__c = (strArrestChargeList.contains('\n') ? strArrestChargeList : '') 
        + (strArraignmentChargeList.contains('\n') ? '\n' + strArraignmentChargeList : '') 
        + (strIndictmentChargeList.contains('\n') ? '\n' + strIndictmentChargeList : '') 
        + (strPleaChargeList.contains('\n') ? '\n' + strPleaChargeList : '');
    }//end of case loop
    
    update cases;  
    
  }
}