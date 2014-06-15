class Public.Users_Groups_InvitesController
  index_action: ->
    invite = new app.FbInvite(@callback_url(), @fb_app_id())
    @send_invite_on_btn_click(invite)
    @simulate_invite_callback(invite)

  send_invite_on_btn_click: (invite) =>
    $('body').on 'click', "a[data-action='fb-invite']", (e) =>
      e.preventDefault()
      invite.show()
      false

  simulate_invite_callback: (invite) =>
    $('body').on 'click', "a[data-action='simulate-fb-invite']", (e) =>
      e.preventDefault()
      invite.record_sent_invites({ to: "12345", request: "13213" })
      false

  callback_url: =>
    $("a[data-action='fb-invite']").data('callback-url')

  fb_app_id: =>
    $("a[data-action='fb-invite']").data('app-id')
