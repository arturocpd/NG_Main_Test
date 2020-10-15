Public with sharing Class AppleWatch{

/*public attributes for PMD testing*/

public Void doWork1(){}
public Void doWork2(){}
public Void doWork3(){}
public Void doWork4(){}
public Void doWork5(){}
public Void doWork6(){}
public Void doWork7(){}
public Void doWork8(){}
public Void doWork9(){}
public Void doWork10(){}
public Void doWork11(){}
public Void doWork12(){}
public Void doWork13(){}
public Void doWork14(){}
public Void doWork15(){}
public Void doWork16(){}
public Void doWork17(){}
public Void doWork18(){}
public Void doWork19(){}
public Void doWork20(){}
public Void doWork21(){}
public Void doWork22(){}

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