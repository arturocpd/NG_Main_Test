global with sharing class rateCopadoController {
	public boolean showMessage {get;set;}
	public String messageType {get;set;}
	public String messageTitle {get;set;}
	public static User u {get;set;}
	
	public rateCopadoController(){
		u = [select Id, Hide_Copado_feedback__c from User where Id =:UserInfo.getUserId() limit 1];
		showMessage = !u.Hide_Copado_feedback__c;
	}
	@RemoteAction
	public static boolean optOutUser(){
		u = new User(Id=UserInfo.getUserId(), Hide_Copado_feedback__c=true);
		update u;
		return true;
	}
}