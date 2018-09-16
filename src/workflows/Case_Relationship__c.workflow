<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>In_Program_Arrest_Notification</fullName>
        <description>In-Program Arrest Notification (CIRT)</description>
        <protected>false</protected>
        <recipients>
            <recipient>CIRT_Rearrest_Notification</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>probinson@cases.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/In_Program_arrest_template</template>
    </alerts>
</Workflow>
