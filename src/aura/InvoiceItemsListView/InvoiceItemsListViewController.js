({
    doInit : function(component, event, helper) {
        try{
            var fieldset = [];
            var invoiceItemFields = component.get('v.invoiceItemFields');
            if (invoiceItemFields) {
                var fieldNames = invoiceItemFields.split(',');
                if (fieldNames && fieldNames.length > 0) {
                    var nameAndType, type, apiName;
                    fieldNames.forEach(function(fieldName) {
                        nameAndType = fieldName.split('/');
                        apiName = nameAndType[0].trim();
                        type = nameAndType[1] ? nameAndType[1].trim().toLowerCase() : 'output';
                        fieldset.push({
                            'apiName': apiName,
                            'type': type,
                            'label': {
                                "type": "default"
                            },
                            'showLabel': true
                        });
                    });
                    component.set('v.fieldset', fieldset);
                    
                    helper.loadItems(component, event, helper, 0);
                }
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