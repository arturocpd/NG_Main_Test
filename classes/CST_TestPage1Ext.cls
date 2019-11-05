public class CST_TestPage1Ext {
	private final Account acct;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public CST_TestPage1Ext(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        
        if(Apexpages.currentPage().getParameters().get('slow')!=null) {
            // Equivalent of sleep 30
            Long startTime = DateTime.now().getTime();
            Long finishTime = DateTime.now().getTime();
            while ((finishTime - startTime) < 30000)
                finishTime = DateTime.now().getTime(); //sleep for 30s
            System.debug('>>> Done from ' + startTime + ' to ' + finishTime);        
        }
    }

    public account getAccount() {
        return this.acct;
    }

    public String getGreeting() {
        return 'Hello ' + acct.name + ' (' + acct.id + ')';
    }
    
    public PageReference longWaitAction() {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Done'));
        
        // Equivalent of sleep 15s
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < 15000)
            finishTime = DateTime.now().getTime();
        System.debug('>>> Done from ' + startTime + ' to ' + finishTime);        
        
        return new PageReference('/');
    }

	Integer count = 0;
    public PageReference incrementCounter() {
        count+=5;
        return null;
    }
    public Integer getCount() {
        return count;
    }
}