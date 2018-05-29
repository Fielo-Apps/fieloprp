({
    applyDefaults: function(component, helper, fieldName) {
        try{
            var defaultFields = ['FieloPRP__Quantity__c','FieloPRP__UnitPrice__c','FieloPRP__TotalPrice__c'];
            var fieldMap = component.get('v.fieldMap');
            if (defaultFields.indexOf(fieldName) !== -1) {
                if (Object.keys(fieldMap).indexOf(fieldName) !== -1) {
                    fieldMap[fieldName].setFieldValue(Object.prototype.valueOf.call(0));
                }
            }   
        } catch(e) {
            console.log(e);
        }
    }
})