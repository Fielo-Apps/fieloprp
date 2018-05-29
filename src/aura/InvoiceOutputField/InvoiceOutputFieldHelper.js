({
	fieldMap: {
        'text': 'stringValue',
        'reference': 'reference',
        'checkbox': 'booleanValue',
        'number': 'decimalValue',
        'date': 'stringValue',
        'datetime': 'stringValue',
        'email': 'stringValue',
        'picklist': 'stringValue',
        'time': 'decimalValue',
        'url': 'stringValue'
    },
    setFieldValue: function(component) {
        var fieldMeta = component.get('v.fieldMeta');
        var fieldValue = component.get('v.fieldValue');
        console.log(this[fieldMeta.attributes.type])
        switch(this.fieldMap[fieldMeta.attributes.type]) {
            case 'decimalValue':
                component.set('v.decimalValue', Number(fieldValue));
                break;
                
            case 'booleanValue':
                component.set('v.booleanValue', Boolean(fieldValue));
                break;
            
			case 'dateValue':
                component.set('v.stringValue', String(fieldValue));
                break;
            
            default:
            case 'stringValue':
                component.set('v.stringValue', fieldValue != null ? String(fieldValue) : '');
                break;
        }
    }
})