@isTest
public class BackEndProgramSelectorControllerTest{
	@isTest static void programActive(){
		FieloPLT__Program__c program = new FieloPLT__Program__c();
        program.Name = 'Default';
        program.FieloPRP__RequestInvoiceProducts__c=false;
        insert program;

        BackEndProgramSelectorController bepsc = new BackEndProgramSelectorController();
        System.assertEquals(program,bepsc.getActiveProgram());
        List<PicklistController.Entry> values = BackEndProgramSelectorController.programs;
        System.assert(!values.isEmpty());
        System.assertEquals('000000000000000',bepsc.programsViewId);
        //System.assertEquals('Default',bepsc.programsViewId);
        RemoteActionResult result = BackEndProgramSelectorController.selectProgram(program.Id);
        List<RemoteActionResult.RemoteActionMessage> messages = result.getMessages();
      	System.assertEquals('Success',messages[0].summary);
	}
}