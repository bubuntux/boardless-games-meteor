Template.traitor.helpers
  canVote: ->
    switch @game.state
      when Games.State.player_selection
        @me.leader #todo player selected
      when Games.State.mission
        @me.mission
      else
        true