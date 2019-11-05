global with sharing class JsRemotingController {
	/*
	The purpose of this class is to encapsulate various methods of Apex controller
	and make these available via Javascript Remoting.
	*/
    @RemoteAction
    global static String createAPIKey(){
        Personal_Settings__c mySettings = Personal_Settings__c.getInstance();
        if(String.isBlank(mySettings.API_Key__c)){
            DeployApi.createAPIKey();
        }
        return DeployAPI.getUserAPIKey();
    }
    
    /**
     * constructor methods. 
     */
    public JsRemotingController(ApexPages.StandardController sc) {}
    public JsRemotingController(){}
}