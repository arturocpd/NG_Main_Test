public with sharing class ManageEnvVarsExt {

    public List<ManagedEnvVars> Lmenv {get;set;}
    public Set<Id> SenvIds = new Set<Id>();
    public Set<String> SenvNames = new Set<String>();
    public Boolean editing {get;set;}
    public String newEnvVarName {get;set;}
    public String deleteVarName {get;set;}
    
    public ManageEnvVarsExt (ApexPages.StandardController std) {
        bestPractices();
        editing = false;
    }
    
    public void editModeOn () {
        editing = true;
    }
    
    public void bestPractices () {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.ENV_VARS_EASY_VALUES));
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.ENV_VARS_GOOD_VALUES));
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.ENV_VARS_COMMIT));
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.ENV_VARS_DEPLOY));
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.ENV_VARS_MORE + ' <a href="' + Label.ENV_VARS_DOCS + '">' + Label.ENV_VARS_DOCS + '</a>'));
    }
    
    public void createMissingVars () {
        
        List<Environmental_Variable__c> LevIns = new List<Environmental_Variable__c>();
        String repo;
        Set<String> Sbranches = new Set<String>();
        
        String deploymentFlowId = ApexPages.currentPage().getParameters().get('dfId');
        
        for (Deployment_Flow_Step__c dfs: [SELECT Source_Environment__c, Destination_Environment__c, Source_Environment__r.Name, Destination_Environment__r.Name, Branch__c, Deployment_Flow__r.Git_Repository__c
                                           FROM Deployment_Flow_Step__c WHERE Deployment_Flow__c = :deploymentFlowId]) {
            SenvIds.add(dfs.Source_Environment__c);
            SenvIds.add(dfs.Destination_Environment__c);
            SenvNames.add(dfs.Source_Environment__r.Name);
            SenvNames.add(dfs.Destination_Environment__r.Name);
            Sbranches.add(dfs.Branch__c);
            repo = dfs.Deployment_Flow__r.Git_Repository__c;
        }
        
        for (Continuous_Integration__c ci : [SELECT Destination_Org_Credential__r.Environment__c, Destination_Org_Credential__r.Environment__r.Name 
                                             FROM Continuous_Integration__c WHERE Branch__c IN :Sbranches AND Git_Repository__c = :repo]) {
        	SenvIds.add(ci.Destination_Org_Credential__r.Environment__c);
            SenvNames.add(ci.Destination_Org_Credential__r.Environment__r.Name + ' - CI');

        }
        
        List<Environmental_Variable__c> Lev = [SELECT Id, Name, Value__c, Environment__c FROM Environmental_Variable__c WHERE Environment__c IN :SenvIds ORDER BY Name, Environment__c];
        
        Map<String,Set<String>> existingNames = new Map<String,Set<String>>();
        
        for (Environmental_Variable__c ev :Lev) {
            if (existingNames.containsKey(ev.Name)) {
                Set<String> tmp = existingNames.get(ev.Name);
                tmp.add(ev.Environment__c);
                existingNames.put(ev.Name, tmp);
            }
            else {
                Set<String> tmp = new Set<String>();
                tmp.add(ev.Environment__c);
                existingNames.put(ev.Name, tmp);
            }
        }
        
        for (String en :existingNames.keySet()) {
            for (Id envId :SenvIds) {
                Set<String> tmp = existingNames.get(en);
                if (!tmp.contains(envId)) {
                    Environmental_Variable__c ev = new Environmental_Variable__c();
                    ev.Name = en;
                    ev.Environment__c = envId;
                    ev.Value__c = null;
                    LevIns.add(ev);
                }
            }
        }
        
        insert LevIns;
    }
    
    public List<ManagedEnvVars> getEnvVars () {
        
        Lmenv = new List<ManagedEnvVars>();
        
        List<Environmental_Variable__c> Lev = [SELECT Id, Name, Value__c, Environment__c, Environment__r.Name FROM Environmental_Variable__c WHERE Environment__c IN :SenvIds ORDER BY Name, Environment__r.Name];
        
        String prevName = null;
        ManagedEnvVars mev = new ManagedEnvVars();
        mev.LmanagedEnvVar = new List<Environmental_Variable__c>();
        for (Environmental_Variable__c ev :Lev) {
            if (prevName != ev.Name && prevName != null) {
                Lmenv.add(mev);
                mev = new ManagedEnvVars();
                mev.meName = ev.Name;
                mev.LmanagedEnvVar = new List<Environmental_Variable__c>();
            }
            mev.meName = ev.Name;
            mev.LmanagedEnvVar.add(ev);
            prevName = ev.Name;
        }
        Lmenv.add(mev);
        
        return Lmenv;
    }
    
	public List<String> getEnvNames () {
        List<String> Lcolumns = new List<String>();
        List<String> LcolumnsSorted = new List<String>();
        Lcolumns.add(Label.NAME);
        LcolumnsSorted.addAll(SenvNames);
        LcolumnsSorted.sort();
        Lcolumns.addAll(LcolumnsSorted);
        return Lcolumns;
    }
    
    public void save () {

        List<Environmental_Variable__c> LevUpd = new List<Environmental_Variable__c>();
        for (ManagedEnvVars mev :Lmenv) {
            for (Environmental_Variable__c ev :mev.LmanagedEnvVar) {
                ev.Name = mev.meName;
            }
			LevUpd.addAll(mev.LmanagedEnvVar);            
        }
        update LevUpd;
        
        editing = false;
    }
    
    public void cancel () {

        editing = false;
    }
    
    public void newVar () {

        List<Environmental_Variable__c> LevTmp = new List<Environmental_Variable__c>();
        for (Id envId : SenvIds) {
            Environmental_Variable__c ev = new Environmental_Variable__c();
            ev.Name = newEnvVarName;
            ev.Environment__c = envId;
            ev.Value__c = null;
            LevTmp.add(ev);

        }
        try {
            insert LevTmp;
            ManagedEnvVars mev = new ManagedEnvVars();
            mev.meName = newEnvVarName;
            mev.LmanagedEnvVar = new List<Environmental_Variable__c>();
            mev.LmanagedEnvVar.addAll(LevTmp);
            Lmenv.add(mev);  
            editing = true;
        }
        catch (Exception e) {
            if (e.getMessage().contains(Label.DUPLICATED_ENVIRONMENTAL_VARIABLE)) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.DUPLICATED_ENVIRONMENTAL_VARIABLE));
            }
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            }
            editing = false;
        }
    }
    
    public void doDelete () {
        delete [SELECT Id FROM Environmental_Variable__c WHERE Name = :deleteVarName];
    }
    
    public class ManagedEnvVars {
        public String meName {get;set;}
        public List<Environmental_Variable__c> LmanagedEnvVar {get;set;}
    }
}