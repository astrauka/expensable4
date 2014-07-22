class app.FbInvite
  constructor: (@callback_url, @app_id) ->
    FB.init(
      appId: @app_id,
      version: 'v2.0',
      frictionlessRequests: true
    )

  show: =>
    FB.ui(
      {
        method: 'apprequests',
        message: 'Join Expensable',
      },
      @record_sent_invites
    )

  record_sent_invites: (response) =>
    $.ajax(
      type: "POST",
      url: @callback_url,
      data: { ids: response.to, request_id: response.request },
      success: @on_invites_sent_success,
      error: @on_invites_sent_error,
    )

  on_invites_sent_success: (data) =>
    window.location.replace data.redirect_to

  on_invites_sent_error: (data) =>
    # nothing
