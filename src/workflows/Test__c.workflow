<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Test_Summary</fullName>
        <field>Test_Summary__c</field>
        <formula>case(RecordTypeId, 
&apos;012600000005MJY&apos;, &apos;Read: &apos; &amp;  text(Reading_Pass_Fail__c) &amp; &apos;, Writing: &apos; &amp; text( Writing_Pass_Fail__c ) &amp; &apos;, Math 1: &apos; &amp; text( Math_I_Pass_Fail__c ) &amp; &apos;, Math 2: &apos; &amp; text( Math_II_Pass_Fail__c ), /*CAT*/
&apos;012600000005JAa&apos;,if(Positive_Score__c=True,&apos;Positive&apos;,&apos;Negative&apos;), /*Drug*/
&apos;012600000005JAb&apos;, text(Result__c), /*GED*/
&apos;012600000005JAd&apos;,&apos;GE &apos;&amp;text(Grade_Equivalent__c), /*STAR*/
&apos;012600000005JAc&apos;,TempMaysiSummary__c, /*MAYSI*/
&apos;012600000005LQ8&apos;, &apos;Read GE: &apos;&amp;if(Reading_GE_RPT__c &gt; 0, text(Reading_GE_RPT__c), &apos;n/a&apos;) 
&amp; &apos;, Math GE: &apos; &amp; if(Math_GE_RPT__c &gt; 0, text(Math_GE_RPT__c), &apos;n/a&apos;), /*TABE*/
&apos;&apos;)</formula>
        <name>Set Test Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Test Summary</fullName>
        <actions>
            <name>Set_Test_Summary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Test summary field has to be defined via a workflow rule because the formula ran over the 5000 character compile limit.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
