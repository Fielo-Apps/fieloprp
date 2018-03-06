(function() {
  'use strict';

  var FieloFormInvoiceApprover = function FieloFormInvoiceApprover(element) {
    this.element_ = element;
    // Initialize instance.
    this.init();
  };
  window.FieloFormInvoiceApprover = FieloFormInvoiceApprover;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloFormInvoiceApprover.prototype.Constant_ = {
    SAVE_CONTROLLER: 'FieloPRP.FormSubmitForApprovalController.save',
    RECORD_ID: 'data-record-id'

  };

  /**
   * Guarda strings para nombres de clases definidas poPr este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloFormInvoiceApprover.prototype.CssClasses_ = {
    SAVE: 'slds-form-approver__save'

  };

  FieloFormInvoiceApprover.prototype.save = function() {
    fielo.util.spinner.FieloSpinner.show();

    this.formValues = {};
    this.nullFields = [];
    this.formValues.Id =
      this.recordId;
    // get values based on action
    this.formValues.ApproverId =
      this.element_
        .querySelector('[data-field-name="approver"]')
        .FieloFormElement
        .get('value');
    try {
      if (this.form_.checkRequiredPassOk_()) {
        Visualforce.remoting.Manager.invokeAction(
          this.Constant_.SAVE_CONTROLLER,
          this.formValues,
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
  FieloFormInvoiceApprover.prototype.init = function() {
    if (this.element_) {
      this.form_ = this.element_.FieloForm;
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
    constructor: FieloFormInvoiceApprover,
    classAsString: 'FieloFormInvoiceApprover',
    cssClass: 'fielosf-invoice-approver',
    widget: true
  });
})();

