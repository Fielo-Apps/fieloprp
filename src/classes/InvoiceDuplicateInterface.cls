global interface InvoiceDuplicateInterface{
	void setUniqueKey(List<Invoice__c> invoices, Boolean isUpdate);
	void validateDuplicates(List<Invoice__c> invoices, Boolean isUpdate);
}