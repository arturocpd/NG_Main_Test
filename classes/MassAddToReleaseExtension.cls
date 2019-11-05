public with sharing class MassAddToReleaseExtension {
	public final Release__c release {get;set;}
	public List<Sprint__c> sprints {get;set;}
	public List<sprintWrapper> wrappedSprints {get;set;}
	
	public static final String[] RELEASE_FIELDS = new String[] {'Id','Name','Project__c','Project__r.Name' };
	
	public MassAddToReleaseExtension(ApexPages.StandardController stdController) {
		if(!Test.isRunningTest())stdController.addFields(RELEASE_FIELDS);
		release = (Release__c)stdController.getRecord();
		sprints = new List<Sprint__c>();
		sprints = [select Id, Name, Release__c, Project__c, (select Id, Name, Project__c, User_Story_Title__c from User_Stories__r) from Sprint__c where Project__c =:release.Project__c];
		
		//User stories by Sprint	
		if(sprints.size() > 0){
			wrappedSprints = wrapSprints(sprints);
		}
		
	}
	public PageReference massAdd_BySprint(){
		List<User_Story__c> updates = new List<User_Story__c>();
		for(sprintWrapper sw : wrappedSprints){	
			for(userStoryWrapper usw : sw.usWrapper){
				if(usw.selected==true){
					usw.userStory.Release__c = release.Id;
					updates.add(usw.userStory);
				}
			}
		}
		if(updates.size() > 0){
			try{
				update updates;
			}
			catch(Exception ex){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+ex.getMessage()));
			}
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your selected User Stories have been added to the Release'));
			for(sprintWrapper sw : wrappedSprints){	
				for(userStoryWrapper usw : sw.usWrapper){
					usw.selected = false;
				}
			}
		}
		else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You must select at least 1 User Story to add to the Release'));
		}
		return null;
	}
	public List<sprintWrapper> wrapSprints(List<Sprint__c> ss){
		List<sprintWrapper> ws = new List<sprintWrapper>();
		List<userStoryWrapper> tmp = new List<userStoryWrapper>();
		for(Sprint__c s : ss){
			tmp = new List<userStoryWrapper>();
			for(User_Story__c u : s.User_Stories__r){
				tmp.add(new userStoryWrapper(false, u));
			}
			ws.add(new sprintWrapper(false, s, tmp));
		}
		return ws;
	}
	public class sprintWrapper{
		public boolean selected {get;set;}
		public Sprint__c sprint {get;set;}
		public List<userStoryWrapper> usWrapper {get;set;}
		
		public sprintWrapper(Boolean b, Sprint__c s, List<userStoryWrapper> us){
			this.selected = b;
			this.sprint = s;
			this.usWrapper = us;
		}
	}
	public class userStoryWrapper{
		public boolean selected {get;set;}
		public User_Story__c userStory {get;set;}
		public userStoryWrapper(Boolean b, User_Story__c us){
			this.selected = b;
			this.userStory = us;
		}
	}
}