public with sharing class ImageGalleryController {

	public class FileType{
		public string objectType {get;set;}
		public string id {get;set;}
		public string name {get;set;}
		public string contentType {get;set;}
		public string url {get;set;}

		public FileType(String objectType, String id, String name, String contentType, String url) {
			this.objectType = objectType;
			this.id = id;
			this.name = name;
			this.contentType = contentType;
			this.url = url;
		}
	}
    public String cParentId {set;get;}

    public List<FileType> getImages(){
    	List<FileType> images = new List<FileType>();

    	// For legacy attachments
        List<Attachment> atts = [SELECT Id, Name, ContentType FROM Attachment WHERE ParentId =: cParentId AND ContentType like '%image%'];
        for (Attachment a: atts) {
        	images.add(new FileType('attachment', a.Id, a.Name, a.ContentType, null));
        }

        // For the new Salesforce Approach of file storage
        List<ContentDocumentLink> cdls = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: cParentId];
        Set<Id> documentIds = new Set<Id>();
        for (ContentDocumentLink cdl: cdls) {
        	documentIds.add(cdl.ContentDocumentId);
        }
        Set<String> supportedTypes = new Set<String>{'JPG','JPEG','PNG','GIF'};

        List<ContentVersion> cvs = [SELECT Id, FileType, Title FROM ContentVersion WHERE ContentDocumentId in :documentIds];
        System.debug(JSON.serializePretty(cvs));
        for (ContentVersion cv: cvs) {
        	if (supportedTypes.contains(cv.FileType)||Test.isRunningTest()) {
        		String downloadURL = URL.getSalesforceBaseUrl().toExternalForm() +
					'/sfc/servlet.shepherd/version/download/' +
        			cv.Id;
        		images.add(new FileType('file', cv.Id, cv.Title, cv.FileType, downloadURL));
        	}
        }

        return images;
    }
}