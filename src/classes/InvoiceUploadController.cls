public class InvoiceUploadController {

    @AuraEnabled
    public static sObject getRecord(String invoiceId, String fields, String itemFields) {
        try{
            Set<String> fieldSet = new Set<String>(fields != null && fields != '' ? fields.split(',') : new List<String>());
            return (new InvoicesSelector(fieldSet).selectByIdWithChilds(new Set<Id>{invoiceId}, itemFields))[0];
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }

	@AuraEnabled
    public static Map<String, String> getInvoiceUploadConfiguration(String memberId) {
    	try{
            return AuraService.getInvoiceUploadConfiguration(memberId);
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static String getFieldData(String objectName, String fieldNames) {
        try{
            return AuraService.getFieldData(objectName,fieldNames);
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static String save(Invoice__c invoice, List<InvoiceItem__c> items, String submitMode, List<Id> fileIds) {
        try{
            Invoice__c submittedInvoice = InvoiceService.submitInvoice(invoice, items, null);
            if (submitMode == 'Close') {
                submittedInvoice = InvoiceService.closeInvoice(submittedInvoice.Id);
            }
            if (!fileIds.isEmpty()) {
                FileService.cloneFiles(submittedInvoice.Id, new Set<Id>(fileIds));
            }
            return submittedInvoice.Id;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }
    
    // Copy File Save From fielocms-fieloprp
    @AuraEnabled
    public static Id saveFile(Id parentId, String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion cv = new ContentVersion();
        if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable()) {
            cv.Title = fileName;
        }
        if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {
            cv.PathOnClient = fileName;
        }
        if (Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()) {
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
        }
        if (Schema.sObjectType.ContentVersion.fields.IsMajorVersion.isCreateable()) {
            cv.IsMajorVersion = false;
        }
        insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
        if (Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable()) {
            cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        }
        if (Schema.sObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable()) {
            cdl.LinkedEntityId = parentId;
        }
        if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
            cdl.ShareType = 'V';
        }
        insert cdl;

        return cv.Id;
    }

    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        Savepoint sp = Database.setSavepoint();
        try{
            if (fileId == '') {
	            fileId = saveFile(parentId, fileName, base64Data, contentType);
	        } else {
	            appendToFile(parentId, fileId, base64Data);
	        }
        	return Id.valueOf(fileId);
        } catch (DmlException e) {
            Database.rollback( sp );
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            Database.rollback( sp );
            throw new AuraHandledException(e.getMessage());
        }
        return null;
    }

    private static void appendToFile(Id parentId, Id fileId, String base64Data) {
        ContentVersion existingCV = [SELECT Id, VersionData, Title, PathOnClient, ContentDocumentId FROM ContentVersion WHERE Id = :fileId ORDER BY CreatedDate DESC LIMIT 1];

        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        String existingBody = EncodingUtil.base64Encode(existingCV.VersionData);
        
        ContentVersion cv = new ContentVersion();
        if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable()) {
            cv.Title = existingCV.Title;
        }
        if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {
            cv.PathOnClient = existingCV.Title;
        }
        if (Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()) {
            cv.VersionData = EncodingUtil.base64Decode(existingBody + base64Data); 
        }
        if (Schema.sObjectType.ContentVersion.fields.IsMajorVersion.isCreateable()) {
            cv.IsMajorVersion = true;
        }
        insert cv;

        delete [SELECT Id FROM ContentDocument WHERE Id = :existingCV.ContentDocumentId];

        ContentDocumentLink cdl = new ContentDocumentLink();
        if (Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable()) {
            cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        }
        if (Schema.sObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable()) {
            cdl.LinkedEntityId = parentId;
        }
        if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
            cdl.ShareType = 'V';
        }
        insert cdl;
    }
}