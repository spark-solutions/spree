import Uri from 'jsuri';

export const dummy = 16;

export const Spree = (() => {
  class Spree {
    static ready(callback) {
      jQuery(document).ready(callback);
      return jQuery(document).on('page:load turbolinks:load', () => callback(jQuery));
    }

    static mountedAt() {
      return window.SpreePaths.mounted_at;
    }

    static adminPath() {
      return window.SpreePaths.admin;
    }

    static pathFor(path) {
      let locationOrigin;
      locationOrigin = `${window.location.protocol}//${window.location.hostname}${window.location.port ? ":" + window.location.port : ""}`;
      return this.url(`${locationOrigin}${this.mountedAt()}${path}`, this.url_params).toString();
    }

    static adminPathFor(path) {
      return this.pathFor(`${this.adminPath()}${path}`);
    }

    static url(uri, query) {
      if (uri.path === void 0) {
        uri = new Uri(uri);
      }
      if (query) {
        $.each(query, (key, value) => uri.addQueryParam(key, value));
      }
      return uri;
    }

    static ajax(urlOrSettings, settings) {
      let url;
      if (typeof urlOrSettings === 'string') {
        return $.ajax(Spree.url(urlOrSettings).toString(), settings);
      } else {
        url = urlOrSettings['url'];
        delete urlOrSettings['url'];
        return $.ajax(Spree.url(url).toString(), urlOrSettings);
      }
    }
  }

  Spree.routes = {
    states_search: Spree.pathFor('api/v1/states'),
    apply_coupon_code(orderId) {
      return Spree.pathFor(`api/v1/orders/${orderId}/apply_coupon_code`);
    }
  };

  Spree.url_params = {};

  return Spree;
})();
