@isTest
public class TestInvoiceViewController {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    @isTest static void unitTest(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Amount__c = 10;
        invoices[0].FieloPRP__Status__c = 'Pending for Approval';
        insert invoices;

        ApexPages.StandardController standardController = new ApexPages.StandardController(invoices[0]);
        InvoiceViewController controller = new InvoiceViewController(standardController);

        invoices[0].FieloPRP__Status__c = 'Approved';

        standardController = new ApexPages.StandardController(invoices[0]);
        controller = new InvoiceViewController(standardController);
    }
}