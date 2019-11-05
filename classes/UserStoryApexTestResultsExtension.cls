public with sharing class UserStoryApexTestResultsExtension {

    private final User_Story__c userStory;
    public String attId {get;set;}
    public Boolean hasAttachment {get;set;}
    
    public static final String[] USERSTORY_FIELDS = new String[] {'Id','Name', 'Org_Credential__c', 'Org_Credential__r.Error__c', 'Org_Credential__r.Validated_Date__c', 'Minimum_Apex_Code_Coverage__c', 'Has_Apex_Code__c'};
    
    public UserStoryApexTestResultsExtension(ApexPages.StandardController stdController) {
        hasAttachment = false;
        if (!Test.isRunningTest())stdController.addFields(USERSTORY_FIELDS);
        this.userStory = (User_Story__c)stdController.getRecord();
        
        if(userStory.Org_Credential__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'This user story does not have a source org. Please add a Source Org to the User Story and try again.'));
            return;
        }
        
        getAttachment();
        if(userStory.Org_Credential__r.Error__c != null || userStory.Org_Credential__r.Validated_Date__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'The selected org is not validated.'));
        }
        if(hasAttachment == false){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'This user story has no Apex Test Results. Press the \'Run Tests\' button.'));
        }
    }
    public void getAttachment(){
        List<Apex_Test_Result__c> res = [select id from Apex_Test_Result__c where Org__c = :userStory.Org_Credential__c order by createddate desc limit 1];
        if (res.size()==0)return;
        List<Attachment> atts = [select Id from Attachment where Name ='ApexTestResult' and ParentId=:res.get(0).Id order by LastModifiedDate DESC];
        if(atts.size()> 0){
            this.hasAttachment = true;
            attId = atts.get(0).Id;
        }
    }
}