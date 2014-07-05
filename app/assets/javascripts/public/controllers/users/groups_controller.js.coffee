class Public.Users_GroupsController
  index_action: () ->
    # remove fb auth left location hash
    if window.location.hash == '#_=_'
      window.location.hash = ''

  show_action: ->
    # Search
    $form = $('.filter-expenses')
    $inputs = $form.find('input')

    $inputs.change ->
      $form.submit()

    $form.find('.select2').change ->
      $form.submit()

    # scrolling
    $('#paginator').on 'inview', (e, visible) ->
      return unless visible

      $next_page_link = $('#paginator').find('a')
      if $next_page_link.size() > 0
        $.ajax
          url: $next_page_link.attr('href')
          success: (html) ->
            # allow js actions
            $('body').append(html)
            $('.expenses-table').append($('.expenses-response .expenses').html())
            $('#paginator').html($('.expenses-response .paginator').html())
            $('.expenses-response').remove()
          error: ->
            $('#paginator').remove()
