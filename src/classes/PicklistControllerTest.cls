@isTest
private class PicklistControllerTest {

	@testSetup static void createData(){
		List<Product2> products = new List<Product2>();
		Product2 prod1 = new Product2();
		prod1.Name = 'Chocolate Diatt Branco';
		prod1.Description = 'chocolate branco sem açucar';
		products.add(prod1);
		Product2 prod2 = new Product2();
		prod2.Name = 'Batata Ruffles';
		prod2.Description = 'batatas onduladas sabor original';
		products.add(prod2);
		Product2 prod3 = new Product2();
		prod3.Name = 'Toddynho';
		prod3.Description = 'bebida láctea sabor achocolatado';
		products.add(prod3);
		insert products;

	}
	
	@isTest static void test() {
		
        PicklistController controller = new PicklistController();
		PicklistController.Entry option1 = new PicklistController.Entry('Open','Open');
		PicklistController.Entry option2 = new PicklistController.Entry('Pending for Approval','Pending for Approval');
		PicklistController.Entry option3 = new PicklistController.Entry('Approved','Approved');
		PicklistController.Entry option4 = new PicklistController.Entry('Rejected','Rejected');
		PicklistController.Entry option5 = new PicklistController.Entry('Canceled','Canceled');
		List<PicklistController.Entry> picklist = new List<PicklistController.Entry>{option1,option2,option3,option4,option5};
		controller.cOptions = JSON.serialize(picklist);
		String optStr = controller.optionsString;
		List<PicklistController.Entry> options = controller.optionsList;
		List<Product2> myproducts = [SELECT Id,Name,Description FROM Product2];
		controller.cValue = myproducts[0].Id;
		String fixed = controller.fixedName;
		List<sObject> recordsSOSL = PicklistController.getRecordsSOSL('Product2','Id','Description','','','Branco');
		List<sObject> records = PicklistController.getRecords('Product2','Id','Name','','','Branco');
		System.assertEquals(myproducts[0].Id,records[0].Id);
	}
	
	
}