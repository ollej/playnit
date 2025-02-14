class Logger {
  constructor(quiet = false) {
    this.quiet = quiet;
  }

  silence() {
    this.quiet = true;
  }

  activate() {
    this.quiet = false;
  }

  debug() { this.delegate('debug', arguments); }

  warn() { this.delegate('warn', arguments); }

  error() { this.delegate('error', arguments); }

  info() { this.delegate('info', arguments); }

  log() { this.delegate('log', arguments); }

  delegate(method, args) {
    if (this.quiet) {
      return;
    }
    if (this.available(method)) {
      console[method].apply(console, args);
    } else if (this.available('log')) {
      console['log'].apply(console, args);
    }
  }

  available(method) {
    return window && window.console && (typeof window.console[method] === 'function');
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Logger = Logger;
