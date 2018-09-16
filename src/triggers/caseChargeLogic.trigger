trigger caseChargeLogic on Case_Charges__c (after delete, after insert, after undelete, 
after update) {
    
    // this trigger created 3/26/13 by MB to replace TriggerChargesDeleteUnAfter, TriggerChargesInsertAfter,
    // and TriggerChargesUpdateAfter
    
    chargeMethods cls = new chargeMethods();
    if(trigger.isDelete) {
        cls.lstNew = trigger.Old;
    } else {
        cls.lstNew = trigger.New;
    }
     
    //Update Top Charge fields of Cases
    cls.TopCharges();    

}