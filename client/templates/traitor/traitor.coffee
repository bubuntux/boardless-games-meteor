Template.traitor.helpers
  canVote: ->
    (@game.state is TraitorGameState.MISSION_VOTING) or (@me.mission and @game.state is TraitorGameState.ON_MISSION)

  canStartMission: ->
    playersOnMission = _.filter(@players, (player) -> player.mission).length
    playersOnMission is TraitorConstant.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

  playersPerMission: ->
    TraitorConstant.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

Template.traitor.events
  'click .btn-start-mission': (event) ->
    event.preventDefault()
    Meteor.call 'startMission'

  'click .btn-yes': (event) ->
    event.preventDefault()
    Meteor.call 'vote', true

  'click .btn-no': (event) ->
    event.preventDefault()
    Meteor.call 'vote', false