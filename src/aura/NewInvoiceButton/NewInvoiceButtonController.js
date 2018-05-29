({
	newInvoice : function(component, event, helper) {
		var compEvent = component.getEvent("newInvoice");
        compEvent.fire();
	}
})