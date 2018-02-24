public with sharing class InvoiceViewController extends PageSettingsController {
    public Invoice__c record {get;set;}
    private ApexPages.StandardController controller;
    public List<Attachment> images {get; set;}
    public String buttonString {get;set;}
    public String hiddenClass {get;set;}
    public Boolean lockedRecord {get;set;}

    /**
    * @brief constructor
    */
    public InvoiceViewController(ApexPages.StandardController controller) {
        this.controller = controller;

        if(!Test.isRunningTest()){
            this.controller.addFields(new List<String>{'Name','FieloPRP__HasDetails__c','FieloPRP__Member__c','FieloPRP__InvoiceNumber__c','FieloPRP__Status__c','FieloPRP__Amount__c','FieloPRP__Date__c','FieloPRP__Description__c','FieloPRP__Distributor__c','FieloPRP__Member__r.FieloPLT__Program__r.FieloPRP__RequestInvoiceAuthorization__c'});
        }

        record = (Invoice__c)controller.getRecord();

        try{
            lockedRecord = InvoiceService.isLockedByApprovalProcess( new Set<Id>{record.Id} );
        }
        catch(Exception e){
            lockedRecord = false;
        }
        
        hiddenClass = lockedRecord ? '' : 'slds-hide';

        images = [SELECT Id, Name FROM Attachment WHERE ParentId =: record.Id];

        initPageSettings( 'FieloPRP__Invoice__c', (SObject) record, buttonString, '', '' );
        if(lockedRecord){
            if (viewSettings != null) {
                viewSettings.FieloPLT__Buttons__c = '';
            }
        }
    }

}