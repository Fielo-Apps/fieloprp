public class AddProductsController {
	@auraEnabled
	public static List<SObject> getProducts(List<String> fieldsInvoices, String whereClause, Integer quantity, Integer offset, String orderBy) {
        try{
            Set<String> fieldsInvoicesSet = new Set<String>(fieldsInvoices);
            fieldsInvoicesSet.add('Id');
            System.debug('whereClause = ' + whereClause);

            String query = 'SELECT ' + String.join(new List<String>(fieldsInvoicesSet), ',') +
            	' FROM ' + productObjectName;

            if (whereClause != null && whereClause != '') {
            	query += ' WHERE ' + whereClause + '{0}';
            	query = String.format(query, new List<String>{''}) ;
            }

            if (orderBy != null) {
            	query += ' ORDER BY '+ orderBy;	
            }
            if (quantity != null) {
            	query += ' LIMIT ' + quantity;
            }
            if (offset != null) {
            	query += ' OFFSET ' + offset;
            }

            System.debug('Query: ' + query);

            List<SObject> productRecords = Database.query(query);

            return productRecords;
        } catch(DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String productField {get{
        if (productField==null) {
            String value;
            try {
                value = FieloPLT__PublicSettings__c.getInstance(UserInfo.getProfileId()).FieloPRP__ProductLookupField__c;
            } catch(Exception e) {
                value = null;
            }
            productField = value != null ? value : 'FieloPRP__Product__c';
        } 
        return productField;
    } set; }

    public static String productObjectName {get{
    	if (productObjectName==null) {
    		productObjectName = Schema.describeSObjects(new String[]{ 'FieloPRP__InvoiceItem__c' }).get(0).fields.getMap().get(productField).getDescribe().getReferenceTo()[0].getDescribe().getName();
    	}
    	return productObjectName;
    } set; }
}