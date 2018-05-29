({
    doInit: function(component, event, helper) {
        try{
            var record = component.get('v.record');
            var invoiceLabel = $A.get('$Label.c.Invoice') + ' ' + record.FieloPRP__InvoiceNumber__c;
            component.set('v.invoiceLabel', invoiceLabel);
            component.set('v.filePtr',0);
            
            helper.getFieldsMetadata(component,helper);
            
            helper.getFiles(component,helper);
            
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', false);
                spinner.fire();
            }    
        } catch(e) {
            console.log(e);
        }
    },
    backToMyInvoices: function(component, event, helper) {
        var compEvent = component.getEvent("showMyInvoices");
        compEvent.fire();
    },
    previous: function(component, event, helper) {
        try{
            var filePtr = component.get('v.filePtr');
            var fileList = component.get('v.fileList');
            filePtr--;
            component.set('v.filePtr', filePtr);
            if (fileList[filePtr]) {
                if (fileList[filePtr].id) {
                    component.set('v.currentFile', fileList[filePtr]);
                }
            }
        } catch(e) {
            console.log(e);
        }
    },
    next: function(component, event, helper) {
        try{
            var filePtr = component.get('v.filePtr');
            var fileList = component.get('v.fileList');
            filePtr++;
            component.set('v.filePtr', filePtr);
            if (fileList[filePtr]) {
                if (fileList[filePtr].id) {
                    component.set('v.currentFile', fileList[filePtr]);
                }
            }
        } catch(e) {
            console.log(e);
        }
    }
})