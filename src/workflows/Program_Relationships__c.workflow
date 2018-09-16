<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Default_Referral_Billable_to_No</fullName>
        <field>Referral_Billable__c</field>
        <literalValue>No</literalValue>
        <name>Default Referral Billable to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Referral_Billable_to_Yes</fullName>
        <field>Referral_Billable__c</field>
        <literalValue>Yes</literalValue>
        <name>Default Referral Billable to Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_HH_Service</fullName>
        <description>Set Health Home Care Coordination as Service</description>
        <field>Service_Type_CIRT__c</field>
        <literalValue>Health Home Care Coordination</literalValue>
        <name>Set HH Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Non_Referral_PRs_to_Active</fullName>
        <field>Program_Status_Phone_Visit__c</field>
        <literalValue>Active</literalValue>
        <name>Set Non-Referral PRs to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Non_Referral_PRs_to_Blank</fullName>
        <field>Program_Status_Phone_Visit__c</field>
        <name>Set Non-Referral PRs to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Non_Referral_PRs_to_Exited</fullName>
        <field>Program_Status_Phone_Visit__c</field>
        <literalValue>Completed</literalValue>
        <name>Set Non-Referral PRs to Exited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Program_Status_Insurance</fullName>
        <field>Program_Status_Phone_Visit__c</field>
        <literalValue>Inactive</literalValue>
        <name>Set Program Status Insurance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set APT Services Referral to Active</fullName>
        <actions>
            <name>Set_Non_Referral_PRs_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Program_Relationships__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APT Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Program_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Discharge_Date_Phone_Visit__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set APT Services Referral to Exited</fullName>
        <actions>
            <name>Set_Non_Referral_PRs_to_Exited</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Program_Relationships__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>APT Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Program_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Discharge_Date_Phone_Visit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Non-Referral PRs to Active</fullName>
        <actions>
            <name>Set_Non_Referral_PRs_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 5) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Program_Relationships__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program History,ACS Involvement,Hospitalization,Entitlements History</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.P_C_ID__c</field>
            <operation>contains</operation>
            <value>CRT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Program_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Discharge_Date_Phone_Visit__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.P_C_ID__c</field>
            <operation>contains</operation>
            <value>CEP</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Non-Referral PRs to Blank</fullName>
        <actions>
            <name>Set_Non_Referral_PRs_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Program_Relationships__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program History,ACS Involvement,Hospitalization,Entitlements History</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.P_C_ID__c</field>
            <operation>contains</operation>
            <value>CRT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.P_C_ID__c</field>
            <operation>contains</operation>
            <value>CEP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Program_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Non-Referral PRs to Exited</fullName>
        <actions>
            <name>Set_Non_Referral_PRs_to_Exited</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 5) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Program_Relationships__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Program History,ACS Involvement,Hospitalization,Entitlements History</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.P_C_ID__c</field>
            <operation>contains</operation>
            <value>CRT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Program_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Discharge_Date_Phone_Visit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.P_C_ID__c</field>
            <operation>contains</operation>
            <value>CEP</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Program Status Insurance</fullName>
        <actions>
            <name>Set_Program_Status_Insurance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Program_Relationships__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Health Insurance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Discharge_Date_Phone_Visit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Relationships__c.Program_Status_Phone_Visit__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Set Program Status on Phone Visit for Health Insurance based on End Date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Service for HH</fullName>
        <actions>
            <name>Set_HH_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Relationships__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Health Home</value>
        </criteriaItems>
        <description>Set Service for record type Health Home</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
