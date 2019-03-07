Public with sharing Class AppleWatch{
 Public Static void appleWatchmethod(list<Opportunity> lopt ){
    for (Opportunity opp : lopt) {
        Task t        = new Task();
        t.Subject     = 'Apple Watch Promo';
        t.Description = 'Send them one ASAP';
        t.Priority    = 'High';
        t.WhatId      = opp.Id;
        insert t;
     /*conflict here test 2334*/ 
     /*conflict qweffwsedfasf test rfgdasfg*/
     /*conflict MODDD test 233adsrfg4*/
     /*conflict afgafgr test 2334*/
     /*conadfrflict here test 2334*/
   }
  
  }
 
 }