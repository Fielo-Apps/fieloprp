public class InvoiceDuplicateDefault implements InvoiceDuplicateInterface{
	
	public void setUniqueKey(List<Invoice__c> invoices, Boolean isUpdate){
		Set<Id> memberIds = new Set<Id>();
		for(Invoice__c invoice : invoices){
			if(invoice.Distributor__c != null && invoice.InvoiceNumber__c != null){
				if(!isUpdate || (invoice.Distributor__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).Distributor__c || invoice.InvoiceNumber__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).InvoiceNumber__c)){
					memberIds.add(invoice.Member__c);
				}
			}
		}

		Map<Id,FieloPLT__Member__c> membersMap = new Map<Id,FieloPLT__Member__c>([SELECT FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id in : memberIds]);
		for(Invoice__c invoice : invoices){
			if(invoice.Distributor__c != null && invoice.InvoiceNumber__c != null){
				if(!isUpdate || (invoice.Distributor__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).Distributor__c || invoice.InvoiceNumber__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).InvoiceNumber__c)){
					invoice.UniqueKey__c = String.valueOf(membersMap.get(invoice.Member__c).FieloPLT__Program__c) + String.valueOf(invoice.Distributor__c) + invoice.InvoiceNumber__c;
				}
			}else{
				invoice.UniqueKey__c = null;
			}
		}
	}

	public void validateDuplicates(List<Invoice__c> invoices, Boolean isUpdate){
		Set<String> uniqueKeys = new Set<String>();
		for(Invoice__c invoice : invoices){
			if(String.isNotBlank(invoice.UniqueKey__c)){
				if(!isUpdate || (invoice.Distributor__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).Distributor__c || invoice.InvoiceNumber__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).InvoiceNumber__c)){
					uniqueKeys.add(invoice.UniqueKey__c);
				}
			}
		}

		if(!uniqueKeys.isEmpty()){
			Set<String> existingKeys = new Set<String>();
			for(Invoice__c invoice : [SELECT UniqueKey__c FROM Invoice__c WHERE Status__c = 'Approved' AND UniqueKey__c in : uniqueKeys]){
				existingKeys.add(invoice.UniqueKey__c);
			}

			for(Invoice__c invoice : invoices){
				if(String.isNotBlank(invoice.UniqueKey__c) && existingKeys.contains(invoice.UniqueKey__c)){
					invoice.addError(Label.DuplicatedInvoiceRecord);
				}else if(invoice.Status__c == 'Approved'){
					existingKeys.add(invoice.UniqueKey__c);
				}
			}
		}
	}

}