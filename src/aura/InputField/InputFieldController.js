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
                
                var ua = navigator.userAgent.toLowerCase(); 
                if (ua.indexOf('safari') != -1) { 
                  if (ua.indexOf('chrome') > -1) {
                    var isSafari = false;
                  } else {
                    var isSafari = true;
                  }
                }
                //var isSafari = navigator.userAgent.toLowerCase().indexOf('safari/') > -1;
                    //  /constructor/i.test(window.HTMLElement) || (function (p) { return p.toString() === "[object SafariRemoteNotification]"; })(!window['safari'] || (typeof safari !== 'undefined' && safari.pushNotification));
                var notSafari = isSafari ? false : true;
                console.log('Safari? ' + isSafari);
                component.set('v.notSafari', notSafari);
            }
        } catch(e) {
            console.log(e);
        }
    },
    handleChange : function(component, event, helper) {
        try{
            var fieldMeta = component.get("v.fieldMeta");
            var compEvent = component.getEvent("fieldUpdate");
            var oldFieldValue = component.get("v.oldFieldValue");
            var fieldName = event.getSource().get('v.name');
            var fieldValue = event.getSource().get('v.value');
            var fireEvent = true;
            console.log('inputType: ' + fieldMeta.attributes.inputType);
            
            if (fieldMeta.attributes.type == "date") {
                if((new Date(String(fieldValue))).getFullYear() >= 10000) {
                    component.set('v.fieldValue', oldFieldValue);
                    helper.setFieldValueByType(component, oldFieldValue);
                    fireEvent = false;
                } 
            }
            if (fireEvent) {
                fieldValue = fieldValue ? fieldValue : '';
				component.set('v.fieldValue', Object.prototype.valueOf.call(fieldValue));    
            	helper.fireFieldUpdate(component, fieldName, Object.prototype.valueOf.call(fieldValue));
            	component.set('v.oldFieldValue', Object.prototype.valueOf.call(fieldValue));
            }
        } catch (e) {
            console.log(e);
        }
    },
    formatField: function(component, event, helper) {
        try{
            var fieldMeta = component.get("v.fieldMeta");
            var fieldValue = component.get("v.fieldValue");
            if (component.get('v.fieldMeta').attributes.inputType == 'number') {
            	component.set('v.decimalValue', Number(fieldValue).toFixed((component.get('v.fieldMeta').attributes.step.split('.')[1] || []).length));    
            }
        } catch(e) {
            console.log(e);
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