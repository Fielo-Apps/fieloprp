({
    getProgram: function(component, event, helper) {
        try{
            var memberId = component.get('v.member').Id;
            var action = component.get('c.getActiveProgram');
            action.setParams({
                'memberId': memberId
            });
            action.setCallback(this, function(response) {
                try{
                    var spinner = $A.get("e.c:ToggleSpinnerEvent");
                    var toastEvent = $A.get("e.force:showToast");
                    var state = response.getState();
                    if (component.isValid() && state === 'SUCCESS') {                    
                        var program = response.getReturnValue();
                        component.set('v.program', program);
                    }else {
                        var errorMsg = response.getError()[0].message;
                        toastEvent.setParams({
                            "title": "loadInvoices: " + errorMsg,
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
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }
    },
    loadInvoices : function(component, event, helper, offset) {
        try{
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();    
            }
            var member = component.get('v.member');
            var fieldset = component.get('v.fieldset');
            fieldset = helper.getFieldset(fieldset).fieldset;
            var whereClause = component.get('v.whereClause');
            var quantity = component.get('v.quantity');
            var orderBy = component.get('v.orderBy');
            if(member){            
                var action = component.get('c.getInvoices');
                var params = {};
                params.fieldsInvoices = fieldset;
                params.memberId = member.Id;
                params.whereClause = whereClause ? whereClause : '';
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
                            var invoices = response.getReturnValue();
                            component.set('v.myInvoices', invoices); 
                            component.set('v.showMyInvoices', true);
                            component.set('v.showNewButton', true);
                        }else {
                            var errorMsg = response.getError()[0].message;
                            toastEvent.setParams({
                                "title": "loadInvoices: " + errorMsg,
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
    getFieldset : function(fieldset) {
        var fields = {fieldset: ['Name'], subcomponents: []};
        fieldset.forEach(function(field){
            if(field.type != 'subcomponent'){
                fields.fieldset.push(field.apiName);
            } else {
                fields.subcomponents.push(field);
                if (fields.fieldset.indexOf(field.apiName)==-1) {
                    fields.fieldset.push(field.apiName);
                }
            }           
        })
        return fields;
    },
    goToView: function(component, viewName) {
        switch(viewName.toLowerCase()) {
            case 'myinvoices':
                component.set('v.showNewInvoice', false);
                component.set('v.showHeader', true);
                component.set('v.showMyInvoices', true);
                component.set('v.showInvoiceRecord', false);
                break;
                
            case 'invoicerecord':
                component.set('v.showHeader', false);
                component.set('v.showMyInvoices', false);
                component.set('v.showNewInvoice', false);
                component.set('v.showInvoiceRecord', true);
                break;
                
            case 'invoiceupload':
                component.set('v.showHeader', false);
                component.set('v.showMyInvoices', false);
                component.set('v.showNewInvoice', true);
                component.set('v.showInvoiceRecord', false);
                break;
                
            default: /* MyInvoices */
                component.set('v.showNewInvoice', false);
                component.set('v.showHeader', true);
                component.set('v.showMyInvoices', true);
                component.set('v.showInvoiceRecord', false);
                break;
        }
        
    }
})