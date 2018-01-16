@isTest
public class ItemsControllerTest {
	
	@isTest static void ItShouldTestGettersAndSetters(){
		ItemsController ctrl = new ItemsController();
		ctrl.cFieldset = '[{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]],"FieloPRP_Product":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_ProductRecent":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_InvoiceItems":[[{"Name":"FieloPRP__Quantity__c","Type":"input","ClassName":"fielosf-product_qty","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c","Type":"lookup","ClassName":"fielosf-product_name","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c","Type":"input","ClassName":"fielosf-product_unit-price","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c","Type":"input","ClassName":"fielosf-product_total-price","onchange":"refreshTotalPriceProxy_"}]]}]';

		List<ItemsController.Section> sections = ctrl.sections;

		System.assert(sections.size()>0);

		String fields = ctrl.fields;

		System.assert( fields != '' && fields != null );
	}

	@isTest static void ItShouldTestInnerClasses() {
		//Given
        String sectionsString = '[{"Name":"Information","Rows":[[{"Name":"FieloPRP__Member__c","Type":"lookup"},{"Name":"FieloPRP__HasDetails__c","Type":"checkbox"}],[{"Name":"FieloPRP__InvoiceNumber__c","Type":"input"}],[{"Name":"FieloPRP__Amount__c","Type":"input"},{"Name":"FieloPRP__Date__c","Type":"input"}],[{"Name":"FieloPRP__Description__c","Type":"input"},{"Name":"FieloPRP__Distributor__c","Type":"lookup"}]],"FieloPRP_Product":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_ProductRecent":[[{"Name":"Name","Type":"input"},{"Name":"Family","Type":"picklist"},{"Name":"ProductCode","Type":"input"}]],"FieloPRP_InvoiceItems":[[{"Name":"FieloPRP__Quantity__c","Type":"input","ClassName":"fielosf-product_qty","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__Product__c","Type":"lookup","ClassName":"fielosf-product_name","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__UnitPrice__c","Type":"input","ClassName":"fielosf-product_unit-price","onchange":"refreshTotalPriceProxy_"},{"Name":"FieloPRP__TotalPrice__c","Type":"input","ClassName":"fielosf-product_total-price","onchange":"refreshTotalPriceProxy_"}]]}]';

        List<ItemsController.Section> sections = (List<ItemsController.Section>) JSON.deserialize( sectionsString, List<ItemsController.Section>.class );
        for ( ItemsController.Section s :sections ) {
        	s.Name = s.Name;
        	s.FieloPRP_Product = s.FieloPRP_Product;
        	s.FieloPRP_ProductRecent = s.FieloPRP_ProductRecent;
        	s.FieloPRP_InvoiceItems = s.FieloPRP_InvoiceItems;
          	for ( List<ItemsController.FormField> r :s.rows ) {
            	for ( ItemsController.FormField f :r ) {
              		f.Type = f.Type;
              		f.Name = f.Name;
              		f.onchange = f.onchange;
              		f.Label = f.Label;
              		f.Value = f.Value;
              		f.WhereCondition = f.WhereCondition;
              		f.ClassName = f.ClassName;
            	}
          	}
        }
	}
}