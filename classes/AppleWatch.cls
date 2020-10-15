Public with sharing Class AppleWatch{

/*public attributes for PMD testing*/

private Void doWork1(){}
private Void doWork2(){}
private Void doWork3(){}
private Void doWork4(){}
private Void doWork5(){}
private Void doWork6(){}
private Void doWork7(){}
private Void doWork8(){}
private Void doWork9(){}
private Void doWork10(){}
private Void doWork11(){}
private Void doWork12(){}
private Void doWork13(){}
private Void doWork14(){}
private Void doWork15(){}
private Void doWork16(){}
private Void doWork17(){}
private Void doWork18(){}
private Void doWork19(){}
private Void doWork20(){}
private Void doWork21(){}
private Void doWork22(){}


 Public Static void appleWatchmethod(list<Opportunity> lopt ){
    for (Opportunity opp : lopt) {
        Task t        = new Task();
        t.Subject     = 'Apple Watch Promo' ;
        t.Description = 'Send them one ASAP' ;
        t.Priority    = 'High' ;
        t.WhatId      = opp.Id;
        insert t;

     /*Commit conflict1 Mod in Source and feature branch*/
     /*Commit conflict2*/
     
   }
  
  }
 
 }
