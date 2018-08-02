public class ApprovalHistoryListViewController {
	@AuraEnabled
    public static List<Map<String, String>> getRecords( String recordId ) {
    	List<Map<String, String>> records = new List<Map<String, String>>();
			
		if (recordId!=null) {
			List<ProcessInstance> pis = InvoicesSelector.selectAllInvoiceApprovalProcessInstance(new Set<Id>{recordId});
 
			if (!pis.isEmpty()) {
				for (ProcessInstance pi: pis) {
					if (pi.StepsAndWorkitems != null) {
						for (ProcessInstanceHistory pih : pi.StepsAndWorkitems) {
							records.add(new Map<String, String>{'stepDate' => pih.CreatedDate.format('yyyy-MM-dd'),'status' => pih.StepStatus == 'Started' ? Label.Submitted : pih.StepStatus,'comments' => pih.Comments});
						}
					}
				}
			} else {
				List<SObject> existingInvoices = new InvoicesSelector(
					new Set<String>{
						'FieloPRP__Status__c',
						'toLabel(FieloPRP__Status__c) FieloPRP__Status__label',
						'FieloPRP__RejectReason__c',
						'FieloPRP__Comments__c',
						'LastModifiedDate'
					}).selectById(
						new Set<Id> {
							recordId
						}
					);

				if (!existingInvoices.isEmpty()) {
					records.add(
						new Map<String, String> {
							'stepDate' => ((Datetime)existingInvoices[0].get('LastModifiedDate')).format('yyyy-MM-dd'),
							'status' => String.valueOf(existingInvoices[0].get('FieloPRP__Status__label')),
							'comments' => (String.valueOf(existingInvoices[0].get('FieloPRP__Status__c')) == 'Rejected' ?
								String.valueOf(existingInvoices[0].get('FieloPRP__RejectReason__c')) + ': ' :
								'') + ( existingInvoices[0].get('FieloPRP__Comments__c') != null ?
									String.valueOf(existingInvoices[0].get('FieloPRP__Comments__c')) :
									'')
						}
					);
				}
			}
		}
		return records;
    }

    @AuraEnabled
    public static List<Object> getColumns(String recordId) {
		List<Map<String, String>> columns = new List<Map<String, String>>();

		List<ProcessInstance> pis = InvoicesSelector.selectAllInvoiceApprovalProcessInstance(new Set<Id>{recordId});
		if (recordId!=null) {
			if (!pis.isEmpty()) {
				columns.add(new Map<String, String>{'id'=>'5', 'type'=>'string', 'name'=>'status', 'label'=>Label.Status});
				columns.add(new Map<String, String>{'id'=>'6', 'type'=>'string', 'name'=>'comments', 'label'=>Label.Comments});
				columns.add(new Map<String, String>{'id'=>'2', 'type'=>'datetime', 'name'=>'stepDate', 'label'=>Label.Date});
			} 
		}

		if (columns.isEmpty()) {
			columns.add(
				new Map<String, String>{
					'id'=>'5',
					'type'=>'string',
					'name'=>'status',
					'label'=>Label.Status
				}
			);
			columns.add(
				new Map<String, String>{
					'id'=>'6',
					'type'=>'string',
					'name'=>'comments',
					'label'=>Label.Comments
				}
			);
			columns.add(
				new Map<String, String>{
					'id'=>'2',
					'type'=>'datetime',
					'name'=>'stepDate',
					'label'=>Label.Date
				}
			);
		}
		return (List<Object>) columns;
	}
}