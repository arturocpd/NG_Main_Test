public with sharing class PromoteChangesExtension {
    public Promotion__c promotion {get;set;}
    public List<Schema.FieldSetMember> promotionRelatedList {get;set;}
    
    public List<userStoryWrapper> userStories {get;set;}
    public List<promotedStoryWrapper> promotedWrappedStories {get;set;}
    public Set<Id> promotedIdsSet {get;set;}
    public ApexPages.Standardcontroller controller {get;set;}
    public Boolean renderTable_userStories {get;set;}
    public Boolean renderTable_promotions {get;set;}
    public Boolean renderStep1 {get;set;}
    public Boolean renderBtnPromote {get;set;}
    public boolean enableCreateDeploymentButton {get;set;}
    public String promotedUserStoryIds {get;set;}

    public static final String[] PROMOTION_FIELDS = new String[] {'Id','Name','Project__c','Create_Full_Permission_Sets_Step__c','Create_Full_Profiles_Step__c','Destination_Environment__c','Source_Environment__c','Source_Org_Credential__c', 'Destination_Org_Credential__c', 'Project__r.Deployment_Flow__c','Send_Deployment_Complete_email__c', 'Release__c'};
    
    public PromoteChangesExtension(ApexPages.StandardController stdController) {
        promotedIdsSet = new Set<Id>();
        renderTable_promotions = false;
        renderTable_userStories = false;
        renderBtnPromote = false;
        renderStep1 = true;
        controller = stdController;
        if (!Test.isRunningTest())stdController.addFields(PROMOTION_FIELDS);
        this.promotion = (Promotion__c)stdController.getRecord();
        if(this.promotion == null){
            this.promotion = new Promotion__c();
        }
        promotionRelatedList = SObjectType.User_Story__c.FieldSets.PromotionRelatedList.getFields();
        refreshTables();
    }
    public void refreshTables(){
        promotedIdsSet = new Set<Id>();
        promotedWrappedStories = getPromotedUserStories();
        userStories = listUserStories();
    }
    public void gotoAddUserStories(){
        listUserStories();
    }
    public List<promotedStoryWrapper> getPromotedUserStories(){
        promotedWrappedStories = new List<promotedStoryWrapper>();
        String queryFields = '';
        for(Schema.FieldSetMember f : SObjectType.User_Story__c.FieldSets.PromotionRelatedList.getFields()) {
            queryFields += ', User_Story__r.' + f.getFieldPath();
        }
        List<Promoted_User_Story__c> tmp =  Database.query(' SELECT Id, User_Story__c ' + queryFields + ' FROM Promoted_User_Story__c WHERE Promotion__c = \'' + promotion.Id + '\'');
            
            //[select Id, User_Story__c, User_Story__r.Name, User_Story__r.Status__c, User_Story__r.User_Story_Title__c , User_Story__r.Epic__c, User_Story__r.Epic__r.Epic_Title__c, Promotion__c from Promoted_User_Story__c where Promotion__c=:promotion.Id];
        for(Promoted_User_Story__c pus : tmp){
            promotedWrappedStories.add(new promotedStoryWrapper(false, pus));
            promotedIdsSet.add(pus.User_Story__c);
        }
        if(promotedWrappedStories.size()==0){
            gotoAddUserStories();
        }
        enableCreateDeploymentButton = promotedIdsSet.size()>0;
        updatePromotedIdSetToString();
        return promotedWrappedStories;
    }
    public List<userStoryWrapper> listUserStories(){
        userStories = new List<userStoryWrapper>();
        List<User_Story__c> LusProject = new List<User_Story__c>();
        List<User_Story__c> LusRelease = new List<User_Story__c>();
        String queryFields = '';
        for(Schema.FieldSetMember f : SObjectType.User_Story__c.FieldSets.PromotionRelatedList.getFields()) {
            queryFields += ',' + f.getFieldPath();
        }

        if (promotion.Project__c != null) {   
            
            LusProject = Database.query(' SELECT Id ' + queryFields + ' FROM User_Story__c WHERE Promote_Change__c=true ' + 
                             ' AND Environment__c = \'' + promotion.Source_Environment__c + '\'' + 
                             ' AND Project__c = \'' + promotion.Project__c + '\'');
            
        	for(User_Story__c us : LusProject) {
                if(!promotedIdsSet.contains(us.Id)) {
                    userStories.add(new userStoryWrapper(false, us));
                    renderTable_userStories = true; 
                }
            }
        }
        else if (promotion.Release__c != null ) {
            
            LusRelease = Database.query(' SELECT Id ' + queryFields + ' FROM User_Story__c WHERE Promote_Change__c=true ' + 
                             ' AND Environment__c = \'' + promotion.Source_Environment__c + '\'' + 
                             ' AND Release__c = \'' + promotion.Release__c + '\'');
            
            for(User_Story__c us : LusRelease) {             
                if(!promotedIdsSet.contains(us.Id)) {
                    userStories.add(new userStoryWrapper(false, us));
                    renderTable_userStories = true; 
                }
            }
        }
    
        return userStories;
    }
    public void removeSelectedUserStories(){
        List<Promoted_User_Story__c> removals = new List<Promoted_User_Story__c>();
        for(promotedStoryWrapper pus : promotedWrappedStories){
            if(pus.selected)removals.add(new Promoted_User_Story__c(Id=pus.promotedUS.Id));
        }
        delete removals;
        refreshTables();
    }
    public void addStoriesToPromotion(){

        // check if there is any userStories
        if( userStories == null || userStories.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.NO_USER_STORIES_TO_PROMOTE));
            return;
        }

        Integer selcount = 0;
        List<Promoted_User_Story__c> promotedStories = new List<Promoted_User_Story__c>();
        for(userStoryWrapper usw : userStories){
            if(usw.selected==true)selcount++;
        }
        if(selcount == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.NO_USER_STORIES_TO_PROMOTE));
            return;
        }

        for(userStoryWrapper usw : userStories){
            if(usw.selected==true){
                selcount++;
                if(!promotedIdsSet.contains(usw.userStory.Id)){
                    promotedIdsSet.add(usw.userStory.Id);
                    String userStoryTitle = (!String.isBlank(usw.userStory.User_Story_Title__c))?usw.userStory.User_Story_Title__c:'';
                    if(userStoryTitle.length() > 80)userStoryTitle = userStoryTitle.left(80); 
                    promotedStories.add(new Promoted_User_Story__c(Name=userStoryTitle, User_Story__c=usw.userStory.Id, Promotion__c=promotion.Id));
                }
            }
        }
        insert promotedStories;
        refreshTables();
    }
    public void updatePromotedIdSetToString(){
        promotedUserStoryIds = '';
        for(String s : promotedIdsSet){
            promotedUserStoryIds += (promotedUserStoryIds==''?'':',')+s;
        }
    }
    public class promotedStoryWrapper{
        public boolean selected {get;set;}
        public Promoted_User_Story__c promotedUS {get;set;}
        public promotedStoryWrapper(boolean b, Promoted_User_Story__c pus){
            this.selected = b;
            this.promotedUS = pus;
        }
    }
    public class userStoryWrapper{
        public boolean selected {get;set;}
        public User_Story__c userStory {get;set;}
        public userStoryWrapper(boolean b, User_Story__c us){
            this.selected = b;
            this.userStory = us;
        }
    }
}