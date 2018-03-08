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
        Comment MOD2
        Line1.MOD2
        Line2.MOD2
        Line3.MOD2
        Line4.MOD2
        Line5.MOD2
        Line6.MOD2
        */
        
        /*
        Comment 2
        Line2.1
        Line2.2
        Line2.3
        Line2.4
        Line2.5
        Line2.6
        */
        
    }

 
 }
}