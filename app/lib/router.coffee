Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route '/:gameName/:gameKey', ->
    @render 'join', data: ->
      board: Boards.findOne(gameName: @params.gameName, gameKey: @params.gameKey)
  , name: 'join'
