public class KanbanBoard {
    private Kanban_Board__c obj;
    
    public KanbanBoard(ApexPages.StandardController stdController) {
        this.obj = (Kanban_Board__c)stdController.getRecord();
        if(obj.Id!=null)
            obj = [SELECT Id, Name, SOQL_Query__c, Field_to_read_update__c, JSON_Settings__c, Columns_SOQL__c , Description__c FROM Kanban_Board__c WHERE Id = :obj.Id LIMIT 1]; 
        else
            obj = new Kanban_Board__c();
        System.debug('KanbanBoard.getJSonRecord return '+obj);
    }

    public String getJSonRecord() {
        // NOTE: needed due to namespacing
        Map<String, String> myMap = new Map<String, String>{
            'Id' => obj.Id,
            'Name' => obj.Name,
            'SOQL_Query__c' => obj.SOQL_Query__c,
            'Field_to_read_update__c' => obj.Field_to_read_update__c,
            'JSON_Settings__c' => obj.JSON_Settings__c,
            'Columns_SOQL__c' => obj.Columns_SOQL__c,
            'Description__c' => obj.Description__c
        };

        return JSON.serialize(myMap);
    }
}