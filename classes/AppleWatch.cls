Public Class AppleWatch{
 Public Static void AppleWatchmethod(list<Opportunity> lopt ){
    for (Opportunity opp : lopt) {
        Task t        = new Task();
        t.Subject     = 'Apple Watch Promo';
        t.Description = 'Send them one ASAP';
        t.Priority    = 'High';
        t.WhatId      = opp.Id;
        insert t;
     /*conflict here test 2334*/
     //testing Git Metadata Step 2
     /* test new commit user story ZZZZ*/
     /* yes!! line*/
     //testing 2 comment trying to force a conflict here
     //changes on dev3
     
       
    }

 
 }
}