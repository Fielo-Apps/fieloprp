@isTest
private with sharing class InvoiceItemsControllerTest {
	@istest public static void InvoiceItemsControllerTest() {
		Map<String, Object> objectInfo = 
			(Map<String, Object>) JSON.deserializeUntyped(
				InvoiceItemsController.getFieldData(
					'FieloPRP__InvoiceItem__c',
					'FieloPRP__Product__c,FieloPRP__Quantity__c,FieloPRP__UnitPrice__c,FieloPRP__TotalPrice__c',
					'FieloPRP__Product__c', 'IsActive = true'
				)
			);
		List<Object> fieldsInfoObj = (List<Object>) objectInfo.get('fields');

		System.assertEquals(4, fieldsInfoObj.size());
	}
}