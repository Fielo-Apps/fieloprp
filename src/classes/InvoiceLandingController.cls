/**
* @description Class to Controller the Incentives Landing Page.
*/
public with sharing class InvoiceLandingController extends PageSettingsSetController{
    private ApexPages.StandardSetController controller {get;set;}
    public String currentView {get;set;}

    public FieloPLT__Program__c currentProgram { get {
        if ( currentProgram == null) {
            currentProgram = ProgramService.getActiveProgram();
        }
        return currentProgram;
    }set;}

    public InvoiceLandingController(ApexPages.StandardSetController stController) {
        this.controller = stController;

        initPageSettings('FieloPRP__Invoice__c','','','');

        this.newSettings.FieloPLT__Sections__c = getSectionsWithMemberWhereCondition(this.newSettings.FieloPLT__Sections__c, currentProgram.Id);
    }

    public List<SelectOption> getListViews() {
        return controller.getListViewOptions();
    }

    public static String getSectionsWithMemberWhereCondition(String sectionsString, String programId){
        List<Section> sections = (List<Section>) JSON.deserialize( sectionsString, List<Section>.class );
        for ( Section s :sections ) {
          for ( List<FormField> r :s.rows ) {
            for ( FormField f :r ) {
              if(f.Name != null) {
                if(f.Name == 'FieloPRP__Member__c') {
                    f.WhereCondition = ' FieloPLT__Program__c IN ( /' + programId + '/ ) ';
                }
              }
            }
          }
        }
        return JSON.serialize(sections);
    }

    @RemoteAction
    public static List<SObject> getInvoices( String objectName, String fields, Integer offset, String orderBy, String filter, Integer recordsPerPage ) {
        
        Set<String> fieldset = new Set<String>(fields.split(','));

        Map<String,Object> jsonObject = (Map<String, Object>) JSON.deserializeUntyped( filter);

        Id programId = (String)jsonObject.get('FieloPRP__Member__r.FieloPLT__Program__c');

        if ( orderBy == null ) {
            orderBy = 'LastModifiedDate DESC';
        }

        return InvoiceService.getInvoices( fieldset, null, programId, recordsPerPage,  offset, orderBy);
    }

    public class Section {
        public String Name{get;set;}
        public List<List<FormField>> Rows{get;set;}

        //PRP Properties
        public List<List<FormField>> FieloPRP_Product{get;set;}
        public List<List<FormField>> FieloPRP_ProductRecent{get;set;}
        public List<List<FormField>> FieloPRP_InvoiceItems{get;set;}
    }

    public class FormField {
        public String Type{get;set;}
        public String Name{get;set;}
        public String onchange{get;set;}
        public String Label{get;set;}
        public String Value{get;set;}
        public String WhereCondition{get;set;}
        public String ClassName{get;set;}
    }
}