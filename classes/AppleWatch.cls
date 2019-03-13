Public Class AppleWatch{
 Public Static void AppleWatchmethod(list<Opportunity> lopt ){
    for (Opportunity opp : lopt) {
        Task t        = new Task();
        t.Subject     = 'Apple Watch Promo';
        t.Description = 'Send them one ASAP';
        t.Priority    = 'High';
        t.WhatId      = opp.Id;
        insert t;
     /*conflict here*/
     
/*lineX*/
/*line2*/
/*line3*/
/*line4*/
/*line5*/


/*line1*/
/*lineX*/
/*line3*/
/*line4*/
/*line5*/


/*line1*/
/*line2*/
/*lineX*/
/*line4*/
/*line5*/

/*line1*/
/*line2*/
/*line3*/
/*lineX*/
/*line5*/


/*line1*/
/*line2*/
/*line3*/
/*line4*/
/*lineX*/
       
    }

 
 }
}