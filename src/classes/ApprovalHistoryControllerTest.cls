@isTest
public class ApprovalHistoryControllerTest {

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

        ApprovalHistoryController ctrl = new ApprovalHistoryController();
        ctrl.cRecord = invoices[0];
        
        System.assert(ctrl.columns.size()>0);

        List<ApprovalHistoryController.Row> rows = ctrl.recordObjects;

        System.assert(rows.size()>0);
    }
}