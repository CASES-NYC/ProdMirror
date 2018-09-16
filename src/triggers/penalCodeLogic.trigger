trigger penalCodeLogic on Penal_Code__c (after update) {

    chargeMethods chargeMethods = new chargeMethods();
    
    Set<Id> penalIds = new Set<Id>();

    //Determine if the Top Charge calc changed
    for (Penal_Code__c p : Trigger.new){
        if (p.Top_Charge_Calculation__c != Trigger.oldMap.get(p.Id).Top_Charge_Calculation__c){
            penalIds.add(p.Id);
        }
    }
    
    //Find charges with updated penal Ids
    chargeMethods.lstNew = [Select Id, Docket_No__c, Charge__c, Type__c 
            From Case_Charges__c
            where Charge__c IN :penalIds];
    
    //Update Top Charge fields of Cases
    chargeMethods.TopCharges();

}