(function() {
  'use strict';

  /**
   * @description FieloMultiFileUploaderPRP controller.
   * Enables multi file upload
   * Implements the design patterns defined by MDL in
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal <tiago.leal@fielo.com>
   * @param {HTMLElement} element - extended element.
   * @constructor
   */
  var FieloMultiFileUploaderPRP = function FieloMultiFileUploaderPRP(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloMultiFileUploaderPRP = FieloMultiFileUploaderPRP;

  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloMultiFileUploaderPRP.prototype.Constant_ = {
    MAX_FILE_SIZE: 4350000,
    CHUNK_SIZE: 950000,
    UPLOAD_CONTROLLER: 'FieloPRP.MultiFileUploader.saveTheChunk',
    DELETE_FILES_CONTROLLER: 'FieloPRP.MultiFileUploader.deleteFiles'
  };

  /**
   * Guarda strings para nombres de clases definidas por este componente que
   * son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloMultiFileUploaderPRP.prototype.CssClasses_ = {
    PAGINATOR: 'fielosf-paginator',
    PILL: 'slds-pill',
    CARD_BODY: 'slds-card__body',
    PILL_CONTAINER: 'slds-card__body--inner',
    PILL_MODEL: 'slds-pill__model',
    PILL_LABEL: 'slds-pill__label',
    PILL_REMOVE: 'slds-pill__remove'
  };

  /**
   * Inicializa el elemento
   */
  FieloMultiFileUploaderPRP.prototype.init = function() {
    if (this.element_) {
      this.initPillsDocument();
      this.filePills_ =
        this.element_.getElementsByClassName(this.CssClasses_.PILL_MODEL);
      $('#file-upload-input-01')[0].addEventListener(
        'change', this.handleFile.bind(this));
      this.removePillbtn_ =
        this.element_.getElementsByClassName(
          this.CssClasses_.PILL_REMOVE)[0];
      this.removePillbtn_.addEventListener(
        'click',
        this.removePill.bind(this));

      this.form_ = this.element_.FieloForm;

      componentHandler.upgradeElement(this.element_);
    }
  };

  FieloMultiFileUploaderPRP.prototype.removePill = function(event) {
    if (this.deleteList === null || this.deleteList === undefined) {
      this.deleteList = [];
    }
    this.currentPillContainer = $(event.srcElement).closest(
      '.' + this.CssClasses_.PILL_CONTAINER)[0];
    this.currentPillLabel = $(this.currentPillContainer).find(
      '.' + this.CssClasses_.PILL_LABEL)[0];
    var fileIndex = this.currentPillLabel
      .getAttribute('data-record-id');
    // Remove file from memory
    this.newFile = false;
    if (this.fileList) {
      if (this.fileList[fileIndex]) {
        delete this.fileList[fileIndex];
        this.newFile = true;
      }
    }
    // Remove file pill representation
    this.currentPillContainer.remove();
    if (!this.newFile) {
      this.deleteList.push(fileIndex);
    }
  };

  FieloMultiFileUploaderPRP.prototype.deleteFilesFromServer = function() {
    if (this.deleteList) {
      if (this.deleteList.length > 0) {
        var self = this;
        var filesToDelete = this.deleteList.slice();
        this.deleteList = null;
        Visualforce.remoting.Manager.invokeAction(
          this.Constant_.DELETE_FILES_CONTROLLER,
          filesToDelete,
          this.uploadFile.bind(this, self.parentId),
          {escape: true}
        );
      }
    }
  };

  FieloMultiFileUploaderPRP.prototype.clearPills = function() {
    this.nonModelPills = $(
      this.element_
        .getElementsByClassName(this.CssClasses_.PILL_CONTAINER)
    ).not(
      this.element_
        .getElementsByClassName(this.CssClasses_.PILL_MODEL)
    );
    var removeBtn;
    [].forEach.call(this.nonModelPills, function(pill) {
      removeBtn = pill.getElementsByClassName(
        this.CssClasses_.PILL_REMOVE)[0];
      removeBtn.click();
    },
      this
    );
  };

  FieloMultiFileUploaderPRP.prototype.initPillsDocument = function() {
    $(document).ready(function() {
      $('body').pill();
    });
  };

  FieloMultiFileUploaderPRP.prototype.initPill = function(pill) {
    this.removePillbtn_ =
      $(pill).find('.' +
        this.CssClasses_.PILL_REMOVE)[0];
    this.removePillbtn_.addEventListener(
      'click',
      this.removePill.bind(this));
  };

  FieloMultiFileUploaderPRP.prototype.addEmptyFilePill = function(fakeFile) {
    this.currentPillContainer = this.filePills_[0].cloneNode(true);
    this.cardBody_ = this.element_.getElementsByClassName(
      this.CssClasses_.CARD_BODY)[0];
    this.cardBody_.appendChild(this.currentPillContainer);
    $(this.currentPillContainer).removeClass('slds-hidden');
    $(this.currentPillContainer).removeClass('slds-is-collapsed');
    $(this.currentPillContainer).removeClass('slds-pill__model');
    this.currentPillLabel =
      this.currentPillContainer.getElementsByClassName(
        this.CssClasses_.PILL_LABEL)[0];
    if (fakeFile.Name) {
      this.currentPillLabel.innerHTML = fakeFile.Name;
      this.currentPillLabel.setAttribute('title', fakeFile.Name);
    } else {
      this.currentPillLabel.innerHTML = fakeFile.Title;
      this.currentPillLabel.setAttribute('title', fakeFile.Title);
    }
    this.currentPillLabel.setAttribute('data-record-id',
      fakeFile.Id);
    this.initPill(this.currentPillContainer);
  };

  FieloMultiFileUploaderPRP.prototype.addFilePill = function(file) {
    this.currentPillContainer = this.filePills_[0].cloneNode(true);
    this.cardBody_ = this.element_.getElementsByClassName(
      this.CssClasses_.CARD_BODY)[0];
    this.cardBody_.appendChild(this.currentPillContainer);
    $(this.currentPillContainer).removeClass('slds-hidden');
    $(this.currentPillContainer).removeClass('slds-is-collapsed');
    $(this.currentPillContainer).removeClass('slds-pill__model');
    this.currentPillLabel =
      this.currentPillContainer.getElementsByClassName(
        this.CssClasses_.PILL_LABEL)[0];
    this.currentPillLabel.innerHTML = file.name;
    this.currentPillLabel.setAttribute('title', file.name);
    this.currentPillLabel.setAttribute('data-record-id',
      Object.keys(this.fileList).length - 1);
    this.initPill(this.currentPillContainer);
  };

  FieloMultiFileUploaderPRP.prototype.handleFile = function(event) {
    this.input_ = event.target;
    if (this.fileList === null || this.fileList === undefined) {
      this.fileList = {};
    }
    [].forEach.call(this.input_.files, function(file) {
      try {
        if (file.size < this.Constant_.MAX_FILE_SIZE) {
          this.fileList[Object.keys(this.fileList).length.toString()] = file;
          this.addFilePill(file);
        } else {
          var message = BackEndJSSettings.LABELS.MaxFileSize.replace('{0}',
            (this.Constant_.MAX_FILE_SIZE / 1024 / 1024).toFixed(2).toString());
          this.throwMessage(message, 'error');
          this.input_.value = null;
        }
      } catch (e) {
        console.log('error' + e);
      }
    },
      this
    );
    this.input_.value = null;
  };

  window.FieloMultiFileUploaderPRP_handleFile = // eslint-disable-line camelcase
    FieloMultiFileUploaderPRP.prototype.handleFile; // eslint-disable-line camelcase

  FieloMultiFileUploaderPRP.prototype.uploadFile = function(parentId) {
    this.parentId = parentId;
    if (this.deleteList) {
      this.deleteFilesFromServer();
    } else if (this.fileList) {
      var filePtr = Object.keys(this.fileList)[0];
      var file = this.fileList[filePtr];
      delete this.fileList[filePtr];
      var self = this;
      console.log(file);
      if (file) {
        var fr = new FileReader();
        fr.onloadend = function() {
          var fileContents = window.btoa(fr.result);
          self.upload(parentId, file, fileContents);
        };
        fr.readAsBinaryString(file);
      } else {
        this.throwMessage(BackEndJSSettings.LABELS.ChooseFileFirst,
          'error');
      }
    } else {
      this.redirectToParent(parentId);
    }
  };

  FieloMultiFileUploaderPRP.prototype.upload = function(
      parentId, file, fileContents) {
    var fromPos = 0;
    var toPos = Math.min(fileContents.length,
      fromPos + this.Constant_.CHUNK_SIZE);

    // start with the initial chunk
    this.uploadChunk(parentId, file, fileContents, fromPos, toPos, '');
  };

  FieloMultiFileUploaderPRP.prototype.uploadChunk = function(
    parentId, file, fileContents, fromPos, toPos, attachId) {
    var chunk = fileContents.substring(fromPos, toPos);
    var self = this;
    Visualforce.remoting.Manager.invokeAction(
        this.Constant_.UPLOAD_CONTROLLER,
        parentId,
        file.name,
        encodeURIComponent(chunk),
        file.type,
        attachId,
        function(a) {
          attachId = a;
          fromPos = toPos;
          toPos = Math.min(fileContents.length, fromPos +
            self.Constant_.CHUNK_SIZE);
          if (fromPos < toPos) {
            self.uploadChunk(
              parentId, file, fileContents, fromPos, toPos, attachId);
          } else if (self.fileList) {
            if (Object.keys(self.fileList).length > 0) {
              self.uploadFile(parentId);
            } else {
              FieloMultiFileUploaderPRP.prototype
                .redirectToParent.call(self, parentId);
            }
          } else {
            FieloMultiFileUploaderPRP.prototype
              .redirectToParent.call(self, parentId);
          }
        },
        {escape: true}
      );
  };

  FieloMultiFileUploaderPRP.prototype.redirectToParent = function(parentId) {
    fielo.util.spinner.FieloSpinner.hide();
    var modalList = document.getElementsByClassName('slds-modal');
    [].forEach.call(modalList, function(modal) {
      try {
        $(modal).modal('dismiss');
      } catch (e) {}
    },
      this
    );
    var result = {message: BackEndJSSettings.LABELS.InvoiceSavedSuccess,
      redirectURL: '/' + parentId};
    this.throwMessage(result.message, 'success');
    location.replace(result.redirectURL);
  };

  FieloMultiFileUploaderPRP.prototype.throwMessage = function(message, type) {
    var notify = fielo.util.notify.create();
    notify.FieloNotify.addMessages([message]);
    notify.FieloNotify.setTheme(type);
    notify.FieloNotify.show();
  };

  componentHandler.register({
    constructor: FieloMultiFileUploaderPRP,
    classAsString: 'FieloMultiFileUploaderPRP',
    cssClass: 'fielosf-multi-file-uploader',
    widget: true
  });
})();
