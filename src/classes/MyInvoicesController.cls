public class MyInvoicesController {
	@auraEnabled
	public static List<SObject> getInvoices(List<String> fieldsInvoices, Id memberId, String whereClause, Integer quantity, Integer offset, String orderBy) {
        try{
            Map<String, DescribeFieldResult> fieldsDescribeMap = AuraService.getFieldsDescribe('FieloPRP__Invoice__c', fieldsInvoices);
            Set<String> fieldsInvoicesSet = new Set<String>(fieldsInvoices);
            fieldsInvoicesSet.add('Id');
            String fieldType;
            for (String fieldName: fieldsInvoicesSet) {
                if (fieldsDescribeMap.containsKey(fieldName)) {
                    fieldType = fieldsDescribeMap.get(fieldName).getType().name().toLowerCase();
                    if (fieldType == 'reference') {
                        fieldsInvoicesSet.add(fieldName.replace('__c','__r') + '.Name');
                    }
                    if (fieldType == 'picklist') {
                        fieldsInvoicesSet.add('toLabel(' + fieldName + ') ' + fieldName.replace('__c','__label'));
                    }
                }
                if (fieldName == 'FieloPRP__InvoiceItems__r') {
                    fieldsInvoicesSet.add('(SELECT Id FROM FieloPRP__InvoiceItems__r) Products');
                }
                if (fieldName == 'FieloPRP__Transactions__r') {
                    fieldsInvoicesSet.add('(SELECT Id FROM FieloPRP__Transactions__r) Transactions');
                }
                if (fieldName == 'FieloPRP__Trackers__r') {
                    fieldsInvoicesSet.add('(SELECT Id FROM FieloPRP__Trackers__r) Trackers');
                }
            }

            if (fieldsInvoicesSet.contains('FieloPRP__InvoiceItems__r')) {
                fieldsInvoicesSet.remove('FieloPRP__InvoiceItems__r');
            }

            System.debug('whereClause = ' + whereClause);
            List<SObject> myInvoices = InvoiceService.getInvoices(
            	fieldsInvoicesSet,
            	memberId,
            	whereClause,
            	quantity,
            	offset,
            	orderBy
            );
            for(SObject invoice: myInvoices) {
                if (invoice.get('FieloPRP__InvoiceNumber__c') == null) {
                    invoice.put('FieloPRP__InvoiceNumber__c', invoice.get('Name')) ;
                }
                for (Object fieldNameObject: invoice.getPopulatedFieldsAsMap().keySet()) {
                    String fieldName = String.valueOf(fieldNameObject);
                    System.debug(fieldName);
                    if (fieldsDescribeMap.containsKey(fieldName)) {
                        fieldType = fieldsDescribeMap.get(fieldName).getType().name().toLowerCase();
                        System.debug(fieldType);
                        if (fieldType == 'reference') {
                            if (invoice.getSObject(fieldName.replace('__c','__r')) != null) {
                                if (invoice.getSObject(fieldName.replace('__c','__r')).get('Name') != null) {
                                    invoice.put(fieldName, invoice.getSObject(fieldName.replace('__c','__r')).get('Name'));
                                }
                            }
                        }
                    }
                    if (fieldName == 'Products') {
                        if (invoice.getSObjects('FieloPRP__InvoiceItems__r') != null) {
                            List<SObject> products = invoice.getSObjects('FieloPRP__InvoiceItems__r');
                            invoice.put('FieloPRP__InvoiceItems__r', '(' + products.size() + ')');
                        }
                    }
                }
            }
            return myInvoices;     
        } catch(DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @auraEnabled    
    public static Map<String, map<String, String>> getPicklistsValues(List<String> listPicklistsToTranslate){
        if(listPicklistsToTranslate == null || listPicklistsToTranslate.isEmpty()){return null;}

        map<String, map<String, String>> mapPicklistsValues = new map<String, map<String, String>>();

        for(String picklistAPIName: listPicklistsToTranslate){
            if(Invoice__c.sObjectType.getDescribe().fields.getMap().containsKey(picklistAPIName.toLowerCase())){
                Schema.Describefieldresult dfield = (Invoice__c.sObjectType.getDescribe().fields.getMap().get(picklistAPIName.toLowerCase())).getDescribe();
                if(String.ValueOf(dfield.getType()).toLowerCase() == 'picklist'){
                    mapPicklistsValues.put(picklistAPIName, new map<String, String>());
                    for (Schema.PicklistEntry pValues: dfield.getPicklistValues()) {
                        mapPicklistsValues.get(picklistAPIName).put(pValues.getValue(), pValues.getLabel());
                    }
                }
            }
        }

        return mapPicklistsValues;
    }

}