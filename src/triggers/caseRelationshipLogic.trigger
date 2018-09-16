trigger caseRelationshipLogic on Case_Relationship__c (Before Insert) {

    for(Case_Relationship__c cr: trigger.New) {
    
        //this is a unique id field, so it prevents duplicate case/contact pairs
        cr.Unique_Id__c = cr.Docket__c + ';' + cr.Contact__c;
    }

}