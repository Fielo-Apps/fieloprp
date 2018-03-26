(function() {
  'use strict';

  var FieloSubmitForApproval = function FieloSubmitForApproval(element) {
    this.element_ = element;
    // Initialize instance.
    this.init();
  };
  window.FieloSubmitForApproval = FieloSubmitForApproval;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloSubmitForApproval.prototype.Constant_ = {
    SUBMIT_CONTROLLER:
      'FieloPRP.FormSubmitForApprovalController.submitForApproval',
    RECORD_ID: 'data-record-id'

  };

  /**
   * Guarda strings para nombres de clases definidas poPr este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloSubmitForApproval.prototype.CssClasses_ = {
    FORM_APPROVER: 'fielosf-invoice-approver'

  };

  FieloSubmitForApproval.prototype.submit = function() {
    fielo.util.spinner.FieloSpinner.show();
    this.record = {};
    this.record.Id =
      this.recordId;
    try {
      Visualforce.remoting.Manager.invokeAction(
        this.Constant_.SUBMIT_CONTROLLER,
        this.record,
        this.submitCallback.bind(this),
        {
          escape: false
        }
      );
    } catch (e) {
      console.warn(e);
    }
  };

  FieloSubmitForApproval.prototype.submitCallback = function(result) {
    this.formApprover = document
      .querySelector('.' + this.CssClasses_.FORM_APPROVER);
    if (result.choseApproverFirst) {
      if (this.formApprover) {
        $(this.formApprover).modal('show');
        fielo.util.spinner.FieloSpinner.hide();
      }
    } else if (result.response) {
      if (this.formApprover) {
        if (this.formApprover.FieloFormInvoiceApprover) {
          if (this.formApprover.FieloFormInvoiceApprover.form_) {
            var notify = fielo.util.notify.create();
            notify
              .FieloNotify
              .addMessages([result.response.messages[0].summary]);
            notify
              .FieloNotify
              .setTheme(result.response.messages[0].severity.toLowerCase());
            notify
              .FieloNotify.show();
            fielo.util.spinner.FieloSpinner.hide();
            if (result
              .response
              .messages[0]
              .severity.toLowerCase() !== 'error') {
              location.reload();
            }
          }
        }
      }
    }
  };

  /**
   * Inicializa el elemento
   */
  FieloSubmitForApproval.prototype.init = function() {
    if (this.element_) {
      this.form_ = this.element_.FieloForm;
      this.recordId =
        this.element_
          .getAttribute(this.Constant_.RECORD_ID);
      this.element_.addEventListener('click',
        this.submit.bind(this));
    }
  };

  fielo.helper.register({
    constructor: FieloSubmitForApproval,
    classAsString: 'FieloSubmitForApproval',
    cssClass: 'fielosf-invoice-submit-for-approval',
    widget: true
  });
})();

