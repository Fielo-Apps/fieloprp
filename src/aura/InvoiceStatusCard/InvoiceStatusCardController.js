({
	doInit : function(component, event, helper) {
		var record = component.get('v.record');
        var output = $A.get('$Label.c.YourInvoiceIs') + ' ' + record.FieloPRP__Status__label.toLowerCase();
        component.set('v.output',output);
        component.set('v.iconName', helper.iconMap[record.FieloPRP__Status__c]);
        component.set('v.statusClass', helper.colorsMap[record.FieloPRP__Status__c]);
        component.set('v.variant', helper.variantMap[record.FieloPRP__Status__c]);
	}
})