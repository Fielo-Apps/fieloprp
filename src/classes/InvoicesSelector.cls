public class InvoicesSelector extends SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Invoice__c.Id,
                Invoice__c.Name,
                Invoice__c.Amount__c,
                Invoice__c.Status__c,
                Invoice__c.HasDetails__c,
                Invoice__c.InvoiceNumber__c,
                Invoice__c.Distributor__c,
                Invoice__c.Program__c
            };
    }

    public InvoicesSelector(Set<String> fields){
        super(fields);
    }

    public InvoicesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return Invoice__c.sObjectType;
    }

    public List<Invoice__c> selectById(Set<Id> invoiceIds){
        return (List<Invoice__c>) selectSObjectsById(invoiceIds);
    }

    public List<Invoice__c> selectByIdWithChilds(Set<Id> invoiceIds, String itemFields){
        Set<String> itemFieldSet = new Set<String>(itemFields != null && itemFields != '' ? itemFields.split(',') : new List<String>{'Id'});

        List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice = (List<Invoice__c>) Database.query(String.format(
                'select {0} ' +
                  ', (SELECT Id, ContentDocument.Id, ContentDocument.Title, ContentDocument.FileType FROM ContentDocumentLinks)' +
                  ', (SELECT Id, Name, ContentType FROM Attachments)' +
                  ', (SELECT ' + String.join(new List<String>(itemFieldSet), ',') + ' FROM FieloPRP__InvoiceItems__r)' +
                  'from {1} ' +
                  'where Id In: invoiceIds ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));

            }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;
    }

    public List<Invoice__c> selectByItemIdWithItemInfo(Set<Id> invoiceItemIds){


         List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice =  (List<Invoice__c>) Database.query(String.format(
                'select {0}, (Select Id, TotalPrice__c From InvoiceItems__r) ' +
                  'from {1} ' +
                  'where Id In (Select FieloPRP__Invoice__c From FieloPRP__InvoiceItem__c Where Id in: invoiceItemIds) ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));

                     }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;


    }

    public List<Invoice__c> selectByItemIdWithDetailedInvoiceDisabled(Set<Id> invoiceIds){


        List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice = (List<Invoice__c>) Database.query(String.format(
                'select {0} ' +
                  'from {1} ' +
                  'where Id In: invoiceIds ' +
                  'and FieloPRP__Member__r.FieloPLT__Program__r.RequestInvoiceProducts__c = false ' + 
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));


                     }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;


    }

    public List<Invoice__c> selectByProgramAndStatus(Set<String> status, Id programId) {
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (programId != null) {
            whereConditions.add(' Member__r.FieloPLT__Program__c =: programId ');
        }
        if (status != null) {
            whereConditions.add(' Status__c IN : status ');
        }
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, 'AND');
        }
        
        query += 'order by {2} {3} {4}';     


         List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice = (List<Invoice__c>) Database.query(String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } ));

                     }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;


    }

    public List<Invoice__c> selectByInvoiceNumberDistributorAndStatus(Set<String> invoiceNumbers, Set<String> distributors, String status) {
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (invoiceNumbers != null) {
            whereConditions.add(' InvoiceNumber__c IN :invoiceNumbers ');
        }
        if (distributors != null) {
            whereConditions.add(' Distributor__c IN :distributors ');
        }
        whereConditions.add(' Status__c = :status ');
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, 'AND');
        }
        
        query += 'order by {2} {3} {4}';     


         List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice = (List<Invoice__c>) Database.query(String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } ));

                     }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;


    }

    public List<Invoice__c> selectByMemberIdAndInvoiceIdBetweenDates(Set<Id> invoiceIds, Id memberId, Date fromdate, Date todate){
        assertIsAccessible();
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (memberId != null) {
            whereConditions.add(' Member__c =: memberId ');
        }
        if( !invoiceIds.isEmpty() ) {
            whereConditions.add(' Id IN : invoiceIds ');
        }
        if(fromdate!=null){
            whereConditions.add(
                'FieloPRP__Date__c >= ' + String.format(
                    '{0}-{1}-{2}'
                    ,new List<String>{
                            String.valueOf(fromdate.year()),
                            ('0'+String.valueOf(fromdate.month())).right(2),
                            ('0'+String.valueOf(fromdate.day())).right(2)
                        }
                    )
            );
        }
        if(todate!=null){
            whereConditions.add(
                'FieloPRP__Date__c <= ' + String.format(
                    '{0}-{1}-{2}'
                    ,new List<String>{
                            String.valueOf(todate.year()),
                            ('0'+String.valueOf(todate.month())).right(2),
                            ('0'+String.valueOf(todate.day())).right(2)
                        }
                    )
            );
        }
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, ' AND ');
        }
        
        query += ' order by {2} {3} {4}';



        query = String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } );



        System.debug('query'+ query);
        
        List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice = (List<Invoice__c>) Database.query(query);


         }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;
    }

    public List<Invoice__c> selectByMemberIdAndWhereClause(Id memberId, String whereClause){
        assertIsAccessible();
        String query = 'SELECT ' + getFieldListString() + ' FROM ' + getSObjectName();

        String whereConditions = '';
        if (memberId != null) {
            whereConditions += ' Member__c =: memberId ';
        }
        if (whereClause != null && whereClause != '') {
            whereConditions += ( whereConditions != '' && whereConditions != null ? ' AND ' : '' ) + whereClause;
        }
        
        if(whereConditions != null && whereConditions != ''){
            query += ' WHERE ' + whereConditions;
        }
        
        query += ' ORDER BY ' + getOrderBy() + ' ' + getLimitCondition() + ' ' + getOffsetCondition();

        System.debug('query'+ query);
        
         List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice = (List<Invoice__c>) Database.query(query);


         }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;
    }

    public List<Invoice__c> selectByIdWithDocuments(Set<Id> invoiceIds) {
        
        List<Invoice__c> listInvoice;

        if(Schema.sObjectType.Invoice__c.isAccessible()){

        listInvoice = (List<Invoice__c>) Database.query(String.format(
                'select {0} ' +
                  ', (SELECT Id, ContentDocument.Id FROM ContentDocumentLinks)' +
                  'from {1} ' +
                  'where Id In: invoiceIds ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));

                     }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;
    }

    public static List<ProcessInstance> selectInvoiceApprovalProcessInstance(Set<Id> invoiceIds){
         String query = '';

        if(Schema.sObjectType.ProcessInstance.isAccessible()){

        query = 'SELECT Id, TargetObjectId, '
                + ' (SELECT Id, toLabel(StepStatus) StepStatus ,Actor.Name, Comments, CreatedDate, ProcessNode.Name FROM StepsAndWorkitems where StepStatus = \'Pending\')'
                + ' FROM ProcessInstance WHERE TargetObjectId in :invoiceIds';
        return (List<ProcessInstance>) Database.query(query);

        }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

           return null;
    }

    public static List<ProcessInstance> selectAllInvoiceApprovalProcessInstance(Set<Id> invoiceIds){
        String query = '';

        if(Schema.sObjectType.ProcessInstance.isAccessible()){

        query = 'SELECT Id, TargetObjectId, ProcessDefinitionId, LastActor.Name, '
                + ' (SELECT Id, toLabel(StepStatus) StepStatus,Actor.Name, Comments, CreatedDate, ProcessNode.Name, OriginalActor.Name FROM StepsAndWorkitems ORDER BY CreatedDate DESC, ProcessNode.Name NULLS LAST)'
                + ' FROM ProcessInstance WHERE TargetObjectId in :invoiceIds ORDER BY CreatedDate DESC';
        return (List<ProcessInstance>) Database.query(query);
        }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

        return null;
    }

    public static List<ProcessInstance> selectLastInvoiceWorkingItem(Set<Id> invoiceIds){
        String query = 'SELECT Id, TargetObjectId, '
                + ' (SELECT Id, StepStatus,Actor.Name, Comments, CreatedDate, ProcessNode.Name FROM StepsAndWorkitems where StepStatus = \'Pending\' ORDER BY CreatedDate DESC LIMIT 1)'
                + ' FROM ProcessInstance WHERE TargetObjectId in :invoiceIds';
         List<ProcessInstance> listInvoice;

        if(Schema.sObjectType.ProcessInstance.isAccessible()){

        listInvoice = (List<ProcessInstance>) Database.query(query);

         }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;
    }

    public static List<ProcessInstance> selectPendingProcessInstances(Set<Id> invoiceIds){
        String query = 'SELECT Id, TargetObjectId ' +
                'FROM ProcessInstance ' +
                'WHERE TargetObjectId IN :invoiceIds ' +
                'AND Status = \'Pending\'';
         List<ProcessInstance> listInvoice;

        if(Schema.sObjectType.ProcessInstance.isAccessible()){

        listInvoice = (List<ProcessInstance>) Database.query(query);


         }else{
            throw new FieloException(Label.CannotAccessRecords);
          }

          return listInvoice;
    }
}