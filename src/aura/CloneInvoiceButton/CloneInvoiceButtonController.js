({
	cloneInvoice : function(component, event, helper) {
		var compEvent = component.getEvent("cloneInvoice");
        compEvent.setParams({'Id':component.get('v.record').Id});
        compEvent.fire();
	}
})