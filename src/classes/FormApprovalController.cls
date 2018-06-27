public with sharing class FormApprovalController {
    public FormApprovalController(FormController controller) {
    }

    public class Entry {
        public String Id{get;set;}
        public String Label{get;set;}
        public String MetaLabel{get;set;}

        public Entry ( String Id, String Label ) {
              this.Id = Id;
              this.Label = Label;
            }
    }

    public String rejectOptionsString {get{
        if (rejectOptionsString == null) {
            Schema.DescribeFieldResult fieldResult = Invoice__c.RejectReason__c.getDescribe();
            List<Schema.PicklistEntry> ples = fieldResult.getPicklistValues();
            List<Entry> entries = new List<Entry>();

            for(Schema.PicklistEntry ple: ples) {
                entries.add(new Entry(ple.getValue(), ple.getLabel()));
            }
            
            rejectOptionsString = JSON.serialize(entries);
        }
        return rejectOptionsString;
    }set;}

    @RemoteAction
    public static FieloPLT.RemoteActionResult save(FieloPRP__Invoice__c record, String action, List<String> nullFields){
        Savepoint sp;
        FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();
        try{
            sp = Database.setSavepoint();

            for(String f: nullFields){
              if ( f != 'sObjectType' ) {
               record.put(f, null );
              }
            }

            List<FieloPRP__Invoice__c> exitingInvoices = new InvoicesSelector(new Set<String>{'Id','FieloPRP__Status__c','FieloPRP__Member__r.FieloPLT__Program__r.FieloPRP__RequestInvoiceAuthorization__c'}).selectById(new Set<Id>{record.Id});

            // Approve or Reject
            result = new InvoiceButtonImpl().executeAction(new List<Id>{record.Id}, JSON.serialize(new Map<String,String>{'type'=>action}));

            // Save Comments/Reject Reason
            update record;

            // CIP 1.1 FA-259
            InvoiceService.processWorkingItems(new Set<Id>{record.Id});
        }catch(DMLException e){
            if(sp != null){
                Database.rollback(sp);
            }
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(e));
        }catch(Exception e){
            if(sp != null){
                Database.rollback(sp);
            }
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(e));
        }
        return result;
    }
}