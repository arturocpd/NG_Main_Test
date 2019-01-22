<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>Sales Console</label>
    <navType>Console</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Flexi_Record_Page</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Account</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Admin CLONE</profile>
    </profileActionOverrides>
    <tabs>standard-Account</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>LightningSalesConsole_UtilityBar</utilityBar>
    <workspaceConfig>
        <mappings>
            <tab>standard-Account</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>
