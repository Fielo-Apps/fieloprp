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

        List<Map<String, Object>> buttonMap = new List<Map<String, Object>>();

        Boolean requestInvoiceAuthorization = false;
        Boolean hasApprovalProcess = false;
        Boolean isCurrentApprover = false;
        Boolean isOpen = false;
        Boolean isApproved = false;
        Boolean isRejected = false;
        Boolean isCanceled = false;
        Boolean isPendingForApproval = false;

        Boolean showApprove = false;
        Boolean showSubmitForApproval = false;
        Boolean showRevert = false;
        Boolean showReprocess = false;
        Boolean showReopen = false;

        hasApprovalProcess = InvoiceService.hasApprovalProcess();

        isCurrentApprover = InvoiceService.getApprovalProcessApprovers().contains(UserInfo.getUserId());

        isOpen = record.FieloPRP__Status__c == 'Open' || record.FieloPRP__Status__c == 'New';

        isApproved = record.FieloPRP__Status__c == 'Approved';

        isPendingForApproval = record.FieloPRP__Status__c == 'Pending for Approval';

        requestInvoiceAuthorization = record.FieloPRP__Member__r.FieloPLT__Program__r.FieloPRP__RequestInvoiceAuthorization__c;

        // Approve/Reject Button
        showApprove = isOpen && (!requestInvoiceAuthorization || !hasApprovalProcess || isCurrentApprover);

        showApprove = showApprove || (isPendingForApproval && !hasApprovalProcess && isCurrentApprover);

        // Submit For Approval Button
        showSubmitForApproval = isOpen && !requestInvoiceAuthorization;

        // Revert Button
        showRevert = isApproved;

        // Reprocess Button
        showReprocess = isApproved || isCanceled;

        // Reopen Button
        showReopen = isRejected;

        //Add Buttons
        if (isOpen) {
            buttonMap.add(
                new Map<String, Object>{'Label' => 'Edit', 'Type' => 'Modal', 'Action' => 'invoiceForm'}
            );
        }

        if (showApprove) {
            buttonMap.add(
                new Map<String, Object>{'Label' => 'Approve', 'Type' => 'Modal', 'Action' => 'approvalForm', 'parameters' => '{"type":"approve"}'}
            );
            buttonMap.add(
                new Map<String, Object>{'Label' => 'Reject', 'Type' => 'Modal', 'Action' => 'approvalForm', 'parameters' => '{"type":"reject"}'}
            );
        }

        if (showSubmitForApproval) {
            buttonMap.add(
                new Map<String, Object>{'Label' => 'Submit For Approval', 'Type' => 'Remote', 'Action' => 'InvoiceButtonImpl', 'Confirm' => true, 'Reflection' => true, 'parameters' => '{"type":"SubmitForApproval"}'}
            );
        }

        if (showRevert) {
            buttonMap.add(
                new Map<String, Object>{'Label' => 'Revert', 'Type' => 'Remote', 'Action' => 'InvoiceButtonImpl', 'Confirm' => true, 'Reflection' => true, 'parameters' => '{"type":"Cancel"}'}
            );
        }

        if (showReprocess) {
            buttonMap.add(
                new Map<String, Object>{'Label' => 'Reprocess', 'Type' => 'Remote', 'Action' => 'InvoiceButtonImpl', 'Confirm' => true, 'Reflection' => true, 'parameters' => '{"type":"Reprocess"}'}
            );
        }

        if (showReopen) {
            buttonMap.add(
                new Map<String, Object>{'Label' => 'Reopen', 'Type' => 'Remote', 'Action' => 'InvoiceButtonImpl', 'Confirm' => true, 'Reflection' => true, 'parameters' => '{"type":"Reopen"}'}
            );
        }

        if(!buttonMap.isEmpty()){
            buttonString = JSON.serialize(buttonMap);
            buttonString = buttonString.substring(1,buttonString.length()-1);
        }


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
            viewSettings.FieloPLT__Buttons__c = '';
        }
    }

}