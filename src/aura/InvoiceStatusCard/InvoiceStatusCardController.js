({
    doInit : function(component, event, helper) {
        var record = component.get('v.record');
        var output = $A.get('$Label.c.YourInvoiceIs') + ' ' + record.FieloPRP__Status__label.toLowerCase();
        component.set('v.output',output);
        if (record.FieloPRP__Status__c == 'Rejected' || record.FieloPRP__Status__c == 'Approved') {
            component.set('v.outputSubtitle', record.FieloPRP__Comments__c);    
        }
        if (record.FieloPRP__Status__c == 'Approved') {
            var outputSubtitle = '';
            var points = 0;
            if (record['FieloPRP__Transactions__r']) {
                record['FieloPRP__Transactions__r'].forEach(function(transaction) {
                    points += transaction.FieloPLT__Points__c;
                });
            } else {
                console.log('FieloPRP__Transactions__r missing');
            }
            if (record['FieloPRP__Trackers__r']) {
                record['FieloPRP__Trackers__r'].forEach(function(tracker) {
                    points += tracker.FieloPLT__Transaction__r.FieloPLT__Points__c;
                });
            } else {
                console.log('FieloPRP__Trackers__r missing');
            }
            if (points > 0) {
                component.set('v.outputSubtitle', helper.format($A.get('$Label.c.CongratulationsMsg'), points));
            }
        }
        component.set('v.iconName', helper.iconMap[record.FieloPRP__Status__c]);
        component.set('v.statusClass', helper.colorsMap[record.FieloPRP__Status__c]);
        component.set('v.variant', helper.variantMap[record.FieloPRP__Status__c]);
    }
})