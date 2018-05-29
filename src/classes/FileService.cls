public with sharing class FileService {
	public static Map<String, String> documentToAttachmentMap {get{
		if (documentToAttachmentMap == null) {
			documentToAttachmentMap = new Map<String, String>{
				'Id' => 'Id',
				'Description' => 'Description',
				'ContentSize' => 'BodyLength',
				'FileExtension' => 'ContentType',
				'FileType' => 'ContentType',
				'OwnerId' => 'OwnerId',
				'ParentId' => 'ParentId',
				'Title' => 'Name'
			};
		}
		return documentToAttachmentMap;
	}
		set;
	}

	public static Map<String, String> attachmentToDocumentMap {get{
		if (attachmentToDocumentMap == null) {
			attachmentToDocumentMap = new Map<String, String>{
				'Id' => 'Id',
				'Description' => 'Description',
				'BodyLength' => 'ContentSize',
				'ContentType' => 'FileExtension',
				'ContentType' => 'FileType',
				'OwnerId' => 'OwnerId',
				'ParentId' => 'ParentId',
				'Name' => 'Title'
			};
		}
		return attachmentToDocumentMap;
	}
		set;
	}

	public static void cloneFiles(Id parentId, Set<Id> fileIds) {
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

        for(String singleId: fileIds) {
            if (singleId.substring(0,3).equals(attachmentPrefix)) {
                attachmentIdsSet.add(singleId);
            }
            if (singleId.substring(0,3).equals(contentDocumentPrefix)) {
                documentIdsSet.add(singleId);
            }
        }

        if (!attachmentIdsSet.isEmpty()) {
        	createDocumentFromAttachment(parentId, attachmentIdsSet);
        }

        if (!documentIdsSet.isEmpty()) {
        	cloneDocuments(parentId, documentIdsSet);
        }
	}

	public static void createDocumentFromAttachment(Id parentId, Set<Id> attachmentIds) {
		Map<Id,Attachment> attachmentMap = new Map<Id,Attachment>((List<Attachment>)Database.query('SELECT Id, Name, Body, ParentId FROM Attachment WHERE Id IN :attachmentIds'));
		List<ContentVersion> cvs = new List<ContentVersion>();

		if (!attachmentMap.isEmpty()) {
			ContentVersion cv;
			for (Attachment a: attachmentMap.values()) {
				cv = new ContentVersion();
		        if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable()) {
		            cv.Title = a.Name;
		        }
		        if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {
		            cv.PathOnClient = a.Name;
		        }
		        if (Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()) {
		            cv.VersionData = a.Body;
		        }
		        if (Schema.sObjectType.ContentVersion.fields.IsMajorVersion.isCreateable()) {
		            cv.IsMajorVersion = true;
		        }
		        cvs.add(cv);
			}
			if (!cvs.isEmpty()) {
				insert cvs;
				Map<Id, ContentVersion> cvMap = new Map<Id, ContentVersion>((List<ContentVersion>)Database.query('SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :cvs'));
				
				List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
				ContentDocumentLink cdl;
				for (ContentVersion contentVersion:cvs) {
			        cdl = new ContentDocumentLink();
			        if (Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable()) {
			            cdl.ContentDocumentId = cvMap.get(contentVersion.Id).ContentDocumentId;
			        }
			        if (Schema.sObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable()) {
			            cdl.LinkedEntityId = parentId;
			        }
			        if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
			            cdl.ShareType = 'V';
			        }
			        cdls.add(cdl);
				}
				if (!cdls.isEmpty()) {
		        	insert cdls;
				}
			}
		}
	}

	public static void cloneDocuments(Id parentId, Set<Id> documentIds) {
		Map<Id, ContentDocument> contentDocumentMap = new Map<Id, ContentDocument>((List<ContentDocument>) Database.query('SELECT Id, (Select Id, Title, PathOnClient, IsMajorVersion FROM ContentVersions ORDER BY CreatedDate DESC LIMIT 1) FROM ContentDocument WHERE Id in :documentIds'));
		Set<Id> contentDocumentIds = contentDocumentMap.keySet();
		Map<Id, ContentVersion> existingCVS = new Map<Id,ContentVersion>((List<ContentVersion>) Database.query('SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentIds'));
		List<ContentVersion> cvs = new List<ContentVersion>();
		ContentVersion cv;

		for (ContentDocument cd: contentDocumentMap.values()) {
			if (!cd.ContentVersions.isEmpty()) {
				cv = new ContentVersion();
		        if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable()) {
		            cv.Title = cd.ContentVersions[0].Title;
		        }
		        if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {
		            cv.PathOnClient = cd.ContentVersions[0].PathOnClient;
		        }
		        if (Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()) {
		            cv.VersionData = existingCVS.get(cd.ContentVersions[0].Id).VersionData;
		        }
		        if (Schema.sObjectType.ContentVersion.fields.IsMajorVersion.isCreateable()) {
		            cv.IsMajorVersion = cd.ContentVersions[0].IsMajorVersion;
		        }
		        cvs.add(cv);
			}
		}
		if (!cvs.isEmpty()) {
			insert cvs;

			Map<Id, ContentVersion> cvMap = new Map<Id, ContentVersion>((List<ContentVersion>) Database.query('SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :cvs'));
			List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
			ContentDocumentLink cdl;

			for (ContentVersion contentVersion:cvs) {
		        cdl = new ContentDocumentLink();
		        if (Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable()) {
		            cdl.ContentDocumentId = cvMap.get(contentVersion.Id).ContentDocumentId;
		        }
		        if (Schema.sObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable()) {
		            cdl.LinkedEntityId = parentId;
		        }
		        if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
		            cdl.ShareType = 'V';
		        }
		        cdls.add(cdl);
			}
			if (!cdls.isEmpty()) {
	        	insert cdls;
			}
		}
	}
}