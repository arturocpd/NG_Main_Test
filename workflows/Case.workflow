<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_email_alert</fullName>
        <description>Case email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ngarturouatcpd@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SupportCaseAssignmentNotification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_from_wide</fullName>
        <description>Email alert from wide</description>
        <protected>false</protected>
        <recipients>
            <recipient>ngarturouatcpd@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>arturogueznez@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_on_Case_1</fullName>
        <description>Email alert on Case 1</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_on_Case_2</fullName>
        <description>Email alert on Case 2</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_on_Case_3</fullName>
        <description>Email alert on Case 3</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_on_Case_4</fullName>
        <description>Email alert on Case 4</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
    <alerts>
        <fullName>Wide_org_email_alert</fullName>
        <description>Wide org email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ngarturouatcpd@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>arturogueznez@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
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
    <rules>
        <fullName>WF Rule Deployment Test</fullName>
        <active>true</active>
        <formula>ISPICKVAL(Origin , &quot;Email&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
