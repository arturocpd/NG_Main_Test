@isTest
public class AnimalLocatorTest {

    @isTest static void testGetAnimalNameById() {
           
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        // Call method to test
        String result = AnimalLocator.getAnimalNameById(2);
        // Verify mock response is not null
        System.assertNotEquals(null,result,
            'The callout returned a null response.');
        System.assertEquals('bear',result);
             
    }   

}