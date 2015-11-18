@LoveLetters = new Mongo.Collection('love_letters')
@Guard =
  value: 1, amount: 5, name: "Guard", shortDesc: "Guess a player's hand.", targetRequired: true
@Priest =
  value: 2, amount: 2, name: "Priest", shortDesc: "Look at a hand.", targetRequired: true
@Baron =
  value: 3, amount: 2, name: "Baron", shortDesc: "Compare hands; lower hand is out.", targetRequired: true
@Handmaid =
  value: 4, amount: 2, name: "Handmaid", shortDesc: "Protection until your next turn."
@Prince =
  value: 5, amount: 2, name: "Prince", shortDesc: "One player discards his or her hand.", validOnYourself: true
@King =
  value: 6, amount: 1, name: "King", shortDesc: "Trade hands.", targetRequired: true
@Countess =
  value: 7, amount: 1, name: "Countess", shortDesc: "Discard if caught with King or Prince."
@Princess =
  value: 8, amount: 1, name: "Princess", shortDesc: "Lose if discarded."
@LoveLettersCards = [Guard, Priest, Baron, Handmaid, Prince, King, Countess, Princess]

_allCards = ->
  cards = []
  for card in LoveLettersCards
    _.times(card.amount, -> cards.push(card.value))
  cards

_newGame = (players) ->
  remainCards = _.shuffle _allCards()
  discarded = remainCards.shift()
  order = 0
  for player in _.shuffle players
    player.order = order++
    player.cards = [remainCards.shift()]
    player.playedCards = []
    player.protected = false
    player.see = undefined
    player.dontHave = undefined
    player.winner = false
  _.find(players, (p) -> p.order is 0).cards.push remainCards.shift()
  players: players
  remainCards: remainCards
  discarded: discarded

@LoveLettersDescription =
  name: 'Love Letters'
  minPlayers: 2
  maxPlayers: 4
  initGame: (gameKey, players) ->
    game = _newGame(players)
    _.each(game.players, (p)-> p.rounds = 0)
    LoveLetters.upsert gameKey, $set: game
  data: (gameKey) ->
    LoveLetters.findOne(gameKey)

Meteor.methods
  love_letters_restart: (gameKey, ready) ->
    game = LoveLetters.findOne gameKey
    if not game
      throw new Meteor.Error "Invalid game"
    player = _.find game.players, (p) -> p.id is Meteor.userId()
    if not player
      throw  new Meteor.Error "You are not in this game"
    player.ready = ready
    if _.every(game.players, (p)-> p.ready)
      _.each game.players, (p) -> p.rounds++ if p.winner
      game = _newGame(game.players)
    delete game._id
    LoveLetters.update gameKey, $set: game

  love_letters_play: (gameKey, card, otherPlayerId, guessCard) ->
    check card, Number if card
    check otherPlayerId, String if otherPlayerId
    check guessCard, Number if guessCard
    game = LoveLetters.findOne gameKey
    if not game
      throw new Meteor.Error "Invalid game"
    player = _.find game.players, (p) -> p.cards?.length is 2
    if not player
      throw  new Meteor.Error "WTF??" #TODO
    if player.id isnt Meteor.userId()
      throw new Meteor.Error "not your turn buddy"
    if not _.contains player.cards, card
      throw new Meteor.Error "you don't have that card dumb ass"

    cardObj = _.find(LoveLettersCards, (c) -> c.value is card)
    if cardObj.targetRequired or cardObj.validOnYourself
      otherPlayer = _.find game.players, (p)-> p.id is otherPlayerId
      if not otherPlayer
        throw new Meteor.Error "Invalid target"
      if otherPlayer.cards.length is 0
        throw new Meteor.Error "Invalid target, he already lost"
      if otherPlayer.id is player.id and not cardObj.validOnYourself
        throw new Meteor.Error "You can't play this card on yourself"

    if card is Guard.value and (not guessCard or guessCard <= 0 or guessCard is Guard.value )
      throw new Meteor.Error "Invalid guess Card"

    if _.contains player.cards, Countess.value and card isnt Countess.value
      if _.contains player.cards, King.value or _.contains player.cards, Prince.value
        throw new Meteor.Error "You MUST play the countess"

    player.cards = _.without player.cards, card # TODO lodash alternative?
    player.cards = [card] if player.cards.length is 0
    player.protected = false
    _.each(game.players, (p)->
      p.see = undefined
      p.dontHave = undefined
    ) #TODO improve with unset?
    player.playedCards.push card

    switch card
      when Guard.value
        if not otherPlayer.protected
          if _.contains otherPlayer.cards, guessCard
            otherPlayer.playedCards.push(otherPlayer.cards.pop())
          else
            otherPlayer.dontHave = guessCard
      when Priest.value
        if not otherPlayer.protected
          player.see = otherPlayer.id
      when Baron.value
        if not otherPlayer.protected
          if _.first(player.cards) > _.first(otherPlayer.cards)
            otherPlayer.playedCards.push(otherPlayer.cards.pop())
          else if _.first(otherPlayer.cards) > _.first(player.cards)
            player.playedCards.push(player.cards.pop())
      when Handmaid.value
        player.protected = true
      when Prince.value
        if not otherPlayer.protected
          lastCard = otherPlayer.cards.pop()
          otherPlayer.playedCards.push(lastCard)
          if lastCard isnt Princess.value and game.remainCards.length > 0
            otherPlayer.cards = [game.remainCards.shift()]
      when King.value
        if not otherPlayer.protected
          aux = player.cards
          player.cards = otherPlayer.cards
          otherPlayer.cards = aux
      when Princess.value
        player.playedCards.push(player.cards.pop())

    if game.remainCards.length > 0
      playersWithOneCard = _.filter(game.players, (p)-> p.cards.length is 1)
      if playersWithOneCard.length is 1
        _.first(playersWithOneCard).winner = true
      else
        nextPlayer = _nextPlayer(playersWithOneCard, player.order)
        nextPlayer.cards.push game.remainCards.shift()
    else
      winner = _.max game.players, (p) -> _.first(p.cards)
      if winner
        _.each(game.players, (p) -> p.winner = true if _.first(p.cards) is _.first(winner.cards))
    delete game._id
    LoveLetters.update gameKey, $set: game

_nextPlayer = (players, currentOrder) ->
  nextPlayers = _.filter players, (p)-> p.order > currentOrder
  if nextPlayers?.length > 0
    return _.min nextPlayers, (p)-> p.order
  return _.min players, (p)-> p.order
