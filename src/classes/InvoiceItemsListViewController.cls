public class InvoiceItemsListViewController {
	
	@AuraEnabled
    public static String getFieldData(String objectName, String fieldNames) {
        try{
            return AuraService.getFieldData(objectName,fieldNames);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }

	@AuraEnabled
	public static List<SObject> getItems(String itemFields, String invoiceId, Integer quantity, Integer offset, String orderBy) {
        try{
			Map<String, DescribeFieldResult> fieldsDescribeMap = AuraService.getFieldsDescribe('FieloPRP__InvoiceItem__c', itemFields!='' && itemFields!=null ? itemFields.split(',') : new List<String>());
	        Set<String> itemsFieldSet = new Set<String>(itemFields!='' && itemFields!=null ? itemFields.split(',') : new List<String>());
	        itemsFieldSet.add('Id');
	        String fieldType;
	        for (String fieldName: itemsFieldSet) {
	            if (fieldsDescribeMap.containsKey(fieldName)) {
	                fieldType = fieldsDescribeMap.get(fieldName).getType().name().toLowerCase();
	                if (fieldType == 'reference') {
	                    itemsFieldSet.add(fieldName.replace('__c','__r') + '.Name');
	                }
	                if (fieldType == 'picklist') {
	                    itemsFieldSet.add('toLabel(' + fieldName + ') ' + fieldName.replace('__c','__label'));
	                }
	            }
	        }

	        InvoiceItemsSelector selector = new InvoiceItemsSelector(itemsFieldSet);
	        selector.setOrderBy(orderBy);
	        selector.setLimit(quantity);
	        selector.setOffset(offset);
	        List<SObject> items = (List<SObject>) selector.selectByInvoiceId(new Set<Id>{invoiceId}, new Set<Id>());

	        for(SObject item: items) {
		        for (Object fieldNameObject: item.getPopulatedFieldsAsMap().keySet()) {
	                String fieldName = String.valueOf(fieldNameObject);
	                System.debug(fieldName);
	                if (fieldsDescribeMap.containsKey(fieldName)) {
	                    fieldType = fieldsDescribeMap.get(fieldName).getType().name().toLowerCase();
	                    System.debug(fieldType);
	                    if (fieldType == 'reference') {
	                        if (item.getSObject(fieldName.replace('__c','__r')) != null) {
	                            if (item.getSObject(fieldName.replace('__c','__r')).get('Name') != null) {
	                                item.put(fieldName, item.getSObject(fieldName.replace('__c','__r')).get('Name'));
	                            }
	                        }
	                    }
	                }
	            }
	        }
	        return items;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
	}
}