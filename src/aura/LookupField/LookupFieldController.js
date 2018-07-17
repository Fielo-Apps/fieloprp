({
    doInit: function(component, event, helper) {
        try{
            var lookupObjectName = component.get('v.field').attributes.referenceTo;
            var objectName = component.get('v.field').attributes.objectName;
            var fieldName = component.get('v.field').attributes.name;
            var fieldKey = objectName + '.' + fieldName;
            var hasChache = false;
            if(localStorage) {
                var records = helper.getCachedOptions(component);
                if (records) {
                    component.set('v.options', records);
                    hasChache = true;                    
                }
            }
            
            var registerFieldEvent = component.getEvent("lookupRegister");
            registerFieldEvent.setParams({
                'name': 'LookupField',
                'component': component
            });
            registerFieldEvent.fire();
            
            if (!hasChache) {
                var getRecords = component.get('c.getRecords');
                getRecords.setParams({
                    'objectName': lookupObjectName,
                    'whereClause': ''
                });
                getRecords.setCallback(this, function(response) {
                    try{
                        var state = response.getState();
                        if (component.isValid() && state === 'SUCCESS') {                    
                            var records = response.getReturnValue();
                            component.set('v.options', records);
                            localStorage.setItem(fieldKey, JSON.stringify(records));
                        }else {
                            var errorMsg = response.getError()[0].message;
                            var spinner = $A.get("e.c:ToggleSpinnerEvent");
                            var toastEvent = $A.get("e.force:showToast");
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
                    } catch(e) {
                        console.log(e);
                    }
                });
                $A.enqueueAction(getRecords);
            }
        } catch(e) {
            console.log(e);
        }
    },
    showOptions: function(component, event, helper) {
        try{
            helper.show(component);
        } catch(e) {
            console.log(e);
        }
    },
    hideOptions: function(component, event, helper) {
        try{
            helper.hide(component);
        } catch(e) {
            console.log(e);
        }
    },
    optionSelected: function(component, event, helper) {
        console.log('optionSelected');
        try{
        	event.stopPropagation();
            var record = event.getParam('record');
            helper.selectOption(component, record);
        } catch(e) {
            console.log(e);
        }
    },
    removeRecord: function(component, event, helper) {
        try{
            var input = component.find('fielo-lookup-input');
            var formElement = component.find('fielo-lookup-combobox-form-element');
            component.set('v.selectedRecord', null);
            var handleChangeMethod = component.get('c.handleChange');
            $A.enqueueAction(handleChangeMethod);
        } catch(e) {
            console.log(e);
        }
    },
    pickRecord: function(component, event, helper) {
        try{
            var params = event.getParam('arguments');
            var objectName = component.get('v.field').attributes.referenceTo;
            var recordId = params.recordId;
            
            var getRecords = component.get('c.getRecords');
            getRecords.setParams({
                'objectName': objectName,
                'whereClause': 'Id = \'' + recordId + '\''
            });
            
            getRecords.setCallback(this, function(response) {
                try{
                    var state = response.getState();
                    if (component.isValid() && state === 'SUCCESS') {                    
                        var records = response.getReturnValue();
                        if (records.length == 1) {
                            helper.selectOption(component, records[0]);
                        }
                    }else {
                        var errorMsg = response.getError()[0].message;
                        var toastEvent = $A.get("e.force:showToast");
                        console.log(errorMsg);
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
                } catch(e) {
                    console.log(e);
                }
            });
            
            $A.enqueueAction(getRecords);
        } catch(e) {
            console.log(e);
        }
    },
    setRecord: function(component, event, helper) {
        try{
            var params = event.getParam('arguments');
            var record = params.record;
            if (record) {
                helper.selectOption(component, record);    
            }
        } catch(e) {
            console.log(e);
        }
    },
    handleChange: function(component, event, helper) {
        try{
            console.log('handleChange');
            var compEvent = component.getEvent("fieldUpdate");
            var fieldMeta = component.get('v.field');
            var record = component.get('v.selectedRecord');
            if (!record) {
                record = {};
            }
            var params = {};
            params.fieldName = fieldMeta.attributes.name;
            params.fieldValue = record.Id != null ? Object.prototype.valueOf.call(record.Id) : null;
            params.isQuoted = fieldMeta.attributes.isQuoted == 'true';
            params.jsType = fieldMeta.attributes.jsType;
            
            if (record.Id === null || record.Id === undefined || record.Id == '') {
                params.isNull == true;
            }
            
            params['stringValue'] = record.Id != null ? record.Id : null;
            
            compEvent.setParams(params);
            component.set('v.fieldValue', params.fieldValue);
            compEvent.fire();
                        
            helper.hide(component);            
        } catch(e) {
            console.log(e);
        }
    },
    handleKeyPress: function(component, event, helper) {
        try{
            if (event.key == 'Enter') {
                console.log('showModal');
                var input = helper.getInput(component);
                component.set('v.searchValue', input.value);
                var action = component.get('c.openSearchModal');
                $A.enqueueAction(action);
            }
        } catch(e) {
            console.log(e);
        }
    },
    filterRecords: function(component, event, helper) {
        try{
            var searchValue = event.target.value;
            component.set('v.searchValue', searchValue);
            helper.filterOptions(component);
            helper.hide(component);
            helper.show(component);
        } catch(e) {
            console.log(e);
        }
    },
    openSearchModal: function(component, event, helper) {
        try{
            var lookupModal = component.find('lookupSearch');
            var searchValue = component.get('v.searchValue');
            component.set('v.searchValue',null);
            helper.refreshOptions(component);
            if (searchValue) {
                lookupModal.set('v.searchValue', searchValue);
                if (lookupModal.find('lookup-filter')) {
                    if (lookupModal.find('lookup-filter').find('invoice-filter-input')) {
                        lookupModal.find('lookup-filter').find('invoice-filter-input').setFieldValue(Object.prototype.valueOf.call(searchValue));
                    }
                }    
            }
            lookupModal.show();
        } catch(e) {
            console.log(e);
        }
    }
})