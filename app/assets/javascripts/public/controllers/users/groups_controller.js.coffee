class Public.Users_GroupsController
  index_action: () ->
    # remove fb auth left location hash
    if window.location.hash == '#_=_'
      window.location.hash = ''

  show_action: =>
    @search_expenses()
    @scroll_expenses()
    @balanes_chart()

  search_expenses: =>
    $form = $('.filter-expenses')
    $inputs = $form.find('input')

    $inputs.change ->
      $form.submit()

    $form.find('.select2').change ->
      $form.submit()

  scroll_expenses: =>
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

  balanes_chart: =>
    chart_id = "users_balance_chart"
    $chart_div = $("##{chart_id}")

    if $chart_div.length > 0
      categories = $chart_div.data("categories")
      data = $chart_div.data("data")

      new Highcharts.Chart(
        chart:
          renderTo: chart_id
          type: "bar"
        title:
          text: null
        xAxis:
          categories: categories
        yAxis:
          title:
            text: null
        series: [
          name: null
          data: data
        ]
        credits:
          enabled: false
        legend:
          enabled: false
        tooltip:
          formatter: ->
            if this.y > 0
              "YEY, is ahead by " + Highcharts.numberFormat(this.y, 2)
            else
              "NOOO, is behind by " + Highcharts.numberFormat(-this.y, 2)
      )
