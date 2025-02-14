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

  static create(html) {
    return document.createRange().createContextualFragment(html);
  }

  static clear(node) {
    node.innerHTML = '';
    return node;
  }

  static append(node, html) {
    const fragment = this.create(html);
    node.appendChild(fragment);
    return node;
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
      clear() {
        Dom.clear(this);
        return this;
      }
    };
    const handler = {
      has(target, prop) {
        if (prop in methods) {
          return true;
        }
        return prop in target;
      },
      get(target, prop, receiver) {
        // Add additional methods
        if (prop in methods) {
          return function (...args) {
            return methods[prop].apply(this === receiver ? target : this, args);
          };
        }

        // delegate method with "this" set to target
        const value = target[prop];
        if (value instanceof Function) {
          return function (...args) {
            return value.apply(this === receiver ? target : this, args);
          };
        }

        // Return property value
        return value;
      }
    };

    return new Proxy(element, handler);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Dom = Dom;
