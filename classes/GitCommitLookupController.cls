public with sharing class GitCommitLookupController{
    public String selectedRepository {get;set;}
    //public Git_Backup__c dummyBackup {get;set;}
    
    public GitCommitLookupController(){
        selectedRepository = '';
    }
    public static List<SelectOption> getRepositories(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- Select --'));
        for(Git_Repository__c r : [select Id, Name from Git_Repository__c order by Name DESC limit 200]){
            options.add(new SelectOption(r.Id, r.Name));
        }
        return options;
    }
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}