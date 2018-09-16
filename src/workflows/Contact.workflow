<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Choices_client_60days</fullName>
        <description>Choices client has reached 60 days in program</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Coordinator_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>probinson@cases.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Court_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Choices_60_day_notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Case_Coordinator_notification_of_new_assigned_client</fullName>
        <description>Send Case Coordinator notification of new assigned client</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Coordinator_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Case_Coordinator</template>
    </alerts>
    <fieldUpdates>
        <fullName>Client_Status_from_Cycle_Active</fullName>
        <field>Client_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Client Status from Cycle: Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>If_Mandate_Length_is_12_12_Month_Mandate</fullName>
        <description>If Mandate Length = 12, Is This a 12 Month Mandate should = Yes</description>
        <field>Is_this_a_12_month_mandate__c</field>
        <literalValue>Yes</literalValue>
        <name>If Mandate Length = 12, 12 Month Mandate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_This_a_12_Month_Mandate_Y</fullName>
        <field>Is_this_a_12_month_mandate__c</field>
        <literalValue>Yes</literalValue>
        <name>Is This a 12 Month Mandate = Y</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mandate_Length_12_12_Mo_Mandate_Y</fullName>
        <description>If</description>
        <field>Is_this_a_12_month_mandate__c</field>
        <literalValue>Yes</literalValue>
        <name>Mandate Length = 12, 12 Mo. Mandate = Y</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mandate_Length_12_12_mo_mandate_N</fullName>
        <description>If Mandate Length is not 12, &quot;Is this a 12 month mandate&quot; =  No</description>
        <field>Is_this_a_12_month_mandate__c</field>
        <literalValue>No</literalValue>
        <name>Mandate Length != 12, 12 mo. mandate = N</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mandate_Length_6_12_Mo_Mandate_No</fullName>
        <description>If Mandate Length = 6, Is This a 12 Month Mandate = No</description>
        <field>Is_this_a_12_month_mandate__c</field>
        <literalValue>No</literalValue>
        <name>Mandate Length = 6, 12 Mo Mandate = No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mandate_Length_blank_12_Mo_Mandate_blan</fullName>
        <description>If Mandate Length is blank, Is This a 12 Month Mandate must also be blank</description>
        <field>Is_this_a_12_month_mandate__c</field>
        <name>Mandate Length blank 12 Mo Mandate blan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Current_Exit_Date_for_QJC</fullName>
        <field>Current_Exit_Date__c</field>
        <formula>if(
not(isblank(Exit_Date_2__c)),Exit_Date_2__c,
if(
isblank(Exit_Date_1__c),null,
if(
isblank(Intake_Date__c),Exit_Date_1__c, null
)))</formula>
        <name>Set Current Exit Date for QJC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SYEP_Sharing</fullName>
        <field>SYEP_Sharing_Setting__c</field>
        <formula>if(includes(SYEP_Participation__c , &quot;2013&quot;), &quot;True&quot;, &quot;False&quot;)</formula>
        <name>Set SYEP Sharing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Successful_START_Exit</fullName>
        <field>PRP_Status__c</field>
        <literalValue>Successful Exit</literalValue>
        <name>Successful START Exit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Current_Exit_Date_from_Cycle</fullName>
        <field>Current_Exit_Date__c</field>
        <formula>Most_Recent_Program_Cycle__r.End_Date__c</formula>
        <name>Update Current Exit Date from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Current_Intake_Date_from_Cycle</fullName>
        <field>Current_Intake_Date__c</field>
        <formula>Most_Recent_Program_Cycle__r.Start_Date__c</formula>
        <name>Update Current Intake Date from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Exit_Reason_from_Cycle</fullName>
        <field>Exit_Reason__c</field>
        <formula>text(Most_Recent_Program_Cycle__r.Exit_Reason__c)</formula>
        <name>Update Exit Reason from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X12_month_Mandate_Blank</fullName>
        <field>Is_this_a_12_month_mandate__c</field>
        <name>12 month Mandate = Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X12_month_Mandate_No</fullName>
        <field>Is_this_a_12_month_mandate__c</field>
        <literalValue>No</literalValue>
        <name>12 month Mandate = No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEO Client activate</fullName>
        <actions>
            <name>Client_Status_from_Cycle_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Screening_Stage__c</field>
            <operation>equals</operation>
            <value>Screening Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>CEO Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Exit_Date_1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Client_Status__c</field>
            <operation>notEqual</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mandate Length %3D 12%2C 12 Mo%2E Mandate %3D Y</fullName>
        <actions>
            <name>Is_This_a_12_Month_Mandate_Y</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Mandate_Length__c</field>
            <operation>equals</operation>
            <value>12</value>
        </criteriaItems>
        <description>If Mandate Length = 12, Is This a 12 Month Mandate = Yes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mandate Length %3D Blank%2C 12 month Mandate %3D blank</fullName>
        <actions>
            <name>X12_month_Mandate_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Mandate_Length__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If Mandate Length is Blank, Is This a 12 Month Mandate must be blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mandate Length not 12 %26 not blank%2C 12 Month Mandate %3D No</fullName>
        <actions>
            <name>X12_month_Mandate_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Mandate_Length__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Mandate_Length__c</field>
            <operation>notEqual</operation>
            <value>12</value>
        </criteriaItems>
        <description>If Mandate Length not 12 &amp; not blank, Is This a 12 Month Mandate must = No</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ONE Client activate</fullName>
        <actions>
            <name>Client_Status_from_Cycle_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Screening_Stage__c</field>
            <operation>equals</operation>
            <value>Screening Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>ONE Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Exit_Date_1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Client_Status__c</field>
            <operation>notEqual</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quarterly rearrest check task</fullName>
        <actions>
            <name>Temp_Quarterly_Rearrest</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>OR(

AND(CONTAINS(P_C_ID__c, &quot;CEP&quot;), Current_Exit_Type__c != &apos;S&apos;, Current_Exit_Date__c - Intake_Date__c &gt;= 15,
NOT(IsNULL(Current_Exit_Date__c))),


AND( Sum_of_Days_in_Cycles__c &gt;= 15, 
OR(CONTAINS(P_C_ID__c, &quot;DTC&quot;), CONTAINS(P_C_ID__c, &quot;CCM&quot;)), NOT(IsNULL(Current_Exit_Date__c))),

AND(Exit_Date_1__c - Intake_Date__c &gt;= 15, CONTAINS(P_C_ID__c, &quot;ACT&quot;), NOT(IsNULL(Exit_Date_1__c)))

)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rearrest check for CCM Voluntary</fullName>
        <actions>
            <name>Temp_CCM_Voluntary_Rearrest</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCM Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Current_Cycle_Type__c</field>
            <operation>equals</operation>
            <value>Voluntary</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Current Exit Date for QJC</fullName>
        <actions>
            <name>Set_Current_Exit_Date_for_QJC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>RecordTypeId = &quot;012600000005MJE&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set SYEP Sharing</fullName>
        <actions>
            <name>Set_SYEP_Sharing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ischanged( SYEP_Participation__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Temp_CCM_Voluntary_Rearrest</fullName>
        <assignedTo>tbrignol@cases.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>194</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Contact.Intake_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Temp CCM Voluntary Rearrest</subject>
    </tasks>
    <tasks>
        <fullName>Temp_Quarterly_Rearrest</fullName>
        <assignedTo>tbrignol@cases.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Contact.Current_Exit_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Temp Quarterly Rearrest</subject>
    </tasks>
</Workflow>
