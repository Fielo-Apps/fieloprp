
{
  "exportType" : "update",
  "configObjects" : [ {
    "apiName" : "fieloplt__library__c",
    "fieldsToExclude" : "fieloplt__resourceid__c"
  }, {
    "apiName" : "fieloplt__ruletrigger__c",
    "fieldsToExclude" : "fieloplt__prefix__c"
  }, {
    "apiName" : "fieloplt__action__c",
    "fieldsToExclude" : "fieloplt__rulesquantity__c,fieloplt__missionsquantity__c,fieloplt__criteriafields__c"
  } ],
  "migrationRecords" : [ {
    "objectAPIName" : "fieloplt__library__c",
    "records" : [ {
      "fieldsValues" : [ {
        "apiName" : "name",
        "value" : "FieloPRP"
      }, {
        "apiName" : "fieloplt__externalid__c",
        "value" : "FieloPRP"
      }, {
        "apiName" : "fieloplt__version__c",
        "value" : "1.011"
      } ],
      "relatedList" : [ {
        "objectAPIName" : "fieloplt__ruletrigger__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice"
          }, {
            "apiName" : "fieloplt__conditionfield__c",
            "value" : "FieloPRP__Status__c"
          }, {
            "apiName" : "fieloplt__conditiontype__c",
            "value" : "Text"
          }, {
            "apiName" : "fieloplt__conditionvalue__c",
            "value" : "Approved"
          }, {
            "apiName" : "fieloplt__date__c",
            "value" : "FieloPRP__ApprovedDate__c"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "Invoice"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__lookupfromemailalert__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__lookupfromtransaction__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__lookupfromtracker__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__action__c",
            "records" : [ {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Invoice > FieloPRP__Member__c"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "InvoiceFieloPRPMemberc"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "Invoice",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__targetemailfield__c",
                "value" : "FieloPRP__Member__r.FieloPLT__Email__c"
              }, {
                "apiName" : "fieloplt__targetemailobject__c",
                "value" : "FieloPLT__Member__c"
              }, {
                "apiName" : "fieloplt__targetmember__c",
                "value" : "FieloPRP__Member__c"
              }, {
                "apiName" : "fieloplt__templatesquantity__c",
                "value" : "0"
              } ],
              "relatedList" : [ {
                "objectAPIName" : "fieloplt__programassignment__c",
                "records" : [ ]
              } ]
            } ]
          }, {
            "objectAPIName" : "fieloplt__kpi__c",
            "records" : [ {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Sales - Program Total Revenue"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00D46000000bvJ0-a0p46000001bK7K"
              }, {
                "apiName" : "fieloplt__iscustom__c",
                "value" : "false"
              }, {
                "apiName" : "fieloplt__reportfilter__c",
                "value" : "[ { \"Report Field\" : \"FieloPRP__Invoice__c.FieloPRP__Program__c\", \"Operator\" : \"equals\", \"Record Field\": \"FieloPLT__Program__r.Id\" }, { \"Report Field\" : \"CUST_CREATED_DATE\", \"Operator\" : \"greaterOrEqual\", \"Record Field\" : \"FieloPLT__StartDate__c\" }, { \"Report Field\" : \"CUST_CREATED_DATE\", \"Operator\" : \"lessOrEqual\", \"Record Field\" : \"FieloPLT__EndDate__c\" }  ]"
              }, {
                "apiName" : "fieloplt__reportmetadata__c",
                "value" : "{\"size\":\"small\",\"styleClass\":\"\",\"cacheResults\":true,\"hideOnError\":false,\"rendered\":true,\"showRefreshButton\":true}"
              }, {
                "apiName" : "fieloplt__reportobjectivefield__c",
                "value" : "s!FieloPRP__Invoice__c.FieloPRP__Amount__c"
              }, {
                "apiName" : "fieloplt__reporttype__c",
                "value" : "Standard"
              }, {
                "apiName" : "fieloplt__reportuniquename__c",
                "value" : "fieloprp__ProgramRevenuePerMonth"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "Invoice",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__type__c",
                "value" : "Program"
              } ],
              "relatedList" : [ ]
            }, {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Sales - Promotion Revenue"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00D46000000bvJ0-a0p46000001bK6T"
              }, {
                "apiName" : "fieloplt__iscustom__c",
                "value" : "false"
              }, {
                "apiName" : "fieloplt__reportfilter__c",
                "value" : "[{ \"Report Field\" : \"FieloPRP__Invoice__c.FieloPRP__Status__c\", \"Operator\" : \"equals\", \"Value\" : \"Approved\" },{ \"Report Field\" : \"FieloPLT__Point__c.FieloPLT__Promotion__c\", \"Operator\" : \"equals\", \"Record Field\":\"FieloPLT__Promotion__r.Name\" }, { \"Report Field\" : \"FieloPRP__Invoice__c.CreatedDate\", \"Operator\" : \"greaterOrEqual\", \"Record Field\" : \"FieloPLT__StartDate__c\" }, { \"Report Field\" : \"FieloPRP__Invoice__c.CreatedDate\", \"Operator\" : \"lessOrEqual\", \"Record Field\" : \"FieloPLT__EndDate__c\" } ]"
              }, {
                "apiName" : "fieloplt__reportmetadata__c",
                "value" : "{\"size\":\"small\",\"styleClass\":\"\",\"cacheResults\":true,\"hideOnError\":false,\"rendered\":true,\"showRefreshButton\":true}"
              }, {
                "apiName" : "fieloplt__reportobjectivefield__c",
                "value" : "s!FieloPRP__Invoice__c.FieloPRP__Amount__c"
              }, {
                "apiName" : "fieloplt__reporttype__c",
                "value" : "Standard"
              }, {
                "apiName" : "fieloplt__reportuniquename__c",
                "value" : "fieloprp__PromotionRevenuePerMonth"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "Invoice",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__type__c",
                "value" : "Promotion"
              } ],
              "relatedList" : [ ]
            } ]
          } ]
        } ]
      }, {
        "objectAPIName" : "fieloplt__model__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "2 Points per Dollar"
          }, {
            "apiName" : "fieloplt__category__c",
            "value" : "Miscelaneas"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0K46000001Ouuq"
          }, {
            "apiName" : "fieloplt__icon__c",
            "value" : "fielosf-icon-content"
          }, {
            "apiName" : "fieloplt__json__c",
            "value" : "{  \"exportType\" : \"model\",  \"configObjects\" : [ {    \"apiName\" : \"fieloplt__promotion__c\",    \"fieldsToExclude\" : \"fieloplt__status__c\",    \"fieldsToExcludeModel\" : \"fieloplt__program__c\"  }, {    \"apiName\" : \"fieloplt__action__c\",    \"fieldsToExclude\" : \"fieloplt__rulesquantity__c,fieloplt__missionsquantity__c,fieloplt__criteriafields__c\"  } ],  \"migrationRecords\" : [ {    \"objectAPIName\" : \"fieloplt__promotion__c\",    \"records\" : [ {      \"fieldsValues\" : [ {        \"apiName\" : \"fieloplt__externalid__c\",        \"value\" : \"0\"      }, {        \"apiName\" : \"name\",        \"value\" : \"2 Points per Dollar\"      }, {        \"apiName\" : \"fieloplt__description__c\",        \"value\" : \"Earn 2 points per dollar\"      }, {        \"apiName\" : \"fieloplt__status__c\",        \"value\" : \"Active\"      } ],      \"relatedList\" : [ {        \"objectAPIName\" : \"fieloplt__rule__c\",        \"records\" : [ {          \"fieldsValues\" : [ {            \"apiName\" : \"fieloplt__externalid__c\",            \"value\" : \"1\"          }, {            \"apiName\" : \"name\",            \"value\" : \"2 Points per Dollar Rule\"          }, {            \"apiName\" : \"fieloplt__action__c.fieloplt__externalid__c\",            \"value\" : \"InvoiceFieloPRPMemberc\",            \"refObject\" : \"fieloplt__action__c\"          }, {            \"apiName\" : \"fieloplt__conversionvalue__c\",            \"value\" : \"2.00\"          }, {            \"apiName\" : \"fieloplt__logicalexpression__c\",            \"value\" : \"ALL\"          }, {            \"apiName\" : \"fieloplt__pointconversionmode__c\",            \"value\" : \"Multiplier\"          }, {            \"apiName\" : \"fieloplt__promotion__c.fieloplt__externalid__c\",            \"value\" : \"0\",            \"refObject\" : \"fieloplt__promotion__c\",            \"isFake\" : true          }, {            \"apiName\" : \"fieloplt__recordfieldname__c\",            \"value\" : \"FieloPRP__Amount__c\"          }, {            \"apiName\" : \"fieloplt__relatedlist__c\",            \"value\" : \"FieloPRP__Invoice__c\"          }, {            \"apiName\" : \"fieloplt__stockcontrol__c\",            \"value\" : \"false\"          }, {            \"apiName\" : \"fieloplt__type__c\",            \"value\" : \"Best Option\"          } ],          \"relatedList\" : [ {            \"objectAPIName\" : \"fieloplt__criterion__c\",            \"records\" : [ {              \"fieldsValues\" : [ {                \"apiName\" : \"fieloplt__externalid__c\",                \"value\" : \"2\"              }, {                \"apiName\" : \"fieloplt__booleanvalue__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__fieldname__c\",                \"value\" : \"FieloPRP__Status__c\"              }, {                \"apiName\" : \"fieloplt__fieldtype__c\",                \"value\" : \"List\"              }, {                \"apiName\" : \"fieloplt__isfield__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__operator__c\",                \"value\" : \"equals\"              }, {                \"apiName\" : \"fieloplt__order__c\",                \"value\" : \"1\"              }, {                \"apiName\" : \"fieloplt__rule__c.fieloplt__externalid__c\",                \"value\" : \"1\",                \"refObject\" : \"fieloplt__rule__c\",                \"isFake\" : true              }, {                \"apiName\" : \"fieloplt__values__c\",                \"value\" : \"Approved\"              }, {                \"apiName\" : \"fieloplt__description__c\",                \"value\" : \"FieloPRP__Status__c = Approved\"              } ],              \"relatedList\" : [ ]            } ]          } ]        } ]      }, {        \"objectAPIName\" : \"fieloplt__kpidomain__c\",        \"records\" : [ {          \"fieldsValues\" : [ {            \"apiName\" : \"fieloplt__externalid__c\",            \"value\" : \"3\"          }, {            \"apiName\" : \"fieloplt__kpi__c.fieloplt__externalid__c\",            \"value\" : \"00D46000000bvJ0-a0p46000001bK6T\",            \"refObject\" : \"fieloplt__kpi__c\"          }, {            \"apiName\" : \"fieloplt__promotion__c.fieloplt__externalid__c\",            \"value\" : \"0\",            \"refObject\" : \"fieloplt__promotion__c\",            \"isFake\" : true          }, {            \"apiName\" : \"fieloplt__snapshot__c\",            \"value\" : \"false\"          }, {            \"apiName\" : \"fieloplt__unique__c\",            \"value\" : \"a0p46000001bK6T_a0Q46000003Ns9Y\"          } ],          \"relatedList\" : [ ]        } ]      } ]    } ]  } ],  \"segmentsCombinations\" : [ ]}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Promotion"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Sales"
          }, {
            "apiName" : "fieloplt__category__c",
            "value" : "Miscelaneas"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0K46000001Ouuv"
          }, {
            "apiName" : "fieloplt__icon__c",
            "value" : "fielosf-icon-content"
          }, {
            "apiName" : "fieloplt__json__c",
            "value" : "{  \"exportType\" : \"model\",  \"configObjects\" : [ {    \"apiName\" : \"fieloplt__promotion__c\",    \"fieldsToExclude\" : \"fieloplt__status__c\",    \"fieldsToExcludeModel\" : \"fieloplt__program__c\"  }, {    \"apiName\" : \"fieloplt__action__c\",    \"fieldsToExclude\" : \"fieloplt__rulesquantity__c,fieloplt__missionsquantity__c,fieloplt__criteriafields__c\"  } ],  \"migrationRecords\" : [ {    \"objectAPIName\" : \"fieloplt__promotion__c\",    \"records\" : [ {      \"fieldsValues\" : [ {        \"apiName\" : \"fieloplt__externalid__c\",        \"value\" : \"0\"      }, {        \"apiName\" : \"name\",        \"value\" : \"Sales\"      }, {        \"apiName\" : \"fieloplt__status__c\",        \"value\" : \"Draft\"      } ],      \"relatedList\" : [ {        \"objectAPIName\" : \"fieloplt__rule__c\",        \"records\" : [ {          \"fieldsValues\" : [ {            \"apiName\" : \"fieloplt__externalid__c\",            \"value\" : \"1\"          }, {            \"apiName\" : \"name\",            \"value\" : \"Purchase Rule\"          }, {            \"apiName\" : \"fieloplt__action__c.fieloplt__externalid__c\",            \"value\" : \"InvoiceFieloPRPMemberc\",            \"refObject\" : \"fieloplt__action__c\"          }, {            \"apiName\" : \"fieloplt__conversionvalue__c\",            \"value\" : \"1.00\"          }, {            \"apiName\" : \"fieloplt__logicalexpression__c\",            \"value\" : \"ALL\"          }, {            \"apiName\" : \"fieloplt__pointconversionmode__c\",            \"value\" : \"Multiplier\"          }, {            \"apiName\" : \"fieloplt__promotion__c.fieloplt__externalid__c\",            \"value\" : \"0\",            \"refObject\" : \"fieloplt__promotion__c\",            \"isFake\" : true          }, {            \"apiName\" : \"fieloplt__recordfieldname__c\",            \"value\" : \"FieloPRP__Amount__c\"          }, {            \"apiName\" : \"fieloplt__relatedlist__c\",            \"value\" : \"FieloPRP__Invoice__c\"          }, {            \"apiName\" : \"fieloplt__stockcontrol__c\",            \"value\" : \"false\"          }, {            \"apiName\" : \"fieloplt__type__c\",            \"value\" : \"Best Option\"          } ],          \"relatedList\" : [ {            \"objectAPIName\" : \"fieloplt__criterion__c\",            \"records\" : [ {              \"fieldsValues\" : [ {                \"apiName\" : \"fieloplt__externalid__c\",                \"value\" : \"2\"              }, {                \"apiName\" : \"fieloplt__booleanvalue__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__fieldname__c\",                \"value\" : \"FieloPRP__Status__c\"              }, {                \"apiName\" : \"fieloplt__fieldtype__c\",                \"value\" : \"List\"              }, {                \"apiName\" : \"fieloplt__isfield__c\",                \"value\" : \"false\"              }, {                \"apiName\" : \"fieloplt__operator__c\",                \"value\" : \"equals\"              }, {                \"apiName\" : \"fieloplt__order__c\",                \"value\" : \"1\"              }, {                \"apiName\" : \"fieloplt__rule__c.fieloplt__externalid__c\",                \"value\" : \"1\",                \"refObject\" : \"fieloplt__rule__c\",                \"isFake\" : true              }, {                \"apiName\" : \"fieloplt__values__c\",                \"value\" : \"Approved\"              }, {                \"apiName\" : \"fieloplt__description__c\",                \"value\" : \"FieloPRP__Status__c = Approved\"              } ],              \"relatedList\" : [ ]            } ]          } ]        } ]      }, {        \"objectAPIName\" : \"fieloplt__kpidomain__c\",        \"records\" : [ ]      } ]    } ]  } ],  \"segmentsCombinations\" : [ ]}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Promotion"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        } ]
      }, {
        "objectAPIName" : "fieloplt__pagesettings__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > Edit"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Ked"
          }, {
            "apiName" : "fieloplt__filters__c",
            "value" : "[{'Rows':[[{'Name':'Name', 'Type':'input'},{'Name':'Family','Type':'picklist'},{'Name':'ProductCode','Type':'input'}]]}]"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__sections__c",
            "value" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Member__c\",\"Type\":\"lookup\"},\r\n\t\t\t{\"Name\":\"FieloPRP__HasDetails__c\",\"Type\":\"checkbox\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__InvoiceNumber__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Amount__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloPRP__Date__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Description__c\",\"Type\":\"input\"}\r\n\t\t\t,{\"Name\":\"FieloPRP__Distributor__c\",\"Type\":\"lookup\"}\r\n\t\t]\r\n\t],\r\n\t\"FieloPRP_Product\":[\r\n\t\t[\r\n\t\t\t{\"Name\":\"Name\", \"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"Family\",\"Type\":\"picklist\"},\r\n\t\t\t{\"Name\":\"ProductCode\",\"Type\":\"input\"}\r\n\t\t]\r\n\t],\r\n\t\"FieloPRP_ProductRecent\": [\r\n\t\t[\r\n\t\t\t{\"Name\":\"Name\", \"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"Family\",\"Type\":\"picklist\"},\r\n\t\t\t{\"Name\":\"ProductCode\",\"Type\":\"input\"}\r\n\t\t]\r\n\t],\r\n\t\"FieloPRP_InvoiceItems\": [\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Quantity__c\", \"Type\":\"input\", \"ClassName\": \"fielosf-product_qty\", \"onchange\": \"refreshTotalPriceProxy_\"},\r\n\t\t\t{\"Name\":\"FieloPRP__Product__c\", \"Type\":\"lookup\", \"ClassName\": \"fielosf-product_name\", \"onchange\": \"refreshTotalPriceProxy_\"},\r\n\t\t\t{\"Name\":\"FieloPRP__UnitPrice__c\", \"Type\": \"input\", \"ClassName\": \"fielosf-product_unit-price\", \"onchange\": \"refreshTotalPriceProxy_\"},\r\n\t\t\t{\"Name\":\"FieloPRP__TotalPrice__c\", \"Type\": \"input\", \"ClassName\": \"fielosf-product_total-price\", \"onchange\": \"refreshTotalPriceProxy_\"}\r\n\t\t]\r\n\t]\r\n}"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "Settings"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Edit"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > Edit (Copy)"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D460000013Gun-a0Q460000038gb8"
          }, {
            "apiName" : "fieloplt__filters__c",
            "value" : "[{'Rows':[[{'Name':'Name', 'Type':'input'},{'Name':'Family','Type':'picklist'},{'Name':'ProductCode','Type':'input'}]]}]"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__sections__c",
            "value" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Member__c\",\"Type\":\"lookup\"},\r\n\t\t\t{\"Name\":\"FieloPRP__HasDetails__c\",\"Type\":\"checkbox\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__InvoiceNumber__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Amount__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloPRP__Date__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Description__c\",\"Type\":\"input\"}\r\n\t\t\t,{\"Name\":\"FieloPRP__Distributor__c\",\"Type\":\"lookup\"}\r\n\t\t]\r\n\t]\r\n}"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "Settings"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Edit"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > Landing"
          }, {
            "apiName" : "fieloplt__buttons__c",
            "value" : "{\"Label\": \"New\", \"Type\": \"Modal\", \"Action\": \"invoiceForm\" }"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Kef"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"FieloPRP__Member__r.Name\"},{\"Name\":\"FieloPRP__Status__c\"},{\"Name\":\"FieloPRP__Amount__c\"}"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "Settings"
          }, {
            "apiName" : "fieloplt__tools__c",
            "value" : "{\"Label\": \"Products\", \"Type\": \"Link\", \"Action\": \"/01t\" }"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Landing"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > New"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012KeY"
          }, {
            "apiName" : "fieloplt__filters__c",
            "value" : "[{'Rows':[[{'Name':'Name', 'Type':'input'},{'Name':'Family','Type':'picklist'},{'Name':'ProductCode','Type':'input'}]]}]"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__sections__c",
            "value" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Member__c\",\"Type\":\"lookup\"},\r\n\t\t\t{\"Name\":\"FieloPRP__HasDetails__c\",\"Type\":\"checkbox\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__InvoiceNumber__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Amount__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloPRP__Date__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Description__c\",\"Type\":\"input\"}\r\n\t\t\t,{\"Name\":\"FieloPRP__Distributor__c\",\"Type\":\"lookup\"}\r\n\t\t]\r\n\t],\r\n\t\"FieloPRP_Product\":[\r\n\t\t[\r\n\t\t\t{\"Name\":\"Name\", \"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"Family\",\"Type\":\"picklist\"},\r\n\t\t\t{\"Name\":\"ProductCode\",\"Type\":\"input\"}\r\n\t\t]\r\n\t],\r\n\t\"FieloPRP_ProductRecent\": [\r\n\t\t[\r\n\t\t\t{\"Name\":\"Name\", \"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"Family\",\"Type\":\"picklist\"},\r\n\t\t\t{\"Name\":\"ProductCode\",\"Type\":\"input\"}\r\n\t\t]\r\n\t],\r\n\t\"FieloPRP_InvoiceItems\": [\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloPRP__Quantity__c\", \"Type\":\"input\", \"ClassName\": \"fielosf-product_qty\", \"onchange\": \"refreshTotalPriceProxy_\"},\r\n\t\t\t{\"Name\":\"FieloPRP__Product__c\", \"Type\":\"lookup\", \"ClassName\": \"fielosf-product_name\", \"onchange\": \"refreshTotalPriceProxy_\"},\r\n\t\t\t{\"Name\":\"FieloPRP__UnitPrice__c\", \"Type\": \"input\", \"ClassName\": \"fielosf-product_unit-price\", \"onchange\": \"refreshTotalPriceProxy_\"},\r\n\t\t\t{\"Name\":\"FieloPRP__TotalPrice__c\", \"Type\": \"input\", \"ClassName\": \"fielosf-product_total-price\", \"onchange\": \"refreshTotalPriceProxy_\"}\r\n\t\t]\r\n\t]\r\n}"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "Settings"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "New"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > Related > Invoice Item"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012KeW"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"FieloPRP__Product__r.Name\"},\r\n{\"Name\":\"FieloPRP__Quantity__c\"},\r\n{\"Name\":\"FieloPRP__UnitPrice__c\"},\r\n{\"Name\":\"FieloPRP__TotalPrice__c\"}"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "0"
          }, {
            "apiName" : "fieloplt__targetfield__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__targetobject__c",
            "value" : "FieloPRP__InvoiceItem__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Related"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > Related > Transaction"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012KeX"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\": \"FieloPLT__IsProcessed__c\"},\r\n{\"Name\": \"FieloPLT__Value__c\"},\r\n{\"Name\": \"FieloPLT__Points__c\"},\r\n{\"Name\": \"FieloPLT__IsReverted__c\"},\r\n{\"Name\": \"CreatedDate\"}"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "1"
          }, {
            "apiName" : "fieloplt__targetfield__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__targetobject__c",
            "value" : "FieloPLT__Transaction__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Related"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > View"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Kee"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"FieloPRP__Status__c\"},\r\n{\"Name\":\"FieloPRP__InvoiceNumber__c\"},\r\n{\"Name\":\"FieloPRP__Distributor__r.Name\"},\r\n{\"Name\":\"FieloPRP__Member__r.Name\"},\r\n{\"Name\":\"FieloPRP__Amount__c\"},\r\n{\"Name\":\"FieloPRP__Date__c\"},\r\n{\"Name\":\"FieloPRP__Comments__c\"}"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__standardactions__c",
            "value" : "View;Settings"
          }, {
            "apiName" : "fieloplt__standardrelated__c",
            "value" : "ProcessSteps;CombinedAttachments;ImageGallery"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "View"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > View (Reopen)"
          }, {
            "apiName" : "fieloplt__buttons__c",
            "value" : "{\"Label\":\"Reopen\",\"Type\":\"Remote\",\"Action\":\"InvoiceButtonImpl\",\"Confirm\":true,\"Reflection\":true,\"parameters\":\"{\\\"type\\\":\\\"Reopen\\\"}\"}"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Kej"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "View"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[ \r\n{\"field\":\"FieloPRP__Status__c\", \r\n\"value\":\"Rejected\"}\r\n]"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > View (Reopen/Reprocess)"
          }, {
            "apiName" : "fieloplt__buttons__c",
            "value" : "{\"Label\":\"Reopen\",\"Type\":\"Remote\",\"Action\":\"InvoiceButtonImpl\",\"Confirm\":true,\"Reflection\":true,\"parameters\":\"{\\\"type\\\":\\\"Reopen\\\"}\"},\r\n{\"Label\":\"Reprocess\",\"Type\":\"Remote\",\"Action\":\"InvoiceButtonImpl\",\"Confirm\":true,\"Reflection\":true,\"parameters\":\"{\\\"type\\\":\\\"Approve\\\"}\"}"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Keh"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "View"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[\r\n{\"field\":\"FieloPRP__Status__c\", \r\n\"value\":\"Canceled\"}\r\n]"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice > View (Revert/Reprocess)"
          }, {
            "apiName" : "fieloplt__buttons__c",
            "value" : "{\"Label\":\"Revert\",\"Type\":\"Remote\",\"Action\":\"InvoiceButtonImpl\",\"Confirm\":true,\"Reflection\":true,\"parameters\":\"{\\\"type\\\":\\\"Cancel\\\"}\"},\r\n{\"Label\":\"Reprocess\",\"Type\":\"Remote\",\"Action\":\"InvoiceButtonImpl\",\"Confirm\":true,\"Reflection\":true,\"parameters\":\"{\\\"type\\\":\\\"Reprocess\\\"}\"}"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Kek"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "View"
          }, {
            "apiName" : "fieloplt__visibility__c",
            "value" : "[ \r\n{\"field\":\"FieloPRP__Status__c\", \r\n\"value\":\"Approved\"}\r\n]"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Invoice Item > Lookup"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D460000013Gun-a0Q460000038gTj"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"FieloPRP__Quantity__c\", \"Type\":\"input\", \"ClassName\": \"fielosf-product_qty\", \"onchange\": \"refreshTotalPriceProxy_\"}, \r\n{\"Name\":\"FieloPRP__Product__c\", \"Type\":\"lookup\", \"ClassName\": \"fielosf-product_name\", \"onchange\": \"refreshTotalPriceProxy_\"}, \r\n{\"Name\":\"FieloPRP__UnitPrice__c\", \"Type\": \"input\", \"ClassName\": \"fielosf-product_unit-price\", \"onchange\": \"refreshTotalPriceProxy_\"}, \r\n{\"Name\":\"FieloPRP__TotalPrice__c\", \"Type\": \"input\", \"ClassName\": \"fielosf-product_total-price\", \"onchange\": \"refreshTotalPriceProxy_\"}"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Lookup"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Member > Related > Invoice"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Keb"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{ \"Name\" : \"FieloPRP__Status__c\" },\r\n\t{ \"Name\" : \"FieloPRP__Amount__c\" },\r\n        { \"Name\" : \"FieloPRP__Date__c\" }"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPLT__Member__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "2"
          }, {
            "apiName" : "fieloplt__targetfield__c",
            "value" : "FieloPRP__Member__c"
          }, {
            "apiName" : "fieloplt__targetobject__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Related"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Product Recent > Lookup"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D460000013Gun-a0Q460000038gTe"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"Name\", \"Type\":\"input\"}, \r\n{\"Name\":\"Family\",\"Type\":\"picklist\"}, \r\n{\"Name\":\"ProductCode\",\"Type\":\"input\"}"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Lookup"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Products > Lookup"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D460000013Gun-a0Q460000038gTZ"
          }, {
            "apiName" : "fieloplt__fieldset__c",
            "value" : "{\"Name\":\"Name\", \"Type\":\"input\"}, \r\n{\"Name\":\"Family\",\"Type\":\"picklist\"}, \r\n{\"Name\":\"ProductCode\",\"Type\":\"input\"}"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPRP__Invoice__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Lookup"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Program > Detail"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Kec"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPLT__Program__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "2"
          }, {
            "apiName" : "fieloplt__sections__c",
            "value" : "{\"Name\" : \"Invoice Settings\",\r\n\t\"Rows\" :[\r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceAuthorization__c\" , \"Type\" : \"input\" },\r\n            {\"Name\" : \"FieloPRP__RequestInvoiceProducts__c\" , \"Type\" : \"input\" },\r\n\t\t\t{\"Name\" : \"FieloPRP__ProductInjectQuery__c\" , \"Type\" : \"input\" }\r\n\t\t]\r\n\t]\r\n}"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Detail"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Program > Edit"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012KeZ"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPLT__Program__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "2"
          }, {
            "apiName" : "fieloplt__sections__c",
            "value" : "{\"Name\" : \"Invoice Settings\", \r\n\t\"Rows\" :[ \r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceAuthorization__c\" , \"Type\" : \"checkbox\" }, \r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceProducts__c\" , \"Type\" : \"checkbox\" }\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__ProductInjectQuery__c\" , \"Type\" : \"input\" }\r\n\t\t] \r\n\t] \r\n}"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Edit"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Program > New"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D46000000bvJ0-a0g460000012Kea"
          }, {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__iscustom__c",
            "value" : "false"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloPRP",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloPLT__Program__c"
          }, {
            "apiName" : "fieloplt__order__c",
            "value" : "2"
          }, {
            "apiName" : "fieloplt__sections__c",
            "value" : "{\"Name\" : \"Invoice Settings\", \r\n\t\"Rows\" :[ \r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceAuthorization__c\" , \"Type\" : \"checkbox\" }, \r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceProducts__c\" , \"Type\" : \"checkbox\" }\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__ProductInjectQuery__c\" , \"Type\" : \"input\" }\r\n\t\t] \r\n\t] \r\n}"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "New"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        } ]
      } ]
    } ]
  } ],
  "segmentsCombinations" : [ ]
}