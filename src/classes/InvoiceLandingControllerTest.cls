@isTest
private class InvoiceLandingControllerTest {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
    private Map<String,FieloPLT__PageSettings__c> lookupSettings {get;set;}

    @testSetup static void createData() {
        List<FieloPLT__PageSettings__c> pageSettings = new List<FieloPLT__PageSettings__c>();

        pageSettings.add(
            new FieloPLT__PageSettings__c(
                Name = 'Invoice > View',
                FieloPLT__Object__c = 'FieloPRP__Invoice__c',
                FieloPLT__Type__c = 'View',
                FieloPLT__IsActive__c = true,
                FieloPLT__Buttons__c = '{"Label": "' + Label.FieloPLT.New + '", "Type": "Action", "Action": "New", "ObjectName" : "' + 'FieloPRP__Invoice__c' + '" }',
                FieloPLT__Fieldset__c = '{"Name":"FieloPRP__Status__c"},{"Name":"FieloPRP__InvoiceNumber__c"},{"Name":"FieloPRP__Distributor__r.Name"}, {"Name":"FieloPRP__Member__r.Name"}, {"Name":"FieloPRP__Amount__c"}, {"Name":"FieloPRP__Date__c"}, {"Name":"FieloPRP__Comments__c"}',
                FieloPLT__StandardRelated__c = 'Approval History; Notes & Attachments; ImageGallery',
                FieloPLT__StandardActions__c = 'View; Page Settings Management'
            )
        );
        pageSettings.add(
            new FieloPLT__PageSettings__c(
                Name = 'Products > Lookup',
                FieloPLT__Object__c = 'FieloPRP__Invoice__c',
                FieloPLT__Type__c = 'Lookup',
                FieloPLT__IsActive__c = true,
                FieloPLT__Fieldset__c = '{"Name":"Name", "Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}',
                FieloPLT__isCustom__c = true
            )
        );
        pageSettings.add(
            new FieloPLT__PageSettings__c(
                Name = 'Product Recent > Lookup',
                FieloPLT__Object__c = 'FieloPRP__Invoice__c',
                FieloPLT__Type__c = 'Lookup',
                FieloPLT__IsActive__c = true,
                FieloPLT__Fieldset__c = '{"Name":"Name", "Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}',
                FieloPLT__isCustom__c = true
            )
        );
        pageSettings.add(
            new FieloPLT__PageSettings__c(
                Name = 'Invoice Item > Lookup',
                FieloPLT__Object__c = 'FieloPRP__Invoice__c',
                FieloPLT__Type__c = 'Lookup',
                FieloPLT__IsActive__c = true,
                FieloPLT__Fieldset__c = '{"Name":"FieloPRP__Quantity__c", "Type":"input", "ClassName": "fielosf-product_qty", "onchange": "refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c", "Type":"lookup", "ClassName": "fielosf-product_name", "onchange": "refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c", "Type": "input", "ClassName": "fielosf-product_unit-price", "onchange": "refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c", "Type": "input", "ClassName": "fielosf-product_total-price", "onchange": "refreshTotalPriceProxy_"}',
                FieloPLT__isCustom__c = true
            )
        );

        insert pageSettings;
    }

    @isTest static void ItShouldTestController(){
        //Given
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
        InvoiceLandingController invoicesCtrl = new InvoiceLandingController(controller);
        

        List<SelectOption> listViews = invoicesCtrl.getListViews();

        System.assert(listViews.size()>0);

        FieloPLT__Program__c currentProgram = invoicesCtrl.currentProgram;

        System.assertEquals(currentProgram.Id, programs[0].Id);

        String sectionString = '[{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]]}]';


        //"FieloPRP_Product":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_ProductRecent":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_InvoiceItems":[[{"Name":"FieloPRP__Quantity__c","Type":"input","ClassName":"fielosf-product_qty","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c","Type":"lookup","ClassName":"fielosf-product_name","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c","Type":"input","ClassName":"fielosf-product_unit-price","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c","Type":"input","ClassName":"fielosf-product_total-price","onchange":"refreshTotalPriceProxy_"}]]}]';

        sectionString = InvoiceLandingController.getSectionsWithMemberWhereCondition(sectionString, currentProgram.Id);
    }

    @isTest static void ItShouldGetInvoices(){
        //Given
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

        List<SObject> queriedInvoices = InvoiceLandingController.getInvoices(
            'FieloPRP__Invoice__c',
            'Id,Name,FieloPRP__InvoiceNumber__c,FieloPRP__Status__c',
            0,
            null,
            JSON.serialize(new Map<String,Object>{ 'FieloPRP__Member__r.FieloPLT__Program__c' => (Object) programs[0].Id }),
            10,
            ''
        );

        System.assert(queriedInvoices.size()>0);
    }

    @isTest static void ItShouldTestControllerInnerClasses(){
        //Given
        String sectionsString = '[{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]]}]';

        //"FieloPRP_Product":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_ProductRecent":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_InvoiceItems":[[{"Name":"FieloPRP__Quantity__c","Type":"input","ClassName":"fielosf-product_qty","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c","Type":"lookup","ClassName":"fielosf-product_name","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c","Type":"input","ClassName":"fielosf-product_unit-price","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c","Type":"input","ClassName":"fielosf-product_total-price","onchange":"refreshTotalPriceProxy_"}]]}]';
        List<InvoiceLandingController.Section> sections = (List<InvoiceLandingController.Section>) JSON.deserialize( sectionsString, List<InvoiceLandingController.Section>.class );
        for ( InvoiceLandingController.Section s :sections ) {
            s.Name = s.Name;
            for ( List<InvoiceLandingController.FormField> r : s.rows) {
                for ( InvoiceLandingController.FormField f :r ) {
                    f.Type = f.Type;
                    f.Name = f.Name;
                    f.onchange = f.onchange;
                    f.Label = f.Label;
                    f.Value = f.Value;
                    f.WhereCondition = f.WhereCondition;
                    f.ClassName = f.ClassName;
                }
            }
        }
    }
}