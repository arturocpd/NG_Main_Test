public with sharing class appHome {
    
    public List<copadoTransaction> transactions {get;set;}
    public List<copadoOrder> orders {get;set;}
    public List<Feature__c> features{get;set;}
    
    public class copadoTransaction{
        public String userName {get;set;}
        public String deployment {get;set;}
        public String stepName {get;set;}
        public String job {get;set;}
        public String destinationOrg {get;set;}
        public String ddate {get;set;}
        public Integer credits {get;set;}
        public Decimal minutes {get;set;}
        public String tType{get;set;}
    }
    public class copadoOrder{
        public String ddate {get;set;}
        public Integer credits {get;set;}
        public Decimal minutes {get;set;}
        public Decimal amount {get;set;}
        public String currencyIsoCode {get;set;}
        public String paymentDetails {get;set;}
    }
    public appHome(){
        transactions = new List<copadoTransaction>();
        orders = new List<copadoOrder>();
        features = Feature__c.getall().values();
    }
    public PageReference init(){
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            DeployAPI.setAuthHeaders(req);//to authenticate agains heroku servers
            String url = [Select API_URL__c from User where Id=:Userinfo.getUserId()].API_URL__c;
            req.setEndpoint(settings.Server_URL+'/?transactions=true&sid='+userInfo.getSessionId()+'&url='+EncodingUtil.urlEncode(url,'UTF-8'));
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            Map<String, Object> fullMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            Map<String, Object> userInfoMap = (Map<String, Object>)fullMap.get('userInfo');
            Map<String, Object> orgMap = (Map<String, Object>)fullMap.get('customerOrg');
            List<Object> obj_transactions = (List<Object>)fullMap.get('transactions');
            
            Set<Id> deploySet = new Set<Id>();
            Set<Id> ownerIdSet = new Set<Id>();
            
            for(Object o : obj_transactions){
                Map<String, Object> tmp = (Map<String, Object>)o;
                try{
                    if(tmp.get('deploymentId')!=null && String.isNotBlank((String)tmp.get('deploymentId'))){
                    	deploySet.add((String)tmp.get('deploymentId')); 
                    }
                    if(tmp.get('userId')!=null && String.isNotBlank((String)tmp.get('userId'))){
                    	ownerIdSet.add((String)tmp.get('userId')); 
                    }
                }
                catch(Exception eParse){
                    System.debug('error while parsing transactions: ' + eParse.getMessage());
                }
            }
            Map<Id,Deployment__c> deploymentMap = new Map<Id,Deployment__c>([select Id, Name, OwnerId from Deployment__c where Id in :deploySet limit 10000]);
            
            for(Deployment__c d : deploymentMap.values()){
                ownerIdSet.add(d.OwnerId);
            }
            Map<Id,User> userMap = new Map<Id,User>([select Id, Name from User where Id IN:ownerIdSet limit 10000]);
            Map<Id,Deployment_Job__c> jobMap = new Map<Id,Deployment_Job__c>([select Id, Name, Step__r.Name, Step__r.Deployment__c, Destination_Org__r.To_Org_Name__c from Deployment_Job__c where Step__r.Deployment__c in :deploySet limit 20000]);
            
            
            for(Object o : obj_transactions){
                Map<String, Object> tmp = (Map<String, Object>)o;
                copadoTransaction ct = new copadoTransaction();
                try {ct.userName = userMap.get((String)tmp.get('userId')).Name;}catch(Exception ex){ ct.userName = ''; }
                ct.credits = (Integer)tmp.get('credits');
                ct.minutes = (Decimal)tmp.get('minutes');
                if(ct.credits < 0 || ct.minutes <0){
                    if(ct.credits < 0)try {ct.deployment = deploymentMap.get((String)tmp.get('deploymentId')).Name;}catch(Exception ex){ ct.deployment = Label.RECORD_DELETED; }
                    if(ct.credits < 0)try {ct.job = jobMap.get((String)tmp.get('jobId')).Name;}catch(Exception ex){ ct.job = Label.RECORD_DELETED; }
                    if(ct.credits < 0)try {ct.destinationOrg = jobMap.get((String)tmp.get('jobId')).Destination_Org__r.To_Org_Name__c;}catch(Exception ex){ ct.destinationOrg = Label.RECORD_DELETED; }
                    if(ct.credits < 0)try {ct.stepName = jobMap.get((String)tmp.get('jobId')).Step__r.Name;} catch(Exception ex){ ct.stepName = Label.RECORD_DELETED; }
                	ct.ddate = (String)tmp.get('date');
                	String action = tmp.get('stepType')+'';
                    if(action !=null && (action == 'diff' || action == 'backup' || action == 'test'
                        || action == 'fileDiff' || action == 'buildTask')){
                        String descrip = action;
                        if(action == 'diff')descrip = OrgDiff__c.sObjectType.getDescribe().getLabel();
                        if(action == 'test')descrip = Apex_Test_Result__c.sObjectType.getDescribe().getLabel();
                        if(action == 'backup')descrip = Git_Backup__c.sObjectType.getDescribe().getLabel();
                        if(action == 'fileDiff')descrip = Snapshot_Difference__c.sObjectType.getDescribe().getLabel();
                        if(action == 'buildTask')descrip = Build_Task__c.sObjectType.getDescribe().getLabel();
                        ct.deployment = 'Action performed was ' + descrip;
                        ct.job = '';
                        ct.destinationOrg = '';
                        ct.stepName = ''; 
                    }
                    if(ct.minutes <0){
                        ct.deployment = 'Action performed was Selenium Testing';
                        ct.job = '';
                        ct.destinationOrg = '';
                        ct.stepName = ''; 
                    }
                    transactions.add(ct);
                }
                else{
                    copadoOrder co = new copadoOrder();
                    //co.amount =  (Decimal)tmp.get('amount');
					co.credits = ct.credits;
                    co.minutes = ct.minutes;
					co.ddate = (String)tmp.get('date');
                    //co.currencyIsoCode = (String)tmp.get('currency');
					//co.paymentDetails = (String)tmp.get('description');
					
					orders.add(co);
                }
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ''+e.getMessage()));
        }
        return null;
    }
    public void syncFeatures(){
        DeployAPI.syncFeaturesNow();
        features = Feature__c.getall().values();
    }
    public void createAPIKey(){
        try{
            DeployAPI.createAPIKey();    
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ''+e.getMessage()));
        }
        
    }
    public String getAPIKey(){
        return DeployAPI.getUserAPIKey();
    }
}