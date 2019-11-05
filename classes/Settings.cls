public with sharing class Settings {

    public static final String DEFAULT_COPADO_SITE = 'https://copado.secure.force.com';
    public static final String DEFAULT_SERVER_URL = 'https://copado.herokuapp.com';
    public static final String DEFAULT_NAMESPACE = 'copado__';
    public static final String NONE = 'none';

    
    
    /**
     * copado force site for oauth callback
     */
    public static String copado_site;
    /**
     * Heroku server URL
     */
    public static String server_url ;
    /**
     * Copado App Namespace
     */
    public static String ns;

    /**
     * This attribute contains the session Id and the url parameter for heroku api calls
     */
    public static String generic_heroku_params;
    

    /**
     * Perform all statics initializations here
     */
    static {

        // get custom setting only once. 
        Settings__c s = Settings__c.getOrgDefaults();

        // set custom setting or default values
        copado_site = String.isNotBlank(s.Copado_Site__c)? s.Copado_Site__c : Settings.DEFAULT_COPADO_SITE;
        server_url = String.isNotBlank(s.Server_URL__c)? s.Server_URL__c : Settings.DEFAULT_SERVER_URL;

        //set default namespace unless it is forced to NONE
        ns = String.isNotBlank(s.Namespace__c) ? (s.Namespace__c != Settings.NONE ? s.Namespace__c : '' ) : Settings.DEFAULT_NAMESPACE; 

        //set the generic parameters to be used in all pages that calls heroku
        //when running on post install script user query will return no records
        String salesforceURL = 'https://login.salesforce.com/services/Soap/u/29.0/00Dxxxxxxxxx';
        List<User> thisUser = [select API_URL__c from User where id=:userinfo.getUserId()];
        if(thisUser.size() == 1){
            salesforceURL = thisUser.get(0).API_URL__c;
        }
        generic_heroku_params = '?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode(salesforceURL,'UTF-8');
    }
    
    public String herokuServer {get;set;}
    public String urlParameters {get;set;}
    public String urlBase {get;set;}
    public String namespace {get;set;}
    public Personal_Settings__c mySettings {get;set;}
    /**
     * This is set only in User Story VF
     */
    public SObject userStoryObj {get;set;}

    /**
     * Helper to serialize the US
     * @return [json]
     */
    public String getUserStoryAsJSON(){
        return JSON.serialize(this.userStoryObj);
    }

    private void constructor(){
        //TODO: move this to external util method in order to use it in other classes 
        urlParameters = Settings.generic_heroku_params;
        herokuServer = Settings.Server_URL;
        urlBase = server_url + '/json/v1/';
        namespace = Settings.ns;
        mySettings = Personal_Settings__c.getInstance();
        if(mySettings==null)mySettings = new Personal_Settings__c(SetupOwnerId=UserInfo.getUserId());
        mySettings.API_Key__c = DeployAPI.decryptAPIKey(mySettings.API_Key__c);
    }

    
    public Settings(ApexPages.StandardController ext) {
        constructor();
    }

    public Settings(GitCommitLookupController controller) {
        constructor();
    }

    public Settings(GitCommitChangesController controller) {
        constructor();
    }

    
    public Settings(){
        constructor();
    }
}