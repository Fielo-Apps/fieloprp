({
    doInit: function(component, event, helper){
        var objectName = component.get('v.objectName');
        var fieldList = component.get('v.invoiceFields');
        var disableItems = component.get('v.disableItems');
        var action = component.get('c.getFieldData');
        
        if (fieldList.toLowerCase().indexOf('fieloprp__amount__c') == -1) {
            fieldList += ',FieloPRP__Amount__c';
        }
        
        action.setParams({
            'objectName': objectName,
            'fieldNames': fieldList
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            
            if (component.isValid() && state === 'SUCCESS') {                    
                var objectInfo = JSON.parse(response.getReturnValue());
                var amountField = objectInfo.fields.filter( function(field) {
                    return field.attributes.name == 'FieloPRP__Amount__c';
                });
                component.set('v.fieldset', objectInfo.fields);
                component.set('v.amountField', amountField[0]);
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
        
        var loadConfig = component.get('c.getInvoiceUploadConfiguration');
        
        loadConfig.setParams({'memberId':component.get('v.member').Id});
        
        loadConfig.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            
            if (component.isValid() && state === 'SUCCESS') {                    
                var invoiceConfig = response.getReturnValue();
                component.set('v.config', invoiceConfig);
                $A.enqueueAction(action);
            }else {
                var errorMsg = response.getError()[0].message;
                toastEvent.setParams({
                    "title": errorMsg,
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
        $A.enqueueAction(loadConfig);
        
        //Clone Feature
        if (localStorage) {
            var cloneId = localStorage.getItem('cloneId');
            if (cloneId) {
                if (cloneId.length==15 || cloneId.length==18) {
                    component.set('v.cloneId', cloneId);
                    localStorage.setItem('cloneId', '');
                }
            }    
        }
        
    },
    backToMyInvoices: function(component, event, helper) {
        var compEvent = component.getEvent("showMyInvoices");
        compEvent.fire();
    },
    handleFilesChange: function(component,event,helper) {
        console.log('handleFilesChange');
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.upload(component, file, content, function(answer) {
                    if (answer) {
                        console.log('Success');
                    }
                    else{
                        console.log('Failure');
                    }
                });
            }
            reader.readAsDataURL(file);
        }
        else{
            helper.hide(component,event);
        }
    },
    updateInvoiceField: function(component,event,helper) {
        try {
            var params = event.getParams();
            var invoce = component.get('v.invoice');
            if (!invoce) {
                invoce = {};
            }
            console.log(JSON.stringify(params, null, 2));
            if (params.fieldName) {
                if (params.jsType == 'string' || params.isQuoted) {
                    invoce[params.fieldName] = String(params.fieldValue);
                } else if (params.jsType == 'number') {
                    invoce[params.fieldName] = Number(params.fieldValue);
                } else if (params.jsType == 'boolean') {
                    invoce[params.fieldName] = Boolean(params.fieldValue);
                } else {
                    invoce[params.fieldName] = params.fieldValue;
                }
            }
            component.set('v.invoice', invoce);   
        } catch(e) {
            console.log(e);
        }
    },
    removeInvoiceFile: function(component,event,helper) {
        var params = event.getParams();
        var fileId = params.fileId;
        if (fileId) {
            var filesList = component.get('v.filesList');
            var newFilesList = filesList.filter(function(file) {
                return ('file-' + file.id) !== fileId;
            });
            component.set('v.filesList', newFilesList);
        }
    },
    showAddProducts: function(component,event,helper) {
        component.set('v.showAddProducts', true);
        component.set('v.modalClass', 'slds-modal slds-fade-in-open');
        component.set('v.backDropClass', 'slds-backdrop slds-backdrop--open');
    },
    hideAddProducts: function(component,event,helper) {
        component.set('v.modalClass', 'slds-modal');
        component.set('v.backDropClass', 'slds-backdrop');
        component.set('v.showAddProducts', false);
    },
    saveProducts: function(component,event,helper) {
        try{
            console.log('saveProducts');
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', false);
                spinner.fire();
            }
            spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();
            }
            var products = event.getParam('products');
            component.set('v.selectedProducts', products);
            var action = component.get('c.addProducts');
            $A.enqueueAction(action);
        } catch(e) {
            console.log(e);
        }
    },
    addProducts: function(component,event,helper) {
        console.log('addProducts');
        var products = component.get('v.selectedProducts');
        var invoiceItemsComponent = component.get('v.invoiceItemsCmp');
        if (invoiceItemsComponent) {
            invoiceItemsComponent.addProducts(products);
        }
    },
    registerComponent: function(component,event,helper) {
        var componentName = event.getParam('name');
        if (componentName === 'InvoiceItems') {
            component.set('v.invoiceItemsCmp', event.getParam('component'));
        }
        if (componentName === 'InputField') {
            var fieldList = component.get('v.invoiceFields').split(',');
            var invoiceFieldsCompsMap = component.get('v.invoiceFieldsCompsMap');
            if (!invoiceFieldsCompsMap) {
                invoiceFieldsCompsMap = {};
            }
            var newField = event.getParam('component');
            invoiceFieldsCompsMap[newField.get('v.fieldMeta').attributes.name] = newField;
            component.set('v.invoiceFieldsCompsMap', invoiceFieldsCompsMap);
            
            if (fieldList[fieldList.length-1] == newField.get('v.fieldMeta').attributes.name) {
                // Used to trigger retrieveRecord (when cloning a invoice record)
                // see doneWaiting function
                component.set('v.lastFieldRegistered', true);
            }
        }
    },
    submitInvoice: function(component,event,helper) {
        try{
            console.log('submitInvoice');
            var toastEvent = $A.get("e.force:showToast");
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();
            }
            helper.getInvoice(component);
            var member = component.get('v.member');
            var invoice = component.get('v.invoice');
            var invoiceItemsComponent = component.get('v.invoiceItemsCmp');
            var requestFileUpload = component.get('v.requestFileUpload');
            if (!invoice) {
                invoice = {};
            }
            invoice.sobjectType = 'FieloPRP__Invoice__c';
            invoice.FieloPRP__Member__c = member.Id;
            var invoiceItems = null;
            if (invoiceItemsComponent) {
                invoiceItems = invoiceItemsComponent.getItems();    
            }
            var filesList = component.get('v.filesList');
            var referenceFiles = filesList.filter(function(file){
                return file.base64Data == null || file.base64Data == '' || file.base64Data == undefined;
            });
            var fileIds = [];
            if (referenceFiles) {
                referenceFiles.forEach(function(file) {
                    fileIds.push(file.id);
                });
            }
            var newFiles = filesList.filter(function(file){
                return file.base64Data != null && file.base64Data != '' && file.base64Data != undefined;
            });
            component.set('v.newFiles', newFiles);
            var hasFiles = true;
            if (!newFiles && requestFileUpload) {
                hasFiles = false;
            } else if (newFiles.length == 0 && fileIds.length == 0 && requestFileUpload) {
                hasFiles = false;
            } else {
                console.log(JSON.stringify(invoice, null, 2));
                console.log(invoiceItems);
                var action = component.get('c.save');
                action.setParams({
                    'invoice': invoice,
                    'items': invoiceItems != null ? invoiceItems : null,
                    'fileIds': fileIds.length > 0 ? fileIds : null,
                    'submitMode': component.get('v.submitMode')
                });
                action.setCallback(this, function(response) {
                    try{
                        var state = response.getState();
                        var toastEvent = $A.get("e.force:showToast");
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        var errorMsg = '';
                        var isSuccess = false;
                        
                        if (component.isValid() && state === 'SUCCESS') {                    
                            var invoiceId = response.getReturnValue();
                            component.set('v.invoiceId', invoiceId);
                            console.log('Invoice Submited: ' + invoiceId);
                            var hasFiles = false;
                            if (newFiles != null && newFiles != undefined) {
                                if (newFiles.length != 0) {
                                    hasFiles = true;
                                    console.log('Uploading Files');
                                    var uploadFiles = component.get('c.uploadFile');
                                    $A.enqueueAction(uploadFiles);
                                } else {
                                    isSuccess = true;
                                }
                            } else {
                                isSuccess = true;
                            }
                            if (isSuccess && invoiceId != null && !hasFiles) {
                                toastEvent.setParams({
                                    "title": $A.get('$Label.c.InvoiceUploaded'),
                                    "message": " ",
                                    "type": "success"
                                });
                                helper.hideContent(component);
                                toastEvent.fire();
                                $A.get("e.force:refreshView").fire();
                            }
                        } else {
                            errorMsg = response.getError()[0].message;
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
                $A.enqueueAction(action);
            }
            
            if (!hasFiles && fileIds.length == 0) {
                toastEvent.setParams({
                    "title": $A.get('$Label.c.NoFileAttached'),
                    "message": " ",
                    "type": "error"
                });
                toastEvent.fire();
                
                spinner = $A.get("e.c:ToggleSpinnerEvent");
                if(spinner){
                    spinner.setParam('show', false);
                    spinner.fire();
                }
            }
        } catch(e) {
            console.log(e);
        }
    },
    uploadFile: function(component,event,helper) {
        helper.fileIndex = 0;
        helper.uploadFile(component);
    },
    doneWaiting: function(component,event,helper) {
        if (component.get('v.lastFieldRegistered') && !component.get('v.isDoneWaiting')) {
            console.log('doneWaiting');
            component.set('v.isDoneWaiting', true);
            if (localStorage) {
                var cloneId = component.get('v.cloneId');
                if (cloneId) {
                    if (cloneId.length==15 || cloneId.length==18) {
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        if(spinner){
                            spinner.setParam('show', true);
                            spinner.fire();    
                        }
                        var action = component.get('c.retrieveRecord');
                        $A.enqueueAction(action);
                    }
                }
            }
            
        }
    },
    retrieveRecord: function(component, event, helper) {
        try{
            var cloneId = component.get('v.cloneId');
            var fields = component.get('v.invoiceFields');
            var itemFields = component.get('v.invoiceItemFields');
            if (cloneId) {
                var retrieveAction = component.get('c.getRecord');
                retrieveAction.setParams({
                    'invoiceId': cloneId,
                    'fields': fields,
                    'itemFields': itemFields
                });
                retrieveAction.setCallback(this, function(response) {
                    try{
                        var state = response.getState();
                        var toastEvent = $A.get("e.force:showToast");
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        
                        if (component.isValid() && state === 'SUCCESS') {                    
                            var record = response.getReturnValue();
                            console.log(JSON.stringify(record, null, 2));
                            
                            var spinner = $A.get("e.c:ToggleSpinnerEvent");
                            if(spinner){
                                spinner.setParam('show', true);
                                spinner.fire();    
                            }
                            helper.setFields(component, record);
                            helper.setFiles(component, record);
                            helper.setItems(component, record);
                        }else {
                            var errorMsg = response.getError()[0].message;
                            toastEvent.setParams({
                                "title": errorMsg,
                                "message": " ",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        if(spinner){
                            spinner.setParam('show', false);
                            spinner.fire();    
                        }
                    } catch(e) {
                        console.log(e);
                    }
                });
                $A.enqueueAction(retrieveAction);
            }
        } catch(e) {
            console.log(e);
        }
    }
})