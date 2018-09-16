<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AddressTypeInactive</fullName>
        <description>MAke Address type inactive when move out date is entered.</description>
        <field>Address_Type__c</field>
        <literalValue>Inactive</literalValue>
        <name>Address Type Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AddressTypeNone</fullName>
        <description>Make Address Type None if Move out date is empty</description>
        <field>Address_Type__c</field>
        <name>Address Type None</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Address Type None</fullName>
        <actions>
            <name>AddressTypeNone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Address_Information__c.Move_Out_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Address_Information__c.Address_Type__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <description>Change an address type to NONE if move out date is made blank</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Inactive Address</fullName>
        <actions>
            <name>AddressTypeInactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Address_Information__c.Move_Out_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Make an address type INACTIVE once a move out date is entered.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
