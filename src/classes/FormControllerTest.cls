@isTest
private class FormControllerTest {
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

        InvoiceItem__c item = new InvoiceItem__c(
            Quantity__c = 10.0,
            UnitPrice__c = 50.0,
            Invoice__c = invoices[0].Id
        );

        insert item;

        Test.startTest();
        FormController fc = new FormController();
        fc.cRecord = invoices[0];
        fc.csObjectName = 'Invoice__c';
        fc.cFormId = '794494956';
        List<FormController.Section> mysections = new List<FormController.Section>();
		FormController.Section section = new FormController.Section();
		section.id = '2145262656';
		section.Name = 'Invoice Item';
		FormController.FormField formField = new FormController.FormField();
		formField.id='14232526';
		formField.Name = 'FieloPRP__Status__c';
		formField.Type = 'Picklist';
		formField.Required = true;
		formField.ReadOnly = true;
		formField.SearchField = 'FieloPRP__InvoiceNumber__c';
		String req = formField.getRequiredValue();
		String read = formField.getReadOnly();
		List<List<FormController.FormField>> lists = new List<List<FormController.FormField>>();
		List<FormController.FormField> forms = new List<FormController.FormField>();
		forms.add(formField);
		lists.add(forms);
		section.Rows = lists;
		mysections.add(section);
		fc.cFieldset = JSON.serialize(mysections);
		List<FormController.Section> sections = fc.sections;
		System.assertEquals('2145262656',sections[0].Id);
		Map<String, String> mapPick = fc.mapPicklistController;
		Map<String, String> mapPickValid = fc.mapPicklistValidFor;
		Map<String, String> mapOptions = fc.mapOptionsString;
		RemoteActionResult resultSave = FormController.save(invoices[0],new List<String>{'FieloPRP__Comments__c'});
		RemoteActionResult resultSave1 = FormController.save(invoices[0],new List<String>{'FieloPRP__InvoiceItem__c'});
		sObject objectReturn = FormController.retrieve('Invoice__c',invoices[0].Id,'FieloPRP__Distributor__c,FieloPRP__InvoiceNumber__c');
		Test.stopTest();
	}
	
	
}