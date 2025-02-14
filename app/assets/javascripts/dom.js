class Dom {
  static id(query) {
    return document.getElementById(query);
  }

  static q(query) {
    return document.querySelector(query);
  }

  static qa(query) {
    return document.querySelectorAll(query);
  }

  static create(html) {
    return document.createRange().createContextualFragment(html);
  }

  static clear(node) {
    node.innerHTML = '';
  }

  static append(node, html) {
    const fragment = this.create(html);
    node.appendChild(fragment);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Dom = Dom;
