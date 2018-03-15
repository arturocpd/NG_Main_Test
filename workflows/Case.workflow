<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_on_Case_1</fullName>
        <description>Email alert on Case 1</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>integration@00d0y000001jzpeuai.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ngarturo2dev1cpd@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>{!Environment.VAR_Username}</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MarketingProductInquiryResponse</template>
    </alerts>
</Workflow>
