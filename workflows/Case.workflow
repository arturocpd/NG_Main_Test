<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_from_wide</fullName>
        <description>Email alert from wide</description>
        <protected>false</protected>
        <recipients>
            <recipient>insightssecurity@00d0y000001jzpeuai.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>arturogueznez@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
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
    <alerts>
        <fullName>Wide_org_email_alert</fullName>
        <description>Wide org email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>insightssecurity@00d0y000001jzpeuai.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>arturogueznez@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
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
    <fieldUpdates>
        <fullName>Test_1</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_10</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_2</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_3</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_4</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_5</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_6</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_7</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_8</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Test_9</fullName>
        <field>Origin</field>
        <literalValue>Phone</literalValue>
        <name>Test 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Origin</fullName>
        <field>Origin</field>
        <literalValue>Email</literalValue>
        <name>Update Origin</name>
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
    <rules>
        <fullName>Org wide alert</fullName>
        <actions>
            <name>Email_alert_from_wide</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.BusinessHoursId</field>
            <operation>equals</operation>
            <value>Default</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Test Thomson</fullName>
        <actions>
            <name>Test_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_10</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_4</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_5</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_6</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_7</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_8</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Test_9</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update origin</fullName>
        <actions>
            <name>Update_Origin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
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
