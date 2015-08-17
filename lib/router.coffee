Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route 'game',
    path: '/game/:_id'
    render: 'game'
    data: ->
      gameKey: @params._id