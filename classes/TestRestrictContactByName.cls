@isTest

public class TestRestrictContactByName{

    @isTest static void upateContact(){
        Contact c  = new Contact();
        c.LastName = 'INVALIDNAME';
        
        Try{
        insert c;
        }
        
        catch(DmlException e){}
        
        c.FirstName = 'Arturo';
        
        Try{
        update c;      
        }
        catch(DmlException e){}
         
 }
}