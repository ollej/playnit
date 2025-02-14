class Flasher {
  constructor(sel) {
    this.sel = sel;
  }

  div() {
    if (this.el) {
      return this.el;
    }
    this.el = Dom.q(this.sel);
    return this.el;
  }

  flash(msg, level = "danger") {
    logger.debug('Flasher.flash msg=', msg, "level=", level);
    this.div().append(`<div class='alert fade in alert-${level}'><button class='close' data-dismiss='alert'>×</button>${msg}</div>`)
  }

  warning(msg) { this.flash(msg, 'warning'); }
  error(msg) { this.flash(msg, 'danger'); }
  info(msg) { this.flash(msg, 'info'); }
  success(msg) { this.flash(msg, 'success'); }
  clear() { this.div().clear(); }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Flasher = Flasher;
