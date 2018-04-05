@isTest
public class AddPrimaryContactTest {

    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(name='Test Account'+i, BillingState='NY'));
        }
        for (Integer i = 50; i < 100; i++) {
            accounts.add(new Account(name='Test Account'+i, BillingState='CA'));
        }
        insert accounts;
    }
    
    static testmethod void testQueueable() {
       	Contact myContact = new Contact (LastName='testContact');
        insert myContact;
        
        // Create our Queueable instance
        AddPrimaryContact updater = new AddPrimaryContact(myContact, 'CA');
        // startTest/stopTest block to force async processes to run
        Test.startTest();        
        System.enqueueJob(updater);
        Test.stopTest();        
        // Validate the job ran. Check if record have correct parentId now
        //System.assertEquals(100, [select count() from account where parentId = :parentId]);
    }
    
}