public class AddPrimaryContact implements Queueable {
    
    private List<Account> accounts;
   	private Contact mainContact = new Contact();
    private String state;
    
    public AddPrimaryContact(Contact theContact, String theState) {
        this.mainContact = theContact;
        this.state = theState;
    }

    public void execute(QueueableContext context) {
        this.accounts = [SELECT Id FROM Account WHERE BillingState = :state LIMIT 200];
        for (Account account : accounts) {
          mainContact.AccountId = account.Id;
          // perform other processing or callout
        }
        update accounts;
    }
    
}