public with sharing class AddressInformationMethods {

    public List<Address_Information__c> newAddressInfos = new List<Address_Information__c>();

    public void validateAndUpdateContact(Map<Id, Address_Information__c> oldMap) {
        
        // This will update the Personal Information section on the Contact object
        //  if the record is set as a "Primary Address".
        
        // 3/28/13 MB: added functionality to clear contact on delete of address record
        
        Set<Id> setclientIds = new Set<Id>();
        Set<String> setZips = new Set<String>();      
        
        for(Address_Information__c add:newAddressInfos) {
        
            setclientIds.add(add.Client__c);
        }        
        
        list<Contact> lstContacts = [Select c.Lives_With__c, c.HomePhone, c.Apt_No__c, c.Building_No__c, 
        							c.City__c, c.Neighborhood__c, c.State__c, c.Street__c, c.Zip__c,
        							(select id, Apt_No__c, Building_No__c, City_Formula__c, City__c, 
        							State_Formula__c, State__c, Neighborhood__c, Street__c, 
        							Home_Phone__c, Contact_Person__c, Relation_to_Client__c, 
        							Relation_to_Client_Other__c, 
        							Contact_Work_Phone__c, Cell_Phone__c, Email__c, Zip_Code__r.Name
        							from Secondary_Address__r where Address_Type__c = 'Primary'
        							order by CreatedDate desc)
        							from Contact c Where c.Id in :setclientIds];
        
        Address_Information__c thisAddress = new Address_Information__c();
        
        for(Contact c :lstContacts) {
            
            //check for duplicate primaries
            if(c.Secondary_Address__r.size() > 1) {
            	
            	//do this because you can only add errors to records in the trigger context
            	oldMap.get(c.Secondary_Address__r[0].Id).Address_Type__c.addError('This client already has a primary'
            	+ ' address. If their primary address has changed, change the type of the other'
            	+ ' address record first.');
            } else if(c.Secondary_Address__r.size() == 0) {
            	
            	c.Apt_No__c = null;
            	c.Building_No__c = null;
            	c.City__c = null;
            	c.State__c = null;
            	c.Zip__c = null;
            	c.Neighborhood__c = null;
            	c.Street__c = null;
            	c.HomePhone = null;
            	c.Lives_With__c = null;
            	
            } else {//size = 1
            	
            	thisAddress = c.Secondary_Address__r[0];
            	
                c.Apt_No__c = thisAddress.Apt_No__c;
                c.Building_No__c = thisAddress.Building_No__c;
				if(thisAddress.City_Formula__c == null || thisAddress.City_Formula__c == '') {
					c.City__c = thisAddress.City__c;
				} else {
					c.City__c = thisAddress.City_Formula__c;
				}
				if(thisAddress.State_Formula__c == null || thisAddress.State_Formula__c == '') {
					c.State__c = thisAddress.State__c;
				} else {
					c.State__c = thisAddress.State_Formula__c;
				}	
                // 11/12/12 MB this line removed because client cell will now be updated on contact directly
                //c.Client_Cell_Phone__c = thisAddress.Client_Cell_Phone__c;
                c.Neighborhood__c = thisAddress.Neighborhood__c;
                c.Street__c = thisAddress.Street__c;
                if(thisAddress.Zip_Code__c == null) {//added 10/8/13, Zip can be null for START clients
                    c.Zip__c = null;
                } else {
                	c.Zip__c = thisAddress.Zip_Code__r.Name;
                }
                // 11/12/12 MB This field was previously updated via similar code in the ClassAddress class. That code is being removed and replicated here
                c.HomePhone = thisAddress.Home_Phone__c;
                
                if(thisAddress.Contact_Person__c != null && thisAddress.Contact_Person__c != '') {
                    c.Lives_With__c = thisAddress.Contact_Person__c + ' (' 
                     + (thisAddress.Relation_to_Client__c == 'Other' ? thisAddress.Relation_to_Client_Other__c : thisAddress.Relation_to_Client__c) 
                     + ')' + (thisAddress.Cell_Phone__c != null ? '\nCell: ' + thisAddress.Cell_Phone__c : '') +
                     + (thisAddress.Contact_Work_Phone__c != null ? '\nWork: ' + thisAddress.Contact_Work_Phone__c : '') +
                     + (thisAddress.Email__c != null ? '\nEmail: ' + thisAddress.Email__c : '');
                }
                else {
                    c.Lives_With__c = null;
                }            	
            	
            }
        }

        update lstContacts;
        
    }
}