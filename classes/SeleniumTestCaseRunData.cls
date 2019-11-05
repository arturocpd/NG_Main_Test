@RestResource(urlMapping='/SeleniumTestCaseRunData')
global with sharing class SeleniumTestCaseRunData {

    global class RunVar {
        public RunVar(String n, String v) { Name=n; Value=v; }
        public String Name;
        public String Value;
    }
    
    global class RunTestCaseAndData {
        public RunTestCaseAndData(Id i, String s, String d, String dn) { id=i; src=s; data=d; dataName=dn; }
        public Id id;
        public String src;
        public String data;
        public String dataName;
    }
    
    global class RunMain {
        public Id Run_Id;
        public String Run_Name;
        public String Run_Base_URL;
        public integer Run_Batch_No;
        public String Run_Namespace;
        public String Run_Org_Credential;
        public String Settings_Name;
        public String Settings_Provider;
        public String Settings_Selected_Platforms;
        public boolean Settings_Webdriver_Proxy;
        public String Settings_Webdriver_URL;
        public String Suite_Apex_code_after_test;
        public String Suite_Apex_code_before_test;
        public String Suite_Id;
        public List<RunVar> global_vars;
        public String login_url;
        public List<RunTestCaseAndData> testcases;
        public String run_unique_id;
    }
    
    @HttpGet
 	global static RunMain testCaseLoadAll() {
        RestResponse res = RestContext.response;
        res.addHeader('Access-Control-Allow-Origin', '*');
        res.addHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,PATCH,DELETE');
        res.addHeader('Access-Control-Allow-Headers', 'Content-Type,Authorization');
		res.addHeader('Content-Type', 'application/json');

        String testRunId = RestContext.request.params.get('id');
        RunMain rm = new RunMain();
        
        Selenium_Test_Run__c r = [SELECT
            Id,
            Name,
            Batch_No__c,
            Org_Credential__c,
            Org_Credential__r.Environment__r.Namespace__c,
            Org_Credential__r.Environment__r.Id,
            Base_URL__c,
            Selenium_Settings__r.Name,
            Selenium_Settings__r.Selected_Platforms__c,
            Selenium_Settings__r.Provider__c,
            Selenium_Settings__r.Webdriver_Proxy__c,
            Selenium_Settings__r.Webdriver_URL__c,
            Selenium_Settings__r.Device_Screen_Size__c,
            Selenium_Test_Suite__r.Id,
            Selenium_Test_Suite__r.Apex_code_before_test__c,
            Selenium_Test_Suite__r.Apex_code_after_test__c,
            Selenium_Test_Group__r.Id
            FROM Selenium_Test_Run__c
            WHERE Id=:testRunId];
        
        rm.Run_Id = r.Id ;
        rm.Run_Name = r.Name ;
        rm.Run_Base_URL = r.Base_URL__c ;
        rm.Run_Batch_No = (integer)r.Batch_No__c ;
        rm.Run_Namespace = r.Org_Credential__r.Environment__r.Namespace__c ;
        rm.Run_Namespace = rm.Run_Namespace==null?'':rm.Run_Namespace;
        rm.Run_Org_Credential = r.Org_Credential__c ;
        rm.Settings_Name = r.Selenium_Settings__r.Name ;
        rm.Settings_Provider = r.Selenium_Settings__r.Provider__c;
        rm.Settings_Selected_Platforms = r.Selenium_Settings__r.Selected_Platforms__c ;
        rm.Settings_Webdriver_Proxy = r.Selenium_Settings__r.Webdriver_Proxy__c ;
        rm.Settings_Webdriver_URL = r.Selenium_Settings__r.Webdriver_URL__c ;
        rm.Suite_Apex_code_after_test = r.Selenium_Test_Suite__r.Apex_code_after_test__c ;
        rm.Suite_Apex_code_before_test = r.Selenium_Test_Suite__r.Apex_code_before_test__c ;
        rm.Suite_Id = r.Selenium_Test_Suite__r.Id ;
        if(String.isNotBlank(rm.Run_Base_URL)) {
            rm.Run_Namespace = null;
            rm.Run_Org_Credential = null;
        }

        List<Selenium_Test_Case_Per_Suite__c> tcs = [SELECT Id, Selenium_Test_Case__r.Id, Selenium_Test_Case__r.Name,
            Test_Dataset_Name__c
            FROM Selenium_Test_Case_Per_Suite__c
            WHERE Selenium_Test_Suite__c = :rm.Suite_Id
            ORDER BY Order__c, CreatedDate];
        
        List<Id> ids = new List<Id>();
        for(Selenium_Test_Case_Per_Suite__c t : tcs)
            ids.add(t.Selenium_Test_Case__r.Id);
		
        // note, for this to work: the testcase must be always the FIRST item, so the ORDER must be appropiate
        List<Attachment> ltc = [SELECT Id, ParentId, Name, Body FROM Attachment WHERE ParentId in :ids AND Name in ('Copado.SeleniumTestCase.json', 'Copado.SeleniumTestData.json') ORDER BY name ASC LIMIT 199];
        Map<Id,List<Attachment>> mtc = new Map<Id,List<Attachment>>();
        for(Attachment t :ltc) {
            if(!mtc.containsKey(t.parentId))
                mtc.put(t.parentId, new List<Attachment>());
            mtc.get(t.parentId).add(t);
        }
        rm.testcases = new List<RunTestCaseAndData>();
        List<Id> testCasesRequiringLocators = new List<Id>();
        for(Selenium_Test_Case_Per_Suite__c t : tcs) {
            if(mtc.containsKey(t.Selenium_Test_Case__r.Id)) {
                RunTestCaseAndData cd = new RunTestCaseAndData(t.Selenium_Test_Case__r.Id, null, null, null);
                cd.src = mtc.get(t.Selenium_Test_Case__r.Id).get(0).Body.toString();
                if(cd.src.containsIgnoreCase('{!Locator.'))
                    testCasesRequiringLocators.add(cd.Id);
                if(mtc.get(t.Selenium_Test_Case__r.Id).size()>1) {
                    cd.dataName = t.Test_Dataset_Name__c;
	                cd.data = mtc.get(t.Selenium_Test_Case__r.Id).get(1).Body.toString();
                    if(cd.data.containsIgnoreCase('{!Locator.'))
                        testCasesRequiringLocators.add(cd.Id);
                }
	            rm.testcases.add( cd );
            }
        }
		
        rm.global_vars = new List<RunVar>();
        rm.run_unique_id = String.valueOf((integer)(Math.random()*9999));
        rm.global_vars.add( new RunVar('RUN_ID', rm.run_unique_id) );
        rm.global_vars.add( new RunVar('NS', rm.Run_Namespace) );
        rm.global_vars.add( new RunVar('BLANK', '') );
        
        List<Selenium_Group_Variable__c> gvars = [SELECT Id, Name, Value__c
            FROM Selenium_Group_Variable__c
            WHERE Selenium_Test_Group__c = :r.Selenium_Test_Group__r.Id];
        for(Selenium_Group_Variable__c t : gvars)
            rm.global_vars.add( new RunVar('Group.'+t.Name, t.Value__c) );
        
        List<Environmental_Variable__c> evars = [SELECT Id, Name, Value__c
            FROM Environmental_Variable__c
            WHERE Environment__c = :r.Org_Credential__r.Environment__c];
        for(Environmental_Variable__c t : evars)
            rm.global_vars.add( new RunVar('Environment.'+t.Name, t.Value__c) );
        
        if(testCasesRequiringLocators.size()>0) {
        	List<Selenium_Locator_Reference__c> ls = [SELECT Selenium_Locator__r.Locator_ID__c, Selenium_Locator__r.Locator__c
            FROM Selenium_Locator_Reference__c
            WHERE Selenium_Test_Case__c in :testCasesRequiringLocators AND Selenium_Locator__r.Locator_ID__c != NULL];
            for(Selenium_Locator_Reference__c t : ls)
                rm.global_vars.add( new RunVar('Locator.'+t.Selenium_Locator__r.Locator_ID__c, t.Selenium_Locator__r.Locator__c) );
        }

		return rm;
    }

}