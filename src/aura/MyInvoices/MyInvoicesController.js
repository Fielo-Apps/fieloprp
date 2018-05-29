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
            console.log(fieldsConfig);
            if(fieldsConfig.length == 0){
                fieldset = config.fieldset;                
            } else if (fieldsConfig.indexOf('[') == 0) {
                fieldset = JSON.parse(fieldsConfig);
            } else {
                var newField, nameAndType, apiName, type;
                var fieldsList = fieldsConfig.split(',');
                fieldsList.forEach(function(field){
                    nameAndType = field.split('/');
                    apiName = nameAndType[0].trim();
                    if (apiName == 'FieloPRP__InvoiceNumber__c') {
                        fieldset.push({
                            "apiName": "FieloPRP__InvoiceNumber__c",
                            "type": "subcomponent",
                            "subcomponent": "c:ShowRecord",
                            "label": {
                                "type": "default"
                            },
                            "showLabel": true
                        });
                    } else if (apiName == 'FieloPRP__Status__c') {
                        fieldset.push({
                            "apiName": "FieloPRP__Status__c",
                            "type": "subcomponent",
                            "subcomponent": "c:InvoiceStatus",
                            "label": {
                                "type": "default"
                            },
                            "showLabel": true
                        });
                    } else if (apiName == 'FieloPRP__InvoiceItems__r') {
                        fieldset.push({
                            "apiName": "FieloPRP__InvoiceItems__r",
                            "type": "subcomponent",
                            "subcomponent": "c:InvoiceItemsCount",
                            "label": {
                                "type": "custom",
                                "value": $A.get("$Label.c.ProductPlural")
                            },
                            "showLabel": true
                        });
                    } else {
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
                    }
                })
            }
            // console.log(JSON.stringify(fieldset, null, 2));
            component.set('v.fieldset', fieldset);
            // console.log('doInit done!')
        } catch(e) {
            component.set('v.error', e);
            component.set('v.showError', true);
        }            
    },
    updateMember: function(component, event, helper){
        var member = event.getParam('member');
        component.set('v.member', member);
        component.set('v.showFilter', true);
        helper.getProgram(component, event, helper);
        helper.loadInvoices(component, event, helper, 0);
    },
    showInvoiceRecord: function(component, event, helper){
        try{
            var spinner = $A.get("e.c:ToggleSpinnerEvent");
            if(spinner){
                spinner.setParam('show', true);
                spinner.fire();    
            }
            var invoiceRecord = event.getParam('record');
            component.set('v.invoiceRecord',invoiceRecord);
            helper.goToView(component, 'invoicerecord');
        } catch(e) {
            console.log(e);
        }
    },
    showInvoicesList: function(component, event, helper){
        component.set('v.showMyInvoices', true);
    },
    paginator: function(component, event, helper){
        var offset = event.getParam("offset");
        // console.log(offset);
        helper.loadInvoices(component, event, helper, offset);
    },
    onSelectChange : function(component, event, helper) {
        var selected = component.find("Status").get("v.value");
        component.set('v.status', selected);
    },
    filterMyInvoices: function(component, event, helper) {
        try{
            console.log('filterMyInvoices');
            var params = event.getParams();
            // console.log(JSON.stringify(params, null, 2));
            component.set('v.whereClause', params.whereClause);
            component.set('v.showMyInvoices', false);
            helper.loadInvoices(component, event, helper, 0);
        } catch(e) {
            console.log(e);
        }
    },
    showNewInvoiceForm: function(component, event, helper) {
        var spinner = $A.get("e.c:ToggleSpinnerEvent");
        if(spinner){
            spinner.setParam('show', true);
            spinner.fire();    
        }
        helper.goToView(component, 'invoiceupload');
    },
    showMyInvoices: function(component, event, helper) {
        helper.goToView(component, 'myinvoices');
        helper.loadInvoices(component, event, helper, 0);
    },
    hideContentHandler: function(component, event, helper) {
        var hide = event.getParam('hide');
        if (hide) {
            component.set('v.showContent', false);
        } else {
            component.set('v.showContent', true);
        }
    },
    cloneInvoice: function(component, event, helper) {
        console.log('cloneInvoice');
        event.stopPropagation();
        localStorage.clear();
        localStorage.setItem('cloneId', event.getParam('Id'));
        var action = component.get('c.showNewInvoiceForm');
        $A.enqueueAction(action);
    },
    /* FUTURE USE: REDIRECT BASED ON HASH (BETA) BEGINS*/
    redirect: function(component, event, helper) {
        var redirect = window.location.hash.replace('#','');
        if (redirect) {
            if (redirect!='myinvoices') {
                component.set('v.redirectTo', redirect);
                var goToViewAction = component.get('c.goToView');
                $A.enqueueAction(goToViewAction);
            }
        } else {
            window.location.hash = 'myinvoices';
        }
    },
    goToView: function(component, event, helper) {
        var redirectTo = component.get('v.redirectTo');
        if (redirectTo) {
            helper.goToView(component, redirectTo);
        }
        
    }
    /* FUTURE USE: REDIRECT BASED ON HASH (BETA) ENDS*/
})