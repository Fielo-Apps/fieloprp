@isTest
public with sharing class PageSettingsSetControllerTest {
	private static List<FieloPLT__Program__c> programs;
   	private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    @testSetup static void createData() {
    	List<FieloPLT__PageSettings__c> pageSettings = new List<FieloPLT__PageSettings__c>();

    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Invoice > Landing',
    			FieloPLT__Object__c = 'FieloPRP__Invoice__c',
    			FieloPLT__Type__c = 'Landing',
    			FieloPLT__Tools__c = '{"Label": "Products", "Type": "Link", "Action": "/01t" }',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__Fieldset__c = '{"Name":"FieloPRP__Member__r.Name"},{"Name":"FieloPRP__Status__c"},{"Name":"FieloPRP__Amount__c"}',
    			FieloPLT__StandardActions__c = 'Page Settings Management'
    		)
    	);
    	String sectionString = '[{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]],"FieloPRP_Product":[[{"Name":"Name", "Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_ProductRecent": [[{"Name":"Name", "Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_InvoiceItems": [[{"Name":"FieloPRP__Quantity__c", "Type":"input", "ClassName": "fielosf-product_qty", "onchange": "refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c", "Type":"lookup", "ClassName": "fielosf-product_name", "onchange": "refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c", "Type": "input", "ClassName": "fielosf-product_unit-price", "onchange": "refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c", "Type": "input", "ClassName": "fielosf-product_total-price", "onchange": "refreshTotalPriceProxy_"}]]}]';
    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Invoice > Edit',
    			FieloPLT__Object__c = 'FieloPRP__Invoice__c',
    			FieloPLT__Type__c = 'Edit',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__StandardActions__c = 'Page Settings Management'
    			//FieloPLT__Sections__c = sectionString
    		)
    	);

    	insert pageSettings;
    }

	@isTest static void setup(){

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

		ApexPages.StandardSetController controller = new ApexPages.StandardSetController(invoices);
		InvoiceLandingController pssc = new InvoiceLandingController(controller);
		pssc.initPageSettings('FieloPRP__Invoice__c',null,null,null);
		String sectionString = '[{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]],"FieloPRP_Product":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_ProductRecent":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_InvoiceItems":[[{"Name":"FieloPRP__Quantity__c","Type":"input","ClassName":"fielosf-product_qty","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c","Type":"lookup","ClassName":"fielosf-product_name","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c","Type":"input","ClassName":"fielosf-product_unit-price","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c","Type":"input","ClassName":"fielosf-product_total-price","onchange":"refreshTotalPriceProxy_"}]]}]';
		pssc.newSettings.FieloPLT__Sections__c = InvoiceLandingController.getSectionsWithMemberWhereCondition(sectionString, programs[0].Id);
		pssc.addNewFieldSet('Delete');
		FieloPLT__PageSettings__c ps2 = pssc.landingSettings;
	}
}