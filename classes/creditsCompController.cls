public with sharing class creditsCompController {
	
	public String buyCreditsUrl {get;set;}
	public String manageSubscriptionUrl {get;set;}
	public String autoRechargeUrl {get;set;}
	public String creditBalance{get;set;}
    public String minutesBalance {get;set;}
	public boolean isValid {get;set;}
	public boolean autoRechargeEnabled {get;set;}
	
	public boolean showError {get;set;}
	public String errorMessage {get;set;}
	
	public creditsCompController(){
		showError = false;
		autoRechargeEnabled = false;
		errorMessage = '';
		isValid = true;
		getCredits();
	}
	public void getCredits(){
		try{
			Http h = new Http();
	    	HttpRequest req = new HttpRequest();
	    	DeployAPI.setAuthHeaders(req);//to authenticate agains heroku servers
	    	String url = [Select API_URL__c from User where Id=:Userinfo.getUserId()].API_URL__c;
	    	req.setEndpoint(settings.Server_URL+'/?sid='+userInfo.getSessionId()+'&url='+ EncodingUtil.urlEncode(url,'UTF-8'));
	    	req.setMethod('GET');
	    	HttpResponse res = h.send(req);
	    	Map<String, Object> fullMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
			Map<String, Object> orgMap = (Map<String, Object>)fullMap.get('customerOrg');
            if(res.getStatusCode()==200){
                creditBalance = ''+(Integer)orgMap.get('credits');
                minutesBalance = ''+(Integer)orgMap.get('minutes');
                autoRechargeEnabled = (boolean)orgMap.get('autoRecharge');
                buyCreditsUrl = settings.Copado_Site+'/buyCredits?sId='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode(url,'UTF-8')+'&lang='+Userinfo.getLanguage()+'&userId='+userinfo.getUserId()+'&orgId='+Userinfo.getOrganizationId();
                autoRechargeUrl = settings.Copado_Site+'/autoRecharge?sId='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode(url,'UTF-8')+'&lang='+Userinfo.getLanguage()+'&userId='+userinfo.getUserId()+'&orgId='+Userinfo.getOrganizationId();
                manageSubscriptionUrl = settings.Server_URL+'/subscription/manage?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode(url,'UTF-8');
            }
            else{
                showError = true;
				errorMessage = res.getStatusCode()+' - '+res.getStatus();
            }
                
		}
		catch(Exception ex){
			showError = true;
			errorMessage = ''+ex;
		}
	}
}