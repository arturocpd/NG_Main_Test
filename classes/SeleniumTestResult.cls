public with sharing class SeleniumTestResult {
    ApexPages.StandardController sc = null;
    public SeleniumTestResult(ApexPages.StandardController ctlr)  { 
       sc = ctlr;            
    } 
      
    public String fileBody {
        get {
            Selenium_Test_Result__c r = (Selenium_Test_Result__c)sc.getRecord();
            
            for(Attachment a : [SELECT id, body, name FROM Attachment WHERE ParentId = :r.id AND Name LIKE 'Selenese%.html' ORDER BY CreatedDate DESC LIMIT 1] ) {
                return a.body.toString();
            }
            return '(no data to display)';
        }
    }
}