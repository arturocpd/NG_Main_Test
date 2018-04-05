public class ContactAndLeadSearch{

    public static List<List<sObject>> searchContactsAndLeads(String name){    

        List<List<sObject>> results = [FIND :name IN NAME FIELDS RETURNING Contact, Lead];
        SYstem.debug(results);
        return results;

    }


}