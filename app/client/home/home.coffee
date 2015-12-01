###
Template.home.helpers
  btnCreateClass: ->
    'disabled' if not Meteor.user()

  gameOptions: ->
    games = []
    for id of GAME
      games.push {id, name: GAME[id].name}
    games

Template.home.events
  'click .btn-create:not(.disabled)': (event, template) ->
    event.preventDefault()
    nameInput = template.$('.nameInput').val()
    keyInput = template.$('.keyInput').val()
    Meteor.call 'createGame', nameInput, keyInput, (error, key) ->
      if error
        throw error
      Router.go 'join', gameName: nameInput, gameKey: key

  'click .btn-join:not(.disabled)': (event, template) ->
    event.preventDefault()
    nameInput = template.$('.nameInput').val()
    keyInput = template.$('.keyInput').val()
    if not nameInput or not keyInput
      throw new Meteor.Error 500, 'Invalid game'
    Router.go 'join', gameName: nameInput, gameKey: keyInput

  'keyup .keyInput': (event, template) ->
    event.preventDefault()
    if template.$('.keyInput').val().length is 0
      template.$('.btn-join').addClass('disabled')
    else
      template.$('.btn-join').removeClass('disabled')
###
