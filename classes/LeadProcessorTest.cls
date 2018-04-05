@isTest
private class LeadProcessorTest {

    @testSetup 
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            leads.add(new Lead(LastName='lead '+i, Company='Salesforce'));
        }
        insert leads;
    }
    
	static testmethod void test() {        
	Test.startTest();
	LeadProcessor uleads = new LeadProcessor();
	Id batchId = Database.executeBatch(uleads);
	Test.stopTest();

    // after the testing stops, assert records were updated properly
	System.assertEquals(200, [select count() from lead where LeadSource = 'Dreamforce']);
	
    }
    
}