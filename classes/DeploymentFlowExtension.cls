public class DeploymentFlowExtension {
    public Deployment_Flow__c obj {get;set;}
    public Environment__c finalDestination {get;set;}
    public List<Deployment_Flow_Step__c> steps {get;set;}
    public class GraphNone {
    	Id uid;
        String srcBranch;
        Id srcEnvId;
        Id nextEnvId;
        GraphNone nextEnv; // can be null, only for the last node;
    }
    public Map<Id,GraphNone> envNodes {get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public DeploymentFlowExtension(ApexPages.StandardController stdController) {
        steps = new List<Deployment_Flow_Step__c>();
        envNodes = new Map<Id,GraphNone>();
        this.obj = (Deployment_Flow__c)stdController.getRecord();
        if(this.obj!=null && this.obj.Id!=null) {
            this.obj = [SELECT Active__c,Branch_Management_Coordinates__c,Flow_Step_Coordinates__c,Git_Repository__c,Id,Main_Branch__c,Manage_Branches__c,Name,
                    (SELECT Id,Name,Test_Level__c,Automatically_Merge_and_Deploy__c,Deployment_Flow__c,
                     Source_Environment__c, Source_Environment__r.Name, Branch__c,
                     Destination_Environment__c, Destination_Environment__r.Name
                     FROM Deployment_Flow_Steps__r ORDER BY Destination_Environment__r.Name, Source_Environment__r.Name)
                FROM Deployment_Flow__c WHERE Id = :this.obj.Id ];
        }
        System.debug('obj='+obj);
        System.debug('# of steps '+obj.Deployment_Flow_Steps__r.size());
        steps.addAll(obj.Deployment_Flow_Steps__r);

       	// prepare the last step, a virtual step, since no "connection" record exists.
        Deployment_Flow_Step__c lastStep = new Deployment_Flow_Step__c();
        lastStep.Id = null;
        lastStep.Branch__c = obj.Main_Branch__c;
        for(Deployment_Flow_Step__c s : obj.Deployment_Flow_Steps__r) {
            GraphNone g = new GraphNone();
            g.uid = s.Id;
            g.srcEnvId = s.Source_Environment__c;
            g.srcBranch = s.Branch__c;
            g.nextEnvId = s.Destination_Environment__c;
            envNodes.put(s.Source_Environment__c, g);
            
            if(s.Branch__c == obj.Main_Branch__c) {
            	lastStep.Destination_Environment__r = s.Source_Environment__r;
                System.debug('heyy '+lastStep);
            }
        }
        steps.add(lastStep);
        
        for(GraphNone g : envNodes.values()) {
            if(envNodes.containsKey(g.nextEnvId)) {
                g.nextEnv = envNodes.get(g.nextEnvId);
            }else{
                // last node.
            }
        }
    }

    public String getJsonNodes() {
        return JSON.serializePretty(envNodes);
    }

    public String getJsonDeploymentFlow() {
        return JSON.serializePretty(obj);
    }
    public String getJsonGitStatusMap() {
        // Retrieve all the attachments of the deployment flow and its steps.
		List<Id> allParentIds = new List<Id>(new Map<Id, SObject>(obj.Deployment_Flow_Steps__r).keySet());
        allParentIds.add(obj.Id);
        System.debug('allParentIds='+allParentIds);
        Map<Id,Object> GitStatusMap = new Map<Id,Object>();
        List<Attachment> atts = [SELECT ParentId, Body FROM Attachment WHERE ParentId in :allParentIds AND Name='result.json'];
        for(Attachment a : atts)
            GitStatusMap.put(a.ParentId, JSON.deserializeUntyped(a.Body.toString()));
        return JSON.serializePretty(GitStatusMap);
    }
}