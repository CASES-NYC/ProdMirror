trigger AddressInformationLogic on Address_Information__c (after insert, after update, after delete) {
    
    // 3/26/13 MB: before insert and before update added from TriggerAddressInsertUpdateBefore.
    // Removed unnecessary code from that trigger by turning Zip Code field into a lookup
    // and making the State and City fields formulas. Also bulkified this code.
    
    // 10/27/14 MB: combined duplicate primary and contact update methods to reduce queries

    AddressInformationMethods addressInfo = new AddressInformationMethods();
    
    if(trigger.isDelete) {
        addressInfo.newAddressInfos = Trigger.old;
    }
    else {
        addressInfo.newAddressInfos = Trigger.new;
    }
    
    if (trigger.isAfter) {
        
        if(trigger.isDelete) {
        	addressInfo.validateAndUpdateContact(Trigger.oldMap);
        } else {
        	addressInfo.validateAndUpdateContact(Trigger.newMap);
        }
    }
}