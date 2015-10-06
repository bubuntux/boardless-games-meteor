Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route 'join',
    path: '/:gameName/:gameKey'
    render: 'join'
    data: ->
      board: Boards.find(gameName: @params.gameName, gameKey: @params.gameKey).fetch()