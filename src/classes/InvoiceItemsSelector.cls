public class InvoiceItemsSelector extends SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                InvoiceItem__c.Id,
                InvoiceItem__c.Name,
                InvoiceItem__c.Quantity__c,
                InvoiceItem__c.UnitPrice__c,
                InvoiceItem__c.TotalPrice__c
            };
    }

    public InvoiceItemsSelector(Set<String> fields){
        super(fields);
    }

    public InvoiceItemsSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return InvoiceItem__c.sObjectType;
    }

    public List<InvoiceItem__c> selectById(Set<Id> invoiceItemIds){
        return (List<InvoiceItem__c>) selectSObjectsById(invoiceItemIds);
    }

    public List<InvoiceItem__c> selectByIdWithInvoiceStatusNotEditable(Set<Id> invoiceItemIds){
        String openStatus = 'Open';
        return (List<InvoiceItem__c>) Database.query(String.format(
                'select {0} ' +
                  'from {1} ' +
                  'where Id In: invoiceItemIds ' +
                  'and FieloPRP__Invoice__r.FieloPRP__Status__c = :openStatus ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<InvoiceItem__c> selectByMemberIdAndInvoiceId(Set<Id> invoiceIds, Id memberId){
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (memberId != null) {
            whereConditions.add(' Invoice__r.Member__c =: memberId ');
        }
        if( !invoiceIds.isEmpty() ) {
            whereConditions.add(' Invoice__c IN : invoiceIds ');
        }
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, 'AND');
        }
        
        query += 'order by {2} {3} {4}';
        
        return (List<InvoiceItem__c>) Database.query(String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } ));
    }

    public List<InvoiceItem__c> selectByInvoiceId(Set<Id> invoiceIds, Set<Id> excludedItemIds){
        return (List<InvoiceItem__c>) Database.query(String.format(
                'select {0} ' +
                  'from {1} ' +
                  'where Id not In : excludedItemIds ' +
                  'and Invoice__c in : invoiceIds ' +
                  'order by {2} {3} {4}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } ));
    }
}