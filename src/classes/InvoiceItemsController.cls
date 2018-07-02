public class InvoiceItemsController {
	@auraEnabled
	public static String getFieldData(String objectName, String fieldNames, String productFieldName, String productInjectQuery) {
		try{
			Map<String, Object> objectInfo = new Map<String, Object>();
			List<Object> fieldsInfoObj = new List<Object>();
			List<Map<String, Object>> newfieldsInfo = new List<Map<String, Object>>();
			Map<String, Object> fieldMeta;
			Map<String, Object> fieldAttributes;

			objectInfo = (Map<String, Object>) JSON.deserializeUntyped(AuraService.getFieldData(objectName,fieldNames));
			fieldsInfoObj = (List<Object>) objectInfo.get('fields');

			for (Object fieldMetaObject: fieldsInfoObj) {
				fieldMeta = (Map<String, Object>) fieldMetaObject;
				fieldAttributes = (Map<String, Object>) fieldMeta.get('attributes');
				if (String.valueOf(fieldAttributes.get('name')) == 'FieloPRP__TotalPrice__c' ||
					String.valueOf(fieldAttributes.get('name')) == 'FieloPRP__UnitPrice__c' ||
					String.valueOf(fieldAttributes.get('name')) == 'FieloPRP__Quantity__c') {
					fieldAttributes.put('min', (Object) 0);
				}
				if ( String.valueOf(fieldAttributes.get('name')) == productFieldName) {
					if (productInjectQuery != '' && productInjectQuery != null) {
						fieldAttributes.put('whereCondition', (Object) productInjectQuery);
					}
				}
				fieldMeta.put('attributes', (Object) fieldAttributes);
				newfieldsInfo.add(fieldMeta);
			}
			objectInfo.put('fields', (Object) newfieldsInfo);
            return JSON.serialize(objectInfo);
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
	}
}