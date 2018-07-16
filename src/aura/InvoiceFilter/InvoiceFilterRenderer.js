({
    afterRender: function (component, helper) {
        this.superAfterRender();
        
        $('#datePicker').datepicker({
        });
    }
})