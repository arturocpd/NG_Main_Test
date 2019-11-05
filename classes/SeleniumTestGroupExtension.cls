public class SeleniumTestGroupExtension {
    Selenium_Test_Group__c grp;
    public SeleniumTestGroupExtension (ApexPages.StandardController stdController){
        this.grp = (Selenium_Test_Group__c)stdController.getRecord();
    }
    public PageReference runGroup(){
        try{
        	WebhookAPI.runSeleniumTestGroup(grp.Id, DeployAPI.getUserAPIKey());    
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
		return new PageReference('/'+grp.Id);
    }
}