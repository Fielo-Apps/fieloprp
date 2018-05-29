@isTest
private class PageSettingsControllerTest {
	private static List<FieloPLT__Program__c> programs;
   	private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
	
	@testSetup static void createData() {
		List<FieloPLT__PageSettings__c> pageSettings = new List<FieloPLT__PageSettings__c>();

    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Invoice > View',
    			FieloPLT__Object__c = 'FieloPRP__Invoice__c',
    			FieloPLT__Type__c = 'View',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__Visibility__c='[{"field":"FieloPRP__Member__r.FieloPLT__Status__c","value":"Active"}]',
    			FieloPLT__Buttons__c = '{"Label": "' + Label.FieloPLT.New + '", "Type": "Action", "Action": "New", "ObjectName" : "' + 'FieloPRP__Invoice__c' + '" }',
    			FieloPLT__Fieldset__c = '{"Name":"FieloPRP__Member__r.Name"},{"Name":"FieloPRP__Status__c"},{"Name":"FieloPRP__Amount__c"},{"Name":"FieloPLT__Order__c"}',
    			FieloPLT__StandardRelated__c = 'Approval History; Notes & Attachments; ImageGallery',
    			FieloPLT__StandardActions__c = 'Edit;New;Clone;Delete;Settings'
    		)
    	);
    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Invoice > Related > Invoice Item',
    			FieloPLT__Object__c = 'FieloPRP__Invoice__c',
    			FieloPLT__Type__c = 'Related',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__Visibility__c='[{"field":"FieloPRP__Member__r.FieloPLT__Status__c","value":"Active"}]',
    			FieloPLT__Buttons__c = '{"Label": "' + Label.FieloPLT.New + '", "Type": "Action", "Action": "New", "ObjectName" : "' + 'FieloPRP__Invoice__c' + '" }',
    			FieloPLT__Fieldset__c = '{"Name":"FieloPRP__Product__r.Name"},{"Name":"FieloPRP__Quantity__c"},{"Name":"FieloPRP__UnitPrice__c"},{"Name":"FieloPRP__TotalPrice__c"}',
    			FieloPLT__TargetObject__c = 'FieloPRP__InvoiceItem__c',
    			FieloPLT__TargetField__c = 'FieloPRP__Invoice__c',
    			FieloPLT__StandardActions__c = 'Edit;New'
    		)
    	);
    	String sectionString = '{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]]}';
    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Invoice > Edit',
    			FieloPLT__Object__c = 'FieloPRP__Invoice__c',
    			FieloPLT__Type__c = 'Edit',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__StandardActions__c = 'Page Settings Management',
    			FieloPLT__Sections__c = sectionString
    		)
    	);
    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Invoice Item > Edit',
    			FieloPLT__Object__c = 'FieloPRP__InvoiceItem__c',
    			FieloPLT__Type__c = 'Edit',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__Sections__c = sectionString,
    			FieloPLT__StandardActions__c = 'Page Settings Management'
    		)
    	);
    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Invoice > Detail',
    			FieloPLT__Object__c = 'FieloPRP__Invoice__c',
    			FieloPLT__Type__c = 'Detail',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__StandardActions__c = 'Page Settings Management',
    			FieloPLT__Sections__c = sectionString
    		)
    	);

    	pageSettings.add(
    		new FieloPLT__PageSettings__c(
    			Name = 'Member > Lookup',
    			FieloPLT__Object__c = 'FieloPLT__Member__c',
    			FieloPLT__Type__c = 'Lookup',
    			FieloPLT__IsActive__c = true,
    			FieloPLT__Fieldset__c = '{"Name":"Name"},{"Name":"FieloPLT__Email__c"},{"Name":"FieloPLT__Points__c"},{"Name":"FieloPLT__Status__c"}',
    			FieloPLT__Filters__c = '{"Name":"Name"}',
    			FieloPLT__StandardActions__c = 'Page Settings Management'
    		)
    	);
    	insert pageSettings;
	}
	
	@isTest static void setup() {
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
		ApexPages.StandardController controller = new ApexPages.StandardController(invoices[0]);
		InvoiceViewController psc = new InvoiceViewController(controller);
		invoices = [SELECT Id,Distributor__c,Status__c,InvoiceNumber__c,Date__c,Amount__c,Member__c,Member__r.FieloPLT__Status__c,Member__r.FieloPLT__Program__r.Id,Member__r.FieloPLT__Program__r.Name FROM Invoice__c WHERE Id = :invoices[0].Id];
		psc.setRecord(invoices[0]);
		psc.initPageSettings('FieloPRP__Invoice__c',invoices[0],null,null,null);
		System.assert(psc.showHeader);
		Set<String> related = psc.relatedStandard;
		System.assert(related != null);
		System.assert(related.size()>0);
		System.assertEquals('Boolean', psc.getType('BOOLEAN'));
		Set<String>  fields = psc.fieldList;
		System.assert(fields != null);
		System.assertEquals(true,fields.contains('fieloprp__member__r.name'));
		FieloPLT__PageSettings__c page = psc.viewSettings;
		FieloPLT__PageSettings__c page2 = psc.detailSettings;
		FieloPLT__PageSettings__c page3 = psc.editSettings;
		List<FieloPLT__PageSettings__c> pagesRelated = psc.relatedSettings;
		System.assert(pagesRelated.size()>0);
		List<FieloPLT__PageSettings__c> pagesForm = psc.relatedFormsSettings;
		System.assert(pagesForm.size()>0);
		psc.getLookupSetting('FieloPRP__Invoice__c',null,null);
		Boolean res = psc.filterResult(invoices[0],'FieloPRP__Date__c','greater than',Date.newInstance(2018, 1, 1));
		System.assertEquals(true,res);
		Boolean result = psc.filterResult(invoices[0],'FieloPRP__Amount__c','greater than',0.00);
		System.assertEquals(true,result);
		Boolean resul = psc.filterResult(invoices[0],'FieloPRP__Member__c','equals',members[0].Id);
		System.assertEquals(true,resul);
		Boolean edit = psc.getHasEditForm();
		System.assertEquals(true,edit);
		Boolean detail = psc.getHasDetail();
		System.assertEquals(true,detail);
		String json = '[{"label":"{!record.FieloPRP__Member__c}","value":"{!$Label.New}"}]';
		String formula = InvoiceViewController.replaceFormula(json,invoices[0]);
		Test.stopTest();
	}
	
}