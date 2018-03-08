Public Class AppleWatch{
 Public Static void AppleWatchmethod(list<Opportunity> lopt ){
    for (Opportunity opp : lopt) {
        Task t        = new Task();
        t.Subject     = 'Apple Watch Promo';
        t.Description = 'Send them one ASAP';
        t.Priority    = 'High';
        t.WhatId      = opp.Id;
        insert t;
        
        /*test case*/
        
        /*
        Comment MOD
        Line1.MOD
        Line2.MOD
        Line3.MOD
        Line4.MOD
        Line5.MOD
        Line6.MOD
        */
        
        
    }

 
 }
}