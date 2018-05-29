({
    getFieldsMetadata: function(component, helper) {
        var fieldSetString = component.get('v.fieldSetString');
        if (fieldSetString) {
            var getFieldData = component.get('c.getFieldData');
            getFieldData.setParams({
                'objectName': 'FieloPRP__Invoice__c',
                'fieldNames': fieldSetString
            });
            getFieldData.setCallback(this, function(response) {
                var state = response.getState();
                var toastEvent = $A.get("e.force:showToast");
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var objectInfo = JSON.parse(response.getReturnValue());
                    var fields = objectInfo.fields;
                    var fieldMap = {};
                    fields.forEach(function(field){
                        fieldMap[field.attributes.name] = field;
                    });
                    component.set('v.fieldMap', fieldMap);
                    helper.setFields(component);
                }else {
                    var errorMsg = response.getError()[0].message;
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire(); 
                    if(spinner){
                        spinner.setParam('show', false);
                        spinner.fire();    
                    } 
                }
            });
            $A.enqueueAction(getFieldData);
        }
    },
    setFields: function(component) {
        try{
            var record = component.get('v.record');
            var fieldSetString = component.get('v.fieldSetString');
            var fieldSet = fieldSetString.split(',');
            var fieldMap = component.get('v.fieldMap');
            
            if (fieldSet) {
                if (fieldSet.length > 0) {
                    //Set Output
                    var outputFields = [];
                    var row;
                    fieldSet.forEach(function(fieldName) {
                        row = {};
                        row.fieldLabel = fieldMap[fieldName].attributes.label;
                        row.fieldName = fieldName;
                        if (record[fieldName]) {
                            row.fieldValue = record[fieldName];
                            row.untypedFieldValue = Object.prototype.valueOf.call(row.fieldValue);
                        } else {
                            row.fieldValue = null;
                            row.untypedFieldValue = null;
                        }
                        row.fieldMeta = fieldMap[fieldName];
                        outputFields.push(row);
                    });
                    component.set('v.outputFields', outputFields);
                }
            }
        } catch(e) {
            console.log(e);
        }
    },
    getFiles: function(component, helper) {
        try{
            var getFiles = component.get('c.getFiles');
            getFiles.setParams({
                'invoiceId': component.get('v.record').Id
            });
            getFiles.setCallback(this, function(response) {
                var state = response.getState();
                var toastEvent = $A.get("e.force:showToast");
                var spinner = $A.get("e.c:ToggleSpinnerEvent");
                
                if (component.isValid() && state === 'SUCCESS') {                    
                    var fileList = JSON.parse(response.getReturnValue());
                    console.log(JSON.stringify(fileList, null, 2));
                    component.set('v.fileList', fileList);
					var filePtr = component.get('v.filePtr');
                    if (fileList[filePtr]) {
                        if (fileList[filePtr].id) {
                            component.set('v.currentFile', fileList[filePtr]);
                        }
                    }
                }else {
                    var errorMsg = response.getError()[0].message;
                    toastEvent.setParams({
                        "title": errorMsg,
                        "message": " ",
                        "type": "error"
                    });
                    toastEvent.fire(); 
                    if(spinner){
                        spinner.setParam('show', false);
                        spinner.fire();    
                    } 
                }
            });
            $A.enqueueAction(getFiles);    
        } catch(e) {
            console.log(e);
        }
    }
})