$(() =>
  $('#currency').on('change', function() {
    return $.ajax({
      type: 'GET',
      url: $(this).data('href'),
      data: {
        currency: $(this).val()
      }
    }).done(() => window.location.reload());
  })
);