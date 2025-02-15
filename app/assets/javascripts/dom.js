class Dom {
  static id(query) {
    return this.proxy(document.getElementById(query));
  }

  static q(query) {
    return this.proxy(document.querySelector(query));
  }

  static qa(query) {
    return this.proxy(document.querySelectorAll(query));
  }

  static fragment(html) {
    return document.createRange().createContextualFragment(html);
  }

  static create(tag, attributes) {
    return this.proxy(Object.assign(document.createElement(tag), attributes));
  }

  static clear(node) {
    node.innerHTML = '';
    return node;
  }

  static append(node, html) {
    const fragment = this.fragment(html);
    node.appendChild(fragment);
    return node;
  }

  static ready(callback) {
    document.addEventListener("turbo:load", callback);
  }

  static proxy(element) {
    if (!element) {
      return null;
    }
    const methods = {
      append(html) {
        Dom.append(this, html);
        return this;
      },
      appendChild(element) {
        this.appendChild(element.el);
        return this;
      },
      clear() {
        Dom.clear(this);
        return this;
      },
      html(content) {
        this.innerHTML = content;
        return this;
      },
      replace(element) {
        this.replaceWith(element.el);
        return this;
      },
      replaceChildren(element) {
        this.replaceChildren(element.el);
        return this;
      },
      val(value) {
        if (value === undefined) {
          return this.value;
        }
        this.value = value;
      },
      hide() {
        this.style.display = "none";
      },
      show() {
        this.style.display = "block";
      },
    };
    const handler = {
      has(target, prop) {
        if (prop in methods) {
          return true;
        }
        return prop in target;
      },
      get(target, prop, receiver) {
        // Return inner element
        if (prop === "el") {
          return target;
        }

        // Add additional methods
        if (prop in methods) {
          return function (...args) {
            return methods[prop].apply(this === receiver ? target : this, args);
          };
        }

        // Delegate method with "this" set to target
        const value = target[prop];
        if (value instanceof Function) {
          return function (...args) {
            return value.apply(this === receiver ? target : this, args);
          };
        }

        // Return property value
        return Reflect.get(target, prop, receiver)
      },
    };

    return new Proxy(element, handler);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Dom = Dom;
