@isTest
private class FormInvoiceControllerTest {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    @isTest static void ItShouldSaveInvoice(){
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


        InvoiceItem__c item = new InvoiceItem__c(
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        RemoteActionResult saveResult = FormInvoiceController.save(invoices[0], new List<InvoiceItem__c>{item}, new List<String>{'FieloPRP__Description__c'});

        system.assert(saveResult.redirectURL != null);
    }

    @isTest static void ItShouldRetrieveInvoice(){
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

        insert invoices[0];

        InvoiceItem__c item = new InvoiceItem__c(
            Quantity__c = 10.0,
            UnitPrice__c = 50.0,
            Invoice__c = invoices[0].Id
        );

        insert item;

        sObject retrievedObject = FormInvoiceController.retrieve( 'FieloPRP__Invoice__c', invoices[0].Id, 'Id,FieloPRP__InvoiceNumber__c', 'Id,FieloPRP__Quantity__c,UnitPrice__c');

        system.assertEquals((String)retrievedObject.get('Id'),(String)invoices[0].Id);
    }

    @isTest static void ItShouldGetHasDetailsFromMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        Boolean hasDetails = FormInvoiceController.getHasDetailsFromMember(members[0].Id);

        system.assertEquals(true, hasDetails);
    }

    @isTest static void ItShouldGetProductRecords(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        programs[0].FieloPRP__ProductInjectQuery__c = 'IsActive != false';
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        Account distributor = new Account(name = 'Fielo');
        
        insert distributor;

        Product2 product = new Product2(Name='Product', IsActive=true, ProductCode='XPTO');

        insert product;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        
        invoices[0].Distributor__c = distributor.Id;
        invoices[0].InvoiceNumber__c = '123456';

        insert invoices[0];

        InvoiceItem__c item = new InvoiceItem__c(
            Quantity__c = 10.0,
            UnitPrice__c = 50.0,
            Invoice__c = invoices[0].Id
        );

        insert item;

        List<sObject> retrievedObjects = FormInvoiceController.getProductRecords(
            'Product2',
            'Name,ProductCode',
            0,
            null,
            '{"ProductCode":"XPTO","IsActive":true}',
            null,
            'IsActive = true'
        );
        
        system.assertEquals((String)retrievedObjects[0].get('Id'),(String)product.Id);
    }

    @isTest static void ItShouldGetActiveProgram(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        programs[0].FieloPRP__ProductInjectQuery__c = 'IsActive != false';
        insert programs;

        FieloPLT__Program__c currentProgram = FormInvoiceController.getActiveProgram();
        
        system.assertEquals(currentProgram.Id,programs[0].Id);
    }

    @isTest static void ItShouldTestGettersAndSetters() {
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

        insert invoices[0];

        InvoiceItem__c item = new InvoiceItem__c(
            Quantity__c = 10.0,
            UnitPrice__c = 50.0,
            Invoice__c = invoices[0].Id
        );

        insert item;

        String fieldSet = '{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]],"FieloPRP_Product":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_ProductRecent":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_InvoiceItems":[[{"Name":"FieloPRP__Quantity__c","Type":"input","ClassName":"fielosf-product_qty","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c","Type":"lookup","ClassName":"fielosf-product_name","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c","Type":"input","ClassName":"fielosf-product_unit-price","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c","Type":"input","ClassName":"fielosf-product_total-price","onchange":"refreshTotalPriceProxy_"}]]}';
        String productFilterFieldSet = '{"Name":"Name", "Type":"input"}, {"Name":"Family","Type":"picklist"}, {"Name":"ProductCode","Type":"input"}';
        String productFieldSet = '{"Name":"Name", "Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}';

        FormInvoiceController controller = new FormInvoiceController();

        controller.cFieldset = fieldSet;
        controller.cProductRecentSection = productFilterFieldSet;
        controller.cProductSection = productFieldSet;
        controller.csObjectName = 'FieloPRP__Invoice__c';
        controller.cRecord = (SObject) invoices[0];

        String productField = controller.productField;

        system.assert(productField != '' && productField != null);

        String fields = controller.fields;

        system.assert(fields != '' && fields != null);

        sObject recordObject = controller.recordObject;

        system.assert(recordObject != null);

        List<Object> requiredFields = (List<Object>) controller.requiredFields();

        system.assert(requiredFields != null);

        List<Map<String,String>> filterRecentRecordsMap = controller.filterRecentRecordsMap;

        system.assert(!filterRecentRecordsMap.isEmpty());

        String filterSObjectName = controller.filterSObjectName;

        system.assert(filterSObjectName != '' && filterSObjectName != null);

        String filterRecentRecords = controller.filterRecentRecords;

        system.assert(filterRecentRecords != '' && filterRecentRecords != null);

        String productSectionString = controller.productSectionString;

        system.assert(productSectionString != '' && productSectionString != null);

        String itemsSectionString = controller.itemsSectionString;

        system.assert(itemsSectionString != '' && itemsSectionString != null);

        FieloPLT__Program__c program = controller.program;

        system.assert(program != null);
    }
}