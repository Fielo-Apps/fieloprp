({
    fileCounter: 0,
    fileIndex: 0,
    upload: function(component, file, base64Data, callback) {
        try{
            var toastEvent = $A.get("e.force:showToast");
            var config = component.get('v.config');
            var supportedFiles = ['image/png','image/jpg','image/jpeg','image/png','image/gif','application/pdf'];
            var filesList = component.get("v.filesList");
            var fileSize = base64Data.length*3/4;
            if (!filesList) {
                filesList = [];
            }
            if (supportedFiles.indexOf(file.type) == -1) {
                toastEvent.setParams({
                    "title": $A.get('$Label.c.InvalidFileType'),
                    "message": " ",
                    "type": "error"
                });
                toastEvent.fire();
            } else if(fileSize > config.maxFileSize) {
                toastEvent.setParams({
                    "title": $A.get('$Label.c.InvalidFileSize'),
                    "message": " ",
                    "type": "error"
                });
                toastEvent.fire();
            } else {
                filesList.push({
                    fileName: file.name,
                    base64Data: base64Data,
                    contentType: file.type,
                    id: this.fileCounter
                });
            }
            
            this.fileCounter = this.fileCounter+1;
            component.set("v.filesList", filesList);
            component.set("v.showFileList", true);
            component.find('invoice-file-input').set('v.value', null);
        } catch(e) {
            console.log(e);
        }
    },
    uploadFile: function(component) {
        console.log('helper.uploadFile');
        try {
            var invoiceId = component.get('v.invoiceId');
            var newFiles = component.get('v.newFiles');
            
            if (newFiles) {
                if (newFiles.length > 0) {
                    var file = newFiles[this.fileIndex];
                    if (file) {
                        this.fileIndex++;
                        var fileContents = file.base64Data;
                        this.saveFile(component, invoiceId, file, fileContents);
                    } else {
                        console.log('no files... =(');
                    }
                }
            }
        } catch(e) {
            console.log(e);
        }
    },
    saveFile: function(component, parentId, file, fileContents) {
        var config = component.get('v.config');
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + Number(config.maxChunkSize));
        
        // start with the initial chunk
        this.saveChunk(component, parentId, file, fileContents, fromPos, toPos, '');
    },
    saveChunk: function(component, parentId, file, fileContents, fromPos, toPos, fileId) {
        console.log('saveChunk');
        var config = component.get('v.config');
        var chunk = fileContents.substring(fromPos, toPos);
        var action = component.get('c.saveTheChunk');
        action.setParams({
            'parentId': parentId,
            'fileName': file.fileName,
            'base64Data': encodeURIComponent(chunk),
            'contentType': file.contentType,
            'fileId': fileId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            var newFiles = component.get('v.newFiles');
            
            if (component.isValid() && state === 'SUCCESS') {
                // Handle Response
                var fileId = response.getReturnValue();
                fromPos = toPos;
                toPos = Math.min(fileContents.length, fromPos + Number(config.maxChunkSize));
                
                if (fromPos < toPos) {
                    this.saveChunk(component, parentId, file, fileContents, fromPos, toPos, fileId);
                } else if (newFiles) {
                    if (this.fileIndex < newFiles.length) {
                        this.uploadFile(component);
                    } else {
                        toastEvent.setParams({
                            "title": $A.get('$Label.c.InvoiceUploaded'),
                            "message": " ",
                            "type": "success"
                        });
                        this.hideContent(component);
                        toastEvent.fire();
                        $A.get("e.force:refreshView").fire();
                    }
                } else {
                    toastEvent.setParams({
                        "title": $A.get('$Label.c.InvoiceUploaded'),
                        "message": " ",
                        "type": "success"
                    });
                    this.hideContent(component);
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                }
            } else {
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
        $A.enqueueAction(action);
    },
    hideContent: function(component) {
        var hideEvent = component.getEvent("hideContent");
        hideEvent.setParams({'hide':true});
        hideEvent.fire();
    },
    setFields: function(component, record){
        try{
            if (record) {
                var invoice = component.get('v.invoice');
                var fieldMap = component.get('v.invoiceFieldsCompsMap');
                if (fieldMap) {
                    [].forEach.call(Object.keys(record), function(fieldName) {
                        if (Object.keys(fieldMap).indexOf(fieldName) != -1) {
                            fieldMap[fieldName].setFieldValue(Object.prototype.valueOf.call(record[fieldName]));
                        }
                    });    
                }
            }
        } catch(e) {
            console.log(e);
        }
    },
    setFiles: function(component, record){
        try{
            if (record) {
                if (record.Attachments) {
                    if (record.Attachments.length > 0) {
                        var filesList = component.get("v.filesList");
                        if (!filesList) {
                            filesList = [];
                        }
                        record.Attachments.forEach(function(file) {
                            filesList.push({
                                fileName: file.Name,
                                base64Data: null,
                                contentType: file.ContentType,
                                id: file.Id
                            });
                        });
                        component.set("v.filesList", filesList);
                        component.set("v.showFileList", filesList.length > 0);
                    }
                }
                if (record.ContentDocumentLinks) {
                    if (record.ContentDocumentLinks.length > 0) {
                        var filesList = component.get("v.filesList");
                        if (!filesList) {
                            filesList = [];
                        }
                        record.ContentDocumentLinks.forEach(function(file) {
                            filesList.push({
                                fileName: file.ContentDocument.Title,
                                base64Data: null,
                                contentType: file.ContentDocument.FileType,
                                id: file.ContentDocument.Id
                            });
                        });
                        component.set("v.filesList", filesList);
                        component.set("v.showFileList", filesList.length > 0);
                    }
                }
            }
        } catch(e) {
            console.log(e);
        }
    },
    setItems: function(component, record){
        try{
            if (record) {
                if (record.FieloPRP__InvoiceItems__r) {
                    if (record.FieloPRP__InvoiceItems__r.length > 0) {
                        component.get('v.invoiceItemsCmp').setItems(record.FieloPRP__InvoiceItems__r);
                    }
                }
            }
        } catch(e) {
            console.log(e);
        }
    },
    getInvoice: function(component){
        console.log('getInvoice');
        try{
            var invoiceFieldsCompsMap = component.get('v.invoiceFieldsCompsMap');
            var invoice = {};
            var fieldInfo;
            var typedFieldValue;
            [].forEach.call(Object.keys(invoiceFieldsCompsMap), function(fieldName) {
                fieldInfo = invoiceFieldsCompsMap[fieldName].get("v.fieldMeta").attributes;
                if (fieldInfo.jsType == 'string' || fieldInfo.isQuoted) {
                    if (String(invoiceFieldsCompsMap[fieldName].get('v.fieldValue')) == 'null') {
                        invoice[fieldName] = null;
                    } else {
                        invoice[fieldName] = String(invoiceFieldsCompsMap[fieldName].get('v.fieldValue'));    
                    }
                } else if (fieldInfo.jsType == 'number') {
                    invoice[fieldName] = Number(invoiceFieldsCompsMap[fieldName].get('v.fieldValue'));
                } else if (fieldInfo.jsType == 'boolean') {
                    invoice[fieldName] = Boolean(invoiceFieldsCompsMap[fieldName].get('v.fieldValue'));
                } else {
                    invoice[fieldName] = invoiceFieldsCompsMap[fieldName].get('v.fieldValue');
                }
            });
            component.set('v.invoice', invoice);
        } catch(e) {
            console.log(e);
        }
    }
})