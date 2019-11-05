public with sharing class CopadoSetupController {
	public static User thisUser {get;set;}
	public String defaultName {get;set;}
	public String defaultType {get;set;}
	public String namespace {get;set;}
	public Org__c org0 {get;set;}
    
	public Boolean hasThisOrg {get;set;}
	public Boolean hasOrgs {get;set;}
	public Boolean hasRepos {get;set;}
    public Boolean hasDeployments {get;set;}
	public Boolean hasSnapshots {get;set;}
	public Boolean hasOrgDiffs {get;set;}
	public Boolean hasSnapshotDiffs {get;set;}

	public Boolean enabledMultiLicenses {get;set;}
	public Boolean isCopadoUser {get;set;}

	public Boolean allowOrgDiff {get;set;}
	public Boolean allowSnapshotDiffs {get;set;}

	public CopadoSetupController() {

		namespace = Settings.ns;
		
		Settings__c setting = Settings__c.getOrgDefaults();
		if(!setting.Enabled_Multi_Licenses__c){
			isCopadoUser = true;
		}
		if(setting.Enabled_Multi_Licenses__c){
			enabledMultiLicenses = true;
			Copado_License__c license = Copado_License__c.getInstance();
			isCopadoUser = license.Enable_Copado__c;
		}

		//Now that we know what license the user has, let's check if the feature is enabled for them.
		Set<String> features = new Set<String>();
		for(Feature__c f : Feature__c.getall().values()){
			if(f.Enabled__c)features.add(f.Name);
		}
		allowOrgDiff = features.contains('Org Difference');
		allowSnapshotDiffs = features.contains('Snapshot Difference');

		hasThisOrg = false;
		hasOrgs = false;
		hasRepos = false;
        hasDeployments = false;
		hasSnapshots = false;
		hasOrgDiffs = false;
		hasSnapshotDiffs = false;

		Set<Id> orgIdSet = new Set<Id>();
		List<Org__c> orgs = getOrgs();
		
        for(Org__c o : orgs){
            orgIdSet.add(o.Id);
        }

		hasRepos = ![select Id, Name, OwnerId from Git_Repository__c where OwnerId=:UserInfo.getUserId() limit 25].isEmpty();
        hasDeployments = ![select Id,Name from Deployment__c where OwnerId=:UserInfo.getUserId() limit 25].isEmpty();
		hasSnapshots = ![select Id, Name, Org__c from Git_Backup__c where Org__c IN:orgIdSet limit 25].isEmpty();
		hasOrgDiffs = ![select Id, Name, OwnerId from OrgDiff__c where OwnerId=:UserInfo.getUserId() limit 25].isEmpty();
		hasSnapshotDiffs = ![select Id, Name, OwnerId from Snapshot_Difference__c where OwnerId=:UserInfo.getUserId() limit 25].isEmpty();
		hasThisOrg = ![Select Id, SFDC_Org_ID__c from Org__c where SFDC_Org_ID__c=:UserInfo.getOrganizationId()+'_'+UserInfo.getUserId() limit 1].isEmpty();

		org0 = new Org__c();
		thisUser = [Select Id, FirstName, LastName, Alias, Username, API_URL__c from User where Id=:UserInfo.getUserId() limit 1];
		boolean isSandbox = [Select isSandbox from Organization].isSandbox;
		org0.Name = 'Copado '+thisUser.Alias;
		org0.Org_Type__c = (isSandbox)?'Sandbox':'Production/Developer';
	}
	public List<Org__c> getOrgs(){
        List<Org__c> orgs = [select Id, Name, OwnerId, Test_Frequency__c, Username__c, SFDC_Org_ID__c, Org_Type__c, Validated_Date__c from Org__c where OwnerId=:UserInfo.getUserId() and Validated_Date__c!=null limit 25];
		hasOrgs = orgs.size()>2;
        return orgs;
	}
	public PageReference rerenderOrg(){
		getOrgs();
		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This org\'s Org Credential was successfully created.'));
		hasThisOrg = true;
        
		return null;
	}
    
	public String getFixedOauthUrl(){

		thisUser = [Select Id, FirstName, LastName, Alias, Username, API_URL__c from User where Id=:UserInfo.getUserId() limit 1];
		
		String urlParameters = '?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode(thisUser.API_URL__c,'UTF-8');
        urlParameters += '&orgId=__ORGIG__';
        //since the user is adding the same org I'm using just isSandbox method. 
        if(CopadoSetupController.isSandbox()) urlParameters += '&sandbox=true';
        urlParameters += '&copadoOrgId='+EncodingUtil.urlEncode(userinfo.getOrganizationId(),'UTF-8');
        urlParameters += '&copadoUserId='+EncodingUtil.urlEncode(userinfo.getUserId(),'UTF-8');
        String herokuServer = settings.server_url;
        String urlOauth = herokuServer + '/Authorize/sforceLogin'+ urlParameters;
        System.debug('Doing oauth! = ' + urlOauth);
        return urlOauth;
	}

	public static Boolean isSandbox() {
	  return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
	}

    public PageReference imdone(){
        return new PageReference('/home/home.jsp');
    }
}