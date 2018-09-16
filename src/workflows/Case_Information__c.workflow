<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Arraignment_Status_CC</fullName>
        <description>If any Arraignment fields are entered, or Docket # entered, or Indictment # entered, set CC Arraignment Status to &quot;Arraigned&quot;</description>
        <field>Arraignment_Status_CC__c</field>
        <literalValue>Arraigned</literalValue>
        <name>Arraignment Status CC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Court_First_Name_default_to_Account_name</fullName>
        <description>When Case Information record is created, set Court Name to match Account Name</description>
        <field>Court_name__c</field>
        <formula>Client_Account__r.Name</formula>
        <name>Court Name default to Account name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CC Arraignment Status</fullName>
        <actions>
            <name>Arraignment_Status_CC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Case_Information__c.Criminal_Court_Arraignment_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Information__c.Top_Criminal_Court_Arraignment_Charge__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Information__c.Detention_Status_at_CC_Arraignment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Information__c.Name</field>
            <operation>notEqual</operation>
            <value>Docket NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Information__c.Indictment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If any Arraignment fields are entered, or Docket # entered, or Indictment # entered, set CC Arraignment Status to &quot;Arraigned&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Court Name default to Account name</fullName>
        <actions>
            <name>Court_First_Name_default_to_Account_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Information__c.Court_name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When Case Information record is created, set Court Name to match Account Name. After creation, allow Court First Name to be edited</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
