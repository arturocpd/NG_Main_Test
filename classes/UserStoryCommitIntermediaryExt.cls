public with sharing class UserStoryCommitIntermediaryExt {
    public User_Story__c userStory {get;set;}
    public ApexPages.Standardcontroller controller {get;set;}
    
	public List<Git_Backup__c> snapshots {get;set;}
    public Boolean showOptions {get;set;}
    public Boolean showError {get;set;}
    public String snapshotId {get;set;}
    public String repoId {get;set;}
    public String orgId {get;set;}
    public String targetPage{get;set;}
    
    public static final String[] FIELDS = new String[] {'Id','Name','Org_Credential__c', 'Environment__c', 'Org_Credential__r.Environment__c'};
    
    public UserStoryCommitIntermediaryExt(ApexPages.StandardController stdController) {
        snapshotId = '';
        showOptions = false;
        showError = false;
        controller = stdController;
        targetPage = ApexPages.currentPage().getParameters().get('targetPage')!=null?ApexPages.currentPage().getParameters().get('targetPage'):'GitCommitChanges';
        if (!Test.isRunningTest())stdController.addFields(FIELDS);
        this.userStory = (User_Story__c)stdController.getRecord();
        if(this.userStory==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.USER_STORY_COMMIT_NO_USER_STORY));
        }
        else{
            getOptions();
        }
    }
    public void getOptions(){ 
        snapshots = new List<Git_Backup__c>();
        if(String.isBlank(userStory.Environment__c)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.USER_STORY_COMMIT_NO_ENVIRONMENT));
            showError = true;
            showOptions = false;
            return;
        }
       
        snapshots = [select Id, Name, Org__c, Git_Repository__c, Git_Repository__r.Name, Org__r.Name, Org__r.OwnerId, Org__r.Environment__c, Branch__c, Frequency__c, Git_Snapshot_Permissions__c from Git_Backup__c where (Git_Snapshot_Permissions__c='' or Git_Snapshot_Permissions__c!='Allow Snapshots Only') and Org__r.Environment__c=:userStory.Environment__c limit 100];
        
        if(snapshots.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.USER_STORY_COMMIT_NO_SNAPSHOT_FOUND));
            showError = true;
            showOptions = false;
            return;
        }
        if(snapshots.size()==1){
            showError = false;
            showOptions = false;
            snapshotId = snapshots[0].Id;
            orgId = snapshots[0].Org__c;
            repoId = snapshots[0].Git_Repository__c;
            return;
        }
        if(snapshots.size()>1){
            showError = false;
            showOptions = true;
            return;
        }
    }
    
    public String getAdditionalParams() {
        PageReference pr = new PageReference('/');
        for(String k : ApexPages.currentPage().getParameters().keySet())
	        pr.getParameters().put(k, ApexPages.currentPage().getParameters().get(k));
       	pr.getParameters().remove('id');
        String pr1 = pr.getUrl().replace('/?', '').replace('/%3f', '').replace('/%3F', '');
        System.debug('pr1='+pr1);
        return pr1.length()>0 ? pr1+'&' : '';
    }
}