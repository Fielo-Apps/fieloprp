@isTest
private class SectionControllerTest {
	private static List<FieloPLT__Program__c> programs;
   	private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
	
	@isTest static void testing() {
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

        Test.startTest();
		SectionController controller = new SectionController();
		controller.cRecord = invoices[0];
        controller.csObjectName = 'Invoice__c';
        controller.cFormId = '794494956';
       // controller.cLayout = 'inline';
        List<SectionController.Section> mysections = new List<SectionController.Section>();
		SectionController.Section section = new SectionController.Section();
		section.id = '2145262656';
		section.Name = 'FieloPRP__InvoiceNumber__c';
		SectionController.FormField formField = new SectionController.FormField();
		formField.id='14232526';
		formField.Name = 'FieloPRP__Status__c';
		formField.Type = 'picklist';
		formField.Required = true;
		formField.ReadOnly = true;
		formField.SearchField = 'FieloPRP__InvoiceNumber__c';
		String req = formField.getRequiredValue();
		String read = formField.getReadOnly();
		List<List<SectionController.FormField>> lists = new List<List<SectionController.FormField>>();
		List<SectionController.FormField> forms = new List<SectionController.FormField>();
		forms.add(formField);
		lists.add(forms);
		section.Rows = lists;
		mysections.add(section);
		controller.cFieldset = JSON.serialize(mysections);
		List<SectionController.Section> sections = controller.sections;
		Map<String, String> mapPick = controller.mapPicklistController;
		Map<String, String> mapPickValid = controller.mapPicklistValidFor;
		Map<String, String> mapOptions = controller.mapOptionsString;
		Test.stopTest();
	}
	
}