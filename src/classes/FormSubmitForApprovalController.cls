public with sharing class FormSubmitForApprovalController {
    public FormSubmitForApprovalController(FormController controller) {
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

    public String userOptionsString {get{
        if (userOptionsString == null) {
            List<User> users = Database.query('SELECT Id, Name, IsActive FROM User WHERE IsActive = true');
            List<Entry> entries = new List<Entry>();

            if (!users.isEmpty()) {
                for(User u: users) {
                    entries.add(new Entry(u.Id, u.Name));
                }
            }
            userOptionsString = JSON.serialize(entries);
        }
        return userOptionsString;
    }set;}

    @RemoteAction
    public static FieloPLT.RemoteActionResult save(Map<String,String> record){
        Savepoint sp;
        FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();
        try{
            sp = Database.setSavepoint();

            if (!(record.get('ApproverId') == null)) {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments(Label.ApprovalRequestSubmitted);
                req1.setObjectId(record.get('Id'));
                req1.setNextApproverIds(new List<Id>{record.get('ApproverId')});

                Approval.ProcessResult approvalResult = Approval.process(req1);
            
                result.addMessage( new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'sent for approval'})) );
                result.redirectURL = '/'+record.get('Id');
            } else {
                result.addMessage( new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Error, Label.ApproverRequired) );
            }
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

    public class ApprovalResponse {
        FieloPLT.RemoteActionResult response {get;set;}
        Boolean choseApproverFirst {get;set;}

        public ApprovalResponse(FieloPLT.RemoteActionResult response, Boolean choseApproverFirst) {
            this.response = response;
            this.choseApproverFirst = choseApproverFirst;
        }
    }

    @RemoteAction
    public static ApprovalResponse submitForApproval(Map<String,String> record) {
        Savepoint sp;
        FieloPLT.RemoteActionResult result = new FieloPLT.RemoteActionResult();
        Boolean choseApproverFirst = false;
        try{
            sp = Database.setSavepoint();

            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(Label.ApprovalRequestSubmitted);
            req1.setObjectId(record.get('Id'));

            Approval.ProcessResult approvalResult = Approval.process(req1);
            
            InvoiceService.updateInvoiceStatus(new Set<Id>{record.get('Id')}, 'Pending For Approval');

            result.addMessage( new FieloPLT.RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, String.format(Label.InvoiceChangeStatusSuccess, new List<String> {'sent for approval'})) );
            result.redirectURL = '/'+record.get('Id');
        } catch(DMLException e){
            if(sp != null){
                Database.rollback(sp);
            }
            if(e.getMessage().contains('[nextApproverIds]')) {
                choseApproverFirst = true;
            }
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(e));
        } catch (Exception e) {
            if(e.getMessage().contains('[nextApproverIds]')) {
                choseApproverFirst = true;
            }
            result.addMessage(new FieloPLT.RemoteActionResult.RemoteActionMessage(e));
        }
        return new ApprovalResponse(result,choseApproverFirst);
    }
}