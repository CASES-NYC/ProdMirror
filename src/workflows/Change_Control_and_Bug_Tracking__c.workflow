<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>CCBT Original Code Update</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Change_Control_and_Bug_Tracking__c.Original_BTCode__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update text field with BT code on creation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
