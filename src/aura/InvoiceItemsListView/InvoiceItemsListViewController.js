({
    doInit : function(component, event, helper) {
        try{
            var fieldset = [];
            var invoiceItemFields = component.get('v.invoiceItemFields');
            if (invoiceItemFields) {
                var action = component.get('c.getFieldData');
                action.setParams({
                    'objectName': component.get('v.objectName'),
                    'fieldNames': invoiceItemFields
                });
                
                action.setCallback(this, function(response) {
                    try { 
                        var state = response.getState();
                        var toastEvent = $A.get("e.force:showToast");
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        
                        if (component.isValid() && state === 'SUCCESS') {                    
                            var objectInfo = JSON.parse(response.getReturnValue());
                            var fieldMap = {};
                            objectInfo.fields.forEach(function(fieldInfo) {
                                fieldMap[fieldInfo.attributes.name] = fieldInfo;
                            });
                            component.set('v.fieldMap', fieldMap);
                            helper.setFieldset(component);
                            helper.loadItems(component, event, helper, 0);
                        }else {
                            var errorMsg = response.getError()[0].message;
                            toastEvent.setParams({
                                "title": errorMsg,
                                "message": " ",
                                "type": "error"
                            });
                            toastEvent.fire(); 
                            if(spinner){
                                spinner.setParam('show', false);
                                spinner.fire();    
                            } 
                        }
                    } catch(e) {
                        console.log(e);
                    }
                });
                $A.enqueueAction(action);
            }    
        } catch(e) {
            console.log(e);
        }
    },
    paginator: function(component, event, helper){
        try{
            event.stopPropagation();
            var offset = event.getParam("offset");
            helper.loadItems(component, event, helper, offset);    
        } catch(e) {
            console.log(e);
        }
    }
})