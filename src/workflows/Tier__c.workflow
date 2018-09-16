<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_RAI_Risk_Level_on_Tier</fullName>
        <field>RAI_Risk_Level__c</field>
        <formula>text(Contact__r.RAI_Risk_Level__c)</formula>
        <name>Set RAI Risk Level on Tier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set RAI Risk Level on Tier</fullName>
        <actions>
            <name>Set_RAI_Risk_Level_on_Tier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>using a workflow instead of a formula so that formulas using this value can be used as criteria in roll-up fields.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
