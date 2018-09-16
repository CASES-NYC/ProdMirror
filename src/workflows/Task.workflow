<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_SkipRestrictions</fullName>
        <field>SkipRestrictions__c</field>
        <literalValue>1</literalValue>
        <name>Reset SkipRestrictions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_skip_triggers_on_task</fullName>
        <description>Sets the skip_triggers__c flag to false after any task is inserted or updated (flag would only be used via the data loader).</description>
        <field>Skip_Triggers__c</field>
        <literalValue>0</literalValue>
        <name>Reset skip triggers on task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Demetria%27s tasks to Sophia</fullName>
        <actions>
            <name>Reset_SkipRestrictions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>and( Owner:User.Username = &quot;dharvin@cases.org&quot;,  ispickval(Status, &quot;Not Started&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reset skip triggers on task</fullName>
        <actions>
            <name>Reset_skip_triggers_on_task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Skip_Triggers__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
