@isTest
public class ProgramServiceTest {
	private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    @isTest static void ItShouldTestGettersAndSetters(){
    	//Given
        programs = MockUpFactory.createPrograms('Default', 2);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        programs[1].FieloPRP__RequestInvoiceProducts__c = false;
        insert programs;

        ProgramService.selectProgram(programs[0].Id);

        System.assertEquals(true,ProgramService.hasPrograms());

        List<SelectOption> sortedPrograms = ProgramService.getProgramsLandingSelectOptions();

        System.assert(sortedPrograms.size()>0);

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();

		System.assertEquals(programs[0].Id,activeProgram.Id);
    }
}