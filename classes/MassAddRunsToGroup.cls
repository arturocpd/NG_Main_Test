public with sharing class MassAddRunsToGroup {
    public List<Selenium_Test_Run__c> runs;
    public AuxiliaryObject__c dummy {get;set;}
    public apexpages.standardsetcontroller con;
    public MassAddRunsToGroup(apexpages.standardsetcontroller std){
        con = std;
        runs = (List<Selenium_Test_Run__c>)std.getSelected();
        System.debug('MassAddRunsToGroup selected... '+runs.size());
        dummy = new AuxiliaryObject__c ();
    }
    public PageReference cancel(){
        return con.cancel();
    }
    public PageReference add(){
        List<Selenium_Test_Run__c> dos = new List<Selenium_Test_Run__c>(); 
        for (Selenium_Test_Run__c o: runs){
            dos.add( new Selenium_Test_Run__c(Id=o.Id, Selenium_Test_Group__c = dummy.Selenium_Test_Group__c) );
        }
        System.debug('MassAddRunsToGroup updating... '+dos.size());
        if(dos.size()>0){
            Database.SaveResult[] res = Database.update(dos, false);
            boolean err = false;
            for(Database.SaveResult r:res){
                if(!r.isSuccess()){
                    err = true;
                    apexpages.addMessage(new Apexpages.Message(apexpages.severity.error, r.getErrors()[0].getMessage()));
                }
            }
            if(err)return null;
        }
        else{
            apexpages.addMessage(new Apexpages.Message(apexpages.severity.error, Label.SELECT_AT_LEAST_ONE_RECORD));
            return null;
        }
        return new PageReference('/' + dummy.Selenium_Test_Group__c);
    }
}