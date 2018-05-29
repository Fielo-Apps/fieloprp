({
    removeFile : function(component, fileId) {
        var compEvent = component.getEvent("removeInvoiceFile");
        compEvent.setParams({
            "fileId" : fileId
        });
        compEvent.fire();
    }
})