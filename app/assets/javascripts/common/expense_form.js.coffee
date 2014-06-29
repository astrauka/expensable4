class app.ExpenseForm
  EMPTY: ''

  constructor: (@form_finder) ->
    @form = $(@form_finder)

  bind: =>
    @adjust_multiplier_inputs()
    @adjust_calculated_price()

    @form.on('change', 'input[data-sharing-user-id]', @adjust_multiplier_inputs)

    @form.on(
      'change',
      'input[data-sharing-user-id], input[data-multiplier-user-id], input.expense-spent',
      @adjust_calculated_price
    )

  multipliers_for_sharing_inputs: (finder) =>
    $share_inputs = @form.find("input[data-sharing-user-id]#{finder}")
    $share_inputs.closest('.row').find('input[data-multiplier-user-id]')

  adjust_multiplier_inputs: =>
    for $multiplier_input in @multipliers_for_sharing_inputs(':checked')
      @enable_multiplier_input($multiplier_input)

    for $multiplier_input in @multipliers_for_sharing_inputs(':not(:checked)')
      @disable_multiplier_input($multiplier_input)

  enable_multiplier_input: (multiplier_input) =>
    $multiplier_input = $(multiplier_input)
    if $multiplier_input.attr('disabled')
      # do not reset value if was enabled
      $multiplier_input.val(1)

    $multiplier_input.removeAttr('disabled')

  disable_multiplier_input: (multiplier_input)=>
    $multiplier_input = $(multiplier_input)
    $multiplier_input.val(0)
    $multiplier_input.attr('disabled', 'disabled')

  adjust_calculated_price: =>
    total_multiples = 0
    for multiplier_input in @multipliers_for_sharing_inputs(':checked')
      total_multiples += Number($(multiplier_input).val())

    spent = Number @form.find('.expense-spent').val()

    calculated = if total_multiples > 0
                   (spent / total_multiples).toFixed(2)
                 else
                   @EMPTY
    @form.find('.single-price-input').val(calculated)

    @allow_submitting_form()

  allow_submitting_form: =>
    if @form.find('.single-price-input').val() == @EMPTY
      @form.find('[data-action=submit]').attr('disabled', 'disabled')
    else
      @form.find('[data-action=submit]').removeAttr('disabled')
