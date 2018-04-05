public class AccountProcessor {
    @future
    public static void countContacts (List<Id> accountsId){
        List<Account> upateAcc = new List<Account>();
        Integer nContacts;
        for (Id accId :accountsId){
            Account currentAcc = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :accId];
            nContacts = [SELECT count() FROM Contact WHERE AccountId = :accId]; 
                                               
            currentAcc.Number_of_Contacts__c = nContacts;
            upateAcc.add(currentAcc);
            
        }
        update upateAcc;
    }

}