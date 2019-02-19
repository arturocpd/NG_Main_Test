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
     /*conflict q2341234fgdasfg*/
     /*conf234123adsrfg4*/
     /*conflict afgafgr test 2334*/
     /*conadfr2134erdwest 2334*/
   }
  
  }
 
 }
