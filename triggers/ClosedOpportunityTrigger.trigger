trigger ClosedOpportunityTrigger on Opportunity (after insert, before update) {
    
    List<Task> createTask = new List<Task>(); 
    
    for(Opportunity opp : Trigger.new){
        if(opp.StageName == 'Closed Won'){
            Task t    = new Task();
            t.Subject = 'Follow Up Test Task';
            t.WhatId  = opp.Id;
            createTask.add(t);
            
        }
    }
    insert createTask;

}