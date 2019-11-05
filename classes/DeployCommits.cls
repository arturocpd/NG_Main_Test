public with sharing class DeployCommits {
    public String repositoryId {get;set;}
    public String branch {get; set;}
    public Git_Repository__c repo {get; set;}
    public List<GitHelper.ACommit> commits;
    public Git_Commit__c dateFrom {get;set;}
    public Git_Commit__c dateTo {get;set;}
    public Deployment__c deployment {get;set;}
    public String chooseCommit {get; set;}
    public String startCommit {get; set;}
    public String endCommit {get; set;}
    public Settings settings {get;set;}
    
    public GitHelper.ACommit startGitCommit {get; set;}
    public GitHelper.ACommit endGitCommit {get; set;}
    
    public Step__c step {get;set;}
    public Boolean showTable;
    public Boolean showDeploy;
    public PageReference cancel(){
        return new PageReference('/'+repositoryId);
    }
    private void initValues(){
        repositoryId = ApexPages.currentPage().getParameters().get('repositoryId');
        DateTime frm = DateTime.now().addYears(-1);
        dateFrom = new Git_Commit__c(Commit_Date__c = frm.date());
        dateTo = new Git_Commit__c(Commit_Date__c = Date.today()+1);
        step = new Step__c(CheckOnly__c = false, Run_All_Tests__c = false);
        deployment = new Deployment__c();
        
        try{
        	repo = [select Id, Name, URI__c from Git_Repository__c where Id =:repositoryId];    
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 'LABEL: Invalid Repository Id: ' + repositoryId));
        }
    }
    public Boolean getShowTable(){
        return String.isBlank(startCommit) || String.isBlank(endCommit);
    }
    public Boolean getShowDeploy(){
        return String.isNotBlank(startCommit) && String.isNotBlank(endCommit);
    }
    public DeployCommits(){
        initValues();
    }
    public DeployCommits(ApexPages.StandardController std){
        initValues();
        deployment.Name = 'Git Deployment';
    }
    public List<GitHelper.ACommit> getCommits(){
        return GitHelper.getCommits(repositoryId, branch, dateFrom.Commit_Date__c, dateTo.Commit_Date__c, startCommit, endCommit,200);
    }
    public PageReference chooseCommit(){
        System.debug('Chosen commit is ' + chooseCommit);
        if(String.isBlank(startCommit)){
            startCommit = chooseCommit;
            startGitCommit = GitHelper.commitMap.get(chooseCommit);
            branch = startGitCommit.branch;
        }
        else{
            endCommit = chooseCommit;
            endGitCommit = GitHelper.commitMap.get(chooseCommit);
        }
        return null;
    }

    /**
     * Method to be called from JS or Apex and show a fixed message includes two parameters (errorLevel and messageName)
     */
    public String errorLevel {get; set;}
    public String messageName {get; set;}
    public void showMessage() {
        ApexPages.Severity level = ApexPages.Severity.ERROR;
        if(errorLevel == 'WARNING') {
            level = ApexPages.Severity.Warning;
        }else{
            if(errorLevel == 'CONFIRM') {
                level = ApexPages.Severity.CONFIRM;
            }
        }
        ApexPages.addMessage(new ApexPages.Message(level, messageName));
    }
}