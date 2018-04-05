public class StringArrayTest {


    public static list<string> generateStringArray(integer n){
    
        List<string> myList = new List<string>();
        String value;
    
        for(Integer i=0; i<n; i++){
        value = 'Test ' + i;
            myList.add(value);
         }
         System.debug(myList);
        return myList;

    }



}