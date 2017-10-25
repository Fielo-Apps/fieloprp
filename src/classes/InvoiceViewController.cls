public class InvoiceViewController extends PageSettingsController {
    public Invoice__c record {get;set;}
    private ApexPages.StandardController controller;
    public List<Attachment> images {get; set;}
    public String buttonString {get;set;}
    public String hiddenClass {get;set;}
    public Boolean lockedRecord {get;set;}
    public List<Map<String,Object>> buttonList {get;set;}

    /**
    * @brief constructor
    */
    public InvoiceViewController(ApexPages.StandardController controller) {
        this.controller = controller;

        if(!Test.isRunningTest()){
            this.controller.addFields(new List<String>{
                'Name',
                'FieloPRP__HasDetails__c',
                'FieloPRP__Member__c',
                'FieloPRP__InvoiceNumber__c',
                'FieloPRP__Status__c',
                'FieloPRP__Amount__c',
                'FieloPRP__Date__c',
                'FieloPRP__Description__c',
                'FieloPRP__Distributor__c',
                'FieloPRP__Member__r.FieloPLT__Program__r.FieloPRP__RequestInvoiceAuthorization__c'
                });
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

        //buttonList = new List<Map<String,Object>>();

        /*if(!lockedRecord){
            if(record.Status__c == 'Open' || record.Status__c == 'New'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Edit',
                    'Type' => 'Modal',
                    'Action' => 'invoiceForm'
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Close',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.closeInvoice',
                    'Confirm' => true
                });
                
                if(!record.FieloPRP__Member__r.FieloPLT__Program__r.FieloPRP__RequestInvoiceAuthorization__c){
                    buttonList.add(new Map<String,Object>{
                        'Label' => 'Submit for approval',
                        'Type' => 'Remote',
                        'Action' => 'FieloPRP.InvoiceViewController.submitForApproval',
                        'Confirm' => true
                    });
                }
            }else if(record.Status__c == 'Pending for Approval'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Approve',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.approveInvoice',
                    'Confirm' => true
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reject',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.rejectInvoice',
                    'Confirm' => true
                });
            }else if(record.Status__c == 'Approved'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Revert',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.cancelInvoice',
                    'Confirm' => true
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reprocess',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.reprocessInvoice',
                    'Confirm' => true
                });
            }else if(record.Status__c == 'Rejected'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reopen',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.reopenInvoice',
                    'Confirm' => true
                });
            }else if(record.Status__c == 'Canceled'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reopen',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.reopenInvoice',
                    'Confirm' => true
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reprocess',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.approveInvoice',
                    'Confirm' => true
                });
            }
        }

        if(!buttonList.isEmpty()){
            buttonString = JSON.serialize(buttonList);
            buttonString = buttonString.substring(1,buttonString.length()-1);    
        }*/

        if(lockedRecord){
            buttonString = '';
        }
        initPageSettings( 'FieloPRP__Invoice__c', (SObject) record, buttonString, '', '' );
        /*if(!lockedRecord){
            buttonString = viewSettings.FieloPLT__Buttons__c;
        }*/
    }

    /*@RemoteAction
    public static RemoteActionResult closeInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            Invoice__c invoice = InvoiceService.closeInvoice(recordId);
            if(invoice.Status__c == 'Pending for Approval'){
                result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'sent for approval'})) );
            }else{
                result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'approved'})) );
            }
            result.redirectURL = '/'+recordId;
        }
        catch(DMLException e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }

        return result;
    }

    @RemoteAction
    public static RemoteActionResult approveInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Approved');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'approved'})) );
            result.redirectURL = '/'+recordId;
        }
        catch(DMLException e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }

        return result;
    }

    @RemoteAction
    public static RemoteActionResult rejectInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Rejected');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'rejected'})) );
            result.redirectURL = '/'+recordId;
        }
        catch(DMLException e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }
        
        return result;
    }

    @RemoteAction
    public static RemoteActionResult reopenInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Open');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'reopened'})) );
            result.redirectURL = '/'+recordId;
        }
        catch(DMLException e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }
        
        return result;
    }

    @RemoteAction
    public static RemoteActionResult cancelInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Canceled');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'cancelled'})) );
            result.redirectURL = '/'+recordId;
        }
        catch(DMLException e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }
        
        return result;
    }

    @RemoteAction
    public static RemoteActionResult reprocessInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.reprocessInvoice(new Set<Id>{recordId});

            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'reprocessed'})) );
            result.redirectURL = '/'+recordId;
        }
        catch(DMLException e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }
        
        return result;
    }

    @RemoteAction
    public static RemoteActionResult submitForApproval(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Pending for Approval');
            InvoiceService.submitForApproval(new Set<Id>{recordId});

            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'sent for approval'})) );
            result.redirectURL = '/'+recordId;
        }
        catch(DMLException e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
        }
        
        return result;
    }*/
}