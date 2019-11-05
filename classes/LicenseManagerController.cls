public without sharing class LicenseManagerController {
	public static String copadoURL = Settings.Server_URL;

	public Integer copadoLicensesAvailable {get;set;}
	public Integer ccmLicensesAvailable {get;set;}
    public Integer cstLicensesAvailable {get;set;}
	public Integer copadoLicensesUsed {get;set;}
	public Integer ccmLicensesUsed {get;set;}
    public Integer cstLicensesUsed {get;set;}
	public boolean enableMultiLicenses {get;set;}
	public List<LicenseManager> copadoUsage {get;set;}
	public List<LicenseManager> ccmUsage {get;set;}
    public List<LicenseManager> cstUsage {get;set;}
    public Map<Id, Copado_License__c> licenseMap {get;set;}

	public User dummyUser {get;set;} //this is used for the user lookup
	public boolean initRun {get;set;} //request user to contact heroku before proceeding

	public boolean assignCopado {get;set;}
	public boolean assignCCM {get;set;}
    public boolean assignCST {get;set;}

	public static final String copadoLicenseLimitReached = Label.COPADO_LICENSE_LIMIT_REACHED;
	public static final String ccmLicenseLimitReached = Label.CCM_LICENSE_LIMIT_REACHED;
    public static final String cstLicenseLimitReached = Label.CST_LICENSE_LIMIT_REACHED;

	public LicenseManagerController() {
		initRun = false;
        Settings__c setting = Settings__c.getOrgDefaults();
        
		copadoLicensesAvailable = setting.Copado_Licenses__c!=null?setting.Copado_Licenses__c.intValue():0;
		ccmLicensesAvailable = setting.CCM_Licenses__c!=null?setting.CCM_Licenses__c.intValue():0;
        cstLicensesAvailable = setting.CST_Licenses__c!=null?setting.CST_Licenses__c.intValue():0;
		enableMultiLicenses = setting.Enabled_Multi_Licenses__c!=null?setting.Enabled_Multi_Licenses__c:false;
		dummyUser = new User();
	}

	public void init(){
        if(getHerokuInfo()){
         	getLocalInfo();
			initRun = true;   
        }
	}

	public boolean getHerokuInfo(){
		//String copadoOrgId = UserInfo.getOrganizationId();
        //String copadoUserId = UserInfo.getUserId();
        String endP = [Select Id, API_URL__c from User where Id =: UserInfo.getUserId()].API_URL__c;
		String url = copadoURL+'/?sid='+UserInfo.getSessionId()+'&url='+EncodingUtil.urlEncode(endP,'UTF-8');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        DeployAPI.setAuthHeaders(req);
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        try{
        	DeployAPI.HerokuResponse hr = new DeployAPI.HerokuResponse(res);
        	Map<String, Object> fullMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        	Map<String, Object> orgMap = (Map<String, Object>)fullMap.get('customerOrg');
        	try{
        		if(orgMap.get('copadoLicenses')!=null)copadoLicensesAvailable = (Integer)orgMap.get('copadoLicenses');
				if(orgMap.get('ccmLicenses')!=null)ccmLicensesAvailable = (Integer)orgMap.get('ccmLicenses');
                if(orgMap.get('cstLicenses')!=null)cstLicensesAvailable = (Integer)orgMap.get('cstLicenses');
				if(orgMap.get('multiLicenses')!=null)enableMultiLicenses = (boolean)orgMap.get('multiLicenses');	
                
                System.debug('copadoLicensesAvailable '+ copadoLicensesAvailable);
                System.debug('ccmLicensesAvailable '+ ccmLicensesAvailable);
                System.debug('cstLicensesAvailable '+ cstLicensesAvailable);
                System.debug('enableMultiLicenses '+ enableMultiLicenses);
                return true;
        	}
        	catch(Exception e){
        		System.debug('Not a multi license org.');
        	}
        	
        }
        catch(Exception e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while getting License information: '+e.getMessage()));
        }
        return false;
	}

	public void getLocalInfo(){

		Settings__c setting = Settings__c.getOrgDefaults();
		//check if heroku data matches local data
		boolean updateSetting = false;
		if(setting.Copado_Licenses__c!=copadoLicensesAvailable){
			setting.Copado_Licenses__c = copadoLicensesAvailable;
			updateSetting = true;
		}
		if(setting.CCM_Licenses__c!=ccmLicensesAvailable){
			setting.CCM_Licenses__c = ccmLicensesAvailable;
			updateSetting = true;
		}
        if(setting.CST_Licenses__c!=cstLicensesAvailable){
			setting.CST_Licenses__c = cstLicensesAvailable;
			updateSetting = true;
		}
		if(setting.Enabled_Multi_Licenses__c!=enableMultiLicenses){
			setting.Enabled_Multi_Licenses__c = enableMultiLicenses;
			updateSetting = true;
		}
		//delete incorrect user assigned org wide settings.
        delete [select Id from Settings__c where SetupOwnerId!=:UserInfo.getOrganizationId()];
		if(updateSetting){
            try{
				upsert setting;
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
		}
		copadoLicensesUsed = 0;
		ccmLicensesUsed = 0;
        cstLicensesUsed = 0;
		List<Copado_License__c> licenses = new List<Copado_License__c>();
		licenseMap = new Map<Id, Copado_License__c>();
		copadoUsage = new List<LicenseManager>();
		ccmUsage = new List<LicenseManager>();
        cstUsage = new List<LicenseManager>();
		licenses = [SELECT Id, SetupOwnerId, SetupOwner.Name, Enable_CCM__c, Enable_CST__c, Enable_Copado__c FROM Copado_License__c ORDER BY SetupOwner.Name];
		if(licenses.size() > 0){
			for(Copado_License__c l : licenses){
				licenseMap.put(l.SetupOwnerId, l);
				if(l.Enable_Copado__c==true){
					copadoUsage.add(new LicenseManager(l, 'copado', this));
					copadoLicensesUsed++;
				}
				if(l.Enable_CCM__c==true){
					ccmUsage.add(new LicenseManager(l, 'ccm', this));
					ccmLicensesUsed++;
				}
                if(l.Enable_CST__c==true){
					cstUsage.add(new LicenseManager(l, 'cst', this));
					cstLicensesUsed++;
				}
			}
		}
	}
	/*
	This method will return true if the license count is exceeded.
	False == Everything ok.
	*/
	public boolean licenseCountExceeded(String type){
		if(type=='copado')return (copadoLicensesUsed+1)>copadoLicensesAvailable;
		if(type=='ccm')return (ccmLicensesUsed+1)>ccmLicensesAvailable;
        if(type=='cst')return (cstLicensesUsed+1)>cstLicensesAvailable;
		return true;
	}
	/*
	Take the user from the dummyUser object and assign them the relevant license(s)
	*/
	public void addUser(){
		if(dummyUser.ManagerId==null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.MUST_SELECT_USER));
			return;
		}
		try{
			if(licenseMap.keySet().contains(dummyUser.ManagerId)){
				Copado_License__c l = licenseMap.get(dummyUser.ManagerId);
				if(l.Enable_Copado__c==false && assignCopado==true && licenseCountExceeded('copado')){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, copadoLicenseLimitReached));
					return;
				}
				if(l.Enable_CCM__c==false && assignCCM==true && licenseCountExceeded('ccm')){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ccmLicenseLimitReached));
					return;
				}
				if(l.Enable_CST__c==false && assignCST==true && licenseCountExceeded('cst')){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, cstLicenseLimitReached));
					return;
				}
				l.Enable_Copado__c = assignCopado;
				l.Enable_CCM__c = assignCCM;
                l.Enable_CST__c = assignCST;
				update l;
			}
			else{
				if(assignCopado==true && licenseCountExceeded('copado')){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, copadoLicenseLimitReached));
					return;
				}
				if(assignCCM==true && licenseCountExceeded('ccm')){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ccmLicenseLimitReached));
					return;
				}
                if(assignCST==true && licenseCountExceeded('cst')){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, cstLicenseLimitReached));
					return;
				}
				Copado_License__c l = new Copado_License__c();
				l.Enable_Copado__c = assignCopado;
				l.Enable_CCM__c = assignCCM;
				l.Enable_CST__c = assignCST;
				l.SetupOwnerId = dummyUser.ManagerId;
				insert l;
			}			
			dummyUser = new User();
			assignCopado = false;
			assignCCM = false;
            assignCST = false;
			getLocalInfo();
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.LICENSE_UPSERT_SUCCESSFUL));
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getMessage()));
		}
	}

	public class LicenseManager{
		public Copado_License__c license {get;set;}
		public String type {get;set;}
		LicenseManagerController outerClass;

		public LicenseManager(Copado_License__c l, String t, LicenseManagerController outerClass){
			this.license = l;
			this.type = t;
			this.outerClass = outerClass;
		}
		public void removeAssignment(){
			try{
				if(type=='copado')license.Enable_Copado__c = false;
				if(type=='ccm')license.Enable_CCM__c = false;
                if(type=='cst')license.Enable_CST__c = false;
				update license;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.LICENSE_UPSERT_SUCCESSFUL));
				outerClass.getLocalInfo();
			}
			catch(Exception e){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ''+e.getMessage()));
			}
		}
	}
}