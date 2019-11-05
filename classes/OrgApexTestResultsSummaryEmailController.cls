public without sharing class OrgApexTestResultsSummaryEmailController {
	public static String apexResultId {get;set;}
    public Apex_Test_Result__c apexResult = null;
    public List<Coverage> classCoverage = null;
	public List<Coverage> triggerCoverage = null;
    public List<ClassMethod> classMethods = null;
    public Integer total_lines {get;set;}
    public Integer covered_lines {get;set;}
    public Integer not_covered_lines {get;set;}
    public Decimal min_coverage {get;set;}
    
    public OrgApexTestResultsSummaryEmailController(){    
    }
    
    public List<Coverage> getClassCoverage(){
        if(apexResult==null){
            getApexResult();
        }
        return classCoverage;
    }
    public List<Coverage> getTriggerCoverage(){
        if(apexResult==null){
            getApexResult();
        }
        return triggerCoverage;
    }
    public List<ClassMethod> getClassMethods(){
        if(apexResult==null){
            getApexResult();
        }
        return classMethods;
    }
    
    public void getApexResult(){
        String jsonBody = null;
        if(String.isBlank(apexResultId)){
            apexResult = new Apex_Test_Result__c();
        }
        else{
        	apexResult = [select id, Tests_run__c, Total_time__c, Successes__c, Failures__c, Org__r.Environment__r.Minimum_Apex_Test_Coverage__c from Apex_Test_Result__c where Id=:apexResultId order by createddate desc limit 1];    
            List<Attachment> resultAttachment = [select Id, Name, ParentId, Body from Attachment where Name='ApexTestResult' and ParentId=:apexResultId order by lastmodifieddate desc limit 1];
            if(resultAttachment.size()==1){
                jsonBody = resultAttachment[0].Body.toString();
            }
        }
        
        classCoverage = new List<Coverage>();
        triggerCoverage = new List<Coverage>();
        classMethods = new List<ClassMethod>();
        Map<String, Object> classCoverageMap = null;
        Map<String, Object> triggerCoverageMap = null;
        Map<String, Object> methodsMap = null;
        Map<String, Object> fullMap = null;
        if(String.isNotBlank(jsonBody)){
            fullMap = (Map<String, Object>)JSON.deserializeUntyped(jsonBody);
            classCoverageMap = (Map<String, Object>)fullMap.get('classCoverageResults');
            triggerCoverageMap = (Map<String, Object>)fullMap.get('triggerCoverageResults');
            methodsMap = (Map<String, Object>)fullMap.get('testClassResults');
        }
        
        
        total_lines = 0;
        covered_lines = 0;
        not_covered_lines = 0;
        min_coverage = apexResult.Org__r!=null?apexResult.Org__r.Environment__r.Minimum_Apex_Test_Coverage__c:75.00;
        
        if(classCoverageMap!=null && classCoverageMap.size()>0){
            for(Object o : classCoverageMap.keySet()){
                String className = (String)o;
                Map<String, Object> classObject = (Map<String, Object>)classCoverageMap.get(className);
                Coverage t = new Coverage();
                t.name = className;
                //t.coverage = (Integer)classObject.get('coverage');
                t.total_lines = (Integer)classObject.get('numLocations');
                t.lines_not_covered = (Integer)classObject.get('numLocationsNotCovered');
                classCoverage.add(t);
                total_lines += t.total_lines;
                not_covered_lines += t.lines_not_covered;
            }
        }
        if(triggerCoverageMap!=null && triggerCoverageMap.size()>0){
            for(Object o : triggerCoverageMap.keySet()){
                String triggerName = (String)o;
                Map<String, Object> triggerObject = (Map<String, Object>)triggerCoverageMap.get(triggerName);
                Coverage t = new Coverage();
                t.name = triggerName;
                //t.coverage = (Integer)triggerObject.get('coverage');
                t.total_lines = (Integer)triggerObject.get('numLocations');
                t.lines_not_covered = (Integer)triggerObject.get('numLocationsNotCovered');
                triggerCoverage.add(t);
                total_lines += t.total_lines;
                not_covered_lines += t.lines_not_covered;
            }
        }
        
        if(methodsMap!=null && methodsMap.size()>0){
            for(Object o : methodsMap.keySet()){
                String className = (String)o;
                Map<String, Object> thisClassMap = (Map<String, Object>)methodsMap.get(className);
                List<Object> methodsList = (List<Object>)thisClassMap.get('methods');
                for(Object om : methodsList){
                    Map<String, Object> mObj = (Map<String, Object>)om;
                    ClassMethod cm = new ClassMethod();
                    cm.methodName = (String)mObj.get('name');
                    cm.className = className;
                    cm.status = (((boolean)mObj.get('success'))?'Passed':'Failed');
                    cm.message = (String)mObj.get('message');
                    classMethods.add(cm);
                }                
            }
        }
        if(total_lines == null || total_lines == 0)total_lines=1;//to prevent div by zero
        covered_lines = total_lines - not_covered_lines;
    }
    public class Coverage{
        public String name {get;set;}
        public Integer total_lines {get;set;}
        public Integer lines_not_covered {get;set;}
        public Integer coverage {get;set;}
    }
    public class ClassMethod{
        public String methodName {get;set;}
        public String className {get;set;}
        public String status {get;set;}
        public String message {get;set;}
    }
}