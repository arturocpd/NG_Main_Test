public class snapshotDifferenceExtension{
    //public boolean disableRunDeepDiff {get;set;}
    //public boolean renderDiffResults {get;set;}
    public boolean isEdit {get;set;}
    public Settings settings {get;set;}
    public Snapshot_Difference__c snapshot {get;set;}
    Public ApexPages.Standardcontroller controller {get;set;}
    public String keyPrefix {get;set;}
    public Boolean isSnapshotEnabled{get;set;}
    public boolean isShareable{get;set;}
    
    public static final String[] SNAPSHOT_FIELDS = new String[] {'Id','Name','Last_Run__c','Source_Option__c','Destination_Option__c','Source_Git_Commit__c','Destination_Git_Commit__c','Source_Org_Credential__c','Destination_Org_Credential__c'};
    
    public snapshotDifferenceExtension(ApexPages.StandardController stdController){
        settings = new Settings();
        controller = stdController;
        if (!Test.isRunningTest())stdController.addFields(SNAPSHOT_FIELDS);
        this.snapshot = (Snapshot_Difference__c)stdController.getRecord();
        DescribeSObjectResult dsr = Git_Org_Commit__c.sObjectType.getDescribe();
        keyPrefix = dsr.getKeyPrefix();
        //renderDiffResults = false;
        //disableRunDeepDiff = true;
        isEdit = true;
        if(this.snapshot == null){
            this.snapshot = new Snapshot_Difference__c();
            //disableRunDeepDiff = true;
        }
        //calculate last run based on lastmodified date of index.json
        if(!String.isBlank(this.snapshot.Id)){
            List<Attachment> atts = [select LastModifiedDate from Attachment where parentId =:this.snapshot.Id and name = 'index.json' order by LastModifiedDate desc limit 1];
            if (atts.size()==1)this.snapshot.Last_Run__c = atts.get(0).LastModifiedDate;
        }
        

        if(snapshot.Id != null && snapshot.Last_Run__c!=null){
            //this.renderDiffResults = true;
            //disableRunDeepDiff = false;
        }
        if(snapshot.Id !=null)isEdit = false;
        //evaludateDisableRunDiff();

        isSnapshotEnabled = true;
        if(!FeatureHelper.isFeatureEnabled('Snapshot Difference')){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error,Label.FEATURE_NOT_SUPPORTED+' Snapshot Difference'));
            isSnapshotEnabled = false;
        }
        System.debug('*** feature enabled: ' + isSnapshotEnabled);
        Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
		isShareable = tokens.containsKey('Snapshot_Difference__Share');
    }
    /*public void evaludateDisableRunDiff(){
        if(snapshot.Source_Option__c==null || snapshot.Destination_Option__c==null){
            disableRunDeepDiff = true;
            return;
        }
        if(snapshot.Source_Option__c=='Git Commit' && snapshot.Source_Git_Commit__c==null)disableRunDeepDiff = true;
        if(snapshot.Destination_Option__c=='Git Commit' && snapshot.Destination_Git_Commit__c==null)disableRunDeepDiff = true;
        if(snapshot.Source_Option__c=='Salesforce Org' && snapshot.Source_Org_Credential__c==null)disableRunDeepDiff = true;
        if(snapshot.Destination_Option__c=='Salesforce Org' && snapshot.Destination_Org_Credential__c==null)disableRunDeepDiff = true;
        disableRunDeepDiff = false;
    }*/
    public void doRerender(){
        //evaludateDisableRunDiff();
        if(snapshot.Destination_Option__c == null){
            snapshot.Destination_Org_Credential__c = null;
            snapshot.Destination_Git_Commit__c = null;
        }
        if(snapshot.Destination_Option__c == 'Git Commit'){
            snapshot.Destination_Org_Credential__c = null;
        }
        if(snapshot.Destination_Option__c == 'Salesforce Org'){
            snapshot.Destination_Git_Commit__c = null;
        }
        
        if(snapshot.Source_Option__c == null){
            snapshot.Source_Org_Credential__c = null;
            snapshot.Source_Git_Commit__c = null;
        }
        if(snapshot.Source_Option__c == 'Git Commit'){
            snapshot.Source_Org_Credential__c = null;
        }
        if(snapshot.Source_Option__c == 'Salesforce Org'){
            snapshot.Source_Git_Commit__c = null;
        }
    }
    public void edit(){
        isEdit = true;
    }
    public PageReference cancel(){
        return controller.cancel();
    }
    public pageReference save(){
        String errorMsg = 'You must select for both source and destination a valid Salesforce Org or Git Commit record.';
        if(snapshot.Source_Option__c==null || snapshot.Destination_Option__c==null){
            snapshot.addError(errorMsg);
            return null;
        }
        if((snapshot.Source_Option__c=='Salesforce Org' && snapshot.Source_Org_Credential__c==null) 
        || (snapshot.Destination_Option__c=='Salesforce Org' && snapshot.Destination_Org_Credential__c==null)){
            snapshot.addError(errorMsg);
            return null;
        }
        if((snapshot.Source_Option__c=='Git Commit' && snapshot.Source_Git_Commit__c==null) 
        || (snapshot.Destination_Option__c=='Git Commit' && snapshot.Destination_Git_Commit__c==null)){
            snapshot.addError(errorMsg);
            return null;
        }
        PageReference pref = controller.save();
        
        return pref;
    }
}