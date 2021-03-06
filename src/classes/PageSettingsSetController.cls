// TODO: Ver que pasa cuando hay registros para un program y registros sin program
public with sharing abstract class PageSettingsSetController{
    public Boolean showHeader {get{
        if(showHeader == null){
            showHeader = ApexPages.currentPage().getParameters().containsKey('embed') ? false : true;
        }return showHeader;
    }set;}
    
    public String objectName {get; set;}
    private Map<ID, Schema.RecordTypeInfo> mapRecordTypes {get;set;}
    
    /* Para los page settings de una landing */
    public FieloPLT__PageSettings__c newPS {get;set;}
    public FieloPLT__PageSettings__c landingPS {get;set;}
    
    public Boolean hasNewForm {get;set;} 
    
    public void addNewFieldSet(String fieldset){
        if(newPS != null){
            if(!String.isBlank(newPS.FieloPLT__Sections__c)){
                newPS.FieloPLT__Sections__c += ',';
            }
            newPS.FieloPLT__Sections__c += fieldset;
        }
    }
    public FieloPLT__PageSettings__c newSettings {get{
        if (newSettings == null){
            if (!String.isBlank(newPS.FieloPLT__Sections__c)){
                sObject sObj = Schema.getGlobalDescribe().get(objectName).newSObject();
                newPS.FieloPLT__Sections__c = '[' + PageSettingsController.replaceFormula( newPS.FieloPLT__Sections__c, sObj ) + ']';
            }
            newSettings = newPS;
        }
        return newSettings;
    }set;}
    
    public FieloPLT__PageSettings__c landingSettings {get{
        if (landingSettings == null){
            sObject sObj = Schema.getGlobalDescribe().get(objectName).newSObject();
            if (String.isNotBlank(landingPS.FieloPLT__Fieldset__c)){
                landingPS.FieloPLT__Fieldset__c = '[' + PageSettingsController.replaceFormula(landingPS.FieloPLT__Fieldset__c, sObj) + ']';
            }
            if (String.isNotBlank(landingPS.FieloPLT__Buttons__c)) {
                landingPS.FieloPLT__Buttons__c = '[' +  PageSettingsController.replaceFormula(landingPS.FieloPLT__Buttons__c, sObj) + ']'; 
            }
            if (String.isNotBlank(landingPS.FieloPLT__Tools__c)) {
                landingPS.FieloPLT__Tools__c = '[' + PageSettingsController.replaceFormula(landingPS.FieloPLT__Tools__c, sObj) + ']'; 
            }
            
            landingSettings = landingPS;
        }
        return landingSettings;
    }set;}
    
    /* 
Constructor para las Landings
*/
    public void initPageSettings(String objectName, String standardButtons, String standardTools, String defaultIcon, Id programId) {
        newSettings = null;
        landingSettings = null;
        
        this.objectName = objectName;
        //this.mapRecordTypes = PageSettingsController.getMapRecordTypes(objectName);
        
        List<String> recordTypeNames = new List<String>();
        //for ( Schema.RecordTypeInfo r : mapRecordTypes.values() ) {
        //  if ( !r.isMaster() && r.isAvailable() ) {
        //      recordTypeNames.add(r.getName());
        //  }
        //}
        
        if(programId == null){
            FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
            if(activeProgram != null){
                programId = activeProgram.Id;
            }
        }
        
        List<FieloPLT__PageSettings__c> settings =  PageSettingsController.getPageSettings(new List<String>{'Edit','New','Landing'}, recordTypeNames, objectName, programId);
        
        newPS = new FieloPLT__PageSettings__c(FieloPLT__Sections__c = '', FieloPLT__Object__c = objectName);
        FieloPLT__PageSettings__c editPS = new FieloPLT__PageSettings__c(FieloPLT__Sections__c = '', FieloPLT__Object__c = objectName);
        
        if(standardButtons == null){
            standardButtons = '';
        }
        if(standardTools == null){
            standardTools = '';
        }
        
        if(defaultIcon == null){
            defaultIcon = 'action-sprite/svg/symbols.svg#record';
        }        
        landingPS = new FieloPLT__PageSettings__c(FieloPLT__Icon__c = defaultIcon, FieloPLT__Fieldset__c = '', FieloPLT__Buttons__c = standardButtons, FieloPLT__Tools__c = standardTools, FieloPLT__StandardActions__c = '');
        hasNewForm = false;
        Boolean hasEditForm = false;
        for (FieloPLT__PageSettings__c p : settings) {
            if (p.FieloPLT__Type__c == 'New'){
                hasNewForm = true;
                if (String.isNotBlank(p.FieloPLT__Sections__c)){
                    newPS.FieloPLT__Sections__c += (String.isNotBlank(newPS.FieloPLT__Sections__c) ? ',' : '') + p.FieloPLT__Sections__c;
                }
            } else if (p.FieloPLT__Type__c == 'Edit'){
                hasEditForm = true;
                if (String.isNotBlank(p.FieloPLT__Sections__c)){
                    editPS.FieloPLT__Sections__c += (String.isNotBlank(editPS.FieloPLT__Sections__c) ? ',' : '') + p.FieloPLT__Sections__c;
                }
            } else if(p.FieloPLT__Type__c == 'Landing'){
                if(String.isNotBlank(p.FieloPLT__Icon__c)){
                    landingPS.FieloPLT__Icon__c = p.FieloPLT__Icon__c;
                }              
                if (String.isNotBlank(p.FieloPLT__Fieldset__c)){
                    landingPS.FieloPLT__Fieldset__c += (String.isNotBlank(landingPS.FieloPLT__Fieldset__c) ? ',' : '') + p.FieloPLT__Fieldset__c;
                }
                if(String.isNotBlank(p.FieloPLT__Buttons__c)){
                    landingPS.FieloPLT__Buttons__c += (String.isNotBlank(landingPS.FieloPLT__Buttons__c) ? ',' : '') + p.FieloPLT__Buttons__c;
                }
                if (String.isNotBlank(p.FieloPLT__Tools__c )){
                    landingPS.FieloPLT__Tools__c += (String.isNotBlank(landingPS.FieloPLT__Tools__c) ? ',' : '') + p.FieloPLT__Tools__c;
                }
                landingPS.FieloPLT__StandardActions__c = p.FieloPLT__StandardActions__c;
            }
        }
        if (!hasNewForm && hasEditForm) {
            newPS = editPS;
            hasNewForm = true;
        }
        if (String.isNotBlank( landingPS.FieloPLT__StandardActions__c)){
            Set<String> opciones = new Set<String>();
            opciones.addAll( landingPS.FieloPLT__StandardActions__c.split(';') );
            
            system.debug(opciones);
            if (opciones.contains('Settings')){
                landingPS.FieloPLT__Tools__c = '{"Label":"' + Label.Settings + '","Type":"Link","Action":"/apex/FieloPLT__PageSettingsListView?type=set&objectName=' + objectName + '"}' + (String.isBlank(landingPS.FieloPLT__Tools__c)?'':',') + landingPS.FieloPLT__Tools__c;
            }
            
            if ( opciones.contains('New')){
                Schema.DescribeSObjectResult describeObjectResult = ((sObject)Type.forName(objectName).newInstance()).getSObjectType().getDescribe();         
                if (describeObjectResult.isCreateable()){
                    if(hasNewForm){
                        landingPS.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "' + objectName + 'Form" }' + (String.isBlank(landingPS.FieloPLT__Buttons__c) ? '' : ',') + landingPS.FieloPLT__Buttons__c;
                    } else {
                        landingPS.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '","Type":"Action","Action":"New","ObjectName":"' + objectName + '" }' + (String.isBlank(landingPS.FieloPLT__Buttons__c) ? '' : ',') + landingPS.FieloPLT__Buttons__c;
                    }               
                }
            }    
        }
    }
}