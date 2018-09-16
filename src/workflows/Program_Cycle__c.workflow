<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Choices_60_days_in_cycle</fullName>
        <ccEmails>probinson@cases.org</ccEmails>
        <description>Choices 60 days in cycle</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Choices_60_day_notification</template>
    </alerts>
    <alerts>
        <fullName>Program_Cycle_Completed_Notification</fullName>
        <ccEmails>ssamnani@cases.org</ccEmails>
        <description>Program Cycle Completed Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Program_Cycle_C_Coordinator_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>CEO_Client_Status_Exited</fullName>
        <field>Client_Status__c</field>
        <literalValue>Exited</literalValue>
        <name>CEO Client Status Exited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Exit_Type_from_Cycle</fullName>
        <field>PRP_Status__c</field>
        <name>Clear Exit Type from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Client_Status_Exited</fullName>
        <field>Client_Status__c</field>
        <literalValue>Exited</literalValue>
        <name>Client Status Exited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Current_Exit_Type_from_Cycle</fullName>
        <field>Current_Exit_Type__c</field>
        <formula>text(Exit_Type__c)</formula>
        <name>Current Exit Type from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Current_Intake_Date_from_Cycle</fullName>
        <field>Current_Intake_Date__c</field>
        <formula>Start_Date__c</formula>
        <name>Current Intake Date from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTC_Modification_End_Date</fullName>
        <field>End_Date__c</field>
        <formula>Last_Mandated_Session_Admin__c</formula>
        <name>DTC Modification End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTC_Modification_Exit_Type</fullName>
        <field>Exit_Type__c</field>
        <literalValue>Successful Exit</literalValue>
        <name>DTC Modification Exit Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>End_date_for_CCM_manual_exit</fullName>
        <field>End_Date__c</field>
        <formula>if(ispickval(Exit_Type__c, &quot;Successful Exit&quot;),
Last_Mandated_Session_Admin__c,
Compliance_Date__c)</formula>
        <name>End date for CCM manual exit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Exit_Client</fullName>
        <description>Change client&apos;s status to exited</description>
        <field>Client_Status__c</field>
        <literalValue>Exited</literalValue>
        <name>Exit Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Exit_Reason_from_Cycle</fullName>
        <field>Exit_Reason__c</field>
        <formula>if( ispickval(Exit_Reason__c, &quot;Other&quot;), &quot;Other: &quot; +  Exit_Reason_Other__c , text(Exit_Reason__c))</formula>
        <name>Exit Reason from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mandate_Type_from_Cycle</fullName>
        <field>Mandate_Type__c</field>
        <formula>case( RecordType.DeveloperName, 
&quot;CCM_Program_Cycle&quot;, &quot;CCM&quot;,
&quot;DTC_Program_Cycle&quot;, &quot;DTC&quot;,
&quot;TRP_Program_Cycle&quot;, &quot;TRP&quot;,
&quot;CIRT_Program_Cycle&quot;, text( Track__c ),
&quot;&quot;)</formula>
        <name>Mandate Type from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Original_Exit_Date</fullName>
        <field>Exit_Date_1__c</field>
        <formula>IF(ISBLANK(Client__r.Exit_Date_1__c ), End_Date__c ,Client__r.Exit_Date_1__c )</formula>
        <name>Updae Original Exit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Original_Exit_Date_from_Cycle</fullName>
        <field>Exit_Date_1__c</field>
        <formula>End_Date__c</formula>
        <name>Original Exit Date from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Original_Exit_Type_from_Cycle</fullName>
        <field>Original_Exit_Type__c</field>
        <formula>text(Exit_Type__c)</formula>
        <name>Original Exit Type from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Original_Intake_date_from_Cycle</fullName>
        <field>Intake_Date__c</field>
        <formula>Start_Date__c</formula>
        <name>Original Intake date from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>START_Days_in_Cycle</fullName>
        <field>Number_of_Days_in_Program_Cycle__c</field>
        <formula>BLANKVALUE( End_Date__c ,  Today__c ) -  Start_Date__c + 1</formula>
        <name>START Days in Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Successful_Exit_Type_from_Cycle</fullName>
        <field>PRP_Status__c</field>
        <literalValue>Successful Exit</literalValue>
        <name>Successful Exit Type from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unsuccessful_Exit_Type_from_Cycle</fullName>
        <field>PRP_Status__c</field>
        <literalValue>Unsuccessful Exit</literalValue>
        <name>Unsuccessful Exit Type from Cycle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Current_Exit_Date</fullName>
        <field>Current_Exit_Date__c</field>
        <formula>End_Date__c</formula>
        <name>Update Current Exit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CEO End Cycle Exit</fullName>
        <actions>
            <name>Exit_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Cycle__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CEO Program Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.End_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Exit_Type__c</field>
            <operation>equals</operation>
            <value>Successful Exit,Unsuccessful Exit,Administrative Discharge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Most_Recent_Program_Cycle_Formula__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Exiting CEO clients through the Program Cycle</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>End date for CCM manual exit</fullName>
        <actions>
            <name>End_date_for_CCM_manual_exit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Cycle__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCM Program Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Exit_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Locked_Admin__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Cycle_Type__c</field>
            <operation>notEqual</operation>
            <value>Voluntary</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>End date for DTC modification exit</fullName>
        <actions>
            <name>DTC_Modification_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DTC_Modification_Exit_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Cycle__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DTC Program Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Days_Sessions_Remaining__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Handles the circumstance where the mandate is modified so that remaining sessions = 0</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Exit Reason from Cycle</fullName>
        <actions>
            <name>Exit_Reason_from_Cycle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Choices Client,DTC Client,CCM Client,TRP Client</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.MostRecentProgramCycleOld__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Exit date from Cycle</fullName>
        <actions>
            <name>Original_Exit_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Current_Exit_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Cycle__c.Most_Recent_Program_Cycle_Formula__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SRP End Cycle</fullName>
        <actions>
            <name>Client_Status_Exited</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Cycle__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SRP Program Cycle</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.End_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Exit_Type__c</field>
            <operation>equals</operation>
            <value>Successful Exit,Unsuccessful Exit,Administrative Discharge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Program_Cycle__c.Most_Recent_Program_Cycle_Formula__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>End of Program Cycle</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>START Days in Cycle</fullName>
        <actions>
            <name>START_Days_in_Cycle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Cycle__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCM Program Cycle,CCM Voluntary Program Cycle,DTC Program Cycle,TRP Program Cycle</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>START%2FCIRT Days in Cycle</fullName>
        <actions>
            <name>START_Days_in_Cycle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Cycle__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCM Program Cycle,CCM Voluntary Program Cycle,DTC Program Cycle,TRP Program Cycle,CIRT Program Cycle</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Start date from Intake PCycle</fullName>
        <actions>
            <name>Current_Intake_Date_from_Cycle</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Original_Intake_date_from_Cycle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Original and Current Start Date for new client</description>
        <formula>AND( ISPICKVAL(Cycle_Type__c,&apos;Intake&apos;) ,  Most_Recent_Program_Cycle_Formula__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
