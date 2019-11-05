global with sharing class DeploymentExt {
public JsRemotingController remotingController{get;set;}
    /**
     * final configuration page
     */
    
    public static final String[] DEPLOYMENT_FIELDS = new String[] {'Name','Flag_Status__c','Date__c','From_Org__c','Id','Completed__c','Status__c','Schedule__c' ,'LastModifiedBy','LastModifiedDate','Deployment_command_sent__c'};

    /**
     * This public instance of deployment obj is the bridge for the standard controller obj
     */
	public Deployment__c dep {get; set;}


    public String errorLevel {get; set;}
    public String messageName {get; set;}

    public List<Map<String,String>> messagesQueue =  new List<Map<String,String>>();
    public String jsonMessagesQueue { set;}

    /*flag for custom fieldset*/
    public boolean showOtherInformation{get;set;}

    /*helper to remove destination org*/
    public String selectedToOrg {get;set;}
    /*helper to select an step*/
    public String selectedStepId {get;set;}
    public String selectStepOrg {get;set;}
    public String selectStepAction {get;set;}


    public Boolean isNew {get;set;}
    public Boolean fromValid {get;set;}
    
    public Boolean historyVisible = false;

    /* helper parameter */
    public String destinationId {get;set;}


    /**
     * helpers to serialize apex data into json
     */
    public String depJson;
    public String destinationsJson;
    public String stepsJson;

    /**
     * TODO 
     */
    public Destination_Org__c[] destinations{get;set;}
    public Set<String> destinationOrgSet;

    /**
     * TODO 
     */
    public Step__c[] steps {get;set;}

    

    /* shortcut to last added step*/
    //public Step__c lastStep {get;set;}

    /**
     * TODO 
     */
    //public Step__c selectedStep {get;set;}

    public Org__c fromOrg {get;set;}

    /**
     * this flag shows ir from org has metadata filters activated.
     * this flag is useful in stepGrid component. 
     */
    public Boolean orgFiltered {get;set;}


    /**
     * url's helpers to heroku api calls
     */
    public String metadata_url{get;set;}
    public String describe_url{get;set;}
    public String sobjects_url{get;set;}
    public String testquery_url{get;set;}
    public String users_url{get;set;}
    public String cancel_url{get;set;}
    public String custom_settings_url{get;set;}
    public String git_metadata_url{get;set;}
    public String quick_actions_url{get;set;}

    public String urlParameters{get;set;}
    public String herokuServer{get;set;}
    public boolean isShareable{get;set;}

    public String getDestinationsJson(){
        return JSON.serialize(this.destinations);
    }

    public String getStepsJson(){
        return JSON.serialize(this.steps);
    }

    public String getDepJson(){
        return JSON.serialize(this.dep);
    }

    public String getjsonMessagesQueue(){
        return JSON.serialize(this.messagesQueue);
    }

    /**
     * This method get a list of step IDs and save them setting the recived order.
     * @param ids String[] in order to be set
     */
    @RemoteAction
    global static void sortSteps(String[] ids) {

        Step__c[] toUpdate =  new Step__c[]{};
        Integer i = 1;
        for(String k :ids){
            toUpdate.add(new Step__c(Id=k, Order__c=i));
            i++;
        }
        Utilities.Secure_DML(toUpdate, Utilities.DML_Action.UPS, schema.SObjectType.Step__c);
    }

    /**
     * Override the standard save action to validate from org credentials. 
     */
    public PageReference saveDeployment(){

        if(String.isNotBlank(dep.From_Org__c) && !DeployAPI.validateOrg(dep.From_Org__c)){
            addMsgError(Label.WRONG_CREDENTIALS);
            return null;
        }
        try{
            boolean isCreate = dep.Id==null;
            Utilities.Secure_DML(dep, Utilities.DML_Action.UPS, schema.SObjectType.Deployment__c);
            setUrls();
            isNew = false;
            addMsgOK('Deployment Saved');
            if(isCreate)return new PageReference('/'+dep.Id);
        }
        catch(Exception ex){
            addMsgError(ex.getMessage());
        }
        return null;
    }


    /**
     * constructor method. 
     */
    public DeploymentExt(ApexPages.StandardController sc) {

        if (!Test.isRunningTest()) { 
            sc.addFields(DEPLOYMENT_FIELDS);
        }

        reset();

        this.dep = (Deployment__c)sc.getRecord();
        
        //instance for new 
        if(this.dep.Id == null){
            //this.dep = new Deployment__c();
            isNew = true;

        }else{
            isNew = false;

            //get previous fromOtrg
            if(dep.From_Org__c != null){
                fromOrg = Utilities.getOrgById(dep.From_Org__c);
                orgFiltered = String.isNotBlank(fromOrg.Metadata_Types__c);
                checkAndValidateFromOrg();
            }
        }

        setUrls();

        initDestination();
        initSteps();


        showOtherInformation = SObjectType.Deployment__c.FieldSets.CustomFields.getFields().size()>0;
        Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
		isShareable = tokens.containsKey('Deployment__Share');

    }

    /**
     * Validate the fromOrg
     */
    public Boolean checkAndValidateFromOrg(){
        
        if(fromOrg.Validated_Status__c != 'OK'){
            //TODO add more logic like checkbox
            Boolean res = DeployAPI.validateOrg(fromOrg.Id);
            //refresh from api credentials. 
            fromOrg = Utilities.getOrgById(dep.From_Org__c);
            orgFiltered = String.isNotBlank(fromOrg.Metadata_Types__c);
            if(!res){
                addMsgError(Label.ORG_NOT_VALIDATED);
            }
            fromValid = res;
        }else{
            fromValid = true;
        }
        return fromValid;
    }

    /**
     * get org detail and Validate connection status
     */
    public PageReference validateFromOrg(){
        PageReference ref = null;
        system.debug('selected '+dep.From_Org__c);
        if(dep.From_Org__c==null){
            fromOrg = null;
            return ref;
        }
        
        fromOrg = Utilities.getOrgById(dep.From_Org__c);

        if(checkAndValidateFromOrg()){
            ref = saveDeployment();
            setUrls();
        }
		return ref;
    }

    /**
     *  fill destinations list and create a default destination if is empty
     */
    public void initDestination(){

        destinationOrgSet = new Set<String>();

        if(isNew){
            destinations = new Destination_Org__c[]{};
        }else{
            destinations = CopadoAPI.getDestinationsOrg(this.dep.Id);

            //pre-fill set helper in order to validate faster duplicates
            
            for(Destination_Org__c d:destinations){
                destinationOrgSet.add(d.To_Org__c);
            }
        }
        
        if(destinations.isEmpty()){
            addDestination();
        }
    }

    /**
     * get from the API the list of step for this deployment.
     */
    public void initSteps(){

        //get initial steps
        //then they will be manage in the frontend 
        if(isNew){
            steps = new Step__c[]{};
        }else{
            steps =CopadoAPI.listSteps(this.dep.Id);
        }
        
    }

    /**
     * Set Heroku urls to call API from javascript
     */
    public void setUrls(){
        cancel_url = getCancelURL();

        //TODO: move this to external util method in order to use it in other classes 
        urlParameters = '?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode([select API_URL__c from User where id=:userinfo.getUserId()].API_URL__c,'UTF-8');
        herokuServer = settings.Server_URL;
        String urlBase = herokuServer + '/json/v1/'; 

        git_metadata_url = urlBase + 'gitmetadata/{repositoryId}/{branch}/{commitId}'+urlParameters;

        if(dep.From_Org__c== null)return;
        
        if(String.isNotBlank(fromOrg.Metadata_Types__c)){
            urlParameters += '&filter='+EncodingUtil.urlEncode(fromOrg.Metadata_Types__c,'UTF-8');
        }
        String fromOrgEncoded = EncodingUtil.urlEncode(dep.From_Org__c,'UTF-8');
        metadata_url = urlBase + 'metadata/'+fromOrgEncoded + urlParameters + '&dates=format';
        describe_url = urlBase + 'describe/'+ fromOrgEncoded+ '/{sobject}'+urlParameters;
        sobjects_url = urlBase + 'listSObjects/'+fromOrgEncoded+ urlParameters;
        testquery_url = urlBase + 'test-query/'+fromOrgEncoded+urlParameters;
        users_url =  urlBase + 'users/'+fromOrgEncoded+urlParameters;

        custom_settings_url =  urlBase + 'customSetting/'+fromOrgEncoded+'/{sobject}'+urlParameters;

        quick_actions_url =  urlBase + 'quickActions/'+fromOrgEncoded+'/{sobject}'+urlParameters;
                
        
    }

    /**
     * Save list of destinations
     */
    public void saveDestination(){

        for(Destination_Org__c d: destinations){
            //find the new one
            if(String.isBlank(d.Id)){

                if(String.isBlank(d.To_Org__c)){
                    addMsgError(Label.ORG_NOT_VALIDATED);
                    return ;
                }

                //validation removed by Fede request
                /*if(d.To_Org__c == dep.From_Org__c){
                    addMsgError('Destination Org can not be the same than From Org.');
                    return ;
                }*/

                if(destinationOrgSet.contains(d.To_Org__c)){
                    addMsgError(Label.DESTINATION_ORG_ALREADY_SELECTED);
                    return ;
                }

                //validate conection
                Org__c org = Utilities.getOrgById(d.To_Org__c);

                if(org.Validated_Status__c != 'OK'){
                    if(!DeployAPI.validateOrg(org.Id)){
                        addMsgError(Label.DESTINATION_ORG_NOT_VALIDATED);
                        return ;
                    }
                    
                }
                // if was ok or validation is Ok then save and refresh
                CopadoAPI.addDestinationOrg(this.dep.Id, d.To_Org__c );
                
                // refresh from API
                initDestination();  
                addMsgOk(Label.DESTINATION_ORG_SAVED);
                
                break;
            }
        }
              
    }

    /**
     * error message in frontend helper
     */
    public void addMsgError(String msg){
        addMsg('ERROR', msg);
    }

    /**
     * generic message in frontend helper
     */
    public void addMsg(String type ,String msg){

        //we are using this map in order to save messages from apex
        //and then render them as a json object in order to be used by the JSApp
        Map<String, String> m = new Map<String, String>();
        m.put('s',type);
        m.put('m',msg);

        messagesQueue.add(m);
        //Apexpages.addMessage(new Apexpages.Message(type, msg));
    }

    /**
     * success message in frontend helper
     */
    public void addMsgOk(String msg){
        addMsg('CONFIRM', msg);
    }


    /**
     * delete destination org and refresh local list
     */
    public PageReference deleteDestOrg(){
        
        CopadoAPI.removeDestinationOrg(this.dep.Id, selectedToOrg);
        
        initDestination();

        return null;
    }

    /**
     * remote action to remove an step
     */
    @RemoteAction
    global static void deleteStep(String stepId){

        //String stepId = DeploymentExt.getParam('stepId');
        
        if(String.isNotBlank(stepId)){
            CopadoApi.removeStep(stepId);

        }

    }

    /**
     * helper to get http param
     * for remote actions
     */
    public static String getParam(String p){
        return Apexpages.currentPage().getParameters().get(p);
    }

    
    /**
     * Add empty Step
     */
    public void addDestination(){
        //add new local
        destinations.add(new Destination_Org__c(Deployment__c = this.dep.Id));
    }

    /**
     * reset page status
     */
    public void reset(){
        fromValid = false;
    }

    
    /**
     * TODO
     * by now it is working on redirection only
     */
    public void deploy(){

    }

    /**
     * TODO
     */
    public PageReference fullCloneRedirect(){
        return null;
    }

    /**
     * TODO
     */
    public void sharing(){

    }

    /**
     * helper to get return url to deployment list tab
     */
    public String getCancelURL(){

        Schema.DescribeSObjectResult result = Deployment__c.SObjectType.getDescribe();
        return '/' + result.getKeyPrefix();

    }
    public Boolean getHistoryVisible(){
        return Schema.sObjectType.Deployment_History__c.fields.Deployment__c.isAccessible();
    }
}