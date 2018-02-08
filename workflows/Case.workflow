<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Leaseplan_email_alert</fullName>
        <description>Leaseplan email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>{!Environment.VAR_Username}</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>email_folder/template_test</template>
    </alerts>
    <fieldUpdates>
        <fullName>Leaseplan_Update</fullName>
        <field>Type</field>
        <literalValue>Electronic</literalValue>
        <name>Leaseplan Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Leaseplan_outbound</fullName>
        <apiVersion>42.0</apiVersion>
        <endpointUrl>http://www.google.com</endpointUrl>
        <fields>AccountId</fields>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>{!Environment.VAR_Username}</integrationUser>
        <name>Leaseplan outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Leaseplan</fullName>
        <actions>
            <name>Leaseplan_email_alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Leaseplan_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Leaseplan_outbound</name>
            <type>OutboundMessage</type>
        </actions>
        <actions>
            <name>leaseplan_task</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_AAA__c</field>
            <operation>notEqual</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>leaseplan_task</fullName>
        <assignedTo>{!Environment.VAR_Username}</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>leaseplan task</subject>
    </tasks>
</Workflow>
