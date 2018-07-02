public with sharing class InvoiceItems extends SObjectDomain {
    public static Boolean totalPriceChanged = false;
    public static Boolean totalPriceZero = false;
    public static Boolean unitPriceChanged = false;
    public static Boolean unitPriceZero = false;
    public static Boolean quantityChanged = false;
    public static Boolean quantityZero = false;

    public static Double newQuantity;
    public static Double newTotalPrice;
    public static Double newUnitPrice;
    public static Double oldQuantity;
    public static Double oldTotalPrice;
    public static Double oldUnitPrice;

    public static Boolean validateAdminFields = true;
    public static Boolean runningAsAdmin = false;

    public static Set<Id> processedIds = new Set<Id>();

    public InvoiceItems(List<InvoiceItem__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<SObject> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                InvoiceService.enableAdminPermission(true);
                InvoiceItems.runningAsAdmin = true;
            }
            return new InvoiceItems(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){

            if(item.Quantity__c==null){
                item.Quantity__c=0.0;
            }
            if(item.TotalPrice__c==null){
                item.TotalPrice__c=0.0;
            }
            if(item.UnitPrice__c==null){
                item.UnitPrice__c=0.0;   
            }
        }
    }

    public override void onValidate(){
        if (validateAdminFields) {
           Set<Id> invoiceIds = new Set<Id>();
            for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
                invoiceIds.add(item.Invoice__c);
            }

            Map<Id,Invoice__c> invoices = new Map<Id,Invoice__c>(new InvoicesSelector().selectById(invoiceIds));

            for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
                if(invoices.containsKey( item.Invoice__c )){
                    if( !invoices.get(item.Invoice__c).HasDetails__c )
                        item.addError(Label.InvoiceDetailInsertDisabled);

                    //Init and Defaults Prices and Quantity Fields
                    setPriceFields(item,null);

                    //Vars set by the method setPriceFields
                    totalPriceZero = newTotalPrice == 0.0;
                    quantityZero = newQuantity == 0.0;
                    unitPriceZero = newUnitPrice == 0.0;

                    //All zero
                    if( totalPriceZero && quantityZero && unitPriceZero ){
                        item.addError( Label.AllPriceFieldsZero );
                    }

                    //Only Unit Price is set
                    else if( totalPriceZero && quantityZero && !unitPriceZero ){
                        item.addError( Label.TotalPriceAndQuantityZero );
                    }

                    //Quantity is negative
                    else if(newQuantity < 0){
                        item.addError( Label.QuantityGreaterThanZero );
                    }

                    //UnitPrice is negative
                    else if(newUnitPrice < 0){
                        item.addError( Label.UnitPriceGreaterThanZero );
                    }
                }
            } 
        }
    }

    public override void onValidate( Map<Id,SObject> existingRecords ){
        if (validateAdminFields) {
            for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
                //Init and Defaults Prices and Quantity Fields
                setPriceFields(item,null);

                //Vars set by the method setPriceFields
                totalPriceZero = newTotalPrice == 0.0;
                quantityZero = newQuantity == 0.0;
                unitPriceZero = newUnitPrice == 0.0;

                //All zero
                if( totalPriceZero && quantityZero && unitPriceZero ){
                    item.addError( Label.AllPriceFieldsZero );
                }

                //Only Unit Price is set
                else if( totalPriceZero && quantityZero && !unitPriceZero ){
                    item.addError( Label.TotalPriceAndQuantityZero );
                }

                //Quantity is negative
                else if(newQuantity < 0){
                    item.addError( Label.QuantityGreaterThanZero );
                }

                //UnitPrice is negative
                else if(newUnitPrice < 0){
                    item.addError( Label.UnitPriceGreaterThanZero );
                }
            }

            Map<Id, InvoiceItem__c> itemsWithPendingInvoice = new Map<Id,InvoiceItem__c>(
                new InvoiceItemsSelector().selectByIdWithInvoiceStatusNotEditable( new Map<Id,InvoiceItem__c>( (List<InvoiceItem__c>)records ).keySet() )
                );

            for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
                if( !itemsWithPendingInvoice.containsKey(item.Id) ){
                    item.addError( Label.DraftNotEditable );
                }
            }
        }
    }

    public override void onAfterInsert() {
        Set<Id> invoiceIds = new Set<Id>();

        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            //Add all new items, no check needed
            invoiceIds.add(item.Invoice__c);

        }

        if(!invoiceIds.isEmpty()){
            List<Invoice__c> invoicesList = new InvoicesSelector().selectById(invoiceIds);
            Map<Id,Invoice__c> mapInvoices = new Map<Id, Invoice__c>(invoicesList);

            for( InvoiceItem__c item: (List<InvoiceItem__c>)records ){
                if(mapInvoices.containsKey(item.Invoice__c))
                    mapInvoices.get(item.Invoice__c).Amount__c = mapInvoices.get(item.Invoice__c).Amount__c != null
                        ? mapInvoices.get(item.Invoice__c).Amount__c + item.TotalPrice__c
                        : item.TotalPrice__c;

                    mapInvoices.get(item.Invoice__c).Amount__c = mapInvoices.get(item.Invoice__c).Amount__c.setScale(2);
            }

            if(invoicesList.size()>0){
                try{
                    if (!runningAsAdmin && validateAdminFields) {
                        InvoiceService.enableAdminPermission(true);
                    }

                    SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});
                    uow.registerDirty(invoicesList);
                    if (Schema.sObjectType.Invoice__c.isUpdateable()) {
                        uow.commitWork();
                    } else {
                        throw new FieloException(String.format(Label.PermissionOnObject,new List<String>{'FieloPRP__Invoice__c'}));
                    }

                    if (!runningAsAdmin && !validateAdminFields) {
                        InvoiceService.enableAdminPermission(false);
                    }
                }catch(Exception e){
                    InvoiceService.enableAdminPermission(false);
                    throw e;
                }
                
            }
        }
    }

    public override void onBeforeInsert(){
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            
            //Init and Defaults Prices and Quantity Fields
            setPriceFields(item,null);

            //Vars set by the method setPriceFields
            totalPriceZero = newTotalPrice == 0.0;
            quantityZero = newQuantity == 0.0;
            unitPriceZero = newUnitPrice == 0.0;

            if( !(!totalPriceZero && quantityZero && unitPriceZero) ){

                //UnitPrice and Quantity set
                if( !quantityZero && !unitPriceZero ){
                    item.TotalPrice__c = newQuantity * newUnitPrice;
                }
                
                //Total Price and Unit Price set
                else if( !totalPriceZero && quantityZero && !unitPriceZero ){
                    item.Quantity__c = newTotalPrice / newUnitPrice;
                }
                
                //Quantity and Total Price set
                else if( !totalPriceZero && !quantityZero && unitPriceZero ){
                    item.UnitPrice__c = newTotalPrice / newQuantity;
                }
                
            }
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            if(item.TotalPrice__c==null)
                item.TotalPrice__c = 0.0;
            if(item.Quantity__c==null)
                item.Quantity__c = 0.0;
            if(item.UnitPrice__c==null)
                item.UnitPrice__c = 0.0;

            //Init and Defaults Prices and Quantity Fields
            setPriceFields(item,((InvoiceItem__c)existingRecords.get(item.Id)));

            //Vars set by the method setPriceFields
            totalPriceZero = newTotalPrice == 0.0;
            quantityZero = newQuantity == 0.0;
            unitPriceZero = newUnitPrice == 0.0;

            totalPriceChanged = newTotalPrice != oldTotalPrice;
            unitPriceChanged = newUnitPrice != oldUnitPrice;
            quantityChanged = newQuantity != oldQuantity;

            if( totalPriceChanged || unitPriceChanged || quantityChanged ){

                //Only Total Price Changed, but unitprice and quantity are set
                if( totalPriceChanged && !unitPriceChanged && !quantityChanged ){
                    if( !quantityZero || !unitPriceZero )
                        item.TotalPrice__c = newQuantity * newUnitPrice;
                }

                //Only Quantity is changed
                if( !totalPriceChanged && !unitPriceChanged && quantityChanged ){
                    item.TotalPrice__c = newQuantity * newUnitPrice;
                }

                //Quantity and Total Price are changed
                else if( totalPriceChanged && !unitPriceChanged && quantityChanged ){
                    if( !quantityZero ) {
                        item.UnitPrice__c = newTotalPrice / newQuantity;
                    } else {
                        if (validateAdminFields) {
                            item.addError( Label.QuantityZero );
                        }
                    }
                }

                //Only Unit Price is changed
                else if( !totalPriceChanged && unitPriceChanged ){
                    item.TotalPrice__c = newQuantity * newUnitPrice;
                }

                //Total Price and Unit Price are changed
                else if( totalPriceChanged && unitPriceChanged && !quantityChanged ){
                    if( !unitPriceZero ) {
                        item.Quantity__c = newTotalPrice / newUnitPrice;
                    }
                    else {
                        if (validateAdminFields) {
                            item.addError( Label.UnitPriceZero );
                        }
                    }
                }

                //Everything changed
                else if( totalPriceChanged && unitPriceChanged && quantityChanged ){
                    if( !totalPriceZero && quantityZero && unitPriceZero)
                        item.TotalPrice__c = newTotalPrice;
                    else
                        item.TotalPrice__c = newQuantity * newUnitPrice;
                }
            }
        }
    }    

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        Set<Id> itemIds = new Set<Id>();

        //Check for updates that may affect TotalPrice
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            //Add only updated items.
            if( item.TotalPrice__c != ((InvoiceItem__c)existingRecords.get(item.Id)).TotalPrice__c ){
                itemIds.add(item.Id);
            }
            
        }

        if(!itemIds.isEmpty()){
            //Method that returns the invoices with its related data
            List<Invoice__c> invoices = new InvoicesSelector().selectByItemIdWithItemInfo(itemIds);

            //Method to update the amount of a given Invoice List.
            //this method is used in afterInsert, afterUpdate and afterDelete methods
            updateInvoiceAmount(invoices);
        }
    }

    public override void onBeforeDelete(){
        if(validateAdminFields){
            Set<Id> invoiceIds = new Set<Id>();
            for(InvoiceItem__c item : (List<InvoiceItem__c>)records){
                if(item.Invoice__c != null){
                    invoiceIds.add(item.Invoice__c);                
                }
            }

            Map<Id,Invoice__c> invoicesMap = new Map<Id,Invoice__c>(new InvoicesSelector(new Set<String>{'FieloPRP__Status__c'}).selectById(invoiceIds));
            for(InvoiceItem__c item : (List<InvoiceItem__c>)records){
                if(item.Invoice__c != null && invoicesMap.get(item.Invoice__c).Status__c != 'Open' && invoicesMap.get(item.Invoice__c).Status__c != 'New'){
                    item.addError(Label.DraftNotEditable);
                }
            }
        }
    }

    public override void onAfterDelete() {
        Set<Id> invoiceIds = new Set<Id>();

        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            //Add all new items, no check needed
            invoiceIds.add(item.Invoice__c);

        }

        if(!invoiceIds.isEmpty()){
            List<Invoice__c> invoicesList = new InvoicesSelector().selectById(invoiceIds);
            Map<Id,Invoice__c> mapInvoices = new Map<Id, Invoice__c>(invoicesList);

            for( InvoiceItem__c item: (List<InvoiceItem__c>)records ){
                mapInvoices.get(item.Invoice__c).Amount__c -= item.TotalPrice__c;
                mapInvoices.get(item.Invoice__c).Amount__c = mapInvoices.get(item.Invoice__c).Amount__c.setScale(2);
            }

            if(invoicesList.size()>0){
                try{
                    if (!runningAsAdmin && validateAdminFields) {
                        InvoiceService.enableAdminPermission(true);
                    }
                    SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});
                    uow.registerDirty(invoicesList);
                    if (Schema.sObjectType.Invoice__c.isUpdateable()) {
                        uow.commitWork();
                    } else {
                        throw new FieloException(String.format(Label.PermissionOnObject,new List<String>{'FieloPRP__Invoice__c'}));
                    }
                    
                    if (!runningAsAdmin && !validateAdminFields) {
                        InvoiceService.enableAdminPermission(false);
                    } 
                }catch(Exception e){
                    InvoiceService.enableAdminPermission(false);
                    throw e;
                }
            }
        }
    }

    /* This method receive a List of Invoice and it's related data and recalculates
        the Amount field.
    */
    public static void updateInvoiceAmount( List<Invoice__c> invoicesList ){
        List<InvoiceItem__c> items = new List<InvoiceItem__c>();
        for(Invoice__c invoice: invoicesList){
            invoice.Amount__c=0;
            for(InvoiceItem__c invoiceItem: invoice.InvoiceItems__r){
                invoice.Amount__c += invoiceItem.TotalPrice__c;
            }
            invoice.Amount__c = invoice.Amount__c.setScale(2);
        }

        if(invoicesList.size()>0){
            try{
                if (!runningAsAdmin && validateAdminFields) {
                    InvoiceService.enableAdminPermission(true);
                }
                SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});
                uow.registerDirty(invoicesList);
                if (Schema.sObjectType.Invoice__c.isUpdateable()) {
                        uow.commitWork();
                } else {
                    throw new FieloException(String.format(Label.PermissionOnObject,new List<String>{'FieloPRP__Invoice__c'}));
                }

                if (!runningAsAdmin && !validateAdminFields) {
                    InvoiceService.enableAdminPermission(false);
                }
            }catch(Exception e){
                InvoiceService.enableAdminPermission(false);
                throw e;
            }
            
        }
    }

    /* This function initiates the vars that contains the fields 
        that validation is needed:
         - TotalPrice__c, Quantity__c and UnitPrice__c
    */
    public static void setPriceFields(InvoiceItem__c newItem, InvoiceItem__c oldItem){
        if(newItem!=null){
            newQuantity = newItem.Quantity__c != null ? newItem.Quantity__c : 0.0;
            newTotalPrice = newItem.TotalPrice__c != null ? newItem.TotalPrice__c : 0.0;
            newUnitPrice = newItem.UnitPrice__c != null ? newItem.UnitPrice__c : 0.0;    
        }

        if(oldItem!=null){
            oldQuantity = oldItem.Quantity__c != null ? oldItem.Quantity__c : 0.0;
            oldTotalPrice = oldItem.TotalPrice__c != null ? oldItem.TotalPrice__c : 0.0;
            oldUnitPrice = oldItem.UnitPrice__c != null ? oldItem.UnitPrice__c : 0.0;
        }
    }
}