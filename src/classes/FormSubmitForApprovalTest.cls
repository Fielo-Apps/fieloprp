@isTest
public class FormSubmitForApprovalTest {

	@isTest static void formSubmitForApprovalTest(){
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

        FormSubmitForApprovalController ctrl = new FormSubmitForApprovalController(new FormController());
        
        System.assert( ctrl.userOptionsString != '' );

		FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();
		FormSubmitForApprovalController.ApprovalResponse response;
        try{
        	response = FormSubmitForApprovalController.submitForApproval(new Map<String,String>{'Id' => invoices[0].Id});
        } catch (Exception e) {}

        try {
        	result = FormSubmitForApprovalController.save(new Map<String,String>{'Id' => invoices[0].Id, 'ApproverId' => UserInfo.getUserId()});
        } catch (Exception e) {}
    }
}