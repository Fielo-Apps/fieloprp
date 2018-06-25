public with sharing class InvoiceDetailController {
	@AuraEnabled
    public static String getFieldData(String objectName, String fieldNames) {
        try{
            return AuraService.getFieldData(objectName,fieldNames);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static String getFiles(String invoiceId) {
    	try{
            return JSON.serialize(AuraService.getImages(invoiceId));
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }
}