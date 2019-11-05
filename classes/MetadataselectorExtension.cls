public with sharing class MetadataselectorExtension {
    public User_Story__c userStory {get;set;}
    public ApexPages.Standardcontroller controller {get;set;}
    public Boolean hasOrg {get;set;}
    public Boolean hasError{get;set;}
    public String mode {get;set;}
    public String metadata_url {get;set;}
    public Settings settings{get;set;}
    
    public static final String[] USERSTORY_FIELDS = new String[] {'Id','Name','Org_Credential__c'};
    
    public MetadataselectorExtension(ApexPages.StandardController stdController) {
        settings = new Settings();
        hasOrg = false;
        hasError = false;
        mode = ApexPages.currentPage().getParameters().get('mode');
        mode = (mode=='ApexTests'||mode=='Metadata')?mode:'';
        controller = stdController;
        if (!Test.isRunningTest())stdController.addFields(USERSTORY_FIELDS);
        this.userStory = (User_Story__c)stdController.getRecord();
        if(userStory.Org_Credential__c!=null){
            hasOrg=true;
            String filter = (mode=='ApexTests')?'&filter='+mode:'';
            String urlParameters = '?userStoryId='+userStory.Id+'&sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode([select API_URL__c from User where id=:userinfo.getUserId()].API_URL__c,'UTF-8')+filter;
            String herokuServer = settings.herokuServer;
            String urlBase = herokuServer + '/json/v1/'; 
            metadata_url = urlBase + 'metadata/'+EncodingUtil.urlEncode(userStory.Org_Credential__c,'UTF-8') + urlParameters + '&dates=format&parentId='+EncodingUtil.urlEncode(userStory.Org_Credential__c,'UTF-8');
            if(mode=='ApexTests')metadata_url = urlBase + 'testClasses/'+EncodingUtil.urlEncode(userStory.Org_Credential__c,'UTF-8') + urlParameters;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.NO_ORG_CREDENTIAL_ON_USER_STORY));
            hasError = true;
        }
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