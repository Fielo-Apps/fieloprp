public class MultiFileUploader {
    @RemoteAction
    public static Id saveAttachment(Id parentId, String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = new Attachment();
        if (Schema.sObjectType.Attachment.fields.parentId.isCreateable()) {
            a.parentId = parentId;
        }
 
        if (Schema.sObjectType.Attachment.fields.Body.isCreateable()) {
            a.Body = EncodingUtil.base64Decode(base64Data);
        }
        
        if (Schema.sObjectType.Attachment.fields.Name.isCreateable()) {
            a.Name = fileName;
        }

        if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable()) {
            a.ContentType = contentType;
        }
        
        insert a;
        
        return a.Id;
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
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = :fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        if (Schema.sObjectType.Attachment.fields.Body.isUpdateable()) {
            a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        }
        
        update a;
    }

    @RemoteAction
    public static Boolean deleteAttachments(List<String> attachmentIds){
        Boolean result = false;
        Set<Id> attachmentIdsSet = new Set<Id>();
        for(String singleId: attachmentIds) {
            try {
                attachmentIdsSet.add((Id)singleId);
            } catch (Exception e) {
                continue;
            }
        }
        if(!attachmentIdsSet.isEmpty()) {
            String query = 'Select Id, Name From Attachment Where Id in :attachmentIdsSet';
            List<Attachment> attachments = Database.query(query);
            if(Attachment.SObjectType.getDescribe().isDeletable()){
                delete attachments;
                result = true;
            }
        }
        return result;
    }

    @RemoteAction
    public static List<String> getList(){
        return new List<String>{'Elem 1', 'Elem 2', 'Elem 3'};
    }
}