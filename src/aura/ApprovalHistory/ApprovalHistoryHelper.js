({
    loadSteps: function(component, event, helper) {
        try{
            console.log('loadSteps');
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();    
            }
            var invoiceId = component.get('v.invoiceId');
            
            if(invoiceId){            
                var action = component.get('c.getRecords');
                action.setParams({'recordId':invoiceId});
                
                // Add callback behavior for when response is received
                action.setCallback(this, function(response) {
                    try{
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        var toastEvent = $A.get("e.force:showToast");
                        var state = response.getState();
                        
                        if (component.isValid() && state === 'SUCCESS') {                    
                            var steps = response.getReturnValue();
                            console.log(JSON.stringify(steps, null, 2));
                            component.set('v.steps', steps);
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
    },
    fieldTypeMap: {
        'action': 'output',
        'stepDate': 'date',
        'assignedTo': 'output',
        'approver': 'output',
        'status': 'output',
        'comments': 'output'
    }
})