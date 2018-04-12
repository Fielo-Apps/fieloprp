@isTest
private class RemoteActionResultTest {
	
	@isTest static void test_method_one(){
		List<Product2> products = new List<Product2>();
		Product2 prod1 = new Product2();
		prod1.Name = 'Chocolate Diatt Branco';
		prod1.Description = 'chocolate branco sem açucar';
		products.add(prod1);
		Product2 prod2 = new Product2();
		prod2.Name = 'Batata Ruffles';
		prod2.Description = 'batatas onduladas sabor original';
		products.add(prod2);
		insert products;
		/*
		Test just the methods that weren't used by others test's class  
		*/
		RemoteActionResult remote = new RemoteActionResult();
		RemoteActionResult.RemoteActionRefresh refresh = new RemoteActionResult.RemoteActionRefresh('FieloPRP__Invoice__c','FieloPRP__Status__c');
		try {
    		String s;
    		Boolean b = s.contains('a');
		} catch(NullPointerException npe) {
			RemoteActionResult.RemoteActionMessage message = new RemoteActionResult.RemoteActionMessage(npe,products[1].Id);
			RemoteActionResult.RemoteActionMessage message1 = new RemoteActionResult.RemoteActionMessage(ApexPages.Severity.Error,npe.getMessage(),npe.getStackTraceString(),'products[1].Id');
			List<RemoteActionResult.RemoteActionMessage> msgs = new List<RemoteActionResult.RemoteActionMessage>{message,message1};
			remote.addMessages(msgs);
		}

	}
		
}