@isTest
private class PhotoUploadControllerTest {

@isTest public static void test(){
    List<FieloPLT__Program__c> programs;
    List<FieloPLT__Member__c> members;
    List<FieloPRP__Invoice__c> invoices;
    programs = MockUpFactory.createPrograms('Default', 1);
    programs[0].FieloPRP__RequestInvoiceProducts__c = true;
    insert programs;

    members = MockUpFactory.createMembers(programs[0].Id,2);
    insert members;

    Account distributor = new Account(name = 'Fielo');
    
    insert distributor;

    invoices = MockUpFactory.createInvoices(members[0].Id,1);
    invoices[0].Distributor__c = distributor.Id;
    invoices[0].InvoiceNumber__c = '123456';
    

    insert invoices;

    InvoiceItem__c item = new InvoiceItem__c(
        Quantity__c = 10.0,
        UnitPrice__c = 50.0,
        Invoice__c = invoices[0].Id
    );

    insert item;

    List<Folder> folders = [SELECT DeveloperName,Id,NamespacePrefix FROM Folder WHERE DeveloperName='FieloImages' AND NamespacePrefix='FieloPLT'];
    Document doc = new Document();
    doc.Name='Logo Fielo';
    doc.Body=EncodingUtil.Base64Decode('/services/data/v42/sobjects/Document/01546000000SgEKAA0/Body');
    doc.ContentType = 'image/png';
    doc.folderId=folders[0].Id;
    insert doc;



    PhotoUploadController controller = new PhotoUploadController();
    controller.folderUniqueName = 'FieloPLT__FieloImages';
    Id folderId = controller.folderId;
    List<PicklistController.Entry> documents = controller.existingDocuments;
    controller.recordObject = doc;
    controller.fieldNameObject = 'Id';
    controller.externalURLNameObject = 'Id';
    String enc = controller.getEncImage();
    Boolean image = controller.hasImage;
    RemoteActionResult result1 = PhotoUploadController.save(doc,folderId,'Document','Id','Id','existing',enc);
    RemoteActionResult result = PhotoUploadController.save(doc,folderId,'Document','Id','Id','cropped',enc);
    RemoteActionResult result2 = PhotoUploadController.remove(doc,'Id','Id');
    //Force the DML Exception
    RemoteActionResult result3 = PhotoUploadController.remove(doc,'Description','IsPublic');
    }


}