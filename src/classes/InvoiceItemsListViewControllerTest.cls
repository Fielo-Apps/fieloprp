@isTest
private with sharing class InvoiceItemsListViewControllerTest {
	@istest public static void testGetFieldData() {
		Map<String, Object> objectInfo = (Map<String, Object>) JSON.deserializeUntyped(InvoiceItemsListViewController.getFieldData('FieloPRP__InvoiceItem__c', 'FieloPRP__Product__c,FieloPRP__Quantity__c,FieloPRP__UnitPrice__c,FieloPRP__TotalPrice__c'));
		List<Object> fieldsInfoObj = (List<Object>) objectInfo.get('fields');

		System.assertEquals(4, fieldsInfoObj.size());
	}

	@istest public static void testGetItems() {
		MockUpFactory.createData();

		List<Invoice__c> invoices = [SELECT Id FROM FieloPRP__Invoice__c LIMIT 1];

		List<SObject> items = InvoiceItemsListViewController.getItems(
			'FieloPRP__Product__c,FieloPRP__Quantity__c,FieloPRP__UnitPrice__c,FieloPRP__TotalPrice__c',
			invoices[0].Id,
			6,
			0,
			'CreatedDate'
		);
	}
}