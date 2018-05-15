@isTest
private class RecentRecordsControllerTest {

    @isTest public static void unitTest(){
        RecentRecordsController controller = new RecentRecordsController();
        controller.cFieldset = '{"Name":"FieloPRP__Member__r.Name"},{"Name":"FieloPRP__Status__c"},{"Name":"FieloPRP__Amount__c"}';
    	controller.cDataFilters = '';
    	controller.csObjectName = 'Invoice__c';
    	controller.cNameField = 'FieloPRP__Member__r.Name,FieloPRP__Status__c,FieloPRP__Amount__c';
    	controller.cAsync = false;
    	controller.orderBy = 'FieloPRP__Member__r.Name';
    	controller.cRecordsPerPage = 10;
    	controller.cWhereClause = '';
    	Integer records = controller.recordsInPage;
    	List<sObject> recents = controller.recentRecords;

    }
}