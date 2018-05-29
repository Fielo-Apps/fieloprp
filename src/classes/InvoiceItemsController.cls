public class InvoiceItemsController {
	@auraEnabled
	public static String getFieldData(String objectName, String fieldNames) {
		return AuraService.getFieldData(objectName,fieldNames);
	}
}