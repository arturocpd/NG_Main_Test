@isTest
public class AccountProcessorTest {
    @isTest public static void testcountContacts(){
        List<Id> listIds = new List<Id>();
        listIds.add(createTestRecords());
        listIds.add(createTestRecords());
        
        Test.startTest();
        AccountProcessor.countContacts(listIds);
        Test.stopTest();
    }
      // Helper method
    static Id createTestRecords() {
        // Create Account record
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        // Create contact records associated to the account
        Contact testContact1 = new Contact(LastName='Test Contact1', AccountId=testAccount.Id);
        insert testContact1;
        Contact testContact2 = new Contact(LastName='Test Contact2', AccountId=testAccount.Id);
        insert testContact2;
        return testAccount.Id;
    }         
}