<?xml version="1.0" encoding="UTF-8"?>
<Profile xmlns="http://soap.sforce.com/2006/04/metadata">
    <applicationVisibilities>
        <application>standard__Sales</application>
        <default>true</default>
        <visible>true</visible>
    </applicationVisibilities>
    <custom>true</custom>
    <description>Profile description</description>
    <fieldPermissions>
        <editable>false</editable>
        <field>Event.Location</field>
        <readable>false</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>false</editable>
        <field>Event.Next_Time__c</field>
        <readable>false</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>false</editable>
        <field>LCRM_Account_Merge_UnMerge_Dup_Event__c.LCRM_GLI_Contact_ID_1__c</field>
        <readable>false</readable>
    </fieldPermissions>
    <fieldPermissions>
        <editable>false</editable>
        <field>LCRM_Account_Merge_UnMerge_Dup_Event__c.LCRM_GLI_Contact_ID_2__c</field>
        <readable>false</readable>
    </fieldPermissions>
    <layoutAssignments>
        <layout>CSTM_Object__c-CSTM Layout 1</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Contact-Contact %28Marketing%29 Layout</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Contract-PageLayout1</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Contract-PageLayout1</layout>
        <recordType>Contract.RecordType1</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Dinner__c-Dinner Layout</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>LCRM_Account_Merge_UnMerge_Dup_Event__c-Account Event Layout</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Opportunity-Admin Clone Layout</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Order-PageLayout1</layout>
        <recordType>Order.RecordType1</recordType>
    </layoutAssignments>
    <layoutAssignments>
        <layout>OrderLineItems__c-PageLayout1</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Quote_Proposal__c-PageLayout1</layout>
    </layoutAssignments>
    <layoutAssignments>
        <layout>Quote_Proposal__c-Quote%2FProposal Layout</layout>
        <recordType>Quote_Proposal__c.RecordType2</recordType>
    </layoutAssignments>
    <loginHours>
        <mondayEnd>1440</mondayEnd>
        <mondayStart>0</mondayStart>
        <tuesdayEnd>1440</tuesdayEnd>
        <tuesdayStart>0</tuesdayStart>
    </loginHours>
    <loginIpRanges>
        <endAddress>83.36.118.193</endAddress>
        <startAddress>83.36.118.192</startAddress>
    </loginIpRanges>
    <loginIpRanges>
        <endAddress>83.36.118.192</endAddress>
        <startAddress>83.36.118.192</startAddress>
    </loginIpRanges>
    <loginIpRanges>
        <endAddress>83.36.118.195</endAddress>
        <startAddress>83.36.118.194</startAddress>
    </loginIpRanges>
    <objectPermissions>
        <allowCreate>true</allowCreate>
        <allowDelete>false</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>false</modifyAllRecords>
        <object>LCRM_Account_Merge_UnMerge_Dup_Event__c</object>
        <viewAllRecords>true</viewAllRecords>
    </objectPermissions>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>Account.Record_Type1</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>false</default>
        <recordType>Account.Record_Type2</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>CSTM_Object__c.CSTM_New_layout</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>Contract.RecordType1</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>Dinner__c.Dinner_RT</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>Order.RecordType1</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>OrderLineItems__c.RecordType1</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <recordTypeVisibilities>
        <default>true</default>
        <recordType>Quote_Proposal__c.RecordType1</recordType>
        <visible>true</visible>
    </recordTypeVisibilities>
    <userLicense>Salesforce</userLicense>
    <userPermissions>
        <enabled>true</enabled>
        <name>ActivateContract</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ActivateOrder</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>AllowUniversalSearch</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>AllowViewKnowledge</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ApiEnabled</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>AssignPermissionSets</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>AssignUserToSkill</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>BulkMacrosAllowed</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CanInsertFeedSystemFields</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CanUseNewDashboardBuilder</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ChatterEditOwnPost</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ChatterEditOwnRecordPost</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ChatterFileLink</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ChatterInternalUser</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ChatterInviteExternalUsers</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ChatterOwnGroups</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ConnectOrgToEnvironmentHub</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ContentAdministrator</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ContentWorkspaces</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ConvertLeads</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CreateCustomizeDashboards</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CreateCustomizeFilters</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CreateCustomizeReports</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CreateDashboardFolders</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CreatePackaging</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CreateReportFolders</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CreateWorkspaces</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>CustomizeApplication</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>DelegatedTwoFactor</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>DeleteActivatedContract</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>DistributeFromPersWksp</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditActivatedOrders</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditBillingInfo</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditBrandTemplates</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditCaseComments</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditEvent</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditHtmlTemplates</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditKnowledge</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditMyDashboards</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditMyReports</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditOppLineItemUnitPrice</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditPublicDocuments</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditPublicFilters</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditPublicTemplates</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EditTask</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EmailSingle</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EnableCommunityAppLauncher</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>EnableNotifications</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ExportReport</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ImportCustomObjects</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ImportLeads</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ImportPersonal</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>LightningConsoleAllowedForUser</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>LightningExperienceUser</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageAnalyticSnapshots</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageBusinessHourHolidays</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageCallCenters</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageCases</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageCategories</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageCertificates</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageContentPermissions</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageContentProperties</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageContentTypes</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageCssUsers</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageCustomPermissions</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageCustomReportTypes</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageDashbdsInPubFolders</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageDataCategories</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageDataIntegrations</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageDynamicDashboards</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageEmailClientConfig</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageEntitlements</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageExchangeConfig</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageHealthCheck</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageInteraction</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageInternalUsers</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageIpAddresses</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageKnowledge</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageKnowledgeImportExport</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageLeads</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageLoginAccessPolicies</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageMobile</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageNetworks</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManagePackageLicenses</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManagePartners</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManagePasswordPolicies</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageProfilesPermissionsets</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManagePvtRptsAndDashbds</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageRemoteAccess</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageReportsInPubFolders</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageRoles</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageSearchPromotionRules</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageSharing</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageSolutions</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageSynonyms</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageTranslation</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageUnlistedGroups</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ManageUsers</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>MassInlineEdit</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ModerateChatter</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>NewReportBuilder</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>PublishPackaging</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ResetPasswords</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>RunReports</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ScheduleReports</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>SelectFilesFromSalesforce</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>SendSitRequests</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ShareInternalArticles</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ShowCompanyNameAsUserBadge</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>SolutionImport</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>SubmitMacrosAllowed</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>SubscribeReportToOtherUsers</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>SubscribeReportsRunAsUser</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>SubscribeToLightningReports</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>TransferAnyCase</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>TransferAnyEntity</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>TransferAnyLead</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>UseTeamReassignWizards</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>UseWebLink</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewAllData</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewAllUsers</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewDataAssessment</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewDataCategories</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewEventLogFiles</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewHealthCheck</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewHelpLink</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewMyTeamsDashboards</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewPublicDashboards</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewPublicReports</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewSetup</name>
    </userPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>WorkCalibrationUser</name>
    </userPermissions>
</Profile>
