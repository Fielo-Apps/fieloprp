(function() {
  'use strict';

  var FieloFormInvoiceApproval = function FieloFormInvoiceApproval(element) {
    this.element_ = element;
    // Initialize instance.
    this.init();
  };
  window.FieloFormInvoiceApproval = FieloFormInvoiceApproval;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloFormInvoiceApproval.prototype.Constant_ = {
    SAVE_CONTROLLER: 'FieloPRP.FormApprovalController.save',
    COMMENTS: 'FieloPRP__Comments__c',
    REJECT_REASON: 'FieloPRP__RejectReason__c',
    RECORD_ID: 'data-record-id'

  };

  /**
   * Guarda strings para nombres de clases definidas poPr este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloFormInvoiceApproval.prototype.CssClasses_ = {
    SAVE: 'slds-form-approval__save'

  };

  FieloFormInvoiceApproval.prototype.endRetrieve = function() {
    if (this.form_.parameters_) {
      if (this.form_.parameters_.type) {
        if (this.form_.parameters_.type === 'reject') {
          $(this.element_
            .querySelector('[data-field-name="' +
              this.Constant_.REJECT_REASON + '"]'))
            .toggle(true);
          this.element_
            .querySelector('[data-field-name="' +
              this.Constant_.REJECT_REASON + '"]').required_ = true;
        } else {
          $(this.element_
            .querySelector('[data-field-name="' +
              this.Constant_.REJECT_REASON + '"]'))
            .toggle(false);
          this.element_
            .querySelector('[data-field-name="' +
              this.Constant_.REJECT_REASON + '"]').required_ = false;
        }
      }
    }
  };

  FieloFormInvoiceApproval.prototype.save = function() {
    fielo.util.spinner.FieloSpinner.show();
    if (this.form_.parameters_) {
      if (this.form_.parameters_.type) {
        this.action = this.form_.parameters_.type;
      }
    }

    this.formValues = {};
    this.nullFields = [];
    this.formValues.Id =
      this.recordId;
    // get values based on action
    this.formValues[this.Constant_.COMMENTS] =
      this.element_
        .querySelector('[data-field-name="' +
          this.Constant_.COMMENTS + '"]')
        .FieloFormElement
        .get('value');

    if (this.action === 'reject') {
      this.formValues[this.Constant_.REJECT_REASON] =
        this.element_
          .querySelector('[data-field-name="' +
            this.Constant_.REJECT_REASON + '"]')
          .FieloFormElement
          .get('value');
    } else {
      this.formValues[this.Constant_.REJECT_REASON] = null;
    }

    if (this.formValues[this.Constant_.COMMENTS] === null) {
      this.nullFields.push(this.Constant_.COMMENTS);
    }

    if (this.formValues[this.Constant_.REJECT_REASON] === null) {
      this.nullFields.push(this.Constant_.REJECT_REASON);
    }

    try {
      if (this.action !== 'reject' || this.form_.checkRequiredPassOk_()) {
        Visualforce.remoting.Manager.invokeAction(
          this.Constant_.SAVE_CONTROLLER,
          this.formValues,
          this.action,
          this.nullFields,
          this.form_.processRemoteActionResult_.bind(this.form_),
          {
            escape: false
          }
        );
      } else {
        fielo.util.spinner.FieloSpinner.hide();
      }
    } catch (e) {
      console.warn(e);
    }
  };

  /**
   * Inicializa el elemento
   */
  FieloFormInvoiceApproval.prototype.init = function() {
    if (this.element_) {
      this.form_ = this.element_.FieloForm;
      this.form_.endRetrieve = this.endRetrieve.bind(this);
      this.recordId =
        this.element_
          .getAttribute(this.Constant_.RECORD_ID);
      this.saveBtn_ =
        this.element_
          .querySelector('.' + this.CssClasses_.SAVE);
      this.saveBtn_.addEventListener('click',
        this.save.bind(this));
    }
  };

  fielo.helper.register({
    constructor: FieloFormInvoiceApproval,
    classAsString: 'FieloFormInvoiceApproval',
    cssClass: 'fielosf-invoice-approval',
    widget: true
  });
})();

