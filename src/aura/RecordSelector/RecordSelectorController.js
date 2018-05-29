({
    doInit: function(component, event, helper) {
        try{
            var registerFieldEvent = component.getEvent("registerSelector");
            registerFieldEvent.setParams({
                'component': component
            });
            registerFieldEvent.fire();
        } catch(e) {
            console.log(e);
        }
    },
    handleChange: function(component, event, helper) {
        try{
            if (event.target.checked) {
                var registerFieldEvent = component.getEvent("selectRecord");
                registerFieldEvent.setParams({
                    'record': component.get('v.record')
                });
                registerFieldEvent.fire();
            } else {
                var registerFieldEvent = component.getEvent("unselectRecord");
                registerFieldEvent.setParams({
                    'id': component.get('v.record').Id
                });
                registerFieldEvent.fire();
            }
        } catch(e) {
            console.log(e);
        }
    },
    selectRecord: function(component, event, helper) {
        try{
            var params = event.getParam('arguments');
            var selected = params.selected;
            component.set('v.selected', selected);
        } catch(e) {
            console.log(e);
        }
    }
})