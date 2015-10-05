Router.map ->
  @route 'home',
    path: '/'
    render: 'home'

  @route 'game',
    path: '/:name/:key'
    render: 'game'
    data: ->
      name = @params.name
      key = @params.key
      board: Boards.find(name: name, key: key).fetch()