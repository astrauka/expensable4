class Public.Users_GroupsController
  index_action: () ->
    # remove fb auth left location hash
    if window.location.hash == "#_=_"
      window.location.hash = ""

