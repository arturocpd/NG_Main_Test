public class ParkLocator {
    public static List<String> Country(String name){ //Posible names are Germany, India, Japan and United States.
        ParkService.ParksImplPort parks = new ParkService.ParksImplPort();
        System.debug(parks.byCountry(name));
        return parks.byCountry(name);
        
    }

}