public with sharing class InvoiceViewController extends PageSettingsController {
    public Invoice__c record {get;set;}
    private ApexPages.StandardController controller;
    public List<Attachment> images {get; set;}
    public String buttonString {get;set;}
    public String hiddenClass {get;set;}
    public Boolean lockedRecord {get;set;}
    public Map<String,FieloPLT__PageSettings__c> lookupSettings {get;set;}
	
    public InvoiceViewController(){}
    /**
    * @brief constructor
    */

    //get the related lookup pages
    public void getLookupSetting( String objectNames, String targetObject, String targetField ) {      

        String query = 'SELECT Name, FieloPLT__Filters__c, FieloPLT__Fieldset__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c = \'Lookup\'  AND FieloPLT__Object__c = :objectNames  ';

        /*FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        Id programId;
        if ( activeProgram != null  ) {
            programId = activeProgram.Id;
            query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }*/

        if ( String.isNotBlank(targetObject ) ) {
            query += ' AND FieloPLT__TargetObject__c = :targetObject';
        } 
        if ( String.isNotBlank(targetField ) ) {
            query += ' AND FieloPLT__TargetField__c = :targetField';
        }
        // ORDER BY & LIMIT 
        //query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c LIMIT 1 ';

        query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c';
        List<FieloPLT__PageSettings__c> pageSetting = Database.query(query);
        List<FieloPLT__PageSettings__c> lookupPSList = pageSetting.isEmpty() ? null : pageSetting;

        this.lookupSettings = new Map<String,FieloPLT__PageSettings__c>();
        
        if (lookupPSList != null) {
            if (lookupPSList.size()>0){
                for(FieloPLT__PageSettings__c p :lookupPSList){
                    if(p.Name == 'Products > Lookup'){
                        lookupSettings.put('productSection', p);
                    }else if(p.Name == 'Product Recent > Lookup'){
                        lookupSettings.put('productRecentSection', p);
                    }else if(p.Name == 'Invoice Item > Lookup'){
                        lookupSettings.put('itemsSection', p);
                    }
                }
            }
        }
    }

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
        Boolean inApprovalProcess = false;

        Boolean showApprove = false;
        Boolean showSubmitForApproval = false;

        hasApprovalProcess = InvoiceService.hasApprovalProcess();

        isCurrentApprover = InvoiceService.getApprovalProcessApprovers().contains(UserInfo.getUserId());

        isOpen = record.FieloPRP__Status__c == 'Open' || record.FieloPRP__Status__c == 'New';

        isApproved = record.FieloPRP__Status__c == 'Approved';
        
        isRejected = record.FieloPRP__Status__c == 'Rejected';

        isCanceled = record.FieloPRP__Status__c == 'Canceled';

        isPendingForApproval = record.FieloPRP__Status__c == 'Pending for Approval';

        inApprovalProcess = InvoiceService.getInvoicesWithApprovalProcess(new Set<Id>{record.Id}).get(record.Id);

        requestInvoiceAuthorization = record.FieloPRP__Member__r.FieloPLT__Program__r.FieloPRP__RequestInvoiceAuthorization__c;

        // Approve/Reject Button
        showApprove = isPendingForApproval && ( requestInvoiceAuthorization || hasApprovalProcess && isCurrentApprover || !( requestInvoiceAuthorization && hasApprovalProcess ) );

        // Submit For Approval Button
        showSubmitForApproval = isOpen && !requestInvoiceAuthorization && hasApprovalProcess;

        showSubmitForApproval = showSubmitForApproval || isPendingForApproval && requestInvoiceAuthorization && hasApprovalProcess && !inApprovalProcess;

        //Add Buttons
        if (isOpen) {
            buttonMap.add(new Map<String, Object>{'Label' => Label.Edit, 'Type' => 'Modal', 'Action' => 'invoiceForm'});
            if  (requestInvoiceAuthorization) {
                buttonMap.add(new Map<String, Object>{'Label' => Label.ButtonClose, 'Type' => 'Remote', 'Action' => 'InvoiceButtonImpl', 'Confirm' => true, 'Reflection' => true, 'parameters' => '{"type":"Close"}'});
            } else {
                buttonMap.add(new Map<String, Object>{'Label' => Label.ButtonClose, 'Type' => 'Modal', 'Action' => 'approvalForm', 'parameters' => '{"type":"Close"}'});
            }
            
        }

        if (showApprove) {
            buttonMap.add(new Map<String, Object>{'Label' => Label.ButtonApprove, 'Type' => 'Modal', 'Action' => 'approvalForm', 'parameters' => '{"type":"approve"}'});
            buttonMap.add(new Map<String, Object>{'Label' => Label.ButtonReject, 'Type' => 'Modal', 'Action' => 'approvalForm', 'parameters' => '{"type":"reject"}'});
        }

        if (showSubmitForApproval) {
            buttonMap.add(new Map<String, Object>{'Label' => Label.ButtonSubmitForApproval, 'Type' => 'Link', 'Action' => '#', 'CssClass' => 'fielosf-invoice-submit-for-approval'});
        }

        if(!buttonMap.isEmpty()){
            buttonString = JSON.serialize(buttonMap);
            buttonString = buttonString.substring(1,buttonString.length()-1);
        }

        hiddenClass = 'slds-hide';

        images = [SELECT Id, Name FROM Attachment WHERE ParentId =: record.Id];

        
        initPageSettings( 'FieloPRP__Invoice__c', (SObject) record, buttonString, '', '' );
        getLookupSetting('FieloPRP__Invoice__c',null,null);
        
    }

}