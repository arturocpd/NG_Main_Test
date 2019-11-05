public with sharing class SeleniumTestQuickRun {
    public static String copadoURL = Settings.Server_URL;

    public Selenium_Test_Run__c run {get; set;}
    public Selenium_Test_Suite__c suite {get; set;}
    public Selenium_Settings__c settings {get; set;}

    public String returnUrl {get; set;}
    public String mode {get; set;}
    public Integer count_cases {get; set;}

    private String runId;
    private String suiteId;
    private String caseId;
    public String userAlias;
    private Boolean noDML;

    public SeleniumTestQuickRun() {
        returnUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String c = ApexPages.currentPage().getParameters().get('mode');
        mode = c==null?'':c;

        runId = ApexPages.currentPage().getParameters().get('runId');
        suiteId = ApexPages.currentPage().getParameters().get('suiteId');
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        userAlias = [select Alias from User where Id =:UserInfo.getUserId()].Alias;

        System.debug('constructor() runId='+runId+' suiteId='+suiteId+' caseId='+caseId);

        run = new Selenium_Test_Run__c();
        suite = new Selenium_Test_Suite__c();
        settings = new Selenium_Settings__c();

    }

    public PageReference quickRunConfirmed() {
        mode = 'continue';
        return quickRun();
    }

    public PageReference save() {
        Selenium_Settings__c s = new Selenium_Settings__c(Name=userAlias+' Quick Test Settings');
        s.Webdriver_URL__c = settings.Webdriver_URL__c;
        s.Default_Org_Credential__c = settings.Default_Org_Credential__c;
        insert s;
        return quickRun();
    }

    public PageReference cancel() {
        return new PageReference('/'+(runId!=null?runId:(suiteId!=null?suiteId:(caseId!=null?caseId:''))));
    }

    /*
    * Find or create suite and/or run
    */
    private void findOrCreateRecords() {
        Selenium_Test_Case__c c = null;
        String runName;
        if(caseId!=null) {
            c = [select Name from Selenium_Test_Case__c where Id = :caseId];
            runName = userAlias+' Quick Run '+c.Name;
            for(Selenium_Test_Suite__c s : [SELECT Id, Name FROM Selenium_Test_Suite__c WHERE Name = :runName ORDER BY CreatedDate DESC LIMIT 1]) {
                suite = s;
                break;
            }
            if(suite.Id==null) {
                suite = new Selenium_Test_Suite__c(Name=runName.abbreviate(80));
                insert suite;
                Selenium_Test_Case_Per_Suite__c cs = new Selenium_Test_Case_Per_Suite__c(Selenium_Test_Suite__c=suite.Id, Selenium_Test_Case__c=c.Id);
                insert cs;
                noDML = false;
                System.debug('Created Suite '+suite.Name);
            }
        }else if(suiteId!=null) {
            suite = [select Id, Name from Selenium_Test_Suite__c where Id = :suiteId];
            runName = suite.Name.startsWith(userAlias+' Quick Run ')? suite.Name : userAlias+' Quick Run '+suite.Name;
        }
        System.debug('findOrCreateRecords() suite='+suite+' noDML='+noDML+'runName='+runName);

        for(Selenium_Test_Run__c r : [SELECT Id, Name
            FROM Selenium_Test_Run__c WHERE Name = :runName AND Selenium_Test_Suite__c = :suite.Id
            ORDER BY CreatedDate DESC LIMIT 1]) {
                run = r;
                break;
        }

        if(run.Id==null) {
            run = new Selenium_Test_Run__c(
                Name=runName.abbreviate(80),
                Selenium_Settings__c=settings.Id,
                Selenium_Test_Suite__c=suite.Id,
                Org_Credential__c=settings.Default_Org_Credential__c
                );
            insert run;
            noDML = false;
            System.debug('Created Run '+run.Name);
        }
        runId = run.Id;
        System.debug('findOrCreateRecords() run='+run+' noDML='+noDML);
    }

    public PageReference quickRun() {
        System.debug('quickRun() runId='+runId+' suiteId='+suiteId+' caseId='+caseId);
        noDML = true;

        if(runId==null) {
            String name = userAlias+' Quick Test Settings';
            System.debug('settings name='+name);
            for( Selenium_Settings__c s : [SELECT Id, Name, Selected_Platforms__c, Webdriver_URL__c, Default_Org_Credential__c, Provider__c FROM Selenium_Settings__c WHERE Name = :name ORDER BY CreatedDate DESC LIMIT 1] ) {
                settings = s;
                break;
            }
            if(settings.Id==null) {
                mode = 'create';
                System.debug('settings not found. Creating');
                return null;
            }

            findOrCreateRecords();
        }

        // now we always have a run and runId
        for( Selenium_Test_Run__c r : [SELECT Id, Name, Last_Status__c,
            Org_Credential__r.Id, Org_Credential__r.Name,
            Selenium_Test_Suite__r.Id, Selenium_Test_Suite__r.Name,
            Selenium_Settings__r.Id, Selenium_Settings__r.Name,
            Selenium_Settings__r.Webdriver_URL__c,
            Selenium_Settings__r.Provider__c,
            Selenium_Settings__r.Selected_Platforms__c ,
			Selenium_Settings__r.Default_Org_Credential__c
            FROM Selenium_Test_Run__c WHERE Id = :runId LIMIT 1]) {
                run  = r;
                suite = run.Selenium_Test_Suite__r;
                settings = run.Selenium_Settings__r;
                break;
        }

        String laststatus = run.Last_Status__c==null?'completed':run.Last_Status__c;

        System.debug('quickRun() runId='+runId+' run='+run);
        System.debug('quickRun() settings='+settings);
        System.debug('quickRun() suite='+suite);
        System.debug('quickRun() noDML='+noDML);

        count_cases =  0;

        if(suite!=null && suite.Id!=null) {
            count_cases = [SELECT count() FROM Selenium_Test_Case_Per_Suite__c WHERE Selenium_Test_Suite__c = :suite.Id];
        }

        if(!(laststatus.containsIgnoreCase('failure') || laststatus.containsIgnoreCase('completed')) && mode!='continue') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.This_test_is_already_running));
            PageReference pr = ApexPages.currentPage();
            mode = 'confirm';
            System.debug('status running. Request confirm');
            return null;
        }

        if( count_cases==0 || settings==null || settings.Selected_Platforms__c=='' || suite==null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Some of the values for the test run/suite/settings are missing'));
            PageReference pr = ApexPages.currentPage();
            mode = 'cancel';
            System.debug('wrong params, cancelling');
            return null;
        }

        if(noDML){
            // no changes to the DB. Execute the Test Run
            if(!Test.isRunningTest()) {
                try{
                    if(String.isBlank(settings.Provider__c) || String.isBlank(settings.Selected_Platforms__c) ){
                        // and now redirect to Settings page to select the provider and a browser
                        PageReference pr = new PageReference('/'+settings.Id+'/e');
                        pr.setRedirect(true);
                        return pr;
                    }
                    
                    WebhookAPI.runSeleniumTest(run.Id, DeployAPI.getUserAPIKey());
                    
                    Selenium_Test_Run__c r = [Select Id FROM Selenium_Test_Run__c WHERE Id = : run.Id];
					r.Last_Status__c = 'Queued';
                    update r;
                }
                catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                    return null;
                }
            }else{
                System.debug('Skipping WebhookAPI.runSeleniumTest(run.Id, xxxx;');
            }
            // and now redirect to the Test results.
            PageReference pr = new PageReference('/'+run.Id);
            pr.setRedirect(true);
            return pr;
        }else{
            // Quick Settings/Suite/Run were created, redirect to this very page.
            PageReference pr = ApexPages.currentPage();
            pr.getParameters().put('runId', run.Id);
            pr.setRedirect(true);
            return pr;
        }

        return null;
    }
}