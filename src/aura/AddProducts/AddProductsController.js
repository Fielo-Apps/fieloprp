({
    doInit: function(component, event, helper){
        var title, fields, fieldset;
        var config = component.get('v.configDefault');
        
        try{
            config = JSON.parse(config);     
            // CHECK IF BASIC CONFIG OVERRIDES ADVANCED CONFIG
            // TITLE
            var titleValue = component.get('v.titleValue').trim();
            if(titleValue.length > 0){
                if (titleValue.indexOf('{') == 0) {
                    title = JSON.parse(titleValue);
                } else {
                    title = {
                        "value": component.get('v.titleValue'),
                        "type": "text"
                    };                    
                }
            }
            if (title) {
                titleValue = '';
                var type = title.type.toLowerCase();
                var value = title.value;
                if(type == 'label'){
                    var label = '$Label.' + value;
                    titleValue = $A.get(label);
                    component.set('v.title', titleValue);                
                }else{
                    titleValue = value;
                    component.set('v.title', titleValue);
                }
            }
            // TITLE
            // FIELDSET
            fieldset = [], fields = [];                        
            var fieldsConfig = component.get('v.fields').trim();
            if(fieldsConfig.length == 0){
                fieldset = config.fieldset;                
            } else if (fieldsConfig.indexOf('[') == 0) {
                fieldset = JSON.parse(fieldsConfig);
            } else {
                fieldset.push({
                    "apiName": "Id",
                    "type": "subcomponent",
                    "subcomponent": "c:RecordSelector",
                    "label": {
                        "type": "default"
                    },
                    "showLabel": false
                });
                var newField, nameAndType, apiName, type;
                var fieldsList = fieldsConfig.split(',');
                fieldsList.forEach(function(field){
                    nameAndType = field.split('/');
                    apiName = nameAndType[0].trim();
                    type = nameAndType[1] ? nameAndType[1].trim().toLowerCase() : 'output';
                    newField = {
                        'apiName': apiName,
                        'type': type,
                        'label': {
                            "type": "default"
                        },
                        'showLabel': true
                    }
                    fieldset.push(newField);                        
                })
            }
            // console.log(JSON.stringify(fieldset, null, 2));
            var selectedProductFieldSet = fieldset.filter(function(field){
                return field.type != 'subcomponent';
            });
            component.set('v.fieldset', fieldset);
            component.set('v.selectedProductfieldset', selectedProductFieldSet);
            // console.log('doInit done!')
            helper.loadProducts(component, event, helper, 0);
        } catch(e) {
            console.log(e);
            component.set('v.error', e);
            component.set('v.showError', true);
        }            
    },
    productSelected: function(component, event, helper) {
        console.log('productSelected');
        event.stopPropagation();
        var productRecord = event.getParam('record');
        var selectedProducts = component.get('v.selectedProducts');
        if (!selectedProducts) {
            selectedProducts = [];
        }
        selectedProducts.push(productRecord);
        component.set('v.selectedProducts', selectedProducts);
    },
    productUnselected: function(component, event, helper) {
        console.log('productUnselected');
        event.stopPropagation();
        var productId = event.getParam('id');
        var selectedProducts = component.get('v.selectedProducts');
        var newSelectedProducts = selectedProducts.filter(function(product){
            return product.Id != productId;
        });
        component.set('v.selectedProducts', newSelectedProducts);
    },
    filterProducts: function(component, event, helper) {
        event.stopPropagation();
        try{
            var whereClause = event.getParam('whereClause');
            component.set('v.whereClause', whereClause);
            component.set('v.rowSelectors', []);
            helper.loadProducts(component, event, helper, 0);
        } catch(e) {
            console.log(e);
        }
    },
    registerComponent: function(component, event, helper) {
        try{
            var selectors = component.get('v.rowSelectors');
            if (!selectors) {
                selectors = [];
            }
            selectors.push(event.getParam('component'));
            component.set('v.rowSelectors', selectors);    
        } catch (e) {
            console.log(e);
        }
    },
    handleAddSelector: function(component, event, helper) {
        try{
            var selectors = event.getParam('value');
            if (selectors) {
                if (selectors.length > 0) {
                    var selectedProcucts = component.get('v.selectedProducts');
                    var checked = selectedProcucts.some(function(product) {
                        return selectors[selectors.length-1].get('v.record').Id == product.Id; 
                    });
                    if (checked) {
                        selectors[selectors.length-1].set('v.selected',true);
                    }
                }
            }
        } catch (e) {
            console.log(e);
        }
    },
    paginator: function(component, event, helper) {
        event.stopPropagation();
        var offset = event.getParam("offset");
        helper.loadProducts(component, event, helper, offset);
    },
    closeModal: function(component, event, helper) {
        try{
            var closeModalEvent = component.getEvent("closeAddProducts");
            closeModalEvent.fire();
        } catch(e) {
            console.log(e);
        }
    },
    addProducts: function(component, event, helper) {
        try{
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();
            }
            var save = component.get('c.save');
            $A.enqueueAction(save);
        } catch(e) {
            console.log(e);
        }
    },
    save: function(component, event, helper) {
        var saveEvent = component.getEvent("saveProducts");
        var products = component.get('v.selectedProducts');
        component.set('v.selectedProducts', []);
        saveEvent.setParams({
            'products': products
        });
        saveEvent.fire();
        var closeModalEvent = component.getEvent("closeAddProducts");
        closeModalEvent.fire();
    }
})