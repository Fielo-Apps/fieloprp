@isTest
private class BackendFooterControllerTest {
	
	@isTest static void test() {
		BackendFooterController bfc = new BackendFooterController();
		bfc.cExternalJS = 'Fielo,Valuenet';
		List<String> urls = bfc.getJSUrls();
		Long off = bfc.offset;

	}
	

	
}