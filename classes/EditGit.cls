public with sharing class EditGit {

	public Git_Repository__c git{get;set;}
    public String dumypass{get;set;}
    public Boolean keyVisible {get;set;}
    public Boolean isSSHauthentication {get;set;}
    public Boolean hasKeys {get;set;}
    public List<Attachment> attachments {get;set;}
    public String selectedKeyId {get;set;}
    public String selectedKeyContent {get;set;}
    public final String KEYNAME = 'id_rsa.pub';
    public List<GitHelper.ACommit> commits;
    public boolean showOtherInformation{get;set;}
    public boolean isShareable{get;set;}
    
    public EditGit(ApexPages.StandardController std) {
        showOtherInformation = SObjectType.Git_Repository__c.FieldSets.CustomFields.getFields().size()>0;
        keyVisible = false;
        hasKeys = false;
        isSSHauthentication = false;
        selectedKeyContent = '';
        dumypass='********';
        if(std.getId()!=null){
            git = utilities.getGitById(std.getId());
            if(git.URI__c.startsWith('git@')){
                dumypass='';
            	isSSHauthentication = true;
            	getKeys();
            }
        }
        else{
            git = new Git_Repository__c();
        }
        
        Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
		isShareable = tokens.containsKey('Git_Repository__Share');
    }
    public PageReference save(){
        Utilities.Secure_DML(git, Utilities.DML_Action.UPS, schema.Sobjecttype.Git_Repository__c);
        return new apexpages.standardController(git).view();
    }
    public PageReference validate(){
        
        if (!DeployAPI.validateGit(git.Id)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.WRONG_CREDENTIALS));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.OK_CREDENTIALS));
        }
        //check features sync and sync if necessary.
        if(Test.isRunningTest())return null;
        return null;
    }
    public void viewKey(){
        if(!String.isBlank(selectedKeyId)){
            List<Attachment> tmp = [select Body from Attachment where Id=:selectedKeyId limit 1];
            if(tmp.size()>0){
                selectedKeyContent = tmp.get(0).Body.toString();
        		keyVisible = true;
                selectedKeyId = '';
                return;
            }
        }
    }
    public PageReference deleteKey(){
        try{
            delete [select Id from Attachment where Id=:selectedKeyId limit 1];
            return new PageReference('/'+git.Id);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            return null;
        }
    }
    public PageReference hideSSHkey(){
        return new PageReference('/'+git.Id);
    }
    private void getKeys(){
        attachments = new List<Attachment>();
        attachments = [select Id, Name, Body, ParentId, CreatedDate, LastModifiedDate from Attachment where Name=:KEYNAME and ParentId=:git.Id];
        if(attachments.size()==1){
            hasKeys = true;
        }
        else{
            hasKeys = false;
        }
    }
    public PageReference createSSHKey(){
        try{
            String result = DeployAPI.createSSHKey(git.Id);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, result));
            return new PageReference('/'+git.Id);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            return null;
        }
    }
    public List<GitHelper.ACommit> getCommits(){
        DateTime frm = DateTime.now().addYears(-1);
        return GitHelper.getCommits(git.Id, null, frm.date(), Date.today()+1, null, null, 10);
    }
    public PageReference deployCommits(){
        PageReference pr = Page.DeployCommits;
        pr.getParameters().put('repositoryId',git.Id);
        return pr;
    }
    
    public void retrieveCommits(){
        String branch = Apexpages.currentPage().getParameters().get('branch');
        System.debug('branch: ' + branch);
        try{
            DeployAPI.getCommitsFromRepo(git.Id, branch);
            ApexPages.getMessages().clear();
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.info, Label.COMMITS_BEING_RETRIEVED ));
        }
        catch(Exception e){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error, e.getMessage()));
        }
       // return null;
    }
}