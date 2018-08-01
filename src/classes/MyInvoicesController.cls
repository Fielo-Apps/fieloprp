public with sharing class MyInvoicesController {
	@AuraEnabled
	public static List<SObject> getInvoices(List<String> fieldsInvoices, Id memberId, String dynamicFilter, Integer quantity, Integer offset, String orderBy) {
        try{
            Map<String, DescribeFieldResult> fieldsDescribeMap = AuraService.getFieldsDescribe('FieloPRP__Invoice__c', fieldsInvoices);
            Set<String> fieldsInvoicesSet = new Set<String>(fieldsInvoices);
            fieldsInvoicesSet.add('Id');
            fieldsInvoicesSet.add('FieloPRP__HasDetails__c');
            fieldsInvoicesSet.add('FieloPRP__Comments__c');
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
                if (fieldName.contains('FieloPRP__Transactions__r')) {
                    fieldsInvoicesSet.add('(SELECT Id, FieloPLT__Points__c FROM FieloPRP__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) Transactions');
                }
                if (fieldName.contains('FieloPRP__Trackers__r')) {
                    fieldsInvoicesSet.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloPRP__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) Trackers');
                }
            }

            if (fieldsInvoicesSet.contains('FieloPRP__InvoiceItems__r')) {
                fieldsInvoicesSet.remove('FieloPRP__InvoiceItems__r');
            }
            if (fieldsInvoicesSet.contains('FieloPRP__Transactions__r')) {
                fieldsInvoicesSet.remove('FieloPRP__Transactions__r');
            }
            if (fieldsInvoicesSet.contains('FieloPRP__Trackers__r')) {
                fieldsInvoicesSet.remove('FieloPRP__Trackers__r');
            }
            if (fieldsInvoicesSet.contains('FieloPRP__Transactions__r,FieloPRP__Trackers__r')) {
                fieldsInvoicesSet.remove('FieloPRP__Transactions__r,FieloPRP__Trackers__r');
            }
            if (fieldsInvoicesSet.contains('FieloPRP__Trackers__r,FieloPRP__Transactions__r')) {
                fieldsInvoicesSet.remove('FieloPRP__Trackers__r,FieloPRP__Transactions__r');
            }
            
            String whereClause = dynamicFilter != '' && dynamicFilter != null ? FilterService.getDynamicWhereCondition(dynamicFilter,'FieloPRP__Invoice__c','') : '';
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

    @AuraEnabled
    public static FieloPLT__Program__c getActiveProgram(String memberId) {
        try{
            List<FieloPLT__Member__c> members = [SELECT Id, FieloPLT__Program__r.Id, FieloPLT__Program__r.FieloPRP__ProductInjectQuery__c, FieloPLT__Program__r.FieloPRP__RequestInvoiceProducts__c FROM FieloPLT__Member__c WHERE Id = :memberId];

            if (!members.isEmpty()) {
                FieloPLT__Program__c program = members[0].FieloPLT__Program__r;
                return program;
            }
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static String getFieldData(String objectName, String fieldNames) {
        try{
            Set<String> fieldsInvoicesSet = new Set<String>(fieldNames != '' && fieldNames != null ? fieldNames.split(',') : new List<String>());
            fieldsInvoicesSet.add('Id');
            fieldsInvoicesSet.add('FieloPRP__HasDetails__c');
            fieldsInvoicesSet.add('FieloPRP__Comments__c');
            return AuraService.getFieldData(objectName,String.join(new List<String>(fieldsInvoicesSet),','));
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}