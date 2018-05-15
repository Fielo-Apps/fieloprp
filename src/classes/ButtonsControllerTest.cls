@isTest
public with sharing class ButtonsControllerTest {
	private static List<FieloPLT__Program__c> programs;
   	private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
    private static List<InvoiceItem__c> itens = new List<InvoiceItem__c>();

	@isTest static void test(){
		programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        Account distributor = new Account(name = 'Fielo');
        
        insert distributor;

        invoices = MockUpFactory.createInvoices(members[0].Id,3);
        invoices[0].Distributor__c = distributor.Id;
        invoices[0].InvoiceNumber__c = '123456';
        invoices[0].FieloPRP__Status__c = 'Open';
        invoices[1].Distributor__c = distributor.Id;
        invoices[1].InvoiceNumber__c = '159558';
        invoices[1].FieloPRP__Status__c = 'Open';
        invoices[2].Distributor__c = distributor.Id;
        invoices[2].InvoiceNumber__c = '178246';
        invoices[2].FieloPRP__Status__c = 'Open';


        insert invoices;

        InvoiceItem__c item = new InvoiceItem__c(
            Quantity__c = 10.0,
            UnitPrice__c = 50.0,
            Invoice__c = invoices[0].Id
        );
        itens.add(item);
        InvoiceItem__c item1 = new InvoiceItem__c(
            Quantity__c = 5.0,
            UnitPrice__c = 10.0,
            Invoice__c = invoices[1].Id
        );
        itens.add(item1);
        InvoiceItem__c item2 = new InvoiceItem__c(
            Quantity__c = 8.0,
            UnitPrice__c = 15.0,
            Invoice__c = invoices[2].Id
        );
        itens.add(item2);

        insert itens;

        Test.startTest();
		ButtonsController bc = new ButtonsController();
		String ids=invoices[0].Id+','+invoices[1].Id+','+invoices[2].Id;

		FieloPLT.RemoteActionResult remoteAction = ButtonsController.executeAction(ids,'InvoiceButtonImpl','{"type":"Close"}');
		bc.cParameters = '{"type":"Close"}';
		bc.cRecordId = invoices[0].Id;
		String parameters = bc.getParametersString();
		String forJson = bc.parametersForJSON;
		
		ButtonsController.Button myButton = new ButtonsController.Button();
		myButton.VisValue = 'Save';
		myButton.Action = 'Save';
		myButton.Parameters = '{"type":"Close"}';
		myButton.id = '262622629626';
		myButton.Icon = 'action-sprite/svg/symbols.svg#new_note';
		myButton.Type = 'Action';
		myButton.Label = 'Save';
		myButton.ObjectName = 'InvoiceButtonImpl';
		myButton.Confirm = true;
		myButton.reflection = true;
		myButton.cRecordId = invoices[1].Id;
		String value = myButton.getVisValueTrim();
		String url = myButton.getUrl();
		String buttonForJson = myButton.getParametersString();
		String buttonParameters = myButton.getParametersForJSON();
		List<ButtonsController.Button> myButtons = new List<ButtonsController.Button>();
		myButtons.add(myButton);
		bc.cButtonsString = '{"Buttons":"myButtons"}';
		bc.cToolsString = '{"Buttons":"myButtons"}';
		List<ButtonsController.Button> buttons = bc.cButtons;
		List<ButtonsController.Button> tools = bc.cTools;
		Test.stopTest();
	}
	
}