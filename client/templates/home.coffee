Template.home.events
  'click .btn-create:not(.disabled)': (event, template) ->
    event.preventDefault()
    userId = Meteor.userId()
    if not userId
      throw new Meteor.Error 500, 'Not logged in'
    gameKey = template.$('[name=gameKey]').val()
    if not gameKey
      gameKey = Random.id(5) #TODO size in base of games
#if Games.find({id: gameKey}, {limit: 1}).count() != 0

  'click .btn-join': (event, template) ->
    event.preventDefault()
