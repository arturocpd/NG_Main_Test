public class ContactSearch{

    public static List<Contact> searchForContacts(String lstname, String postal){
    
    
    List<Contact> myList = new List<Contact>();
        myList = [SELECT Id,Name FROM Contact WHERE LastName=:lstname AND MailingPostalCode=:postal];
        System.debug(myList);
        return myList;
        
    }


}