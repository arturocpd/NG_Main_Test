public class AccountHandler{

    public static Account insertNewAccount(String accName){
    
    Try{
            Account newAccount = new Account();
            newAccount.Name = accName;
            insert newAccount;
            return newAccount;
      }
      catch(DmlException e){
      System.debug('La cuenta no se ha creado pq no se ha dado un nombre');
      return null;
      }
      
      
            
       
   
    }
    
    
}