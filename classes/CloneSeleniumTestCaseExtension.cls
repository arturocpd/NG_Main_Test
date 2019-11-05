public class CloneSeleniumTestCaseExtension {
    public final Selenium_Test_Case__c tc{get;set;}
    public Selenium_Test_Case__c clonedTC{get;set;}
    public CloneSeleniumTestCaseExtension(ApexPages.StandardController stdController) {
        tc = [select id, name, Version__c from Selenium_Test_Case__c where id = :stdController.getId()];
        clonedTC = tc.clone();
        // A new version must be created.
        Integer next = 1;
        try{
            System.debug('tc.Version__c='+tc.Version__c);
            next = Integer.valueOf(tc.Version__c.replace('v','')) + 1;
        }catch(Exception e) {
            System.debug('Error parsing the attachment name for the next version '+e);
            next = 2;
        }
        clonedTC.Version__c = ''+next;
        clonedTC.Previous_Version__c = tc.Id;
        clonedTC.Name = clonedTC.Name.replaceAll('-v[0-9]+$', '')+'-v'+clonedTC.Version__c;
    }

    public PageReference doClone(){
        insert clonedTC;

        Attachment[] sobs;
        List<Id> doneIds = new List<Id>();
        do {
            sobs = [
                    select Id, ParentId, Name, Description, Body, ContentType
                    from Attachment
                    where ParentId = :tc.Id
                    and Id not in :doneIds
                    limit 1
                    ];
            if (sobs.size() == 1) {
                Attachment sob = sobs[0];
                if( sob.Name == 'Copado.SeleniumTestCase.json' ) {
                    Map<String, Object> tc = (Map<String, Object>)JSON.deserializeUntyped(sob.Body.toString());
                    tc.put('name', (String)clonedTC.Name);
                    sob.Body = Blob.valueOf(JSON.serialize(tc));
                }
                insert new Attachment(
                        ParentId = clonedTC.Id,
                        Name = sob.Name,
                        Description = sob.Description,
                        Body = sob.Body,
                        ContentType = sob.ContentType
                        );
                doneIds.add(sob.Id);
                System.debug('>>> loop heap=' + Limits.getHeapSize());
            }
        } while (sobs.size() == 1);


        return new PageReference('/'+clonedTC.Id);
    }
}