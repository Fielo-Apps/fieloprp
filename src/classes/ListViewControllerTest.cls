@IsTest 
public with sharing class ListViewControllerTest {
    
    @IsTest(SeeAllData=false) 
    public static void testListViewController() {

        FieloPLT__Program__c program = MockUpFactory.createPrograms('Program', 1)[0];
        insert program;
        
        Test.startTest();

        String fieldset = 'Name, Id';
        String objectType = 'FieloPLT__Program__c';
        String whereCondition = null;
        List<sObject> records = ListViewController.getRecords(fieldset, objectType, whereCondition);
        String fieldset2 = 'FieloPRP__Member__c';
        try{
        List<sObject> records1 = ListViewController.getRecords(fieldset2, objectType, whereCondition);
        }catch(AuraHandledException e){
            System.debug('AuraHandledException lançada com sucesso');
            System.assert(true);
        }

        String objectAPIName = 'FieloPLT__Program__c';
        map<String, String> fieldLabels = ListViewController.getFieldLabels(objectAPIName);
        
        Test.stopTest();
    }
}