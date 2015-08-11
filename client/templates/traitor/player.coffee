Template.player.helpers
  playerBtnClass: ->
    parentData = Template.parentData()
    if parentData.game.state is TraitorGameState.PLAYER_SELECTION and parentData.me.leader
      'btn btn-default btn-player' + (if @mission then ' active' else '')

Template.player.events
  'click .btn-player': (event) ->
    event.preventDefault()
    Meteor.call 'mission', @_id