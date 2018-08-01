public with sharing class InvoiceUploadController {

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
            Map<String, String> invoiceConfigurations = new Map<String, String>();
        
            List<FieloPLT__Member__c> members = new MembersSelector(new Set<String>{'FieloPLT__Program__r.FieloPRP__RequestInvoiceProducts__c','FieloPLT__Program__r.FieloPRP__ProductInjectQuery__c'})
                .selectById(new Set<Id>{memberId});

            if (!members.isEmpty()) {
                invoiceConfigurations.put('requestInvoiceProducts', String.valueOf(members[0].FieloPLT__Program__r.RequestInvoiceProducts__c));
                invoiceConfigurations.put('productInjectQuery', members[0].FieloPLT__Program__r.ProductInjectQuery__c);
            }
            
            FieloPLT__PublicSettings__c settings = AuraService.settings;

            if (settings != null) {
                invoiceConfigurations.put('productLookupField', settings.FieloPRP__ProductLookupField__c != null ? settings.FieloPRP__ProductLookupField__c : 'FieloPRP__Product__c');
                invoiceConfigurations.put('maxFileSize', settings.FieloPRP__MaxFileSize__c != null ? String.valueOf(Integer.valueOf(settings.FieloPRP__MaxFileSize__c)) : '4350000');
                invoiceConfigurations.put('maxChunkSize', settings.FieloPRP__MaxFileChunkSize__c != null ? String.valueOf(Integer.valueOf(settings.FieloPRP__MaxFileChunkSize__c)) : '950000');
            } else {
                invoiceConfigurations.put('productLookupField', 'FieloPRP__Product__c');
                invoiceConfigurations.put('maxFileSize', '4350000');
                invoiceConfigurations.put('maxChunkSize', '950000');
            }

            invoiceConfigurations.put('productObjectName', Schema.SObjectType.InvoiceItem__c.fields.getMap().get( invoiceConfigurations.get('productLookupField') ).getDescribe().getReferenceTo()[0].getDescribe().getName() );

            return invoiceConfigurations;
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
            Map<String, Object> objectInfo = new Map<String, Object>();
            List<Object> fieldsInfoObj = new List<Object>();
            List<Map<String, Object>> newfieldsInfo = new List<Map<String, Object>>();
            Map<String, Object> fieldMeta;
            Map<String, Object> fieldAttributes;

            objectInfo = (Map<String, Object>) JSON.deserializeUntyped(AuraService.getFieldData(objectName,fieldNames));
            fieldsInfoObj = (List<Object>) objectInfo.get('fields');

            for (Object fieldMetaObject: fieldsInfoObj) {
                fieldMeta = (Map<String, Object>) fieldMetaObject;
                fieldAttributes = (Map<String, Object>) fieldMeta.get('attributes');
                if (String.valueOf(fieldAttributes.get('name')) == 'FieloPRP__Amount__c') {
                    fieldAttributes.put('min', (Object) 0);
                }
                fieldMeta.put('attributes', (Object) fieldAttributes);
                newfieldsInfo.add(fieldMeta);
            }
            objectInfo.put('fields', (Object) newfieldsInfo);
            return JSON.serialize(objectInfo);
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
            if (submitMode == 'Approval Process') {
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
        if (Schema.sObjectType.ContentVersion.isCreateable()) {
            insert cv;
        } else {
            throw new FieloException(String.format(Label.PermissionOnObject, new List<String>{'ContentVersion'}));
        }

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
        if (Schema.sObjectType.ContentDocumentLink.isCreateable()) {
            insert cdl;
        } else {
            throw new FieloException(String.format(Label.PermissionOnObject, new List<String>{'ContentDocumentLink'}));
        }

        return cv.Id;
    }

    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        Savepoint sp = Database.setSavepoint();
        try{
            if (fileId == '') {
	            fileId = saveFile(parentId, fileName, base64Data, contentType);
	        } else {
	            fileId = appendToFile(parentId, fileId, base64Data);
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

    private static Id appendToFile(Id parentId, Id fileId, String base64Data) {
        if (Schema.sObjectType.ContentVersion.isAccessible()) {
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

            if (Schema.sObjectType.ContentDocument.isDeletable()) {
                delete [SELECT Id FROM ContentDocument WHERE Id = :existingCV.ContentDocumentId];
            }
            if (Schema.sObjectType.ContentVersion.isCreateable()) {
                insert cv;
            } else {
                throw new FieloException(String.format(Label.PermissionOnObject, new List<String>{'ContentVersion'}));
            }

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
            if (Schema.sObjectType.ContentDocumentLink.isCreateable()) {
                insert cdl;
            } else {
                throw new FieloException(String.format(Label.PermissionOnObject, new List<String>{'ContentDocumentLink'}));
            }

            return cv.Id;
        } else {
            throw new FieloException(String.format(Label.PermissionOnObject, new List<String>{'ContentVersion'}));
        }
    }
}