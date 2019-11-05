public with sharing class DeploymentWizardExtension{

    public ApexPages.StandardController stdController {get; set;}
    public Deployment__c deployment {get;set;}
    //AUTHORIZATION
    public static string userId{get {return Userinfo.getUserId();}}
    public static string orgId{get{return Userinfo.getOrganizationId();}}
    public static string sessionId{get{return Userinfo.getSessionId()!=null?Userinfo.getSessionId():'';}}
    public static string token{get{return DeployAPI.getAuthToken();}}
    
    // METADATA
    public string selectedRetrievables {get;set;}
    public string metadata_url{get;set;}
    public string describe_url{get;set;}
    public string sobjects_url{get;set;}
    public string testquery_url{get;set;}
    public string users_url{get;set;}
    public Boolean fromOrgFiltered;
    
    // STEP TOGGLE 
    public String gotoStep {get;set;}   
    public boolean step_createDeployment {get;set;}
    public boolean step_addStep {get;set;}
    public boolean step_selectDestinationOrgs {get;set;}
    public boolean step_setupSchedule {get;set;}
    
    // STEPS
    public ApexPages.StandardController stepController {get; set;}
    public Step__c step {get; set;}
    public boolean step_Step_edit{get;set;}
    public boolean step_Step_new{get;set;}
    public boolean hasSteps {get;set;}
    public ID selectedStep {get;set;}
    public List<Step__c> steps {get;set;}
    public String stepDescription {get;set;}
    public Integer stepCount {get;set;}
    
    // Destination orgs
    public Destination_Org__c destinationOrg {get; set;}
    public List<Destination_Org__c> destinationOrgs {get;set;}
    public boolean hasDestOrgs {get;set;}
    public boolean step_DestOrg_edit {get;set;}
    public string selectedDestOrg {get;set;}
    
    // Setup schedule
    public boolean showDateField {get;set;}

    public boolean showOtherInformation{get;set;}

    public boolean ui2 {get;set;}
    
    
    public Boolean getfromOrgFiltered(){
        if(this.fromOrgFiltered != null) return this.fromOrgFiltered;

        if(deployment.From_Org__c != null){
            String  types = [SELECT Metadata_Types__c FROM Org__c WHERE ID=:deployment.From_Org__c].Metadata_Types__c;
            this.fromOrgFiltered = String.isNotBlank(types);
        }

        return this.fromOrgFiltered;
    }
    
    public void setUrls(){
        //TODO: move this to external util method in order to use it in other classes 
        String urlParameters = '?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode([select API_URL__c from User where id=:userinfo.getUserId()].API_URL__c,'UTF-8');
        String herokuServer = settings.Server_URL;
        String urlBase = herokuServer + '/json/v1/'; 
        if(deployment.From_Org__c== null)return;
        metadata_url = urlBase + 'metadata/'+EncodingUtil.urlEncode(deployment.From_Org__c,'UTF-8') + urlParameters;
        describe_url = urlBase + 'describe/'+EncodingUtil.urlEncode(deployment.From_Org__c,'UTF-8')+ '/{sobject}'+urlParameters;
        sobjects_url = urlBase + 'listSObjects/'+EncodingUtil.urlEncode(deployment.From_Org__c,'UTF-8')+ urlParameters;
        testquery_url = urlBase + 'test-query/'+EncodingUtil.urlEncode(deployment.From_Org__c,'UTF-8')+urlParameters;
        users_url =  urlBase + 'users/'+EncodingUtil.urlEncode(deployment.From_Org__c,'UTF-8')+urlParameters;
    }
    public DeploymentWizardExtension(ApexPages.StandardController stdController) {
        //this flag is when the request came from the new UI in order to replace back url
        ui2 = false;
        if(ApexPages.currentPage().getParameters().get('_ui')!=null && ApexPages.currentPage().getParameters().get('_ui')=='2'){
            ui2 = true;
        }
        estimationDone = false;
        deployment = (Deployment__c)stdController.getRecord();
        if(deployment==null)deployment=new Deployment__c();
        setUrls();
        
        step = new Step__c();
        stepController = new ApexPages.StandardController(step);
        steps = new List<Step__c>();
        
        destinationOrg = new Destination_Org__c();
        destinationOrgs = new List<Destination_Org__c>();
        
        selectedStep = ApexPages.currentPage().getParameters().get('stepId');
        gotoStep = ApexPages.currentPage().getParameters().get('gotoStep');
        
        step_createDeployment = true;
        step_addStep = false;
        step_selectDestinationOrgs = false;
        step_setupSchedule = false;
        
        if(gotoStep == 'deployNow'){
            boolean validationPassed = true;
            step_createDeployment = false;
            steps = getSteps();
            destinationOrgs = getDestinationOrgs();
            if(steps.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.MISSING_STEPS_MESSAGE));
                validationPassed = false;
            }
            if(destinationOrgs.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.MISSING_DEST_ORGS_MESSAGE));
                validationPassed = false;
            }

            if(validationPassed)goto_setupSchedule();
            else step_createDeployment = true;
        }
        if(String.isNotBlank(selectedStep)){
            step_createDeployment = false;
            goto_addStep();
        }
        showOtherInformation = SObjectType.Deployment__c.FieldSets.CustomFields.getFields().size()>0;
    }
    public PageReference save_deployment(){
        ApexPages.Message msg = null;
        if(!DeployAPI.validateOrg(deployment.From_Org__c)){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error,Label.WRONG_CREDENTIALS));
            return null;
        }
        try{
            Utilities.Secure_DML(deployment, Utilities.DML_Action.UPS, schema.Sobjecttype.Deployment__c);
            setUrls();

            goto_addStep();
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ''+ex));
        }
        return null;
    }
    public List<Step__c> getSteps(){
        steps = new List<Step__c>();
        steps = Utilities.getStepsByDeploymentId(deployment.Id);
        if(steps.size() > 0) hasSteps = true;
        stepCount = steps.size();
        return steps;
    }
    public void newStep(){
        step = new Step__c();
        step_Step_edit = true;
        step.Order__c = steps.size()+1;
        step.Name = 'Step '+step.Order__c;
        selectedStep = null;
        step_Step_new = true;
    }
    public PageReference useStep(){
        ApexPages.Message msg = null;
        step = Utilities.getStepById(selectedStep);
        step_Step_edit = true;
        return null;
    }
     public PageReference deleteStep(){
        Utilities.Secure_DML(Utilities.getStepById(selectedStep), Utilities.DML_Action.DEL, schema.Sobjecttype.Step__c);
        enforceStepsOrder();
        getSteps();
        return null;
    }
    public PageReference updateStepDescription(){
        if(step.Type__c == 'MetaData'){
            stepDescription = Label.STEP_DESCRIPTION_METADATA;
        }
        if(step.Type__c == 'Full Profiles'){
            stepDescription = Label.STEP_DESCRIPTION_FULL_PROFILES;
        }
        if(step.Type__c == 'Users'){
            stepDescription = Label.STEP_DESCRIPTION_USERS;
        }
        if(step.Type__c == 'Translations'){
            stepDescription = Label.STEP_DESCRIPTION_TRANSLATIONS;
        }
        if(step.Type__c == 'Data'){
            stepDescription = Label.STEP_DESCRIPTION_DATA;
        }
        if(step.Type__c == 'Bulk Data'){
            stepDescription = Label.STEP_DESCRIPTION_BULK_DATA;
        }
        if(step.Type__c == null){
            stepDescription = Label.STEP_DESCRIPTION_NONE_SELECTED;
        }
        return null;
    }
    public PageReference deleteDestOrg(){
        Utilities.Secure_DML([select id from Destination_Org__c where id= :selectedDestOrg], Utilities.DML_Action.DEL, schema.Sobjecttype.Destination_Org__c);
        getDestinationOrgs();
        return null;
    }
    @RemoteAction
    public static String remoteAction_SaveMetadata(String id, String s){
        String jsonInput = s;
        
        Attachment[] atts = [Select Id, ParentId, Name, Body from Attachment where ParentId=:id and Name='MetaData' order by LastModifiedDate DESC limit 1];
        if(atts.size()==0){
            Attachment att = new Attachment();
            att.Name = 'MetaData';
            att.ParentId = id;
            att.Body = blob.valueOf(jsonInput );
            Utilities.Secure_DML(att, Utilities.DML_Action.INS, schema.Sobjecttype.Attachment);
        }
        else{
            Attachment att = atts[0];
            att.Body = blob.valueOf(jsonInput );
            Utilities.Secure_DML(att, Utilities.DML_Action.UPD, schema.Sobjecttype.Attachment);
        }
        return ':)';
    }
    
    public List<Destination_Org__c> getDestinationOrgs(){
        destinationOrgs = new List<Destination_Org__c>();
        destinationOrgs = Utilities.getDestinationOrgsByDeploymentId(deployment.Id);
        if(destinationOrgs.size() > 0) hasDestOrgs = true;
        return destinationOrgs;
    }
    public PageReference newDestOrg(){
        destinationOrg = new Destination_Org__c();
        step_destOrg_edit = true;
        return null;
    }
    public PageReference saveDestOrg(){
        ApexPages.Message msg = null;
        if(!DeployAPI.validateOrg(destinationOrg.To_Org__c)){
            Apexpages.addMessage(new apexpages.Message(apexpages.severity.error,Label.WRONG_CREDENTIALS));
            return null;
        }
        try{
            destinationOrg.Deployment__c = deployment.id;
            Utilities.Secure_DML(destinationOrg, Utilities.DML_Action.UPS, schema.Sobjecttype.Destination_Org__c);
            destinationOrg = Utilities.getDestinationOrgsById(destinationOrg.Id);
            destinationOrgs.add(destinationOrg);
            goto_selectDestinationOrgs();
        }
        catch(Exception ex){
            msg = new ApexPages.Message(ApexPages.Severity.ERROR, ''+ex);
            ApexPages.addMessage(msg);
        }
        return null;
    }
    public PageReference goto_createDeployment (){
        step_createDeployment = true;
        step_addStep = false;
        step_selectDestinationOrgs = false;
        step_setupSchedule = false;
        return null;
    }
    public PageReference goto_addStep(){
        steps = getSteps();
        step_createDeployment = false;
        step_addStep = true;
        step_selectDestinationOrgs = false;
        step_setupSchedule = false;
        step_Step_edit = false;
        return null;
    }
    
    public PageReference enforceStepsOrder(){
        //enforce strict steps order
        getSteps();
        Integer i = 1; 
        for(Step__c st:steps){
            st.Order__c = i;
            i++;
        }
        Utilities.Secure_DML(steps, Utilities.DML_Action.UPD, schema.Sobjecttype.Step__c);
        return null;
    }
    
    public PageReference goto_selectDestinationOrgs(){
        
        enforceStepsOrder();
        //prepare destination orgs
        destinationOrgs = getDestinationOrgs();
        step_createDeployment = false;
        step_addStep = false;
        step_selectDestinationOrgs = true;
        step_setupSchedule = false;
        step_destOrg_edit = false;
        return null;
    }
    public List<SelectOption> getScheduleOptions() {
        List<SelectOption> options = new List<SelectOption>();
       Schema.DescribeFieldResult fieldResult = Deployment__c.Schedule__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple) {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    public PageReference goto_setupSchedule (){
        step_createDeployment = false;
        step_addStep = false;
        step_selectDestinationOrgs = false;
        step_setupSchedule = true;
        showDateField = false;
        return null;
    }
    public PageReference scheduleShowDate(){
        showDateField = false;
        if(deployment.Schedule__c == 'Deploy later'){
            Org__c customerOrg = DeployAPI.getCustomerOrg();
            if(customerOrg==null){
                deployment.Schedule__c ='';
                deployment.Schedule__c.addError(Label.CUSTOMER_ORG_NOT_EXISTS);
                return null;
            }
            if(!DeployAPI.validateOrg(customerOrg.Id)){
                deployment.Schedule__c ='';
                deployment.Schedule__c.addError(Label.CUSTOMER_ORG_NOT_VALIDATED);
                return null;
            }
            showDateField = true;
        }
        return null;
    }
    public PageReference confirmAll(){
        return confirm(true);
    }
    public PageReference confirmOutstanding(){
        return confirm(false);
    }
    public PageReference confirm(Boolean allJobs){
        Integer creds = DeployAPI.getCredits();
        if((deployment.Date__c == null || deployment.Date__c < System.now()) && deployment.Schedule__c == 'Deploy later'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DEPLOYLATER_DT_MUST_BE_FUTURE));
            return null;
        }
        if(!estimationDone){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.ESTIMATION_IN_PROGRESS));
            return null;
        }
        if(totalEstimations>creds && DeployAPI.orgMap.get('autoRecharge')=='false'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.NOT_ENOUGH_CREDITS));
            return null;
        }
        deployment.Deployment_Completed_email_sent__c = false;
        deployment.Status__c = 'Scheduled';
        if(deployment.Schedule__c == 'Deploy now'){
            deployment.Date__c = System.now();
        }
        //a time based workflow will perform the deployment when the time comes.
        Utilities.Secure_DML(deployment, Utilities.DML_Action.UPD, schema.Sobjecttype.Deployment__c);
        Utilities.resetStatuses(deployment.Id,allJobs);
        Integer pendingJobs = [select count() from Deployment_Job__c where Step__r.Deployment__c = :deployment.Id and Status__c = 'Pending'];
        if(pendingJobs==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Nothing to deploy. Try "Deploy All" button'));
            return null;
        }
        if(deployment.Schedule__c == 'Deploy now'){
            DeployAPI.Deploy(deployment.Id, UserInfo.getSessionId());
        }
        else {
            //deprecated - not necessary anymore with oauth
           // DeployAPI.saveDeploy(deployment.Id, UserInfo.getSessionId());
        }
        return new PageReference('/apex/Deployment?id='+deployment.Id);
    }
    public class Estimation{
        public Step__c step{get;set;}
        public String stepId{get;set;}
        public Integer credits{get;set;}
        public String Status{get;set;}
        public Integer outstandingCredits{get;set;}
    }
    public List<Estimation> estimations;
    public Integer subTotalEstimations{get;set;}
    public Integer totalEstimations{get;set;}
    public Integer orgCount{get;set;}
    public boolean estimationDone{get;set;}
    public Integer subTotalOutstandingEstimations{get;set;}
    public Integer totalOutstandingEstimations{get;set;}
    
    public List<Estimation> getEstimations(){
        // Check if estimations have been previously calculated
        if(estimationDone && estimations.size() == getSteps().size())return estimations;
        estimations = new List<Estimation>();
        if(getSteps().size()==0 || !step_setupSchedule){
            estimationDone = false;
            return estimations;
        }
        estimationDone = true;
        orgCount = destinationOrgs.size();
        totalEstimations = 0;
        totalOutstandingEstimations = 0;
        
        Map<String,Object> mapa = estimateDeploy(deployment.id);
        Map<Id,Integer> outstandings = new Map<Id,Integer>();
        for(Deployment_Job__c dj:[select Id, Status__c, Step__c from Deployment_Job__c where Step__c in:mapa.keyset() limit 10000]){
            if(outstandings.get(dj.Step__c)==null)outstandings.put(dj.Step__c, 0);
            if(dj.Status__c != 'Success'){
                outstandings.put(dj.Step__c, outstandings.get(dj.Step__c) +1);
            }
        }
        for(Step__c st:[select id,name,checkonly__c from Step__c where id in:mapa.keyset() order by order__c]){
            Estimation e = new Estimation();
            e.step = st;
            e.stepId = st.id;
            try{
                e.credits = Integer.valueOf((String)mapa.get(st.id))* orgCount;
                e.outstandingCredits = Integer.valueOf((String)mapa.get(st.id)) * outstandings.get(st.id);
                totalEstimations += e.credits;
                totalOutstandingEstimations += e.outstandingCredits;
                e.Status ='Estimation Done';
            }
            catch(Exception ex){
                e.status =(String)mapa.get(st.id);
                estimationDone = false;
            }
            estimations.add(e);
        }
        return estimations;
    }
    private class UserAttachment {
        public List<String> userIds;
        public String fromSuffix;
        public String toSuffix;
        public Boolean active;
        public Boolean userTerritories;
        
        public UserAttachment parse(String json) {
			return (UserAttachment) System.JSON.deserialize(json, UserAttachment.class);
		}
    }
    public Map<String, Object> estimateDeploy(String deploymentId) {
        Map<String, Object> eMap = new Map<String, Object>();
        List<String> mStepsIds = new List<String>();
        Set<String> gitStepsIds = new Set<String>();
        for(Step__c step:[SELECT Type__c FROM Step__c WHERE Deployment__c=:deploymentId]) {
            eMap.put(step.Id, '1');
            if(step.Type__c == 'MetaData' || step.Type__c == 'Full Profiles' || step.Type__c == 'Full Permission Sets' || step.Type__c == 'Users' || step.Type__c == 'Translations' || step.Type__c == 'Delete MetaData' || step.Type__c == 'Custom Settings' || step.Type__c == 'Git MetaData'){
                if(step.Type__c == 'Git MetaData') { gitStepsIds.add(step.Id); }
                // The credits are based on the number of items in the step's attachment
                mStepsIds.add(step.id);
            } else if(step.Type__c == 'Manual Task' || step.Type__c == 'Git Promotion'){ eMap.put(step.Id, '0'); } else { 
            	// 1 credit per execution of all other step types (Data, Bulk Data, Apex, URL Callout and any other)
                eMap.put(step.Id, '1');
            }
        }
        List<String> atts = new List<String>{'MetaData','Full Profiles','Full Permission Sets','Translations','Users','Custom Settings'};
        try {
            for(Attachment att:[SELECT Name, ParentId, Body FROM Attachment WHERE ParentId IN :mStepsIds AND Name IN :atts]){
                String b = EncodingUtil.base64Decode(EncodingUtil.base64Encode(att.Body)).toString();
                // Attachments of 'Users' and 'Custom Settings' have irregular json structures
                if(att.Name == 'Users'){
                    Matcher m = Pattern.compile('\\[\\s*\\s*(.+?)\\s*\\]').matcher(b);
                    if (m.find()) {
                        String users = m.group();
                        List<String> uIds = (List<String>)System.JSON.deserialize(users, List<String>.class);
                        eMap.put(att.ParentId, String.valueOf(uIds.size()));
                    } else { eMap.put(att.ParentId, String.valueOf('1')); }
                } else if(att.Name == 'Custom Settings') {
                    Matcher m = Pattern.compile('\"(prevRes).*?\":\\[.*?\\]').matcher(b);
                    if (m.find()) {
                        String settings = m.group().removeStart('"prevRes":');
                        List<Object> rItems = (List<Object>)JSON.deserializeUntyped(settings);
                        eMap.put(att.ParentId, String.valueOf(rItems.size()));
                    } else { eMap.put(att.ParentId, String.valueOf('1')); }
                } else {
                    // All other attachments have regular json structures
                    List<Object> mItems = (List<Object>)JSON.deserializeUntyped(b);
                    if(att.Name == 'Translations' || att.Name == 'Full Profiles' || att.Name == 'Full Permission Sets'){
                        // 5 credits per translation, full profile and full permission set
                        eMap.put(att.ParentId, String.valueOf(mItems.size()*5)); 
                    } else if(gitStepsIds.contains(att.ParentId) && mItems.size() > 50) { 
                        // 50 max credits for 'Git MetaData'
                        eMap.put(att.ParentId, String.valueOf(50)); 
                    } else if(mItems.size() > 0) { 
                        // 1 credit per metadata item
                        eMap.put(att.ParentId, String.valueOf(mItems.size())); 
                    } else { eMap.put(att.ParentId, '1');  }
                } 
            }
        } catch (Exception e) {
            System.debug(e);
        }
        return eMap;
    }
    public PageReference refreshEstimations(){
        getEstimations();
        return null;
    }
    public void moveUp(){
        try{
            Step__c lowerStep = new Step__c();
            Step__c upperStep = new Step__c();
            Map<Decimal,Step__c> stepMap = new Map<Decimal,Step__c>();
            for(Step__c a : steps){
                stepMap.put(a.Order__c, a);
                if(a.Id == selectedStep)lowerStep=a;
            }
            upperStep = stepMap.get(lowerStep.Order__c-1);
            lowerStep.Order__c = lowerStep.Order__c - 1;
            upperStep.Order__c = upperStep.Order__c + 1;
            update steps;
            getSteps();
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getStackTraceString()));
        }
    }
    public void moveDown(){
        try{
            Step__c lowerStep = new Step__c();
            Step__c upperStep = new Step__c();
            Map<Decimal,Step__c> stepMap = new Map<Decimal,Step__c>();
            for(Step__c a : steps){
                stepMap.put(a.Order__c, a);
                if(a.Id == selectedStep)upperStep=a;
            }
            lowerStep = stepMap.get(upperStep.Order__c+1);
            lowerStep.Order__c = lowerStep.Order__c - 1;
            upperStep.Order__c = upperStep.Order__c + 1;
            update steps;
            getSteps();
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getStackTraceString()));
        }
    }
    public List<SelectOption> getStepTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption('MetaData','MetaData'));
        options.add(new SelectOption('Full Profiles','Full Profiles'));
        options.add(new SelectOption('Full Permission Sets','Full Permission Sets'));
        options.add(new SelectOption('Users','Users'));
        options.add(new SelectOption('Translations','Translations'));
        options.add(new SelectOption('Data','Data'));
        options.add(new SelectOption('Bulk Data','Bulk Data'));
        options.add(new SelectOption('Delete MetaData','Delete MetaData'));
        return options;
    }
}