public with sharing class Invoices extends SObjectDomain {
    
    public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;
    public static Decimal newAmount;
    public static Decimal oldAmount;
    public static String newStatus;
    public static String oldStatus;
    public static String newDate;
    public static String oldDate;
    public static String newInvoiceNumber;
    public static String oldInvoiceNumber;
    public static Boolean amountHasChanged;
    public static Boolean dateHasChanged;
    public static Boolean invoiceNumberHasChanged;
    public static Set<Id> approvedInvoicesId = new Set<Id>();

    public Invoices(List<Invoice__c> records) {
        super(records);
    }

    public override void onAfterInsert() {
        FieloPLT.SObjectService.processRecords((List<Invoice__c>) Records, null);
    }

    public override void onValidate(){
        if(validateAdminFields){
            Set<Id> memberIds = new Set<Id>();
            for(Invoice__c invoice: (List<Invoice__c>)records){
                if(invoice.Member__c!=null)
                    memberIds.add(invoice.Member__c);
            }

            Map<Id,FieloPLT__Member__c> disabledUpdateMembers = new Map<Id, FieloPLT__Member__c>( new MembersSelector().selectByIdAndProgramWithDetailedInvoiceFalse(memberIds));

            for(Invoice__c invoice: (List<Invoice__c>)records){
                if( invoice.Amount__c != null && invoice.Amount__c != 0.0 )
                    if(invoice.Member__c!=null)
                        if( !disabledUpdateMembers.containsKey( invoice.Member__c ) ) {
                            invoice.addError( Label.AmountUpdateDisabled );
                        } else {
                            if (invoice.Amount__c < 0.0) {
                                invoice.addError( Label.NegativeAmount );
                            }
                        }
                            
                if( invoice.Date__c == null ) {
                    invoice.addError( Label.DateFieldNull );
                } else if ( invoice.Date__c > System.today() ){
                    invoice.addError( Label.FutureDateField );
                }
            }
            getDuplicatedRecords(records);
        }
    }

    public override void onValidate( Map<Id,SObject> existingRecords ){
        if(validateAdminFields){
            Map<Id,Invoice__c> disabledUpdateinvoices = new Map<Id, Invoice__c>( new InvoicesSelector().selectByItemIdWithDetailedInvoiceDisabled(new Map<Id,Invoice__c>((List<Invoice__c>)records).keyset()));

            for(Invoice__c invoice: (List<Invoice__c>)records){
                newAmount = invoice.Amount__c!=null ? invoice.Amount__c : 0.0;
                oldAmount = ((Invoice__c)existingRecords.get(invoice.Id)).Amount__c!=null ? ((Invoice__c)existingRecords.get(invoice.Id)).Amount__c : 0.0;

                newDate = invoice.Date__c!=null ? String.valueOf(invoice.Date__c): '';
                oldDate = ((Invoice__c)existingRecords.get(invoice.Id)).Date__c!=null ? String.valueOf(((Invoice__c)existingRecords.get(invoice.Id)).Date__c) : '';

                newInvoiceNumber = invoice.InvoiceNumber__c != null ? invoice.InvoiceNumber__c : '';
                oldInvoiceNumber = ((Invoice__c)existingRecords.get(invoice.Id)).InvoiceNumber__c != null ? ((Invoice__c)existingRecords.get(invoice.Id)).InvoiceNumber__c : '';

                amountHasChanged = newAmount != oldAmount;
                dateHasChanged = newDate != oldDate;
                invoiceNumberHasChanged = newInvoiceNumber != oldInvoiceNumber;

                if( newAmount.setScale(2) != oldAmount.setScale(2) )
                    if( !disabledUpdateinvoices.containsKey( invoice.Id ) )
                        invoice.addError( Label.AmountUpdateDisabled );

                if( invoice.HasDetails__c != ((Invoice__c)existingRecords.get(invoice.Id)).HasDetails__c )
                    invoice.addError( Label.HasDetailsNotEditable );

                if( ((Invoice__c)existingRecords.get(invoice.Id)).Status__c != 'Open' ){
                    if( amountHasChanged || dateHasChanged || invoiceNumberHasChanged )
                        invoice.addError( Label.DraftNotEditable );
                }

                if( invoice.Date__c == null ) {
                    invoice.addError( Label.DateFieldNull );
                } else if ( invoice.Date__c > System.today() ){
                    invoice.addError( Label.FutureDateField );
                }

                if( newAmount == 0.0 &&
                    invoice.Status__c != 'Open' &&
                    invoice.Status__c != 'New') {
                    invoice.addError( Label.ZeroAmount );
                }

                if (newAmount < 0.0) {
                    invoice.addError( Label.NegativeAmount );
                }

                String priorValue = ((Invoice__c)existingRecords.get(invoice.Id)).Status__c;
                String currentStatus = invoice.Status__c;

                if (currentStatus != priorValue &&
                    !(priorValue == 'Open' && currentStatus == 'Pending For Approval') &&
                    !(priorValue == 'Open' && currentStatus == 'Approved') &&
                    !(priorValue == 'Open' && currentStatus == 'Rejected') &&
                    !(priorValue == 'Pending For Approval' && currentStatus == 'Approved') &&
                    !(priorValue == 'Pending For Approval' && currentStatus == 'Rejected') &&
                    !(priorValue == 'Approved' && currentStatus == 'Canceled') &&
                    !(priorValue == 'Rejected' && currentStatus == 'Open') &&
                    !(priorValue == 'Canceled' && currentStatus == 'Approved') &&
                    !(priorValue == 'Canceled' && currentStatus == 'Open')
                    ) {
                    invoice.addError( Label.InvalidStatusChange );
                }

                if(!approvedInvoicesId.contains(invoice.Id)){
                    if(invoice.ApprovedDate__c != ((Invoice__c)existingRecords.get(invoice.Id)).ApprovedDate__c){
                        invoice.ApprovedDate__c = ((Invoice__c)existingRecords.get(invoice.Id)).ApprovedDate__c;
                    }

                }
            }
            getDuplicatedRecords(records);
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
        for (Invoice__c invoice: (List<Invoice__c>)records){
            if (invoice.Status__c == 'Open' && ((Invoice__c)existingRecords.get(invoice.Id)).Status__c != 'Open') {
                invoice.RejectReason__c = '';
                invoice.Comments__c = '';
            }
            if (invoice.Status__c == 'Approved' && ((Invoice__c)existingRecords.get(invoice.Id)).Status__c != 'Approved') {
                invoice.ApprovedDate__c = System.now();
                approvedInvoicesId.add(invoice.Id);
            }
            if (invoice.Status__c != 'Approved' && ((Invoice__c)existingRecords.get(invoice.Id)).Status__c == 'Approved') {
                invoice.ApprovedDate__c = null;
            }


        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        List<Invoice__c> recordsToProcess = new List<Invoice__c>();
        Map<Id,Invoice__c> mapExistingRecordsToProcess = new Map<Id,Invoice__c>();
        Set<Id> recordsToRevert = new Set<Id>();

        for(Invoice__c record : (List<Invoice__c>)records){
            if(!processedIds.contains(record.Id)){
                recordsToProcess.add(record);
                mapExistingRecordsToProcess.put(record.Id,(Invoice__c)existingRecords.get(record.Id));
                processedIds.add(record.Id);
            }

            newStatus = record.Status__c;
            oldStatus = ((Invoice__c)existingRecords.get(record.Id)).Status__c;

            if(oldStatus == 'Approved' && newStatus == 'Canceled'){
                recordsToRevert.add(record.Id);
            }
        }
        if(!recordsToProcess.isEmpty()){
            FieloPLT.SObjectService.processRecords(recordsToProcess, mapExistingRecordsToProcess);
        }
        if(!recordsToRevert.isEmpty()){
            revertInvoices(recordsToRevert);
        }
    }

    public override void onApplyDefaults() {
        Set<Id> memberIds = new Set<Id>();
        for(Invoice__c invoice: (List<Invoice__c>)records){
            memberIds.add(invoice.Member__c);
        }

        Map<Id,FieloPLT__Member__c> detailessInvoiceMembers = new Map<Id, FieloPLT__Member__c>( new MembersSelector().selectByIdAndProgramWithDetailedInvoiceFalse(memberIds));

        for(Invoice__c record : (List<Invoice__c>)records){
            if(record.Status__c == null){
                record.Status__c = 'Open';
            }

            record.HasDetails__c = !detailessInvoiceMembers.containsKey( record.Member__c );
        }
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<SObject> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                InvoiceService.enableAdminPermission(true);
            }
            return new Invoices(sObjectList);
        }
    }

    public override void onBeforeDelete(){
        deleteInvoiceItems((List<Invoice__c>) Records);
        deleteFiles((List<Invoice__c>) Records);
    }

    public static void deleteInvoiceItems(List<Invoice__c> invoices){
        try{
            if (validateAdminFields) {
                InvoiceService.enableAdminPermission(true);
                SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{InvoiceItem__c.SObjectType});
                uow.registerDeleted([SELECT Id FROM InvoiceItem__c WHERE Invoice__c IN : invoices]);
                if (Schema.sObjectType.Invoice__c.isDeletable()) {
                    uow.commitWork();
                } else {
                    throw new FieloException(String.format(Label.PermissionOnObject,new List<String>{'FieloPRP__InvoiceItem__c'}));
                }
                InvoiceService.enableAdminPermission(false);
            }
        }catch(Exception e){
            InvoiceService.enableAdminPermission(false);
            for(Invoice__c invoice: invoices){
                invoice.addError(e.getMessage());
            }
        }
    }

    public static void deleteFiles(List<Invoice__c> invoices){
        List<Invoice__c> existingInvoices = new InvoicesSelector(new Set<String>{'Id'}).selectByIdWithDocuments(new Map<Id,Invoice__c>(invoices).keySet());
        Set<Id> documentIds = new Set<Id>();
        for (Invoice__c invoice:existingInvoices) {
            if (!invoice.ContentDocumentLinks.isEmpty()) {
                for (ContentDocumentLink cdl: invoice.ContentDocumentLinks) {
                    documentIds.add(cdl.ContentDocument.Id);
                }
            }
        }
        String query = 'SELECT Id FROM ContentDocument WHERE Id in :documentIds';
        List<ContentDocument> documents = Database.query(query);
        if(ContentDocument.SObjectType.getDescribe().isDeletable()){
            delete documents;
        }
    }

    public static void revertInvoices(Set<Id> invoiceIds){
        List<Id> idsToRevert = new List<Id>(new Map<Id,FieloPLT__Transaction__c>(new TransactionsSelector().selectByInvoiceIdAndNotReverted(invoiceIds)).keySet());
        if(!idsToRevert.isEmpty())
            FieloPLT.TransactionService.revertTransactions( idsToRevert );
    }

    private static void getDuplicatedRecords(List<Invoice__c> invoices) {
    
        String className = 'InvoiceDuplicateDefault';
        if (!String.isBlank(FieloPLT__PublicSettings__c.getOrgDefaults().InvoiceDuplicateClass__c)) {
            className = FieloPLT__PublicSettings__c.getOrgDefaults().InvoiceDuplicateClass__c;
        }
        
        Type t = Type.forName(className);
        InvoiceDuplicateInterface reflInstance = (InvoiceDuplicateInterface)t.newInstance();
        
        reflInstance.setUniqueKey(invoices, Trigger.isUpdate);        
        reflInstance.validateDuplicates(invoices, Trigger.isUpdate);
    }
}