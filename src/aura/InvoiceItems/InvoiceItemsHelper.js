({
    invoiceItems: {
        
    },
    refreshAmount: function(component, event, helper) {
        try{
            console.log('refreshAmount');
            var invoiceItemIds = Object.keys(helper.invoiceItems);
            var amount = 0.0;
            invoiceItemIds.forEach(function(invoiceItemId) {
                console.log('Item: ' + invoiceItemId);
                if (helper.invoiceItems[invoiceItemId]) {
                    var fields = helper.invoiceItems[invoiceItemId].get('v.fields');
                    if (fields) {
                        var totalPriceField = fields.filter(function(field) {
                            return field.get('v.fieldMeta').attributes.name === 'FieloPRP__TotalPrice__c';
                        });
                        if (totalPriceField.length==1) {
                            amount += Number(totalPriceField[0].get('v.fieldValue'));
                            console.log('    ' + Number(totalPriceField[0].get('v.fieldValue')));
                        }
                    }
                }
            });
            component.set('v.totalAmount', amount);   
        } catch (e) {
            console.log(e);
        }
    },
    itemCount: 0,
    getEmptyItems: function(component) {
        console.log('getEmptyItems');
        var items = component.get('v.items');
        var productField = component.get('v.productField');
        var emptyItems = [];
        if (items) {
            if (items.length >0) {
                Array.prototype.push.apply(emptyItems,
                    items.filter(function(item) {
                        return item[productField] == null || item[productField] == '' || item[productField] == undefined;
                    })
                );
            }
        }
        return emptyItems;
    },
    addItem: function(component, helper) {
        try{
            var newItems = component.get('v.newItems');
            var fieldSet = component.get('v.fieldset');
            if (!newItems) {
                newItems = [];
            }
            var itemRecord = {};
            [].forEach.call(fieldSet, function (field) {
                itemRecord[field.attributes.name] = null;
            });
            itemRecord.Id = helper.itemCount;
            helper.itemCount = helper.itemCount+1;
            newItems.push(itemRecord);
            component.set('v.newItems', newItems);
        } catch(e) {
            console.log(e);
        }
    },
    commitItems: function(component) {
        try{
            var items = component.get('v.items');
            if (!items) {
                items = [];
            }
            Array.prototype.push.apply(items, component.get('v.newItems'));
            component.set('v.items', items);
            component.set('v.newItems', null);
        } catch(e) {
            console.log(e);
        }
    },
    setItems: function(component, helper, items) {
        try{
            if (items) {
                if (items.length>0) {
                    var emptyItems = helper.getEmptyItems(component);
                    var count = items.length - emptyItems.length;
                    for(var i=0;i<count;i++) {
                        helper.addItem(component, helper);
                    }
                    helper.commitItems(component);
                    var existingItems = component.get('v.items');
                    console.log('items: ' + items.length + ', emptyItems: ' + emptyItems.length + ', existingItems: ' + existingItems.length);
                    for(var i=0;i<items.length;i++) {
                        console.log('processing record :' + items[i].Id);
                        [].forEach.call(Object.keys(items[i]), function(fieldName) {
                            existingItems[i][fieldName] = items[i][fieldName];
                        });
                    }
                    helper.invoiceItems = {};
                    component.set('v.items', []);
                    component.set('v.items', existingItems);
                    console.log(JSON.stringify(component.get('v.items'), null, 2));
                    var updatedItems = existingItems;
                    component.set('v.updatedItems', updatedItems);                    
                    var updateItems = component.get('c.updateItems');
                    $A.enqueueAction(updateItems);
                }
            }
        } catch(e) {
            console.log(e);
        }
    }
})