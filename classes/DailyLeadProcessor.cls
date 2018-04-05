global class DailyLeadProcessor implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Lead> leadsToUpdate = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = '' LIMIT 200];
        List<Lead> updateLeads = new List<Lead>();
        For (Lead currentLead : leadsToUpdate){
            currentLead.LeadSource = 'Dreamforce';
            updateLeads.add(currentLead);
        }
        Update updateLeads;
    }
}