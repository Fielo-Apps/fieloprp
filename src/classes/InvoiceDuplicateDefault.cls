public class InvoiceDuplicateDefault implements InvoiceDuplicateInterface{
	
	public void setUniqueKey(List<Invoice__c> invoices, Boolean isUpdate){
		Set<Id> memberIds = new Set<Id>();
		for(Invoice__c invoice : invoices){
			if(invoice.InvoiceNumber__c != null){
				if(!isUpdate || (invoice.Distributor__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).Distributor__c || invoice.InvoiceNumber__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).InvoiceNumber__c)){
					memberIds.add(invoice.Member__c);
				}
			}
		}


		Map<Id,FieloPLT__Member__c> membersMap = new Map<Id,FieloPLT__Member__c>([SELECT FieloPLT__Program__c FROM FieloPLT__Member__c WHERE Id in : memberIds]);
		for(Invoice__c invoice : invoices){
			if(invoice.InvoiceNumber__c != null){
				if(!isUpdate || (invoice.Distributor__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).Distributor__c || invoice.InvoiceNumber__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).InvoiceNumber__c)){
					invoice.UniqueKeyField__c = String.valueOf(membersMap.get(invoice.Member__c).FieloPLT__Program__c);
                    invoice.UniqueKeyField__c = String.valueOf(invoice.Distributor__c) == null ? invoice.UniqueKeyField__c : invoice.UniqueKeyField__c + String.valueOf(invoice.Distributor__c);
                    invoice.UniqueKeyField__c +=  invoice.InvoiceNumber__c;
				}
			}else{
				invoice.UniqueKeyField__c = null;
			}
		}
	}

	public void validateDuplicates(List<Invoice__c> invoices, Boolean isUpdate){
		Map<String,Invoice__c> keyInvoicesMap = new Map<String,Invoice__c>();
		for(Invoice__c invoice : invoices){
			if(String.isNotBlank(invoice.UniqueKeyField__c)){
				if(!isUpdate || (invoice.Distributor__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).Distributor__c || invoice.Status__c != ((Invoice__c)Trigger.oldMap.get(invoice.Id)).Status__c)){
					keyInvoicesMap.put(invoice.UniqueKeyField__c, invoice);
				}
			}
		}

		if(!keyInvoicesMap.isEmpty()){
			Set<String> existingKeys = new Set<String>();
			for(Invoice__c invoice : [SELECT UniqueKeyField__c FROM Invoice__c WHERE Status__c = 'Approved' AND UniqueKeyField__c in : keyInvoicesMap.keySet() AND Id not in : invoices]){
				existingKeys.add(invoice.UniqueKeyField__c);
			}

			for(Invoice__c invoice : keyInvoicesMap.values()){
				if(String.isNotBlank(invoice.UniqueKeyField__c) && existingKeys.contains(invoice.UniqueKeyField__c)){
					invoice.addError(Label.DuplicatedInvoiceRecord);
				}else if(invoice.Status__c == 'Approved'){
					existingKeys.add(invoice.UniqueKeyField__c);
				}
			}
		}
	}

}