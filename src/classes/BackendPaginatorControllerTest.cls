@isTest
private class BackendPaginatorControllerTest {
	
	@isTest static void test() {
		BackendPaginatorController bpc = new BackendPaginatorController();
		bpc.filter = '{"Name":"Name"}';
		String cfilter = bpc.cFilter;
		System.assertEquals('{"Name":"Name"}',cfilter);
	}
	
}