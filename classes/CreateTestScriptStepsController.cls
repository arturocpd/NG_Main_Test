public with sharing class CreateTestScriptStepsController {
    public Test_Script__c testScript {get;set;}
    public String testScriptId {get;set;}
    public List<stepRow> scriptSteps {get;set;}
    public Integer rowCount {get;set;}
    public Test_Script_Step__c dummyStep {get;set;}
    public Settings settings {get;set;}
    
    public CreateTestScriptStepsController(){
        settings = new Settings();
        testScriptId = ApexPages.currentPage().getParameters().get('tId');
        testScript = CMUtilities.getTestScriptById(testScriptId);
        getSteps();
        dummyStep = new Test_Script_Step__c();
    }
    public PageReference returnToTestScript(){
        return new PageReference('/'+testScriptId);
    }
    public void addRow(){
        scriptSteps = new List<stepRow>();
        dummyStep.Test_Script__c = testScriptId;
        dummyStep.Order__c = rowCount+1;
        insert dummyStep;
        dummyStep = new Test_Script_Step__c();
        scriptSteps = getSteps();
    }
    public List<stepRow> getSteps(){
        scriptSteps = new List<stepRow>();
        rowCount = 0;
        List<Test_Script_Step__c> tmp = new List<Test_Script_Step__c>();
        tmp = CMUtilities.getTestScriptStepsByTest(testScriptId);
        if(tmp == null)return null;
        for(Test_Script_Step__c s : tmp){
            scriptSteps.add(new stepRow(s));
            rowCount++;
        }
        return scriptSteps;
    }
        
    public class stepRow {
        public Test_Script_Step__c step {get;set;}
        
        public stepRow(Test_Script_Step__c s){
            step = s;
        }
        public void saveStep(){
            try{
                update step;
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getMessage()));
            }
        }
        public void deleteStep(){
            delete step;
        }
    }
}