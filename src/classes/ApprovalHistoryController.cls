public class ApprovalHistoryController {
	public static String recordId {get;set;}
	public Invoice__c cRecord {get;set{
			cRecord = value;
			ApprovalHistoryController.recordId = value.Id;
		}
	}

	public class RelatedColumn  {
		public String id{get;set;}
		public String Type{get;set;}
		public String Name{get;set;}
		public String Label{get;set;}
		public Boolean getIsCrossFormula(){return (Name.countMatches('.') == 0 || (Name.countMatches('.') ==  1 && Name.endsWith('.Name'))) ? false : true;}

		public RelatedColumn(String id, String type, String name, String label) {
			this.id = id;
			this.type = type;
			this.name = name;
			this.label = label;
		}
	}

	public class Row{
		public String action {get;set;}
		public Datetime stepDate {get;set;}
		public string status {get;set;}
		public string comments {get;set;}

		public Row(String action, Datetime stepDate, String status, String comments) {
			this.action = action;
			this.stepDate = stepDate;
			this.status = status;
			this.comments = comments;
		}
	}

	public List<RelatedColumn> columns { get {
		if (columns == null) {
			columns = new List<RelatedColumn>();
			columns.add(new RelatedColumn('1', 'string', 'action', 'Action'));
			columns.add(new RelatedColumn('2', 'datetime', 'stepDate', 'Date'));
			columns.add(new RelatedColumn('3', 'string', 'status', 'Status'));
			columns.add(new RelatedColumn('6', 'string', 'comments', 'Comments'));
		}
		return columns;
	} set; }

	public List<Row> recordObjects {get {
		if (recordObjects == null) {
			recordObjects = ApprovalHistoryController.getRecords(null,null,null,null,null,null);
		}
		return recordObjects;
	} set;}

	public Boolean noRecords {get {
		return recordObjects.isEmpty();
	} set;}

	@RemoteAction
    public static List<Row> getRecords( String objectName, String fields, Integer offset, String orderBy, String filter, Integer recordsPerPage) {
    	List<Row> records = new List<Row>();
			
		if (recordId!=null) {
			List<ProcessInstance> pis = InvoicesSelector.selectAllInvoiceApprovalProcessInstance(new Set<Id>{recordId});

			if (!pis.isEmpty()) {
				for (ProcessInstance pi: pis) {
					if (pi.StepsAndWorkitems != null) {
						for (ProcessInstanceHistory pih : pi.StepsAndWorkitems) {
							records.add(new Row((pih.StepStatus == 'Started' ? 'Approval Request Submitted' : ('Step: ' + (pih.ProcessNode!=null?pih.ProcessNode.Name:''))),pih.CreatedDate,pih.StepStatus == 'Started' ? 'Submitted' : pih.StepStatus,pih.Comments));
						}
					}
				}
			} else {
				List<Invoice__c> existingInvoices = new InvoicesSelector(new Set<String>{'FieloPRP__Status__c','FieloPRP__RejectReason__c','FieloPRP__Comments__c','LastModifiedDate'}).selectById(new Set<Id>{recordId});

				if (!existingInvoices.isEmpty()) {
					if (existingInvoices[0].Status__c == 'Approved' || existingInvoices[0].Status__c == 'Rejected') {
						records.add(new Row('Approval Request Submitted',existingInvoices[0].LastModifiedDate,existingInvoices[0].Status__c,(existingInvoices[0].Status__c == 'Approved' ? '' : existingInvoices[0].RejectReason__c + ': ') + (existingInvoices[0].Comments__c!=null?existingInvoices[0].Comments__c:'')));
					}
				}
			}
		}
		return records;
    }
}