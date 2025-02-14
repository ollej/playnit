class Flasher {
  constructor(sel) {
    this.sel = sel;
  }

  div() {
    if (this.el) {
      return this.el;
    }
    this.el = Dom.q(this.sel);
    console.log("div", this.el);
    return this.el;
  }

  flash(msg, level = "danger") {
    logger.debug('Flash', msg, level);
    Dom.append(this.div(), `<div class='alert fade in alert-${level}'><button class='close' data-dismiss='alert'>×</button>${msg}</div>`);
  }

  warning(msg) { this.flash(msg, 'warning'); }
  error(msg) { this.flash(msg, 'danger'); }
  info(msg) { this.flash(msg, 'info'); }
  success(msg) { this.flash(msg, 'success'); }
  clear() { Dom.clear(this.div()); }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Flasher = Flasher;
