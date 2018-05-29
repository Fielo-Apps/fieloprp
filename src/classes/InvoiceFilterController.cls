public class InvoiceFilterController {
	@AuraEnabled
	public static String getFieldData(String objectName, String fieldNames, String rangedFields) {
		try{
			Set<String> rangedFieldSet = new Set<String>(rangedFields != '' && rangedFields != null ? rangedFields.split(',') : new List<String>());
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
				if (!fieldAttributes.containsKey('isRanged')) {
					fieldAttributes.put('isRanged', (Object) String.valueOf(rangedFieldSet.contains(String.valueOf(fieldAttributes.get('name')))));
					if (rangeLabel.containsKey(String.valueOf(fieldAttributes.get('type')))) {
						fieldAttributes.put('rangeLabel', (Object) String.valueOf(rangeLabel.get(String.valueOf(fieldAttributes.get('type')))));	
					} else {
						fieldAttributes.put('rangeLabel', (Object) Label.RangeSuffix);
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

	public static Map<String, String> rangeLabel {get{
		if (rangeLabel == null) {
			rangeLabel = new Map<String, String>{
				'currency' => Label.CurrencyRangeSuffix,
        		'double' => Label.DoubleRangeSuffix,
        		'percent' => Label.PercentRangeSuffix,
        		'date' => Label.DateRangeSuffix,
        		'datetime' => Label.DatetimeRangeSuffix
			};
		}
		return rangeLabel;
	} set; }
}