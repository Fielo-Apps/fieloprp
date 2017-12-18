public with sharing class ImageGalleryController {
    private List<Attachment> images;
    public String cParentId {set;get;}

    public List<Attachment> getImages(){
        images = [SELECT Id, Name, ContentType FROM Attachment WHERE ParentId =: cParentId];
        return images;
    }
}