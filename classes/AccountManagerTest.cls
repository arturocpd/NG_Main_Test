@IsTest
private class AccountManagerTest {

    @isTest static void testgetAccount() {
        Id recordId = createTestRecords();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri  = 'https://yourInstance.salesforce.com/services/apexrest/Accounts/'+ recordId +'/contacts';
        request.httpMethod  = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount != null);
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