function CouponManager (input) {
  this.input = input
  this.couponCodeField = this.input.couponCodeField
  this.couponStatus = this.input.couponStatus
}

CouponManager.prototype.applyCoupon = function () {
  this.couponCode = $.trim($(this.couponCodeField).val())
  if (this.couponCode !== '') {
    if (this.couponStatus.length === 0) {
      this.couponStatus = $('<div/>', {
        id: 'coupon_status'
      })
      this.couponCodeField.parent().append(this.couponStatus)
    }
    this.couponStatus.removeClass()
    this.sendRequest(this.couponCode)
  } else {
    return true
  }
}

CouponManager.prototype.sendRequest = function (couponCode) {
  fetch(Spree.routes.api_v2_storefront_cart_apply_coupon_code, {
    method: 'PATCH',
    headers: {
      'X-Spree-Order-Token': Spree.current_order_token,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      coupon_code: couponCode,
    })
  }).then(response => {
    switch (response.status) {
      case 404:
        response.json().then(({ error }) => { this.couponStatus.addClass('alert-error').html(error) });
        break;
      case 422:
        response.json().then(({ error }) => { this.couponStatus.addClass('alert-error').html(error) });
        break;
      case 500:
        alert('Internal Server Error');
        break;
      case 200:
        this.couponCodeField.val('')
        this.couponStatus.addClass('alert-success').html(Spree.translations.coupon_code_applied)
        window.location.reload()
        break;
    };
  });
}
