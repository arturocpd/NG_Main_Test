public class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts(Integer numContacts, String lName){
        List<Contact> listOfContacts = new List<Contact>();
    
        for(Integer i=1; i<=numContacts; i++){
            Contact c   = new Contact();
            c.FirstName = 'Contact ' + i;
            c.LastName  = lName;
            listOfContacts.add(c);
        }
        System.debug(listOfContacts);
        return listOfContacts;
        
   }

}