({
    doInit: function(component, event, helper) {
        try{
            if (!component.get('v.registered')) {
                var registerFieldEvent = component.getEvent("fieldRegister");
                registerFieldEvent.setParams({
                    'name': 'InputField',
                    'component':component
                });
                registerFieldEvent.fire();
                component.set('v.registered',true);
            }
        } catch(e) {
            console.log(e);
        }
    },
    handleChange : function(component, event, helper) {
        console.log('handleChange');
        try{
            var fieldMeta = component.get("v.fieldMeta");
            var compEvent = component.getEvent("fieldUpdate");
            var fieldName = event.getSource().get('v.name');
            var fieldValue = event.getSource().get('v.value');
            component.set('v.fieldValue', Object.prototype.valueOf.call(fieldValue));
            helper.fireFieldUpdate(component, fieldName, Object.prototype.valueOf.call(fieldValue));
        } catch (e) {
            console.log(e.toString());
        }
    },
    setFieldValue: function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set('v.fieldValue', params.fieldValue);
        helper.setFieldValueByType(component, params.fieldValue);
    },
    handleUpdate: function(component, event, helper) {
        helper.setFieldValueByType(component, component.get('v.fieldValue'));
    },
    lookupRegister: function(component, event, helper) {
        component.set('v.lookupComponent', event.getParam('component'));
    },
    lookupUpdate: function(component, event, helper) {
        component.set('v.fieldValue', event.getParam('fieldValue'));
    }
})