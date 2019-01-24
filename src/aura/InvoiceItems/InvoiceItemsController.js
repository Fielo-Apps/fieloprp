({
    doInit: function(component, event, helper){
        var objectName = component.get('v.objectName');
        var fieldList = component.get('v.invoiceItemFields');
        var action = component.get('c.getFieldData');
        action.setParams({
            'objectName': objectName,
            'fieldNames': fieldList
        });
        
        action.setCallback(this, function(response) {
            try{
                var state = response.getState();
                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var objectInfo = JSON.parse(response.getReturnValue());
                    component.set('v.fieldset', objectInfo.fields);
                    helper.addItem(component, helper);
                    helper.commitItems(component);
                    var registerEvent = component.getEvent("registerInvoiceItems");
                    registerEvent.setParams({
                        'name': 'InvoiceItems',
                        'component':component
                    });
                    registerEvent.fire();
                }else {
                    var errorMsg = response.getError()[0].message;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire(); 
                }
            } catch(e) {
                console.log(e);
            }
        });
        
        $A.enqueueAction(action);
    },
    invoiceItemRegister: function(component, event, helper){
        event.stopPropagation();
        var params = event.getParams();
        console.log('item ' + params.component.get('v.item').Id + ' registered.');
        helper.invoiceItems[params.component.get('v.item').Id] = params.component;
    },
    addItem: function(component, event, helper) {
        try{
            helper.addItem(component, helper);
            helper.commitItems(component);
        } catch(e) {
            console.log(e);
        }
    },
    removeItem: function(component, event, helper) {
        console.log('removeItem');
        var params = event.getParams();
        if (params) {
            if (params.invoiceItemId) {
                var itemId = params.invoiceItemId;
                var items = component.get('v.items');
                var newItems = items.filter(function(item) {
                    return item.Id !== itemId;
                });
                delete helper.invoiceItems[itemId];
                component.set('v.items', newItems);        
            }
            helper.refreshAmount(component, event, helper);
        }
    },
    updateInvoiceAmount: function(component, event, helper) {
        if (!component.get('v.disableAmountUpdate')) {
            console.log('updateInvoiceAmount');
            helper.refreshAmount(component, event, helper);
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', false);
                spinner.fire();    
            }
        }
    },
    addProducts: function(component, event, helper) {
        try{
            component.set('v.disableAmountUpdate', true);
            var params = event.getParam('arguments');
            var products = params.products;
            var emptyItems = helper.getEmptyItems(component);
            var productField = component.get('v.productField');
            var count = products.length - emptyItems.length;
            for(var i=0;i<count;i++) {
                helper.addItem(component, helper);
            }
            helper.commitItems(component);
            emptyItems = helper.getEmptyItems(component);
            var items = component.get('v.items');
            var itemMap = {};
            items.forEach(function(item){
                itemMap[item.Id] = item;
            });
            var selectedItem;
            var productMap = {};
            for(var i=0; i<products.length; i++) {
                itemMap[emptyItems[i].Id][productField] = products[i].Id;
                productMap[products[i].Id] = products[i];
            }
            var updatedItems = [];
            for(var item in itemMap) {
                updatedItems.push(itemMap[item]);
            }
            component.set('v.updatedItems', updatedItems);
            
            var updateItems = component.get('c.updateItems');
            $A.enqueueAction(updateItems);
        } catch(e) {
            console.log(e);
        }
    },
    setItems: function(component, event, helper) {
        component.set('v.disableAmountUpdate', true);
        var params = event.getParam('arguments');
        var items = params.items;
        helper.setItems(component, helper, items);
    },
    updateItems: function(component, event, helper) {
        try{
            var updatedItems = component.get("v.updatedItems");
            
            if (updatedItems) {
                if (updatedItems.length > 0) {
                    updatedItems.forEach(function(item) {
                        console.log(JSON.stringify(helper.invoiceItems, null, 2));
                        if(helper.invoiceItems[item.Id]) {
                            [].forEach.call(Object.keys(item), function(fieldName) {
                                if (item[fieldName]) {
                                    if (helper.invoiceItems[item.Id].get('v.fieldMap')[fieldName]) {
                                        helper.invoiceItems[item.Id].get('v.fieldMap')[fieldName].setFieldValue(Object.prototype.valueOf.call(item[fieldName]));
                                    } else {
                                        console.log(fieldName + ' not found on component');
                                    }
                                } else {
                                    console.log(fieldName + ' not found on record');
                                }
                            });
                        } else {
                            console.log(item.Id + ' not found on helper');
                        }
                    });
                }
            }
            component.set('v.disableAmountUpdate', false);
            var action = component.get('c.updateInvoiceAmount');
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }
    },
    getItems: function(component, event, helper) {
        try {
            console.log('getItems');
            var items = component.get('v.items');
            var fieldSet = component.get('v.fieldset');
            var itemRecord;
            var fieldComp;
            var fieldMeta;
            var itemsToReturn = [];
            console.log(JSON.stringify(helper.invoiceItems, null, 2));
            items.forEach(function (item) {
                itemRecord = {};
                itemRecord.sobjectType = 'FieloPRP__InvoiceItem__c';
                [].forEach.call(Object.keys(item), function(field) {
                    if (field != 'Id') {
                        console.log(JSON.stringify(helper.invoiceItems[item.Id].get('v.fieldMap'), null, 2));
                        fieldComp = helper.invoiceItems[item.Id].get('v.fieldMap')[field];
                        if (fieldComp) {
                            fieldMeta = fieldComp.get('v.fieldMeta');
                            if (fieldMeta.attributes.jsType == 'string' || !(fieldMeta.attributes.isQuoted === "false")) {
                                if ( fieldMeta.attributes.inputType == 'reference' && (fieldComp.get('v.fieldValue') == null || fieldComp.get('v.fieldValue') == undefined || fieldComp.get('v.fieldValue') == '')) {
                                    delete itemRecord[field];
                                } else {
                                    itemRecord[field] = String(fieldComp.get('v.fieldValue'));
                                }
                            } else if (fieldMeta.attributes.jsType == 'number') {
                                itemRecord[field] = Number(fieldComp.get('v.fieldValue'));
                            } else if (fieldMeta.attributes.jsType == 'boolean') {
                                itemRecord[field] = Boolean(fieldComp.get('v.fieldValue'));
                            } else {
                                itemRecord[field] = fieldComp.get('v.fieldValue');
                            }   
                        }    
                    }
                });
                itemsToReturn.push(itemRecord);
            });
            return itemsToReturn;
        } catch(e) {
            console.log(e);
        }
    },
    printItems: function(component, event, helper) {
        var items = component.get('v.items');
        console.log(JSON.stringify(items, null, 2));
    }
})