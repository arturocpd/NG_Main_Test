public with sharing class BackupNow {

	public Git_Backup__c backup;
	public String validation;
    public Boolean isValid {get;set;}
	public boolean hideMessages;
    public boolean testOK;
    public Boolean isBackupEnabled {get;set;}
    public boolean showOtherInformation{get;set;}

    public BackupNow(ApexPages.StandardController stdController) {
        this.backup = (Git_Backup__c)stdController.getRecord();
        this.backup = [select Git_Repository__c, Org__c, CreatedById, Org__r.OwnerId from Git_Backup__c where id=:this.backup.id];
        hideMessages = false;
        testOK = false;

        //check validations in order to disable functionality
        getValidation();

        isBackupEnabled = true;
        if(!FeatureHelper.isFeatureEnabled('Git Backup')){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error,Label.FEATURE_NOT_SUPPORTED+' Git Backup'));
            isBackupEnabled = false;
        }
        
        showOtherInformation = SObjectType.Git_Backup__c.FieldSets.CustomFields.getFields().size()>0;
    }

    public void doBackup() {
    	hideMessages = true;
    	if(!testConnections())return;
        if(!FeatureHelper.isFeatureEnabled('Git Backup')){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error,Label.FEATURE_NOT_SUPPORTED+' Git Backup'));
            isBackupEnabled = false;
            return;
        }
    	try{
            String comment = Apexpages.currentPage().getParameters().get('comment');

    		DeployAPI.backupNow(this.backup.Id, comment);
    		ApexPages.getMessages().clear();
    		Apexpages.addMessage(new apexpages.Message(apexpages.severity.info,Label.BACKUP_STARTED));
    	}
        catch(Exception e){
			Apexpages.addMessage(new apexpages.Message(apexpages.severity.error, e.getMessage()));
        }
        hideMessages = false;
    }
    public boolean testConnections(){
        if(testOK)return true;
        System.debug('testing connections');
    	Id gitId = this.backup.Git_Repository__c;
    	Id orgId = this.backup.Org__c;
    	if(!DeployAPI.validateGit(gitId)){
    		Apexpages.addMessage(new apexpages.Message(apexpages.severity.error, Git_Repository__c.sObjectType.getDescribe().getLabel() + ' ' + Label.WRONG_CREDENTIALS));
    		System.debug('git not validated');
            return false;
    	}
        System.debug('git validated, hideMessages='+hideMessages);
    	//if(!hideMessages)Apexpages.addMessage(new apexpages.Message(apexpages.severity.info, Git_Repository__c.sObjectType.getDescribe().getLabel() + ' ' + Label.OK_CREDENTIALS));
    	
        if(!DeployAPI.validateOrg(orgId)){
    		Apexpages.addMessage(new apexpages.Message(apexpages.severity.error, Org__c.sObjectType.getDescribe().getLabel() + ' ' + Label.WRONG_CREDENTIALS));
    		System.debug('org not validated');
            return false;
    	}
        System.debug('org validated, hideMessages='+hideMessages);
    	//if(!hideMessages)Apexpages.addMessage(new apexpages.Message(apexpages.severity.info, Org__c.sObjectType.getDescribe().getLabel() + ' ' + Label.OK_CREDENTIALS));
    	
        /*
         * removed because causes false positives while displaying the backup. saying credentials are not validated
         * when the developer doesn't own the org credential.
         *  
    	Org__c copadoOrg = DeployAPI.getCustomerOrg(this.backup.Org__r.OwnerId);
    	if(copadoOrg == null){
    		Apexpages.addMessage(new apexpages.Message(apexpages.severity.error, Label.CUSTOMER_ORG_NOT_EXISTS));
    		System.debug('no copado org');
            return false;
    	} 
    	if(!DeployAPI.validateOrg(copadoOrg.id)){
    		Apexpages.addMessage(new apexpages.Message(apexpages.severity.error, Label.CUSTOMER_ORG_NOT_VALIDATED));
            System.debug('copado org not validated');
    		return false;
    	}
		*/
        System.debug('copado org validated, hideMessages='+hideMessages);
        testOK = true;
        System.debug('testOK='+testOK);
    	return true;
    }

    public String getValidation(){
        System.debug('start getValidation -> testOK='+testOK);
        isValid = this.testConnections();
    	validation = isValid ? Label.OK :Label.ERROR_TEST_GIT_CONNECTIONS;
        System.debug('end getValidation -> testOK='+testOK);
    	return validation;
    }

    public void doTestConnections(){
    	this.testConnections();
    }
    public void getCommits() {
        hideMessages = true;
        if(!testConnections())return;
        try{
            DeployAPI.getCommits(this.backup.Id);
            ApexPages.getMessages().clear();
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.info, Label.COMMITS_BEING_RETRIEVED));
        }
        catch(Exception e){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error, e.getMessage()));
        }
        hideMessages = false;
    }


    /**
     * Fake getter to create the Heroku get Metadata url 
     * @return [url]
     */
    public String getMetadata_url(){
        Id orgId = this.backup.Org__c;

        String urlParameters = '?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode([select API_URL__c from User where id=:userinfo.getUserId()].API_URL__c,'UTF-8');
        String herokuServer = settings.Server_URL;
        String urlBase = herokuServer + '/json/v1/'; 
        
        if(orgId == null)return null;
        return urlBase + 'metadata/'+EncodingUtil.urlEncode(orgId,'UTF-8') + urlParameters+ '&dates=format';
    }

    /**
     * Fake getter to create the Heroku get Zip files url 
     * @return [url]
     */
    public String getQuery_url(){

        Id orgId = this.backup.Org__c;

        String urlParameters = '?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode([select API_URL__c from User where id=:userinfo.getUserId()].API_URL__c,'UTF-8');
        String herokuServer = settings.Server_URL;
        String urlBase = herokuServer + '/json/v1/'; 
        
        if(orgId == null)return null;
        return urlBase + 'query/'+EncodingUtil.urlEncode(orgId,'UTF-8') + urlParameters+ '&dates=format';
    }
}