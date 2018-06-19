({
    doInit : function(component, event, helper) {
        try{
            var invoiceId = component.get('v.invoiceId');
            var action = component.get('c.getColumns');
            action.setParams({'recordId':invoiceId});
            action.setCallback(this, function(response) {
                try{
                    var spinner = $A.get("e.c:ToggleSpinnerEvent");
                    var toastEvent = $A.get("e.force:showToast");
                    var state = response.getState();
                    
                    if (component.isValid() && state === 'SUCCESS') {                    
                        var columns = response.getReturnValue();
                        var fieldset = [];
                        if (columns) {
                            if (columns.length>0) {
                                [].forEach.call(columns, function(field) {
                                    if(field.name == 'status') {
                                        fieldset.push({
                                            "apiName": field.name,
                                            "type": "subcomponent",
                                            "subcomponent": "c:ApprovalStepStatus",
                                            "label": {
                                                "type": "Custom",
                                                "value": field.label
                                            },
                                            "showLabel": true
                                        });
                                    } else {
                                        fieldset.push({
                                            'apiName': field.name,
                                            'type': helper.fieldTypeMap[field.name],
                                            'label': {
                                                'type': 'custom',
                                                'value': field.label
                                            },
                                            'showLabel': true
                                        });    
                                    }
                                });
                                component.set('v.fieldset',fieldset);
                                component.set('v.showApprovalHistory',true);
                                
                                helper.loadSteps(component, event, helper);
                            }
                        }
                        
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
        } catch(e) {
            console.log(e);
        }
    },
    paginator: function(component, event, helper){
        try{
            event.stopPropagation();
            var offset = event.getParam("offset");
            helper.loadSteps(component, event, helper);    
        } catch(e) {
            console.log(e);
        }
    }
})