@istest
private with sharing class InvoiceDetailControllerTest {
	@istest public static void testGetFieldData() {
		Map<String, Object> objectInfo = (Map<String, Object>) JSON.deserializeUntyped(InvoiceDetailController.getFieldData('FieloPRP__Invoice__c', 'FieloPRP__Status__c,FieloPRP__Date__c,FieloPRP__Amount__c,FieloPRP__Distributor__c'));
		List<Object> fieldsInfoObj = (List<Object>) objectInfo.get('fields');

		System.assertEquals(4, fieldsInfoObj.size());
	}

	@istest public static void testGetFiles() {
		MockUpFactory.createData();

		List<Invoice__c> invoices = [SELECT Id FROM FieloPRP__Invoice__c LIMIT 1];

		List<Object> files = (List<Object>) JSON.deserializeUntyped(InvoiceDetailController.getFiles(invoices[0].Id));

		System.assert(!files.isEmpty());
	}
}