({
    setFieldset: function(component) {
        var invoiceItemFields = component.get('v.invoiceItemFields');
        var fieldMap = component.get('v.fieldMap');
        var fieldset = [];
        if (invoiceItemFields) {
            var fieldNames = invoiceItemFields.split(',');
            if (fieldNames && fieldNames.length > 0) {
                var nameAndType, type, apiName;
                fieldNames.forEach(function(fieldName) {
                    nameAndType = fieldName.split('/');
                    apiName = nameAndType[0].trim();
                    type = nameAndType[1] ? nameAndType[1].trim().toLowerCase() : 'output';
                    if (fieldNames.indexOf(fieldName) == 0) {
                        fieldset.push({
                            'apiName': apiName,
                            'type': type,
                            'label': {
                                "type": "default"
                            },
                            'showLabel': true
                        });
                    } else {
                        if (fieldMap[apiName]) {
                            fieldset.push({
                                "apiName": apiName,
                                "type": "subcomponent",
                                "subcomponent": "c:InvoiceOutputField",
                                "label": {
                                    "type": "default",
                                    "value": fieldMap[apiName].attributes.label
                                },
                                "config": JSON.stringify(fieldMap[apiName]),
                                "showLabel": true
                            });    
                        } else {
                            fieldset.push({
                                'apiName': apiName,
                                'type': type,
                                'label': {
                                    "type": "default"
                                },
                                'showLabel': true
                            });
                        }    
                    }
                    
                });
                component.set('v.fieldset', fieldset);
                component.set('v.showItems', false);
                component.set('v.showItems', true);
            }
        }
    },
    loadItems: function(component, event, helper, offset) {
        try{
            console.log('loadItems');
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();    
            }
            var invoiceId = component.get('v.invoiceId');
            var invoiceItemFields = component.get('v.invoiceItemFields');
            var quantity = component.get('v.quantity');
            var orderBy = component.get('v.orderBy');
            
            if(invoiceId){            
                var action = component.get('c.getItems');
                var params = {};
                
                params.itemFields = invoiceItemFields;
                params.invoiceId = invoiceId;
                params.quantity = (quantity ? quantity : 6) + 1;
                params.offset = offset > 0 && offset != null ? offset : 0;
                params.orderBy = orderBy;
                
                action.setParams(params);
                
                // Add callback behavior for when response is received
                action.setCallback(this, function(response) {
                    try{
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        var toastEvent = $A.get("e.force:showToast");
                        var state = response.getState();
                        
                        if (component.isValid() && state === 'SUCCESS') {                    
                            var items = response.getReturnValue();
                            component.set('v.items', items); 
                            component.set('v.showItems', true);
                        }else {
                            var errorMsg = response.getError()[0].message;
                            toastEvent.setParams({
                                "title": "loadItems: " + errorMsg,
                                "message": " ",
                                "type": "error"
                            });
                            toastEvent.fire(); 
                        }
                        if(spinner){
                            spinner.setParam('show', false);
                            spinner.fire();    
                        }
                    } catch(e) {
                        console.log(e);
                    }
                });      
                // Send action off to be executed
                $A.enqueueAction(action);
            }
        } catch(e) {
            console.log(e);
        }
    }
})