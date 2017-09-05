(function() {
  'use strict';

  var FieloFormInvoice = function FieloFormInvoice(element) {
    this.element_ = element;
    // Initialize instance.
    this.init();
  };
  window.FieloFormInvoice = FieloFormInvoice;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloFormInvoice.prototype.Constant_ = {
    SAVE_CONTROLLER: 'FieloPRP.FormInvoiceController.save',
    RETRIEVE_CONTROLLER: 'data-retrieve-controller',
    GET_PROGRAM_CONTROLLER: 'FieloPRP.FormInvoiceController.getActiveProgram',
    MEMBER: 'FieloPRP__Member__c',
    PRODUCT_RECENT: 'recentProductRecords',
    DATA_RECORD_ID: 'data-record-id',
    OBJECT_NAME: 'data-object-name',
    FIELDS: 'data-fields',
    FIELD_NAME: 'data-field-name',
    REDIRECT: 'data-redirect',
    PRODUCT_FIELD: 'data-product-field-name'

  };

  /**
   * Guarda strings para nombres de clases definidas poPr este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloFormInvoice.prototype.CssClasses_ = {
    CONTAINER: 'slds-form-element',
    ITEMS_CONTAINER: 'fielosf-invoice-items',
    SAVE: 'slds-form__save',
    CANCEL: 'slds-form__cancel',
    DELETE: 'slds-button--delete',
    NEW: 'slds-button--new',
    ELEMENT: 'slds-form-element',
    INVOICE_ITEM: 'fielosf-invoice__item',
    ADD_PRODUCTS: 'slds-button--addproducts',
    PRODUCT_QTY: 'fielosf-product_qty',
    PRODUCT_UNIT_PRICE: 'fielosf-product_unit-price',
    PRODUCT_TOTAL_PRICE: 'fielosf-product_total-price',
    PRODUCT_NAME: 'fielosf-product_name',
    PRODUCT_FORM: 'fielosf-invoice-form-addproducts',
    PRODUCT_ADD: 'slds-form-product__add',
    PRODUCT_CANCEL: 'slds-form-product__cancel',
    PRODUCT_SEARCH: 'slds-form-product__search',
    RECENT_RECORDS: 'fielosf-recent-records__model',
    RECENT_CHECKBOX: 'fielosf-recent-records-checkbox',
    LOOKUP_PILL: 'slds-pill_container',
    SHOW: 'slds-show',
    INVOICE_AMOUNT: 'fielosf-invoice_amount',
    TOTAL_POINTS: 'fielosf-total_points',
    FILE_UPLOADER: 'fielosf-multi-file-uploader',
    NEW_FILE_BUTTON: 'slds-file-selector__button',
    BUTTON_ICON: 'slds-button__icon',
    PILL_LABEL: 'slds-pill__label',
    INPUT: 'slds-input'

  };

  FieloFormInvoice.prototype.submitForm = function() {
    this.saveRecord_ = true;
    var memberId = this.element_
      .querySelector('[data-field-name="' + this.Constant_.MEMBER + '"]')
        .FieloFormElement.get('value');
    this.getHasDetails(memberId);
  };

  /**
   * Envía el formulario
   */
  FieloFormInvoice.prototype.save_ = function() {
    fielo.util.spinner.FieloSpinner.show();
    var memberValue = this.element_
      .querySelector('[data-field-name="' + this.Constant_.MEMBER + '"]')
        .FieloFormElement.get('value');
    var hasDetails = '';
    var event = '';
    var nullFields = [];
    if (memberValue) {
      hasDetails = this.element_
        .querySelector('[data-field-name="FieloPRP__HasDetails__c"]')
          .FieloFormElement.get('value');
      fielo.util.spinner.FieloSpinner.show();
      var formValues = this.getValues_();
      if (formValues.Id === '') {
        delete formValues.Id;
      }
      if (formValues.FieloPRP__Date__c === '' ||
        formValues.FieloPRP__Date__c === null ||
        formValues.FieloPRP__Date__c === undefined) {
        delete formValues.FieloPRP__Date__c;
        nullFields.push('FieloPRP__Date__c');
      }
      var itemValues =
        this.itemsContainer_.FieloInvoiceItems.get();

      if (hasDetails) {
        if (formValues.FieloPRP__Amount__c !== null &&
            formValues.FieloPRP__Amount__c !== undefined) {
          delete formValues.FieloPRP__Amount__c;
        }
      }

      try {
        Visualforce.remoting.Manager.invokeAction(
          this.Constant_.SAVE_CONTROLLER,
          formValues,
          hasDetails ? itemValues : null,
          nullFields,
          this.saveCallback_.bind(this),
          {
            escape: false
          }
        );
      } catch (e) {
        console.warn(e);
      }
    } else {
      event = {message: BackEndJSSettings.LABELS.MemberMustBeChosen,
        redirectURL: '#'};
      this.form_.processRemoteActionResult_(null, event);
    }
    this.keepItems_ = false;
  };

  FieloFormInvoice.prototype.saveCallback_ = function(result, event) {
    var fileList = this.element_
      .getElementsByClassName(this.CssClasses_.FILE_UPLOADER)[0]
        .FieloMultiFileUploaderPRP.fileList;
    var deleteFilesList = this.element_
      .getElementsByClassName(this.CssClasses_.FILE_UPLOADER)[0]
        .FieloMultiFileUploaderPRP.deleteList;
    this.hasAttachments = fileList ?
      Object.keys(fileList).length > 0 :
      false;
    this.hasDeletedAttachments = deleteFilesList ?
      deleteFilesList.length > 0 :
      false;
    console.log(result);
    if (result.redirectURL === null || result.redirectURL === undefined) {
      this.form_.processRemoteActionResult_(result, event);
    } else if (this.hasAttachments || this.hasDeletedAttachments) {
      var invoiceId = result.redirectURL.substring(1,
        result.redirectURL.length);
      this.element_.getElementsByClassName(this.CssClasses_.FILE_UPLOADER)[0]
        .FieloMultiFileUploaderPRP.uploadFile(invoiceId);
    } else {
      this.form_.processRemoteActionResult_(result, event);
    }
  };

  FieloFormInvoice.prototype.getValues_ = function() {
    this.form_.elements_ = [];
    var invoiceValues = {};
    // invoiceValues.sObjectType =
    //  this.form_.element_.getAttribute(this.form_.Constant_.OBJECT_NAME);

    [].forEach.call(this.invoiceElements_, function(element) {
      if (element.FieloFormElement.get('fieldName') !== '') {
        var property = element.FieloFormElement.get('fieldName');
        if (property) {
          this.form_.elements_[property] = element;
          invoiceValues[property] = element.FieloFormElement.get('value');
        }
      }
    }, this);
    return invoiceValues;
  };

  FieloFormInvoice.prototype.setValues_ = function() {
    return this.itemsContainer_.FieloInvoiceItems.set();
  };

  FieloFormInvoice.prototype.clear_ = function() {
    if (!this.keepItems_) {
      this.disableMemberValidation = true;
      [].forEach.call(this.invoiceElements_, function(item) {
        item.FieloFormElement.clear();
      });
      this.element_.getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)[0]
        .FieloInvoiceItems.clear();
      this.initItem_(
        this.element_.getElementsByClassName(
          this.CssClasses_.ITEMS_CONTAINER)[0]);
      this.element_.getElementsByClassName(this.CssClasses_.FILE_UPLOADER)[0]
        .FieloMultiFileUploaderPRP.clearPills();
      this.disableMemberValidation = false;
    }
  };

  FieloFormInvoice.prototype.setProductsFilter_ = function() {
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    this.productPaginator_ =
      this.productRecent_.FieloRecentRecords.getPaginator(
        ).FieloPaginator;
    this.productFilter = [];

    this.productFilter.IsActive = true;
    this.productPaginator_.setFilters(
        this.productFilter);
  };

  /**
   * Reload Reward Recent Records
   */
  FieloFormInvoice.prototype.reloadproductRecent_ = function() {
    this.keepItems_ = true;
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    if (this.productRecent_ !== null && this.productRecent_ !== undefined) {
      this.resetSearch_();
      this.setProductsFilter_();
      this.recentPaginator_ =
        this.productRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
      this.recentPaginator_.setPage();
      this.recentPaginator_.getRecords();
    }
  };

  FieloFormInvoice.prototype.resetSearch_ = function() {
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    if (this.productRecent_ !== null && this.productRecent_ !== undefined) {
      this.searchFields_ = this.productForm_.getElementsByClassName(
        this.CssClasses_.ELEMENT);
      this.newFilters_ = [];
      [].forEach.call(this.searchFields_, function(element) {
        this.filterField_ = element.FieloFormElement;
        this.productPaginator_ =
          this.productRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
        delete this.productPaginator_.getFilters()[
            this.filterField_.get('fieldName')];
      },
      this
      );
      this.productPaginator_.setFilters(this.newFilters_);
    }
  };

  /**
   * Execute Search
   */
  FieloFormInvoice.prototype.searchRecords_ = function() {
    this.productRecent_ = document.getElementById(
      this.Constant_.PRODUCT_RECENT);
    if (this.productRecent_ !== null && this.productRecent_ !== undefined) {
      this.searchFields_ = this.productForm_.getElementsByClassName(
        this.CssClasses_.ELEMENT);
      this.newFilters_ = [];

      [].forEach.call(this.searchFields_, function(element) {
        this.filterField_ = element.FieloFormElement;
        this.productPaginator_ =
          this.productRecent_.FieloRecentRecords.getPaginator().FieloPaginator;
        if (this.filterField_.get('value') !== '' &&
          this.filterField_.get('value') !== null &&
          this.filterField_.get('value') !== undefined) {
          if (this.filterField_.get('type') === 'input-double') {
            this.newFilters_[
              this.filterField_.get('fieldName')] =
              parseFloat(this.filterField_.get('value'));
          } else {
            this.newFilters_[
              this.filterField_.get('fieldName')] =
              this.filterField_.get('value');
          }
        } else {
          delete this.productPaginator_.getFilters()[
            this.filterField_.get('fieldName')];
        }
      },
      this
      );
      this.productPaginator_.setFilters(this.newFilters_);
      this.productPaginator_.setPage();
      this.productPaginator_.getRecords();
    }
  };

  FieloFormInvoice.prototype.resetKeepItems = function() {
    this.keepItems_ = false;
  };

  FieloFormInvoice.prototype.showItems_ = function() {
    if (this.memberField_.FieloFormElement.get('value') === null ||
      this.memberField_.FieloFormElement.get('value') === undefined) {
      $(this.element_.getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)
        ).addClass('slds-hide');
    } else {
      $(this.element_.getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)
        ).removeClass('slds-hide');
    }
  };

  FieloFormInvoice.prototype.initItem_ = function(element) {
    this.elementFields = element.getElementsByClassName(
          this.CssClasses_.ELEMENT);

    [].forEach.call(this.elementFields, function(field) {
      field.addEventListener('change', this.refreshTotalPriceProxy_.bind(this));
      componentHandler.upgradeElement(field);
    },
      this
    );
    $('[data-field-name="' + this.productField + '"]')
      .find('#invoiceForm--input')
      .keypress(this.protectProductField_.bind(this));
  };

  FieloFormInvoice.prototype.protectProductField_ = function(event) {
    if ($('[data-field-name="FieloPRP__Member__c"]')[0]
        .FieloFormElement.get('value') === '') {
      $('[data-field-name="' + this.productField + '"]')
      .find('#invoiceForm--input').blur();
    }
    this.verifyMember_(event);
  };

  FieloFormInvoice.prototype.initNewItem = function() {
    this.invoiceItems =
      this.element_.getElementsByClassName(
        this.CssClasses_.INVOICE_ITEM);
    this.lastInvoiceItem =
      this.invoiceItems[this.invoiceItems.length - 1];
    this.initItem_(this.lastInvoiceItem);
  };

  FieloFormInvoice.prototype.updateProductBasket = function() {
    this.recentProductRecords_ =
      this.productForm_.getElementsByClassName(this.CssClasses_.RECENT_RECORDS);
    this.productsInfo_ = [];

    [].forEach.call(this.recentProductRecords_, function(element) {
      this.recordCheckbox =
        element.getElementsByClassName(
          this.CssClasses_.RECENT_CHECKBOX)[0];
      if (this.recordCheckbox.checked === true) {
        this.productsInfo_.push(element.getAttribute(
            this.Constant_.DATA_RECORD_ID));
      }
    },
      this
    );

    this.invoiceItems_ = this.element_.getElementsByClassName(
      this.CssClasses_.ITEMS_CONTAINER)[0];

    this.getEmptyInvoiceItems();

    [].forEach.call(this.productsInfo_, function(productId) {
      if (productId !== null &&
        productId !== undefined) {
        if (this.availableSlots.length > 0) {
          this.lastInvoiceItem = this.availableSlots.pop();
        } else {
          this.invoiceContainerItems_ = this.element_.getElementsByClassName(
          this.CssClasses_.ITEMS_CONTAINER)[0];
          // todo: discover a new way to create redemption items, or turn the
          // the method into a public method
          this.invoiceContainerItems_.FieloInvoiceItems.newinvoiceItem_();
          this.invoiceItems_ =
            this.element_.getElementsByClassName(
              this.CssClasses_.INVOICE_ITEM);
          this.lastInvoiceItem =
            this.invoiceItems_[this.invoiceItems_.length - 1];
        }
        this.initItem_(this.lastInvoiceItem);
        this.elementFields = this.lastInvoiceItem.getElementsByClassName(
          this.CssClasses_.ELEMENT);

        $(this.lastInvoiceItem).find(
            $('[data-field-name="' + this.productField + '"]')
            )[0].FieloFormElement.set('value', productId);
        $(this.lastInvoiceItem).find(
            $('[data-field-name="FieloPRP__Quantity__c"]')
            )[0].FieloFormElement.set('value', 1);
        this.activeItem = this.lastInvoiceItem;
        this.activeItem.setAttribute('data-value', productId);
      }
    },
      this
    );
    this.productRecent_.FieloRecentRecords.uncheckAll();
  };

  /**
   * Set the available redemptions slots array
   *
   */
  FieloFormInvoice.prototype.getEmptyInvoiceItems = function() {
    var product;
    this.availableSlots = [];
    [].forEach.call(
      this.element_.getElementsByClassName(this.CssClasses_.INVOICE_ITEM),
      function(element) {
        product =
          $(element).find(
            $('[data-field-name="' + this.productField + '"]')
            )[0].FieloFormElement.get('value');
        if (product === null || product === undefined) {
          this.availableSlots.push(element);
        }
      },
        this
    );
  };

  FieloFormInvoice.prototype.refreshTotal = function() {
    if (this.hasAmountFields) {
      this.invoiceItems_ = this.element_.getElementsByClassName(
        this.CssClasses_.INVOICE_ITEM);
      var invoiceTotalValue = Number(0);
      var itemTotal;
      [].forEach.call(this.invoiceItems_, function(item) {
        itemTotal = $(item).find(
          $('[data-field-name="FieloPRP__TotalPrice__c"]')
            )[0].FieloFormElement.get('value');
        itemTotal = isNaN(parseFloat(itemTotal)) ?
          parseFloat(0) :
          parseFloat(itemTotal);
        invoiceTotalValue += Number(parseFloat(itemTotal));
      },
        this
      );
      this.invoiceTotal_ =
        this.element_.querySelector('.' + this.CssClasses_.TOTAL_POINTS);
      this.invoiceTotal_.innerHTML = parseFloat(invoiceTotalValue).toFixed(2);
    }
  };

  FieloFormInvoice.prototype.refreshTotalPriceProxy_ = function(value) {
    this.verifyMember_(value);
    if (this.hasAmountFields) {
      var row =
        $(value.srcElement).closest('.' + this.CssClasses_.INVOICE_ITEM)[0];

      var updatedField =
        $(value.srcElement).closest('.' +
          this.CssClasses_.ELEMENT)[0].FieloFormElement.get('fieldName');

      var unitPriceFieldElement =
        $(row).find($('[data-field-name="FieloPRP__UnitPrice__c"]')
              )[0];
      var quantityFieldElement =
        $(row).find($('[data-field-name="FieloPRP__Quantity__c"]')
              )[0];
      var totalPriceFieldElement =
        $(row).find($('[data-field-name="FieloPRP__TotalPrice__c"]')
              )[0];

      var unitPriceField = unitPriceFieldElement ?
        unitPriceFieldElement.FieloFormElement :
        null;
      var quantityField = quantityFieldElement ?
        quantityFieldElement.FieloFormElement :
        null;
      var totalPriceField = totalPriceFieldElement ?
        totalPriceFieldElement.FieloFormElement :
        null;

      if (unitPriceField) {
        if (unitPriceField.get('value') === null ||
          unitPriceField.get('value') === undefined ||
          unitPriceField.get('value') === '') {
          unitPriceField.set('value', 0);
        }
      }
      if (quantityField) {
        if (quantityField.get('value') === null ||
          quantityField.get('value') === undefined ||
          quantityField.get('value') === '') {
          quantityField.set('value', 0);
        }
      }
      if (totalPriceField) {
        if (totalPriceField.get('value') === null ||
          totalPriceField.get('value') === undefined ||
          totalPriceField.get('value') === '') {
          totalPriceField.set('value', 0);
        }
      }
      /* var zeroUnitPrice =
        unitPriceField.get('value') === '0';
      var zeroQuantity =
        quantityField.get('value') === '0';
      var zeroTotalPrice =
        totalPriceField.get('value') === '0';
      */
      if (totalPriceField && quantityField && unitPriceField) {
        if (updatedField === 'FieloPRP__Quantity__c') {
          totalPriceField.set('value',
            (parseFloat(quantityField.get('value')) *
              parseFloat(unitPriceField.get('value'))).toFixed(2)
            );
        }
        if (updatedField === 'FieloPRP__UnitPrice__c') {
          totalPriceField.set('value',
            (parseFloat(quantityField.get('value')) *
              parseFloat(unitPriceField.get('value'))).toFixed(2)
            );
        }
        if (updatedField === 'FieloPRP__TotalPrice__c') {
          unitPriceField.set('value',
            (parseFloat(quantityField.get('value')) > 0.0 ?
            parseFloat(totalPriceField.get('value')) /
              parseFloat(quantityField.get('value')) :
              0).toFixed(2)
            );
        }
      }
      this.refreshTotal();
    }
  };

  FieloFormInvoice.prototype.verifyMember_ = function(event) {
    if (!this.disableMemberValidation) {
      var memberId = document.querySelector(
        '[data-field-name="FieloPRP__Member__c"]'
        ).FieloFormElement.get('value');
      if (memberId === null || memberId === undefined) {
        event.stopPropagation();
        event.preventDefault();
        this.keepItems_ = false;
        this.clear_();
        this.throwMessage(BackEndJSSettings.LABELS.MemberMustBeChosen, 'error');
        $('[data-field-name="FieloPRP__Member__c"]')
          .find('#invoiceForm--input')[0].focus();
      } else {
        this.memberNotNull = true;
        if ($(event.srcElement).hasClass(this.CssClasses_.ADD_PRODUCTS) ||
          $(event.srcElement).hasClass(this.CssClasses_.NEW) ||
          $(event.srcElement).hasClass(this.CssClasses_.ELEMENT) ||
          $(event.srcElement).hasClass(this.CssClasses_.INPUT)) {
          this.validateHasDetails = true;
        } else {
          this.validateHasDetails = false;
        }
        this.currentEvent_ = event;
        this.getHasDetails(memberId);
      }
    }
  };

  FieloFormInvoice.prototype.getHasDetails = function(memberId) {
    Visualforce.remoting.Manager.invokeAction(
      'FieloPRP.FormInvoiceController.getHasDetailsFromMember',
      memberId,
      this.callbackHandler.bind(this),
      {escape: true}
    );
  };

  window.FieloFormInvoice_refreshPoints = // eslint-disable-line camelcase
      FieloFormInvoice.prototype.refreshTotalPriceProxy_;

  FieloFormInvoice.prototype.setParameters_ = function() {
    for (var field in this.parameters_) {
      if (this.parameters_.hasOwnProperty(field) &&
          this.elements_.hasOwnProperty(field)) {
        this.elements_[field].FieloFormElement.set(
          'value',
          this.parameters_[field]
        );
      }
    }
  };

  /**
   * Callback interno para retrieveRecords_
   * @param {sObject} result - record
   * @param {event} event - status ajax
   *
   */
  FieloFormInvoice.prototype.retrieveHandler_ = function(result) {
    fielo.util.spinner.FieloSpinner.show();
    this.result = result;
    try {
      // analizo si hay listas
      // preparo un hash para representar los campos que tienen listas
      var hash = '|';
      for (var field in result) {
        if (result.hasOwnProperty(field) && field.indexOf('__r') > -1) {
          hash += field.slice(0, -1) + 'c|';
        }
      }

      this.fields_.forEach(function(field) {
        // si es una lista
        if (hash.indexOf(field) > -1) {
          var values;
          switch (typeof result[field.slice(0, -1) + 'r']) {
            case 'object':
              // es un objeto que en su propiedad field contiene un string con id separados por ;
              // siguiendo el formato de salesforce
              // hay que parsear la informacion para pasarlo a la interfaz normal
              values = result[field.slice(0, -1) + 'r'];
              // busco la clave que contiene el campo __c
              var __c;
              for (var key in values) {
                if (values.hasOwnProperty(key) && key.indexOf('__c') > -1) {
                  __c = key;
                  break;
                }
              }
              if (__c) {
                values = values[__c].split(';');
              } else {
                values = result[field];
              }
              break;
            case 'array':
            default:
              // una interfaz normal
              values = result[field.slice(0, -1) + 'r'];
              break;
          }
          this.elements_[field].FieloFormElement.set('value', values);
        } else if (this.elements_[field]) {
          if (
            this.elements_[field].FieloFormElement.get('type') === 'input-date'
          ) {
            result[field] = fielo.util.parseDateFromSF(result[field]);
          }
          this.elements_[field].FieloFormElement.set('value', result[field]);
        }
      }, this);

      if (this.result.FieloPRP__InvoiceItems__r) {
        this.getEmptyInvoiceItems();

        this.result.FieloPRP__InvoiceItems__r.forEach(function(item) {
          if (this.availableSlots.length > 0) {
            this.lastInvoiceItem = this.availableSlots.pop();
          } else {
            this.invoiceContainerItems_ = this.element_.getElementsByClassName(
            this.CssClasses_.ITEMS_CONTAINER)[0];
            // todo: discover a new way to create redemption items, or turn the
            // the method into a public method
            this.invoiceContainerItems_.FieloInvoiceItems.newinvoiceItem_();
            this.invoiceItems_ =
            this.element_.getElementsByClassName(
              this.CssClasses_.INVOICE_ITEM);
            this.lastInvoiceItem =
            this.invoiceItems_[this.invoiceItems_.length - 1];
          }
          this.initItem_(this.lastInvoiceItem);
          this.elementFields = this.lastInvoiceItem.getElementsByClassName(
            this.CssClasses_.ELEMENT);

          [].forEach.call(Object.keys(item), function(field) {
            if (field === 'Id') {
              if (item[field]) {
                this.lastInvoiceItem.setAttribute('data-record-id',
                  item[field]);
              }
            } else if (item[field]) {
              var itemElement = $(this.lastInvoiceItem).find(
                $('[data-field-name="' + field + '"]')
                  )[0];
              if (itemElement) {
                itemElement.FieloFormElement.set('value', item[field]);
              }
            }
          },
            this
          );
        },
          this
        );
      }
      if (this.result.Attachments) {
        [].forEach.call(this.result.Attachments, function(attachment) {
          this.multiFileUploader_.FieloMultiFileUploaderPRP
            .addEmptyFilePill(attachment);
        },
          this
        );
      }

      // 3 - Pisar con los parameters de source en edit y new
      this.setParameters_();
      this.endRetrieve();
      this.disableMemberEdit_();
    } catch (e) {
      var notify = fielo.util.notify.create();
      notify.FieloNotify.addMessages([this.Constant_.HAS_ERROR, e]);
      notify.FieloNotify.setTheme('error');
      notify.FieloNotify.show();
      console.log(e);
    }
    fielo.util.spinner.FieloSpinner.hide();
  };

  FieloFormInvoice.prototype.retrieve_ = function(source) {
    // traigo los parameters del boton
    this.parameters_ = source.FieloButton.getParameters();

    // Setea parametros default en edit y new
    this.setParameters_();

    // 2 - Hacer retrieve si estoy en edit
    if (
      this.parameters_.hasOwnProperty('Id') ||
      this.parameters_.hasOwnProperty('cloneId')
    ) {
      this.isEditing = true;
      this.recordId_ = this.parameters_.Id;

      var retrieveRecordId = this.parameters_.Id || this.parameters_.cloneId;

      // Si es un record busca los datos y los setea
      var fields = Object.keys(this.getValues_()).join();

      var itemFields = Object.keys(
        this.itemsContainer_.FieloInvoiceItems.get()[0]).join();

      var objectName = this.element_.getAttribute(this.Constant_.OBJECT_NAME);
      Visualforce.remoting.Manager.invokeAction(
        this.retrieveController_,
        objectName,
        retrieveRecordId,
        fields,
        itemFields,
        this.retrieveHandler_.bind(this),
        {escape: true}
      );
    } else {
      this.isEditing = false;
      this.setParameters_();
      this.endRetrieve();
    }
  };

  FieloFormInvoice.prototype.checkHasDetails = function() {
    var hasDetails = this.element_
      .querySelector('[data-field-name="FieloPRP__HasDetails__c"]')
        .FieloFormElement.get('value');
    if (!hasDetails) {
      this.currentEvent_.stopPropagation();
      this.currentEvent_.preventDefault();
      this.keepItems_ = false;
      this.clear_();
      this.closeProducsModalIfOpened_();
      var actionResult = {
        message: BackEndJSSettings.LABELS.InvoiceDetailInsertDisabled};
      this.form_.processRemoteActionResult_(null, actionResult);
    }
  };

  /**
   * Callback interno para getHasDetails,
   * Pay attention to other class variables that
   * are used in this method:
   * - this.validateHasDetails (will execute some validations)
   * - this.saveRecord_ (tries to save the record)
   * @param {boolean} result - HasDetails or not
   *
   */
  FieloFormInvoice.prototype.callbackHandler = function(result) {
    if (result) {
      this.element_
      .querySelector('[data-field-name="FieloPRP__HasDetails__c"]')
        .FieloFormElement.set('value', result);
    }
    if (this.validateHasDetails) {
      this.checkHasDetails();
      this.validateHasDetails = false;
    }
    if (this.saveRecord_) {
      this.saveRecord_ = false;
      this.save_();
    }
  };

  FieloFormInvoice.prototype.hasDetailsCheck = function() {
    var hasDetailsFormElement =
      this.element_.querySelector(
        '[data-field-name="FieloPRP__HasDetails__c"]');
    var invoiceContainerItems =
      this.element_.querySelector(
        '.' + this.CssClasses_.ITEMS_CONTAINER);

    $(hasDetailsFormElement).addClass('slds-hidden');
    $(hasDetailsFormElement).addClass('slds-is-collapsed');

    if (this.result !== null && this.result !== undefined) {
      var hasDetails = this.result.FieloPRP__HasDetails__c;
      var memberValue = this.result.FieloPRP__Member__c;
      if (memberValue !== null && !hasDetails) {
        $(invoiceContainerItems).addClass('slds-hidden');
        $(invoiceContainerItems).addClass('slds-is-collapsed');
      }
      if (memberValue !== null && hasDetails) {
        this.hideAmount_();
      }
    }

    componentHandler.upgradeElement(hasDetailsFormElement);
  };

  FieloFormInvoice.prototype.endRetrieve = function() {
    this.hasDetailsCheck();
    this.refreshTotal();
  };

  FieloFormInvoice.prototype.closeProducsModalIfOpened_ = function() {
    if ($('.' + this.CssClasses_.PRODUCT_FORM).hasClass('slds-show')) {
      $('.fielosf-invoice-form-addproducts').modal('hide');
    }
    if ($('.fielosf-invoice-form').hasClass('slds-hide')) {
      $('.fielosf-invoice-form').modal('show');
    }
  };

  FieloFormInvoice.prototype.hideAmount_ = function() {
    var amountFormElem =
      this.element_.querySelector(
        '[data-field-name="FieloPRP__Amount__c"]');

    $(amountFormElem).addClass('slds-hidden');
    $(amountFormElem).addClass('slds-is-collapsed');
  };

  FieloFormInvoice.prototype.disableMemberEdit_ = function() {
    $('[data-field-name="FieloPRP__Member__c"]')
      .addClass('disabled');
  };

  FieloFormInvoice.prototype.getActiveProgram = function() {
    Visualforce.remoting.Manager.invokeAction(
      this.Constant_.GET_PROGRAM_CONTROLLER,
      this.getActiveProgramCallback.bind(this),
      {escape: true}
    );
  };

  FieloFormInvoice.prototype.getActiveProgramCallback = function(program) {
    if (!this.isEditing) {
      if (program.FieloPRP__RequestInvoiceProducts__c) {
        $('.' + this.CssClasses_.ITEMS_CONTAINER)
          .removeClass('slds-hidden');
        $('.' + this.CssClasses_.ITEMS_CONTAINER)
          .removeClass('slds-is-collapsed');
        $('[data-field-name="FieloPRP__Amount__c"]')
          .addClass('slds-hidden');
        $('[data-field-name="FieloPRP__Amount__c"]')
          .addClass('slds-is-collapsed');
      } else {
        $('.' + this.CssClasses_.ITEMS_CONTAINER)
          .addClass('slds-hidden');
        $('.' + this.CssClasses_.ITEMS_CONTAINER)
          .addClass('slds-is-collapsed');
        $('[data-field-name="FieloPRP__Amount__c"]')
          .removeClass('slds-hidden');
        $('[data-field-name="FieloPRP__Amount__c"]')
          .removeClass('slds-is-collapsed');
      }
    }
  };

  FieloFormInvoice.prototype.getHasFields = function() {
    this.hasAmountFields = false;
    if (this.itemsContainer_
        .querySelector('[data-field-name="FieloPRP__Quantity__c"]') &&
      this.itemsContainer_
        .querySelector('[data-field-name="FieloPRP__UnitPrice__c"]') &&
      this.itemsContainer_
        .querySelector('[data-field-name="FieloPRP__TotalPrice__c"]')) {
      this.hasAmountFields = true;
    }
    if (this.hasAmountFields === false) {
      [].forEach.call(this.itemsContainer_
        .querySelector('tfoot')
          .querySelectorAll('td'), function(td) {
        td.innerHTML = '';
      }, this);
    }
  };

  FieloFormInvoice.prototype.throwMessage = function(message, type) {
    var notify = fielo.util.notify.create();
    notify.FieloNotify.addMessages([message]);
    notify.FieloNotify.setTheme(type);
    notify.FieloNotify.show();
  };

  FieloFormInvoice.prototype.retrieveProxy_ = function(modal, source) {
    modal.FieloFormInvoice.clear_();
    modal.FieloFormInvoice.retrieve_(source);
  };
  window.FieloFormInvoice_retrieve = FieloFormInvoice.prototype.retrieveProxy_; // eslint-disable-line camelcase

  /**
   * Inicializa el elemento
   */
  FieloFormInvoice.prototype.init = function() {
    if (this.element_) {
      this.openForm_ = location.hash.split('#').slice(1);
      this.retrieveController_ =
        this.element_.getAttribute(this.Constant_.RETRIEVE_CONTROLLER);

      this.productField =
        this.element_.getAttribute(this.Constant_.PRODUCT_FIELD);

      this.form_ = this.element_.FieloForm;

      this.itemsContainer_ =
        this.element_
          .getElementsByClassName(this.CssClasses_.ITEMS_CONTAINER)[0];
      if (this.itemsContainer_ !== null && this.itemsContainer_ !== undefined) {
        componentHandler.upgradeElement(this.itemsContainer_);
      }

      this.getHasFields();

      this.element_.FieloForm.save_ = this.submitForm.bind(this);

      this.form_.clear_ = this.clear_.bind(this);

      this.invoiceElements_ = $(
        this.element_
          .getElementsByClassName(this.CssClasses_.ELEMENT)
      ).not(
        this.itemsContainer_ !== null &&
          this.itemsContainer_ !== undefined ?
          this.itemsContainer_.getElementsByClassName(
            this.CssClasses_.ELEMENT) :
          null
      );

      this.fields_ = Object.keys(this.getValues_());

      this.elements_ = [];
      [].forEach.call(
        this.element_.getElementsByClassName(this.CssClasses_.CONTAINER),
        function(container) {
          componentHandler.upgradeElement(container);
          this.elements_[container.FieloFormElement.get('fieldName')] =
            container;
        },
        this
      );

      this.form_.save_ = this.submitForm.bind(this);

      if (this.openForm_.length > 0) {
        var Id = this.openForm_[1];
        this.memberField_.FieloFormElement.set('value', Id);
        $(this.element_).modal('show');
      }
      this.invoiceAmount_ =
        this.element_.querySelector('.' + this.CssClasses_.INVOICE_AMOUNT);

      if (this.keepItems_ === null || this.keepItems_ === undefined) {
        this.keepItems_ = false;
      }

      this.addProductsBtn_ = this.element_.getElementsByClassName(
        this.CssClasses_.ADD_PRODUCTS)[0];
      // Method to disable any action when no member is given
      this.addProductsBtn_.addEventListener('click',
        this.verifyMember_.bind(this));
      // Method to refresh recend records from the add rewards modal
      this.addProductsBtn_.addEventListener('click',
        this.reloadproductRecent_.bind(this));

      this.cancelBtn_ = this.element_.getElementsByClassName(
        this.CssClasses_.CANCEL)[0];
      // Make filled fields persistent
      this.cancelBtn_.addEventListener('click',
        this.resetKeepItems.bind(this));

      this.newProductBtn = this.element_.getElementsByClassName(
        this.CssClasses_.NEW)[0];
      // Method to disable any action when no member is given
      this.newProductBtn.addEventListener('click',
        this.verifyMember_.bind(this));
      this.newProductBtn.addEventListener('click',
        this.initNewItem.bind(this));

      this.productForm_ =
        document.getElementsByClassName(this.CssClasses_.PRODUCT_FORM)[0];
      if (this.productForm_ !== null && this.productForm_ !== undefined) {
        this.productFormAddBtn_ =
          this.productForm_.getElementsByClassName(
            this.CssClasses_.PRODUCT_ADD)[0];
        // Add selected rewards to basket
        this.productFormAddBtn_.addEventListener('click',
          this.updateProductBasket.bind(this));

        this.productFormSearchBtn_ =
          this.productForm_.getElementsByClassName(
            this.CssClasses_.PRODUCT_SEARCH)[0];
        // Executes the reward search based on modal filters
        this.productFormSearchBtn_.addEventListener('click',
          this.searchRecords_.bind(this));

        this.cancelProductsAddBtn_ = document.getElementsByClassName(
          this.CssClasses_.PRODUCT_CANCEL)[0];
        this.productRecent_ = document.getElementById(
          this.Constant_.PRODUCT_RECENT);
        // Unmark selected rows in the rewards modal
        this.cancelProductsAddBtn_.addEventListener('click',
          this.productRecent_.FieloRecentRecords.uncheckAll.bind(
            this.productRecent_.FieloRecentRecords));
      }
      // Add Listeners to items fields on show.
      $(this.element_).on('shown.aljs.modal', function() {
        var _this = document.getElementsByClassName(
          'fielosf-invoice-form')[0];
        _this.FieloFormInvoice.getActiveProgram();
      });
      $(this.element_).on('select', function() {
        var _this = document.getElementsByClassName(
        'fielosf-invoice-form')[0];
        _this.FieloFormInvoice.getActiveProgram();
      });
      this.multiFileUploader_ = this.element_.getElementsByClassName(
        this.CssClasses_.FILE_UPLOADER
        )[0];
      this.newFileBtn_ =
        this.multiFileUploader_.getElementsByClassName(
          this.CssClasses_.NEW_FILE_BUTTON
          )[0];
      this.newFileBtn_.addEventListener(
        'click',
        this.verifyMember_.bind(this));
    }
  };

  fielo.helper.register({
    constructor: FieloFormInvoice,
    classAsString: 'FieloFormInvoice',
    cssClass: 'fielosf-invoice-form',
    widget: true
  });
})();

