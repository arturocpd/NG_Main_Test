public with sharing class UserStoryImportSetController {
	public apexpages.standardsetcontroller con;

    public List<User_Story__c> records {get;set;}
    // used only to render/read the lookup field
    public Deployment_Task__c  dummy {get;set;}
    // list of all the metadata items selected in all the commits, unique
    public Map<String, MetaDataItem> allMetadata = new Map<String, MetaDataItem>();
	
    public class MetaDataItem {
         public String t {get;set;}
         public String n {get;set;}
         public boolean r;
         public boolean s;
         public String cb;
         public String cd;
    }

	public UserStoryImportSetController(apexpages.standardsetcontroller std){
        con = std;
		dummy = new Deployment_Task__c ();
        records = (List<User_Story__c>)std.getSelected();
        allMetadata = new Map<String, MetaDataItem>();
	}

    public void initPage() {
        gatherMetadataFromCommits();
    }
    
    public void gatherMetadataFromCommits() {
        if(records.size()<1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'You need to select at least one user story with commits.'));
            return;
        }
        List<String> ids = new List<String>();
        for(User_Story__c r : records)
            ids.add(r.Id);
        // fetch each MetaData attachment from each commit associated with each user story
        List<Attachment> atts = [SELECT Id, Body FROM Attachment WHERE Name='Metadata' AND ParentId in 
                                 (SELECT Snapshot_Commit__c FROM User_Story_Commit__c WHERE User_Story__r.Id IN :ids )
                                 ORDER BY CreatedDate DESC];
        System.debug('got '+atts.size()+' for ids: '+ids.size());
		for (Attachment a : atts) {
            List<MetaDataItem> metadata = new List<MetaDataItem>();
            try{
                metadata = (List<MetaDataItem>) JSON.deserialize(a.Body.toString(), List<MetaDataItem>.class);
            }catch(Exception e) {
                System.debug(LoggingLevel.ERROR, e);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Couldnt parse attachment for'));
            }
            // merge the commit metadata to the allMetadata set.
            for(MetaDataItem mi : metadata) {
                String key = mi.t+'.'+mi.n;
                System.debug('- '+key+' '+mi.s+' '+mi);
                if(!allMetadata.containsKey(key)) {
                    mi.s = true;
                    allMetadata.put(key, mi);
                }else{
                    // if it exists, check if it has mi.r = false, and ensure it's also false in allMetadata
                    // this is to ensure if it is not retrieve-only at least once, it must be not retrieve only.
                    if(mi.r==null||!mi.r)
                        allMetadata.get(key).r = false;
                }
            }
		}
    }
    
    public List<MetaDataItem> getAllMetadata() {
        return allMetadata.values();
    }
    
	public PageReference cancel(){
		return con.cancel();
	}
    
	public PageReference assign(){
        if(allMetadata.size()<1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no metadata selection in the selected user stories'));
            return null;
        }
        Id userStoryId = dummy.User_Story__c;
        Attachment att = new Attachment(ParentId=userStoryId, Name='MetadataPreselection-UsertStoryImport', Body=Blob.valueOf(JSON.serialize(allMetadata.values())));
        insert att;
        
        PageReference pr = Page.UserStoryCommitIntermediary;
        pr.setRedirect(true);
        String uri = pr.getUrl()+'?Id='+userStoryId+'&MetadataPreselectionId='+att.Id;
		return new PageReference(uri);
	}
}