@isTest
public class FormApprovalControllerTest {

	@isTest static void formApprovalTest(){
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
        Invoices[0].Status__c = 'Open';
        Invoices[0].Amount__c = 10;

        insert invoices;

        FormApprovalController ctrl = new FormApprovalController(new FormController());
        
        System.assert( ctrl.rejectOptionsString != '' );

        FieloPLT.RemoteActionResult result = FormApprovalController.save(invoices[0],'close', new List<String>());

        System.assertEquals( result.redirectURL, '/'+invoices[0].Id );
    }
}