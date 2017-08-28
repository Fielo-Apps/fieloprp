public with sharing class FormInvoiceController {
    /*****  Datos  *****/
    public static Boolean cRecordRedirect{get;set;}
    public String csObjectName{get;set;}
    public String cfilterSObjectName{get;set;}
    private Boolean queryRecordNotDone = true;


    public String fields {get{
        if ( fields == null ) {
            fields = 'Id';
            for ( Section s :sections ) {
                for ( List<FormField> r :s.rows ) {
                    for ( FormField f :r ) {
                        if ( !String.isBlank(f.Name) ) {
                            fields += ', '  + f.Name;
                        }
                    }
                }
            }
        }
        return fields;
    }
        set;
    }

    public SObject cRecord {get;set;}

    public SObject recordObject{get{
        if (queryRecordNotDone ) {
            queryRecordNotDone = false;
            if ( cRecord !=null && cRecord.Id != null ) {
                Id recordId = cRecord.Id;
                String query = 'SELECT  ' + fields;
                query += ' FROM ' + csObjectName;
                query += ' WHERE Id = : recordId ';

                recordObject = Database.query(query)[0];
            } else {
                recordObject = Schema.getGlobalDescribe().get(csObjectName).newSObject() ;
            }
        }
        return recordObject;
    }
        set;
    }


    /*****  Secciones Y Fields  *****/
    public String cFieldset{get;set;}
    public String cFilter{get;set;}
    public String cFilterRecent{get;set;}

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

    public List<Section> sections { get {
        if ( sections == null ) {
            if ( !String.isBlank(cFieldset)  ) {
                // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
                if ( !cFieldset.startsWith('[') ) {
                    cFieldset = '[' + cFieldset.replace('\'', '"') + ']';
                }
                sections = (List<Section>) JSON.deserialize( cFieldset, List<FormInvoiceController.Section>.class );
            } else {
                sections = new List<Section>();
            }
        }
        return sections;
    } 
        set;
    }

    public String productSectionString {get{
        Section productSection = new Section();
        for(Section s: sections) {
            if(s.FieloPRP_Product != null){
                productSection.Name = 'Products';
                productSection.rows = s.FieloPRP_Product;
                break;
            }
        }
        return JSON.serialize(productSection);
    }
        set;
    }

    public String itemsSectionString {get{
        Section itemSection = new Section();
        for(Section s: sections) {
            if(s.FieloPRP_InvoiceItems != null){
                itemSection.Name = 'Product Recent';
                itemSection.rows = s.FieloPRP_InvoiceItems;
                break;
            }
        }
        return JSON.serialize(itemSection);
    }
        set;
    }

    public String filterRecentRecords {get{
        filterRecentRecords = '';
        if( !filterRecentRecordsMap.isEmpty() ){
            filterRecentRecords = JSON.serialize(filterRecentRecordsMap);
            filterRecentRecords = filterRecentRecords.substring(1,filterRecentRecords.length()-1);
        }
        return filterRecentRecords;
    }
        set;
    }

    /*****  Piclklist Values *****/
    private Map<String, Schema.SObjectField> fieldMap { get {
        if ( fieldMap == null && csObjectName != null ) {
            Schema.DescribeSObjectResult[] describes = Schema.describeSObjects(new String[]{ csObjectName });
            fieldMap = describes.get(0).fields.getMap();
        }
        return fieldMap;
    }
        set; 
    }

    private Map<String, Schema.SObjectField> filterFieldMap { get {
        if ( filterFieldMap == null && cfilterSObjectName != null ) {
            Schema.DescribeSObjectResult[] describes = Schema.describeSObjects(new String[]{ cfilterSObjectName });
            filterFieldMap = describes.get(0).fields.getMap();
        }
        return filterFieldMap;
    }
        set;
    }

    public Map<String, String> mapOptionsString { get {
        if ( mapOptionsString == null && mapPicklistOptions != null ) {
            mapOptionsString = new Map<String, String>();
            for ( String key : mapPicklistOptions.keySet() ) {
                String options = '';
                for ( PicklistController.Entry p : mapPicklistOptions.get(key) ) {
                    options += ',{ "id": "' + p.Id + '", "label": "' + p.Label + '" }';
                }
                if ( options != '') {
                    mapOptionsString.put(key,'[' + options.substring(1) + ']');
                } else {
                    mapOptionsString.put(key,'[]');
                }
            }
        }
        return mapOptionsString;
    }
        set;
    }

    public Map<String, List<PicklistController.Entry>> mapPicklistOptions { get {
        if ( mapPicklistOptions == null && !String.isBlank(csObjectName) ) {
            mapPicklistOptions = new Map<String, List<PicklistController.Entry>>();
            for ( Section s :sections ) {
                for ( List<FormField> ff :s.Rows ) {
                    for ( FormField f :ff ) {
                        if ( (f.Type == 'picklist' ||  f.Type == 'radio'|| f.Type == 'multiselect'|| f.Type == 'checkboxes') && fieldMap.containsKey(f.Name) ) {
                            List<PicklistController.Entry> options = new List<PicklistController.Entry>();
                            Schema.DescribeFieldResult describe = fieldMap.get(f.Name).getDescribe();
                            if ( describe.getType().name() == 'PICKLIST' || describe.getType().name() == 'MULTIPICKLIST' ) {
                                List<Schema.PicklistEntry> pickListValues = describe.getPickListValues();
                                for (Schema.PicklistEntry a : pickListValues) {
                                    options.add( new PicklistController.Entry(a.getValue(), a.getLabel() ));
                                }
                            } else if ( describe.getType().name() == 'REFERENCE' ) {
                                String query = 'SELECT ID, Name FROM ' + describe.getReferenceTo().get(0);
                                if ( ! String.isBlank( f.WhereCondition )  ){
                                    query += ' WHERE ' + f.WhereCondition.replace('/', '\'') ;
                                }
                                query += ' LIMIT 500';
                                for ( SObject o : Database.query(query) ) {
                                    // Substring para que matche con el multipicklist (para multisegment)
                                    options.add( new PicklistController.Entry( ((String)o.id).substring(0, 15),  (String)o.get('Name') ));
                                }
                            }
                            mapPicklistOptions.put( f.Name , options);
                        }
                    }
                }
            }
        }
        return mapPicklistOptions;
    }
        set;
    }

    public List<Map<String,String>> filterRecentRecordsMap{get{
        filterRecentRecordsMap = new List<Map<String,String>>();

        for ( Section s :sections ) {
            for ( List<FormField> r :s.FieloPRP_ProductRecent ) {
                for ( FormField f :r ) {
                    if ( !String.isBlank(f.Name) ) {
                        if ( f.Name != 'Name' ){
                            filterRecentRecordsMap.add(new Map<String,String>{
                                    'Name' => f.Name,
                                    'Type' => filterFieldMap.get(f.Name).getDescribe().getType().name(),
                                    'Label' => filterFieldMap.get(f.Name).getDescribe().getLabel()
                                }
                            );
                        }
                    }
                }
            }
        }
        return filterRecentRecordsMap;
    }
        set;
    }

    @RemoteAction
    public static RemoteActionResult save(FieloPRP__Invoice__c record, List<FieloPRP__InvoiceItem__c> items, List<String> nullFields){
        Savepoint sp;
        RemoteActionResult result = new RemoteActionResult();

        try{
            sp = Database.setSavepoint();

            for(String f: nullFields){
              if ( f != 'sObjectType' ) {
               record.put(f, null );
              }
            }

            Invoice__c invoice = InvoiceService.submitInvoice(record, items, null);
            result.addMessage( new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, Label.InvoiceSavedSuccess) );
            result.redirectURL = '/'+invoice.Id;
        }catch(DMLException e){
            if(sp != null){
                Database.rollback(sp);
            }
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }catch(Exception e){
            if(sp != null){
                Database.rollback(sp);
            }
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        return result;
    }

  @RemoteAction
  public static sObject retrieve( String objectName, String recordId, String fields, String itemFields){
    String query = 'SELECT ' + fields;
    if (itemFields != null) {
      query += String.format(' ,(SELECT {0} FROM InvoiceItems__r)', new List<String>{itemFields});
    }
    query += ' ,(SELECT Id, Name FROM Attachments)';
    query += ' FROM ' + objectName;
    query += ' WHERE ID = :recordId' ;
    query += ' LIMIT 1';
    List<sObject> result = Database.query(query);
    if ( result.size() > 0 ) {
      return result.get(0);
    }
    return null;
  }

  public FieloPLT__Program__c program {get{
        if (program == null){
            program = ProgramService.getActiveProgram();
        }
        return program;
    } set;}

    private static Map<String, Schema.SObjectField> staticFilterFieldMap {get;set;}

    private static void initStaticFilterFieldMap( String sObjectName ){
        if ( staticFilterFieldMap == null && sObjectName != null ) {
            Schema.DescribeSObjectResult[] describes = Schema.describeSObjects(new String[]{ sObjectName });
            staticFilterFieldMap = describes.get(0).fields.getMap();
        }
    }

    public static String assembleMemberWhereCondition(Id memberId){
        String whereCondition = '';
        String query = 'Select Id, '
            + 'FieloPLT__Points__c, '
            + 'FieloPLT__Program__c, '
            + '(Select Id From FieloPLT__MembersSegments__r) '
            + 'From FieloPLT__Member__c '
            + 'Where Id = :memberId';

        List<FieloPLT__Member__c> members = (List<FieloPLT__Member__c>) Database.query(query);

        if (!members.isEmpty()) {
          if (members[0].FieloPLT__Program__c != null) {
              whereCondition += ' AND FieloPLT__Program__c = \'' + members[0].FieloPLT__Program__c + '\'';
          }
          if (members[0].FieloPLT__Points__c != null) {
              whereCondition += ' AND FieloPLT__Points__c <= ' + members[0].FieloPLT__Points__c;
          }
          if ( !members[0].FieloPLT__MembersSegments__r.isEmpty()) {
              List<Id> memberSegments = new List<Id>( 
                  new Map<Id, FieloPLT__MemberSegment__c>(
                      members[0].FieloPLT__MembersSegments__r).keySet() 
              );
              whereCondition += ' AND (FieloPLT__Segment__c in (\'' + String.join(memberSegments,'\',\'') + '\')';
              whereCondition += ' OR FieloPLT__Segment__c = null)';
          }
        }
        return whereCondition;
    }

    public static String assembleWhereCondition(String fieldName, String fieldValue){
        //Member Field Special Treatment
        System.debug(fieldName + ' = ' + fieldValue);
        String singleWhereCondition='';
        if (staticFilterFieldMap.containsKey(fieldName)) {
            String fieldType = staticFilterFieldMap.get(fieldName).getDescribe().getType().name();
            Set<String> nonQuotedTypes = new Set<String>{'DOUBLE',
                'DATETIME',
                'DATE',
                'CURRENCY',
                'INTEGER',
                'BOOLEAN',
                'PERCENT',
                'TIME'};

            //Special treatment
            System.debug(fieldName + ' = ' + fieldType);
            if (nonQuotedTypes.contains(fieldType)) {
                singleWhereCondition = ' AND ' + fieldName + ' = ' + fieldValue;

            } else if (fieldType == 'STRING') {
                singleWhereCondition = ' AND ' + fieldName + ' like \'%' + fieldValue+'%\'';

            } else {
                singleWhereCondition = ' AND ' + fieldName + ' = \'' + fieldValue+'\'';
            }
        }
        return singleWhereCondition;
    }

    private static String getWhereCondition( String objectName, String filterJson ) {
      initStaticFilterFieldMap(objectName);
      String whereCondition = '';
      if(filterJson != null && filterJson != '{}'){
        Map<String,Object> filter = (Map<String, Object>) JSON.deserializeUntyped( filterJson);
        for ( String k :filter.keySet() ) {
          String value = String.valueOf(filter.get(k));
          if (value != null) {
            if ( value.startsWith('!') ) {
              whereCondition += ' AND ' + k + ' <> \'' +  value.substring(1) + '\'';
            } else {
              whereCondition += assembleWhereCondition(k,value);
            }
          }
        }
        if (whereCondition.length() > 4) {
          whereCondition = ' WHERE ' + whereCondition.substring(4);
          whereCondition += getProgramProductInjection();
        } else {
          whereCondition += getProgramProductInjection().substring(4);
        }
      }
      return whereCondition;
    }

    public static String getProgramProductInjection() {
      String whereCondition = ProgramService.getActiveProgram().FieloPRP__ProductInjectQuery__c;
      return whereCondition != '' &&
          whereCondition != null ?
          ' AND ' + whereCondition :
          ''; 
    }
    
    @RemoteAction
    public static List<SObject> getProductRecords( String objectName, String fields, Integer offset, String orderBy, String dataFilters, Integer recordsPerPage ) {

        String query = 'SELECT Id, ' + fields;
        query += ' FROM ' + objectName;
        query += getWhereCondition( objectName, dataFilters );

        // ORDER BY       
        if ( orderBy == null ) {
            orderBy = 'LastModifiedDate DESC';
        }
        query += ' ORDER BY '+ orderBy; //DESC
        // LIMIT & OFFSET
        if ( recordsPerPage == null ) {
            recordsPerPage = 10;
        }
        query += ' LIMIT '+ String.valueOf(recordsPerPage);
        if ( offset != null ){
          query += ' OFFSET '+ String.valueOf(offset);
        }
        System.debug('query: ' + query);
        return Database.query(query);
    }

    @RemoteAction
    public static Boolean getHasDetailsFromMember(String memberId) {
      String query = 'Select FieloPLT__Program__r.FieloPRP__RequestInvoiceProducts__c';
      query += ' FROM FieloPLT__Member__c';
      query += ' WHERE Id =: memberId';
      FieloPLT__Member__c member = (FieloPLT__Member__c) Database.query(query);
      return member.FieloPLT__Program__r.FieloPRP__RequestInvoiceProducts__c;
    }

    @RemoteAction
    public static FieloPLT__Program__c getActiveProgram() {
        return ProgramService.getActiveProgram();
    }
}