({
    handleRemove : function(component, event, helper) {
        var element = event.getSource();
        helper.removeFile(component, element.get('v.name'));
    }
})