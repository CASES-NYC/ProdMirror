<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notifacation_for_CC_if_progress_notes_get_enter_for_their_client</fullName>
        <ccEmails>ssamnani@cases.org</ccEmails>
        <description>Notifacation for CC, if progress notes get enter for their client</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Progress_Note_entered_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Populate_Written_By</fullName>
        <description>fill written_by__c with username</description>
        <field>Written_by__c</field>
        <formula>$User.FirstName  &amp; &apos; &apos; &amp;  $User.LastName</formula>
        <name>Populate Written By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Activity_Date_with_Note_Date</fullName>
        <description>When the progress note is not attached to any activity record, copy the information from the note Date field to the Activity Date field</description>
        <field>Activity_Date__c</field>
        <formula>Date__c</formula>
        <name>Update Activity Date with Note Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>No Activity - default Note Date</fullName>
        <actions>
            <name>Update_Activity_Date_with_Note_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Progress_Note__c.Activity_Id_Admin__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the progress note is not attached to any activity record, fill in the Activity Date field with the information in the note&apos;s Date field.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Note written by</fullName>
        <actions>
            <name>Populate_Written_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Progress_Note__c.Written_by__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>capture name of note creator in separate field to preserve name is case of migration or if creator of note was not the writer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
