<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_from_wide</fullName>
        <description>Email alert from wide</description>
        <protected>false</protected>
        <recipients>
            <recipient>{!Environment.useremailalert}</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>arturogueznez@gmail.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
    <alerts>
        <fullName>Wide_org_email_alert</fullName>
        <description>Wide org email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>{!Environment.useremailalert}</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>{!Environment.arturogueznez}</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
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
</Workflow>
