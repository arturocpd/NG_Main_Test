public with sharing class EditOrgDiffExtension {
    
    private OrgDiff__c orgdiff;
    
    private List<String> metadataTypes;
    public List<SelectOption> types;
    public List<SelectOption> selectedTypes{get;set;}
    public List<String> sel{get;set;}
    public Boolean isDiffEnabled{get;set;}

    public String previuosFilterConfig = '';

    
    /**
     * This method is a helper in order to refresh el fromOrgID when the record is new
     * Is a helper for javascript refresh call
     */
    public PageReference fromOrgChanged(){
        
        //get the new ID 
        String fromOrgId = Apexpages.currentPage().getParameters().get('fromOrgId');
        //save to controller record
        orgdiff.From_Org__c = fromOrgId;
        //refresh MetadataTypes using the new Id
        getMetadataTypes();

        copySelectedMetadataTypesFromOrg(fromOrgId);

        return null;
    }

    public void copySelectedMetadataTypesFromOrg(String fromOrgId){

        orgdiff.Metadata_Types__c = MetadataTypesHelper.getMetadataTypesFromOrg(fromOrgId);
        prepareSelectedContext(orgdiff.Metadata_Types__c);

    }

    public List<String> getMetadataTypes(){
    
        return MetadataTypesHelper.getMetadataTypesByOrgId(orgdiff.From_Org__c);

    }


    public List<SelectOption> getTypes() {

        return MetadataTypesHelper.getTypeOptionsByOrgId(orgdiff.From_Org__c, sel);
    
    }
    
    public void setTypes(List<SelectOption> l){
        types = l;
    }

    public void prepareSelectedContext(String orgSelectedTypes){

        selectedTypes = new List<SelectOption>();
        sel = new List<String>();
        if(String.isNotBlank(orgSelectedTypes)){
            for(String t : orgSelectedTypes.split(',')){
                selectedTypes.add(new SelectOption(t,t));    
                sel.add(t);
            }
        }
        sel.sort();


    }

    public EditOrgDiffExtension(ApexPages.StandardController stdController) {
        orgdiff = (OrgDiff__c) stdController.getRecord();
        prepareSelectedContext(orgdiff.Metadata_Types__c);

        //save previous filter convinations in order to know if will be need remove cache when diff is saved
        previuosFilterConfig = makeFilterConfig(orgdiff);
        
        
        isDiffEnabled = true;
        if(!FeatureHelper.isFeatureEnabled('Org Difference')){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error,Label.FEATURE_NOT_SUPPORTED+': Org Difference'));
            isDiffEnabled = false;
        }
    }

    public void checkFiltersAndForceCache(OrgDiff__c od){
   
        if(makeFilterConfig(od) != previuosFilterConfig){
            delete [SELECT Id FROM Attachment where ParentId = :od.Id ];
        }
    }

    public String makeFilterConfig(OrgDiff__c od){
        
        String res = String.isBlank(od.Metadata_Types__c)?'':od.Metadata_Types__c;
        res += String.isBlank(od.From_Org__c)?'':od.From_Org__c;
        res += od.To_Date__c == null ?'': String.valueOf(od.To_Date__c);
        res += od.From_Date__c == null ?'': String.valueOf(od.From_Date__c);
        res += String.isBlank(od.Last_Modified_By_Name__c)?'': od.Last_Modified_By_Name__c;

        return res  ;
    }

    public PageReference save(){
        if(!FeatureHelper.isFeatureEnabled('Org Difference')){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error,Label.FEATURE_NOT_SUPPORTED+': Org Difference'));
            return null;
        }
        
        orgdiff.Metadata_Types__c = MetadataTypesHelper.joinOptions(selectedTypes);

        //TODO: if new selected types are not in org from it should trigger and error. 

        //TODO: this logic should be moved to trigger on new version
        checkFiltersAndForceCache(orgdiff);
        Utilities.Secure_DML(orgdiff, Utilities.DML_Action.UPS, schema.Sobjecttype.OrgDiff__c);
        return new PageReference('/'+orgdiff.id);   
    }
}