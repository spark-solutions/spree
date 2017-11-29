//= require jquery.payment
$(document).ready(function() {
  if ($("#new_payment").is("*")) {

    if($('#credit_card_number').is('*')){
      console.log('stripe');
      var stripe = Stripe('pk_test_6pRNASCoBOKtIshFeQd4XMUh');
      var elements = stripe.elements();

      var card_number = elements.create('cardNumber');
      var card_expiry = elements.create('cardExpiry');
      var card_cvv = elements.create('cardCvc');

      card_number.mount('#credit_card_number');
      card_expiry.mount('#credit_card_expiry');
      card_cvv.mount('#credit_card_cvv');

      card_number.addEventListener('change', function(event) {
        var displayError = document.getElementById('card_number_errors');
        if (event.error) {
          displayError.textContent = event.error.message;
        } else {
          displayError.textContent = '';
          $(".ccType").val(event.brand)

          console.dir(event);
        }
      });

      card_expiry.addEventListener('change', function(event) {
        var displayError = document.getElementById('card_expiry_errors');
        if (event.error) {
          displayError.textContent = event.error.message;
        } else {
          displayError.textContent = '';
        }
      });

      card_cvv.addEventListener('change', function(event) {
        var displayError = document.getElementById('card_cvv_errors');
        if (event.error) {
          displayError.textContent = event.error.message;
        } else {
          displayError.textContent = '';
        }
      });
    }

    $('.payment_methods_radios').click(
      function() {
        $('.payment-methods').hide();
        $('.payment-methods :input').prop('disabled', true);
        if (this.checked) {
          $('#payment_method_' + this.value + ' :input').prop('disabled', false);
          $('#payment_method_' + this.value).show();
        }
      }
    );

    $('.payment_methods_radios').each(
      function() {
        if (this.checked) {
          $('#payment_method_' + this.value + ' :input').prop('disabled', false);
          $('#payment_method_' + this.value).show();
        } else {
          $('#payment_method_' + this.value).hide();
          $('#payment_method_' + this.value + ' :input').prop('disabled', true);
        }

        if ($("#card_new" + this.value).is("*")) {
          $("#card_new" + this.value).radioControlsVisibilityOfElement('#card_form' + this.value);
        }
      }
    );

    $('.cvvLink').click(function(event){
      window_name = 'cvv_info';
      window_options = 'left=20,top=20,width=500,height=500,toolbar=0,resizable=0,scrollbars=1';
      window.open($(this).prop('href'), window_name, window_options);
      event.preventDefault();
    });

    $('select.jump_menu').change(function(){
      window.location = this.options[this.selectedIndex].value;
    });
  }
});
