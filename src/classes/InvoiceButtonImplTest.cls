@isTest
private class InvoiceButtonImplTest {
	private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    @isTest static void ItShouldCloseInvoice(){
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

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Close"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }

    @isTest static void ItShouldClosePendingInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        programs[0].FieloPRP__RequestInvoiceAuthorization__c = true;
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

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Close"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }

    @isTest static void ItShouldSubmitInvoiceForApproval(){
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

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"SubmitForApproval"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }

    @isTest static void ItShouldApproveInvoice(){
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

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Approve"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }

    @isTest static void ItShouldRejectInvoice(){
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

        invoices[0].Status__c = 'Pending for Approval';

        update invoices;

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Reject"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }

    @isTest static void ItShouldCancelInvoice(){
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

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Approve"}');

        result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Cancel"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }

    @isTest static void ItShouldReprocessInvoice(){
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

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Approve"}');

        result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Reprocess"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }

    @isTest static void ItShouldReopenInvoice(){
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

        invoices[0].Status__c = 'Pending for Approval';

        update invoices;

        InvoiceButtonImpl btn = new InvoiceButtonImpl();

        FieloPLT.RemoteActionResult result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Reject"}');

        result = btn.executeAction(new List<Id>{invoices[0].Id}, '{"type":"Reopen"}');

        System.assertEquals('/'+invoices[0].Id, result.redirectURL);
    }
}