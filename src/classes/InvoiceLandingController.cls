/**
* @description Class to Controller the Incentives Landing Page.
*/
public with sharing class InvoiceLandingController extends PageSettingsSetController{
    private ApexPages.StandardSetController controller {get;set;}
    public Map<String,FieloPLT__PageSettings__c> lookupSettings {get;set;}

    public FieloPLT__Program__c currentProgram { get {
        if (currentProgram == null && ProgramService.hasPrograms()) {
            currentProgram = ProgramService.getActiveProgram();
        }
        return currentProgram;
    }set;}

    public void getLookupSetting( String objectNames, String targetObject, String targetField ) {      
        
        system.debug('getLookupSetting()');

        String query = 'SELECT Name, FieloPLT__Filters__c, FieloPLT__Fieldset__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c = \'Lookup\'  AND FieloPLT__Object__c = :objectNames  ';

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        
        system.debug('active program: ' + activeProgram);
        
        Id programId;
        if ( activeProgram != null  ) {
            programId = activeProgram.Id;
            query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }

        if ( String.isNotBlank(targetObject ) ) {
            query += ' AND FieloPLT__TargetObject__c = :targetObject';
        } 
        if ( String.isNotBlank(targetField ) ) {
            query += ' AND FieloPLT__TargetField__c = :targetField';
        }
        // ORDER BY & LIMIT 
        //query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c LIMIT 1 ';

        query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c';
        List<FieloPLT__PageSettings__c> pageSetting = Database.query(query);
        List<FieloPLT__PageSettings__c> lista = pageSetting.isEmpty() ? null : pageSetting;

        this.lookupSettings = new Map<String,FieloPLT__PageSettings__c>();
        
        if (!lista.isEmpty()){
            for(FieloPLT__PageSettings__c p :lista){
                if(p.Name == 'Products > Lookup'){
                    lookupSettings.put('productSection', p);
                }else if(p.Name == 'Product Recent > Lookup'){
                    lookupSettings.put('productRecentSection', p);
                }else if(p.Name == 'Invoice Item > Lookup'){
                    lookupSettings.put('itemsSection', p);
                }
            }
        }
    }

    public InvoiceLandingController(ApexPages.StandardSetController stController) {
        this.controller = stController;
        
        //Verify if a program was already created
        if(currentProgram != null)
        {      
            initPageSettings('FieloPRP__Invoice__c','','','',currentProgram.Id);
            getLookupSetting('FieloPRP__Invoice__c','','');
            //System.debug('lookupSettings: '+ lookupSettings);

            if(!Test.isRunningTest()) {
                this.newSettings.FieloPLT__Sections__c = getSectionsWithMemberWhereCondition(this.newSettings.FieloPLT__Sections__c, currentProgram.Id);
            }
        }
    }
    
    //Verify if a program was already created. If not, redirect to ProgramLanding page
    public PageReference verifyProgram(){
        PageReference retURL;
        if(!ProgramService.hasPrograms()){
            retURL = Page.FieloPLT__ProgramLanding;
            retURL.setRedirect(true);
        }
      return retURL;
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
    public static List<SObject> getInvoices( String objectName, String fields, Integer offset, String orderBy, String filter, Integer recordsPerPage, String whereClause ) {
        
        Set<String> fieldset = new Set<String>(fields.split(','));

        Map<String,Object> jsonObject = (Map<String, Object>) JSON.deserializeUntyped( filter);

        Id programId = (String)jsonObject.get('FieloPRP__Member__r.FieloPLT__Program__c');
        
        system.debug('programId: ' + programId);

        if ( orderBy == null ) {
            orderBy = 'LastModifiedDate DESC';
        }

        return InvoiceService.getInvoices( fieldset, null, programId, recordsPerPage,  offset, orderBy);
    }

    public class Section {
        public String Name{get;set;}
        public List<List<FormField>> Rows{get;set;}

        //PRP Properties
        /*public List<List<FormField>> FieloPRP_Product{get;set;}
        public List<List<FormField>> FieloPRP_ProductRecent{get;set;}
        public List<List<FormField>> FieloPRP_InvoiceItems{get;set;}*/
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