Template.player.helpers
  playerClass: ->
    parentData = Template.parentData()
    playerClass = ''
    if parentData.game.state is TraitorGameState.PLAYER_SELECTION and parentData.me.leader
      playerClass = 'btn btn-default btn-player'
      if @mission
        playerClass += ' active'
    if @vote is true
      playerClass += ' text-success'
    if @vote is false
      playerClass += ' text-danger'
    playerClass

Template.player.events
  'click .btn-player': (event) ->
    event.preventDefault()
    mission = not event.target.classList.contains 'active'
    Meteor.call 'mission', @_id, mission