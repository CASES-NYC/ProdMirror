<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_Email_For_Exit</fullName>
        <description>Notification Email For Exit</description>
        <protected>false</protected>
        <recipients>
            <recipient>snicholas@cases.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notification_Email_for_Exit</template>
    </alerts>
    <alerts>
        <fullName>Notification_For_Extension</fullName>
        <description>Notification For Extension</description>
        <protected>false</protected>
        <recipients>
            <recipient>snicholas@cases.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notification_Email_for_Extension</template>
    </alerts>
</Workflow>
