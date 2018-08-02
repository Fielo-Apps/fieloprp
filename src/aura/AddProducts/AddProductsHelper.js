({
    loadProducts : function(component, event, helper, offset) {
        var spinner = $A.get("e.c:ToggleSpinnerEvent");
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }
        var fieldset = component.get('v.fieldset');
        fieldset = helper.getFieldset(fieldset).fieldset;
        var dynamicFilter = component.get('v.dynamicFilter');
        var quantity = component.get('v.quantity');
        var orderBy = component.get('v.orderBy');
        var action = component.get('c.getProducts');
        var params = {};
        params.fieldsInvoices = fieldset;
        params.dynamicFilter = dynamicFilter ? dynamicFilter : '';
        params.quantity = (quantity ? quantity : 6) + 1;
        params.offset = offset > 0 && offset != null ? offset : 0;
        params.orderBy = orderBy;
        
        action.setParams(params);
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            //  console.log(JSON.stringify(response.getReturnValue(), null, 2));
            if (component.isValid() && state === 'SUCCESS') {                    
                var products = response.getReturnValue();
                component.set('v.productRecords', products);
            }else {
                var errorMsg = response.getError()[0].message;
                toastEvent.setParams({
                    "title": "loadProducts: " + errorMsg,
                    "message": " ",
                    "type": "error"
                });
                toastEvent.fire(); 
            }
            if(spinner){
                spinner.setParam('show', false);
                spinner.fire();    
            }
        });      
        // Send action off to be executed
        $A.enqueueAction(action);
        
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
        // console.log(JSON.stringify(fields.subcomponents, null, 2));
        return fields;
    },
    setSelectors: function(component) {
        try {
            var selectedProcucts = component.get('v.selectedProducts');
            var selectors = component.get('v.rowSelectors');
            var singleSelector;
            selectedProcucts.forEach(function(product) {
                var singleSelector = selectors.filter(function(selector) {
                    return selector.get('v.record').Id === product.Id;
                });
                if (singleSelector.length == 1) {
                    singleSelector.set('v.selected', true);
                }
            });    
        } catch (e) {
            console.log(e);
        }
    }
})