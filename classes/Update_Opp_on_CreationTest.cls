@isTest
private class Update_Opp_on_CreationTest {

 
  @isTest static void createOpportunity() {
    Opportunity opp = new Opportunity ();
    System.debug(opp.Description);
    opp.Name = 'Swift Deal';
    opp.StageName = 'Prospecting';
    opp.CloseDate = Date.today();
    insert opp;
    System.debug(opp.Description);
    System.assertEquals(('Description'), opp.Description);
  }

  
}