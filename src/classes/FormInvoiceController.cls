public with sharing class FormInvoiceController {
    /*****  Datos  *****/
    public static Boolean cRecordRedirect{get;set;}
    public String csObjectName{get;set;}
    private Boolean queryRecordNotDone = true;


    public String productField {get{
        if (productField==null) {
            string value;
            try {
                value = FieloPLT__PublicSettings__c.getInstance(UserInfo.getProfileId()).FieloPRP__ProductLookupField__c;
            } catch(Exception e) {
                value = null;
            }
            productField = value != null ? value : 'FieloPRP__Product__c';
        } 
        return productField;
    }
        set;
    }

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
        if (recordObject==null) {
            if (queryRecordNotDone) {
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
        }
        return recordObject;
    }
        set;
    }


    /*****  Secciones Y Fields  *****/
    public String cFieldset{get;set;}
    public String cProductSection{get;set;}
    public String cProductRecentSection{get;set;}
    public String cItemsSection{get;set;}

    //Bruna deleted
    /*public class Section {
        public String Name{get;set;}
        public List<List<FormField>> Rows{get;set;}

        //PRP Properties    
        public List<List<FormField>> FieloPRP_Product{get;set;}
        public List<List<FormField>> FieloPRP_ProductRecent{get;set;}
        public List<List<FormField>> FieloPRP_InvoiceItems{get;set;}

    }*/

    //Bruna added
    public class Section {
        public String Name{get;set;}
        public List<List<FormField>> Rows{get;set;}
    }


    public class FormField {
        public String Type{get;set;}
        public String Name{get;set;}
        public String onchange{get;set;}
        public String Label{get;set;}
        public String Value{get;set;}
        public String WhereCondition{get;set;}
        public String ClassName{get;set;}

        public FormField(Map<String, String> attributes) {
            this.Type = attributes.containsKey('Type') ? attributes.get('Type') : '';
            this.Name = attributes.containsKey('Name') ? attributes.get('Name') : '';
            this.onchange = attributes.containsKey('onchange') ? attributes.get('onchange') : '';
            this.Label = attributes.containsKey('Label') ? attributes.get('Label') : '';
            this.Value = attributes.containsKey('Value') ? attributes.get('Value') : '';
            this.WhereCondition = attributes.containsKey('WhereCondition') ? attributes.get('WhereCondition') : '';
            this.ClassName = attributes.containsKey('ClassName') ? attributes.get('ClassName') : '';
        }
    }

    public List<FormField> requiredFields() {
        List<FormField> fields = new List<FormField>();
        Schema.DescribeFieldResult qty = Schema.describeSObjects(new String[]{ 'FieloPRP__InvoiceItem__c' })
            .get(0).fields.getMap()
                .get('FieloPRP__Quantity__c')
                    .getDescribe();
        fields.add(
            new FormField(
                new Map<String,String>{
                    'Type' => 'input',
                    'Name' => qty.getName(),
                    'onchange' => 'refreshTotalPriceProxy_',
                    'Label' => qty.getLabel(),
                    'ClassName' => 'fielosf-product_qty'
                }
            )
        );
        return fields;
    }

    public List<List<FormField>> checkFields(List<List<FormField>> rows) {
        Boolean hasQuantity = false;
        for(List<FormField> fields:rows) {
            for(FormField field: fields) {
                if (field.Name == 'FieloPRP__Quantity__c') {
                    hasQuantity = true;
                }
            }
        }
        List<List<FormField>> fixedRows = new List<List<FormField>>();
        if (!hasQuantity) {
            fixedRows.addAll(new List<List<FormField>> {this.requiredFields()});
        }
        fixedRows.addAll(rows);
        return fixedRows;
    }  

    /*public List<Section> sections { get {
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
    }*/

    //Bruna added
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


    //Bruna added
    public List<FormField> listProductSection { get{
        System.debug('Chegou em listProductSection: '+ cProductSection);
        if ( String.isNotBlank(cProductSection)  ) {
            System.debug('Chegou em cProductSection e não ta em branco');
            // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
            if ( !cProductSection.startsWith('[') ) {
                cProductSection = '[' + cProductSection.replace('\'', '"') + ']';
            }
            listProductSection = (List<FormField>) JSON.deserialize( cProductSection, List<FormInvoiceController.FormField>.class );
        } else {
            listProductSection = new List<FormField>();
        }
        
        return listProductSection;
    } 
        set;
    }
    

    //Bruna added
    public List<FormField> listItemsSection { get{
        System.debug('Chegou em cItemsSection: '+ cItemsSection);
        if ( String.isNotBlank(cItemsSection)  ) {
            // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
            if ( !cItemsSection.startsWith('[') ) {
               cItemsSection = '[' + cItemsSection.replace('\'', '"') + ']';
            }
            listItemsSection = (List<FormField>) JSON.deserialize( cItemsSection, List<FormInvoiceController.FormField>.class );
        } else {
            listItemsSection = new List<FormField>();
        }
        
        return listItemsSection;
    } 
        set;
    }


    //Bruna added
    public List<FormField> listProductRecentSection { get{
        if ( String.isNotBlank(cProductRecentSection) ) {
            // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
            if ( !cProductRecentSection.startsWith('[') ) {
                cProductRecentSection = '[' + cProductRecentSection.replace('\'', '"') + ']';
            }
            listProductRecentSection = (List<FormField>) JSON.deserialize( cProductRecentSection, List<FormInvoiceController.FormField>.class );
        } else {
            listProductRecentSection = new List<FormField>();
        }
        
        return listProductRecentSection;
    } 
        set;
    }
    

    //Bruna added
    public String productSectionString { get{
        System.debug('Chegou em productSectionString');
        if (productSectionString==null) {
            Section newProductSection = new Section();
            if( listProductSection != null) {
                newProductSection.Name = Schema.describeSObjects(new String[]{ 'FieloPRP__InvoiceItem__c' }).get(0).fields.getMap().get(productField).getDescribe().getReferenceTo()[0].getDescribe().getLabelPlural();
                newProductSection.rows = new List<List<FormField>>{listProductSection};
            }           
            productSectionString = JSON.serialize(newProductSection);
        }
        return productSectionString;
    }
        set;
    }

    //Bruna added
    public String itemsSectionString { get{
        System.debug('Chegou em itemsSectionString');
        if (itemsSectionString==null) {
            Section newItemSection = new Section();
            if(listItemsSection != null){
                newItemSection.Name = Label.Items;
                newItemSection.rows = new List<List<FormField>>{listItemsSection};
                newItemSection.rows = checkFields(newItemSection.rows);
                }
            
            itemsSectionString = JSON.serialize(newItemSection);
        }
        return itemsSectionString;
    }
        set;
    }

    public String filterRecentRecords {get{
        if (filterRecentRecords==null) {
            filterRecentRecords = '';
            if( !filterRecentRecordsMap.isEmpty() ){
                filterRecentRecords = JSON.serialize(filterRecentRecordsMap);
                filterRecentRecords = filterRecentRecords.substring(1,filterRecentRecords.length()-1);
            }
        }
        return filterRecentRecords;
    }
        set;
    }

    public String filterSObjectName {get{
        if (filterSObjectName==null) {
            filterSObjectName = Schema.describeSObjects(new String[]{ 'FieloPRP__InvoiceItem__c' })
                .get(0).fields.getMap()
                    .get(productField)
                        .getDescribe().getReferenceTo()[0].getDescribe().getName();
        }
        return filterSObjectName;
    }
        set;
    }

    private Map<String, Schema.SObjectField> filterFieldMap { get {
        if ( filterFieldMap == null && filterSObjectName != null ) {
            Schema.DescribeSObjectResult[] describes = Schema.describeSObjects(new String[]{ filterSObjectName });
            filterFieldMap = describes.get(0).fields.getMap();
        }
        return filterFieldMap;
        }set;}

    //Bruna deleted
    /*public List<Map<String,String>> filterRecentRecordsMap{get{
        if (filterRecentRecordsMap==null) {
            filterRecentRecordsMap = new List<Map<String,String>>();
            for ( Section s : sections ) {
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
        }
        return filterRecentRecordsMap;
    }
        set;
    }*/

    //Bruna added
    public List<Map<String,String>> filterRecentRecordsMap{get{
        if (filterRecentRecordsMap==null) {
            filterRecentRecordsMap = new List<Map<String,String>>();
            for ( FormField f : listProductRecentSection ) {
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
        query += ' ,(Select Id, ContentDocument.Title From ContentDocumentLinks)';
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
    } 
        set;
    }

    private static Map<String, Schema.SObjectField> staticFilterFieldMap {get;set;}

    private static void initStaticFilterFieldMap( String sObjectName ){
        if ( staticFilterFieldMap == null && sObjectName != null ) {
            Schema.DescribeSObjectResult[] describes = Schema.describeSObjects(new String[]{ sObjectName });
            staticFilterFieldMap = describes.get(0).fields.getMap();
        }
    }

    private static String assembleWhereCondition(String fieldName, String fieldValue){
        //Member Field Special Treatment
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
            if (nonQuotedTypes.contains(fieldType)) {
                singleWhereCondition = ' AND ' + String.escapeSingleQuotes(fieldName) + ' = ' + String.escapeSingleQuotes(fieldValue);
            } else if (fieldType == 'STRING') {
                singleWhereCondition = ' AND ' + String.escapeSingleQuotes(fieldName) + ' like \'%' + String.escapeSingleQuotes(fieldValue)+'%\'';
            } else {
                singleWhereCondition = ' AND ' + String.escapeSingleQuotes(fieldName) + ' = \'' + String.escapeSingleQuotes(fieldValue)+'\'';
            }
        }
        return singleWhereCondition;
    }

    private static String getWhereCondition( String objectName, String filterJson ) {
      initStaticFilterFieldMap(objectName);
      String whereCondition = '';
      if(filterJson != null && filterJson != '{}'){
        Map<String,Object> filter = (Map<String, Object>) JSON.deserializeUntyped( filterJson);
        for ( String fieldName :filter.keySet() ) {
          String fieldValue = String.valueOf(filter.get(fieldName));
          if (fieldValue != null) {
            if ( fieldValue.startsWith('!') ) {
              whereCondition += ' AND ' + String.escapeSingleQuotes(fieldName) + ' <> \'' +  String.escapeSingleQuotes(fieldValue.substring(1)) + '\'';
            } else {
              whereCondition += assembleWhereCondition(fieldName,fieldValue);
            }
          }
        }

        String productInjectQuery = getProgramProductInjection();

        if (whereCondition.length() > 4) {
          whereCondition = ' WHERE ' + whereCondition.substring(4);
          whereCondition += productInjectQuery;
        } else {
          whereCondition += productInjectQuery.length() > 4 ? productInjectQuery.substring(4) : '';
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
    public static List<SObject> getProductRecords( String objectName, String fields, Integer offset, String orderBy, String dataFilters, Integer recordsPerPage, String whereClause ) {

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
        
        //query = String.escapeSingleQuotes(query);
        System.debug('query: ' + query);
        return Database.query(query);
    }

    @RemoteAction
    public static Boolean getHasDetailsFromMember(String memberId) {
      if(!Schema.sObjectType.Invoice__c.isAccessible())
            throw new FieloPLT.FieloException('Insufficient permission to access invoices.');

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