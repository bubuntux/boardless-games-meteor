Template.traitor.helpers
  canVote: ->
    (@game.state is TraitorGameState.MISSION_VOTING) or (@me.mission and @game.state is TraitorGameState.ON_MISSION)

  canStartMission: ->
    playersOnMission = _.filter(@players, (player) -> player.mission).length
    playersOnMission is TraitorConstant.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

  playersPerMission: ->
    TraitorConstant.PLAYERS_PER_ROUND[@players.length][@game.rounds.length]

  yesBtnClass: ->
    'active' if @me.secret_vote is true

  noBtnClass: ->
    'active' if @me.secret_vote is false

Template.traitor.events
  'click .btn-start-mission': (event) ->
    event.preventDefault()
    Meteor.call 'startMission'

  'click .btn-vote': (event) ->
    event.preventDefault()
    vote = event.target.classList.contains 'btn-yes'
    Meteor.call 'vote', vote