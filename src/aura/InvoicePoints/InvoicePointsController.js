({
    doInit : function(component, event, helper) {
        try{
            var record = component.get('v.record');
            var points = 0;
            if (record['FieloPRP__Transactions__r']) {
                record['FieloPRP__Transactions__r'].forEach(function(transaction) {
                    points += transaction.FieloPLT__Points__c;
                });
            }
            if (record['FieloPRP__Trackers__r']) {
                record['FieloPRP__Trackers__r'].forEach(function(tracker) {
                    points += tracker.FieloPLT__Transaction__r.FieloPLT__Points__c;
                });
            }
            if (points > 0) {
            	component.set('v.output', String(points));        
            }
        } catch(e) {
            console.log(e);
        }
    }
})