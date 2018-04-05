@isTest
private class DailyLeadProcessorTest {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testScheduledJob() {

        // Create some out of date Opportunity records
        List<Lead> lds = new List<Lead>();
		for (Integer i=0; i<200; i++) {
		Lead l = new Lead(LastName = 'Lead' + i, Company = 'Salesforce');
		lds.add(l);
        }
        insert lds;
        
        // Get the IDs of the opportunities we just inserted
        //Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>(opptys);
        //List<Id> opptyIds = new List<Id>(opptyMap.keySet());

        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP, new DailyLeadProcessor());         
        // Verify the scheduled job has not run yet.
        Test.stopTest();
        
        // Now that the scheduled job has executed,
        // check that our leads were updated
        

    }
}