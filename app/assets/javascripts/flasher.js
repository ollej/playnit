class Flasher {
  constructor(sel) {
    this.sel = sel;
  }

  div() {
    if (this.$div) {
      return this.$div;
    }
    this.$div = $(this.sel);
    return this.$div;
  }

  flash(msg, level = "danger") {
    logger.debug('Flash', msg, level);
    return this.div().append(`<div class='alert fade in alert-${level}'><button class='close' data-dismiss='alert'>×</button>${msg}</div>`);
  }

  warning(msg) { this.flash(msg, 'warning'); }
  error(msg) { this.flash(msg, 'danger'); }
  info(msg) { this.flash(msg, 'info'); }
  success(msg) { this.flash(msg, 'success'); }
  clear() { this.div().html(''); }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Flasher = Flasher;
