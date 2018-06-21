({
    colorsMap: {
        'Open': 'fielo-invoice-status--pending',
        'Pending for Approval': 'fielo-invoice-status--pending',
        'Approved': 'fielo-invoice-status--approved',
        'Rejected': 'fielo-invoice-status--rejected',
        'Canceled': 'fielo-invoice-status--rejected',
        'New': 'fielo-invoice-status--pending'
    },
    iconMap: {
        'Open': 'utility:info',
        'Pending for Approval': 'utility:info',
        'Approved': 'utility:success',
        'Rejected': 'utility:warning',
        'Canceled': 'utility:warning',
        'New': 'utility:info'
    },
    variantMap: {
        'Open': 'base',
        'Pending for Approval': 'base',
        'Approved': 'inverse',
        'Rejected': 'inverse',
        'Canceled': 'inverse',
        'New': 'base'
    },
    format: function() {
        var num = arguments.length; 
        var oStr = arguments[0];   
        for (var i = 1; i < num; i++) { 
            var pattern = "\\{" + (i-1) + "\\}"; 
            var re = new RegExp(pattern, "g"); 
            oStr = oStr.replace(re, arguments[i]); 
        } 
        return oStr;
    }
})