<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Temp_replace_Community_Living</fullName>
        <field>Area__c</field>
        <literalValue>Community Tenure</literalValue>
        <name>Temp replace Community Living</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Temp replace Community Living</fullName>
        <actions>
            <name>Temp_replace_Community_Living</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Delete after case info redesign</description>
        <formula>ispickval(Area__c, &quot;Community Living&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
