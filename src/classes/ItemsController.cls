public with sharing class ItemsController {
  /*****  Data  *****/
  public String cFieldset{get;set;}

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
                sections = (List<Section>) JSON.deserialize( cFieldset, List<Section>.class );
            } else {
                sections = new List<Section>();
            }
        }
        return sections;
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

}