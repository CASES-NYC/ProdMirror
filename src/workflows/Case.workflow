<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_SF_ticket_closed</fullName>
        <description>Email sent when SF ticket closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Ticket_Closed</template>
    </alerts>
    <alerts>
        <fullName>New_Ticket_Notification</fullName>
        <description>New Ticket Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_ticket_notification</template>
    </alerts>
    <alerts>
        <fullName>New_Ticket_Received</fullName>
        <description>New Ticket Received</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/salesforce_ticket_received</template>
    </alerts>
    <alerts>
        <fullName>Send_Ticket_Closed_Email</fullName>
        <description>Send Ticket Closed Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Ticket_Closed</template>
    </alerts>
    <rules>
        <fullName>Ticket Closed</fullName>
        <actions>
            <name>Send_Ticket_Closed_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When Saleforce ticket closed</description>
        <formula>AND(ISCHANGED(Status), ISPICKVAL(Status,&quot;Closed&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
