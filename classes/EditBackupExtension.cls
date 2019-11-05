public with sharing class EditBackupExtension {

    public final String STATIC_RESOURCE = 'StaticResource';

    private List<String> metadataTypes;
    public List<SelectOption> types;
    public List<SelectOption> selectedTypes{get;set;}
    public Git_Backup__c backup;
    public List<String> sel{get;set;}
    public boolean showOtherInformation{get;set;}

    public Boolean isStaticResourcesSelected {get;set;}

    
    public Settings settings {get;set;}
    
    public EditBackupExtension(ApexPages.StandardController stdController) {
        settings = new Settings();
        backup = (Git_Backup__c)stdController.getRecord();
        
        isStaticResourcesSelected = false;
        selectedTypes = new List<SelectOption>();
        sel = new List<String>();

        if(backup.Metadata_Types__c != null){
            for(String t:backup.Metadata_Types__c.split(',')){
                selectedTypes.add(new SelectOption(t,t));    
                sel.add(t);

                if(t == STATIC_RESOURCE){
                    isStaticResourcesSelected = true;
                }
            }
        }else{
            isStaticResourcesSelected = true;
        }
        sel.sort();

        showOtherInformation = SObjectType.Git_Backup__c.FieldSets.CustomFields.getFields().size()>0;
    }
    public void init(){
        
    }
    public void reRender(){
        
    }
    public List<String> getMetadataTypes(){

        return MetadataTypesHelper.getMetadataTypesByOrgId(backup.Org__c);
    
    }

    public List<SelectOption> getTypes() {

        return MetadataTypesHelper.getTypeOptionsByOrgId(backup.Org__c, sel);
    
    }

    public void setTypes(List<SelectOption> l){
        types = l;
    }

    public PageReference save(){
        backup.Metadata_Types__c = MetadataTypesHelper.joinOptions(selectedTypes);
        if(String.isNotBlank(backup.Frequency__c) && backup.Frequency__c!='None' && backup.Git_Snapshot_Permissions__c == 'Allow Commits Only'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.COMMIT_ONLY_SNAPSHOTS_CANNOT_BE_SCHEDULED));
            return null;
        }
        upsert backup;
        return new PageReference('/'+backup.id);
    }

    /**
     * This method is a helper which refresh the OrgId when the record is new
     * Is a helper for javascript refresh call
     */
    public PageReference orgChanged(){
        
        //get the new ID 
        String OrgId = Apexpages.currentPage().getParameters().get('OrgId');
        //save to controller record
        backup.Org__c = OrgId;
        //refresh MetadataTypes using the new Id
        getMetadataTypes();
        return null;
    }

    
}