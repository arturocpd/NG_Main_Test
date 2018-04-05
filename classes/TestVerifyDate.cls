@isTest
private class TestVerifyDate{

    @isTest static void testCheckDatesOk(){
        Date d1 = date.parse('01/01/16');
        Date d2 = date.parse('01/15/16');
        Date finalDate = VerifyDate.CheckDates(d1,d2); //1 enero vs 15 enero
        System.assertEquals(d2,finalDate); //devuleve 15 enero
    }
        
    
     @isTest static void testCheckDatesNotOk1(){
         Date d1 = date.parse('01/01/16');
         Date d2 = date.parse('02/15/16');
         Date finalDate = VerifyDate.CheckDates(d1,d2); //1 de enero vs 15 febrero
         Date d3 = date.parse('01/31/16');
         System.assertEquals(d3,finalDate); // devuelve 31 enero
    }
    
     @isTest static void testCheckDatesNotOk2(){
         Date d1 = date.parse('01/15/16');
         Date d2 = date.parse('01/01/16');
         Date finalDate = VerifyDate.CheckDates(d1,d2); //15 enero vs 1 enero
         Date d3 = date.parse('01/31/16');
         System.assertEquals(d3,finalDate); // devuelve 31 enero
    }
}