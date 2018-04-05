public class AnimalLocator {
    public static string getAnimalNameById(Integer num){
       
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+num);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
       Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
       Map<String, Object> atributes = (Map<String, Object>) results.get('animal');
       String myAnimal = (String)atributes.get('name');
       	System.debug(results);
        System.debug(atributes);
        System.debug(myAnimal);
           //String res = response.getBody();
                 
        return myAnimal;
    }
	
}