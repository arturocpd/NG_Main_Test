public with sharing class QuickCreateUserStoriesController {
	public User_Story__c dummyStory {get;set;}
	public List<storyRow> userStories {get;set;}
	public String projectId {get;set;}
	public String sprintId {get;set;}
	public String epicId {get;set;}
	public boolean preLoadExisting {get;set;}
	public boolean isValid {get;set;}
	
	public QuickCreateUserStoriesController(){
		preLoadExisting = false;
		isValid = true;
		dummyStory = new User_Story__c();
		userStories = new List<storyRow>();
		projectId = ApexPages.currentPage().getParameters().get('pid');
		sprintId = ApexPages.currentPage().getParameters().get('sid');
		epicId = ApexPages.currentPage().getParameters().get('eid');

		try{
			dummyStory.Project__c = projectId;
			dummyStory.Sprint__c = sprintId;
			dummyStory.Epic__c = epicId;
		}
		catch(Exception e){
			isValid = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e));
		}
		setUserStoryPresets();
	}
	public void updatePreset(){
		this.preLoadExisting = preLoadExisting;
		if(!preLoadExisting)userStories = new List<storyRow>();
		if(preLoadExisting)getStories();
	}
	public PageReference updateFromLookups(){
		projectId = dummyStory.Project__c;
		sprintId = dummyStory.Sprint__c;
		setUserStoryPresets();
		return null; 
	}

	public PageReference setUserStoryPresets(){
		if(dummyStory.Project__c != null || dummyStory.Epic__c != null){
			if(preLoadExisting)getStories();
		}
		if(dummyStory.Sprint__c != null){
			if(dummyStory.Project__c == null){
				dummyStory.Project__c = [select Id, Project__c from Sprint__c where Id=:sprintId limit 1].Project__c;
			}
		}
		projectId = dummyStory.Project__c;
		sprintId = dummyStory.Sprint__c;
		epicId = dummyStory.Epic__c;
		return null;
	}
    public List<User_Story__c> getUserStories(){
		if(dummyStory.Sprint__c!= null || dummyStory.Epic__c != null){
            return [select Id, Project__c, Sprint__c, User_Story_Title__c,userStory_Role__c, userStory_Need__c, userStory_Reason__c, createdDate, Epic__c from User_Story__c where Project__c = :dummyStory.Project__c and (Sprint__c = :dummyStory.Sprint__c or Epic__c = :dummyStory.Epic__c) order by createdDate ASC];
		}
		return [select Id, Project__c, Sprint__c, User_Story_Title__c,userStory_Role__c, userStory_Need__c, userStory_Reason__c, createdDate, Epic__c from User_Story__c where Project__c = :dummyStory.Project__c order by createdDate ASC];
	}
	public void addRow(){
        Integer rowIndex = 0; 
		dummyStory.Project__c = projectId;
		dummyStory.Sprint__c = sprintId;
		if(epicId!=null && epicId!=dummyStory.Epic__c){
			dummyStory.Epic__c = epicId;
		}
		else{ 
			epicId = dummyStory.Epic__c;
		}
		insert dummyStory; 
        // Add the recently inserted dummyStory in the userStories list
        if(!preLoadExisting)userStories.add(new storyRow(dummyStory));
		if(preLoadExisting)userStories = getStories();
        // Reset the dummyStory values for the new empty row
		dummyStory = new User_Story__c();
		dummyStory.Project__c = projectId;
		dummyStory.Sprint__c = sprintId;
		dummyStory.Epic__c = epicId;
		setUserStoryPresets();
	}
	public PageReference cancel(){
		if(dummyStory.Project__c != null)return new PageReference('/'+dummyStory.Project__c);
		return new PageReference('/home/home.jsp');
	}
	public List<storyRow> getStories(){
		userStories = new List<storyRow>();
		List<User_Story__c> tmp = new List<User_Story__c>();
		tmp = getUserStories();
		if(tmp == null)return null;
		for(User_Story__c s : tmp){
			userStories.add(new storyRow(s));
		}
		return userStories;
	}
	public class storyRow {
		public User_Story__c story {get;set;}
        
		public storyRow(User_Story__c us){
			story = us;
		}
		public void saveStory(){
			try{
				update story;
			}
			catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getMessage()));
			}
		}
		public void deleteStory(){
			delete story;
		}
	}
}