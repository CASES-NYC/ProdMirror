<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Discharge_Date_Escort_Date</fullName>
        <description>Set Discharge Date = Escort Date when Program Status = Never Enrolled</description>
        <field>Discharge_Date__c</field>
        <formula>Escort_Date__c</formula>
        <name>Discharge Date = Escort Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Discharge_Date_Ph_Visit_Escort_Date</fullName>
        <description>Set Discharge Date = Escort Date when Program Status = Never Enrolled</description>
        <field>Discharge_Date_By_Phone_Visit__c</field>
        <formula>Escort_Date__c</formula>
        <name>Discharge DatePh/Visit = Escort Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Discharge Date When Never Enrolled FLWUP</fullName>
        <actions>
            <name>Discharge_Date_Ph_Visit_Escort_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>FollowUp__c.Program_Status__c</field>
            <operation>equals</operation>
            <value>Never Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>FollowUp__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Treatment Program Follow Up</value>
        </criteriaItems>
        <description>Set Discharge Date = Escort Date when Program Status = Never Enrolled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
