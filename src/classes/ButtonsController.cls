public with sharing class ButtonsController {

    public String cParameters{get;set;}
    public String cRecordId{get;set;}

    @remoteAction
    public static FieloPLT.RemoteActionResult executeAction(String recordIds, String className, String parameters){
      Type t = Type.forName(className);
      FieloPLT.ButtonActionInterface reflectionInstance = (FieloPLT.ButtonActionInterface)t.newInstance();
      return reflectionInstance.executeAction(recordIds.split(','), parameters);
    }

    public String parametersForJSON { get {
      if ( parametersForJSON == null) {

        if ( String.isBlank(cRecordId ) ) {
          parametersForJSON = cParameters.replace('\'','"');
        } else {
          parametersForJSON = '{"Id": "' + cRecordId + '"}';
          if ( !String.isBlank(cParameters) ) {
            parametersForJSON += ',' + cParameters.replace('\'','"');
          }
        }
      }
      return parametersForJSON;
    } set;}

    public String getParametersString() {
      String queryString = String.isBlank(cRecordId ) ? '' : '&id=' + cRecordId;

      if ( !String.isBlank(cParameters) ) {

        cParameters = cParameters.replace('\'', '"');
        try { 
          Map<String,Object> p = (Map<String,Object>) JSON.deserializeUntyped(cParameters );
          for ( String key: p.keySet()){
            queryString += '&' + key + '=' + p.get(key);
          }
        } catch( JSONException e ) {
            system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + cParameters );        
        }
      }
      return queryString;
    }

  
  /***** Buttons & Toolbar ******/  
  public class Button {
    public String Icon{get;set;}
    public String Type{get;set;}
    public String Label{get;set;}
    public String ObjectName{get;set;}
    public String Action{get;set;}
    public String CssClass{get;set;} 
    public String Parameters{get;set;}    
    public Boolean Confirm{get;set;}
    public Boolean reflection{get{if(reflection == null) reflection = false; return reflection;}set;}
    public String cRecordId {get;set;}

    public String getUrl () {
      return this.Action.startsWith('/') ? System.URL.getSalesforceBaseUrl().toExternalForm() + this.Action : this.Action;
    }

    public String getParametersForJSON() {
        if(this.reflection != null && this.reflection){
          Map<String,Object> parametersMap;
          if(this.Parameters != null){
            parametersMap = (Map<String,Object>)JSON.deserializeUntyped(this.Parameters);
          } 
          parametersMap.put('Id',this.cRecordId);
          return JSON.serialize(parametersMap).replace('\'','"');
        }else{
          return this.Parameters.replace('\'','"');  
        }
    }

    public String getParametersString() {
      String queryString = '';
      if ( !String.isBlank(Parameters) ) {
        try {        
          Map<String,String> p = (Map<String,String>) JSON.deserializeUntyped(Parameters);
          for ( String key: p.keySet()){
            queryString += '&' + key + '=' + p.get(key);
          }
        } catch( JSONException e ) {
            system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + Parameters );        
        }          
      }
      return queryString;
    }

  }

  public String cButtonsString {get;set;}
  public List<Button> cButtons { get {
      if ( cButtons == null && !String.isBlank(cButtonsString)  ) {
        // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
        if ( !cButtonsString.startsWith('[') ) {
          cButtonsString = '[' + cButtonsString.replace('\'', '"') + ']';
        }
        try {
          cButtons = (List<ButtonsController.Button>) JSON.deserialize( cButtonsString , List<ButtonsController.Button>.class );
          if(cRecordId != null){
            for(ButtonsController.Button button : cButtons){
              button.cRecordId = this.cRecordId;
            }
          }
        } catch( JSONException e ) {
            system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + cButtonsString );        
        }          
      }
      return cButtons;
    } set;
  }

  public String cToolsString {get;set;}
  public List<Button> cTools { get {
      if ( cTools == null && !String.isBlank(cToolsString)  ) {
        // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
        if ( !cToolsString.startsWith('[') ) {
          cToolsString = '[' + cToolsString.replace('\'', '"') + ']';
        }
        try {
          cTools = (List<ButtonsController.Button>) JSON.deserialize( cToolsString, List<ButtonsController.Button>.class );
        } catch( JSONException e ) {
            system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + cToolsString );        
        }
      }
      return cTools;
    } set;
  }
}
