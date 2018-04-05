@isTest
public class ParkLocatorTest {
    @isTest static void testCallout(){
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String name = 'India';
        List<String> parks = ParkLocator.Country(name);
        System.assertEquals('Anamudi Shola National Park', parks[0]);
        System.assertEquals('Anshi National Park', parks[1]);
        System.assertEquals('Bandipur National Park', parks[2]);
    }
}