public class UserStorySelectCommits {
    public User_Story__c us;
    public String repositoryId {get;set;}
	public String snapshotId {get;set;}
	public String orgId {get;set;}
    public String userStoryId {get;set;}

    public List<ACommit> commits;
	public String orgName {get;set;}
	public String repoName {get;set;}
	public String branch {get;set;}
    
    public UserStorySelectCommits(ApexPages.StandardController std){
		us = (User_Story__c) std.getRecord();
        Map<String, String> params = ApexPages.currentPage().getParameters();

		repositoryId = params.get('repoId');
		snapshotId = params.get('snapshotId');
		orgId = params.get('orgId');
        userStoryId = params.get('userStoryId');

		//get values for subtitle
		Git_Backup__c snapshot = [SELECT Org__r.Name, Branch__c, Git_Repository__r.Name FROM Git_Backup__c WHERE Id =:snapshotId ];

		orgName = snapshot.Org__r.Name;
		repoName = snapshot.Git_Repository__r.Name;
		branch = snapshot.Branch__c;
    }
    public void getCommits(List<ACommit> t){
        this.commits = t;
    }
    public List<ACommit> getCommits(){
        commits = new List<ACommit>();
        Set<String> existing = new Set<String>();
        for(User_Story_Commit__c sc:[select Snapshot_Commit__r.Commit_Id__c from User_Story_Commit__c where User_Story__c = :userStoryId])existing.add(sc.Snapshot_Commit__r.Commit_Id__c);
        for(Git_Org_Commit__c c:[select Id, Name, Commit_Id__c, Commit_Message__c, Commit_Date__c from Git_Org_Commit__c
                                 where Git_Backup__c =:this.snapshotId and Status__c='Complete' order by Commit_Date__c desc limit 200]){
        	commits.add(new ACommit(c,existing.contains(c.Commit_Id__c)));
		}
        return commits;
    }
    public PageReference saveSelections(){
        List<User_Story_Commit__c> t = new List<User_Story_Commit__c>();
        for(ACommit c:commits){
            if(c.sel){
                t.add(new User_Story_Commit__c(User_Story__c = this.userStoryId, Snapshot_Commit__c = c.c.Id, External_Id__c = this.userStoryId + '_' + c.c.Commit_Id__c));
            }
        }
        upsert t User_Story_Commit__c.External_Id__c;
        return new PageReference('/'+this.userStoryId);
    }
    public PageReference cancel(){
        return new PageReference('/'+this.userStoryId);
    }
    public class ACommit{
        public Git_Org_Commit__c c{get;set;}
        public boolean sel{get;set;}
        public ACommit(Git_Org_Commit__c c, boolean sel){
            this.c = c;
            this.sel = sel;
        }
    }
}