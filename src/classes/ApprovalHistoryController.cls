public with sharing class ApprovalHistoryController {
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
		public string assignedTo {get;set;}
		public string approver {get;set;}
		public string status {get;set;}
		public string comments {get;set;}

		public Row(String action, Datetime stepDate, String assignedTo, String approver, String status, String comments) {
			this.action = action;
			this.stepDate = stepDate;
			this.assignedTo = assignedTo;
			this.approver = approver;
			this.status = status;
			this.comments = comments;
		}
	}

	public List<RelatedColumn> columns { get {
		if (columns == null) {
			columns = new List<RelatedColumn>();

			List<ProcessInstance> pis = InvoicesSelector.selectAllInvoiceApprovalProcessInstance(new Set<Id>{recordId});
			if (recordId!=null) {
				if (!pis.isEmpty()) {
					columns.add(new RelatedColumn('1', 'string', 'action', Label.Action));
					columns.add(new RelatedColumn('2', 'datetime', 'stepDate', Label.Date));
					columns.add(new RelatedColumn('3', 'string', 'assignedTo', Label.AssignedTo));
					columns.add(new RelatedColumn('4', 'string', 'approver', Label.Approver));
					columns.add(new RelatedColumn('5', 'string', 'status', Label.Status));
					columns.add(new RelatedColumn('6', 'string', 'comments', Label.Comments));
				} 
			}

			if (columns.isEmpty()) {
				columns.add(new RelatedColumn('1', 'string', 'action', Label.Action));
				columns.add(new RelatedColumn('2', 'datetime', 'stepDate', Label.Date));
				columns.add(new RelatedColumn('3', 'string', 'status', Label.Status));
				columns.add(new RelatedColumn('4', 'string', 'comments', Label.Comments));
			}
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
							records.add(new Row((pih.StepStatus == 'Started' ? Label.ApprovalRequestSubmitted : (Label.StepName + ': ' + (pih.ProcessNode!=null?pih.ProcessNode.Name:''))),pih.CreatedDate,pih.OriginalActor.Name,pi.LastActor.Name,pih.StepStatus == 'Started' ? Label.Submitted : pih.StepStatus,pih.Comments));
						}
					}
				}
			} else {
				List<Invoice__c> existingInvoices = new InvoicesSelector(new Set<String>{'FieloPRP__Status__c','FieloPRP__RejectReason__c','FieloPRP__Comments__c','LastModifiedDate'}).selectById(new Set<Id>{recordId});

				if (!existingInvoices.isEmpty()) {
					if (existingInvoices[0].Status__c == 'Approved' || existingInvoices[0].Status__c == 'Rejected') {
						records.add(new Row(Label.SingleInvoiceApprovalAction,existingInvoices[0].LastModifiedDate,null,null,existingInvoices[0].Status__c,(existingInvoices[0].Status__c == 'Approved' ? '' : existingInvoices[0].RejectReason__c + ': ') + (existingInvoices[0].Comments__c!=null?existingInvoices[0].Comments__c:'')));
					}
				}
			}
		}
		return records;
    }
}