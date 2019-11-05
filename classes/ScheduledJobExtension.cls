public without sharing class ScheduledJobExtension {
    public CronTrigger ct{get;set;}
    public Scheduled_Job__c job {get;set;}
    private ApexPages.StandardController cont;
    public ScheduledJobExtension(ApexPages.StandardController std){
        cont = std;
        job = (Scheduled_Job__c)std.getRecord();
        if(String.isnotBlank(job.Apex_Job_ID__c)){
            List<CronTrigger> cts = [select Id, CronExpression , NextFireTime, PreviousFireTime, StartTime, State, TimesTriggered, TimeZoneSidKey  from CronTrigger where Id=:job.Apex_Job_ID__c];
            ct = cts.size()>0?cts.get(0):null;
        }
        if(ct==null)ct = new CronTrigger();
    }
    public PageReference stop(){
        if(String.isnotBlank(job.Apex_Job_ID__c)){
            List<CronTrigger> cts = [select Id, CronExpression , NextFireTime, PreviousFireTime, StartTime, State, TimesTriggered, TimeZoneSidKey  from CronTrigger where Id=:job.Apex_Job_ID__c];
            if(cts.size()>0){
              	System.abortJob(job.Apex_Job_ID__c);
              	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.JOB_UNSCHEDULED_SUCCESSFULLY ));
            }
            else{
        		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,Label.NO_JOB_FOUND));
            }
            job.Apex_Job_ID__c = null;
            update job;
            ct = new CronTrigger();
            return null;
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,Label.NOTHING_TO_STOP));
        }
        return null;
    }
    public PageReference delete_job(){
        stop();
        delete job;
        return cont.delete();
    }
    public PageReference schedule_job(){
        PageReference pr = Page.ScheduledJobSchedule;
        pr.getParameters().put('id',job.Id);
        return pr;
    }
    public PageReference save_job(){
        try{
            stop();
            String cron = job.Cron_Expression__c;
            String jobId = System.schedule(job.Name.left(80), cron, new WebhookSchedulable(job.Id));
            job.Apex_Job_ID__c  = jobId;
            update job;
            return new PageReference('/'+job.Id);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, Label.COULD_NOT_SCHEDULE_JOB + ': ' + e.getMessage()));
        }
        return null;
    }
}