<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_email_alert</fullName>
        <description>Case email alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>{!Environment.VAR_Username}</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SupportCaseAssignmentNotification</template>
    </alerts>
</Workflow>
