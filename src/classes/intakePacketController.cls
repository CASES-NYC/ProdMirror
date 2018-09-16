public without sharing class intakePacketController {
/**
*   {Purpose}   -  TODO:  Controller for the Intake Packet VF page
*
*   {Contact}   - support@demandchainsystems.com
*                 www.demandchainsystems.com
*                 612-424-0032                  
*/

/**
*   CHANGE  HISTORY
*   =============================================================================
*   Date        Name                    Description
*   20141208    Eric Gronholz DCS       Created
*   =============================================================================
*/
    private final Contact oContact;
    private final Id recordId;
    private final UtilityIds utilIds;

    public Case_Information__c oIntakeCase {get;set;}
    public Map<String, List<Case_Relationship__c>> mapRelationships {get;set;} 
    public Event oOrientationEvent {get;set;}
    public Address_Information__c oPrimaryAddress {get;set;}
    public Employment__c oLastEmployment {get;set;}
    public Education__c oLastEducation {get;set;}
    public Administrative_Actions__c oLastAdminAction {get;set;}
    public Assessment__c oLastAssessment {get;set;}

    public List<Case_Relationship__c> lstOpenAtIntake {get;set;}
    public Boolean showOpenAtIntake {get;set;}
    public List<Case_Relationship__c> lstPreIntake {get;set;}
    public Boolean showPreIntake {get;set;}
    public List<Case_Relationship__c> lstPostExit {get;set;}
    public Boolean showPostExit {get;set;}


    ///////////////////////////
    // Constructor
    ///////////////////////////
    public intakePacketController(ApexPages.StandardController scController) {
        this.utilIds = new UtilityIds();
        this.oContact = (Contact)scController.getRecord();
        this.recordId = this.oContact.Id;
        this.lstOpenAtIntake = new List<Case_Relationship__c>();
        this.showOpenAtIntake = false;
        this.lstPreIntake = new List<Case_Relationship__c>();
        this.showPreIntake = false;
        this.lstPostExit = new List<Case_Relationship__c>();
        this.showPostExit = false;
    }

    /////////////////////////////////////
    // Action Method to retrieve all data
    /////////////////////////////////////
    public void findPacketData() {
        if (this.oContact.Intake_Case__c != null) {
            this.oIntakeCase = this.retrieveIntakeCase(this.oContact.Intake_Case__c);
        }
        this.mapRelationships = this.retrieveRelatedCases();
        if (mapRelationships.containsKey('Open at Intake')) {
            this.lstOpenAtIntake = mapRelationships.get('Open at Intake');
            this.showOpenAtIntake = true;
        }
        if (mapRelationships.containsKey('Prior')) {
            this.lstPreIntake = mapRelationships.get('Prior');
            this.showPreIntake = true;
        }
        if (mapRelationships.containsKey('Post-Exit')) {
            this.lstPostExit = mapRelationships.get('Post-Exit');
            this.showPostExit = true;
        }

        this.oOrientationEvent = this.retrieveOrientationEvent();
        this.oPrimaryAddress = this.retrievePrimaryAddress();
        this.oLastEmployment = this.retrieveLastEmployment();
        this.oLastEducation = this.retrieveLastEducation();
        this.oLastAdminAction = this.retrieveLastAdminAction();
        this.oLastAssessment = this.retrieveLastAssessment();
    }

    ////////////////////////////////////////////////////////////////////////////////
    //retrieve the data for all cases associated to the current contact
    ////////////////////////////////////////////////////////////////////////////////
    private Case_Information__c retrieveIntakeCase(Id intakeCaseId) {
        Case_Information__c retVal = new Case_Information__c();
        String soqlStmt = '';

        //loop through all the fields in the Case_Information__c object and retrieve data for the current contact's Intake Case
        String sObjectName = 'Case_Information__c';
        Map<String, Schema.SObjectField> mapFields 
                    = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        for(String sFieldName : mapFields.keySet()) {
            if (soqlStmt == '') {
                soqlStmt = 'SELECT ' + sFieldName;
            } else {
                soqlStmt += ', ' + sFieldName;
            }
        } 
        soqlStmt += ', RecordType.Name';
        soqlStmt += ', Defense_Attorney_Law_Guardian__r.Name';
        soqlStmt += ', Defense_Attorney_Law_Guardian__r.Account.Name';
        soqlStmt += ', Defense_Attorney_Law_Guardian__r.Account.BillingStreet';
        soqlStmt += ', Defense_Attorney_Law_Guardian__r.Account.BillingCity';
        soqlStmt += ', Defense_Attorney_Law_Guardian__r.Account.BillingState';
        soqlStmt += ', Defense_Attorney_Law_Guardian__r.Account.BillingPostalCode';
        soqlStmt += ', Defense_Attorney_Law_Guardian__r.Phone';

        soqlStmt += ' FROM Case_Information__c WHERE Id = :intakeCaseId';

        List<SObject> lstRecs = Database.query(soqlStmt);        
        if (lstRecs.size() > 0) {
            retVal = (Case_Information__c)lstRecs[0];
        }
        return retVal;
    }

    ////////////////////////////////////////////////////////////////////////////////
    //break retrieved records into appropriate holding lists stored in a map by case type
    ////////////////////////////////////////////////////////////////////////////////
    private Map<String, List<Case_Relationship__c>>  retrieveRelatedCases() {
        Map<String, List<Case_Relationship__c>> retVal = new Map<String, List<Case_Relationship__c>>();
        List<Case_Relationship__c> lstHold;

        List<Case_Relationship__c> lstRelationships = this.retrieveAllRelatedCases();
        for (Case_Relationship__c oRelationship : lstRelationships) {
            if (retVal.containsKey(oRelationship.Case_Type__c)) {
                lstHold = retVal.get(oRelationship.Case_Type__c);
            } else {
                lstHold = new List<Case_Relationship__c>();
            }
            lstHold.add(oRelationship);
            retVal.put(oRelationship.Case_Type__c, lstHold);
        }

        return retVal;
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    //retrieve the data for all cases associated to the current contact
    ////////////////////////////////////////////////////////////////////////////////
    private List<SObject> retrieveAllRelatedCases() {

        Set<Id> setIds = new Set<Id>();
        setIds.add(this.recordId);
        String soqlStmt = '';

        //loop through all the fields in the Case_Relationship__c object and retrieve data for current contact id
        String sObjectName = 'Case_Relationship__c';
        Map<String, Schema.SObjectField> mapFields 
                    = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        for(String sFieldName : mapFields.keySet()) {
            if (soqlStmt == '') {
                soqlStmt = 'SELECT ' + sFieldName;
            } else {
                soqlStmt += ', ' + sFieldName;
            }
        } 

        //loop through all the fields in the Docket (Case_Information__c) object and retrieve data for the related records
        sObjectName = 'Case_Information__c';
        mapFields = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        for(String sFieldName : mapFields.keySet()) {
            soqlStmt += ', Docket__r.' + sFieldName;
        } 
        soqlStmt += ', Docket__r.RecordType.Name';

        //loop through all the fields in the Contact object and retrieve data for the related records
        sObjectName = 'Contact';
        mapFields = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        for(String sFieldName : mapFields.keySet()) {
            soqlStmt += ', Contact__r.' + sFieldName;
            soqlStmt += ', Docket__r.Defense_Attorney_Law_Guardian__r.' + sFieldName;
        }

        soqlStmt += ' FROM Case_Relationship__c';
        soqlStmt += ' WHERE Case_Type__c != \'Intake\' And Contact__c IN :setIds ORDER BY CreatedDate';

        List<SObject> lstRecs = Database.query(soqlStmt);        

        return lstRecs;
    }

    //////////////////////////////////////////////////
    // find the orientation event based on record type
    //////////////////////////////////////////////////    
    private Event retrieveOrientationEvent() {
        Event retVal = new Event();
        for (Event oRec : [Select WhoId
                                , WhatId
                                , ActivityDate
                                , ActivityDateTime
                                , RecordType.Name
                            From Event 
                            Where WhoId = :this.recordId
                                And RecordTypeId = :this.utilIds.orientationAppointment
                            Order By ActivityDate DESC 
                            LIMIT 1]) {
            retVal = oRec;
        }

        return retVal;
    }

    //////////////////////////////////////////////////
    // find the primary address of the contact
    //////////////////////////////////////////////////    
    private Address_Information__c retrievePrimaryAddress() {
        Address_Information__c retVal = new Address_Information__c();

        for (Address_Information__c oRec : [Select a.Address_Type__c
                                                , a.Apt_No__c
                                                , a.Building_No__c
                                                , a.Cell_Phone__c
                                                , a.City__c
                                                , a.Client__c
                                                , a.Date_Verified__c
                                                , a.Home_Phone__c
                                                , a.How_Verified__c
                                                , a.Id
                                                , a.Move_In_Date__c
                                                , a.Move_Out_Date__c
                                                , a.State__c
                                                , a.Street__c
                                                , a.Zip__c 
                                            from Address_Information__c a 
                                            where a.Client__c = :this.recordId 
                                                and a.Address_Type__c='Primary' limit 1]) {
            retVal = oRec;
        }

        return retVal;
    }

    //////////////////////////////////////////////////
    // find the latest employment record for the contact
    //////////////////////////////////////////////////    
    private Employment__c retrieveLastEmployment() {
        Employment__c retVal = new Employment__c();

        for (Employment__c oRec : [select e.Client__c
                                        , e.Employer__c
                                        , e.Employer__r.Name
                                        , e.Id
                                        , e.LastActivityDate
                                        , e.Name
                                        , e.Start_Date__c
                                        , e.Work_Hours_from_and_to__c
                                        , e.employer__r.BillingCity
                                        , e.employer__r.BillingCountry
                                        , e.employer__r.BillingPostalCode
                                        , e.employer__r.BillingState
                                        , e.employer__r.BillingStreet
                                        , e.employer__r.Industry
                                        , e.employer__r.Phone 
                                    from Employment__c e 
                                    where e.Client__c = :this.recordId 
                                    order by e.Start_Date__c DESC limit 1]) {
            retVal = oRec;
        }

        return retVal;
    }

    //////////////////////////////////////////////////
    // find all education records for the contact
    //////////////////////////////////////////////////    
    private Education__c retrieveLastEducation() {
        Education__c retVal = new Education__c();

        for (Education__c oRec : [Select e.Id
                                        , e.Name
                                        , e.School_Institution_Hours_From_and_To__c
                                        , e.School_Institution__c
                                        , e.School_Institution__r.BillingCity
                                        , e.School_Institution__r.BillingCountry
                                        , e.School_Institution__r.BillingPostalCode
                                        , e.School_Institution__r.BillingState
                                        , e.School_Institution__r.BillingStreet
                                        , e.School_Institution__r.Industry
                                        , e.School_Institution__r.Name
                                        , e.School_Institution__r.Phone 
                                    from Education__c e 
                                    where e.Client__c = :this.recordId 
                                    order by e.Start_Date__c DESC limit 1]) {
            retVal = oRec;
        }

        return retVal;
    }

    //////////////////////////////////////////////////
    // find all education records for the contact
    //////////////////////////////////////////////////    
    private Administrative_Actions__c retrieveLastAdminAction() {
        Administrative_Actions__c retVal = new Administrative_Actions__c();

        for (Administrative_Actions__c oRec : [Select Client__c
                                                    , Conditions__c
                                                    , Doesnt_Fit_Criteria_Comments__c
                                                    , Name 
                                                from Administrative_Actions__c 
                                                Where Client__c = :this.recordId 
                                                    and (RecordTypeId = :this.utilIds.aaReintake
                                                         or RecordTypeId = :this.utilIds.aaReintakeLocked)
                                                order by Action_Date__c DESC limit 1]) {
            retVal = oRec;
        }

        return retVal;
    }

    //////////////////////////////////////////////////
    // find the latest assessment record for the contact
    //////////////////////////////////////////////////    
    private Assessment__c retrieveLastAssessment() {
        Assessment__c retVal = new Assessment__c();

        for (Assessment__c oRec : [select Contact__c
                                            , RecordType.Name
                                            , Residence__c
                                            , Family_Peers_Section_1__c
                                            , Education_Section_1__c
                                            , Employment_Section_1__c
                                            , Social__c
                                            , Substance_Abuse_Section_1__c
                                            , Health__c
                                            , Legal__c
                                            , Miscellaneous1__c
                                    from Assessment__c e 
                                    where Contact__c = :this.recordId 
                                        and RecordType.Name like 'Court Rep Assessment%'
                                    order by CreatedDate DESC limit 1]) {
            retVal = oRec;
        }

        return retVal;
    }       
}