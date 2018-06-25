({
    doInit : function(component, event, helper) {
        try{
            var record = component.get('v.record');
            var name = 'FieloPRP__Status__c';
            var label = name.replace('__c','__label');
            if (record[name]) {
                name = name
                if (record[label]) {
                    component.set('v.output', record[label]);
                    component.set('v.class', helper.colorsMap[record[name]]);
                }
            }    
        } catch(e) {
            console.log(e);
        }
    }
})