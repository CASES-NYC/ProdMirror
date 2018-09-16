<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MOCJ_Level_Recommendatin</fullName>
        <description>Update field based on top arraignment charge level, aggravating factors true or false, and risk score</description>
        <field>Supervision_Level_Recommendation__c</field>
        <formula>IF( RA_Total_Score_Calc__c &gt;80,&quot;INCOMPLETE&quot;,
IF(left(MOCJ_Supervision_Part1__c,1)=&quot;V&quot;,&quot;INELIGIBLE&quot;,
IF(right(trim(MOCJ_Risk_Category__c),3)=&quot;Low&quot;,
  IF(right(trim(MOCJ_Supervision_Part1__c),1)=&quot;T&quot;,&quot;Level 2&quot;,&quot;Level 1&quot;),
if(MOCJ_Risk_Category__c=&quot;Medium&quot;,if(right(trim(MOCJ_Supervision_Part1__c),1)=&quot;T&quot;,&quot;Level 3&quot;,&quot;Level 2&quot;),IF(right(trim(MOCJ_Supervision_Part1__c),1)=&quot;T&quot;,&quot;Level 4&quot;,
IF(left(MOCJ_Supervision_Part1__c,1)=&quot;M&quot;,&quot;Level 2&quot;,&quot;Level 3&quot;))))))</formula>
        <name>MOCJ Level Recommendatin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MOCJ_Risk_Category_Calc</fullName>
        <description>Update MOCJ Risk recommendation</description>
        <field>MOCJ_Risk_Category__c</field>
        <formula>IF(RA_Total_Score_Calc__c&gt;=80,&quot;INCOMPLETE&quot;,
IF( RA_Total_Score_Calc__c &lt;= -10, &quot;Low&quot;,
IF(and(RA_Total_Score_Calc__c&gt;=-9, RA_Total_Score_Calc__c&lt;=-5),&quot;Medium Low&quot;,
IF(and(RA_Total_Score_Calc__c&gt;=-4,RA_Total_Score_Calc__c&lt;=0),&quot;Medium&quot;,IF(and(RA_Total_Score_Calc__c&gt;=1,RA_Total_Score_Calc__c&lt;=4),&quot;Medium High&quot;,IF(RA_Total_Score_Calc__c&gt;=5,&quot;High - SRP INELIGIBLE&quot;,&quot;Unknown&quot;))))))</formula>
        <name>MOCJ Risk Category Calc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MOCJ Risk Category Calc</fullName>
        <actions>
            <name>MOCJ_Level_Recommendatin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MOCJ_Risk_Category_Calc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Referral__c.RA_Total_Score_Calc__c</field>
            <operation>greaterOrEqual</operation>
            <value>-16</value>
        </criteriaItems>
        <description>calculate risk category from total score</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
