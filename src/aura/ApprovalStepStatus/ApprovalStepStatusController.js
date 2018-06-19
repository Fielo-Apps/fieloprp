({
    doInit : function(component, event, helper) {
        try{
            var record = component.get('v.record');
            var name = 'status';
            if (record[name]) {
                component.set('v.output', record[name]);
                if (helper.colorsMap[record[name]]) {
                	component.set('v.class', helper.colorsMap[record[name]]);
                } else {
                    component.set('v.class', 'fielo-invoice-status--pending');
                }
            }    
        } catch(e) {
            console.log(e);
        }
    }
})