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
            
            var fields = component.get('v.fields');
            var action = component.get('c.getFieldData');
            action.setParams({
                'objectName': 'FieloPRP__Invoice__c',
                'fieldNames': fields
            });
            action.setCallback(this, function(response) {
                    try{
                        var spinner = $A.get("e.c:ToggleSpinnerEvent");
                        var toastEvent = $A.get("e.force:showToast");
                        var state = response.getState();
                        if (component.isValid() && state === 'SUCCESS') {                    
                            var objectInfo = JSON.parse(response.getReturnValue());
                            var fieldMap = {};
                            objectInfo.fields.forEach(function(fieldInfo) {
                                fieldMap[fieldInfo.attributes.name] = fieldInfo;
                            });
                            component.set('v.fieldMap', fieldMap);
                            helper.setFieldSet(component);
                            if (localStorage.getItem('InvoicesReady') == null){
                                localStorage.setItem('InvoicesReady', true);
                                $A.get("e.force:refreshView").fire();
                            }
                        }else {
                            var errorMsg = response.getError()[0].message;
                            toastEvent.setParams({
                                "title": "loadInvoices: " + errorMsg,
                                "message": " ",
                                "type": "error"
                            });
                            toastEvent.fire(); 
                        }
                        if(spinner){
                            spinner.setParam('show', false);
                            spinner.fire();    
                        }    
                    } catch(e) {
                        console.log(e);
                    }
                });    
            $A.enqueueAction(action);
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
        if(component.get('v.currentView') != 'myinvoices') {
            var action = component.get('c.showMyInvoices');
            $A.enqueueAction(action);
        }
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