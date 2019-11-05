public with sharing class PromotionEditExtension {
    
    public boolean showOtherInformation{get;set;}
    
    public PromotionEditExtension(ApexPages.StandardController stdController) {
        
        showOtherInformation = SObjectType.Promotion__c.FieldSets.CustomFields.getFields().size()>0;
    }
}