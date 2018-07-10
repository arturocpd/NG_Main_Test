@isTest
private class AppleWatch_TestClass {
  
  @isTest static void createOpportunity() {
    Opportunity opp = new Opportunity ();
    opp.Name = 'Swift Deal';
    opp.StageName = 'Prospecting';
    opp.CloseDate = Date.today();
    insert opp;
  }
  
}