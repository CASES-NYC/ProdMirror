<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_skip_triggers_on_event</fullName>
        <description>Sets the skip_triggers__c flag to false after any event is inserted or updated (flag would only be used via the data loader).</description>
        <field>Skip_Triggers__c</field>
        <literalValue>0</literalValue>
        <name>Reset skip triggers on event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Reset skip triggers on event</fullName>
        <actions>
            <name>Reset_skip_triggers_on_event</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.Skip_Triggers__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
