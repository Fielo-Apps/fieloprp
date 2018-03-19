public with sharing class InvoiceButtonImpl implements FieloPLT.ButtonActionInterface {
	
	public FieloPLT.RemoteActionResult executeAction(List<Id> recordIds, String parameters){
		Map<String,String> parametersMap = (Map<String,String>)JSON.deserialize(parameters, Map<String,String>.class);

		Id recordId = recordIds[0];
		if(parametersMap.get('type') == 'Close'){
			FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();

	        try{
	            Invoice__c invoice = InvoiceService.closeInvoice(recordId);
	            if(invoice.Status__c == 'Pending for Approval'){
	                result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.SentForApproval})) );
	            }else{
	                result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.Approved})) );
	            }
	            result.redirectURL = '/'+recordId;
	        }
	        catch(DMLException e){
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
	        }

	        return result;
		}else if(parametersMap.get('type') == 'SubmitForApproval'){
			FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();

	        try{
	            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Pending for Approval');
	            InvoiceService.submitForApproval(new Set<Id>{recordId});

	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.SentForApproval})) );
	            result.redirectURL = '/'+recordId;
	        }
	        catch(DMLException e){
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
	        }
	        
	        return result;
		}else if(parametersMap.get('type') == 'Approve'){
			FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();

	        try{
	            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Approved');
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.Approved})) );
	            result.redirectURL = '/'+recordId;
	        }
	        catch(DMLException e){
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
	        }

	        return result;
		}else if(parametersMap.get('type') == 'Reject'){
			FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();

	        try{
	            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Rejected');
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.Rejected})) );
	            result.redirectURL = '/'+recordId;
	        }
	        catch(DMLException e){
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
	        }
	        
	        return result;
		}else if(parametersMap.get('type') == 'Cancel'){
			FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();

	        try{
	            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Canceled');
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.Cancelled})) );
	            result.redirectURL = '/'+recordId;
	        }
	        catch(DMLException e){
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
	        }
	        
	        return result;
		}else if(parametersMap.get('type') == 'Reprocess'){
			FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();

	        try{
	            InvoiceService.reprocessInvoice(new Set<Id>{recordId});

	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.Reprocessed})) );
	            result.redirectURL = '/'+recordId;
	        }
	        catch(DMLException e){
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
	        }
	        
	        return result;
		}else if(parametersMap.get('type') == 'Reopen'){
			FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();

	        try{
	            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Open');
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {Label.Reopened})) );
	            result.redirectURL = '/'+recordId;
	        }
	        catch(DMLException e){
	            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,e.getDmlMessage(0)));
	        }
	        
	        return result;
		}
		return null;
	}

}