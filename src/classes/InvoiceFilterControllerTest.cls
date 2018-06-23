@isTest
private with sharing class InvoiceFilterControllerTest {
	@isTest public static void InvoiceFilterControllerTest() {
		Map<String, Object> objectInfo = (Map<String, Object>) JSON.deserializeUntyped(InvoiceFilterController.getFieldData('FieloPRP__Invoice__c', 'FieloPRP__Status__c,FieloPRP__Date__c,FieloPRP__Amount__c', 'FieloPRP__Date__c,FieloPRP__Amount__c'));
		List<Object> fieldsInfoObj = (List<Object>) objectInfo.get('fields');

		//3 fields + 2 ranged fields
		System.assertEquals(5, fieldsInfoObj.size());
	}
}