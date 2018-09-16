trigger caseLogic on Case_Information__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    //this trigger replaces casedeletebefore, casedeleteunafter, caseinsertafter, caseinsertbefore,
    // caseupdateafter, and case updatebefore. Created 3/21/13 by MB
    
    caseValidationMethods caseMethods = new caseValidationMethods();
    
    caseMethods.bolIsNew = Trigger.isInsert || Trigger.isUndelete;
    
    if(trigger.isDelete) {
        caseMethods.mapNew = trigger.OldMap;
    } else {
        caseMethods.mapNew = trigger.NewMap;
        caseMethods.lstNewCases = trigger.New;
        
        if(Trigger.isUpdate) {
        
            caseMethods.lstOldCases = trigger.Old;
        }
    }
    boolean skipUpdate = false;
    
    if(Trigger.isBefore) {
        
        if(Trigger.isInsert || trigger.isUpdate) {
            
            caseMethods.validateCase(); 
        }      
    
        if (Trigger.IsDelete){
          
            caseMethods.deleteCase();
        } 
    }
    
    if(Trigger.isAfter) {
        
        if(trigger.isInsert || Trigger.isUnDelete || trigger.isUpdate) {
            
            for (Case_Information__c ci : Trigger.new){
                    
                //Determine if this update is from the top_charge calculation
                if (trigger.isUpdate && Trigger.oldMap.get(ci.id).Charge_List_Admin__c != ci.Charge_List_Admin__c){
                        
                    SkipUpdate = true;
                    break;
                } 
            } 
            
            caseMethods.createCaseRelationships();      
        }        
        
        // do this for every case, unless the update came from a related Charge
        if(!skipUpdate) {
            //ClassClientStatus.SetClientStatus(clientIds,true);  
            if(trigger.isDelete) {  
                update new list<Contact>([select id from Contact where Intake_Case__c in :trigger.oldMap.keySet()]);
            }  else {
                update new list<Contact>([select id from Contact where Intake_Case__c in :trigger.newMap.keySet()]);
            }
        }           
    }   
}