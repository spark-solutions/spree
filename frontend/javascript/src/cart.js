import $ from 'jquery';
import Spree from 'spree-core';

export const fetchCartLink = () => $.ajax({
  url: Spree.pathFor('cart_link'),
  success(data) {
    return $('#link-to-cart').html(data);
  }
});
