<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Choices 30 days in detention task</fullName>
        <active>true</active>
        <formula>and( Contact_Detained_Dates_Lookup__r.RecordTypeId = &quot;012600000005L5A&quot;, ispickval(Contact_Detained_Dates_Lookup__r.Client_Status__c, &quot;On Program Hold&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Choices_Temp_Exit_Notification</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Detained_Dates__c.Detained_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Choices_Temp_Exit_Notification</fullName>
        <assignedToType>owner</assignedToType>
        <description>This Choices client has been in detention for 30 days and needs to be exited.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Choices Temp Exit Notification</subject>
    </tasks>
</Workflow>
