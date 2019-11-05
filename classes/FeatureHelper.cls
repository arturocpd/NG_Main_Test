public without sharing class FeatureHelper {
    
    public boolean branchMgmtEnabled {get;set;}
    
	public static boolean isFeatureEnabled(String feature){
		Boolean res = true;
		Feature__c f = Feature__c.getValues(feature);
        system.debug('***** Features retrieved: '+ f);
        if(f != null && f.Enabled__c == false)res = false;
		System.debug('***** Checking feature: ' + feature + ': ' + res);
        if(feature == 'Git Backup'){
            System.debug('Git Backup is available to all users if enabled at the Org level. Git Backup enabled = ' + res);
            return res;
        }
        if (feature.startsWith('CCM')){
            if(!LicenseHelper.isCCMEnabled()){
             	System.debug('***** CCM feature for a non CCM enabled user. res = false');
	            res = false;   
            }
        }
        else{
            //This is a Copado feature - non prefixed features are assumed to be Copado's
            if(!LicenseHelper.isCopadoEnabled()){
                System.debug('***** Copado feature for a non Copado enabled user. res = false');
            	res = false;
            }
        }
		return res;
	}
    public static boolean isBranchMgmtEnabled(){
        return featureHelper.isFeatureEnabled('Branch Management');
    }
    
    //Constructors
    private void constructor(){
        branchMgmtEnabled = isBranchMgmtEnabled();
    }
    public FeatureHelper(){
        constructor();
    }
    public FeatureHelper(ApexPages.StandardController stdController){
        constructor();
    }
}