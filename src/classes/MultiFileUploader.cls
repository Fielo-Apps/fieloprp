public class MultiFileUploader {
    @RemoteAction
    public static Id saveAttachment(Id parentId, String fileName, String base64Data, String contentType) { 
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
            cv.IsMajorVersion = true;
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

    @RemoteAction
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
        if (fileId == '') {
            fileId = saveAttachment(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion cv = [
            SELECT Id, VersionData
            FROM ContentVersion
            WHERE Id = :fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(cv.VersionData);
        if (Schema.sObjectType.ContentVersion.fields.VersionData.isUpdateable()) {
            cv.VersionData = EncodingUtil.base64Decode(existingBody + base64Data); 
        }
        
        update cv;
    }

    @RemoteAction
    public static Boolean deleteFiles(List<String> attachmentIds){
        List<Schema.DescribeSObjectResult> describes = Schema.describeSObjects(new String[]{'Attachment','ContentDocument'}); //[0].getDescribe().getKeyPrefix();
        String attachmentPrefix;
        String contentDocumentPrefix;
        for (Schema.DescribeSObjectResult d: describes) {
          if(d.getName()=='Attachment') {
            attachmentPrefix = d.getKeyPrefix();
          }
          if(d.getName()=='ContentDocument') {
            contentDocumentPrefix = d.getKeyPrefix();
          }
        }

        Set<Id> attachmentIdsSet = new Set<Id>();
        Set<Id> documentIdsSet = new Set<Id>();

        for(String singleId: attachmentIds) {
            if (singleId.substring(0,3).equals(attachmentPrefix)) {
                attachmentIdsSet.add(singleId);
            }
            if (singleId.substring(0,3).equals(contentDocumentPrefix)) {
                documentIdsSet.add(singleId);
            }
        }

        Boolean attachmentResult=false;
        Boolean documentResult=false;
        if (!attachmentIdsSet.isEmpty()) {
            attachmentResult = deleteAttachments(attachmentIdsSet);
        }
        if (!documentIdsSet.isEmpty()) {
            documentResult = deleteDocuments(documentIdsSet);
        }
        
        return attachmentResult || documentResult;
    }

    public static Boolean deleteAttachments(Set<Id> attachmentIdsSet) {
        Boolean result = false;
        String query = 'Select Id, Name From Attachment Where Id in :attachmentIdsSet';
        List<Attachment> attachments = Database.query(query);
        if(Attachment.SObjectType.getDescribe().isDeletable()){
            delete attachments;
            result = true;
        }
        return result;
    }

    public static Boolean deleteDocuments(Set<Id> documentIdsSet) {
        Boolean result = false;
        String query = 'SELECT Id, Title FROM ContentDocument WHERE Id in :documentIdsSet';
        List<ContentDocument> documents = Database.query(query);
        if(ContentDocument.SObjectType.getDescribe().isDeletable()){
            delete documents;
            result = true;
        }
        return result;
    }
}