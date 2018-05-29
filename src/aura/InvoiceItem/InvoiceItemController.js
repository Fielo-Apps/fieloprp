({
    doInit: function(component, event, helper) {
        console.log('InnvoiceItemController.doInit');
        try{            
            var registerFieldEvent = component.getEvent("invoiceItemRegister");
            registerFieldEvent.setParams({
                'name': 'InvoiceItem',
                'component':component
            });
            registerFieldEvent.fire();
        } catch(e) {
            console.log(e);
        }
    },
    registerField: function(component, event, helper) {
        try {
            event.stopPropagation();
            var params = event.getParams();
            var fieldMap = component.get('v.fieldMap');
            if (!fieldMap) {
                fieldMap = {};
            }
            fieldMap[params.component.get('v.fieldMeta').attributes.name] = params.component;
            component.set('v.fieldMap', fieldMap);
            helper.applyDefaults(component, helper, params.component.get('v.fieldMeta').attributes.name);
            var fields = [];
            Object.keys(fieldMap).forEach(function(fieldName) {
                fields.push(fieldMap[fieldName]);
            });
            component.set('v.fields', fields);   
        } catch(e) {
            console.log(e);
        }
    },
    removeItem: function(component, event, helper) {
        var itemId = event.getSource().get('v.name');
        var removeEvent = component.getEvent("removeInvoiceItem");
        removeEvent.setParams({
            'invoiceItemId': itemId
        });
        removeEvent.fire();
        var updateAmountEvent = component.getEvent("updateInvoiceAmount");
    },
    refreshTotalPrice: function(component, event, helper) {
        try{
            event.stopPropagation();
            console.log('refreshTotalPrice');
            var bindFields = ['FieloPRP__UnitPrice__c','FieloPRP__Quantity__c','FieloPRP__TotalPrice__c'];
            var params = event.getParams();
            var updatedFieldName = params.fieldName;
            var fieldMap = component.get('v.fieldMap');
            if (bindFields.indexOf(updatedFieldName) !== -1) {
                var fieldNames = Object.keys(fieldMap);
                var hasTotalPriceFields = fieldNames.indexOf('FieloPRP__UnitPrice__c') !== -1 &&
                    fieldNames.indexOf('FieloPRP__Quantity__c') !== -1 &&
                    fieldNames.indexOf('FieloPRP__TotalPrice__c') !== -1;
                if (hasTotalPriceFields) {
                    var totalPrice = Number(fieldMap.FieloPRP__TotalPrice__c.get('v.fieldValue'));
                    var unitPrice = Number(fieldMap.FieloPRP__UnitPrice__c.get('v.fieldValue'));
                    var quantity = Number(fieldMap.FieloPRP__Quantity__c.get('v.fieldValue'));
                    var updateAmountEvent = component.getEvent("updateInvoiceAmount");
                    if (updatedFieldName === 'FieloPRP__Quantity__c' || updatedFieldName === 'FieloPRP__UnitPrice__c') {
                        fieldMap.FieloPRP__TotalPrice__c.setFieldValue(Object.prototype.valueOf.call((parseFloat(quantity) * parseFloat(unitPrice)).toFixed(2)));
                    }
                    if (updatedFieldName === 'FieloPRP__TotalPrice__c') {
                        fieldMap.FieloPRP__UnitPrice__c.setFieldValue(Object.prototype.valueOf.call((parseFloat(quantity) > 0.0 ? parseFloat(totalPrice) / parseFloat(quantity) : 0).toFixed(2)));
                    }
                    
                    if (updatedFieldName === 'FieloPRP__Quantity__c' || updatedFieldName === 'FieloPRP__UnitPrice__c' || updatedFieldName === 'FieloPRP__TotalPrice__c') {
                        updateAmountEvent.fire();
                    }
                }    
            }
            var productField = component.get('v.productField');
            if (updatedFieldName == productField) {
                var record = component.get('v.item');
                if (record) {
                    if (fieldMap[productField].get('v.fieldValue')) {
                    	record[updatedFieldName] = String(fieldMap[productField].get('v.fieldValue'));
                    } else {
                        record[updatedFieldName] = null;
                    }
                }
                component.set('v.item', record);
            }
        } catch (e) {
            console.log(e);
        }
    },
    updateItem: function(component, event, helper) {
        try{
            console.log('updateItem');
        } catch(e) {
            console.log(e);
        }
    }
})