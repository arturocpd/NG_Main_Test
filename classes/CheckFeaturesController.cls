global  class CheckFeaturesController {

	/**
	 * returns the static namespacevi
	 * @return [description]
	 */
	public String getNamespace(){
		return Settings.ns; 
	}

    /**
     * Async call to update features in custom settings if needed 
     */
    @RemoteAction
    global static void checkFeatures(){
        DeployAPI.checkSyncFeatures();
    }

    /**
     * Async call to check setup Org 
     */
    @RemoteAction
    global static Boolean checkSetup(){

    	String orgId = Userinfo.getOrganizationId()+'_'+Userinfo.getUserId();
    	Org__c[] org = [SELECT ID FROM Org__c WHERE  Validated_Date__c != null AND SFDC_Org_ID__c = :orgId LIMIT 1];
        return !org.isEmpty();
    }
    
    /**
     * Async call to update features in custom settings if needed 
     */
    @RemoteAction
    global static void checkLicenses(){
        DeployAPI.checkSyncLicenses();
    }
}