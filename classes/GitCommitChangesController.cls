global with sharing class GitCommitChangesController{

	public Git_Org_Commit__c gitCommit{get;set;} 

	public String repositoryId {get;set;}
	public String snapshotId {get;set;}
	public String orgId {get;set;}
    public String userStoryId {get;set;}

	public String orgName {get;set;}
	public String repoName {get;set;}
	public String branch {get;set;}

    public Git_Backup__c gitBackup {get;set;}
    public User_Story__c userStory {get;set;}
    public boolean showSnapshotInformation{get;set;}

    public List<Schema.FieldSetMember> getFields() {
    	List<Schema.FieldSetMember> fields = SObjectType.Git_Backup__c.FieldSets.Commit_Files_Information.getFields();
        showSnapshotInformation = fields.size()>0;
        return fields;
    }
    public List<Schema.FieldSetMember> getUSFields() {
    	return SObjectType.User_Story__c.FieldSets.Commit_Files_Information.getFields();
    }
	/**
	 * constructor
	 * @return [description]
	 */
	public GitCommitChangesController() {
		// get from parameter the related snapshot
		Map<String, String> params = ApexPages.currentPage().getParameters();

		repositoryId = params.get('repoId');
		snapshotId = params.get('snapshotId');
		orgId = params.get('orgId');
        userStoryId = params.get('userStoryId');
        
        String Commit_Message = '';
        if(String.isNotEmpty(userStoryId)) {
            // get values for userStory fields and commit message
            try {
                String query = 'SELECT ';
                for(Schema.FieldSetMember f : this.getUSFields()) {
                    String fp = f.getFieldPath();
                    if(fp != 'Name') {
                        query += fp + ', ';
                    }
                }
                query += 'Name FROM User_Story__c WHERE Id =:userStoryId LIMIT 1';
                userStory = Database.query(query);
            } catch (Exception e) {
                System.debug(e);
            }
            for( User_Story__c us : [SELECT Name, User_Story_Title__c  FROM User_Story__c WHERE Id =:userStoryId]) {
	            Commit_Message = (us.Name +': ' + (String.isEmpty(us.User_Story_Title__c)?'': us.User_Story_Title__c)).left(254);
            }
        }
        
		// get values snapshot fields and subtitle
        try {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : this.getFields()) {
                String fp = f.getFieldPath();
                if(fp != 'Git_Repository__r.Name')  {
                    query += fp + ', ';
                }
            }
            query += ' Git_Repository__r.Name FROM Git_Backup__c WHERE Id =:snapshotId LIMIT 1';
            gitBackup = Database.query(query);
        } catch (Exception e) {
            System.debug(e);
        }
        
        Git_Backup__c snapshot = [SELECT Org__r.Name, Branch__c, Git_Repository__r.Name FROM Git_Backup__c WHERE Id =:snapshotId ];
		orgName = snapshot.Org__r.Name;
		repoName = snapshot.Git_Repository__r.Name;
		branch = snapshot.Branch__c;

		// create a fake commit record
		gitCommit = new Git_Org_Commit__c(
			Git_Backup__c = snapshotId,
			Org__c = orgId,
            Commit_Message__c = Commit_Message
		); 
	}
}