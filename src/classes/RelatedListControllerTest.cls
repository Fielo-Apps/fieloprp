@isTest
private class RelatedListControllerTest {
	private static List<FieloPLT__Program__c> programs;
   	private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

	@isTest static void test_method_one() {
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

		RelatedListController controller = new RelatedListController();
		controller.cFieldset = '{"Name":"FieloPRP__Member__r.Name"},{"Name":"FieloPRP__Status__c"},{"Name":"FieloPRP__Amount__c"}';
    	controller.cDataFilters = '{"FieloPRP__Status__c":"Active"}';
    	controller.csObjectName = 'Invoice__c';
    	controller.cNameField = 'FieloPRP__Status__c';
    	controller.orderBy = 'FieloPRP__Member__r.Name';
    	controller.cRecordsPerPage = 10;
    	controller.cWhereClause = '';
    	Integer records = controller.cRecordObjectsInPage;
    	String nameField = controller.nameFieldLabel;
    	List<Object> objects = controller.cRecordObjects;
    	Boolean noRecords = controller.noRecords;
    	Boolean viewAll = controller.viewAll;
    	RemoteActionResult result = RelatedListController.deleteRecord(invoices[0].Id);
	}
	
	
}