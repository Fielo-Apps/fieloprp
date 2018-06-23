@isTest
private with sharing class ApprovalHistoryListViewControllerTest {
	@isTest static void approvalHistoryTest(){
		//Given
        List<FieloPLT__Program__c> programs = MockUpFactory.createPrograms('Default', 1);
        insert programs;

        List<FieloPLT__Member__c> members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        Account distributor = new Account(name = 'Fielo');
        
        insert distributor;

        List<FieloPRP__Invoice__c> invoices = MockUpFactory.createInvoices(members[0].Id,1);
        
        invoices[0].Distributor__c = distributor.Id;
        invoices[0].InvoiceNumber__c = '123456';
        Invoices[0].Status__c = 'Approved';
        Invoices[0].Amount__c = 10;

        insert invoices;
        
        List<Object> columns = ApprovalHistoryListViewController.getColumns(invoices[0].Id);

        System.assertEquals(3,columns.size());

        List<Map<String, String>> records =  ApprovalHistoryListViewController.getRecords( invoices[0].Id );
        System.assertEquals(1,records.size());
	}
}