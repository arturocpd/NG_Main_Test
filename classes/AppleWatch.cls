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
        Comment
        Line1
        Line2
        Line3
        Line4
        Line5
        Line6
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