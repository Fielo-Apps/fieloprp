@isTest
private class BackendHeaderRecordControllerTest {
	private static List<FieloPLT__Program__c> programs;
   	private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
	
	
	@isTest static void test() {
		programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        Account distributor = new Account(name = 'Fielo');
        
        insert distributor;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Distributor__c = distributor.Id;
        invoices[0].InvoiceNumber__c = '123456';

        insert invoices;

        InvoiceItem__c item = new InvoiceItem__c(
            Quantity__c = 10.0,
            UnitPrice__c = 50.0,
            Invoice__c = invoices[0].Id
        );

        insert item;

		BackendHeaderRecordController bhrc = new BackendHeaderRecordController();
		bhrc.cRecord = invoices[0];
		bhrc.csObjectName = 'Invoice__c';
		bhrc.cFieldset = '{"Name":"FieloPRP__Member__r.Name"},{"Name":"FieloPRP__Status__c"},{"Name":"FieloPRP__Amount__c"}';
		BackendHeaderRecordController.HeaderColumn head = new BackendHeaderRecordController.HeaderColumn();
		head.id='4725921962';
		head.Name='Information';
		head.Label=null;
		head.Type=null;
		List<BackendHeaderRecordController.HeaderColumn> headers = bhrc.columns;
		SObject record = bhrc.cRecord;
		RemoteActionResult result = BackendHeaderRecordController.deleteRecord(invoices[0].Id);
	}
	
	
}