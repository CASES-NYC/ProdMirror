<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BJMHS_Referral_Not_Needed</fullName>
        <field>BJMHS_Referral_Recommended__c</field>
        <literalValue>No</literalValue>
        <name>BJMHS Referral Not Needed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Contact__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJMHS_Referral_Recommended</fullName>
        <field>BJMHS_Referral_Recommended__c</field>
        <literalValue>Yes</literalValue>
        <name>BJMHS Referral Recommended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Contact__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_PHQ_9_Result</fullName>
        <field>PHQ_9_Result__c</field>
        <formula>if (isNull (PHQ_9_Total_Score__c), &quot;&quot;,
if ( PHQ_9_Total_Score__c &gt;= 20, &quot;Severe depression&quot;, if( PHQ_9_Total_Score__c &gt;= 15, &quot;Moderately severe depression&quot;, if( PHQ_9_Total_Score__c &gt;= 10, &quot;Moderate depression&quot;, if( PHQ_9_Total_Score__c &gt;= 5, &quot;Mild depression&quot;, &quot;Minimal depression&quot;)))))</formula>
        <name>Calculate PHQ 9 Result</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Assessment_Result</fullName>
        <field>Assessment_Result__c</field>
        <formula>case(RecordType.DeveloperName,
&quot;BJMHS&quot;, if( BJMHS_Result__c = &quot;Yes&quot;, &quot;Referral Recommended&quot;, &quot;Referral Not Needed&quot;),
&quot;LSI_R_SV&quot;,  text(LSI_R_SV_Score__c) ,
&quot;MHSF&quot;, text(MHSF_Total_Score__c),
&quot;TCU&quot;, text(TCU_Total_Score__c),
&quot;PHQ_9&quot;, if( Contact__r.RecordType.DeveloperName = &quot;CIRT_Client&quot;, PHQ_9_Result__c, &quot;Assessment Incomplete&quot;),
&quot;PHQ_9_Read_Only&quot;, PHQ_9_Result__c,
&quot;UCLA_PTSD_RI&quot;, &quot;Assessment Incomplete&quot;,
&quot;UCLA_PTSD_RI_Read_Only&quot;, if( UCLA_PTSD_RI_Flag__c, &quot;PTSD Diagnosis Likely&quot;, &quot;No Flag&quot;),
&quot;Psychosocial_Assesment_Mental_Health_Assessment&quot;, &quot;Assessment Incomplete&quot;,
&quot;Psychosocial_Assesment_Mental_Health_Assessment_Read_Only&quot;, if(ispickval(Community_based_Care_Recommended__c, &quot;Yes&quot;), &quot;Community-based Care Recommended&quot;, if(ispickval(Community_based_Care_Recommended__c, &quot;No&quot;), &quot;Referral Not Needed&quot;, if(ispickval(Community_based_Care_Recommended__c, &quot;In Care&quot;), &quot;Currently In Community-based Care&quot;, &quot;&quot;))),
&quot;LS_CMI&quot;,  &quot;High Risk Areas: &quot; &amp; if( contains( LSCMI_Subscale_1_Criminal_History__c, &quot;High&quot;), &quot;Criminal History &quot;, &quot;&quot;)

&amp; if( contains(LSCMI_Subscale_2_Education_Employment__c, &quot;High&quot;), &quot;Education/Employment &quot;, &quot;&quot;)

&amp; if( contains(LSCMI_Subscale_3_Family_Marital__c, &quot;High&quot;), &quot;Family/Marital &quot;, &quot;&quot;)

&amp; if( contains(LSCMI_Subscale_4_Leisure_Recreation__c, &quot;High&quot;), &quot;Leisure/Recreation &quot;, &quot;&quot;)

&amp; if( contains(LSCMI_Subscale_5_Companions__c, &quot;High&quot;),&quot;Companions &quot;, &quot;&quot;)

&amp; if( contains(LSCMI_Subscale_6_Alcohol_Drug_Problem__c, &quot;High&quot;), &quot;Alcohol/Drug Problem &quot;, &quot;&quot;)

&amp; if( contains(LSCMI_Subscale_7_Pro_criminal_Attitude__c, &quot;High&quot;), &quot;Pro-Criminal Attitude &quot;, &quot;&quot;)

&amp; if( contains(LSCMI_Subscale_8_Anti_social_Pattern__c, &quot;High&quot;), &quot;Antisocial Pattern &quot;, &quot;&quot;),
&quot;&quot;)</formula>
        <name>Set Assessment Result</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PTSD_RI_Field</fullName>
        <field>UC_PTSD_RI__c</field>
        <formula>UC_Reaction_Category_B_Sum__c +  UC_Reaction_Category_C_Sum__c + UC_Reaction_Category_D_Sum__c +  UC_Reaction_Category_E_Sum__c</formula>
        <name>Update PTSD RI Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PTSD_RI_Total</fullName>
        <description>ucla ptsd ri field with total of numeric fields</description>
        <field>UC_PTSD_RI__c</field>
        <formula>UC_Reaction_Category_B_Sum__c +  UC_Reaction_Category_C_Sum__c + UC_Reaction_Category_D_Sum__c + UC_Reaction_Category_E_Sum__c</formula>
        <name>Update PTSD RI Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Risk_Category</fullName>
        <description>updates contact record with risk category</description>
        <field>Risk_Category_at_Intake__c</field>
        <formula>Risk_Category_at_Intake__c</formula>
        <name>Update Risk Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Contact__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>BJMHS Referral Not Needed</fullName>
        <actions>
            <name>BJMHS_Referral_Not_Needed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BJMHS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.BJMHS_Result__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BJMHS Referral Recommended</fullName>
        <actions>
            <name>BJMHS_Referral_Recommended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BJMHS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.BJMHS_Result__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate PHQ 9 Result</fullName>
        <actions>
            <name>Calculate_PHQ_9_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PHQ-9</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Risk Category</fullName>
        <actions>
            <name>Update_Risk_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LSI-R:SV,LS/CMI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Risk_Category_at_Intake__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>CCM Client,DTC Client,Nathaniel ACT Client,CIRT Client</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Assessment Result</fullName>
        <actions>
            <name>Set_Assessment_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BJMHS,LSI-R:SV,LS/CMI,PHQ-9,PHQ-9 - Read Only,MHSF,TCU</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UCLA Full PTSD Likely False</fullName>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>UCLA PTSD RI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_B_Met__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_C_Met__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_D_Met__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UCLA Full PTSD Likely True</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>UCLA PTSD RI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_B_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_C_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_D_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UCLA PTSD RI Score</fullName>
        <actions>
            <name>Update_PTSD_RI_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>UCLA  PTSD DSM V</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UCLA Partial PTSD Likely False</fullName>
        <active>false</active>
        <booleanFilter>1 AND NOT(2 AND ((3 AND 4) OR (4 AND 5) OR (3 AND 5)))</booleanFilter>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>UCLA PTSD RI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_A_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_B_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_C_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_D_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UCLA Partial PTSD Likely True</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND ((3 AND 4) OR (4 AND 5) OR (3 AND 5))</booleanFilter>
        <criteriaItems>
            <field>Assessment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>UCLA PTSD RI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_A_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_B_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_C_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assessment__c.Criterion_D_Met__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
