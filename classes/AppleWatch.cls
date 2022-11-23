Public with sharing Class AppleWatch{
 Public Static void appleWatchmethod(list<Opportunity> lopt ){
    for (Opportunity opp : lopt) {
        Task t        = new Task();
        t.Subject     = 'Apple Watch Promo' ;
        t.Description = 'Send them one ASAP' ;
        t.Priority    = 'High' ;
        t.WhatId      = opp.Id;
        insert t;
<<<<<<< HEAD
     /*Comment ABCD*/
     
=======
     /*Comment Dev1 Org FINAL*/
>>>>>>> refs/remotes/origin/feature/US-0012999
     /*Comment 2*/
   }
  }
 }
