@isTest
public class TestRESTInvoice {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
    private static List<FieloPRP__InvoiceItem__c> items;
    private static Integer s_num;

    /*  TEST-1615
        Get Invoices
        - Default Fieldset (OK)
    */
    @isTest static void PRP_0006_FB() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','FieloPRP__Date__c');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<Invoice__c> svcInvoices = (List<Invoice__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<Invoice__c>.class);

        System.assertEquals(2,svcInvoices.size());
    }

    /*  TEST-1616
        Get Invoice Header
        - Default Fieldset (OK)
    */
    @isTest static void PRP_0007_FB(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id+'/invoiceItems';

        req.params.put('fields','Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c, FieloPRP__Invoice__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<InvoiceItem__c> svcItems = (List<InvoiceItem__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<InvoiceItem__c>.class);

        System.assertEquals(2,svcItems.size());
    }

    /*  TEST-1617
        Get Invoice Items
        - Default Fieldset (OK)
    */
    @isTest static void PRP_0008_FB() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id+'/invoiceItems';

        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<InvoiceItem__c> svcItems = (List<InvoiceItem__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<InvoiceItem__c>.class);

        System.assertEquals(2,svcItems.size());
    }

    /*  TEST-1618
        POST Invoice - (OK)
    */
    @isTest static void PRP_0009_FB() {
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        //invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.httpMethod = 'POST';

        // When
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.createInvoice(invoices[0], items, null);
        Test.stopTest();

        Invoice__c svcInvoice = (Invoice__c) System.JSON.deserialize(RestContext.response.responseBody.toString(), Invoice__c.class);

        System.assert( svcInvoice.Id != null );

        System.assert( [SELECT Id, Name From FieloPRP__InvoiceItem__c WHERE Invoice__c = :svcInvoice.Id].size()>0 );
    }

    @isTest static void itShouldGetInvoices(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.params.put('fields','Id, Name, FieloPRP__InvoiceNumber__c, FieloPRP__Date__c, FieloPRP__Member__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','FieloPRP__Date__c');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<Invoice__c> svcInvoices = (List<Invoice__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<Invoice__c>.class);

        System.assertEquals(2,svcInvoices.size());
    }

    @isTest static void itShouldGetInvoicesBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        members[0].FieloPLT__Status__c='Blocked';
        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode );
        
        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('FIELO_ACCOUNT_BLOCKED', String.valueOf(responseBody.get('errorcode') ) );
    }

    @isTest static void itShouldGetOneInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id;
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<Invoice__c> svcInvoices = (List<Invoice__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<Invoice__c>.class);

        System.assertEquals(1,svcInvoices.size());
        System.assertEquals(invoices[0].Id,svcInvoices[0].Id);
    }

    @isTest static void itShouldGetOneInvoiceBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        members[0].FieloPLT__Status__c='Blocked';
        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id;
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode );
        
        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('FIELO_ACCOUNT_BLOCKED', String.valueOf(responseBody.get('errorcode') ) );
    }

    @isTest static void itShouldGetOneNonExistingInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        s_num=0;

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/' + 
            FieloPRP__Invoice__c.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-String.valueOf(s_num).length()) + String.valueOf(s_num);
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode );
        
        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('RECORD_NOT_FOUND', String.valueOf(responseBody.get('errorcode') ) );
    }

    @isTest static void itShouldGetNoInvoicesAtAll(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.params.put('fields','Id, Name, FieloPRP__InvoiceNumber__c, FieloPRP__Date__c, FieloPRP__Member__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','FieloPRP__Date__c');

        //no record will return: wrong date range to cover all the method code
        req.params.put('fromdate','2017-02-01'); // YYYY-MM-DD - Supported
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported

        req.httpMethod = 'GET';

        // When
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode );
        
        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('RECORD_NOT_FOUND', String.valueOf(responseBody.get('errorcode') ) );
    }

    @isTest static void itShouldGetInvoiceItems(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id+'/invoiceItems';

        req.params.put('fields','Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c, FieloPRP__Invoice__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<InvoiceItem__c> svcItems = (List<InvoiceItem__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<InvoiceItem__c>.class);

        System.assertEquals(2,svcItems.size());
    }

    @isTest static void itShouldGetInvoiceItemsBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        members[0].FieloPLT__Status__c = 'Blocked';

        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id+'/invoiceItems';

        req.params.put('fields','Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c, FieloPRP__Invoice__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode );
        
        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('FIELO_ACCOUNT_BLOCKED', String.valueOf(responseBody.get('errorcode') ) );
    }

    @isTest static void itShouldGetNoInvoiceItemsAtAll(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        //Using the second Invoice Id to make the method returns no invoice item at all
        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[1].Id+'/invoiceItems';

        req.params.put('fields','Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c, FieloPRP__Invoice__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode );
        
        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('RECORD_NOT_FOUND', String.valueOf(responseBody.get('errorcode') ) );
    }

    @isTest static void itShouldCreateAnInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.httpMethod = 'POST';

        // When
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.createInvoice(invoices[0], items, null);
        Test.stopTest();

        Invoice__c invoice = (Invoice__c) System.JSON.deserialize(RestContext.response.responseBody.toString(), Invoice__c.class);

        System.assert( invoice.Id != null );
    }

    @isTest static void itShouldUpdateAnInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.httpMethod = 'POST';

        // When
        RestContext.request = req;
        RestContext.response = res;

        RESTInvoice.createInvoice(invoices[0], items, null);

        Invoice__c invoice = (Invoice__c) System.JSON.deserialize(RestContext.response.responseBody.toString(), Invoice__c.class);

        invoice.Status__c = 'Pending for Approval';

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/' + invoice.Id + '/close';

        System.debug(req.requestURI);

        Test.startTest();
            RESTInvoice.updateInvoice(invoice, items, null);
        Test.stopTest();

        System.debug(RestContext.response.responseBody.toString());

        invoice = (Invoice__c) System.JSON.deserialize(RestContext.response.responseBody.toString(), Invoice__c.class);

        System.assertEquals('Approved', ((FieloPRP__Invoice__c)[Select Status__c From FieloPRP__Invoice__c Where Id = :invoice.Id LIMIT 1]).Status__c);
    }

    @isTest static void itShouldNotCreateAnInvoiceBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        members[0].FieloPLT__Status__c = 'Blocked';

        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        //invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        /*List<RESTInvoice.RESTInvoiceWrapper> RESTInvoiceWrapperList = new List<RESTInvoice.RESTInvoiceWrapper>();
        
        RESTInvoice.RESTInvoiceWrapper riw;

        riw = new RESTInvoice.RESTInvoiceWrapper();
        riw.invoice = invoices[0];
        riw.invoiceItems = new List<InvoiceItem__c>();
        riw.invoiceItems.addAll(items);

        RESTInvoiceWrapperList.add(riw);

        riw = new RESTInvoice.RESTInvoiceWrapper();
        riw.invoice = invoices[1];

        RESTInvoiceWrapperList.add(riw);*/

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.httpMethod = 'POST';

        //req.requestBody = Blob.valueOf(JSON.serialize(RESTInvoiceWrapperList));
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            //RESTInvoice.createInvoice(RESTInvoiceWrapperList);
            RESTInvoice.createInvoice(invoices[0], items, null);
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode );
        
        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('FIELO_ACCOUNT_BLOCKED', String.valueOf(responseBody.get('errorcode') ) );
    }

    @isTest static void itShouldNotCreateAnInvoiceException(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,1);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        //invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        /*List<RESTInvoice.RESTInvoiceWrapper> RESTInvoiceWrapperList = new List<RESTInvoice.RESTInvoiceWrapper>();
        
        RESTInvoice.RESTInvoiceWrapper riw;

        riw = new RESTInvoice.RESTInvoiceWrapper();
        riw.invoice = invoices[0];
        riw.invoiceItems = new List<InvoiceItem__c>();
        riw.invoiceItems.addAll(items);

        RESTInvoiceWrapperList.add(riw);

        riw = new RESTInvoice.RESTInvoiceWrapper();
        riw.invoice = invoices[1];

        RESTInvoiceWrapperList.add(riw);*/

        //Cause Exception
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        update programs;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';

        req.httpMethod = 'POST';

        //req.requestBody = Blob.valueOf(JSON.serialize(RESTInvoiceWrapperList));
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            //RESTInvoice.createInvoice(RESTInvoiceWrapperList);
            RESTInvoice.createInvoice(invoices[0], items, null);
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode );

        Map<String,Object> responseBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());

        System.assertEquals('EXCEPTION', String.valueOf(responseBody.get('errorcode') ) );
    }
}