<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
</Workflow>
