<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>Standard User CLONE</fullName>
    <custom>true</custom>
    <fieldPermissions>
        <editable>false</editable>
        <field>Dinner__c.LateDinner__c</field>
        <readable>false</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>true</editable>
        <field>Dinner__c.Point_of_contact__c</field>
        <readable>true</readable>
    </fieldPermissions>
    <objectPermissions>
        <allowCreate>false</allowCreate>
        <allowDelete>false</allowDelete>
        <allowEdit>false</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>false</modifyAllRecords>
        <object>Dinner__c</object>
        <viewAllRecords>true</viewAllRecords>
    </objectPermissions>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>Dinner__c.Dinner_RT</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>false</default>
        <recordType>Dinner__c.Dinner_RT_2</recordType>
        <visible>false</visible>
    </recordTypeVisibilities>
    <userLicense>Salesforce</userLicense>
</Profile>
