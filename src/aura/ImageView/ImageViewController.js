({
    doInit: function(component, event, helper) {
        component.set('v.fileLabel', $A.get("$Label.c.File").toLowerCase());
    },
    openImage: function(component, event, helper) {
        try{
            var image = component.find('modalImage');
            var file = component.get('v.file');
            //create image element
            image.set('v.class', 'slds-align--absolute-center');
            image.set('v.style', 'max-width:100%; max-height:100%; margin:auto; ');
            
            component.set('v.modalClass', 'slds-modal slds-modal--large slds-fade-in-open slds-size_2-of-3 slds-align_absolute-center');
            component.set('v.backDropClass', 'slds-backdrop slds-backdrop--open');
            
            component.set('v.header', file.name);
        } catch(e) {
            console.log(e);
        }
    },
    closeModal: function(component, event, helper) {
        try{
            component.set('v.modalClass', 'slds-modal');
            component.set('v.backDropClass', 'slds-backdrop');
        } catch(e) {
            console.log(e);
        }
    },
    downloadFile: function(component, event, helper) {
        try{
            location.href = component.get('v.file').url;
        } catch(e) {
            console.log(e);
        }
    }
})